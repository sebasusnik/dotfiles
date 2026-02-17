require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "yaml",
    "html",
    "css",
    "markdown",
    "markdown_inline",
  },

  highlight = { enable = true },

  indent = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",      -- empezar selección
      node_incremental = "<CR>",    -- agrandar (nodo)
      node_decremental = "<BS>",    -- achicar
      scope_incremental = "<TAB>",  -- agrandar por scope
    },
  },
})