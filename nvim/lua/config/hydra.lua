-- ~/.config/nvim/lua/config/hydra.lua
-- ============================================
-- HYDRA - Sticky keymaps (modos temporales)
-- ============================================

local Hydra = require('hydra')

-- ============================================
-- MOVER LÍNEAS (sticky j/k)
-- ============================================

-- Variable para trackear si hay selección visual activa
local visual_selection = { start_line = nil, end_line = nil }

-- Helper para mover líneas
local function move_down()
   if visual_selection.start_line and visual_selection.end_line then
      -- Mover selección visual
      local start = visual_selection.start_line
      local end_line = visual_selection.end_line

      -- Mover las líneas
      vim.cmd(string.format("%d,%dm %d", start, end_line, end_line + 1))

      -- Actualizar las posiciones después del movimiento
      visual_selection.start_line = start + 1
      visual_selection.end_line = end_line + 1

      -- Mover el cursor a la primera línea del bloque movido
      vim.api.nvim_win_set_cursor(0, {visual_selection.start_line, 0})
   else
      -- Mover línea actual
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      vim.cmd("m .+1")
      vim.api.nvim_win_set_cursor(0, {current_line + 1, 0})
   end
end

local function move_up()
   if visual_selection.start_line and visual_selection.end_line then
      -- Mover selección visual
      local start = visual_selection.start_line
      local end_line = visual_selection.end_line

      -- No mover si ya estamos en la primera línea
      if start <= 1 then return end

      -- Mover las líneas
      vim.cmd(string.format("%d,%dm %d", start, end_line, start - 2))

      -- Actualizar las posiciones después del movimiento
      visual_selection.start_line = start - 1
      visual_selection.end_line = end_line - 1

      -- Mover el cursor a la primera línea del bloque movido
      vim.api.nvim_win_set_cursor(0, {visual_selection.start_line, 0})
   else
      -- Mover línea actual
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      if current_line > 1 then
         vim.cmd("m .-2")
         vim.api.nvim_win_set_cursor(0, {current_line - 1, 0})
      end
   end
end

local move_hydra = Hydra({
   name = 'Move Lines',
   mode = 'n',
   body = '<leader>m',
   heads = {
      { 'j', move_down, { desc = 'Mover abajo' } },
      { 'k', move_up, { desc = 'Mover arriba' } },
      { '<Esc>', nil, { exit = true, desc = 'Salir' } },
   },
   config = {
      color = 'pink',
      invoke_on_body = false,
      on_exit = function()
         -- Limpiar al salir
         visual_selection.start_line = nil
         visual_selection.end_line = nil
      end,
      hint = {
         type = 'window',
         float_opts = { border = 'rounded' },
      },
   },
})

-- Keymap visual para leader+m: guardar posiciones y activar hydra
vim.keymap.set('x', '<leader>m', function()
   -- Obtener posiciones MIENTRAS estamos en modo visual
   local start_pos = vim.fn.getpos("v")  -- Inicio de la selección visual
   local end_pos = vim.fn.getpos(".")     -- Fin de la selección visual (cursor)

   -- Guardar las líneas (el segundo elemento de getpos es el número de línea)
   visual_selection.start_line = math.min(start_pos[2], end_pos[2])
   visual_selection.end_line = math.max(start_pos[2], end_pos[2])

   -- Salir de modo visual (ESC)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

   -- Activar hydra después de un pequeño delay para que el ESC se procese
   vim.defer_fn(function()
      move_hydra:activate()
   end, 10)
end, { desc = 'Mover líneas (hydra)' })

-- ============================================
-- NAVEGACIÓN INTELIGENTE (sticky <leader>n + [/])
-- Navega por funciones, types, variables, etc.
-- ============================================

-- Tipos de nodos válidos para navegar
local valid_node_types = {
   "function_declaration",
   "method_definition",
   "function_expression",
   "arrow_function",
   "lexical_declaration",      -- const/let
   "variable_declaration",      -- var
   "type_alias_declaration",    -- type
   "interface_declaration",     -- interface
   "enum_declaration",          -- enum
   "class_declaration",         -- class
}

