--[[
    Lua Module Documentation

    This Lua module provides utility functions for configuring and manipulating data in a Lua environment, with a focus on integration with Neovim.

    Usage:
    local utils = require("etiennecollin.utils")

    @module etiennecollin.utils
]]
local M = {}

--[[
    Default Theme

    The default theme to use if no theme is specified in the Neovim configuration.

    @field default_theme
    @usage utils.default_theme = "slate"
]]
M.default_theme = "slate"

--[[
    Set Color Scheme

    Sets the color scheme for the Neovim environment.

    @function set_colorscheme
    @tparam string theme_name The name of the color scheme to set. Default is "tokyonight" if no theme_name is provided.
    @usage utils.set_colorscheme("sonokai")
]]
function M.set_colorscheme(theme_name)
	-- Set the default theme if no theme is specified
	theme_name = theme_name or M.default_theme

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
    @usage myModule.print_table(myTable)
]]
function M.print_table(table)
	print(vim.inspect(table))
end

return M
