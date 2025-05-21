return {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar", "GrugFarWithin" },
  init = function()
    require("etiennecollin.core.mappings.plugin").grug_far()
  end,
}
