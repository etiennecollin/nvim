vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("etiennecollin-trailing-whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  desc = "Remove trailing whitespace on save.",
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

local group_conflict = vim.api.nvim_create_augroup("etiennecollin-git-conflicts", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group_conflict,
  pattern = "GitConflictDetected",
  callback = function(event)
    local buf_name = vim.api.nvim_buf_get_name(event.buf)
    vim.notify("Conflict detected in " .. buf_name)
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = group_conflict,
  pattern = "GitConflictResolved",
  callback = function(event)
    local buf_name = vim.api.nvim_buf_get_name(event.buf)
    vim.notify("Conflicts resolved in " .. buf_name)
  end,
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
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
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

-- -- https://github.com/mcauley-penney/nvim/
-- vim.api.nvim_create_autocmd({ "WinScrolled", "WinResized", "VimResized" }, {
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
--   desc = "Always respect scrolloff.",
-- })

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
vim.api.nvim_create_autocmd("CmdLineEnter", {
  group = group_cursorline,
  callback = function()
    vim.opt.cursorlineopt = "both"
  end,
  desc = "When entering command-line , highlight both number and screenline.",
})
vim.api.nvim_create_autocmd("CmdLineLeave", {
  group = group_cursorline,
  callback = function()
    vim.opt.cursorlineopt = "number"
  end,
  desc = "When leaving command-line, revert cursorline highlight to just number.",
})

local group_insert_indent = vim.api.nvim_create_augroup("etiennecollin-insert-indent", { clear = true })
local function apply_ts_indent_if_blank(buf, lnum)
  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
  if line ~= "" then
    return false
  end

  -- Check if indentexpr is set before evaluating
  local indentexpr = vim.bo.indentexpr
  if indentexpr == "" or indentexpr == nil then
    return false
  end

  -- Get indent from indentexpr (Tree-sitter or fallback)
  local old_lnum = vim.v.lnum
  vim.v.lnum = lnum
  local indent = vim.fn.eval(vim.bo.indentexpr)
  vim.v.lnum = old_lnum
  if indent > 0 then
    vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { string.rep(" ", indent) })
  end
  return true
end
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group_insert_indent,
  callback = function()
    -- Get current line
    local buf = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1]

    -- Apply indentation
    if apply_ts_indent_if_blank(buf, lnum) then
      -- Go to end of line
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, false, true), "n", true)
    end
  end,
  desc = "Apply indent on InsertLeave",
})
vim.api.nvim_create_autocmd("CursorMovedI", {
  group = group_insert_indent,
  callback = function()
    -- Store the line we're leaving
    local buf = vim.api.nvim_get_current_buf()
    local prev_line = vim.b.previous_insert_line or 0
    local current_line = vim.api.nvim_win_get_cursor(0)[1]

    -- If moved, restore on previous line
    if prev_line ~= current_line and prev_line > 0 then
      local _ = apply_ts_indent_if_blank(buf, prev_line)
    end

    -- store current line for future
    vim.b.previous_insert_line = current_line
  end,
  desc = "Apply indent in insert cursor move",
})
