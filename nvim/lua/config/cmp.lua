local cmp = require("cmp")
local luasnip = require("luasnip")

-- snippets “tipo VSCode” (React/TS/etc)
require("luasnip.loaders.from_vscode").lazy_load()

local tw_colorizer = require("tailwindcss-colorizer-cmp")

cmp.setup({
  formatting = {
    format = tw_colorizer.formatter,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      -- Priority: cmp menu > luasnip > minuet > fallback
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        -- Let minuet handle Tab if it has a suggestion, otherwise fallback
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
  },
})

-- Cmdline autocomplete (: commands and / search)
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline" } }
  ),
})
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- Exportamos capabilities para LSP
local M = {}
M.capabilities = require("cmp_nvim_lsp").default_capabilities()
return M