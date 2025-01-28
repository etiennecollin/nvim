return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "Snacks" },
				},
				telemetry = {
					enable = false,
				},
			},
		},
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
