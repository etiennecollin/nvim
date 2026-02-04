return function()
  local api = require("obsidian.api")
  local note = require("obsidian.note")
  local template_exists = vim.fn.filereadable(string.format("%s/weekly_report.md", api.templates_dir())) == 1

  note
    .create({
      aliases = { string.format("Weekly Report - %d, Week %d", os.date("%Y"), os.date("%V")) },
      id = string.format("%d_W%02d", os.date("%Y"), os.date("%V")),
      dir = Obsidian.dir / "weekly-reports",
      tags = { "weekly-report" },
      template = template_exists and "weekly_report" or nil,
      verbatim = true,
      should_write = true,
    })
    :open()
end
