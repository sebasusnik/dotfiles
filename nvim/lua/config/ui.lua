-- ============================================
-- UI Zen + Craftzdog-like (sin theme)
-- ============================================

-- 1) Diagnósticos: limpio, sin ruido inline
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
    focusable = false,
  },
})

-- 2) Signs con iconos suaves (requiere Nerd Font)
local diag_signs = {
  Error = "󰅚",
  Warn  = "󰀪",
  Hint  = "󰌶",
  Info  = "󰋽",
}
for t, icon in pairs(diag_signs) do
  local hl = "DiagnosticSign" .. t
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 3) Bordes rounded para TODO floating preview (esto faltaba)
do
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig(contents, syntax, opts, ...)
  end
end

-- 4) Hover y signature también rounded (extra seguro)
vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- 5) Zen: menos “ruido” del UI
vim.o.winborder = "rounded"
vim.opt.fillchars = { vert = " ", eob = " " }

-- 6) Opcional MUY lindo: mostrar diagnóstico flotante al “descansar” el cursor
-- (sin robar foco, re zen)
vim.opt.updatetime = 350
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

local function transparent()
  vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn",  { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea",     { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
end

transparent()
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparent })