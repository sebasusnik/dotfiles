-- ~/.config/nvim/lua/config/textobjects.lua
-- ============================================
-- TREESITTER TEXTOBJECTS - Keymaps manuales
-- ============================================

-- Helper para crear keymaps de textobjects
local function map_textobject(modes, key, capture)
  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, key, function()
      require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
    end, { desc = "Textobject " .. capture })
  end
end

-- Modos: x = visual, o = operator-pending
local modes = { "x", "o" }

-- ============================================
-- SELECT: Seleccionar textobjects
-- ============================================

-- Funciones
map_textobject(modes, "af", "@function.outer")
map_textobject(modes, "if", "@function.inner")

-- Clases
map_textobject(modes, "ac", "@class.outer")
map_textobject(modes, "ic", "@class.inner")

-- Parámetros/Argumentos
map_textobject(modes, "aa", "@parameter.outer")
map_textobject(modes, "ia", "@parameter.inner")

-- Condicionales (if/else)
map_textobject(modes, "ai", "@conditional.outer")
map_textobject(modes, "ii", "@conditional.inner")

-- Loops (for/while)
map_textobject(modes, "al", "@loop.outer")
map_textobject(modes, "il", "@loop.inner")

-- Bloques
map_textobject(modes, "ab", "@block.outer")
map_textobject(modes, "ib", "@block.inner")

-- Comentarios
map_textobject(modes, "a/", "@comment.outer")

-- ============================================
-- MOVE: Navegar entre textobjects
-- ============================================

local ts_move = require("nvim-treesitter-textobjects.move")

-- Siguiente inicio
vim.keymap.set("n", "]m", function()
  ts_move.goto_next_start("@function.outer")
end, { desc = "Siguiente función" })

vim.keymap.set("n", "]c", function()
  ts_move.goto_next_start("@class.outer")
end, { desc = "Siguiente clase" })

vim.keymap.set("n", "]a", function()
  ts_move.goto_next_start("@parameter.outer")
end, { desc = "Siguiente parámetro" })

vim.keymap.set("n", "]i", function()
  ts_move.goto_next_start("@conditional.outer")
end, { desc = "Siguiente condicional" })

vim.keymap.set("n", "]l", function()
  ts_move.goto_next_start("@loop.outer")
end, { desc = "Siguiente loop" })

vim.keymap.set("n", "]b", function()
  ts_move.goto_next_start("@block.outer")
end, { desc = "Siguiente bloque" })

-- Siguiente final
vim.keymap.set("n", "]M", function()
  ts_move.goto_next_end("@function.outer")
end, { desc = "Siguiente función (final)" })

vim.keymap.set("n", "]C", function()
  ts_move.goto_next_end("@class.outer")
end, { desc = "Siguiente clase (final)" })

-- Anterior inicio
vim.keymap.set("n", "[m", function()
  ts_move.goto_previous_start("@function.outer")
end, { desc = "Anterior función" })

vim.keymap.set("n", "[c", function()
  ts_move.goto_previous_start("@class.outer")
end, { desc = "Anterior clase" })

vim.keymap.set("n", "[a", function()
  ts_move.goto_previous_start("@parameter.outer")
end, { desc = "Anterior parámetro" })

vim.keymap.set("n", "[i", function()
  ts_move.goto_previous_start("@conditional.outer")
end, { desc = "Anterior condicional" })

vim.keymap.set("n", "[l", function()
  ts_move.goto_previous_start("@loop.outer")
end, { desc = "Anterior loop" })

vim.keymap.set("n", "[b", function()
  ts_move.goto_previous_start("@block.outer")
end, { desc = "Anterior bloque" })

-- Anterior final
vim.keymap.set("n", "[M", function()
  ts_move.goto_previous_end("@function.outer")
end, { desc = "Anterior función (final)" })

vim.keymap.set("n", "[C", function()
  ts_move.goto_previous_end("@class.outer")
end, { desc = "Anterior clase (final)" })

print("✓ Textobjects keymaps cargados")
