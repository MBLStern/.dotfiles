return {
    "mfussenegger/nvim-jdtls",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    ft = "java",
    config = function()
        local jdtls = require('jdtls')
        local home = os.getenv("HOME")
        local system_os = "linux"
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = home .. "/eclipse-workspace/" .. project_name
        local bundles = {
            vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
        }

        vim.list_extend(bundles,
            vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", true), "\n"))

        local javaConfig = {
            cmd = {
                "/usr/bin/java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx4g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",

                -- Eclipse jdtls location
                "-jar",
                home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
                "-configuration",
                home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. system_os,
                "-data",
                workspace_dir,
            },
            --root_dir = vim.fs.dirname(vim.fs.find({ ".git", ".svn", "mvnw", "gradlew", ".project", ".classpath" }, { upward = true })[1]),
            root_dir = require("jdtls.setup").find_root({ ".git", ".svn", "mvnw", "gradlew", ".project", ".classpath" }),
            init_options = {
                bundles = bundles,
                extendedClientCapabilities = jdtls.extendedClientCapabilities,
            },
            settings = {
                java = {
                    home = "/usr/lib/jvm/java-21-openjdk",
                    eclipse = {
                        downloadSources = true,
                    },
                    configuration = {
                        runtimes = {
                            {
                                name = "JavaSE-1.8",
                                path = "/usr/lib/jvm/java-8-openjdk/",
                            },
                            {
                                name = "JavaSE-17",
                                path = "/usr/lib/jvm/java-17-openjdk/",
                            },
                            {
                                name = "JavaSE-21",
                                path = "/usr/lib/jvm/java-21-openjdk/",
                                default = true,
                            },
                        },
                    },
                    references = {
                        includeDecompiledSources = true,
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    signatureHelp = { enabled = true },
                    completion = {
                        favoriteStaticMembers = {
                            "org.hamcrest.MatcherAssert.assertThat",
                            "org.hamcrest.Matchers.*",
                            "org.hamcrest.CoreMatchers.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "java.util.Objects.requireNonNull",
                            "java.util.Objects.requireNonNullElse",
                            "org.mockito.Mockito.*",
                        },
                        importOrder = {
                            "java",
                            "javax",
                            "com",
                            "org",
                        },
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        useBlocks = true,
                    },
                },
            },
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }

        local opts = { silent = true }
        vim.keymap.set('n', "<A-o>", jdtls.organize_imports, opts)
        vim.keymap.set('n', "<leader>tc", jdtls.test_class, opts)
        vim.keymap.set('n', "<leader>tn", jdtls.test_nearest_method, opts)

        javaConfig["on_attach"] = function(client, bufnr)
            jdtls.setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs()
        end

        vim.api.nvim_create_augroup("Java", { clear = true })
        vim.api.nvim_create_autocmd("Filetype", {
            pattern = "java",
            callback = function()
                jdtls.start_or_attach(javaConfig)
            end,
        })
    end
}
