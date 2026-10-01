local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local tools = require("config.project_tools")

-- Capabilities de nvim-cmp para TODOS los servers (sin cargar nvim-cmp)
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- ============================================================
-- Mason
-- ============================================================

mason.setup()

mason_lspconfig.setup({
  ensure_installed = { "biome", "eslint", "lua_ls", "tailwindcss" },
  -- Los servers se habilitan a mano abajo. Con automatic_enable (default en
  -- mason-lspconfig v2) se habilita TODO lo instalado en Mason (ej. ts_ls,
  -- que duplicaría a typescript-tools).
  automatic_enable = false,
})

-- Tailwind LSP (with cn/cva/clsx support for shadcn/ui)
vim.lsp.config("tailwindcss", {
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cn\\(([^)]*)\\)",      "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cva\\(([^)]*)\\)",     "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)",      "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "clsx\\(([^)]*)\\)",    "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "twMerge\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
})
vim.lsp.enable("tailwindcss")

-- lua_ls: Neovim config aware
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")

-- ============================================================
-- Keymaps comunes — aplican a TODOS los LSP via LspAttach
-- ============================================================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local nmap = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
    end

    nmap("gd", vim.lsp.buf.definition, "Go to definition")
    nmap("K", vim.lsp.buf.hover, "Hover")
    nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
    nmap("<leader>ca", vim.lsp.buf.code_action, "Code actions")

    -- <leader>dd (no <leader>d): <leader>d también es prefijo de <leader>dl/dL
    -- y nvim esperaba timeoutlen antes de ejecutar el mapping.
    nmap("<leader>dd", vim.diagnostic.open_float, "Diagnostics")
    nmap("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    nmap("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  end,
})

-- ============================================================
-- Biome / ESLint (mutuamente excluyentes)
-- ============================================================
-- Ambos configs de lspconfig solo arrancan si encuentran su archivo de
-- config (biome.json / eslint.config.*). Encima, ESLint no arranca en
-- proyectos con Biome. La decisión es por buffer, así abrir archivos de
-- proyectos distintos no prende/apaga los servers globalmente.

vim.lsp.config("eslint", { settings = { format = false } })

local eslint_root_dir = vim.lsp.config.eslint.root_dir
if type(eslint_root_dir) == "function" then
  vim.lsp.config("eslint", {
    root_dir = function(bufnr, on_dir)
      if tools.detect(bufnr).use_biome then return end
      eslint_root_dir(bufnr, on_dir)
    end,
  })
end

vim.lsp.enable({ "biome", "eslint" })
