-- ~/.config/nvim/lua/config/themery.lua
-- ============================================
-- THEMERY: Theme Browser & Manager
-- ============================================

require("themery").setup({
  -- Live preview as you navigate
  livePreview = true,
  themes = {
    -- Neovim default
    {
      name = "Default",
      colorscheme = "default",
      before = [[
        vim.opt.background = "dark"
      ]],
    },
    -- Catppuccin variants
    {
      name = "Catppuccin Mocha (warm, cozy)",
      colorscheme = "catppuccin-mocha",
      before = [[
        require("catppuccin").setup({
          flavour = "mocha",
          transparent_background = false,
        })
      ]],
    },
    {
      name = "Catppuccin Macchiato",
      colorscheme = "catppuccin-macchiato",
    },
    -- Rose Pine variants
    {
      name = "Rose Pine Moon (minimal, elegant) ⭐",
      colorscheme = "rose-pine-moon",
      before = [[
        require("rose-pine").setup({
          variant = "moon",
          dark_variant = "moon",
        })
      ]],
    },
    {
      name = "Rose Pine Main",
      colorscheme = "rose-pine",
    },
    -- Tokyo Night variants
    {
      name = "Tokyo Night (vibrant, modern)",
      colorscheme = "tokyonight-night",
      before = [[
        require("tokyonight").setup({
          style = "night",
        })
      ]],
    },
    {
      name = "Tokyo Night Storm",
      colorscheme = "tokyonight-storm",
    },
    -- Kanagawa
    {
      name = "Kanagawa Wave (calm, nature)",
      colorscheme = "kanagawa-wave",
      before = [[
        require("kanagawa").setup({
          theme = "wave",
        })
      ]],
    },
    {
      name = "Kanagawa Dragon (darker)",
      colorscheme = "kanagawa-dragon",
    },
    -- Nightfox variants
    {
      name = "Nightfox (balanced)",
      colorscheme = "nightfox",
    },
    {
      name = "Carbonfox (minimal, gray)",
      colorscheme = "carbonfox",
    },
    {
      name = "Nordfox (cool blues)",
      colorscheme = "nordfox",
    },
    {
      name = "Dawnfox (warm light) ☀️",
      colorscheme = "dawnfox",
    },
    -- Gruvbox
    {
      name = "Gruvbox Dark (warm, retro)",
      colorscheme = "gruvbox",
      before = [[
        require("gruvbox").setup({
          contrast = "hard",
        })
        vim.opt.background = "dark"
      ]],
    },
    {
      name = "Gruvbox Light ☀️",
      colorscheme = "gruvbox",
      before = [[
        vim.opt.background = "light"
      ]],
    },
    -- Dracula
    {
      name = "Dracula (purple, vibrant)",
      colorscheme = "dracula",
    },
    -- OneDark
    {
      name = "OneDark (clean, professional)",
      colorscheme = "onedark",
      before = [[
        require("onedark").setup({
          style = "dark",
        })
      ]],
    },
    -- Everforest
    {
      name = "Everforest (soft green)",
      colorscheme = "everforest",
      before = [[
        vim.g.everforest_background = "hard"
        vim.opt.background = "dark"
      ]],
    },
    -- GitHub
    {
      name = "GitHub Dark",
      colorscheme = "github_dark",
    },
    {
      name = "GitHub Light ☀️",
      colorscheme = "github_light",
    },
    -- Moonfly
    {
      name = "Moonfly (dark blue)",
      colorscheme = "moonfly",
    },
    -- Oxocarbon
    {
      name = "Oxocarbon (IBM Carbon)",
      colorscheme = "oxocarbon",
    },
  },
})

-- Keybinding to open theme browser
vim.keymap.set("n", "<leader>th", "<cmd>Themery<cr>", { desc = "Theme Browser" })
