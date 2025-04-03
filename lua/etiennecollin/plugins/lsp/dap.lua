return {
	"mfussenegger/nvim-dap",
	ft = { "cpp", "c", "rust" },
	dependencies = {
		{ "jay-babu/mason-nvim-dap.nvim", dependencies = "williamboman/mason.nvim" },
	},
	config = function()
		-----------------------------------------------------------------------
		-- Install DAPs with mason
		-----------------------------------------------------------------------
		require("mason-nvim-dap").setup({
			ensure_installed = require("etiennecollin.config").ensure_installed_daps,
			automatic_installation = true,
			automatic_setup = true,
			handlers = {},
		})

		-----------------------------------------------------------------------
		-- Setup DAP
		-----------------------------------------------------------------------
		require("etiennecollin.core.mappings.plugin").dap()

		vim.api.nvim_set_hl(0, "DapStoppedLine", {
			default = true,
			link = "Visual",
		})

		local signs = {
			Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
			Breakpoint = " ",
			BreakpointCondition = " ",
			BreakpointRejected = { " ", "DiagnosticError" },
			LogPoint = ".>",
		}

		for name, sign in pairs(signs) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define("Dap" .. name, {
				text = sign[1],
				texthl = sign[2] or "DiagnosticInfo",
				linehl = sign[3],
				numhl = sign[3],
			})
		end
	end,
}
