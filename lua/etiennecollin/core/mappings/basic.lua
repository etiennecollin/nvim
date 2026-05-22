vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap F1 which is used for ghostty's quick term
vim.keymap.set({ "n", "i", "v", "t" }, "<F1>", "")

-- Move up/down selected lines
vim.keymap.set("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<a-j>", ":<C-u>execute \"'<,'>silent move '>+\" . v:count1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<a-k>", ":<C-u>execute \"'<,'>silent move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("n", "<a-down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<a-up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<a-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<a-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<a-down>", ":<C-u>execute \"'<,'>silent move '>+\" . v:count1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<a-up>", ":<C-u>execute \"'<,'>silent move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Move to beginning/end of line
vim.keymap.set("n", "<a-h>", "^", { desc = "Go to start of line" })
vim.keymap.set("n", "<a-l>", "$", { desc = "Go to end of line" })
vim.keymap.set("n", "<a-left>", "^", { desc = "Go to start of line" })
vim.keymap.set("n", "<a-right>", "$", { desc = "Go to end of line" })

-- Selection
vim.keymap.set("n", "<a-a>", "ggVG", { desc = "Select all" })

-- Join current line with line below and replace
-- cursor at initial position
vim.keymap.set("n", "J", "mzJ`z")

-- Up/down half page with centered view
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")

-- Clear search highlights
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Search next/previous with centered view
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Search in visual mode
vim.keymap.set("v", "/", "<Esc>/\\%V")
vim.keymap.set("v", "?", "<Esc>?\\%V")

-- Tab and Shift-Tab for indentation
vim.keymap.set("n", "<tab>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<c-i>", "<c-i>") -- We need this as remapping <tab> also remaps <c-i>
vim.keymap.set("n", "<s-tab>", "<<", { desc = "Unindent line" })
vim.keymap.set("x", "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("x", "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Esc to exit terminal mode
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })

-- Wrapping
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })

-- Yanking and pasting
vim.keymap.set("v", "p", '"_dP', { desc = "Paste" })
vim.keymap.set({ "v" }, "<leader>p", '"_d"+P', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })

-- I'll get cancelled too...
vim.keymap.set("i", "<c-c>", "<Esc>", { desc = "Insert mode escape" })

-- Window navigation
vim.keymap.set({ "n", "v", "i" }, "<c-h>", "<c-w>h", {
  desc = "Navigate window left",
})
vim.keymap.set({ "n", "v", "i" }, "<c-j>", "<c-w>j", {
  desc = "Navigate window down",
})
vim.keymap.set({ "n", "v", "i" }, "<c-k>", "<c-w>k", {
  desc = "Navigate window up",
})
vim.keymap.set({ "n", "v", "i" }, "<c-l>", "<c-w>l", {
  desc = "Navigate window right",
})

-- Window navigation with arrows
-- On my COLEMAK mod-DH layout, I have a layer with the arrows in place of hjkl
vim.keymap.set({ "n", "v", "i", "t" }, "<c-left>", "<c-w>h", {
  desc = "Navigate window left",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-down>", "<c-w>j", {
  desc = "Navigate window down",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-up>", "<c-w>k", {
  desc = "Navigate window up",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-right>", "<c-w>l", {
  desc = "Navigate window right",
})

-- Window placement with arrows
-- On my COLEMAK mod-DH layout, I have a layer with the arrows in place of hjkl
vim.keymap.set({ "n", "v", "i", "t" }, "<c-s-left>", "<c-w>H", {
  desc = "Move window left",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-s-down>", "<c-w>J", {
  desc = "Move window down",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-s-up>", "<c-w>K", {
  desc = "Move window up",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<c-s-right>", "<c-w>L", {
  desc = "Move window right",
})

-- Window resizing
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make window bigger vertically" })
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make window smaller vertically" })
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make window bigger horizontally" })
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make window smaller horizontally" })

-- Window splitting
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>", { desc = "HSplit window" })
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "VSplit window" })

-- Buffers
vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bF", "<cmd>ene | startinsert<cr>", { desc = "New fullscreen buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bf", "<cmd>tab split<cr>", { desc = "Open current buffer in fullscreen tab" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bv", "<cmd>vnew<cr>", { desc = "New vertical split buffer" })
vim.keymap.set("n", "<leader>bh", "<cmd>new<cr>", { desc = "New horizontal split buffer" })

-- Tabs
vim.keymap.set("n", "<leader>Bc", "<cmd>tabc<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>Bn", "<cmd>tabn<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>Bo", "<cmd>tabe<cr>", { desc = "Open tab" })
vim.keymap.set("n", "<leader>Bp", "<cmd>tabp<cr>", { desc = "Previous tab" })

-- Folds
vim.keymap.set("n", "zv", "zMzvzz", { desc = "Close all folds except the current one" })
vim.keymap.set("n", "zj", "zcjzOzz", { desc = "Close current fold when open. Always open next fold." })
vim.keymap.set("n", "zk", "zckzOzz", { desc = "Close current fold when open. Always open previous fold." })

-- Diagnostics
-- diagnostic keymaps
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
  end
end

vim.keymap.set("n", "H", function()
  vim.diagnostic.open_float(nil, { focusable = true, scope = "cursor", source = "if_many" })
end, { desc = "Hover Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
vim.keymap.set("n", "lh", vim.diagnostic.hide, { desc = "Hide diagnostics" })
vim.keymap.set("n", "ls", vim.diagnostic.show, { desc = "Show diagnostics" })

-- Saving and quitting
vim.keymap.set("n", "<leader>q", function()
  -- If it's a help buffer, just bdelete it
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
  if buftype == "help" then
    vim.cmd("bdelete")
    return
  end

  -- Try to close the current window
  local ok = pcall(function()
    vim.cmd("close")
  end)

  -- If it's the last window
  if not ok then
    vim.notify("Last window", vim.log.levels.INFO)
  end
end, { desc = "Close window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>silent up!<cr>", { desc = "Save" })

-- Utilities
vim.keymap.set("n", "<leader>XE", "<cmd>set fileformat=unix<cr>", { desc = "Set file format to unix" })
vim.keymap.set("x", "<leader>'", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  local count = math.abs(end_line - start_line) + 1
  vim.notify("Selected lines: " .. count, vim.log.levels.INFO)
end, { desc = "Count selected lines" })
vim.keymap.set("n", "<leader>XX", "<cmd>!chmod +x %<cr>", { desc = "Make executable" })
vim.keymap.set("n", "<leader>zl", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>zm", "<cmd>Mason<cr>", { desc = "Mason" })

-- Undotree
local function open_undotree()
  vim.cmd.packadd("nvim.undotree")
  require("undotree").open()
end
vim.keymap.set("n", "<leader>U", open_undotree, { desc = "Undotree" })

-- Other
local function fire_save()
  if
    vim.fn.confirm(
      "🔥 FIRE SAVE: this will stage, commit, and push all changes to a new branch. Continue?",
      "&Yes\n&No",
      2,
      "Warning"
    ) ~= 1
  then
    vim.notify("Fire save aborted", 3)
    return
  end

  local ts = os.date("%Y%m%d%H%M%S")
  local branch = "etiennecollin-fire-" .. ts

  vim.cmd("!git checkout -b " .. branch)
  vim.cmd("!git add -A")
  vim.cmd(string.format('!git commit -m "FIRE, THIS COMMIT SAVES THE STATE OF MY WORK: %s"', ts))
  vim.cmd("!git push -u origin " .. branch)

  vim.notify("Fire save complete on branch: " .. branch, 3)
end

vim.keymap.set("n", "<leader>XF", fire_save, { desc = "Fire-save snapshot" })
