vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Unmap F1 which is used for ghostty's quick term
vim.keymap.set({ "n", "i", "v", "t" }, "<F1>", "")

-- Move up/down selected lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- Join current line with line below and replace
-- cursor at initial position
vim.keymap.set("n", "J", "mzJ`z")

-- Up/down half page with centered view
vim.keymap.set("n", "<c-d>", "<c-d>zz")
vim.keymap.set("n", "<c-u>", "<c-u>zz")

-- Search next/previous with centered view
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Tab and Shift-Tab for indentation
vim.keymap.set("n", "<tab>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<c-i>", "<c-i>") -- We need this as remapping <tab> also remaps <c-i>
vim.keymap.set("n", "<s-tab>", "<<", { desc = "Unindent line" })
vim.keymap.set("x", "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("x", "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Search in visual mode
vim.keymap.set("v", "/", "<Esc>/\\%V")
vim.keymap.set("v", "?", "<Esc>?\\%V")

-- Yanking and pasting
vim.keymap.set("v", "<leader>P", [["_dP]], {
  desc = "Delete and paste (keep clipboard)",
})
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
  desc = "Yank selection to system clipboard",
})
vim.keymap.set("n", "<leader>Y", [["+Y]], {
  desc = "Yank whole line to system clipboard",
})
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], {
  desc = "Delete without yank",
})

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
vim.keymap.set("n", "<leader>bN", "<cmd>bp<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bf", "<cmd>tab split<cr>", { desc = "Open current buffer in fullscreen tab" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bs", "<cmd>new<cr>", { desc = "New split buffer" })

-- Tabs
vim.keymap.set("n", "<leader>Bc", "<cmd>tabc<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>Bn", "<cmd>tabn<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>Bo", "<cmd>tabe<cr>", { desc = "Open tab" })
vim.keymap.set("n", "<leader>Bp", "<cmd>tabp<cr>", { desc = "Previous tab" })

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
vim.keymap.set("n", "<leader>Q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>up!<cr>", { desc = "Save" })

-- Utilities
vim.keymap.set("n", "<leader>XE", "<cmd>set fileformat=unix<cr>", { desc = "Set file format to unix" })
vim.keymap.set("n", "<leader>XX", "<cmd>!chmod +x %<cr>", { desc = "Make executable" })
vim.keymap.set("n", "<leader>zl", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>zm", "<cmd>Mason<cr>", { desc = "Mason" })

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
