return {
    "quarto-dev/quarto-nvim",
    opts = {
        lspFeatures = {
            languages = { "r", "python", "julia", "bash", "html", "lua" },
        },
    },
    ft = "quarto",
    keys = {
        { "<leader>ma",   "<cmd>QuartoActivate<cr>",                    desc = "Quarto activate" },
        { "<leader>mp",   "<cmd>QuartoPreview<cr>",                     desc = "Quarto preview" },
        { "<leader>mq",   "<cmd>QuartoClosePreview<cr>",                desc = "Quarto close" },
        { "<leader>me",   "<cmd>lua require('otter').export()<cr>",     desc = "Quarto export" },
        { "<leader>mE",   "<cmd>lua require('otter').export(true)<cr>", desc = "Quarto export overwrite" },
        { "<leader>mrr",  "<cmd>QuartoSendAbove<cr>",                   desc = "Quarto run to cursor" },
        { "<leader>mra",  "<cmd>QuartoSendAll<cr>",                     desc = "Quarto run all" },
        { "<leader><cr>", "<Plug>SlimeSendCell<cr>",                    desc = "Send code chunk" },
        {
            "<leader><cr>",
            "<Plug>SlimeRegionSend<cr>",
            mode = "v",
            desc = "Send code chunk",
        },
    },
    dependencies = {
        {
            "jmbuhr/otter.nvim",
            ft = "quarto",
            opts = {
                buffers = {
                    set_filetype = true,
                },
            },
        },
    },
}
