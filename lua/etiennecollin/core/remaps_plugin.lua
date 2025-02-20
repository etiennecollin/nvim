-- These functions create mappings that are only loaded when the plugin is loaded
-- This is done by calling the function in its corresponding plugin config
local M = {}

-- stylua: ignore start
function M.toggleterm()
	vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = " Terminal float" })
	vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal horizontal" })
	vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal vertical" })
	vim.keymap.set("n", "<leader>tTp", '<cmd>TermExec cmd="python"<cr>', { desc = "Python" })
	vim.keymap.set({ "n", "i", "v", "t" }, "<F3>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal", })
end

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
		local_map("<leader>mc", "<cmd>! typst compile --root ~ " .. vim.fn.expand("%:p") .. "<cr>", "Compile PDF")
		local_map("<leader>mm", "<cmd>TypstPreviewToggle<cr>", "Toggle preview")
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
	map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
	map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

	-- These two mappings use a "command" form to allow ranges in visual mode
	map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
	map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")

	map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Hunk")
	map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
	map("n", "<leader>gd", gs.diffthis, "Diff This")
	map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
	map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk Inline")
	map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
	map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
	map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end

function M.snacks()
	-- Snacks other
	vim.keymap.set("n", "<leader>zh", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
	vim.keymap.set("n", "<leader>rf", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
	vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
	vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
	vim.keymap.set("n", "<leader>XZ", function() Snacks.zen() end, { desc = "Toggle zen mode" })

	-- Snacks git
	vim.keymap.set({ "n", "i", "v", "t" }, "<F2>", function() Snacks.lazygit() end, { desc = "Lazygit" })
	vim.keymap.set({ "n" }, "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log" })
	vim.keymap.set({ "n", "v", "t" }, "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit file logs" })
	vim.keymap.set({ "n", "v", "t" }, "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit logs" })
	vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
	vim.keymap.set({ "n" }, "<leader>gx", function() Snacks.picker.git_status() end, { desc = "Git Status" })

	-- Snacks explorer
	vim.keymap.set({ "n" }, "<leader>e", function() Snacks.picker.explorer() end, { desc = "Toggle Explorer" })

	-- Snacks picker
	vim.keymap.set({ "n" }, "<leader><leader>", function() Snacks.picker.buffers() end, { desc = "Buffers" })
	vim.keymap.set({ "n" }, "<leader>qp", function() Snacks.picker.projects() end, { desc = "Projects" })
    vim.keymap.set({ "n" }, '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
	vim.keymap.set({ "n" }, "<leader>s:", function() Snacks.picker.commands() end, { desc = "Commands" })
	vim.keymap.set({ "n" }, "<leader>s;", function() Snacks.picker.command_history() end, { desc = "Command History" })
	vim.keymap.set({ "n" }, "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
	vim.keymap.set({ "n" }, "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
	vim.keymap.set({ "n" }, "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
	vim.keymap.set({ "n" }, "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
    vim.keymap.set({ "n" }, "<leader>sC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
	vim.keymap.set({ "n" }, "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
	vim.keymap.set({ "n" }, "<leader>sf", function() Snacks.picker.files() end, { desc = "Files" })
	vim.keymap.set({ "n" }, "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
    vim.keymap.set({ "n" }, "<leader>sG", function() Snacks.picker.git_files() end, { desc = "Git Files" })
	vim.keymap.set({ "n" }, "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
	vim.keymap.set({ "n" }, "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
	vim.keymap.set({ "n" }, "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
	vim.keymap.set({ "n" }, "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
	vim.keymap.set({ "n" }, "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
	vim.keymap.set({ "n" }, "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
	vim.keymap.set({ "n" }, "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
    vim.keymap.set({ "n" }, "<leader>sp", function() Snacks.picker() end, { desc = "Picker" })
	vim.keymap.set({ "n" }, "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
	vim.keymap.set({ "n" }, "<leader>sr", function() Snacks.picker.resume() end, { desc = "Resume" })
	vim.keymap.set({ "n" }, "<leader>sR", function() Snacks.picker.recent() end, { desc = "Recent" })
	vim.keymap.set({ "n" }, "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
	vim.keymap.set({ "n" }, "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "All Todo" })
	vim.keymap.set({ "n" }, "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })
    vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })

    -- Snacks LSP
	vim.keymap.set({ "n" }, "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
	vim.keymap.set({ "n" }, "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
	vim.keymap.set({ "n" }, "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
	vim.keymap.set({ "n" }, "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
end

function M.neogen()
	vim.keymap.set("n", "<leader>na", "<cmd>Neogen<cr>", { desc = "Annotation" })
end

function M.spectre()
	vim.keymap.set("n", "<leader>S", "<cmd>Spectre<cr>", { desc = "Spectre" })
end

function M.harpoon()
	local harpoon = require("harpoon")

	vim.keymap.set("n", "<leader>a", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon" })
	vim.keymap.set("n", "<leader>A", function() harpoon:list():add() end, { desc = "Add to Harpoon" })

	vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon select 1" })
	vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon select 2" })
	vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon select 3" })
	vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon select 4" })
end

function M.lsp(_, bufnr)
	local map = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("<leader>rn", vim.lsp.buf.rename, "Rename")
	map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
	map("K", vim.lsp.buf.hover, "Hover Documentation")
	map("gD", vim.lsp.buf.declaration, "Goto Declaration")
	map("<leader>rs", ":LspRestart<CR>", "Restart")
	vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Goto previous diagnostic" })
	vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Goto next diagnostic" })
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
end

function M.dap()
	local map = function(keys, func, desc)
		vim.keymap.set({ "n", "v" }, keys, func, { desc = desc })
	end

	-- From lazyvim
	-- https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/plugins/extras/dap/core.lua
	---@param config {args?:string[]|fun():string[]?}
	local function get_args(config)
		local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
		config = vim.deepcopy(config)
		---@cast args string[]
		config.args = function()
			local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
			return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
		end
		return config
	end

	local dap = require("dap")

	map("<leader>DB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, "breakpoint condition")
	map("<leader>Db", dap.toggle_breakpoint, "Toggle breakpoint")
	map("<leader>Dc", dap.continue, "Run/Continue")
	map("<leader>Da", function() dap.continue({ before = get_args }) end, "Run with args")
	map("<leader>DC", dap.run_to_cursor, "Run to cursor")
	map("<leader>Dg", dap.goto_, "Go to line (no execute)")
	map("<leader>Di", dap.step_into, "Step into")
	map("<leader>Dj", dap.down, "Down")
	map("<leader>Dk", dap.up, "Up")
	map("<leader>Dl", dap.run_last, "Run last")
	map("<leader>Do", dap.step_out, "Step out")
	map("<leader>DO", dap.step_over, "Step over")
	map("<leader>Dp", dap.pause, "Pause")
	map("<leader>Dr", dap.repl.toggle, "Toggle repl")
	map("<leader>Ds", dap.session, "Session")
	map("<leader>Dt", dap.terminate, "Terminate")
	map("<leader>Dw", require("dap.ui.widgets").hover, "Widgets")
end

function M.dapui()
	local map = function(keys, func, desc)
        vim.keymap.set({ "n", "v" }, keys, func, { desc = desc })
    end

	local dapui = require("dapui")

	map("<leader>Du", function() dapui.toggle() end, "Dap UI Toggle")
	map("<leader>De", function() dapui.eval() end, "Dap UI Eval")
end
-- stylua: ignore end

return M
