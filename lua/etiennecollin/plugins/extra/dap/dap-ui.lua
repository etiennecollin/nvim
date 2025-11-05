return {
  "rcarriga/nvim-dap-ui",
  ft = { "cpp", "c", "rust", "python" },
  dependencies = {
    "mfussenegger/nvim-dap",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local virtual_text = require("nvim-dap-virtual-text")

    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
      virtual_text.refresh()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
      virtual_text.refresh()
    end

    dapui.setup({
      floating = {
        border = "rounded",
      },
    })

    require("etiennecollin.core.mappings.plugin").dapui()
  end,
}
