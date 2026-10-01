local cmp = require("cmp")
local luasnip = require("luasnip")

-- Sugerencia inline de minuet visible? (minuet carga en InsertEnter y puede
-- no estar configurado si faltan las env vars)
local function minuet_visible()
  local ok, vt = pcall(require, "minuet.virtualtext")
  return ok and vt.action.is_visible()
end

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
      elseif minuet_visible() then
        require("minuet.virtualtext").action.accept()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif minuet_visible() then
        require("minuet.virtualtext").action.dismiss()
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
