-- ~/.config/nvim/lua/config/hydra.lua
-- ============================================
-- HYDRA - Sticky keymaps (modos temporales)
-- ============================================

local Hydra = require('hydra')

-- ============================================
-- MOVER LÍNEAS (sticky j/k)
-- ============================================

-- Helper para mover líneas que funciona en normal y visual
local function move_down()
   local mode = vim.fn.mode()
   if mode == 'V' or mode == 'v' or mode == '\22' then  -- visual modes
      vim.cmd("'<,'>m '>+1")
      vim.cmd("normal! gv=gv")
   else  -- normal mode
      vim.cmd("m .+1")
      vim.cmd("normal! ==")
   end
end

local function move_up()
   local mode = vim.fn.mode()
   if mode == 'V' or mode == 'v' or mode == '\22' then  -- visual modes
      vim.cmd("'<,'>m '<-2")
      vim.cmd("normal! gv=gv")
   else  -- normal mode
      vim.cmd("m .-2")
      vim.cmd("normal! ==")
   end
end

Hydra({
   name = 'Move Lines',
   mode = {'n', 'v'},
   body = '<leader>m',
   heads = {
      { 'j', move_down, { desc = 'Mover abajo' } },
      { 'k', move_up, { desc = 'Mover arriba' } },
      { '<Esc>', nil, { exit = true, desc = 'Salir' } },
   },
   config = {
      color = 'pink',
      invoke_on_body = false,
      hint = {
         type = 'window',
         float_opts = { border = 'rounded' },
      },
   },
})

-- ============================================
-- NAVEGACIÓN FUNCIONES (sticky <leader>n + [/])
-- ============================================
local ts_move = require("nvim-treesitter-textobjects.move")

Hydra({
   name = 'Navigate Functions',
   mode = 'n',
   body = '<leader>n',
   heads = {
      { ']', function() ts_move.goto_next_start("@function.outer") end, { desc = 'Siguiente función' } },
      { '[', function() ts_move.goto_previous_start("@function.outer") end, { desc = 'Anterior función' } },
      { '<Esc>', nil, { exit = true, desc = 'Salir' } },
   },
   config = {
      color = 'pink',
      invoke_on_body = false,
      hint = {
         type = 'window',
         float_opts = { border = 'rounded' },
      },
   },
})

print("✓ Hydra keymaps cargados")
