return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  opts = {
    dependencies_bin = { ["tinymist"] = "tinymist" }, -- Installed by mason
    get_root = function()
      return os.getenv("HOME")
    end,
  },
}
