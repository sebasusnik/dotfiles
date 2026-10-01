-- ~/.config/nvim/lua/config/options.lua
-- ============================================
-- OPCIONES DE NEOVIM
-- ============================================

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""
vim.opt.wrap = false
vim.opt.linebreak = true   -- wrap at word boundaries when wrap is on
vim.opt.breakindent = true -- preserve indentation on wrapped lines
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true

-- Comportamiento
-- schedule: detectar el provider del clipboard puede tardar en el arranque
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Large file handler: deshabilitar features pesadas para archivos > 500KB
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function(ev)
        local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
        if ok and stat and stat.size > 500 * 1024 then
            vim.b[ev.buf].bigfile = true -- treesitter no arranca (config/treesitter.lua)
            vim.bo[ev.buf].swapfile = false
            vim.bo[ev.buf].undofile = false
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(ev.buf) then
                    vim.bo[ev.buf].syntax = "off"
                end
            end)
        end
    end,
    desc = "Disable heavy features for large files (>500KB)",
})

-- Wrap para archivos de markup/templates
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "json" },
    callback = function() vim.opt_local.wrap = true end,
    desc = "Wrap long lines in template/markup files (Tailwind classes)",
})
