vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("etiennecollin-trailing-whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  desc = "Remove trailing whitespace on save.",
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("etiennecollin-auto-create-dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create directory when saving a file, in case some intermediate directory does not exist.",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("etiennecollin-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
  desc = "Highlight on yank.",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("etiennecollin-filetype-indent", { clear = true }),
  pattern = require("etiennecollin.config").reduced_tabstop,
  callback = function()
    vim.opt_local.tabstop = 2
  end,
  desc = "Decrease tabstop for certain filetypes.",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("etiennecollin-filetype-keybinds", { clear = true }),
  callback = require("etiennecollin.core.mappings.plugin").language_specific,
  desc = "Set keybinds when filetype changes.",
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
  desc = "Enable inlay hints if the server supports them.",
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

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("etiennecollin-restore-cursor", { clear = true }),
  callback = function(args)
    local exclude = { "gitcommit" }
    if vim.tbl_contains(exclude, vim.bo[args.buf].filetype) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        if vim.api.nvim_get_mode().mode ~= "t" then
          vim.cmd("normal! zz")
        end
      end)
    end
  end,
  desc = "Restore cursor to file position in previous editing session.",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("etiennecollin-resize", { clear = true }),
  command = "tabdo wincmd =",
  desc = "Resize all windows to fit the current tab.",
})

local group_recording = vim.api.nvim_create_augroup("etiennecollin-macro-recording", { clear = true })
vim.api.nvim_create_autocmd("RecordingEnter", {
  group = group_recording,
  callback = function()
    vim.notify("Recording macro...")
  end,
  desc = "Notify when macro recording starts.",
})
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = group_recording,
  callback = function()
    vim.notify("Done recording macro")
  end,
  desc = "Notify when macro recording is done.",
})

local group_cursorline = vim.api.nvim_create_augroup("etiennecollin-cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = group_cursorline,
  callback = function()
    vim.opt_local.cursorline = true
  end,
  desc = "Show cursorline in active window.",
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = group_cursorline,
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Hide cursorline in inactive window.",
})

local group_insert_mode_perf = vim.api.nvim_create_augroup("etiennecollin-insert-mode-perf", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group_insert_mode_perf,
  callback = function()
    vim.diagnostic.enable(false)
    vim.opt.cursorline = false
    vim.opt_local.cursorlineopt = "number"
  end,
  desc = "Apply UI tweaks for insert mode.",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group_insert_mode_perf,
  callback = function()
    vim.diagnostic.enable(true)
    vim.opt_local.cursorline = true
    vim.opt_local.cursorlineopt = "both"
  end,
  desc = "Revert UI tweaks for insert mode.",
})
