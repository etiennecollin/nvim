--[[
    Lua Module Documentation

    This Lua module provides utility functions for configuring and manipulating data.

    Usage:
    local utils = require("etiennecollin.utils.local")

    @module etiennecollin.utils.local
]]
local M = {}

--[[
    Is Full Config

    Checks existance of `full` or `core` file to determine if the full configuration should be loaded.

    @function is_full_config
    @treturn bool True if the full configuration should be loaded, false otherwise.
    @usage if utils.is_full_config() then
        print("Loading full configuration...")
    end
]]
function M.is_full_config()
  local config_dir = vim.fn.stdpath("config")
  while true do
    if vim.fn.filereadable(config_dir .. "/full.conf") == 1 then
      return true
    elseif vim.fn.filereadable(config_dir .. "/core.conf") == 1 then
      return false
    else
      -- Notify user that neither `full` nor `core` file was found
      print("No configuration file found.")
      M.create_config_file()
    end
  end
end

--[[
    Create Config File

    Creates a configuration file in the Neovim configuration directory.

    @function create_config_file
    @usage utils.create_config_file()
]]
function M.create_config_file()
  -- Define the directory where the config files will be created
  local config_dir = vim.fn.stdpath("config")

  -- Define file names and their corresponding choices
  local file_choices = { "core.conf", "full.conf" }

  local file_name
  local file_path

  while true do
    -- Prompt the user for input
    local input = vim.fn.input("Enter configuration type (1 for core, 2 for full): ")
    local choice = tonumber(input)
    print("\n")

    -- Check if the input is valid
    if choice == 1 or choice == 2 then
      file_name = file_choices[choice]
      file_path = config_dir .. "/" .. file_name

      -- Create the file
      local file = io.open(file_path, "w")
      if file then
        file:write("-- This is a configuration file\n")
        file:close()
        print("Configuration file created: " .. file_path)
        break
      else
        print("Error creating the file.")
      end
    else
      print('Invalid input. Please enter "1" for core or "2" for full.')
    end
  end
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
