-- ~/.config/nvim/lua/config/indent.lua
-- ============================================
-- INDENT-BLANKLINE: guías de indentación
-- ============================================

require("ibl").setup({
    indent = { char = "│", highlight = "IblIndent" },
    scope = {
        enabled = true,
        highlight = "IblScope",
        show_start = false,
        show_end = false,
        include = {
            node_type = {
                tsx = {
                    "object", "array",
                    "class_declaration",
                    "interface_declaration",
                    "type_alias_declaration",
                    "enum_declaration",
                    "export_statement",
                },
                typescript = {
                    "object", "array",
                    "class_declaration",
                    "interface_declaration",
                    "type_alias_declaration",
                    "enum_declaration",
                },
            },
        },
    },
})
