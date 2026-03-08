#!/usr/bin/env bash
set -euo pipefail

# --- Platform assertion ---
OS="$(uname -s)"
ARCH="$(uname -m)"
NVIM_ARCH=""

if [[ "${OS}" != "Linux" ]]; then
  echo "Error: This installer supports Linux only (detected: ${OS})."
  exit 1
fi

case "${ARCH}" in
x86_64)
  NVIM_ARCH="x86_64"
  ;;
aarch64 | arm64)
  NVIM_ARCH="arm64"
  ;;
*)
  echo "Error: Unsupported architecture: ${ARCH} (supported: x86_64, arm64/aarch64)"
  exit 1
  ;;
esac

echo "Detected architecture: ${NVIM_ARCH}"

# --------------------------

URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
INSTALL_BASE="${HOME}/.local/opt"
BIN_DIR="${HOME}/.local/bin"
BIN_NAME="nvim-linux-${NVIM_ARCH}"

mkdir -p "${INSTALL_BASE}" "${BIN_DIR}"

echo "Downloading and extracting latest Neovim..."
rm -rf "${INSTALL_BASE}/${BIN_NAME}"
curl -L "${URL}" | tar -xz -C "${INSTALL_BASE}"

STAGING_DIR="${INSTALL_BASE}/${BIN_NAME}"

if [[ ! -x "${STAGING_DIR}/bin/nvim" ]]; then
  echo "Extraction failed: nvim binary not found."
  exit 1
fi

VERSION="$("${STAGING_DIR}/bin/nvim" --version | head -n1 | awk '{print $2}')"
TARGET_DIR="${INSTALL_BASE}/nvim-${VERSION}"

if [[ -d "${TARGET_DIR}" ]]; then
  echo "Neovim ${VERSION} is already installed."
  rm -rf "${STAGING_DIR}"
else
  echo "Installing Neovim ${VERSION} → ${TARGET_DIR}"
  mv "${STAGING_DIR}" "${TARGET_DIR}"
fi

ln -sfn "${TARGET_DIR}/bin/nvim" "${BIN_DIR}/nvim"

echo
echo "Active version:"
"${BIN_DIR}/nvim" --version | head -n1
echo

# Detect older versions
mapfile -t installed < <(find "${INSTALL_BASE}" -maxdepth 1 -type d -name 'nvim-*' | sort)

older=()
for dir in "${installed[@]}"; do
  if [[ "${dir}" != "${TARGET_DIR}" ]]; then
    older+=("${dir}")
  fi
done

if ((${#older[@]} > 0)); then
  echo "Older Neovim versions detected:"
  for d in "${older[@]}"; do
    echo "  - $(basename "${d}")"
  done
  echo
  read -rp "Delete older versions? [y/N] " answer
  if [[ "${answer}" =~ ^[Yy]$ ]]; then
    for d in "${older[@]}"; do
      rm -rf "${d}"
      echo "Removed $(basename "${d}")"
    done
  else
    echo "Older versions kept."
  fi
fi

echo "Done."
