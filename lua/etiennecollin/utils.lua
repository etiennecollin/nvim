--[[
    Lua Module Documentation

    This Lua module provides utility functions for configuring and manipulating data.

    Usage:
    local utils = require("etiennecollin.utils")

    @module etiennecollin.utils
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
    Set Color Scheme

    Sets the color scheme for the Neovim environment.

    @function set_colorscheme
    @tparam string theme_name The name of the color scheme to set. Default is "tokyonight" if no theme_name is provided.
    @usage utils.set_colorscheme("sonokai")
]]
function M.set_colorscheme(theme_name)
	-- Set the default theme if no theme is specified
	theme_name = theme_name or require("etiennecollin.config").default_colorscheme

	require("lazy").load({ plugins = { theme_name } })

	-- Set the color scheme and print an error if it fails to load
	if not pcall(function()
		vim.cmd("colorscheme " .. theme_name)
	end) then
		print(
			'Error: Could not set colorscheme "'
				.. theme_name
				.. '". Make sure the theme is installed and available in your runtimepath.'
		)
		print("")
	end
end

--[[
    Split String

    Splits a string into parts based on a specified separator.

    @function split
    @tparam string input_string The input string to be split.
    @tparam[opt="%s"] string sep The separator pattern. Default is whitespace.
    @treturn table An array containing the parts of the split string.
    @usage local parts = utils.split("Hello, World!", ",")
]]
function M.split(input_string, sep)
	if sep == nil then
		sep = "%s"
	end

	local result = {}
	for substr in string.gmatch(input_string, "([^" .. sep .. "]+)") do
		table.insert(result, substr)
	end

	return result
end

--[[
    Set Key Recursive

    Sets a value in a nested table based on a dot-separated key.

    @function set_key_recursive
    @tparam table table The table in which to set the value.
    @tparam string keys The dot-separated key string specifying the path to the value.
    @param value The value to set.
    @treturn table The modified table.
    @usage utils.set_key_recursive(myTable, "nested.key", "new value")
]]
function M.set_key_recursive(table, keys, value)
	local current_table = table
	local parsed_keys = M.split(keys, ".")

	for i, subkey in ipairs(parsed_keys) do
		-- Set the value if we are at the last key
		if i == #parsed_keys then
			current_table[subkey] = value
			return table
		end

		-- Create an empty table if the key does not exist
		current_table[subkey] = current_table[subkey] or {}
		current_table = current_table[subkey]
	end
end

--[[
    Print Table

    Prints the contents of a table using the Vim inspect function.

    @function print_table
    @tparam table table The table to print.
    @usage utils.print_table(myTable)
]]
function M.print_table(table)
	print(vim.inspect(table))
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
