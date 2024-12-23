vim.g.mapleader = " "

-- Move up/down selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join current line with line below and replace
-- cursor at initial position
vim.keymap.set("n", "J", "mzJ`z")

-- Up/down half page with centered view
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next/previous with centered view
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Apparently the greatest remaps ever
vim.keymap.set("x", "<leader>p", [["_dP]], {
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
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Insert mode escape" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", {
	desc = "Navigate window left",
})
vim.keymap.set("n", "<C-j>", "<C-w>j", {
	desc = "Navigate window down",
})
vim.keymap.set("n", "<C-k>", "<C-w>k", {
	desc = "Navigate window up",
})
vim.keymap.set("n", "<C-l>", "<C-w>l", {
	desc = "Navigate window right",
})

vim.keymap.set("n", "<leader>bc", "<cmd>close<cr>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers" })
vim.keymap.set("n", "<leader>bh", "<cmd>FocusSplitDown<cr>", { desc = "Hsplit window" })
vim.keymap.set("n", "<leader>bn", "<cmd>FocusSplitNicely<cr>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>bv", "<cmd>FocusSplitRight<cr>", { desc = "Vsplit window" })

vim.keymap.set("n", "<leader>Bc", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>Bn", "<cmd>tabn<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>Bo", "<cmd>tabnew<cr>", { desc = "Open tab" })
vim.keymap.set("n", "<leader>Bp", "<cmd>tabp<cr>", { desc = "Previous tab" })

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal<cr>", { desc = "Toggle Neotree" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>Q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>update!<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>XE", "<cmd>set fileformat=unix<cr>", { desc = "Set file format to unix" })

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undotree" })
vim.keymap.set("n", "<leader>XA", "<cmd>CellularAutomaton make_it_rain<cr>", { desc = "Cellular automaton" })
vim.keymap.set("n", "<leader>XX", "<cmd>!chmod +x %<cr>", { desc = "Make executable" })
vim.keymap.set("n", "<leader>zm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>zl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Exit insert mode
-- vim.keymap.set("i", "jj", "<esc>", {
-- 	desc = "Exit insert mode",
-- })
-- vim.keymap.set("i", "kk", "<esc>", {
-- 	desc = "Exit insert mode",
-- })
