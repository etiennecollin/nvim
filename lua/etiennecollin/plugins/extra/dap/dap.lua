return {
  "mfussenegger/nvim-dap",
  ft = { "cpp", "c", "rust", "python" },
  cmd = { "DapNew" },
  dependencies = {
    { "jay-babu/mason-nvim-dap.nvim", dependencies = "mason-org/mason.nvim", config = false },
  },
  config = function()
    -----------------------------------------------------------------------
    -- Install DAPs with mason
    -----------------------------------------------------------------------
    require("mason-nvim-dap").setup({
      ensure_installed = require("etiennecollin.config").ensure_installed_daps,
      automatic_installation = true,
      automatic_setup = true,
      handlers = {}, -- Keep this line to generate default handlers
    })

    -----------------------------------------------------------------------
    -- Setup DAP
    -----------------------------------------------------------------------
    local dap = require("dap")

    -- Enable debugging threads
    dap.defaults.fallback.auto_continue_if_many_stopped = false

    -- Fix `attach` for debugpy
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"

        ---@type dap.ServerAdapter
        local adapter = {
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = {
            source_filetype = "python",
          },
        }
        cb(adapter)
      else
        ---@type dap.ExecutableAdapter
        local adapter = {
          type = "executable",
          command = vim.fn.exepath("debugpy-adapter"),
          args = {},
          options = {
            source_filetype = "python",
          },
        }
        cb(adapter)
      end
    end
    dap.adapters.debugpy = dap.adapters.python

    -- Setup mappings
    require("etiennecollin.core.mappings.plugin").dap()

    vim.api.nvim_set_hl(0, "DapStoppedLine", {
      default = true,
      link = "Visual",
    })

    local signs = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = { " ", "DiagnosticInfo", nil },
      BreakpointCondition = { " ", "DiagnosticInfo", nil },
      BreakpointRejected = { " ", "DiagnosticError", nil },
      LogPoint = { ".>", "DiagnosticInfo", nil },
    }

    for name, sign in pairs(signs) do
      vim.fn.sign_define("Dap" .. name, {
        text = sign[1],
        texthl = sign[2],
        linehl = sign[3],
        numhl = sign[3],
      })
    end
  end,
}
