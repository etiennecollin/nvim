--[[
    Lua Module Documentation

    This Lua module provides utility functions for configuring and manipulating data.

    Usage:
    local utils = require("etiennecollin.utils.global")

    @module etiennecollin.utils.global
]]
local M = {}

--[[
    Set Colorscheme

    Sets the colorscheme for the Neovim environment.

    @function set_colorscheme
    @usage utils.set_colorscheme()
]]
function M.set_colorscheme()
	local colorscheme = require("etiennecollin.config").colorscheme

	-- Make sure the colorscheme is loaded
	require("lazy").load({ plugins = { colorscheme } })

	-- Set the colorscheme and fallback on error
	if not pcall(function()
		vim.cmd("colorscheme " .. colorscheme)
	end) then
		local fallback = require("etiennecollin.config").colorscheme_fallback
		print(
			'Error: Could not set colorscheme "'
				.. colorscheme
				.. '". Make sure the colorscheme is installed and loaded. Using "'
				.. fallback
				.. '" instead.'
		)
		vim.cmd("colorscheme " .. fallback)
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

return M
