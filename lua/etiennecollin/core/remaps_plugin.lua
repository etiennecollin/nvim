-- ToggleTerm
vim.keymap.set({ "n", "i", "v", "t" }, "<S-F1>", "<cmd>ToggleTermToggleAll<cr>", {
	desc = "Toggle terminal",
})

-- SnipRun commands
vim.keymap.set({ "n", "v" }, "<leader>rr", "<plug>SnipRun", { silent = true, desc = "Run code snippet" })
vim.keymap.set("n", "<leader>ro", "<plug>SnipRunOperator", { silent = true, desc = "Run code snippet with operator" })

-- NerdCommenter
vim.keymap.set("v", "<leader>cc", "<plug>NERDCommenterToggle", { desc = "Toggle commenting" })

-- These functions create mappings that are only loaded when the plugin is loaded
-- This is done by calling the function in its corresponding plugin config
local M = {}

function M.markdown_remaps()
	vim.keymap.set("n", "<leader>m", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })
end

function M.ufo_remaps()
	local ufo = require("ufo")

	vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
	vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
end

function M.rust_remaps(_, bufnr)
	local rust_tools = require("rust-tools")
	local opts = {
		silent = true,
		buffer = bufnr,
	}

	opts.desc = "Rust Tools hover actions"
	vim.keymap.set("n", "<leader>ca", rust_tools.hover_actions.hover_actions, opts)

	opts.desc = "Rust Tools code actions"
	vim.keymap.set("n", "<Leader>rc", rust_tools.code_action_group.code_action_group, opts)
end

function M.lsp_remaps(_, bufnr)
	-- Setup lspconfig
	local opts = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}

	-- Show definition, references
	opts.desc = "Show LSP references"
	vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

	-- Go to declaration
	opts.desc = "Go to declaration"
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	-- Show lsp definitions
	opts.desc = "Show LSP definitions"
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

	-- Show lsp implementations
	opts.desc = "Show LSP implementations"
	vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	-- Show lsp type definitions
	opts.desc = "Show LSP type definitions"
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	-- See available code actions, in visual mode will apply to selection
	opts.desc = "See available code actions"
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	-- Smart rename
	opts.desc = "Smart rename"
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	-- Show  diagnostics for file
	opts.desc = "Show buffer diagnostics"
	vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

	-- Show diagnostics for line
	opts.desc = "Show line diagnostics"
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

	-- Jump to previous diagnostic in buffer
	opts.desc = "Go to previous diagnostic"
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

	-- Jump to next diagnostic in buffer
	opts.desc = "Go to next diagnostic"
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	-- Show documentation for what is under cursor
	opts.desc = "Show documentation for what is under cursor"
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	-- Mapping to restart lsp if necessary
	opts.desc = "Restart LSP"
	vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
end

return M
