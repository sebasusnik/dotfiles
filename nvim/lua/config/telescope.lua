-- ~/.config/nvim/lua/config/telescope.lua
-- ============================================
-- TELESCOPE: Búsqueda fuzzy
-- ============================================

local actions = require("telescope.actions")

-- Excluidos directo en rg (antes: file_ignore_patterns, que filtra en Lua
-- entrada por entrada DESPUÉS de listar todo, incluido .git/ por --hidden)
local excludes = { "--glob=!.git/", "--glob=!node_modules/", "--glob=!dist/", "--glob=!build/" }

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
    vimgrep_arguments = vim.list_extend({
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    }, excludes),
  },
  pickers = {
    find_files = {
      find_command = vim.list_extend({ "rg", "--files", "--color=never", "--hidden" }, excludes),
      previewer = false,
    },
    live_grep = {
      previewer = false,
    },
    buffers = {
      previewer = false,
    },
    current_buffer_fuzzy_find = {
      previewer = false,
    },
  },
})

-- Sorter nativo (C). pcall: si falló el `make` del build, sigue andando.
pcall(require("telescope").load_extension, "fzf")

-- Keymaps (<leader>ff, <leader>fg, <leader>/, <leader>b): init.lua (lazy keys)
