-- ~/.config/nvim/lua/config/session.lua
require("persistence").setup()

vim.keymap.set("n", "<leader>xr", function() require("persistence").load() end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>xq", function() require("persistence").stop() end, { desc = "Stop saving session" })
