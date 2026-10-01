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

      -- No mover si ya estamos en la última línea (E16: Invalid range)
      if end_line >= vim.api.nvim_buf_line_count(0) then return end

      -- Mover las líneas
      vim.cmd(string.format("%d,%dm %d", start, end_line, end_line + 1))

      -- Actualizar las posiciones después del movimiento
      visual_selection.start_line = start + 1
      visual_selection.end_line = end_line + 1

      -- Mover el cursor a la primera línea del bloque movido
      vim.api.nvim_win_set_cursor(0, {visual_selection.start_line, 0})
   else
      -- Mover línea actual (salvo que sea la última: E16: Invalid range)
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      if current_line >= vim.api.nvim_buf_line_count(0) then return end
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

-- Implementación compartida con ]m / [m: config/ts_nav.lua
local ts_nav = require("config.ts_nav")
local function goto_next_declaration() ts_nav.goto_declaration(1) end
local function goto_prev_declaration() ts_nav.goto_declaration(-1) end

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
