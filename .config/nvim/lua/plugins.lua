-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd 'packadd packer.nvim'
end

-- Plugins
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'

    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-vsnip'

    use 'joshdick/onedark.vim'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'tpope/vim-dispatch'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-sensible'
    use 'tpope/vim-sleuth'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'folke/trouble.nvim'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() require 'nvim-tree'.setup {} end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'arkav/lualine-lsp-progress'

    use 'simrat39/rust-tools.nvim'

    -- Debugging
    use 'mfussenegger/nvim-dap'
end)

-- TODO: Move to config
require 'nvim-tree'.setup {}
require('lualine').setup {
    options = { theme = 'codedark' },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 }, 'lsp_progress' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
}
require('telescope').setup {
    defaults = {
        path_display = { "truncate" }
    }
}

-- On attach for language servers
local on_attach = function(client, bufnr)
    vim.o.completeopt = 'menu,menuone,noselect'
    vim.o.shortmess = vim.o.shortmess .. 'c'
    vim.o.updatetime = 10
end

-- nvim-cmp
local cmp = require 'cmp'

local if_visible = function(f)
    return function(fallback)
        if cmp.visible() then
            f()
        else
            fallback()
        end
    end
end

local select_next_item = if_visible(cmp.select_next_item)
local select_prev_item = if_visible(cmp.select_prev_item)

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = select_next_item,
        ['<down>'] = select_next_item,
        ['<C-p>'] = select_prev_item,
        ['<up>'] = select_prev_item
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = "nvim_lsp_signature_help" },
        -- { name = 'vsnip' },
        -- { name = 'buffer' },
    }
})

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
})

-- nvim-lsp-installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.setup({
    ensure_installed = { "rust_analyzer", "sumneko_lua", "jdtls" }
})

-- Lsp config
local lspconfig = require("lspconfig")

lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim", "use", "foo" }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
}

local rust_tools = require("rust-tools");
rust_tools.setup {};
rust_tools.inlay_hints.enable();


vim.cmd [[
    nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

    " Quick-fix
    nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>
    nnoremap <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <silent> g<space>  <cmd>lua vim.lsp.buf.formatting()<CR>

    augroup AutoFormat
        au!
        au BufWritePre * :lua vim.lsp.buf.format()
    augroup END

    nnoremap <silent> <C-s> :w<CR>
    inoremap <silent> <C-s> <ESC>:w<CR>
]]

-- Keybinds
vim.cmd('nnoremap <C-p> :Telescope git_files<CR>')
vim.cmd('nnoremap <C-f> :Telescope live_grep<CR>')
vim.cmd('noremap <C-_> :Commentary<CR>')
