return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		{ "theHamsta/nvim-dap-virtual-text", dependencies = "nvim-treesitter/nvim-treesitter" },
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Dap UI",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "Eval",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		dapui.setup({
			floating = {
				border = "rounded",
			},
		})
	end,
}
