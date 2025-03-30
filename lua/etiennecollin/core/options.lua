-- Set the colorscheme
require("etiennecollin.utils").default_colorscheme = "gruvbox-material"

-- Ensure installed plugins
require("etiennecollin.utils").ensure_installed_treesitter =
	{ "vim", "regex", "lua", "bash", "markdown", "markdown_inline", "comment" }
require("etiennecollin.utils").ensure_installed_lsps =
	{ "lua_ls", "rust_analyzer", "zls", "clangd", "basedpyright", "jdtls", "tinymist", "tailwindcss", "ts_ls" }
require("etiennecollin.utils").ensure_installed_linters = {
	c = { "trivy", "cpplint" },
	cpp = { "trivy", "cpplint" },
	rust = { "trivy" },
	python = { "trivy" },
	java = { "trivy" },
	javascript = { "trivy", "oxlint" },
	typescript = { "trivy", "oxlint" },
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
	typst = { "typstyle" },
	javascript = { "prettier" },
	typescript = { "prettier" },
	javascriptreact = { "prettier" },
	typescriptreact = { "prettier" },
	svelte = { "prettier" },
	tex = { "latexindent" },
	css = { "prettier" },
	html = { "prettier" },
	json = { "prettier" },
	jsonc = { "prettier" },
	yaml = { "prettier" },
	markdown = { "prettier" },
	graphql = { "prettier" },
}
require("etiennecollin.utils").ensure_installed_daps = { "codelldb" }

-- Set termguicolors to enable highlight groups
vim.g.have_nerd_font = true
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Set floating window border
vim.o.winborder = "rounded"

-- Set diagnostics
local signs = {
	Error = " ",
	Warn = " ",
	Hint = "󰌵 ",
	Info = " ",
}
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, {
		text = icon,
		texthl = hl,
		numhl = "",
	})
end

vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	virtual_lines = { current_line = true },
	signs = true,
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
})

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
vim.opt.softtabstop = 0 -- Set to 0 to match tabstop
vim.opt.shiftwidth = 0 -- Set to 0 to match tabstop
vim.opt.expandtab = true -- Use spaces instead of tabs

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Set search options
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Substitution
vim.opt.inccommand = "nosplit"

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

-- Setup folds
vim.o.foldtext = ""
vim.o.foldcolumn = "0"
vim.o.foldenable = false
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"

-- Other settings
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 300

local function commit_on_save()
	-- Check if the file is in a git repository
	if vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") ~= "" then
		-- Add the current file to the staging area
		vim.fn.system("git add " .. vim.fn.expand("%:p"))

		-- Commit the file with a generic message
		vim.fn.system('git commit -q -m "squash! $(git log -1 --format=%H)"')
	end
end

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = "*",
-- 	callback = commit_on_save,
-- })
