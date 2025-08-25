local IMG_PATH = vim.fn.expand("~/Pictures/wallpapers/a_moonlit_night_at_sea.jpg")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    animate = {
      enabled = true,
      fps = 120,
    },
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5MB
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "sf", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "a", desc = "New File", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "sg",
            desc = "Find Text",
            action = ":lua Snacks.dashboard.pick('live_grep')",
          },
          {
            icon = " ",
            key = "so",
            desc = "Recent Files",
            action = ":lua Snacks.dashboard.pick('oldfiles')",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          {
            icon = " ",
            key = "m",
            desc = "Mason",
            action = ":Mason",
          },
          {
            icon = "󰒲 ",
            key = "l",
            desc = "Lazy",
            action = ":Lazy",
            enabled = package.loaded.lazy ~= nil,
          },
          {
            icon = "󰖟 ",
            key = "o",
            desc = "Open Repo",
            action = ":lua Snacks.gitbrowse()",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
          },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
      sections = {
        {
          enabled = function()
            return (vim.fn.executable("chafa") == 1) and (vim.fn.filereadable(IMG_PATH) == 1)
          end,
          {
            section = "terminal",
            cmd = "chafa " .. IMG_PATH .. " --format symbols --symbols vhalf --size 60x17 --stretch",
            height = 17,
            padding = 1,
          },
          {
            pane = 2,
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
        },
        {
          enabled = function()
            return not ((vim.fn.executable("chafa") == 1) and (vim.fn.filereadable(IMG_PATH) == 1))
          end,
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    dim = {
      enabled = true,
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    image = {
      enabled = true,
      doc = {
        inline = false,
        img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", "resources" },
      },
      math = {
        enabled = false,
      },
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
      scope = {
        enabled = true,
      },
    },
    input = {
      enabled = true,
    },
    lazygit = {
      enabled = true,
      theme = {
        selectedLineBgColor = { bg = "CursorLine" },
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      layout = { preset = "ivy" },
      sources = {
        explorer = {
          auto_close = true,
          layout = { preset = "ivy", preview = true },
          win = {
            list = {
              keys = {
                ["."] = "explorer_focus",
                ["<BS>"] = "explorer_up",
                ["<space>"] = "select_and_next",
                ["a"] = "explorer_add",
                ["c"] = "explorer_copy",
                ["d"] = "explorer_del",
                ["h"] = "toggle_hidden",
                ["H"] = "toggle_ignored",
                ["l"] = "confirm",
                ["m"] = "explorer_move",
                ["r"] = "explorer_rename",
                ["y"] = "explorer_yank",
              },
            },
          },
        },
      },
    },
    quickfile = {
      enabled = true,
    },
    scope = {
      enabled = true,
    },
    scratch = {
      enabled = true,
    },
    scroll = {
      enabled = false,
    },
    terminal = {
      enabled = true,
    },
    words = {
      enabled = true,
      debounce = 100,
    },
    zen = {
      enabled = true,
    },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").snacks()
  end,
}
