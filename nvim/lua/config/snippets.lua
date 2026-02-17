local luasnip = require("luasnip")

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

-- TS
luasnip.add_snippets("typescript", {
  s("clg", { t("console.log("), i(1), t(")") }),
  s("imp", { t("import "), i(1, "Thing"), t(" from '"), i(2, "module"), t("';") }),
})

-- TSX
luasnip.add_snippets("typescriptreact", {
  s("rfc", {
    t("export function "), i(1, "Component"), t("() {"),
    t({ "", "  return (", "    <div>" }), i(2, "hola"), t({ "</div>", "  )", "}" }),
  }),
})