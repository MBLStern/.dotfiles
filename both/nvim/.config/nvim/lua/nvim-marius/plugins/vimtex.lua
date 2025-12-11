return {
    'lervag/vimtex',
    lazy = false,
    ft = "tex",
    init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "zathura"
        vim.cmd("filetype plugin on")
    end
}
