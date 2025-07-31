-- Packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
    -- Utilities
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'tpope/vim-fugitive',
    'tpope/vim-unimpaired',
    'tpope/vim-eunuch',
    'tpope/vim-sleuth',
    'tpope/vim-repeat',
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },
    'airblade/vim-gitgutter',
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            -- Auto close nvim tree
            vim.api.nvim_create_autocmd("BufEnter", {
                nested = true,
                callback = function()
                    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
                        vim.cmd "quit"
                    end
                end
            })
            require('nvim-tree').setup {
                update_focused_file = { enable = true },
                diagnostics = { enable = true },
                view = { width = 50 }
            }
        end,
    },

    -- Search
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
    },

    -- Colorscheme
    { 'navarasu/onedark.nvim' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        config = function()
            require('lualine').setup({})
        end
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', cmd = 'TSUpdate' },
    'nvim-treesitter/playground',

    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- LSP
    { 'neovim/nvim-lspconfig' },
    
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },
    {
        'github/copilot.vim',
        init = function()
            vim.g.copilot_no_tab_map = true
            vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        end,
        -- Lazy-load on a command
        cmd = "Copilot",
    },

    {
        -- Database UI. Remember to add connections to local .vimrc, like this.
        --
        -- let g:dbs = {
        -- \ 'dev': 'postgres://postgres:password@localhost:5432/axum-demo',
        -- \ }
        --
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_auto_execute_table_helpers = 1
            vim.cmd [[
                autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
            ]]
        end,
    }
})