local function is_valid_node(node)
   if not node then return false end
   local node_type = node:type()
   for _, valid_type in ipairs(valid_node_types) do
      if node_type == valid_type then return true end
   end
   -- Incluir export_statement si su hijo es válido
   if node_type == "export_statement" then
      for child in node:iter_children() do
         if is_valid_node(child) then return true end
      end
   end
   return false
end

-- Navegar al siguiente nodo válido
local function goto_next_declaration()
   -- Verificar tipo de archivo compatible
   local ft = vim.bo.filetype
   local supported_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
   local is_supported = false
   for _, supported_ft in ipairs(supported_filetypes) do
      if ft == supported_ft then
         is_supported = true
         break
      end
   end

   if not is_supported then
      vim.notify("Navegación solo disponible en archivos TS/JS", vim.log.levels.INFO)
      return
   end

   local bufnr = 0
   local cursor = vim.api.nvim_win_get_cursor(0)
   local current_row = cursor[1] - 1  -- 0-indexed

   local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
   if not ok or not parser then
      vim.notify("Treesitter no disponible para este archivo", vim.log.levels.WARN)
      return
   end

   local trees = parser:parse()
   if not trees or #trees == 0 then return end

   local root = trees[1]:root()
   local best_node = nil
   local best_row = math.huge

   -- Función recursiva para visitar nodos
   local function visit(n)
      if is_valid_node(n) then
         local row = n:range()
         if row > current_row and row < best_row then
            best_node = n
            best_row = row
         end
      end
      for child in n:iter_children() do
         visit(child)
      end
   end

   -- Recorrer todos los nodos del árbol
   for node in root:iter_children() do
      visit(node)
   end

   if best_node then
      local row = best_node:range()
      vim.api.nvim_win_set_cursor(0, {row + 1, 0})
   end
end

-- Navegar al anterior nodo válido
local function goto_prev_declaration()
   -- Verificar tipo de archivo compatible
   local ft = vim.bo.filetype
   local supported_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
   local is_supported = false
   for _, supported_ft in ipairs(supported_filetypes) do
      if ft == supported_ft then
         is_supported = true
         break
      end
   end

   if not is_supported then
      vim.notify("Navegación solo disponible en archivos TS/JS", vim.log.levels.INFO)
      return
   end

   local bufnr = 0
   local cursor = vim.api.nvim_win_get_cursor(0)
   local current_row = cursor[1] - 1  -- 0-indexed

   local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
   if not ok or not parser then
      vim.notify("Treesitter no disponible para este archivo", vim.log.levels.WARN)
      return
   end

   local trees = parser:parse()
   if not trees or #trees == 0 then return end

   local root = trees[1]:root()
   local best_node = nil
   local best_row = -1

   -- Función recursiva para visitar nodos
   local function visit(n)
      if is_valid_node(n) then
         local row = n:range()
         if row < current_row and row > best_row then
            best_node = n
            best_row = row
         end
      end
      for child in n:iter_children() do
         visit(child)
      end
   end

   -- Recorrer todos los nodos del árbol
   for node in root:iter_children() do
      visit(node)
   end

   if best_node then
      local row = best_node:range()
      vim.api.nvim_win_set_cursor(0, {row + 1, 0})
   end
end

local nav_hydra = Hydra({
   name = 'Navigate Declarations',
   mode = 'n',
   body = '<leader>n',
   heads = {
      { 'j', goto_next_declaration, { desc = 'Siguiente declaración' } },
      { 'k', goto_prev_declaration, { desc = 'Anterior declaración' } },
      { '<Esc>', nil, { exit = true, desc = 'Salir' } },
   },
   config = {
      color = 'pink',
      invoke_on_body = true,
      hint = {
         type = 'window',
         float_opts = { border = 'rounded' },
      },
   },
})
