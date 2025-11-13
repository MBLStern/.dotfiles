return {
    "avalonia",
    config = function()
        local home = os.getenv('HOME')
        local avalonia_lsp_bin = home ..
            "/.local/share/nvim/lazy/avalonia/avaloniaServer/AvaloniaLanguageServer"
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            pattern = { "*.axaml" },
            callback =
                function()
                    vim.cmd.setfiletype("xml")
                    vim.lsp.start({
                        name = "Avalonia LSP",
                        cmd = { "dotnet", avalonia_lsp_bin },
                        root_dir = vim.fn.getcwd(),
                    })
                end
        })
    end
}
