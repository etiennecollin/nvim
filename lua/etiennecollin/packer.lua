-- Shortcut to get the config file of a plugin
-- function get_config(fileName)
--   return function()
--     require("etiennecollin/config/" .. fileName)
--   end
-- end
function get_config(fileName)
    return string.format('require("etiennecollin/config/%s")', fileName)
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    -- Required by null-ls and used by other plugins
    use("nvim-lua/plenary.nvim")

    -------------------------
    -------------------------
    -- Theme & Customization
    -------------------------
    -------------------------

    -- Color theme
    use({
        "Mofiqul/dracula.nvim",
        as = "dracula",
        config = get_config("dracula")
    })

    -------------------------
    -------------------------
    -- Project management
    -------------------------
    -------------------------

    -- File browser
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        -- or                            , branch = "0.1.x",
        requires = {{"nvim-lua/plenary.nvim"}}
    })

    -- Better file navigation and adds marks
    use({"theprimeagen/harpoon"})

    -------------------------
    -------------------------
    -- Language support
    -------------------------
    -------------------------

    -- Syntax highlighting
    use({
        "nvim-treesitter/nvim-treesitter",
        config = get_config("treesitter"),
        run = ":TSUpdate"
    })

    -- Setup LSP
    use({
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = { -- LSP Support
        {"neovim/nvim-lspconfig"}, -- Required
        {"williamboman/mason.nvim"}, -- Optional
        {"williamboman/mason-lspconfig.nvim"}, -- Optional
        -- Autocompletion
        {"hrsh7th/nvim-cmp"}, -- Required
        {"hrsh7th/cmp-nvim-lsp"}, -- Required
        {"hrsh7th/cmp-buffer"}, -- Optional
        {"hrsh7th/cmp-path"}, -- Optional
        {"saadparwaiz1/cmp_luasnip"}, -- Optional
        {"hrsh7th/cmp-nvim-lua"}, -- Optional
        -- Snippets
        {"L3MON4D3/LuaSnip"}, -- Required
        {"rafamadriz/friendly-snippets"}, -- Optional
        -- Handle Rust language server
        {"simrat39/rust-tools.nvim"}, -- Required for rust_analyzer
        -- DAP
        {"mfussenegger/nvim-dap"}, -- Optional
        -- Linter and Formatter
        {"jose-elias-alvarez/null-ls.nvim"}, -- Required
        {"jay-babu/mason-null-ls.nvim"}}, -- Required to link null-ls to mason
        config = get_config("lsp")
    })

    -- LaTeX support
    use({
        "lervag/vimtex",
        config = get_config("vimtex")
    })

    -------------------------
    -------------------------
    -- Language specific
    -------------------------
    -------------------------

    -- Markdown
    -- Quick preview
    use({
        "ellisonleao/glow.nvim",
        config = get_config("glow")
    })
    -- Complete preview
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
        setup = get_config("markdownpreview")
    })

    -------------------------
    -------------------------
    -- Other Plugins
    -------------------------
    -------------------------

    use({
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = get_config("toggleterm")
    })

    -------------------------
    -------------------------
    -- Bindings
    -------------------------
    -------------------------

    use({
        "folke/which-key.nvim",
        config = get_config("whichkey")
    })

end)
