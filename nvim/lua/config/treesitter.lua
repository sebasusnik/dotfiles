-- ~/.config/nvim/lua/config/treesitter.lua
-- ============================================
-- TREESITTER: Syntax highlighting y parsing
-- New nvim-treesitter main branch API
-- ============================================

-- En la rama main, nvim-treesitter NO activa el highlighting: hay que llamar
-- vim.treesitter.start() por buffer. Sin esto, .ts/.js/.css/etc. quedaban con
-- el syntax regex viejo (más lento y menos preciso).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].bigfile then return end -- ver config/options.lua
    -- pcall: falla si no hay parser instalado para el filetype
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
