return {
	"jpalardy/vim-slime",
	ft = { "markdown", "typst", "quarto" },
	dependencies = { "jmbuhr/otter.nvim" },
	init = function()
		vim.b["quarto_is_" .. "python" .. "_chunk"] = false
		Quarto_is_in_python_chunk = function()
			require("otter.tools.functions").is_otter_language_context("python")
		end

		vim.cmd([[
            let g:slime_dispatch_ipython_pause = 100
            function SlimeOverride_EscapeText_quarto(text)
                call v:lua.Quarto_is_in_python_chunk()
                if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk || (exists('b:quarto_is_r_mode') && !b:quarto_is_r_mode)
                    return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
                else
                    return a:text
                end
            endfunction
        ]])

		local function mark_terminal()
			vim.g.slime_last_channel = vim.b.terminal_job_id
			vim.print(vim.g.slime_last_channel)
		end

		local function set_terminal()
			vim.b.slime_config = { jobid = vim.g.slime_last_channel }
		end

		vim.b.slime_cell_delimiter = "# %%"

		-- slime, neovvim terminal
		vim.g.slime_target = "neovim"
		vim.g.slime_python_ipython = 1

		-- -- slime, tmux
		-- vim.g.slime_target = "tmux"
		-- vim.g.slime_bracketed_paste = 1
		-- vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }

		local function toggle_slime_tmux_nvim()
			if vim.g.slime_target == "tmux" then
				pcall(function()
					vim.b.slime_config = nil
					vim.g.slime_default_config = nil
				end)
				-- slime, neovvim terminal
				vim.g.slime_target = "neovim"
				vim.g.slime_bracketed_paste = 0
				vim.g.slime_python_ipython = 1
			elseif vim.g.slime_target == "neovim" then
				pcall(function()
					vim.b.slime_config = nil
					vim.g.slime_default_config = nil
				end)
				-- -- slime, tmux
				vim.g.slime_target = "tmux"
				vim.g.slime_bracketed_paste = 1
				vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }
			end
		end

		vim.keymap.set("n", "<leader>tsm", mark_terminal, { desc = "Mark terminal" })
		vim.keymap.set("n", "<leader>tss", set_terminal, { desc = "Set terminal" })
		vim.keymap.set("n", "<leader>tso", toggle_slime_tmux_nvim, { desc = "Toggle tmux/nvim terminal" })
	end,
	config = function()
		require("etiennecollin.core.remaps_plugin").slime()
	end,
}
