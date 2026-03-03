return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "zapling/mason-conform.nvim", dependencies = "mason-org/mason.nvim", config = false },
  cmd = { "ConformInfo" },
  config = function()
    local default_timeout_ms = 500

    local conform = require("conform")
    conform.setup({
      default_format_opts = {
        lsp_format = "fallback",
        timeout_ms = default_timeout_ms,
      },
      format_after_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { lsp_format = "fallback", timeout_ms = default_timeout_ms }
      end,
      formatters = {
        black = {
          prepend_args = { "--line-length=120" },
        },
        clang_format = {
          prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
        },
        google_java_format = {
          prepend_args = { "--aosp" },
        },
        prettier = {
          prepend_args = { "--tab-width=2" },
        },
      },
      formatters_by_ft = require("etiennecollin.config").ensure_installed_formatters,
    })

    -- Install formatters with mason
    require("mason-conform").setup()

    -- Format mapping
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({ async = true }, function(err, did_edit)
        if err then
          vim.notify("Formatting error (buffer edited: " .. tostring(did_edit) .. "): " .. err, vim.log.levels.WARN)
        end
      end)
    end, { desc = "Format buffer" })

    local function enable_autoformat(enable, buff_local)
      buff_local = buff_local or false

      vim.b.disable_autoformat = not enable
      if not buff_local then
        vim.g.disable_autoformat = not enable
      end
      local state = enable and "enabled" or "disabled"
      vim.notify("Autoformat " .. state, vim.log.levels.INFO)
    end

    -- Toggle autoformat
    local autoformat_enabled = true
    vim.keymap.set({ "n", "v" }, "<leader>F", function()
      autoformat_enabled = not autoformat_enabled
      enable_autoformat(autoformat_enabled, false)
    end, { desc = "Toggle autoformat-on-save" })

    -- Create commands to enable/disable autoformat-on-save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      enable_autoformat(false, args.bang)
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function(args)
      enable_autoformat(true, args.bang)
    end, {
      desc = "Enable autoformat-on-save",
      bang = true,
    })

    -- Create command to format buffer
    vim.api.nvim_create_user_command("Format", function(opts)
      conform.format({ async = false, timeout_ms = tonumber(opts.fargs[1]) or nil })
    end, {
      desc = "Format current buffer",
      nargs = "?",
    })
  end,
}
