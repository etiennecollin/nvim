-- Vertically center document when entering insert mode
vim.cmd("autocmd InsertEnter * norm zz")

-- Remove trailing whitespace on save
vim.cmd("autocmd BufWritePre, FileWritePre * :%s/\\s\\+$//e")

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
	pattern = { "javascript", "javascriptreact", "typst", "markdown", "json", "jsonc", "lua" },
	callback = function()
		vim.opt_local.tabstop = 2
	end,
})
