-- ToggleTerm
vim.keymap.set({ "n", "i", "v", "t" }, "<F1>", "<cmd>ToggleTermToggleAll<cr>", {
	desc = "Toggle terminal",
})

-- These functions create mappings that are only loaded when the plugin is loaded
-- This is done by calling the function in its corresponding plugin config
local M = {}

function M.slime()
	local function toggle_slime_tmux_nvim()
		pcall(function()
			vim.b.slime_config = nil
			vim.g.slime_default_config = nil
		end)
		if vim.g.slime_target == "tmux" then
			-- Use neovim terminal for slime
			vim.g.slime_target = "neovim"
			vim.g.slime_bracketed_paste = 0
			vim.g.slime_python_ipython = 1
		elseif vim.g.slime_target == "neovim" then
			-- Use tmux for slime
			vim.g.slime_target = "tmux"
			vim.g.slime_bracketed_paste = 1
			vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }
		end
	end

	vim.keymap.set("n", "<leader>tsc", "<cmd>SlimeConfig<cr>", { desc = "Configure slime" })
	vim.keymap.set("n", "<leader>tso", toggle_slime_tmux_nvim, { desc = "Toggle tmux/nvim terminal for slime" })
end

function M.silicon()
	vim.keymap.set("v", "<leader>S", ":Silicon<cr>", { desc = "Silicon" })
end

function M.language_specific()
	local wk = require("which-key")
	local opts_n = {
		mode = "n",
		prefix = "<leader>",
		buffer = 0,
	}
	local opts_v = {
		mode = "v",
		prefix = "<leader>",
		buffer = 0,
	}

	local file_type = vim.api.nvim_buf_get_option(0, "filetype")
	local use_molten = false

	-- Add keymaps for quarto, typst, and markdown
	if file_type == "quarto" then
		use_molten = true
		wk.register({
			m = {
				name = "Quarto",
				a = { "<cmd>QuartoActivate<cr>", "Quarto activate" },
				p = { "<cmd>QuartoPreview<cr>", "Quarto preview" },
				q = { "<cmd>QuartoClosePreview<cr>", "Quarto close" },
				e = { "<cmd>lua require('otter').export()<cr>", "Quarto export" },
				E = { "<cmd>lua require('otter').export(true)<cr>", "Quarto export overwrite" },
				r = {
					name = "Quarto run",
					c = { "<cmd>QuartoSendAbove<cr>", "Run to cursor" },
					a = { "<cmd>QuartoSendAll<cr>", "Run all" },
				},
			},
		}, opts_n)
	elseif file_type == "typst" then
		wk.register({
			m = { "<cmd>TypstWatch --root ~<cr>", "Typst watch" },
		}, opts_n)
	elseif file_type == "markdown" then
		wk.register({
			m = { "<cmd>MarkdownPreviewToggle<cr>", "Toggle markdown preview" },
		}, opts_n)
	end

	-- Add keymaps for molten if it is being used and for slime otherwise
	if use_molten then
		wk.register({
			E = { "<plug>SlimeSendCell", "Slime send cell" },
			["<cr>"] = { "<cmd>QuartoSend<cr>", "Run cell" },
			["mm"] = {
				name = "Molten",
				e = { "<cmd>MoltenExport<cr>", "Export notebook" },
				h = { "<cmd>MoltenHideOutput<cr>", "Hide output" },
				o = { "<cmd>noautocmd MoltenEnterOutput<cr>", "Enter output" },
				p = { "<cmd>MoltenImagePopup<cr>", "Image popup" },
				q = { "<cmd>MoltenInterrupt<cr>", "Interrupt kernel" },
				r = { "<cmd>MoltenRestart<cr>", "Restart kernel" },
			},
		}, opts_n)
		wk.register({
			E = { "<plug>SlimeRegionSend", "Slime send visual" },
			["<cr>"] = { "<cmd>QuartoSendRange<cr>", "Run visual range" },
		}, opts_v)
	else
		wk.register({
			["<cr>"] = { "<plug>SlimeSendCell", "Slime send cell" },
		}, opts_n)
		wk.register({
			["<cr>"] = { "<plug>SlimeRegionSend", "Slime send visual" },
		}, opts_v)
	end
end

function M.neogen()
	vim.keymap.set("n", "<leader>n", "<cmd>Neogen<cr>", { desc = "Generate annotation" })
end

function M.spectre()
	vim.keymap.set("n", "<leader>S", "<cmd>Spectre<cr>", { desc = "Spectre" })
end

function M.ufo()
	local ufo = require("ufo")

	vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
	vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
end

function M.harpoon()
	local harpoon = require("harpoon")

	vim.keymap.set("n", "<leader>a", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Harpoon" })
	vim.keymap.set("n", "<leader>A", function()
		harpoon:list():append()
	end, { desc = "Add to Harpoon" })

	vim.keymap.set("n", "<leader>1", function()
		harpoon:list():select(1)
	end, { desc = "Harpoon select 1" })
	vim.keymap.set("n", "<leader>2", function()
		harpoon:list():select(2)
	end, { desc = "Harpoon select 2" })
	vim.keymap.set("n", "<leader>3", function()
		harpoon:list():select(3)
	end, { desc = "Harpoon select 3" })
	vim.keymap.set("n", "<leader>4", function()
		harpoon:list():select(4)
	end, { desc = "Harpoon select 4" })
end

function M.rust(_, bufnr)
	local rust_tools = require("rust-tools")
	local opts = {
		silent = true,
		buffer = bufnr,
	}

	opts.desc = "See available hover actions"
	vim.keymap.set("n", "<leader>ch", rust_tools.hover_actions.hover_actions, opts)

	opts.desc = "See available code actions"
	vim.keymap.set("n", "<leader>ca", rust_tools.code_action_group.code_action_group, opts)
end

function M.lsp(_, bufnr)
	-- Setup lspconfig
	local opts = {
		noremap = true,
		silent = true,
		buffer = bufnr,
	}

	-- Show definition, references
	opts.desc = "Show LSP references"
	vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

	-- Go to declaration
	opts.desc = "Go to declaration"
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	-- Show lsp definitions
	opts.desc = "Show LSP definitions"
	vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

	-- Show lsp implementations
	opts.desc = "Show LSP implementations"
	vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	-- Show lsp type definitions
	opts.desc = "Show LSP type definitions"
	vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	-- See available code actions, in visual mode will apply to selection
	opts.desc = "See available code actions"
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	-- Smart rename
	opts.desc = "Smart rename"
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	-- Show  diagnostics for file
	opts.desc = "Show buffer diagnostics"
	vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

	-- Show diagnostics for line
	opts.desc = "Show line diagnostics"
	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

	-- Jump to previous diagnostic in buffer
	opts.desc = "Go to previous diagnostic"
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

	-- Jump to next diagnostic in buffer
	opts.desc = "Go to next diagnostic"
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	-- Show documentation for what is under cursor
	opts.desc = "Show documentation for what is under cursor"
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	-- Mapping to restart lsp if necessary
	opts.desc = "Restart LSP"
	vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

	-- Help with function signature
	opts.desc = "Signature help"
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end

return M
