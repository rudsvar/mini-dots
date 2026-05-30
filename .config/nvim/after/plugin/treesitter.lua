-- Treesitter config (nvim-treesitter `main` branch API)

-- Install parsers (no-op if already installed; runs asynchronously)
require('nvim-treesitter').install({
    "c", "lua", "vim", "rust", "java", "javascript", "typescript", "haskell",
})

-- Enable treesitter highlighting per buffer. On the `main` branch highlighting
-- is provided by Neovim core via vim.treesitter.start(), not by setup().
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and pcall(vim.treesitter.start, args.buf, lang) then
            -- ok: parser present and highlighting started
        end
    end,
})
