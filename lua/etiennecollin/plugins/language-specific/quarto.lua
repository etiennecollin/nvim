return {
	"quarto-dev/quarto-nvim",
	opts = {
		lspFeatures = {
			languages = { "r", "python", "julia", "bash", "html", "lua" },
		},
	},
	ft = "quarto",
	dependencies = { "jmbuhr/otter.nvim" },
	config = function()
		vim.keymap.set("n", "<leader>ma", "<cmd>QuartoActivate<cr>", { desc = "Quarto activate" })
		vim.keymap.set("n", "<leader>mp", "<cmd>QuartoPreview<cr>", { desc = "Quarto preview" })
		vim.keymap.set("n", "<leader>mq", "<cmd>QuartoClosePreview<cr>", { desc = "Quarto close" })
		vim.keymap.set("n", "<leader>me", "<cmd>lua require('otter').export()<cr>", { desc = "Quarto export" })
		vim.keymap.set(
			"n",
			"<leader>mE",
			"<cmd>lua require('otter').export(true)<cr>",
			{ desc = "Quarto export overwrite" }
		)
		vim.keymap.set("n", "<leader>mrr", "<cmd>QuartoSendAbove<cr>", { desc = "Run to cursor" })
		vim.keymap.set("n", "<leader>mra", "<cmd>QuartoSendAll<cr>", { desc = "Run all" })
		vim.keymap.set("n", "<leader><cr>", "<Plug>SlimeSendCell<cr>", { desc = "Send code chunk" })
		vim.keymap.set("v", "<leader><cr>", "<Plug>SlimeRegionSend<cr>", { desc = "Send code chunk" })
	end,
}
