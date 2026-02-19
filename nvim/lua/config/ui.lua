-- ============================================
-- UI Zen + Craftzdog-like (sin theme)
-- ============================================

-- 0) Visual mode con color más claro
vim.api.nvim_set_hl(0, "Visual", { bg = "#4a4a4a", fg = "NONE" })

-- 0.5) Highlight para marcas visuales guardadas (más claro también)
vim.api.nvim_set_hl(0, "VisualMarks", { bg = "#3a3a3a", fg = "NONE" })

-- Mostrar marcas visuales después de salir del modo visual
local visual_marks_ns = vim.api.nvim_create_namespace("visual_marks")

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = {"*:[vV\x16]*", "[vV\x16]*:*"},
  callback = function()
    local mode = vim.fn.mode()

    -- Si salimos del modo visual
    if not mode:match("[vV\x16]") then
      -- Limpiar highlights anteriores
      vim.api.nvim_buf_clear_namespace(0, visual_marks_ns, 0, -1)

      -- Obtener marcas visuales
      local start_line = vim.fn.line("'<") - 1
      local end_line = vim.fn.line("'>")

      -- Agregar highlight sutil a las líneas seleccionadas
      if start_line >= 0 and end_line > start_line then
        for line = start_line, end_line - 1 do
          vim.api.nvim_buf_add_highlight(0, visual_marks_ns, "VisualMarks", line, 0, -1)
        end

        -- Auto-limpiar después de 3 segundos
        vim.defer_fn(function()
          vim.api.nvim_buf_clear_namespace(0, visual_marks_ns, 0, -1)
        end, 3000)
      end
    end
  end,
})

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

-- 3) Bordes rounded para TODO floating preview + treesitter injection in hover buffers
do
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    local bufnr, winnr = orig(contents, syntax, opts, ...)
    if syntax == "markdown" and bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
        if text:match("[%.#]?[%w-]+%s*{[^}]-:[^}]-}") then
          -- Strip markdown code-fence lines (```css / ```) that stylize_markdown
          -- leaves in the buffer, then start a CSS treesitter parser.
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local clean = {}
          for _, line in ipairs(lines) do
            if not line:match("^%s*```") then
              clean[#clean + 1] = line
            end
          end
          vim.bo[bufnr].modifiable = true
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, clean)
          vim.bo[bufnr].modifiable = false
          pcall(vim.treesitter.stop, bufnr)
          vim.bo[bufnr].filetype = "css"
        end
      end, 50)
    end
    return bufnr, winnr
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
  -- Editor background
  vim.api.nvim_set_hl(0, "Normal",      { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC",    { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn",  { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "MsgArea",     { bg = "NONE" })

  -- Line numbers (subtle, current line slightly brighter)
  vim.api.nvim_set_hl(0, "LineNr",       { bg = "NONE", fg = "#555555" })
  vim.api.nvim_set_hl(0, "LineNrAbove",  { bg = "NONE", fg = "#555555" })
  vim.api.nvim_set_hl(0, "LineNrBelow",  { bg = "NONE", fg = "#555555" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", fg = "#888888", bold = false })

  -- Indent guides (faint line, current scope slightly brighter)
  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#303030", nocombine = true })
  vim.api.nvim_set_hl(0, "IblScope",  { fg = "#505050", nocombine = true })

  -- Trailing whitespace
  vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#3d2020" })

  -- Floating windows
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })

  -- Neo-tree specific
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "NONE", fg = "NONE" })
  vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "NONE", fg = "NONE" })

  -- General window separators
  vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", fg = "NONE" })
  vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", fg = "NONE" })

  -- Git signs (keep foreground colors, remove background)
  vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsTopdelete", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsChangedelete", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "GitSignsUntracked", { bg = "NONE" })
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

-- Trailing whitespace highlight
vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])