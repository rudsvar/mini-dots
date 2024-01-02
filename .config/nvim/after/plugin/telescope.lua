require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<c-/>"] = false,
            }
        }
    },
    pickers = {},
    extensions = {}
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<C-h>', builtin.help_tags, {})
