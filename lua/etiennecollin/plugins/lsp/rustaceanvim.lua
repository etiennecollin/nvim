return {
	"mrcjkb/rustaceanvim",
	version = "^4", -- Recommended
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"williamboman/mason.nvim",
	},
	ft = { "rust" },
	config = function()
		local capabilities = require("etiennecollin.utils").get_lsp_capabilities()
		local on_attach = require("etiennecollin.core.mappings.plugin").lsp

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
				hover_actions = {
					auto_focus = true,
				},
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
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				default_settings = {
					-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
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
						checkOnSave = {
							command = "clippy",
							allTargets = false,
						},
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
