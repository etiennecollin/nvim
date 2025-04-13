--[[
    Lua Module Documentation

    This Lua module provides configurations for LSPs.

    Usage:
    local servers = require("etiennecollin.plugins.lsp.configs")

    @module etiennecollin.plugins.lsp.configs
]]
local M = {}

function M.basedpyright()
	vim.lsp.config("basedpyright", {
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
	})
end

function M.clangd()
	vim.lsp.config("clangd", {
		cmd = {
			"clangd",
			"--fallback-style=Google",
			"--offset-encoding=utf-16",
		},
	})
end

function M.jdtls()
	vim.lsp.config("jdtls", {
		root_dir = require("lspconfig").util.root_pattern(
			"build.xml", -- Ant
			"pom.xml", -- Maven
			".git",
			".java_project",
			"build.gradle",
			"settings.gradle", -- Gradle
			"settings.gradle.kts" -- Gradle
		) or vim.fn.getcwd(),
	})
end

function M.lua_ls()
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "Snacks" },
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

function M.marksman()
	vim.lsp.config("marksman", {
		filetypes = { "markdown", "markdown.mdx", "quarto" },
		root_dir = require("lspconfig").util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
	})
end

function M.pylsp()
	vim.lsp.config("pylsp", {
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
	})
end

function M.tailwindcss()
	vim.lsp.config("tailwindcss", {
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
	})
end

function M.tinymist()
	vim.lsp.config("tinymist", {
		settings = {
			exportPdf = "never", -- Choose onType, onSave or never.
		},
		root_dir = function()
			return os.getenv("HOME")
		end,
	})
end

return M
