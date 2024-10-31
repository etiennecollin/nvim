return {
	"theHamsta/nvim-dap-virtual-text",
	ft = { "cpp", "c", "rust" },
	dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("nvim-dap-virtual-text").setup({
			enabled = true,

			-- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = true,
			only_first_definition = false,
			all_references = false,
			clear_on_continue = false,

			--- A callback that determines how a variable is displayed or whether it should be omitted
			--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
			--- @param buf number
			--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
			--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
			--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
			--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
			display_callback = function(variable, buf, stackframe, node, options)
				-- By default, strip out new line characters
				if options.virt_text_pos == "inline" then
					return " = " .. variable.value:gsub("%s+", " ")
				else
					return variable.name .. " = " .. variable.value:gsub("%s+", " ")
				end
			end,

			virt_text_pos = "eol", -- vim.fn.has("nvim-0.10") == 1 and "inline" or "eol"
		})
	end,
}
