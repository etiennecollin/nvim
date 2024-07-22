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
			print("Using neovim terminal for slime")
		elseif vim.g.slime_target == "neovim" then
			-- Use tmux for slime
			vim.g.slime_target = "tmux"
			vim.g.slime_bracketed_paste = 1
			vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }
			print("Using tmux for slime")
		end
	end

	vim.keymap.set("n", "<leader>tsc", "<cmd>SlimeConfig<cr>", { desc = "Configure slime" })
	vim.keymap.set("n", "<leader>tso", toggle_slime_tmux_nvim, { desc = "Toggle tmux/nvim terminal for slime" })
	vim.keymap.set("n", "<leader><cr>", "<plug>SlimeSendCell", { desc = "Slime send cell" })
	vim.keymap.set("v", "<leader><cr>", "<plug>SlimeRegionSend", { desc = "Slime send visual" })
end

function M.gen()
	vim.keymap.set({ "n", "v" }, "<leader>]", ":Gen<CR>")
end

function M.silicon()
	vim.keymap.set("v", "<leader>S", ":Silicon<cr>", { desc = "Silicon" })
end

function M.boole()
	vim.keymap.set({ "n", "v" }, "<leader>=", "<cmd>Boole increment<cr>", { desc = "Boole increment" })
	vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Boole decrement<cr>", { desc = "Boole decrement" })
end

function M.language_specific()
	local wk = require("which-key")
	local file_type = vim.api.nvim_buf_get_option(0, "filetype")

	-- Add keymaps for typst, and markdown
	if file_type == "typst" then
		wk.add({
			mode = { "n" },
			{ "<leader>m", group = "typst" },
			{ "<leader>mm", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle preview" },
			{ "<leader>mw", "<cmd>TypstWatch --root ~<cr>", desc = "PDF watch" },
		})
	elseif file_type == "markdown" then
		wk.add({
			mode = { "n" },
			{ "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle markdown preview" },
		})
	elseif file_type == "rust" then
		wk.add({
			mode = { "n" },
			{ "<leader>m", group = "rust" },
			{ "<leader>mc", "<cmd>RustLsp codeAction<cr>", desc = "Code Actions" },
			{ "<leader>me", "<cmd>RustLsp explainError<cr>", desc = "Explain Error" },
			{ "<leader>mx", "<cmd>RustLsp renderDiagnostic<cr>", desc = "Render Diagnostics" },
			{ "<leader>mo", "<cmd>RustLsp openDocs<cr>", desc = "Open Documentation" },
			{ "<leader>mr", "<cmd>RustLsp runnables<cr>", desc = "Run" },
			{ "<leader>md", "<cmd>RustLsp debuggables<cr>", desc = "Debug" },
			{ "<leader>mt", "<cmd>RustLsp testables<cr>", desc = "Test" },
		})
	end
end

function M.neogen()
	vim.keymap.set("n", "<leader>na", "<cmd>Neogen<cr>", { desc = "Generate annotation" })
end

function M.spectre()
	vim.keymap.set("n", "<leader>S", "<cmd>Spectre<cr>", { desc = "Spectre" })
end

function M.telescope()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
	vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
	vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Global" })
	vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help tags" })
	vim.keymap.set("n", "<leader>sl", builtin.grep_string, { desc = "Local" })
	vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Recent files" })
	vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
	vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Select Telescope" })
	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "Open Files" })
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "Neovim files" })
	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "Fuzzy search in current buffer" })
end

function M.harpoon()
	local harpoon = require("harpoon")

	vim.keymap.set("n", "<leader>a", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "Harpoon" })
	vim.keymap.set("n", "<leader>A", function()
		harpoon:list():add()
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

function M.lsp(_, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Jump to the definition of the word under your cursor.
	map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")

	-- Find references for the word under your cursor.
	map("gr", require("telescope.builtin").lsp_references, "Goto References")

	-- Jump to the implementation of the word under your cursor.
	map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")

	-- Jump to the type of the word under your cursor.
	map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type Definition")

	-- Fuzzy find all the symbols in your current document.
	map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")

	-- Fuzzy find all the symbols in your current workspace.
	map("<leader>ss", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

	-- Rename the variable under your cursor.
	map("<leader>rn", vim.lsp.buf.rename, "Rename")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

	-- Show documentation for what is under cursor
	map("K", vim.lsp.buf.hover, "Hover Documentation")

	-- This is not Goto Definition, this is Goto Declaration.
	map("gD", vim.lsp.buf.declaration, "Goto Declaration")

	-- Mapping to restart lsp if necessary
	map("<leader>rs", ":LspRestart<CR>", "Restart")

	-- Jump to previous diagnostic in buffer
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic" })

	-- Jump to next diagnostic in buffer
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Goto next diagnostic" })

	-- Help with function signature
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, { desc = "Signature help" })
end

return M
