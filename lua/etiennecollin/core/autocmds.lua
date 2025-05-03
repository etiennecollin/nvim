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

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("etiennecollin-hold-diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			scope = "cursor",
			close_events = { "BufLeave", "CursorMoved", "ModeChanged", "FocusLost" },
		})
	end,
	desc = "Show diagnostics on cursor hold",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("etiennecollin-filetype-indent", { clear = true }),
	pattern = require("etiennecollin.config").reduced_tabstop,
	callback = function()
		vim.opt_local.tabstop = 2
	end,
	desc = "Decrease tabstop for certain filetypes",
})

-- After creating the autocmdh we run the function manually for the first time.
-- This is necessary to run when opening file with `nvim file.ext`.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("etiennecollin-filetype-keybinds", { clear = true }),
	callback = require("etiennecollin.core.mappings.plugin").language_specific,
	desc = "Set keybinds when filetype changes",
})
require("etiennecollin.core.mappings.plugin").language_specific()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("etiennecollin-lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
			vim.keymap.set("n", "<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { buffer = event.buf, desc = "LSP: Inlay Hints" })
		end
	end,
	desc = "Enable inlay hints if the server supports them",
})

-- https://www.reddit.com/r/neovim/comments/10383z1/open_help_in_buffer_instead_of_split/
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("etiennecollin-help", { clear = true }),
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

-- https://github.com/mcauley-penney/nvim/
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("etiennecollin-foldmethod", { clear = true }),
	pattern = "*",
	callback = function()
		local ok, parser = pcall(vim.treesitter.get_parser)
		if ok and parser then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		else
			vim.opt_local.foldmethod = "indent"
		end
	end,
	desc = "Set foldmethod to treesitter or indent based on filetype",
})

-- https://github.com/mcauley-penney/nvim/
vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("etiennecollin-scrolloff", { clear = true }),
	callback = function()
		local win_h = vim.api.nvim_win_get_height(0) -- Height of window
		local off = math.min(vim.o.scrolloff, math.floor(win_h / 2)) -- Scroll offset
		local dist = vim.fn.line("$") - vim.fn.line(".") -- Distance from current line to last line
		local rem = vim.fn.line("w$") - vim.fn.line("w0") + 1 -- Num visible lines in current window

		if dist < off and win_h - rem + dist < off then
			local view = vim.fn.winsaveview()
			view.topline = view.topline + off - (win_h - rem + dist)
			vim.fn.winrestview(view)
		end
	end,
	desc = "When at EOB, bring the current line towards center screen",
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
