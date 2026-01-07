local IMG_PATH = vim.fn.expand("~/Pictures/wallpapers/a_moonlit_night_at_sea.jpg")
local function pdw_viewer_command(file, page)
  return { "flatpak", "run", "com.github.ahrm.sioyek", file, "--page", tostring(page) }
end

local git_actions = {
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

local rga_source = {
  title = "Ripgrep-All",
  finder = require("etiennecollin.plugins.core.snacks-pickers.ripgrep-all").finder,
  formatter = require("etiennecollin.plugins.core.snacks-pickers.ripgrep-all").formatter,
  format = "file",
  preview = "file",
  regex = true,
  show_empty = true,
  live = true, -- live grep by default
  supports_live = true,
  actions = {
    open = function(picker, item)
      picker:close()
      if item.ext == "pdf" then
        -- Open PDF at the correct page
        vim.fn.jobstart(pdw_viewer_command(item.file, item.page), { detach = true })
      else
        vim.cmd(("edit +%d %s"):format(item.pos[1], vim.fn.fnameescape(item.file)))
      end
    end,
  },
  win = {
    input = {
      keys = {
        ["<CR>"] = { "open", mode = { "n", "i" } },
      },
    },
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  ---@type snacks.picker.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "a", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Restore Session", section = "session" },
          { icon = " ", key = "sf", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
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
            key = "sc",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          {
            icon = " ",
            key = "zm",
            desc = "Mason",
            action = ":Mason",
          },
          {
            icon = "󰒲 ",
            key = "zl",
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
    picker = {
      enabled = true,
      -- layout = {
      --   preset = "ivy",
      --   layout = { title = "{title} {live} {flags} - {preview}" },
      -- },
      matcher = {
        frecency = true,
        history_bonus = true,
      },
      previewers = {
        diff = {
          style = "terminal",
          cmd = { "delta" },
        },
      },
      sources = {
        git_log = git_actions,
        git_log_file = git_actions,
        git_log_line = git_actions,
        rga = rga_source,
        explorer = {
          auto_close = true,
          layout = { preset = "ivy", preview = true },
          matcher = { fuzzy = true },
          actions = {
            yank_relative_cwd = function(_, item)
              local path = vim.fn.fnamemodify(item.file, ":.")
              vim.fn.setreg("+", path)
              vim.fn.setreg('"', path)
              vim.notify("Yanked: " .. path)
            end,
            yank_relative_home = function(_, item)
              local path = vim.fn.fnamemodify(item.file, ":~")
              vim.fn.setreg("+", path)
              vim.fn.setreg('"', path)
              vim.notify("Yanked: " .. path)
            end,
          },
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
                ["<c-o>"] = "explorer_yank",
                ["y"] = "yank_relative_cwd",
                ["Y"] = "yank_relative_home",
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
    animate = {
      enabled = true,
      fps = 120,
    },
    bigfile = {
      enabled = true,
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
