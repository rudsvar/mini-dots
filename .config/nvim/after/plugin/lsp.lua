-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = {
            winhighlight = "Normal:CmpCompletion,CursorLine:CmpItemSel",
        },
        documentation = {
            border = "rounded",
            winhighlight = "Normal:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lua' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- Set up LSP servers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define on_attach function
local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", ']e', vim.diagnostic.goto_next)
    vim.keymap.set("n", '[e', vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
end

-- Configure LSP handlers with borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
})

-- Helper function to setup LSP servers
local function setup_lsp(server, config)
    -- Get the command from lspconfig's default config
    local server_config = lspconfig[server]
    if not server_config then
        return
    end

    local cmd = server_config.document_config.default_config.cmd
    if cmd and vim.fn.executable(cmd[1]) == 0 then
        return
    end

    local default_config = {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    if config then
        default_config = vim.tbl_deep_extend("force", default_config, config)
    end

    lspconfig[server].setup(default_config)
end

-- Setup LSP servers
setup_lsp("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

setup_lsp("rust_analyzer", {
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = true,
            diagnostics = {
                experimental = {
                    enable = true
                }
            }
        }
    }
})

setup_lsp("pyright", {
    settings = {
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true
            }
        }
    }
})

setup_lsp("gleam")
setup_lsp("gopls")
setup_lsp("hls")

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = {
        spacing = 1,
        prefix = '',
        suffix = ',',
    },
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})


-- Diagnostic signs
local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
