-- ~/.config/nvim/lua/config/treesitter.lua
-- ============================================
-- TREESITTER: Syntax highlighting y parsing
-- ============================================

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

configs.setup({
  ensure_installed = {
    -- Core
    "lua", "vim", "vimdoc", "query",
    -- Web dev
    "javascript", "typescript", "tsx", "jsx",
    "html", "css", "scss",
    -- Data formats
    "json", "jsonc", "yaml", "toml", "xml",
    -- Documentation
    "markdown", "markdown_inline",
    -- Shell/Config
    "bash", "fish", "zsh",
    "dockerfile", "make",
    -- Git
    "git_config", "git_rebase", "gitcommit", "gitignore",
    -- Other languages
    "python", "rust", "go", "c", "cpp",
    -- Misc
    "regex", "comment",
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
    },
  },
})
