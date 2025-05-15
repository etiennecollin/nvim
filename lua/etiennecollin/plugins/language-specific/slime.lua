return {
  "jpalardy/vim-slime",
  ft = { "markdown", "typst", "python" },
  init = function()
    vim.g.slime_cell_delimiter = "^\\s*```"

    -- Use neovim terminal for slime
    vim.g.slime_target = "neovim"
    vim.g.slime_bracketed_paste = true
    vim.g.slime_python_ipython = false

    vim.g.slime_dont_ask_default = false
    vim.g.slime_input_pid = false
    vim.g.slime_menu_config = false
    vim.g.slime_neovim_ignore_unlisted = false
    vim.g.slime_suggest_default = true

    -- Do not use default mappings
    vim.g.slime_no_mappings = true

    require("etiennecollin.core.mappings.plugin").slime()
  end,
}
