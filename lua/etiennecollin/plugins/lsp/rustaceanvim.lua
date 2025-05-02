return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Recommended
	dependencies = {
		"mfussenegger/nvim-dap",
		"williamboman/mason.nvim",
	},
	ft = { "rust" },
	config = function()
		-- Setup codelldb path for DAP
		local extension_path = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
		if not vim.fn.filereadable(codelldb_path) or not vim.fn.filereadable(liblldb_path) then
			local msg = "Installing codelldb via Mason...\nEither codelldb or liblldb was not readable.\ncodelldb: "
				.. codelldb_path
				.. "\nliblldb: "
				.. liblldb_path
			vim.notify(msg, vim.log.levels.INFO)
			vim.cmd(":MasonInstall codelldb")
		end

		vim.g.rustaceanvim = {
			tools = {
				reload_workspace_from_cargo_toml = true,
				inlay_hints = {
					auto = true,
					parameter_hints_prefix = "<-",
					other_hints_prefix = "->",
				},
			},
			dap = {
				adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
			},
			server = {
				capabilities = require("etiennecollin.utils.local").get_lsp_capabilities(),
				on_attach = function(client, bufnr)
					-- Load default LSP mappings
					require("etiennecollin.core.mappings.plugin").lsp(client, bufnr)

					-- Overwrite default LSP mappings
					vim.keymap.set("n", "<leader>ca", function()
						vim.cmd.RustLsp("codeAction")
					end, { silent = true, buffer = bufnr })
					vim.keymap.set("n", "K", function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end, { silent = true, buffer = bufnr })
				end,
				default_settings = {
					-- https://github.com/rust-lang/rust-analyzer/blob/afc367b96c093b410c8852e583ba467a196b58c8/docs/book/src/configuration_generated.md
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
