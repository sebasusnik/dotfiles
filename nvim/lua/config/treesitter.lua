-- ~/.config/nvim/lua/config/treesitter.lua
-- ============================================
-- TREESITTER: Syntax highlighting y parsing
-- ============================================

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

configs.setup({
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "javascript", "typescript", "tsx",
    "json", "yaml", "html", "css",
    "markdown", "markdown_inline",
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
