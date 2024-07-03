local lazy = vim.api.nvim_create_augroup("lazy", {})

-- Lazy load plugin on specific file extension
vim.api.nvim_create_autocmd("UIEnter", {
	group = lazy,
	pattern = { "*.gpg", "*.pgp", "*.asc" },
	callback = function()
		require("lazy").load({ plugins = { "vim-gnupg" } })
	end,
})
