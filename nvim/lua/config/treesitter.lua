-- ~/.config/nvim/lua/config/treesitter.lua
-- ============================================
-- TREESITTER: Syntax highlighting y parsing
-- New nvim-treesitter main branch API
-- ============================================

-- Explicitly start treesitter for filetypes whose filetype name ≠ parser name
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescriptreact", "javascriptreact" },
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})

require("nvim-treesitter").install({
  -- Core
  "lua", "vim", "vimdoc", "query",
  -- Web dev
  "javascript", "typescript", "tsx", "jsx",
  "html", "css", "scss",
  -- Data formats
  "json", "yaml", "toml", "xml",
  -- Documentation
  "markdown", "markdown_inline",
  -- Shell/Config
  "bash", "fish", "dockerfile", "make",
  -- Git
  "git_config", "git_rebase", "gitcommit", "gitignore",
  -- Other languages
  "python", "rust", "go", "c", "cpp",
  -- Misc
  "regex", "comment",
})
