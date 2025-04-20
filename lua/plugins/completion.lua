-- return {
--   "hrsh7th/nvim-cmp",
--   event = "InsertEnter",
--   dependencies = {
--     "hrsh7th/cmp-buffer", -- source for text in buffer
--     "hrsh7th/cmp-path", -- source for file system paths
--     "L3MON4D3/LuaSnip", -- snippet engine
--     "saadparwaiz1/cmp_luasnip", -- for autocompletion
--     "rafamadriz/friendly-snippets", -- useful snippets
--     "onsails/lspkind.nvim", -- vs-code like pictograms
--   },
--   config = function()
--     local cmp = require("cmp")
--     local luasnip = require("luasnip")
--     local lspkind = require("lspkind")
--
--     -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
--     require("luasnip.loaders.from_vscode").lazy_load()
--
--     cmp.setup({
--       completion = {
--         completeopt = "menu,menuone,preview,noselect",
--       },
--       snippet = { -- configure how nvim-cmp interacts with snippet engine
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--       mapping = cmp.mapping.preset.insert({
--         ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
--         ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
--         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
--         ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
--         ["<C-e>"] = cmp.mapping.abort(), -- close completion window
--         ["<CR>"] = cmp.mapping.confirm({ select = true }),
--       }),
--       -- sources for autocompletion
--       sources = cmp.config.sources({
--         { name = "nvim_lsp" },
--         { name = "luasnip" }, -- snippets
--         { name = "buffer" }, -- text within current buffer
--         { name = "path" }, -- file system paths
--       }),
--       -- configure lspkind for vs-code like pictograms in completion menu
--       formatting = {
--         format = lspkind.cmp_format({
--           maxwidth = 50,
--           ellipsis_char = "...",
--         }),
--       },
--     })
--   end,
-- }

return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
    },
    {
        "hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({

                    ["<C-9>"] = cmp.mapping.select_prev_item(),
                    ["<C-0>"] = cmp.mapping.select_next_item(),

                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),

                    -- Tab untuk next completion
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),

                    -- Shift+Tab untuk prev completion
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            vim.fn.feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
                                ""
                            )
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "nvim_lua" },
                }),
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = "buffer" },
                }),
            })

        end,
    },
    -- {
    --     "windwp/nvim-autopairs",
    --     config = function()
    --         require("nvim-autopairs").setup({})
    --         local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    --         local cmp = require("cmp")
    --         cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    --     end,
    -- },
}
