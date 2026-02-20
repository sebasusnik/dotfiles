-- ~/.config/nvim/lua/config/keymaps.lua
-- ============================================
-- KEYMAPS GLOBALES
-- ============================================

vim.g.mapleader = " "

-- Navegación entre splits
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Split izquierda" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Split derecha" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Split abajo" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Split arriba" })
vim.keymap.set("n", "<leader>wq", "<C-w>q", { desc = "Cerrar split" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })

-- Navegación entre buffers
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Alternar últimos 2 archivos" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Cerrar archivo" })
vim.keymap.set("n", "<leader>fx", ":!open %<CR>", { desc = "Abrir con app del sistema" })
