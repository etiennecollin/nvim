return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    default_mappings = true,
    default_commands = true,
    disable_diagnostics = false,
    list_opener = "copen",
    highlights = {
      incoming = "DiffAdd",
      ancestor = "DiffChange",
      current = "DiffText",
    },
  },
  init = function()
    local group_conflict = vim.api.nvim_create_augroup("etiennecollin-git-conflicts", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group_conflict,
      pattern = "GitConflictDetected",
      callback = function(event)
        local buf_name = vim.api.nvim_buf_get_name(event.buf)
        vim.notify("Conflict detected in " .. buf_name, vim.log.levels.WARN)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group_conflict,
      pattern = "GitConflictResolved",
      callback = function(event)
        local buf_name = vim.api.nvim_buf_get_name(event.buf)
        vim.notify("Conflicts resolved in " .. buf_name, vim.log.levels.INFO)
      end,
    })
  end,
}
