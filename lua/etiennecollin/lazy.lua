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
local config_type = require("etiennecollin.utils.local").get_config_type()
local imports
if config_type == 1 then
  require("etiennecollin.utils.global").set_fallback_colorscheme()
  return
elseif config_type == 2 then
  imports = {
    colorscheme,
    core,
  }
elseif config_type == 3 then
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
  vim.notify("Invalid configuration type: " .. config_type, vim.log.levels.ERROR)
  return
end

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
