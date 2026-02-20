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
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Wrap para archivos de markup/templates
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "json" },
    callback = function() vim.opt_local.wrap = true end,
    desc = "Wrap long lines in template/markup files (Tailwind classes)",
})
