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

-- Helper para encontrar type/interface/enum/objeto/variable manualmente
local function find_type_or_function_node()
  local bufnr = 0

  -- FORZAR inicialización de treesitter
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then
    vim.notify("Treesitter no disponible para este archivo", vim.log.levels.WARN)
    return nil
  end

  -- Forzar el parse del buffer (esto inicializa treesitter)
  pcall(function() parser:parse() end)

  local node = vim.treesitter.get_node({ bufnr = bufnr })
  if not node then
    return nil
  end

  -- Buscar nodo válido (solo nodos OUTER, no inner)
  while node do
    local node_type = node:type()
    local found_node = nil

    -- Funciones (outer)
    if node_type == "function_declaration"
       or node_type == "method_definition"
       or node_type == "function_expression"
       or node_type == "arrow_function" then
      found_node = node
    end

    -- Declaraciones de variables (const/let/var) - SOLO OUTER
    if node_type == "lexical_declaration"
       or node_type == "variable_declaration" then
      found_node = node
    end

    -- Types, interfaces, enums (TypeScript)
    if node_type == "type_alias_declaration"
       or node_type == "interface_declaration"
       or node_type == "enum_declaration" then
      found_node = node
    end

    -- Clases
    if node_type == "class_declaration" then
      found_node = node
    end

    -- Si encontramos un nodo válido, verificar si su parent es export_statement
    if found_node then
      local parent = found_node:parent()
      if parent and parent:type() == "export_statement" then
        -- Retornar el export_statement completo para incluir "export"
        return parent
      else
        return found_node
      end
    end

    node = node:parent()
  end

  return nil
end

-- Helper para seleccionar un nodo (compatible con visual y operator-pending)
local function select_node_range(node)
  if not node then
    return false
  end

  local start_row, start_col, end_row, end_col = node:range()

  -- node:range() devuelve 0-indexed, end_row es EXCLUSIVO
  -- Para seleccionar hasta la última línea en Vim (1-indexed), necesitamos end_row + 1
  local start_line = start_row + 1
  local end_line = end_row + 1

  -- Método oficial de nvim-treesitter-textobjects:
  -- 1. Entrar en visual mode linewise
  vim.cmd('normal! V')

  -- 2. Mover cursor al inicio (columna 0)
  vim.api.nvim_win_set_cursor(0, {start_line, 0})

  -- 3. Usar 'o' para cambiar al otro extremo de la selección
  vim.cmd('normal! o')

  -- 4. Mover cursor al final de la última línea
  -- En modo V (linewise), ir a cualquier posición en la línea selecciona toda la línea
  vim.api.nvim_win_set_cursor(0, {end_line, 0})

  return true
end

-- Helper inteligente: intenta búsqueda manual completa
local function map_smart_textobject(modes, key, captures, desc)
  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, key, function()
      -- Intentar búsqueda manual que cubre funciones, types, interfaces, enums
      local node = find_type_or_function_node()
      if node then
        select_node_range(node)
        return
      end

      -- Si no encontró nada, avisar
      vim.notify("No se encontró: " .. desc, vim.log.levels.WARN)
    end, { desc = desc })
  end
end

-- Modos: x = visual, o = operator-pending
local modes = { "x", "o" }

-- ============================================
-- SELECT: Seleccionar textobjects
-- ============================================

-- Funciones/Types/Enums (inteligente - búsqueda manual completa)
-- Esto hace que "vaf" funcione tanto en funciones como en types/interfaces/enums
map_smart_textobject(modes, "af", {}, "function/type/enum (outer)")
map_smart_textobject(modes, "if", {}, "function/type/enum (inner)")

-- Nota: "if" (inner) usa la misma lógica que "af" (outer) por ahora
-- En el futuro se puede mejorar para seleccionar solo el contenido interno

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
