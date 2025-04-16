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
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next/previous with centered view
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Tab and Shift-Tab for indentation
vim.keymap.set("n", "<tab>", ">>", { desc = "Indent line" })
vim.keymap.set("n", "<c-i>", "<c-i>") -- We need this as remapping <tab> also remaps <c-i>
vim.keymap.set("n", "<s-tab>", "<<", { desc = "Unindent line" })
vim.keymap.set({ "v", "x" }, "<tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set({ "v", "x" }, "<s-tab>", "<gv", { desc = "Unindent selection" })

-- Search in visual mode
vim.keymap.set("v", "/", "<Esc>/\\%V")
vim.keymap.set("v", "?", "<Esc>?\\%V")

-- Yanking and pasting
vim.keymap.set("x", "<leader>P", [["_dP]], {
	desc = "Delete and paste (keep clipboard)",
})
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {
	desc = "Yank selection to system clipboard",
})
vim.keymap.set("n", "<leader>Y", [["+Y]], {
	desc = "Yank whole line to system clipboard",
})
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]], {
	desc = "Delete without yank",
})

-- I'll get cancelled too...
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Insert mode escape" })

-- Window navigation
vim.keymap.set({ "n", "v", "i" }, "<C-h>", "<C-w>h", {
	desc = "Navigate window left",
})
vim.keymap.set({ "n", "v", "i" }, "<C-j>", "<C-w>j", {
	desc = "Navigate window down",
})
vim.keymap.set({ "n", "v", "i" }, "<C-k>", "<C-w>k", {
	desc = "Navigate window up",
})
vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<C-w>l", {
	desc = "Navigate window right",
})

-- Window navigation with arrows
-- On my COLEMAK mod-DH layout, I have a layer with the arrows in place of hjkl
vim.keymap.set({ "n", "v", "i", "t" }, "<C-Left>", "<C-w>h", {
	desc = "Navigate window left",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<C-Down>", "<C-w>j", {
	desc = "Navigate window down",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<C-Up>", "<C-w>k", {
	desc = "Navigate window up",
})
vim.keymap.set({ "n", "v", "i", "t" }, "<C-Right>", "<C-w>l", {
	desc = "Navigate window right",
})

-- Window resizing
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "Make window bigger vertically" })
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "Make window smaller vertically" })
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "Make window bigger horizontally" })
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "Make window smaller horizontally" })

-- Window splitting
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "VSplit window" })
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>", { desc = "HSplit window" })

-- Buffers
vim.keymap.set("n", "<leader>bc", "<cmd>close<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bn", "<cmd>ene | startinsert<cr>", { desc = "New buffer" })

-- Tabs
vim.keymap.set("n", "<leader>Bc", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>Bn", "<cmd>tabn<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>Bo", "<cmd>tabnew<cr>", { desc = "Open tab" })
vim.keymap.set("n", "<leader>Bp", "<cmd>tabp<cr>", { desc = "Previous tab" })

-- Saving and quitting
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>Q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>update!<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>XE", "<cmd>set fileformat=unix<cr>", { desc = "Set file format to unix" })

-- Utilities
vim.keymap.set("n", "<leader>XX", "<cmd>!chmod +x %<cr>", { desc = "Make executable" })
vim.keymap.set("n", "<leader>zm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>zl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<cr>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<cr>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<cr>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<cr>zz")

-- Exit insert mode
-- vim.keymap.set("i", "jj", "<esc>", {
-- 	desc = "Exit insert mode",
-- })
-- vim.keymap.set("i", "kk", "<esc>", {
-- 	desc = "Exit insert mode",
-- })
