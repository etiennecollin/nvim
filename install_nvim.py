#!/usr/bin/env python3
"""Install or remove a user-local Neovim release; uses only Python's standard library."""

import argparse
import fnmatch
import os
import platform
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from argparse import Namespace
from pathlib import Path
from typing import Optional

API = "https://api.github.com/repos/neovim/neovim/releases"
RELEASES = "https://github.com/neovim/neovim/releases"
VERSION = re.compile(r"v?[0-9]+\.[0-9]+\.[0-9]+(?:[-+][A-Za-z0-9.+-]+)?\Z")
HEADERS = {"User-Agent": "install-nvim.py"}

NVIM_INSTALL_PREFIX = "nvim-managed-"
NVIM_INSTALL_GLOB = f"{NVIM_INSTALL_PREFIX}v[0-9]*"
NVIM_INSTALL_BACKUP_PREFIX = ".nvim-backup."
NVIM_INSTALL_STAGING_PREFIX = ".nvim-staging."


def get_os_arch() -> tuple[str, str]:
    # Map platform.system() and platform.machine() values to the naming convention used for Neovim releases.
    # For example, the macOS ARM64 release is named `nvim-macos-arm64.tar.gz`.
    os_name = {
        "Linux": "linux",
        "Darwin": "macos",
    }.get(platform.system())

    arch = {
        "x86_64": "x86_64",
        "aarch64": "arm64",
        "arm64": "arm64",
    }.get(platform.machine())

    if not os_name or not arch:
        raise RuntimeError(f"Unsupported platform: {platform.system()}/{platform.machine()}")

    return os_name, arch


def exists(path: Path) -> bool:
    return os.path.lexists(path)


def remove(path: Path, ignore_errors: bool = False) -> None:
    # Remove a symlink or a file
    if path.is_symlink() or (exists(path) and not path.is_dir()):
        path.unlink()
    elif path.is_dir():
        shutil.rmtree(path, ignore_errors=ignore_errors)


def nvim_version(binary: Path) -> Optional[str]:
    # Get nvim version from a nvim binary
    try:
        p = subprocess.run([str(binary), "--version"], capture_output=True, text=True, timeout=15)
        line = p.stdout.splitlines()[0]
        return line[5:] if p.returncode == 0 and line.startswith("NVIM ") else None
    except (OSError, subprocess.SubprocessError, IndexError):
        return None


def get_tag(version: str) -> str:
    # If a version was specified, we get it directly
    if version:
        tag = version if version.startswith("v") else f"v{version}"
        url = f"{API}/tags/{urllib.parse.quote(tag, safe='v.+-')}"

        # Make sure the requested version is available
        print(f"Checking release {tag}...")
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=HEADERS), timeout=30):
                return tag
        except urllib.error.HTTPError as e:
            if e.code == 404:
                raise RuntimeError(f"Release {tag} does not exist") from e
            raise RuntimeError(f"Could not verify release {tag} (HTTP {e.code})") from e

    # Fetch tag from latest release
    print("Checking latest Neovim release...")
    req = urllib.request.Request(f"{RELEASES}/latest", headers=HEADERS, method="HEAD")
    with urllib.request.urlopen(req, timeout=60) as response:
        tag = response.geturl().rstrip("/").rsplit("/", 1)[-1]

    # Make sure tag is formatted properly
    if not VERSION.fullmatch(tag):
        raise RuntimeError(f"Invalid latest release tag: {tag}")

    return tag


def atomic_symlink(link: Path, target: Path) -> None:
    # Get a unique filename
    fd, name = tempfile.mkstemp(prefix=".nvim-link.", dir=link.parent)
    os.close(fd)
    os.unlink(name)

    # Create the symlink with that name
    try:
        os.symlink(target, name)
        os.replace(name, link)
    finally:
        if os.path.lexists(name):
            os.unlink(name)


def uninstall(base: Path, link: Path) -> None:
    patterns = (
        NVIM_INSTALL_GLOB,
        f"{NVIM_INSTALL_BACKUP_PREFIX}*",
        f"{NVIM_INSTALL_STAGING_PREFIX}*",
    )
    removed = False

    print("Removing managed Neovim installations...")

    # Remove install directories
    for pattern in patterns:
        for path in base.glob(pattern):
            remove(path)
            print(f"Removed {path.name}")
            removed = True

    # Remove symlink
    if link.is_symlink():
        target = os.readlink(link)
        managed = fnmatch.fnmatchcase(target, str(base / NVIM_INSTALL_GLOB / "bin/nvim"))

        # Make sure it's a directory we created in the past
        if managed:
            link.unlink()
            print(f"Removed {link}")
            removed = True
        else:
            print(f"Preserving unmanaged symlink: {link} -> {target}")
    elif exists(link):
        print(f"Preserving {link}: it is not a symlink")
    print("Uninstall complete." if removed else "No managed Neovim installations found.")


