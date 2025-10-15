--[[
    Lua Module Documentation

    This Lua module provides the configuration settings for the Neovim config.

    Usage:
    local config = require("etiennecollin.core.config")

    @module etiennecollin.core.config
]]
local M = {}

--- The colorscheme to use
M.colorscheme = "rose-pine"

--- The default colorscheme to use if the specified colorscheme is not available
M.colorscheme_fallback = "retrobox"

--- The background style
--- Either "light" or "dark"
M.background_style = "dark"

--- The Treesitter languages to be installed.
M.ensure_installed_treesitter = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline", "comment" }

--- The LSPs to be installed by Mason.
M.ensure_installed_lsps = { "lua_ls", "clangd", "basedpyright", "bashls", "jdtls", "tinymist", "ts_ls", "neocmake" }

--- The Linters to be installed by Mason.
M.ensure_installed_linters = {
  javascript = { "oxlint" },
  typescript = { "oxlint" },
}

--- The Formatters to be installed by Mason.
M.ensure_installed_formatters = {
  lua = { "stylua" },
  python = { "isort", "black" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  zsh = { "shfmt" },
  c = { "clang-format" },
  cpp = { "clang-format" },
  java = { "google-java-format" },
  typst = { "typstyle" },
  javascript = { "prettier" },
  typescript = { "prettier" },
  javascriptreact = { "prettier" },
  typescriptreact = { "prettier" },
  svelte = { "prettier" },
  tex = { "latexindent" },
  css = { "prettier" },
  html = { "prettier" },
  json = { "prettier" },
  jsonc = { "prettier" },
  yaml = { "prettier" },
  markdown = { "prettier" },
  graphql = { "prettier" },
  sql = { "sql_formatter" },
}

--- The DAPs to be installed by Mason.
M.ensure_installed_daps = { "codelldb", "cpptools" }

--- Decrease tabstop for certain filetypes
M.reduced_tabstop = {
  "fpp",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "plantuml",
  "sh",
  "typescriptreact",
  "typst",
}

return M
