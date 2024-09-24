local lazy = vim.api.nvim_create_augroup("lazy", {})

-- Lazy load plugin on specific file extension
vim.api.nvim_create_autocmd("UIEnter", {
	group = lazy,
	pattern = { "*.gpg", "*.pgp", "*.asc" },
	callback = function()
		require("lazy").load({ plugins = { "vim-gnupg" } })
	end,
})

-- Vertically center document when entering insert mode
vim.cmd("autocmd InsertEnter * norm zz")

-- Remove trailing whitespace on save
vim.cmd("autocmd BufWritePre, FileWritePre * :%s/\\s\\+$//e")

-- Floating linting messages on cursor hold and disable virtual text
vim.cmd([[au CursorHold * lua vim.diagnostic.open_float(0,{scope = "cursor"})]])

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("etiennecollin-highlight-yank", { clear = true }),
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Modify the tabstop setting for certain filetypes
local augroup_indent = vim.api.nvim_create_augroup("etiennecollin-filetype-indent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = augroup_indent,
	pattern = { "javascript", "javascriptreact" },
	callback = function()
		vim.opt_local.tabstop = 2
	end,
})
