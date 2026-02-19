-- ~/.config/nvim/lua/config/minuet.lua
-- ============================================
-- MINUET: AI Autocompletion for Neovim
-- ============================================
-- Uses OpenAI-compatible adapter with Kimi API (Moonshot)

-- Get configuration from environment (no fallbacks - must be set in ~/.zshenv)
local ai_model = os.getenv("AI_MODEL_PLUS")
local ai_url = os.getenv("AI_BASE_URL")
local ai_key_value = os.getenv("AI_API_KEY_PLUS")

-- Validate required environment variables
if not ai_model or not ai_url or not ai_key_value then
  vim.notify(
    "Missing AI config! Set AI_MODEL_PLUS, AI_BASE_URL, and AI_API_KEY_PLUS in ~/.zshenv",
    vim.log.levels.ERROR
  )
  return
end

require("minuet").setup({
  provider = "openai_compatible",
  provider_options = {
    openai_compatible = {
      model = ai_model,
      -- Use a function to return the API key
      api_key = function()
        return vim.env.AI_API_KEY_PLUS or os.getenv("AI_API_KEY_PLUS")
      end,
      name = "Kimi",
      end_point = ai_url .. "/chat/completions",
      optional = {
        max_tokens = 256,
        -- Remove top_p and temperature to use model defaults
      },
    },
  },
  -- Enable virtual text mode (inline ghost text like Copilot)
  virtualtext = {
    -- Auto-trigger for all filetypes (use {'*'} for all, or specify like {'python', 'lua'})
    auto_trigger_ft = { '*' },
    keymap = {
      accept = '<Tab>',           -- Accept whole completion
      accept_line = '<A-a>',      -- Accept one line (Alt-a)
      dismiss = '<S-Tab>',        -- Dismiss suggestion
      prev = '<A-[>',             -- Previous suggestion (Alt-[)
      next = '<A-]>',             -- Next suggestion (Alt-])
    },
  },
  -- Throttle and debounce (reduced for faster response)
  throttle = 500,
  debounce = 200,
  request_timeout = 5,
  context_window = 8192,
  notify = 'warn',  -- Only show warnings and errors
})

-- Commands to test/control Minuet:
-- :Minuet virtualtext enable  - Enable virtual text mode
-- :Minuet virtualtext disable - Disable virtual text mode
-- :Minuet virtualtext toggle  - Toggle virtual text mode
-- :Minuet change_model        - Change AI model interactively

-- Keybindings
vim.keymap.set('n', '<leader>ae', '<cmd>Minuet virtualtext enable<cr>', { desc = "Enable AI completion" })
vim.keymap.set('n', '<leader>ad', '<cmd>Minuet virtualtext disable<cr>', { desc = "Disable AI completion" })
vim.keymap.set('n', '<leader>at', '<cmd>Minuet virtualtext toggle<cr>', { desc = "Toggle AI completion" })
vim.keymap.set('n', '<leader>am', '<cmd>Minuet change_model<cr>', { desc = "Change AI model" })
