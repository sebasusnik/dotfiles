-- ~/.config/nvim/lua/config/comment.lua
-- Comment.nvim with JSX/TSX context-aware commenting

require("ts_context_commentstring").setup({ enable_autocmd = false })

require("Comment").setup({
    -- Use ts-context-commentstring for correct comment style per filetype
    -- (e.g. {/* */} in JSX instead of //)
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
})
