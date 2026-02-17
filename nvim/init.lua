-- ~/.config/nvim/init.lua
-- ============================================
-- NVIM ZEN + OPENCODE
-- ============================================

-- ============================================
-- 1) APARIENCIA / UI BASE
-- ============================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.cmd.colorscheme("default")

-- ============================================
-- 2) COMPORTAMIENTO
-- ============================================
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- ============================================
-- 3) LEADER + KEYMAPS
-- ============================================
vim.g.mapleader = " "

-- Atajos básicos
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Guardar" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Salir" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Guardar y salir" })

-- Navegación entre splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Panel izquierda" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Panel derecha" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Panel abajo" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Panel arriba" })

-- ============================================
-- 4) BOOTSTRAP LAZY.NVIM
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- 5) PLUGINS
-- ============================================
require("lazy").setup({
    -- ======================
    -- Navegación / archivos
    -- ======================
    {
        "echasnovski/mini.files",
        config = function()
            require("mini.files").setup({
                windows = { preview = false, width_focus = 30 },
            })

            vim.keymap.set("n", "<leader>e", function()
                if not MiniFiles.close() then
                    MiniFiles.open(vim.api.nvim_buf_get_name(0))
                end
            end, { desc = "Toggle file explorer" })

            -- Navegación: Enter para abrir, - para volver atrás
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id
                    vim.keymap.set("n", "<CR>", function()
                        MiniFiles.go_in()
                    end, { buffer = buf_id, desc = "Enter directory" })
                    vim.keymap.set("n", "-", function()
                        MiniFiles.go_out()
                    end, { buffer = buf_id, desc = "Go back" })
                end,
            })
        end,
    },

    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
        vim.keymap.set("n", "<leader>f", ":Files<CR>", { desc = "Buscar archivos" })
        vim.keymap.set("n", "<leader>g", ":Rg<CR>", { desc = "Buscar texto" })
        vim.keymap.set("n", "<leader>/", ":BLines<CR>", { desc = "Buscar en archivo" })
        end,
    },

    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                columns = { "icon" },
                view_options = {
                    show_hidden = false,
                },
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil explorer" })
        end,
    },

    -- ======================
    -- LSP / Tooling
    -- ======================
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },

    -- TS tools (mejor UX que ts_ls)
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        config = function()
            require("typescript-tools").setup({
                capabilities = require("config.cmp").capabilities,
                on_attach = function(_, bufnr)
                    local nmap = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
                    end

                    nmap("gd", vim.lsp.buf.definition, "Go to definition")
                    nmap("K", vim.lsp.buf.hover, "Hover")
                    nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
                    nmap("<leader>ca", vim.lsp.buf.code_action, "Code actions")
                end,
            })
        end,
    },
    { "nvim-lua/plenary.nvim" },

    -- ======================
    -- Autocomplete + Snippets
    -- ======================
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },

    -- ======================
    -- Formatter / Linter
    -- ======================
    { "stevearc/conform.nvim" },
    { "mfussenegger/nvim-lint" },

    -- ======================
    -- UI / Iconos
    -- ======================
    { "nvim-tree/nvim-web-devicons" },

    -- ======================
    -- Treesitter
    -- ======================
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ok, configs = pcall(require, "nvim-treesitter.configs")
        if not ok then return end

        configs.setup({
        ensure_installed = {
            "lua","vim","vimdoc",
            "javascript","typescript","tsx",
            "json","yaml","html","css",
            "markdown","markdown_inline",
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>",
            },
        },
        })
    end,
    },
    {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- ======================
    -- Git
    -- ======================
    {
    "lewis6991/gitsigns.nvim",
    },

    -- ======================
    -- Zen mode
    -- ======================
    {
    "folke/zen-mode.nvim",
    },
})

-- ============================================
-- 6) CARGAR CONFIG MODULAR
-- ============================================
require("config.project_tools")
require("config.cmp")
require("config.lsp")
require("config.formatting")
require("config.lint")
require("config.snippets")
require("config.ui")
require("config.gitsigns")
require("config.zen")

-- ============================================
-- 7) OPENCODE
-- ============================================
require("config.opencode")