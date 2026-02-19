require("scrollbar").setup({
  show = true,
  handle = {
    text = "▌",
    blend = 50,
    hide_if_all_visible = true,
  },
  marks = {
    GitAdd    = { text = "│" },
    GitChange = { text = "│" },
    GitDelete = { text = "│" },
    Error     = { text = { "│", "│" } },
    Warn      = { text = { "│", "│" } },
    Info      = { text = { "│", "│" } },
    Hint      = { text = { "│", "│" } },
    Search    = { text = { "│", "│" } },
  },
  handlers = {
    diagnostic = true,
    gitsigns   = true,
    search     = false,
    cursor     = false,
    handle     = true,
  },
})

require("scrollbar.handlers.gitsigns").setup()

vim.api.nvim_set_hl(0, "ScrollbarHandle",          { bg = "NONE", fg = "#555555" })
vim.api.nvim_set_hl(0, "ScrollbarHandleFg",        { bg = "NONE", fg = "NONE" })
vim.api.nvim_set_hl(0, "ScrollbarError",           { bg = "NONE", fg = "#cc3333" }) -- red
vim.api.nvim_set_hl(0, "ScrollbarErrorHandle",     { bg = "NONE", fg = "#cc3333" })
vim.api.nvim_set_hl(0, "ScrollbarWarn",            { bg = "NONE", fg = "#d4a017" }) -- amber yellow
vim.api.nvim_set_hl(0, "ScrollbarWarnHandle",      { bg = "NONE", fg = "#d4a017" })
vim.api.nvim_set_hl(0, "ScrollbarInfo",            { bg = "NONE", fg = "#4488bb" }) -- steel blue
vim.api.nvim_set_hl(0, "ScrollbarInfoHandle",      { bg = "NONE", fg = "#4488bb" })
vim.api.nvim_set_hl(0, "ScrollbarHint",            { bg = "NONE", fg = "#558855" }) -- muted green
vim.api.nvim_set_hl(0, "ScrollbarHintHandle",      { bg = "NONE", fg = "#558855" })
vim.api.nvim_set_hl(0, "ScrollbarGitAdd",          { bg = "NONE", fg = "#22aaaa" }) -- cyan
vim.api.nvim_set_hl(0, "ScrollbarGitAddHandle",    { bg = "NONE", fg = "#22aaaa" })
vim.api.nvim_set_hl(0, "ScrollbarGitChange",       { bg = "NONE", fg = "#cc7722" }) -- orange
vim.api.nvim_set_hl(0, "ScrollbarGitChangeHandle", { bg = "NONE", fg = "#cc7722" })
vim.api.nvim_set_hl(0, "ScrollbarGitDelete",       { bg = "NONE", fg = "#994466" }) -- rose
vim.api.nvim_set_hl(0, "ScrollbarGitDeleteHandle", { bg = "NONE", fg = "#994466" })
vim.api.nvim_set_hl(0, "ScrollbarSearch",          { bg = "NONE", fg = "#8866cc" }) -- purple
vim.api.nvim_set_hl(0, "ScrollbarSearchHandle",    { bg = "NONE", fg = "#8866cc" })
