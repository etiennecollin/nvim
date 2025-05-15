return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  opts = {},
  init = function()
    require("etiennecollin.core.mappings.plugin").grug_far()
  end,
}
