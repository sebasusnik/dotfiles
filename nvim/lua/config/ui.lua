-- ============================================
-- UI Zen + Craftzdog-like (sin theme)
-- ============================================

-- 0) Mostrar marcas visuales después de salir del modo visual
-- (los colores de Visual/VisualMarks están en apply_highlights, más abajo)
local visual_marks_ns = vim.api.nvim_create_namespace("visual_marks")

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "[vV\x16]*:*",
  callback = function()
    -- Si seguimos en visual (ej: v -> V) no hacemos nada
    if vim.fn.mode():match("[vV\x16]") then return end

    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(buf, visual_marks_ns, 0, -1)

    -- Marcas visuales (0-indexed, end exclusivo)
    local start_line = vim.fn.line("'<") - 1
    local end_line = vim.fn.line("'>")
    if start_line < 0 or end_line <= start_line then return end

    -- Un solo extmark para todo el rango (nvim_buf_add_highlight está deprecado)
    pcall(vim.api.nvim_buf_set_extmark, buf, visual_marks_ns, start_line, 0, {
      end_row = end_line,
      hl_group = "VisualMarks",
      hl_eol = true,
    })

    -- Auto-limpiar después de 3 segundos (en el MISMO buffer)
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_clear_namespace(buf, visual_marks_ns, 0, -1)
      end
    end, 3000)
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

-- 3) Hover de CSS (tailwind/cssls): mostrarlo como CSS puro.
-- Solo si el hover es un bloque ```css: antes matcheaba cualquier `{ a: b }`
-- y los hovers de tipos de TypeScript terminaban highlighteados como CSS.
-- (El borde rounded de todos los floats lo da `winborder`, más abajo.)
do
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    local bufnr, winnr = orig(contents, syntax, opts, ...)
    if syntax == "markdown" and bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if first:match("^%s*```css%s*$") then
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

-- 4) Zen: menos “ruido” del UI
vim.o.winborder = "rounded"
vim.opt.fillchars = { vert = " ", eob = " " }

-- 5) Opcional MUY lindo: mostrar diagnóstico flotante al “descansar” el cursor
-- (sin robar foco, re zen)
vim.opt.updatetime = 350
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- No tapar un float que ya esté abierto (hover con K, signature, etc.).
    -- Los no-focusables (fidget, el propio float de diagnósticos) no cuentan.
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" and cfg.focusable then return end
    end
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- Saca el fondo de un highlight SIN perder el resto (fg, bold, etc).
-- nvim_set_hl reemplaza la definición entera: { bg = "NONE" } solo borraba
-- también el fg (ej: los signos de gitsigns perdían el color).
local function clear_bg(name)
  local def = vim.api.nvim_get_hl(0, { name = name, link = false })
  def.bg = nil
  def.ctermbg = nil
  vim.api.nvim_set_hl(0, name, def)
end

local hl = function(name, val) vim.api.nvim_set_hl(0, name, val) end

-- Todos los colores custom en un solo lugar. Se re-aplican en cada
-- ColorScheme: `:colorscheme` (themery) hace `hi clear` y borraba los que
-- estaban seteados una sola vez en gitsigns.lua / neotree.lua.
local function apply_highlights()
  -- Selección visual con color más claro + marcas al salir de visual
  hl("Visual",      { bg = "#4a4a4a" })
  hl("VisualMarks", { bg = "#3a3a3a" })

  -- Editor background
  hl("Normal",      { bg = "NONE" })
  hl("NormalNC",    { bg = "NONE" })
  hl("EndOfBuffer", { bg = "NONE" })
  hl("MsgArea",     { bg = "NONE" })
  clear_bg("SignColumn")

  -- Line numbers (subtle, current line slightly brighter)
  hl("LineNr",       { fg = "#555555" })
  hl("LineNrAbove",  { fg = "#555555" })
  hl("LineNrBelow",  { fg = "#555555" })
  hl("CursorLineNr", { fg = "#888888" })

  -- Indent guides (faint line, current scope slightly brighter)
  hl("IblIndent", { fg = "#303030", nocombine = true })
  hl("IblScope",  { fg = "#505050", nocombine = true })

  -- Trailing whitespace
  hl("TrailingWhitespace", { bg = "#3d2020" })

  -- Floating windows
  clear_bg("NormalFloat")
  clear_bg("FloatBorder")

  -- Window separators (invisibles)
  hl("VertSplit",    { bg = "NONE", fg = "NONE" })
  hl("WinSeparator", { bg = "NONE", fg = "NONE" })

  -- Neo-tree
  hl("NeoTreeNormal",       { bg = "NONE" })
  hl("NeoTreeNormalNC",     { bg = "NONE" })
  hl("NeoTreeEndOfBuffer",  { bg = "NONE" })
  hl("NeoTreeVertSplit",    { bg = "NONE", fg = "NONE" })
  hl("NeoTreeWinSeparator", { bg = "NONE", fg = "NONE" })
  hl("NeoTreeCursorLine",   { bg = "#2a2a3a" })
  -- Archivos/carpetas filtrados (gitignored, node_modules, etc.) apagados
  hl("NeoTreeDimText",      { fg = "#4a4a5a", italic = true })

  -- Git signs (mismos colores que la scrollbar, ver config/scrollbar.lua)
  hl("GitSignsAdd",    { fg = "#22aaaa" }) -- cyan
  hl("GitSignsChange", { fg = "#cc7722" }) -- orange
  hl("GitSignsDelete", { fg = "#994466" }) -- rose
  clear_bg("GitSignsTopdelete")
  clear_bg("GitSignsChangedelete")
  clear_bg("GitSignsUntracked")

  -- Diagnósticos: undercurl (más compatible con Ghostty)
  hl("DiagnosticUnderlineError", { sp = "#ff5f5f", undercurl = true })
  hl("DiagnosticUnderlineWarn",  { sp = "#ffaf5f", undercurl = true })
  hl("DiagnosticUnderlineInfo",  { sp = "#5fafd7", undercurl = true })
  hl("DiagnosticUnderlineHint",  { sp = "#5fd787", undercurl = true })
  -- TypeScript específicos
  hl("DiagnosticUnnecessary",    { sp = "#808080", undercurl = true })
  hl("DiagnosticDeprecated",     { sp = "#d75f00", undercurl = true })
end

apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
  -- schedule: correr después de los ColorScheme de los plugins (neo-tree
  -- re-define sus grupos ahí)
  callback = function() vim.schedule(apply_highlights) end,
})

-- 6) Secuencias de escape para undercurl (crítico para Ghostty)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Trailing whitespace highlight
vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])