return {
  "theHamsta/nvim-dap-virtual-text",
  ft = { "cpp", "c", "rust" },
  dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
  opts = {
    -- Create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    enable_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = true,
    only_first_definition = false,
    all_references = false,
    clear_on_continue = false,
    virt_text_pos = "eol", -- vim.fn.has("nvim-0.10") == 1 and "inline" or "eol"
  },
}
