return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.tailwindcss.setup({
		filetypes = {
			"css",
			"scss",
			"sass",
			"postcss",
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"svelte",
			"vue",
			-- "rust",
		},
		init_options = {
			-- Set languages to be considered as different ones by lsp
			userLanguages = {
				rust = "html",
			},
		},
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
