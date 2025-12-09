return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = "Obsidian",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/vaults/*.md",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "work",
        path = "~/vaults/work",
      },
    },
    -- callbacks = {
    --   enter_note = function(e)
    --     vim.keymap.del("n", "<CR>", { buffer = e.buf })
    --     vim.keymap.set("n", "<leader><CR>", require("obsidian.api").smart_action, { buffer = e.buf })
    --   end,
    -- },
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
    },
    picker = {
      name = "snacks",
    },
  },
}
