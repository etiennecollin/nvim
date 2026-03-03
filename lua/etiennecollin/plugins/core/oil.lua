local detail = false
-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  "stevearc/oil.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<cr>"] = "actions.select",
      ["<bs>"] = { "actions.parent", mode = "n" },
      ["<c-v>"] = { "actions.select", opts = { vertical = true } },
      ["<c-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<c-t>"] = { "actions.select", opts = { tab = true } },
      ["<c-p>"] = "actions.preview",
      ["<c-r>"] = "actions.refresh",
      ["<c-c>"] = { "actions.close", mode = "n" },
      ["<esc>"] = { "actions.close", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
      ["<m-s>"] = { "actions.change_sort", mode = "n" },
      ["<m-h>"] = { "actions.toggle_hidden", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gx"] = "actions.open_external",
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
      ["gd"] = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          if detail then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
      },
    },
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
    },
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").oil()
  end,
}
