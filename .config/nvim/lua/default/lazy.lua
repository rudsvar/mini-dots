-- Lazy
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
    -- Search
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- Colorscheme
    { 'navarasu/onedark.nvim' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        config = function()
            require('lualine').setup({
                sections = {
                    lualine_c = {
                        'filename',
                        {
                            function()
                                local ok, clients = pcall(vim.lsp.get_clients, { bufnr = 0 })
                                if not ok or not clients or #clients == 0 then
                                    return ""
                                end
                                local names = {}
                                for _, client in ipairs(clients) do
                                    if client and client.name then
                                        table.insert(names, client.name)
                                    end
                                end
                                if #names == 0 then
                                    return ""
                                end
                                return table.concat(names, " ")
                            end,
                        },
                    },
                }
            })
        end
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', lazy = false, build = ':TSUpdate' },

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

})
