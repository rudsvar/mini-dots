vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.o.foldmethod = 'expr'                     -- Enable capability to customise Neovim's fold method
vim.o.foldexpr = 'nvim_treesitter#foldexpr()' -- Use Treesitter's built-in folding method
vim.o.foldnestmax = 10                        -- Fold's won't be applied to nesting deeper than 10 levels
vim.o.foldlevel = 99
