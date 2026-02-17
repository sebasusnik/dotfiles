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
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                enable_git_status = true,
                enable_diagnostics = false,
                popup_border_style = "rounded",
                window = {
                    position = "right",
                    width = 24,
                    mappings = {
                        ["<cr>"] = {
                            function(state)
                                local node = state.tree:get_node()
                                if node.type == "directory" then
                                    require("neo-tree.sources.filesystem.commands").set_root(state)
                                else
                                    require("neo-tree.sources.filesystem.commands").open(state)
                                end
                            end,
                            desc = "Open file or enter directory"
                        },
                        ["-"] = "navigate_up",
                        ["<space>"] = "none",
                        ["<C-w>"] = "none",
                    }
                },
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file = {
                        enabled = false,
                    },
                    group_empty_dirs = false,
                    use_libuv_file_watcher = false,
                },
                default_component_configs = {
                    container = {
                        enable_character_fade = false,
                    },
                    indent = {
                        with_markers = false,
                        indent_size = 2,
                        padding = 0,
                    },
                    icon = {
                        folder_closed = "󰉋",
                        folder_open = "󰝰",
                        folder_empty = "󰉖",
                        default = "󰈙",
                    },
                    modified = {
                        symbol = "",
                    },
                    git_status = {
                        symbols = {
                            added     = "",
                            modified  = "",
                            deleted   = "",
                            renamed   = "",
                            untracked = "",
                            ignored   = "",
                            unstaged  = "",
                            staged    = "",
                        }
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                    },
                },
            })
            vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
            vim.keymap.set("n", "-", ":Neotree reveal<CR>", { desc = "Reveal in Neo-tree" })
            vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus Neo-tree" })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")

            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    file_ignore_patterns = {
                        "node_modules/",
                        ".git/",
                        "dist/",
                        "build/",
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                        "--glob=!node_modules/",
                        "--glob=!dist/",
                        "--glob=!build/",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        previewer = false,
                    },
                    live_grep = {
                        previewer = false,
                    },
                    buffers = {
                        previewer = false,
                    },
                    current_buffer_fuzzy_find = {
                        previewer = false,
                    },
                },
            })

            vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Buscar archivos" })
            vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Buscar texto" })
            vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Buscar en archivo" })
            vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buscar buffers" })
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