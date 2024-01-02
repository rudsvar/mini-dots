require('default.set')
require('default.remap')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.vscode == nil then
    require('default.packer')

    -- Auto save + load folds
    vim.cmd([[
        function! MakeViewCheck()
            if has('quickfix') && &buftype =~ 'nofile'
                " Buffer is marked as not a file
                return 0
            endif
            if empty(glob(expand('%:p')))
                " File does not exist on disk
                return 0
            endif
            return 1
        endfunction
        augroup vimrcAutoView
            autocmd!
            " Autosave & Load Views.
            autocmd BufWritePost,BufLeave,BufWinLeave,WinLeave ?* if MakeViewCheck() | mkview! | endif
            autocmd BufWinEnter ?* if MakeViewCheck() | normal! zx
            autocmd BufWinEnter,BufWritePost ?* if MakeViewCheck() | silent! loadview | endif
        augroup end
    ]])

    vim.cmd([[
        augroup AutoFormat
            au!
            au BufWritePre * :lua vim.lsp.buf.format()
        augroup END
    ]])

end
