return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "zapling/mason-conform.nvim", dependencies = "mason-org/mason.nvim", config = false },
  cmd = { "ConformInfo" },
  config = function()
    local conform = require("conform")
    local default_timeout_ms = 500
    conform.setup({
      formatters_by_ft = require("etiennecollin.config").ensure_installed_formatters,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = default_timeout_ms, lsp_fallback = true }
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
      local timeout = tonumber(opts.fargs[1]) or default_timeout_ms
      conform.format({ lsp_fallback = true, async = false, timeout_ms = timeout })
    end, {
      desc = "Format current buffer",
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({ lsp_fallback = true, async = false })
    end, { desc = "Format buffer" })
  end,
}
