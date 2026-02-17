-- ~/.config/nvim/lua/config/telescope.lua
-- ============================================
-- TELESCOPE: Búsqueda fuzzy
-- ============================================

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
    file_ignore_patterns = {
      "node_modules/",
      ".git/",
      "dist/",
      "build/",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
      "--glob=!node_modules/",
      "--glob=!dist/",
      "--glob=!build/",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
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

-- Keymaps
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Buscar texto" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Buscar en archivo" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buscar buffers" })
