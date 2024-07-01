-- Setting global options

-- Set termguicolors to enable highlight groups
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Set the colorscheme and ensure installed plugins
require("etiennecollin.utils").default_colorscheme = "gruvbox-material"
require("etiennecollin.utils").ensure_installed_treesitter = { "lua", "markdown_inline", "comment" }
require("etiennecollin.utils").ensure_installed_lsps =
	{ "lua_ls", "rust_analyzer", "jdtls", "basedpyright", "typst_lsp" }
require("etiennecollin.utils").ensure_installed_linters = {
	c = { "trivy" },
	cpp = { "trivy" },
	rust = { "trivy" },
	python = { "trivy" },
	java = { "trivy" },
	javascript = { "trivy" },
	typescript = { "trivy" },
}
require("etiennecollin.utils").ensure_installed_formatters = {
	lua = { "stylua" },
	python = { "isort", "black" },
	sh = { "shfmt" },
	bash = { "shfmt" },
	zsh = { "shfmt" },
	c = { "clang_format" },
	cpp = { "clang_format" },
	java = { "google-java-format" },
	typst = { "typstfmt" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	javascriptreact = { "prettier" },
	typescriptreact = { "prettier" },
	svelte = { "prettier" },
	css = { "prettier" },
	html = { "prettier" },
	json = { "prettier" },
	yaml = { "prettier" },
	markdown = { "prettier" },
	graphql = { "prettier" },
}
require("etiennecollin.utils").ensure_installed_daps = { "codelldb" }

-- Set cursor options and line highlighting
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.cursorline = true
vim.opt.colorcolumn = { "80", "120" }

-- Enable incrementing hex numbers and letters
vim.api.nvim_set_option_value("nrformats", "hex,alpha", {})

-- Enable numbers and relative numbers
vim.opt.number = true
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

-- Substitution
vim.opt.inccommand = "split"

-- Set how splits open
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪"

-- Enable hidden buffers
vim.opt.hidden = true

-- Backup and undo settings
-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Other settings
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Vertically center document when entering insert mode
vim.cmd("autocmd InsertEnter * norm zz")

-- Remove trailing whitespace on save
vim.cmd("autocmd BufWritePre, FileWritePre * :%s/\\s\\+$//e")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("etiennecollin-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Floating linting messages on cursor hold and disable virtual text
vim.cmd([[au CursorHold * lua vim.diagnostic.open_float(0,{scope = "cursor"})]])
