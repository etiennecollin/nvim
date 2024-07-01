return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.basedpyright.setup({
		settings = {
			basedpyright = {
				disableOrganizeImports = true,
				typeCheckingMode = "standard",
				analysis = {
					inlayHints = {
						callArgumentNames = "all",
						functionReturnTypes = true,
						pytestParameters = true,
						variableTypes = true,
					},
					autoFormatStrings = true,
				},
				linting = { enabled = true },
			},
		},
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
