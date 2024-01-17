return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.clangd.setup({
		cmd = {
			"clangd",
			"--fallback-style=Google",
			"--offset-encoding=utf-16",
		},
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
