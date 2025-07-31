vim.cmd("colorscheme onedark")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#aaaaaa" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none", fg = "#666666" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "none", fg = "#666666" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { bg = "none", fg = "#666666" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "none", fg = "#666666" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none", fg = "#666666" })

-- LSP hover/documentation window background (Shift+K)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#242424" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#242424", fg = "#666666" })

-- Completion windows
vim.api.nvim_set_hl(0, "CmpCompletion", { bg = "#333333" })
vim.api.nvim_set_hl(0, "CmpDocumentation", { bg = "#242424" })
vim.api.nvim_set_hl(0, "CmpDocumentationBorder", { bg = "#242424", fg = "#666666" })

-- Completion item selection
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82aaff", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82aaff", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#666666" })
vim.api.nvim_set_hl(0, "CmpItemSel", { bg = "#3e4451" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3e4451" })
