--- Return the Monday of the first week of the year according to ISO 8601
local function find_first_monday(iso_year)
  -- Using ISO 8601, Jan 4 is always in week 1
  local jan4 = os.time({ year = iso_year, month = 1, day = 4 })
  -- 1..7 (Mon..Sun)
  local jan4_weekday = tonumber(os.date("%u", jan4))
  -- Monday of ISO week 1
  return jan4 - (jan4_weekday - 1) * 86400
end

-- ISO 8601 offset a week by X weeks
local function shift_iso_week(iso_year, iso_week, offset)
  local week1_monday = find_first_monday(iso_year)
  local target = week1_monday + (iso_week - 1 + offset) * 7 * 86400
  return tonumber(os.date("%G", target)), tonumber(os.date("%V", target))
end

-- Return date given ISO year, ISO week and ISO weekday (1=Mon .. 7=Sun) using ISO 8601
local function find_iso_week_day(iso_year, iso_week, iso_weekday)
  local week1_monday = find_first_monday(iso_year)
  return week1_monday + (iso_week - 1) * 7 * 86400 + (iso_weekday - 1) * 86400
end

-- Return current ISO 8601 year and week
local function current_iso_week_and_year()
  local now = os.time()
  return tonumber(os.date("%G", now)), tonumber(os.date("%V", now))
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = "Obsidian",
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/vaults/*.md",
  },
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    ---@diagnostic disable-next-line: missing-fields
    ui = { enable = false }, -- Because we're using markview.nvim
    workspaces = {
      {
        name = "work",
        path = "~/vaults/work",
      },
    },
    picker = {
      name = "snacks.pick",
    },
    comment = {
      enabled = true,
    },
    callbacks = {
      enter_note = function()
        vim.keymap.del("n", "<CR>", { buffer = true })
        vim.keymap.set(
          "n",
          "<leader>m<CR>",
          require("obsidian.actions").smart_action,
          { buffer = true, desc = "Smart Action" }
        )
      end,
    },
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d-%a",
      alias_format = nil,
      default_tags = { "daily-notes" },
    },
    note_id_func = function(id)
      local date = os.date("%Y_%m_%d")
      local formatted_id = id:gsub("[%s-.]+", "_"):gsub("__+", "_"):gsub("^_", ""):gsub("_$", ""):lower() or "unset"

      local random_id = ""
      for _ = 1, 4 do
        random_id = random_id .. string.char(math.random(65, 90))
      end

      local filename = date .. "_" .. random_id .. "_" .. formatted_id .. ".md"
      return filename
    end,
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d %a",
      time_format = "%H:%M:%S",
      substitutions = {
        last_friday = function(ctx)
          local y, w = current_iso_week_and_year()
          -- 1..7 (Mon..Sun)
          local today_weekday = tonumber(os.date("%u"))

          -- If before Friday, go to previous ISO week
          if today_weekday < 5 then
            y, w = shift_iso_week(y, w, -1)
          end

          local timestamp = find_iso_week_day(y, w, 5) -- Friday (day 5)
          local fmt = (ctx.template_opts and ctx.template_opts.date_format) or "%Y-%m-%d"
          return tostring(os.date(fmt, timestamp))
        end,
        this_thursday = function(ctx)
          local y, w = current_iso_week_and_year()
          -- 1..7 (Mon..Sun)
          local today_weekday = tonumber(os.date("%u"))

          -- If after Thursday, go to next ISO week
          if today_weekday > 4 then
            y, w = shift_iso_week(y, w, 1)
          end

          local timestamp = find_iso_week_day(y, w, 4) -- Thursday
          local fmt = ctx.template_opts.date_format or "%Y-%m-%d"
          return tostring(os.date(fmt, timestamp))
        end,
      },
    },
  },
  config = function(_, opts)
    -- Make sure workspaces exist
    for _, ws in ipairs(opts.workspaces or {}) do
      local ws_path = vim.fn.expand(ws.path)
      if vim.fn.isdirectory(ws_path) == 0 then
        vim.fn.mkdir(ws_path, "p")
      end
    end

    require("obsidian").setup(opts)
    require("obsidian").register_command("weekly_report", { nargs = 0 })
    require("obsidian").register_command("to_html", { nargs = 0 })
  end,
}
