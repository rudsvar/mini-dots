-- Packer
vim.cmd [[packadd packer.nvim]]

-- Plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Utilities
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-repeat'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- Search
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { 'nvim-lua/plenary.nvim' },
    }
    use {
        "folke/trouble.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
    }

    -- Colorscheme
    use { 'navarasu/onedark.nvim' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({})
        end
    }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/playground'

    -- Lsp
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            { 'williamboman/mason.nvim' }, -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' }, -- Optional
            { 'hrsh7th/cmp-path' }, -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' }, -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }
    use {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                }
            })
        end
    }
end)
