local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local colorscheme = { import = "etiennecollin.plugins.colorscheme" }
local core = { import = "etiennecollin.plugins.core" }
local extra = { import = "etiennecollin.plugins.extra" }
local language_specific = { import = "etiennecollin.plugins.language-specific" }
local lsp = { import = "etiennecollin.plugins.lsp" }

local imports = {
	colorscheme,
	core,
}

-- If config contains `core` file, then nothing is added to imports.
-- If config contains `full` file, then `extra`, `language_specific` and `lsp` are added to imports.
if require("etiennecollin.utils").is_full_config() then
	table.insert(imports, extra)
	table.insert(imports, language_specific)
	table.insert(imports, lsp)
end

require("lazy").setup(imports, {
	checker = { enabled = true, notify = false },
	change_detection = { enabled = true, notify = false },
	dev = { path = "~/github/" },
	install = {
		colorscheme = { require("etiennecollin.config").default_colorscheme },
	},
	rocks = {
		hererocks = true,
	},
})

require("etiennecollin.utils").set_colorscheme()
