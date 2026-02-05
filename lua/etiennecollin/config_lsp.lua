--[[
    Lua Module Documentation

    This Lua module provides configurations for LSPs.

    Usage:
    local servers = require("etiennecollin.plugins.lsp.configs")

    @module etiennecollin.plugins.lsp.configs
]]

---@type table<string, vim.lsp.Config>
local M = {}

---@type vim.lsp.Config
M.basedpyright = {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      typeCheckingMode = "standard",
      analysis = {
        inlayHints = {
          callArgumentNames = "all",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
        autoFormatStrings = true,
      },
      linting = { enabled = true },
    },
  },
}

---@type vim.lsp.Config
M.clangd = {
  cmd = {
    "clangd",
    "--fallback-style=Google",
    "--offset-encoding=utf-16",
  },
}

---@type vim.lsp.Config
M.jdtls = {
  root_dir = require("lspconfig").util.root_pattern(
    "build.xml", -- Ant
    "pom.xml", -- Maven
    ".git",
    ".java_project",
    "build.gradle",
    "settings.gradle", -- Gradle
    "settings.gradle.kts" -- Gradle
  ) or vim.fn.getcwd(),
}

---@type vim.lsp.Config
M.lua_ls = {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = {
        globals = { "vim", "Snacks", "Obsidian" },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

---@type vim.lsp.Config
M.marksman = {
  filetypes = { "markdown", "markdown.mdx", "quarto" },
  root_dir = require("lspconfig").util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
}

---@type vim.lsp.Config
M.pylsp = {
  settings = {
    pylsp = {
      configurationSources = "null",
      plugins = {
        autopep8 = {
          enabled = false,
        },
        pycodestyle = {
          enabled = false,
        },
      },
    },
  },
}

---@type vim.lsp.Config
M.tailwindcss = {
  filetypes = {
    "css",
    "scss",
    "sass",
    "postcss",
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "svelte",
    "vue",
    -- "rust",
  },
  init_options = {
    -- Set languages to be considered as different ones by lsp
    userLanguages = {
      rust = "html",
    },
  },
}

---@type vim.lsp.Config
M.tinymist = {
  settings = {
    exportPdf = "never", -- Choose onType, onSave or never.
  },
  root_dir = os.getenv("HOME"),
}

M.harper_ls = {
  filetypes = { "markdown" },
}

return M
