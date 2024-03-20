return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.typst_lsp.setup({
		root_dir = function()
			return os.getenv("HOME")
		end,
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
