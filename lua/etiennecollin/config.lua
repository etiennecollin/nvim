--[[
    Lua Module Documentation

    This Lua module provides the configuration settings for the Neovim config.

    Usage:
    local config = require("etiennecollin.core.config")

    @module etiennecollin.core.config
]]
local M = {}

--- The default theme to use
M.default_colorscheme = "tokyonight"

--- The background style
--- Either "light" or "dark"
M.background_style = "dark"

--- The Treesitter languages to be installed.
M.ensure_installed_treesitter = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline", "comment" }

--- The LSPs to be installed by Mason.
M.ensure_installed_lsps =
	{ "lua_ls", "rust_analyzer", "zls", "clangd", "basedpyright", "jdtls", "tinymist", "tailwindcss", "ts_ls" }

--- The Linters to be installed by Mason.
M.ensure_installed_linters = {
	c = { "trivy", "cpplint" },
	cpp = { "trivy", "cpplint" },
	rust = { "trivy" },
	python = { "trivy" },
	java = { "trivy" },
	javascript = { "trivy", "oxlint" },
	typescript = { "trivy", "oxlint" },
}

--- The Formatters to be installed by Mason.
M.ensure_installed_formatters = {
	lua = { "stylua" },
	python = { "isort", "black" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	zsh = { "shfmt" },
	c = { "clang_format" },
	cpp = { "clang_format" },
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
}

--- The DAPs to be installed by Mason.
M.ensure_installed_daps = { "codelldb" }

--- Decrease tabstop for certain filetypes
M.reduced_tabstop = { "javascript", "javascriptreact", "typst", "markdown", "json", "jsonc", "lua" }

return M
