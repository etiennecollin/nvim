return {
  "HakonHarnes/img-clip.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = "PasteImage",
  opts = {
    default = {
      -- File and directory options
      dir_path = "assets",
      extension = "png",
      file_name = "%Y-%m-%d-%H-%M-%S",
      use_absolute_path = false,
      relative_to_current_file = true,

      -- Template options
      template = "$FILE_PATH",
      url_encode_path = true,
      relative_template_path = true,
      use_cursor_in_template = false,
      insert_mode_after_paste = true,

      -- Prompt options
      prompt_for_file_name = true,
      show_dir_path_in_prompt = false,

      -- Image options
      copy_images = true, -- When DnD, copy the image to the assets directory
      download_images = true, -- Download images from the web to the assets directory

      -- Drag and drop options
      drag_and_drop = {
        enabled = true,
        insert_mode = true,
      },
    },
    filetypes = {
      quarto = {
        template = "![$CURSOR]($FILE_PATH)",
      },
      markdown = {
        download_images = true,
      },
    },
  },
  init = function()
    require("etiennecollin.core.mappings.plugin").img_clip()
  end,
}