def prune(base: Path, target: Path, force: bool) -> None:
    # Get all previous installs of nvim
    old = [p for p in sorted(base.glob(NVIM_INSTALL_GLOB)) if p.is_dir() and not p.is_symlink() and p != target]
    if not old:
        return
    print("Other managed versions: " + ", ".join(p.name for p in old))

    try:
        answer = "y" if force else input("Delete them? [y/N] ".strip()) if sys.stdin.isatty() else ""
    except EOFError:
        answer = ""

    if force or answer.lower() == "y":
        for path in old:
            remove(path)
            print(f"Removed {path.name}")
    else:
        print("Keeping other versions; use --prune to delete them.")


def download_neovim(tag: str, destination: Path):
    os_name, arch = get_os_arch()
    root = f"nvim-{os_name}-{arch}"
    archive = destination / f"{root}.tar.gz"
    url = f"{RELEASES}/download/{tag}/{root}.tar.gz"

    print(f"Downloading Neovim {tag}...")

    # Download
    with urllib.request.urlopen(urllib.request.Request(url, headers=HEADERS), timeout=300) as src:
        with archive.open("wb") as dst:
            shutil.copyfileobj(src, dst)

    # Extract
    with tarfile.open(archive, "r:gz") as tar:
        tar.extractall(destination, filter="data")

    # Validate
    staging = destination / root
    binary = staging / "bin/nvim"
    if not binary.is_file() or not os.access(binary, os.X_OK) or nvim_version(binary) != tag:
        raise RuntimeError(f"Downloaded archive is not a valid Neovim {tag} release")

    return staging


def install(args: Namespace, home: Path):
    base, bindir = home / ".local/opt", home / ".local/bin"
    link = bindir / "nvim"
    base.mkdir(parents=True, exist_ok=True)
    bindir.mkdir(parents=True, exist_ok=True)

    # Do not overwrite an existing binary with a symlink
    if exists(link) and not link.is_symlink():
        raise RuntimeError(f"{link} exists and is not a symlink; move it aside first")

    # Get properly formatted tag and check whether requested version is valid
    tag = get_tag(args.version)
    target = base / f"{NVIM_INSTALL_PREFIX}{tag}"
    print(f"Target release: {tag}")

    # Check if requested version is already installed
    is_download_needed = True
    if exists(target) and not args.force:
        if target.is_dir() and not target.is_symlink() and nvim_version(target / "bin/nvim") == tag:
            print(f"Neovim {tag} is already installed.")
            is_download_needed = False
        else:
            # Matching install directory exists but doesn't contain a valid nvim executable
            raise RuntimeError(f"Invalid target: {target}; use --force to replace it")

    temp = backup = None
    is_created = is_modified = is_install_valid = False
    old_link = Path(os.readlink(link)) if link.is_symlink() else None

    try:
        if is_download_needed:
            # Download nvim to a temp staging directory
            temp = Path(tempfile.mkdtemp(prefix=NVIM_INSTALL_STAGING_PREFIX, dir=base))
            staging = download_neovim(tag, temp)

            # Take a backup of the existing install
            if exists(target):
                backup = base / f"{NVIM_INSTALL_BACKUP_PREFIX}{os.getpid()}"
                if exists(backup):
                    raise RuntimeError(f"Backup already exists: {backup}")
                os.replace(target, backup)

            # Move staging directory to target
            os.replace(staging, target)
            is_created = True
            print(f"Installed Neovim {tag} in {target}")

        # Add `nvim` symlink to new install
        atomic_symlink(link, target / "bin/nvim")
        is_modified = True

        # Check that downloaded nvim version is active
        active = nvim_version(link)
        if active != tag:
            raise RuntimeError(f"Active version mismatch: expected {tag}, got {active or 'unknown'}")

        is_install_valid = True
        print(f"Active version: NVIM {active}")

        if backup and exists(backup):
            remove(backup)

        prune(base, target, args.prune)
        print("Done.")

    except Exception:
        pass
    finally:
        # Cleanup invalid install
        if not is_install_valid:
            if is_modified:
                if old_link is None:
                    remove(link)
                else:
                    atomic_symlink(link, old_link)

            # Delete downloaded content and restore backup if it exists
            if backup and exists(backup):
                if exists(target):
                    remove(target)
                os.replace(backup, target)
            elif is_created and exists(target):
                remove(target)

        # Remove temp directory
        if temp and exists(temp):
            remove(temp, True)


def main():
    parser = argparse.ArgumentParser(description="Install and manage a user-local Neovim release.")
    parser.add_argument("--version", "--tag", metavar="TAG")
    parser.add_argument("--force", action="store_true", help="replace an existing release")
    parser.add_argument("--prune", action="store_true", help="delete other versions without prompting")
    parser.add_argument("--uninstall", action="store_true", help="remove managed installations")
    args = parser.parse_args()

    if args.version and not VERSION.fullmatch(args.version):
        parser.error("invalid release tag; expected a version such as v0.11.5")

    if args.uninstall and (args.version or args.force or args.prune):
        parser.error("--uninstall cannot be combined with --version, --force, or --prune")

    try:
        home = Path.home()
        if args.uninstall:
            uninstall(home / ".local/opt", home / ".local/bin/nvim")
        else:
            install(args, home)
    except (OSError, RuntimeError, tarfile.TarError, urllib.error.URLError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("Interrupted.", file=sys.stderr)
        return 130
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
