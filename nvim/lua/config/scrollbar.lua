-- Colores via config (no nvim_set_hl): la scrollbar re-crea sus highlights
-- en cada ColorScheme y pisaba los que se seteaban a mano.
require("scrollbar").setup({
  show = true,
  handle = {
    text = "█",
    color = "#555555",
    blend = 100,
    hide_if_all_visible = true,
  },
  marks = {
    GitAdd    = { text = "│", color = "#22aaaa" },            -- cyan
    GitChange = { text = "│", color = "#cc7722" },            -- orange
    GitDelete = { text = "│", color = "#994466" },            -- rose
    Error     = { text = { "│", "│" }, color = "#cc3333" },   -- red
    Warn      = { text = { "│", "│" }, color = "#d4a017" },   -- amber yellow
    Info      = { text = { "│", "│" }, color = "#4488bb" },   -- steel blue
    Hint      = { text = { "│", "│" }, color = "#558855" },   -- muted green
    Search    = { text = { "│", "│" }, color = "#8866cc" },   -- purple
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
