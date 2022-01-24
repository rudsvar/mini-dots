if !exists('g:vscode')
    lua require 'plugins'
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set undofile
set noswapfile
set nobackup

set number
set signcolumn=no

set nofoldenable
set foldmethod=syntax

" Autocommands
set viewoptions=folds,cursor
augroup AutoView
    au!
    au BufWinLeave *.* mkview
    au BufWinEnter *.* silent! loadview
augroup END

" Colors
set termguicolors

colorscheme onedark

hi Normal guibg=none
hi NormalFloat guibg=#212121
hi StatusLine guibg=none
