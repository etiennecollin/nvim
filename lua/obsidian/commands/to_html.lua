local function pandoc_preview_current_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = buf }) or ""

  -- Accept common markdown filetypes
  if not (ft == "markdown" or ft == "md") then
    vim.notify("Buffer filetype is not markdown (detected: " .. ft .. ")", vim.log.levels.ERROR)
    return
  end

  if vim.fn.executable("pandoc") == 0 then
    vim.notify("pandoc not found in PATH. Please install pandoc.", vim.log.levels.ERROR)
    return
  end

  -- Collect markdown source
  local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")

  -- Run pandoc, writing HTML to stdout
  vim.system({ "pandoc", "-f", "markdown", "-t", "html", "-s" }, { stdin = input, text = true }, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify("pandoc failed:\n" .. (result.stderr or "<no output>"), vim.log.levels.ERROR)
      end)
      return
    end

    vim.schedule(function()
      -- Create scratch buffer
      local html_buf = vim.api.nvim_create_buf(false, true)

      -- Open in split
      vim.cmd("vsplit")
      vim.api.nvim_win_set_buf(0, html_buf)

      -- Populate buffer
      vim.api.nvim_buf_set_lines(html_buf, 0, -1, false, vim.split(result.stdout, "\n", { plain = true }))

      -- Buffer settings
      vim.bo[html_buf].filetype = "html"
      vim.bo[html_buf].bufhidden = "wipe"
      vim.bo[html_buf].swapfile = false
    end)
  end)
end

return pandoc_preview_current_buffer
