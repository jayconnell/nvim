return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "marilari88/neotest-vitest",
        "V13Axel/neotest-pest",
    },
    config = function()
        local neotest = require("neotest")
        neotest.setup({
            adapters = {
                require("neotest-vitest"),
                require("neotest-pest")({
                    ignore_dirs = { "vendor", "node_modules" },
                    root_ignore_files = { "phpunit-only.tests" },
                }),
            }
        })

        vim.keymap.set("n", "<leader>tn", function()
            neotest.run.run()
        end)

        vim.keymap.set("n", "<leader>tf", function()
            neotest.run.run(vim.fn.expand("%"))
        end)


        vim.keymap.set("n", "<leader>ts", function()
            neotest.run.run({ suite = true })
        end)
    end,
}

