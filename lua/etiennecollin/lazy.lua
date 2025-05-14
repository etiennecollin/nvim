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

-- ============
-- Core config
-- ============
local colorscheme = { import = "etiennecollin.plugins.colorscheme" }
local core = { import = "etiennecollin.plugins.core" }
-- ============

-- ============
-- Full config
-- ============
local language_specific = { import = "etiennecollin.plugins.language-specific" }
local misc = { import = "etiennecollin.plugins.misc" }

-- Mason, LSPs, DAPs, Linters, Formatters
local extra = { import = "etiennecollin.plugins.extra" }
local lsp = { import = "etiennecollin.plugins.extra.lsp" }
local dap = { import = "etiennecollin.plugins.extra.dap" }
-- ============

-- Check if the full config should be loaded
local imports
if require("etiennecollin.utils.local").is_full_config() then
	imports = {
		colorscheme,
		core,
		language_specific,
		misc,
		extra,
		lsp,
		dap,
	}
else
	imports = {
		colorscheme,
		core,
	}
end

require("lazy").setup(imports, {
	checker = { enabled = true, notify = false },
	change_detection = { enabled = true, notify = false },
	dev = { path = "~/github/" },
	install = {
		colorscheme = { require("etiennecollin.config").colorscheme },
	},
	rocks = {
		hererocks = true,
	},
})

require("etiennecollin.utils.global").set_colorscheme()
