-- ~/.config/nvim/lua/config/session.lua
require("persistence").setup()

-- Auto-restaurar sesión al abrir nvim sin archivo (como VS Code)
vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        if vim.fn.argc() == 0 then
            vim.schedule(function()
                require("persistence").load()
            end)
        end
    end,
})

vim.keymap.set("n", "<leader>xr", function() require("persistence").load() end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>xq", function() require("persistence").stop() end, { desc = "Stop saving session" })
