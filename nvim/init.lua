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
-- Git state cache: updated async on BufEnter/FocusGained, zero render cost
-- dirty = repo-wide (like oh-my-posh), ahead/behind vs remote
local _git = { ahead = 0, behind = 0, dirty = false }
local function _refresh_git()
    vim.fn.jobstart("git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null", {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data and data[1] and data[1] ~= "" then
                local a, b = data[1]:match("(%d+)%s+(%d+)")
                _git.ahead  = tonumber(a) or 0
                _git.behind = tonumber(b) or 0
            else
                _git.ahead, _git.behind = 0, 0
            end
        end,
    })
    vim.fn.jobstart("git status --porcelain 2>/dev/null", {
        stdout_buffered = true,
        on_stdout = function(_, data)
            _git.dirty = data ~= nil and data[1] ~= nil and data[1] ~= ""
        end,
    })
end
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "BufWritePost" }, { callback = _refresh_git })

-- Dynamic winbar: filename + line count + diagnostics (per-window)
local _no_winbar_ft = { "neo-tree", "lazy", "mason", "help", "qf", "TelescopePrompt" }
_G._winbar = function()
    if vim.bo.buftype ~= "" then return "" end
    local ft = vim.bo.filetype
    for _, v in ipairs(_no_winbar_ft) do
        if ft == v then return "" end
    end

    local left = "%#WinBar# %f %#Comment#%l/%L"

    -- Diagnostics for current buffer (errors + warnings only, subtle)
    local diag_str = ""
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warns  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if errors > 0 then diag_str = diag_str .. "%#DiagnosticError# " .. errors .. " " end
    if warns  > 0 then diag_str = diag_str .. "%#DiagnosticWarn# " .. warns  .. " " end

    -- Git branch from gitsigns + repo-wide dirty + ahead/behind (mirrors oh-my-posh zen.toml)
    local branch = vim.b.gitsigns_head
    local git_str = ""
    if branch and branch ~= "" then
        local dirty  = _git.dirty and "*" or ""
        local behind = _git.behind > 0 and "⇣" or ""
        local ahead  = _git.ahead  > 0 and "⇡" or ""
        git_str = "%#Comment#  " .. branch .. dirty .. " " .. behind .. ahead .. " "
    end

    return left .. "%=" .. diag_str .. git_str
end
vim.opt.winbar = "%{%v:lua._winbar()%}"
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = ""
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
-- Using Neovim's default with treesitter for full syntax highlighting

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
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Split izquierda" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Split derecha" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Split abajo" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Split arriba" })
vim.keymap.set("n", "<leader>wq", "<C-w>q", { desc = "Cerrar split" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })

-- Navegación entre buffers (archivos abiertos)
vim.keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Alternar últimos 2 archivos" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { desc = "Cerrar archivo" })

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
            })
        end,
    },
    { "nvim-lua/plenary.nvim" },

    -- ======================
    -- Autocomplete + Snippets
    -- ======================
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-cmdline" },
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
    -- Theme Manager
    -- ======================
    {
        "zaldih/themery.nvim",
        config = function() require("config.themery") end,
    },

    -- Popular colorschemes
    { "catppuccin/nvim", name = "catppuccin" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "folke/tokyonight.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "Mofiqul/dracula.nvim" },
    { "navarasu/onedark.nvim" },
    { "sainnhe/everforest" },
    { "projekt0n/github-nvim-theme" },
    { "bluz71/vim-moonfly-colors", name = "moonfly" },
    { "nyoom-engineering/oxocarbon.nvim" },

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
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        config = function() require("nvim-ts-autotag").setup() end,
    },

    -- ======================
    -- Illuminate (highlight word under cursor)
    -- ======================
    {
        "RRethy/vim-illuminate",
        event = "BufReadPre",
        config = function()
            require("illuminate").configure({
                delay = 200,
                providers = { "lsp", "treesitter", "regex" },
            })
        end,
    },

    -- ======================
    -- Todo comments
    -- ======================
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({ signs = false })
        end,
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

    -- ======================
    -- Hydra (sticky keymaps)
    -- ======================
    {
        "nvimtools/hydra.nvim",
        config = function() require("config.hydra") end,
    },

    -- ======================
    -- Which-key (keybinding hints)
    -- ======================
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function() require("config.which-key") end,
    },

    -- ======================
    -- Flash (fast navigation)
    -- ======================
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function() require("config.flash") end,
    },

    -- ======================
    -- AI Autocompletion (Minuet)
    -- ======================
    {
        "milanglacier/minuet-ai.nvim",
        dependencies = {
            "nvim-cmp",
        },
        config = function() require("config.minuet") end,
    },

    -- ======================
    -- Colorizer (inline color preview)
    -- ======================
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({ "*" }, {
                RGB = true, RRGGBB = true, names = false, css = true,
            })
        end,
    },

    -- ======================
    -- Tailwind color swatches in cmp
    -- ======================
    { "roobert/tailwindcss-colorizer-cmp.nvim" },

    -- ======================
    -- Spectre (project search & replace)
    -- ======================
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>sr", function() require("spectre").open() end,                            desc = "Search & replace" },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search word" },
        },
        config = function()
            require("spectre").setup()
        end,
    },

    -- ======================
    -- Better escape (jk → Esc)
    -- ======================
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup({
                default_mappings = false,
                mappings = {
                    i = { j = { k = "<Esc>" } },
                    v = { j = { k = "<Esc>" } },
                },
            })
        end,
    },

    -- ======================
    -- Autopairs
    -- ======================
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("config.autopairs") end,
    },

    -- ======================
    -- Surround
    -- ======================
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function() require("nvim-surround").setup() end,
    },

    -- ======================
    -- Comments (con soporte JSX/TSX)
    -- ======================
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function() require("config.comment") end,
    },

    -- ======================
    -- Sessions
    -- ======================
    {
        "folke/persistence.nvim",
        lazy = false,
        config = function() require("config.session") end,
    },

    -- ======================
    -- Fidget (LSP progress indicator)
    -- ======================
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        config = function()
            require("fidget").setup({
                notification = { window = { winblend = 0 } },
            })
        end,
    },

    -- ======================
    -- Trouble (diagnostics list)
    -- ======================
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        config = function()
            require("trouble").setup({ use_diagnostic_signs = true })
            vim.keymap.set("n", "<leader>dl", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble (project)" })
            vim.keymap.set("n", "<leader>dL", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble (buffer)" })
        end,
    },

    -- ======================
    -- Lazygit
    -- ======================
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "LazyGit",
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
        end,
    },

    -- ======================
    -- Indent guides
    -- ======================
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│", highlight = "IblIndent" },
                scope  = { enabled = true, highlight = "IblScope", show_start = false, show_end = false },
            })
        end,
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