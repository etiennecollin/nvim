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
		          function SlimeOverridg_EscapeText_quarto(text)
		              call v:lua.Quarto_is_in_python_chunk()
		              if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk || (exists('b:quarto_is_r_mode') && !b:quarto_is_r_mode)
		                  return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
		              else
		                  return a:text
		              end
		          endfunction
		      ]])

		vim.g.slime_cell_delimiter = "^\\s*```"

		-- Use neovim terminal for slime
		vim.g.slime_target = "neovim"
		vim.g.slime_dont_ask_default = 0
		vim.g.slime_bracketed_paste = 0
		vim.g.slime_python_ipython = 1

		-- Do not use default mappings
		vim.g.slime_no_mappings = 1

		require("etiennecollin.core.remaps_plugin").slime()
	end,
}
