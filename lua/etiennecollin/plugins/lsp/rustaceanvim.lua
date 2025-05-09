return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Recommended
	dependencies = { "mfussenegger/nvim-dap" },
	ft = { "rust" },
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				reload_workspace_from_cargo_toml = true,
				inlay_hints = {
					auto = true,
					parameter_hints_prefix = "<-",
					other_hints_prefix = "->",
				},
			},
			server = {
				capabilities = require("etiennecollin.utils.local").get_lsp_capabilities(),
				on_attach = function(client, bufnr)
					-- Load default LSP mappings
					require("etiennecollin.core.mappings.plugin").lsp(client, bufnr)

					-- Overwrite default LSP mappings
					vim.keymap.set("n", "K", function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end, { silent = true, buffer = bufnr })
				end,
				settings = {
					-- https://github.com/rust-lang/rust-analyzer/blob/8b624868e4ce2cb5b39559175f0978bee86bdeea/docs/book/src/configuration_generated.md
					["rust-analyzer"] = {
						check = {
							command = "clippy",
							extraArgs = {
								"--all",
								-- "--all-targets",
								-- "--all-features",
								"--",
								"-W",
								"clippy::all",
							},
						},
						checkOnSave = true,
						inlayHints = {
							chainingHints = {
								enable = false,
							},
							closingBraceHints = {
								enable = false,
							},
						},
						procMacro = {
							ignored = {
								leptos_macro = {
									"component",
									"server",
								},
							},
						},
					},
				},
			},
		}
	end,
}
