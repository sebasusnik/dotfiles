require("gitsigns").setup({
  signcolumn = true,
  numhl = false,
  linehl = false,
  current_line_blame = false, -- zen: off por defecto
})

-- Keymaps (tranquis)
vim.keymap.set("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset hunk" })

-- Colores: config/ui.lua (apply_highlights)
