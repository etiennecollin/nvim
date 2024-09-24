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
	local is_file_type = function(x)
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		return filetype == x
	end

	local local_map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = 0, silent = true, desc = desc })
	end

	-- Add keymaps for typst, and markdown
	if is_file_type("typst") then
		local_map("<leader>m", "", "Typst")
		local_map("<leader>mm", "<cmd>TypstPreviewToggle<cr>", "Toggle live preview")
		local_map("<leader>mc", "<cmd>TypstCompile<cr>", "Compile")
		local_map("<leader>mw", "<cmd>TypstWatch --root ~<cr>", "PDF Watch")
	elseif is_file_type("markdown") then
		local_map("<leader>m", "<cmd>MarkdownPreviewToggle<cr>", "Toggle markdown preview")
	elseif is_file_type("rust") then
		local_map("<leader>m", "", "Rust")
		local_map("<leader>mc", "<cmd>RustLsp codeAction<cr>", "Code Actions")
		local_map("<leader>me", "<cmd>RustLsp explainError<cr>", "Explain Error")
		local_map("<leader>mx", "<cmd>RustLsp renderDiagnostic<cr>", "Render Diagnostics")
		local_map("<leader>mo", "<cmd>RustLsp openDocs<cr>", "Open Documentation")
		local_map("<leader>mr", "<cmd>RustLsp runnables<cr>", "Run")
		local_map("<leader>md", "<cmd>RustLsp debuggables<cr>", "Debug")
		local_map("<leader>mt", "<cmd>RustLsp testables<cr>", "Test")
	end
end

function M.gitsigns(buffer)
	local gs = require("gitsigns")

	local function map(mode, l, r, desc)
		vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
	end

	map("n", "]h", function()
		if vim.wo.diff then
			vim.cmd.normal({ "]c", bang = true })
		else
			gs.nav_hunk("next")
		end
	end, "Next Hunk")
	map("n", "[h", function()
		if vim.wo.diff then
			vim.cmd.normal({ "[c", bang = true })
		else
			gs.nav_hunk("prev")
		end
	end, "Prev Hunk")
	map("n", "]H", function()
		gs.nav_hunk("last")
	end, "Last Hunk")
	map("n", "[H", function()
		gs.nav_hunk("first")
	end, "First Hunk")

	-- These two mappings use a "command" form to allow ranges in visual mode
	map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
	map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

	map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
	map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
	map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
	map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
	map("n", "<leader>hb", function()
		gs.blame_line({ full = true })
	end, "Blame Line")
	map("n", "<leader>hB", function()
		gs.blame()
	end, "Blame Buffer")
	map("n", "<leader>hd", gs.diffthis, "Diff This")
	map("n", "<leader>hD", function()
		gs.diffthis("~")
	end, "Diff This ~")
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
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
