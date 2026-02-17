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
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function() require("config.neotree") end,
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require("config.telescope") end,
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
        branch = "main",
        build = ":TSUpdate",
        config = function() require("config.treesitter") end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
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
-- Ya cargados por lazy.nvim: neotree, telescope, treesitter
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
-- 6.5) TEXTOBJECTS (después de que plugins estén cargados)
-- ============================================
vim.defer_fn(function()
  local ok = pcall(require, "config.textobjects")
  if not ok then
    print("⚠️  Textobjects no pudo cargar (¿falta nvim-treesitter-textobjects?)")
  end
end, 200)

-- ============================================
-- 7) AI INTEGRATION (OpenCode + Claude Code)
-- ============================================
require("config.ia")