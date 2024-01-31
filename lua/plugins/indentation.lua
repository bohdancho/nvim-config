return {
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "v2.20.8",
        opts = {
            show_trailing_blankline_indent = true,
            show_first_indent_level = true,
        },
    },
    {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    },
}
