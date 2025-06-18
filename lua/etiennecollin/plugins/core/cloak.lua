return {
  "laytan/cloak.nvim",
  ft = { "asc", "config", "sh", "secret" },
  cmd = { "CloackToggle", "CloakDisable", "CloakEnable", "CloakPreviewLine" },
  opts = {
    cloak_character = "*",
    cloak_length = 8,
    -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
    highlight_group = "Comment",
    patterns = {
      {
        file_pattern = {
          "*.asc",
          "*.env",
          "*.secret",
        },
        cloak_pattern = { "=.+", ":.+" },
      },
    },
  },
}
