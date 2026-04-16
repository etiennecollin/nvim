local base_sources = { "lsp", "path", "snippets", "buffer" }
local function merge_sources(a, b)
  return vim.list_extend(vim.deepcopy(a), vim.deepcopy(b))
end
local default_sources = merge_sources(base_sources, { "omni" })

return {
  "saghen/blink.cmp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
    "jmbuhr/cmp-pandoc-references",
    "brenoprata10/nvim-highlight-colors",
  },
  version = "1.*",
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "super-tab" },
    signature = {
      enabled = true,
      window = {
        show_documentation = false,
      },
    },
    cmdline = {
      enabled = true,
      keymap = { preset = "inherit" },
      completion = {
        menu = {
          auto_show = true,
        },
      },
      sources = { "buffer", "cmdline", "path" },
    },
    term = {
      enabled = false,
      keymap = {
        preset = "inherit",
        ["<c-p>"] = false,
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
    sources = {
      default = default_sources,
      per_filetype = {
        typst = merge_sources(default_sources, { "references" }),
        markdown = merge_sources(default_sources, { "references" }),
        lua = merge_sources(default_sources, { "lazydev" }),
        ["dap-repl"] = base_sources,
      },
      providers = {
        snippets = {
          name = "Snippets",
          -- Disable snippets after trigger character
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= "trigger_character"
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        references = {
          name = "pandoc_references",
          module = "cmp-pandoc-references.blink",
        },
      },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
      },
      ghost_text = {
        enabled = false,
      },
      menu = {
        border = "none",
        draw = {
          treesitter = { "lsp" },
          -- Use nvim-highlight-colors to show colors in the menu
          components = {
            kind_icon = {
              text = function(ctx)
                -- Default kind icon
                local icon = ctx.kind_icon
                -- If LSP source, check for color derived from documentation
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= "" then
                    icon = color_item.abbr
                  end
                end
                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                -- Default highlight group
                local highlight = "BlinkCmpKind" .. ctx.kind
                -- If LSP source, check for color derived from documentation
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
