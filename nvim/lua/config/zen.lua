require("zen-mode").setup({
  window = {
    backdrop = 0.95,
    width = 0.70,
    height = 0.90,
    options = {
      number = false,
      relativenumber = false,
      signcolumn = "yes",
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false,
      showcmd = false,
    },
  },
})

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen Mode" })