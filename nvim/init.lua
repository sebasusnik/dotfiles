-- ~/.config/nvim/init.lua
-- ============================================
-- NVIM ZEN + OPENCODE
-- ============================================

-- ============================================
-- 1) CONFIG BASE (antes de plugins)
-- ============================================
require("config.options")
require("config.winbar")
require("config.keymaps")

-- ============================================
-- 2) BOOTSTRAP LAZY.NVIM
-- ============================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- 3) PLUGINS
-- ============================================
require("lazy").setup({
    rocks = { hererocks = false }, -- usar luarocks del sistema (brew install luarocks)

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
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree reveal toggle<cr>", desc = "Toggle Neo-tree" },
            { "-",         "<cmd>Neotree reveal<cr>",        desc = "Reveal in Neo-tree" },
            { "<leader>o", "<cmd>Neotree reveal focus<cr>",  desc = "Focus Neo-tree" },
        },
        -- `nvim .` / `nvim <dir>`: cargar neo-tree para que reemplace a netrw
        init = function()
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("NeotreeStartDirectory", { clear = true }),
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then return end
                    local stat = vim.uv.fs_stat(vim.fn.argv(0) --[[@as string]])
                    if stat and stat.type == "directory" then require("neo-tree") end
                end,
            })
        end,
        config = function() require("config.neotree") end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Sorter nativo en C: mucho más rápido en repos grandes
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end,                desc = "Buscar archivos" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,                 desc = "Buscar texto" },
            { "<leader>/",  function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Buscar en archivo" },
            { "<leader>b",  function() require("telescope.builtin").buffers() end,                   desc = "Buscar buffers" },
        },
        config = function() require("config.telescope") end,
    },

    -- ======================
    -- Markdown / imágenes
    -- ======================
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
        },
    },
    {
        "3rd/image.nvim",
        ft = { "markdown" }, -- solo se usa para imágenes inline en markdown
        build = "luarocks --lua-version=5.1 install magick",
        config = function() require("config.image") end,
    },

    -- ======================
    -- LSP / Tooling
    -- ======================
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    },
    { "williamboman/mason-lspconfig.nvim", lazy = true },
    { "neovim/nvim-lspconfig" },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        config = function()
            require("typescript-tools").setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })
        end,
    },
    { "nvim-lua/plenary.nvim", lazy = true },

    -- ======================
    -- Autocomplete + Snippets
    -- ======================
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "roobert/tailwindcss-colorizer-cmp.nvim",
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                config = function() require("config.snippets") end,
            },
        },
        config = function() require("config.cmp") end,
    },
    -- Solo se usa para las capabilities del LSP (no carga nvim-cmp)
    { "hrsh7th/cmp-nvim-lsp", lazy = true },

    -- ======================
    -- Formatter
    -- ======================
    -- Lint: lo hacen los LSP de eslint/biome (ver config/lsp.lua)
    { "stevearc/conform.nvim", lazy = true, cmd = "ConformInfo", opts = {} },

    -- ======================
    -- UI
    -- ======================
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "zaldih/themery.nvim",
        priority = 1000, -- aplicar el theme antes que el resto de la UI
        config = function() require("config.themery") end,
    },
    { "catppuccin/nvim",                  name = "catppuccin",  lazy = true },
    { "rose-pine/neovim",                 name = "rose-pine",   lazy = true },
    { "folke/tokyonight.nvim",            lazy = true },
    { "rebelot/kanagawa.nvim",            lazy = true },
    { "EdenEast/nightfox.nvim",           lazy = true },
    { "ellisonleao/gruvbox.nvim",         lazy = true },
    { "Mofiqul/dracula.nvim",             lazy = true },
    { "navarasu/onedark.nvim",            lazy = true },
    { "sainnhe/everforest",               lazy = true },
    { "projekt0n/github-nvim-theme",      lazy = true },
    { "bluz71/vim-moonfly-colors",        name = "moonfly",     lazy = true },
    { "nyoom-engineering/oxocarbon.nvim", lazy = true },

    -- ======================
    -- Treesitter
    -- ======================
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        -- La rama main NO soporta lazy-loading (ver su README)
        lazy = false,
        config = function() require("config.treesitter") end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        config = function() require("config.textobjects") end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        config = function() require("nvim-ts-autotag").setup() end,
    },

    -- ======================
    -- Edición
    -- ======================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("config.autopairs") end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function() require("nvim-surround").setup() end,
    },
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function() require("config.comment") end,
    },
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({
                default_mappings = false,
                mappings = { i = { j = { k = "<Esc>" } }, v = { j = { k = "<Esc>" } } },
            })
        end,
    },

    -- ======================
    -- Git
    -- ======================
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function() require("config.gitsigns") end,
    },
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "LazyGit",
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },

    -- ======================
    -- Utilidades
    -- ======================
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>sr", function() require("spectre").open() end,                              desc = "Search & replace" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search word" },
        },
        config = function() require("spectre").setup() end,
    },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function() require("todo-comments").setup({ signs = false }) end,
    },
    {
        "RRethy/vim-illuminate",
        event = "BufReadPre",
        config = function()
            require("illuminate").configure({
                delay = 200,
                providers = { "lsp", "treesitter", "regex" },
                large_file_cutoff = 3000,
                filetypes_denylist = { "neo-tree", "TelescopePrompt", "lazy", "mason", "trouble", "help" },
            })
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({ "*" }, { RGB = true, RRGGBB = true, names = false, css = true })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        config = function() require("config.indent") end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>dl", "<cmd>Trouble diagnostics toggle<cr>",             desc = "Trouble (project)" },
            { "<leader>dL", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble (buffer)" },
        },
        config = function()
            require("trouble").setup({ use_diagnostic_signs = true })
        end,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        config = function()
            require("fidget").setup({ notification = { window = { winblend = 0 } } })
        end,
    },

    -- ======================
    -- UI extras
    -- ======================
    {
        "petertriho/nvim-scrollbar",
        event = "BufReadPre",
        config = function() require("config.scrollbar") end,
    },
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        config = function() require("config.zen") end,
    },
    {
        "nvimtools/hydra.nvim",
        event = "VeryLazy",
        config = function() require("config.hydra") end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("config.which-key") end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function() require("config.flash") end,
    },

    -- ======================
    -- AI
    -- ======================
    {
        "milanglacier/minuet-ai.nvim",
        event = "InsertEnter",
        cmd = "Minuet",
        keys = {
            { "<leader>ae", "<cmd>Minuet virtualtext enable<cr>",  desc = "Enable AI completion" },
            { "<leader>ad", "<cmd>Minuet virtualtext disable<cr>", desc = "Disable AI completion" },
            { "<leader>at", "<cmd>Minuet virtualtext toggle<cr>",  desc = "Toggle AI completion" },
            { "<leader>am", "<cmd>Minuet change_model<cr>",        desc = "Change AI model" },
        },
        config = function() require("config.minuet") end,
    },

    -- ======================
    -- Sessions
    -- ======================
    {
        "folke/persistence.nvim",
        lazy = false,
        config = function() require("config.session") end,
    },

}, {
    performance = {
        rtp = {
            -- Plugins built-in que no se usan (netrw lo reemplaza neo-tree)
            disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
    },
})

-- ============================================
-- 4) MÓDULOS (post-plugins)
-- ============================================
require("config.project_tools")
-- Defer LSP setup until the first real file is opened, so mason-lspconfig,
-- vim.lsp.config() and vim.lsp.enable() don't run on an empty startup.
-- BufNewFile cubre `nvim archivo-nuevo.ts` (ahí no hay BufReadPre).
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function() require("config.lsp") end,
})
require("config.formatting")
require("config.ui")
require("config.ia")
require("config.filetypes")
