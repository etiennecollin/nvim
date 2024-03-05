return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.marksman.setup({
		filetypes = { "markdown", "markdown.mdx", "quarto" },
		root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
