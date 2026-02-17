-- ============================================
-- UI Zen + Craftzdog-like (sin theme)
-- ============================================

-- 1) Diagnósticos: limpio, sin ruido inline
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN]  = "󰀪",
      [vim.diagnostic.severity.HINT]  = "󰌶",
      [vim.diagnostic.severity.INFO]  = "󰋽",
    },
  },
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

-- 7) Habilitar soporte de undercurl en terminal
vim.o.termguicolors = true

-- Configurar secuencias de escape para undercurl (crítico para Ghostty)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- 8) Configurar underline para diagnósticos (más compatible)
local function set_diagnostics_hl()
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
    sp = "#ff5f5f",
    undercurl = true
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
    sp = "#ffaf5f",
    undercurl = true
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {
    sp = "#5fafd7",
    undercurl = true
  })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {
    sp = "#5fd787",
    undercurl = true
  })
  -- TypeScript específicos
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {
    sp = "#808080",
    undercurl = true
  })
  vim.api.nvim_set_hl(0, "DiagnosticDeprecated", {
    sp = "#d75f00",
    undercurl = true
  })
end

set_diagnostics_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diagnostics_hl })