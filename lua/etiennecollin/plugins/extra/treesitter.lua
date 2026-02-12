return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)

    local installed_parsers = require("nvim-treesitter.config").get_installed("parsers")
    local ensure_installed_parsers = require("etiennecollin.config").ensure_installed_treesitter

    -- Find missing parsers
    local not_installed = vim.tbl_filter(function(parser)
      return not vim.tbl_contains(installed_parsers, parser)
    end, ensure_installed_parsers)

    -- Install missing parsers
    if #not_installed > 0 then
      require("nvim-treesitter").install(not_installed)
    end

    local function treesitter_start(bufnr, parser_name)
      -- Enable syntax highlighting
      vim.treesitter.start(bufnr, parser_name)

      -- Enable regex syntax highlighting
      vim.bo[bufnr].syntax = "on"

      -- Set fold method
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

      -- Indent is experimental
      vim.bo[bufnr].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    end

    -- Register autocmd
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "*" },
      group = vim.api.nvim_create_augroup("etiennecollin-treesitter", { clear = true }),
      callback = function(event)
        -- Get parser name
        local bufnr = event.buf
        local ft = event.match
        local parser_name = vim.treesitter.language.get_lang(ft)

        -- Check if a parser exists for lang
        if not vim.tbl_contains(require("nvim-treesitter.config").get_available(), parser_name) then
          return
        end

        -- Install parser if needed
        if not vim.tbl_contains(installed_parsers, parser_name) then
          vim.notify("Installing parser for " .. parser_name, vim.log.levels.INFO)
          require("nvim-treesitter").install({ parser_name }):await(function()
            treesitter_start(bufnr, parser_name)
          end)
          return
        end

        treesitter_start(bufnr, parser_name)
      end,
      desc = "Enable treesitter features if parser is available",
    })
  end,
}
