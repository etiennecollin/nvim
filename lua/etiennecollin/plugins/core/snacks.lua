local IMG_PATH = vim.fn.expand("~/Pictures/wallpapers/a_moonlit_night_at_sea.jpg")

local gitActions = {
  actions = {
    ["open_file"] = function(picker)
      local currentCommit = picker:current().commit
      picker:close()
      vim.cmd("Gitsigns show " .. currentCommit)
    end,
    ["diffview"] = function(picker)
      local currentCommit = picker:current().commit
      picker:close()
      vim.cmd("DiffviewOpen HEAD " .. currentCommit)
    end,
  },
  win = {
    input = {
      keys = {
        ["<CR>"] = {
          "open_file",
          desc = "Open File",
          mode = { "n", "i" },
        },
        ["<c-d>"] = {
          "diffview",
          desc = "Diffview",
          mode = { "n", "i" },
        },
      },
    },
  },
}

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
      -- Make fullscreen
      win = {
        width = 0,
        height = 0,
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 80,
        },
      },
      layout = {
        preset = "ivy",
      },
      matcher = {
        frecency = true,
        history_bonus = true,
      },
      sources = {
        git_log = gitActions,
        git_log_file = gitActions,
        git_log_line = gitActions,
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
                ["l"] = "confirm",
                ["m"] = "explorer_move",
                ["r"] = "explorer_rename",
                ["y"] = "explorer_yank",
              },
            },
          },
        },
      },
      -- debug = {
      --   scores = true,
      -- },
      transform = function(item)
        if not item.file then
          return item
        end

        -- Lower priority for files inside deps/
        if item.file:match("deps/") then
          item.score_add = (item.score_add or 0) - 100
        end

        return item
      end,
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
      snacks_image = {
        relative = "editor",
        col = -1,
      },
    },
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").snacks()
  end,
}
