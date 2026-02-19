-- ~/.config/nvim/lua/config/flash.lua
-- ============================================
-- FLASH: Fast navigation and jumping
-- ============================================

require("flash").setup({
  -- Minimal labels for zen aesthetic
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
  },
  jump = {
    jumplist = true,
    pos = "start",
    history = false,
    register = false,
    nohlsearch = true,
    autojump = false,
  },
  label = {
    uppercase = false,
    current = true,
    after = true,
    before = false,
    style = "overlay",
  },
  modes = {
    char = {
      enabled = true,
      jump_labels = true,
    },
  },
})

-- Keybindings
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })
vim.keymap.set({ "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle flash search" })
