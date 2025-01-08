return {
    "crispgm/nvim-tabline",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require('tabline').setup({
            show_index = true,
            show_modify = true,
            show_icon = false,
            fnamemodify = ':t',
            modify_indicator = '[+]',
            no_name = 'No name',
            brackets = { '', '' },
            inactive_tab_max_length = 0
        })
    end,
}
