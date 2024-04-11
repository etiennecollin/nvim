local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "etiennecollin.plugins.colorscheme" },
	{ import = "etiennecollin.plugins.base" },
	{ import = "etiennecollin.plugins.language-specific" },
	{ import = "etiennecollin.plugins.lsp" },
}, {
	checker = { enabled = true, notify = false },
	change_detection = { enabled = true, notify = false },
	install = {
		colorscheme = { require("etiennecollin.utils").default_colorscheme },
	},
})
