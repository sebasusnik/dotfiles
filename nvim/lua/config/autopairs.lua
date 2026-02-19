-- ~/.config/nvim/lua/config/autopairs.lua
local autopairs = require("nvim-autopairs")

autopairs.setup({
    check_ts = true, -- use treesitter to check for pairs
    ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        typescript = { "template_string" },
    },
})

-- Integration with nvim-cmp: auto-add closing pair on completion confirm
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
