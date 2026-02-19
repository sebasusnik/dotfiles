require("gitsigns").setup({
  signcolumn = true,
  numhl = false,
  linehl = false,
  current_line_blame = false, -- zen: off por defecto
})

-- Keymaps (tranquis)
vim.keymap.set("n", "]h", require("gitsigns").next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "[h", require("gitsigns").prev_hunk, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hp", require("gitsigns").preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hs", require("gitsigns").stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", require("gitsigns").reset_hunk, { desc = "Reset hunk" })

vim.api.nvim_set_hl(0, "GitSignsAdd",    { bg = "NONE", fg = "#22aaaa" }) -- cyan
vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE", fg = "#cc7722" }) -- orange
vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE", fg = "#994466" }) -- rose