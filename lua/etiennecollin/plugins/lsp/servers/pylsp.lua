return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.pylsp.setup({
		settings = {
			pylsp = {
				configurationSources = "null",
				plugins = {
					autopep8 = {
						enabled = false,
					},
					pycodestyle = {
						enabled = false,
					},
				},
			},
		},
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
