--------------------------------------------------------------------------------
-- Set terminal windows title
--------------------------------------------------------------------------------
vim.opt.title = true
vim.opt.titlestring = "nvim: %t"

--------------------------------------------------------------------------------
-- Set termguicolors to enable highlight groups
--------------------------------------------------------------------------------
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

--------------------------------------------------------------------------------
-- Set floating window border
--------------------------------------------------------------------------------
vim.opt.winborder = "rounded"

--------------------------------------------------------------------------------
-- Set diagnostics
--------------------------------------------------------------------------------
vim.opt.signcolumn = "yes:1"

-- Set the signs for diagnostics
local s = vim.diagnostic.severity
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	virtual_lines = { current_line = true },
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
	signs = {
		text = {
			[s.ERROR] = " ",
			[s.WARN] = " ",
			[s.INFO] = " ",
			[s.HINT] = "󰌵 ",
		},
		linehl = {
			[s.ERROR] = "DiagnosticSignError",
			[s.WARN] = "DiagnosticSignWarn",
			[s.INFO] = "DiagnosticSignInfo",
			[s.HINT] = "DiagnosticSignHint",
		},
		numhl = {
			[s.ERROR] = "",
			[s.WARN] = "",
			[s.INFO] = "",
			[s.HINT] = "",
		},
	},
})

--------------------------------------------------------------------------------
-- Set symbols for whitespace characters
--------------------------------------------------------------------------------
vim.opt.list = true
vim.opt.listchars = {
	nbsp = "␣", -- Show zero-width space
	tab = "  ", -- Make sure tab doesn't show as I
	trail = "·", -- Show trailing whitespace
}

--------------------------------------------------------------------------------
-- Set cursor options and line highlighting
--------------------------------------------------------------------------------
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.cursorline = true
-- Only highlight the line number in the cursor line
vim.opt.cursorlineopt = { "number" }
vim.opt.colorcolumn = { "80", "120" }

--------------------------------------------------------------------------------
-- Enable incrementing hex, octal and bin numbers, and letters
--------------------------------------------------------------------------------
vim.opt.nrformats = { "alpha", "bin", "blank", "hex", "octal" }

--------------------------------------------------------------------------------
-- Enable numbers and relative numbers
--------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true

--------------------------------------------------------------------------------
-- Set indentation
--------------------------------------------------------------------------------
vim.opt.tabstop = 4
vim.opt.softtabstop = 0 -- Set to 0 to match tabstop
vim.opt.shiftwidth = 0 -- Set to 0 to match tabstop
vim.opt.expandtab = true -- Use spaces instead of tabs

vim.opt.autoindent = true
vim.opt.smartindent = true

-- << and >> shift to the nearest tabstop
vim.opt.shiftround = true

--------------------------------------------------------------------------------
-- Set search options
--------------------------------------------------------------------------------
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

--------------------------------------------------------------------------------
-- Substitution
--------------------------------------------------------------------------------
vim.opt.inccommand = "nosplit"

--------------------------------------------------------------------------------
-- Set how splits open
--------------------------------------------------------------------------------
vim.opt.splitbelow = true
vim.opt.splitright = true

--------------------------------------------------------------------------------
-- Enable line wrapping
--------------------------------------------------------------------------------
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪"

--------------------------------------------------------------------------------
-- Enable hidden buffers
--------------------------------------------------------------------------------
vim.opt.hidden = true

--------------------------------------------------------------------------------
-- Backup and undo settings
--------------------------------------------------------------------------------
vim.opt.backup = false
vim.opt.undofile = true
-- vim.opt.swapfile = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

--------------------------------------------------------------------------------
-- Setup folds
--------------------------------------------------------------------------------
vim.opt.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.foldenable = false
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"

--------------------------------------------------------------------------------
-- Scrolloff settings
--------------------------------------------------------------------------------
vim.opt.scrolloff = 30
vim.opt.sidescrolloff = 5

--------------------------------------------------------------------------------
-- Command timeout (used for WhichKey)
--------------------------------------------------------------------------------
vim.opt.timeout = true
vim.opt.timeoutlen = 300

--------------------------------------------------------------------------------
-- Other settings
--------------------------------------------------------------------------------
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.redrawtime = 150
vim.opt.showcmd = false
