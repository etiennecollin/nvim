vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		vim.cmd("norm zz")
	end,
	desc = "Vertically center document when entering insert mode",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("etiennecollin-trailing-whitespace", { clear = true }),
	pattern = "*",
	callback = function()
		vim.cmd([[%s/\s\+$//e]])
	end,
	desc = "Remove trailing whitespace on save",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("etiennecollin-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight when yanking (copying) text",
})

local augroup_indent = vim.api.nvim_create_augroup("etiennecollin-filetype-indent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = augroup_indent,
	pattern = { "javascript", "javascriptreact", "typst", "markdown", "json", "jsonc", "lua" },
	callback = function()
		vim.opt_local.tabstop = 2
	end,
	desc = "Set tabstop to 2 spaces for certain filetypes",
})

-- https://www.reddit.com/r/neovim/comments/10383z1/open_help_in_buffer_instead_of_split/
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function(event)
		if vim.bo[event.buf].filetype == "help" then
			vim.opt_local.colorcolumn = ""
			vim.opt_local.concealcursor = "nc"

			vim.cmd.only()
			vim.bo[event.buf].buflisted = true
		end
	end,
	desc = "Open help pages in a listed buffer in the current window.",
})

-- local function commit_on_save()
-- 	-- Check if the file is in a git repository
-- 	if vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") ~= "" then
-- 		-- Add the current file to the staging area
-- 		vim.fn.system("git add " .. vim.fn.expand("%:p"))
--
-- 		-- Commit the file with a generic message
-- 		vim.fn.system('git commit -q -m "squash! $(git log -1 --format=%H)"')
-- 	end
-- end
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = "*",
-- 	callback = commit_on_save,
-- })
