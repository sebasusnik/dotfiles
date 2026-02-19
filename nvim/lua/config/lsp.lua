local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local tools = require("config.project_tools")
local cmpcfg = require("config.cmp")

-- ============================================================
-- Mason
-- ============================================================

mason.setup()

mason_lspconfig.setup({
  ensure_installed = { "biome", "eslint" }
})

-- ⚠️ IMPORTANTE:
-- Desactivamos eslint por defecto.
-- Solo lo activamos si el proyecto realmente lo necesita.
vim.lsp.enable("eslint", false)

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

    nmap("<leader>d", vim.diagnostic.open_float, "Diagnostics")
    nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

-- ============================================================
-- Biome / ESLint (mutuamente excluyentes)
-- ============================================================

local function stop_client(bufnr, name)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == name then
      client.stop()
    end
  end
end

local function enable_server(server_name)
  vim.lsp.config(server_name, {
    capabilities = cmpcfg.capabilities,
    settings = server_name == "eslint" and { format = false } or nil,
  })

  vim.lsp.enable(server_name, true)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    if not (
      ft == "javascript"
      or ft == "javascriptreact"
      or ft == "typescript"
      or ft == "typescriptreact"
    ) then
      return
    end

    local det = tools.detect(args.buf)

    if det.use_biome then
      -- Proyecto usa Biome → ESLint apagado
      stop_client(args.buf, "eslint")
      vim.lsp.enable("eslint", false)
      enable_server("biome")

    elseif det.use_eslint then
      -- Proyecto usa ESLint → lo habilitamos
      vim.lsp.enable("eslint", true)
      enable_server("eslint")
    end
  end,
})