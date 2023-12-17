return function(capabilities, on_attach)
	local lspconfig = require("lspconfig")
	lspconfig.jdtls.setup({
		root_dir = lspconfig.util.root_pattern(
			"build.xml", -- Ant
			"pom.xml", -- Maven
			".git",
			".java_project",
			"build.gradle",
			"settings.gradle", -- Gradle
			"settings.gradle.kts" -- Gradle
		) or vim.fn.getcwd(),
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
