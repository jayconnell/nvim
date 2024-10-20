return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "b0o/schemastore.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "intelephense",
                "volar",
                "ts_ls",
                "tailwindcss",
                "jsonls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                intelephense = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        commands = {
                            IntelephenseIndex = {
                                function()
                                    vim.lsp.buf.execute_command({ command = "intelephense.index.workspace" })
                                end
                            },
                        },
                        capabilities = capabilities,
                    }
                end,

                -- Vue, JavaScript and Typescript
                volar = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.volar.setup {
                        on_attach = function(client, bufnr)
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                        end,
                        capabilities = capabilities,
                    }
                end,

                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup {
                        init_options = {
                            plugins = {
                                {
                                    name = "@vue/typescript-plugin",
                                    location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
                                    languages = { "javascript", "typescript", "vue" },
                                },
                            },
                        },
                        filetypes = {
                            "javascript",
                            "javascriptreact",
                            "javascript.jsx",
                            "typescript",
                            "typescriptreact",
                            "typescript.tsx",
                            "vue",
                        },
                    }
                end,

                tailwindcss = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tailwindcss.setup {
                        capabilities = capabilities,
                    }
                end,

                jsonls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.jsonls.setup {
                        settings = {
                            json = {
                                schemas = require('schemastore').json.schemas(),
                            },
                        },
                        capabilities = capabilities,
                    }
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
