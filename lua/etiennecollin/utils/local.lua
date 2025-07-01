--[[
    Lua Module Documentation

    This Lua module provides utility functions for configuring and manipulating data.

    Usage:
    local utils = require("etiennecollin.utils.local")

    @module etiennecollin.utils.local
]]
local M = {}

local config_dir = vim.fn.stdpath("config")
local config_choices = {
  [1] = { name = "Base configuration", file = "base.conf" },
  [2] = { name = "Core configuration", file = "core.conf" },
  [3] = { name = "Full configuration", file = "full.conf" },
}

--[[
    Create Config File

    Prompts the user to pick a configuration (base, core, or full)
    and writes that choice out as a `.conf` file in the Neovim config directory.

    @function create_config_file
    @tparam bool If true, the file is created; if false, no file is created.
    @usage utils.create_config_file()
]]
function M.create_config_file()
  local labels = {}
  for idx, choice in ipairs(config_choices) do
    labels[idx] = choice.name
  end

  local selection = vim.fn.confirm("Select configuration:", table.concat(labels, "\n"), 1, "Info")
  if selection < 1 or selection > #config_choices then
    vim.notify("No configuration created.", vim.log.levels.WARN)
    return nil
  end

  local cfg = config_choices[selection]
  local path = config_dir .. "/" .. cfg.file

  local fh, err = io.open(path, "w")
  if not fh then
    vim.notify('Error writing "' .. cfg.file .. '": ' .. err, vim.log.levels.ERROR)
    return nil
  end

  fh:write("-- " .. cfg.name .. " file\n")
  fh:close()
  vim.notify("Created configuration: " .. path, vim.log.levels.INFO)
  return selection
end

--[[
    Get Configuration Type

    Check which plugins should be loaded based on the configuration file.
    If no valid file exists, prompt the user to create one.

    @function get_config_type
    @treturn int 1 for base, 2 for core, 3 for full
    @usage if utils.get_config_type() == 3 then
             print("Loading full configuration...")
           end
]]
function M.get_config_type()
  for idx, cfg in ipairs(config_choices) do
    if vim.fn.filereadable(config_dir .. "/" .. cfg.file) == 1 then
      return idx
    end
  end

  -- vim.notify("No configuration file found.", vim.log.levels.WARN)
  local created = M.create_config_file()
  if not created then
    error("Configuration required to proceed.")
  end

  for idx, cfg in ipairs(config_choices) do
    if vim.fn.filereadable(config_dir .. "/" .. cfg.file) == 1 then
      return idx
    end
  end

  error("Failed to create configuration file.")
end

--[[
  Returns the LSP capabilities merged with the capabilities from the blink module.

  @function get_lsp_capabilities
  @usage local capabilities = utils.get_lsp_capabilities()
]]
function M.get_lsp_capabilities()
  local capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  return capabilities
end

return M
