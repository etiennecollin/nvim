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

    -- Create commands to enable/disable autoformat-on-save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Enable autoformat-on-save",
    })

    vim.api.nvim_create_user_command("Format", function(opts)
      conform.format({ async = false, timeout_ms = tonumber(opts.fargs[1]) or nil })
    end, {
      desc = "Format current buffer",
      nargs = "?",
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({ async = true }, function(err, did_edit)
        if err then
          vim.notify("Formatting error (buffer edited: " .. tostring(did_edit) .. "): " .. err, vim.log.levels.WARN)
        end
      end)
    end, { desc = "Format buffer" })
  end,
}
