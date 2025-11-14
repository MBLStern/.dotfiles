return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lsp-signature-help' },
        { 'L3MON4D3/LuaSnip' },
        { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function()
        -- luasnip setup
        local ls = require("luasnip")
        vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
        vim.keymap.set({ "i", "s" }, "<M-l>", function() ls.jump(-1) end, { silent = true })


        -- cmp setup
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-r>'] = cmp.mapping.select_next_item(),
                ['<C-f>'] = cmp.mapping.select_prev_item(),
                ['<C-x>'] = cmp.mapping.scroll_docs(4),
                ['<C-z>'] = cmp.mapping.scroll_docs(-4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-E>'] = cmp.mapping.abort(),
                ['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'nvim_lsp_signature_help' }
                },
                {
                    { name = 'buffer' },
                })
        })

        -- lsp setup

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local home = os.getenv('HOME')
        local pid = vim.fn.getpid()
        local clang_root_markers = { "sdkconfig", ".clangd", ".git" }

        vim.lsp.config('lua_ls', {
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath('config')
                        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                    then
                        return
                    end
                end
                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT',
                        path = {
                            'lua/?.lua',
                            'lua/?/init.lua',
                        },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        }
                    }
                })
            end,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                },
            }

        })

        vim.lsp.config("vhdl_ls", {
            on_attach = on_attach,
            capabilities = capabilities
        })

        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    gofumpt = true
                },
            },
            on_attach = on_attach,
            capabilities = capabilities
        })

        if string.find(os.getenv("PATH") or "none", "esp%-idf") ~= nil then
            vim.lsp.config("clangd", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { home .. "/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd",
                    "--compile-commands-dir=" .. vim.fs.root(0, clang_root_markers) .. "/build",
                    "--background-index", "--clang-tidy", "--header-insertion=never", "--completion-style=detailed",
                    "--function-arg-placeholders", "--fallback-style=llvm",
                    "--query-driver=" ..
                    home ..
                    "/.espressif/tools/xtensa-esp-elf/esp-14.2.0_20241119/xtensa-esp-elf/bin/xtensa-esp32-elf-gcc"
                },
                root_markers = clang_root_markers,
            })
        else
            vim.lsp.config("clangd", {
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
                init_options = {
                    fallbackFlags = { '-std=c++17' },
                },
                root_markers = clang_root_markers,
            })
        end

        vim.lsp.config("omnisharp", {
            cmd = { home .. "/.local/share/nvim/mason/packages/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(pid) },
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
            enable_roslyn_analysers = true,
            enable_import_completion = true,
            organize_imports_on_format = true,
            enable_decompilation_support = true,
            filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets', 'tproj', 'slngen', 'fproj' }
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "gopls",
                "jdtls",
                "vhdl_ls",
                "omnisharp",
            },
        })

        require('mason-tool-installer').setup({
            -- Install these linters, formatters, debuggers automatically
            ensure_installed = {
                'java-debug-adapter',
                'java-test',
            },
        })

        -- enable error messages
        vim.diagnostic.config({ virtual_text = true })

        -- keymaps
        vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end)
        vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end)

        -- auto format
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                vim.lsp.buf.format({ async = false })
            end
        })
    end
}
