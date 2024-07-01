return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "rshkarin/mason-nvim-lint", dependencies = "williamboman/mason.nvim" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = require("etiennecollin.utils").ensure_installed_linters

		-- Install linters with mason
		require("mason-nvim-lint").setup()

		-- Lint on entering buffer, saving and leaging insert mode
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Lint buffer" })
	end,
}
