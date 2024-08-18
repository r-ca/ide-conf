return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason-lspconfig.nvim',
        'williamboman/mason.nvim',
    },
    config = function()
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local lspconfig = require('lspconfig')

        local capabilities = require('lsp.external.handler').capabilities;
        local on_attach = function(client, bufnr)
            require('lsp.external.handler').on_attach(client, bufnr)
        end


        mason.setup({
            ensure_installed = {
                "css-lsp",
                "css-variables-language-server",
                "docker-compose-language-server",
                "dockerfile-language-sevice",
                "gopls",
                "html-lsp",
                "htmlhint",
                "intelephense",
                "jdtls",
                "kotlin-language-server",
                "lua-language-server",
                "prisma-language-server",
                "typescript-language-server",
                "vue-language-server",
            },
        })
        mason_lspconfig.setup()
        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    -- autostart = true,
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,

            -- Javaは別で設定しているので
            jdtls = function()
            end,

            tsserver = function()
                local vue_typescript_plugin = require("mason-registry").get_package("vue-language-server")
                    :get_install_path() .. "/node_modules/@vue/language-server"
                -- local vue_typescript_plugin = os.getenv("HOME") .. "/.local/share/mise/installs/node/20/lib/node_modules/@vue/language-server"
                -- debug log for check path
                print(vue_typescript_plugin)
                lspconfig.tsserver.setup({
                    init_options = {
                        plugins = {
                            {
                                name = "@vue/typescript-plugin",
                                location = vue_typescript_plugin,
                                languages = { "javascript", "typescript", "vue" },
                            },
                        },
                    },
                    filetypes = {
                        "javascript", "typescript", "vue"
                    },
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end,
        })
    end,
}
