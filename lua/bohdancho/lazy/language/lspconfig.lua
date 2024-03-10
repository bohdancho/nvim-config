local M

local capabilities =
    vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    require("lsp_signature").on_attach({}, bufnr)

    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-T>.

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("K", vim.lsp.buf.hover, "Hover")
    map("<leader>lr", require("bohdancho.renamer").open, "Rename")
    map("<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("<leader>d", function()
        vim.diagnostic.open_float { border = "rounded" }
    end, "Floating [d]iagnostic")
    map("[d", function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
    end, "Goto prev")
    map("]d", function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
    end, "Goto next")
end

M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup {
                    ensure_installed = { "lua_ls", "vtsls", "emmet_ls", "tailwindcss" },
                }
            end,
        },
        "yioneko/nvim-vtsls",
        "nvim-lua/plenary.nvim", -- used for bohdancho.renamer
        {
            "ray-x/lsp_signature.nvim",
        },
    },
    config = function()
        local lspconfig = require "lspconfig"
        -- set default server config, optional but recommended
        require("lspconfig.configs").vtsls = require("vtsls").lspconfig

        lspconfig.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
                        },
                        maxPreload = 100000,
                        preloadFileSize = 10000,
                    },
                },
            },
        }
        lspconfig.vtsls.setup { capabilities = capabilities, on_attach = on_attach }
        lspconfig.emmet_ls.setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- expand only on hotkey (excluded from snippets list)
                vim.keymap.set("i", "<C-e>", function()
                    client.request("textDocument/completion", vim.lsp.util.make_position_params(), function(_, result)
                        local textEdit = result[1].textEdit
                        local snip_string = textEdit.newText
                        textEdit.newText = ""
                        vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
                        require("luasnip").lsp_expand(snip_string)
                    end, bufnr)
                end)

                on_attach(client, bufnr)
            end,
        }
        lspconfig.tailwindcss.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                -- add autocomplete in unusual places for classes like cva
                tailwindCSS = { experimental = { classRegex = { { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" } } } },
            },
        }
    end,
}

return M
