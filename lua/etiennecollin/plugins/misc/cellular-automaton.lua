return {
  "eandrju/cellular-automaton.nvim",
  cmd = "CellularAutomaton",
  dependencies = "nvim-treesitter/nvim-treesitter",
  inidt = function()
    require("etiennecollin.core.mappings.plugin").cellular_automaton()
  end,
}
