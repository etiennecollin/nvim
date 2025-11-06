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
    vim.hl.on_yank()
  end,
  desc = "Highlight on yank",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("etiennecollin-filetype-indent", { clear = true }),
  pattern = require("etiennecollin.config").reduced_tabstop,
  callback = function()
    vim.opt_local.tabstop = 2
  end,
  desc = "Decrease tabstop for certain filetypes",
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("etiennecollin-git-conflicts", { clear = true }),
  pattern = "GitConflictDetected",
  callback = function()
    vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
    vim.keymap.set("n", "cww", function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("etiennecollin-filetype-keybinds", { clear = true }),
  callback = require("etiennecollin.core.mappings.plugin").language_specific,
  desc = "Set keybinds when filetype changes",
})
-- After creating the autocmd we run the function manually for the first time.
-- This is necessary to run when opening file with `nvim file.ext`.
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

-- -- https://github.com/mcauley-penney/nvim/
-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "CursorHoldI" }, {
--   group = vim.api.nvim_create_augroup("etiennecollin-scrolloff", { clear = true }),
--   callback = function()
--     local win_h = vim.api.nvim_win_get_height(0) -- Height of window
--     local off = math.min(vim.o.scrolloff, math.floor(win_h / 2)) -- Scroll offset
--     local dist = vim.fn.line("$") - vim.fn.line(".") -- Distance from current line to last line
--     local rem = vim.fn.line("w$") - vim.fn.line("w0") + 1 -- Num visible lines in current window
--
--     if dist < off and win_h - rem + dist < off then
--       local view = vim.fn.winsaveview()
--       view.topline = view.topline + off - (win_h - rem + dist)
--       vim.fn.winrestview(view)
--     end
--   end,
--   desc = "Always respect scrolloff",
-- })

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("etiennecollin-resize", { clear = true }),
  command = "tabdo wincmd =",
  desc = "Resize all windows to fit the current tab",
})

local group_recording = vim.api.nvim_create_augroup("etiennecollin-recording", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = group_recording,
  callback = function()
    vim.o.cmdheight = 1
  end,
  desc = "Set cmdheight to 1 when recording starts",
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = group_recording,
  callback = function()
    vim.o.cmdheight = 0
  end,
  desc = "Reset cmdheight to 0 when recording stops",
})
