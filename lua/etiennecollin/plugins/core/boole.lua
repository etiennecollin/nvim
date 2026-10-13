return {
  "nat-418/boole.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    mappings = {
      -- increment = nil,
      -- decrement = nil,
      increment = "<c-a>",
      decrement = "<c-x>",
    },
    -- User defined loops
    -- additions = {
    -- 	{ "Foo", "Bar" },
    -- 	{ "tic", "tac", "toe" },
    -- },
    allow_caps_additions = {
      { "enable", "disable" },
      -- enable → disable
      -- Enable → Disable
      -- ENABLE → DISABLE
    },
  },
}
