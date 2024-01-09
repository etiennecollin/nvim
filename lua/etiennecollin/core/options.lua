-- Setting global options

-- Set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.opt.background = "dark"
require("etiennecollin.utils").default_theme = "sonokai"

-- Set cursor options and line highlighting
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.cursorline = true
vim.opt.colorcolumn = { "80", "120" }

-- Enable incrementing hex numbers and letters
vim.api.nvim_set_option("nrformats", "hex,alpha")

-- Enable numbers and relative numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Set indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Set how splits open
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable line wrapping
vim.opt.wrap = true

-- Enable hidden buffers
vim.opt.hidden = true

-- Backup and undo settings
-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undofile = true

-- Other settings
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

-- Vertically center document when entering insert mode
vim.cmd("autocmd InsertEnter * norm zz")

-- Remove trailing whitespace on save
vim.cmd("autocmd BufWritePre,FileWritePre * :%s/\\s\\+$//e")
