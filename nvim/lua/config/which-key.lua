-- ~/.config/nvim/lua/config/which-key.lua
-- ============================================
-- WHICH-KEY: Keybinding hints
-- ============================================

require("which-key").setup({
  preset = "modern",
  delay = 500,  -- Delay before showing (ms)
  icons = {
    breadcrumb = "»",
    separator = "→",
    group = "+",
  },
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
})

-- Register keybinding groups (which-key auto-discovers the rest)
require("which-key").add({
  -- Groups
  { "<leader>f",        group = "Find",          icon = { icon = "󰍉", color = "blue" } },
  { "<leader>g",        group = "Grep",          icon = { icon = "󰛔", color = "yellow" } },
  { "<leader>h",        group = "Git Hunks",     icon = { icon = "󰊢", color = "orange" } },
  { "<leader>a",        group = "AI",            icon = { icon = "󰚩", color = "purple" } },
  { "<leader>t",        group = "Theme",         icon = { icon = "󰏘", color = "cyan" } },
  { "<leader>r",        group = "Refactor",      icon = { icon = "󰑕", color = "yellow" } },
  { "<leader>c",        group = "Code",          icon = { icon = "󰅱", color = "azure" } },
  { "<leader>d",        group = "Diagnostics",   icon = { icon = "󰒡", color = "red" } },
  { "<leader>dl",       desc = "Trouble (project)", icon = { icon = "󰝤", color = "red" } },
  { "<leader>dL",       desc = "Trouble (buffer)",  icon = { icon = "󰝤", color = "orange" } },
  { "<leader>s",        group = "Search/Replace", icon = { icon = "󰛔", color = "blue" } },
  { "<leader>sr",       desc = "Search & replace (Spectre)", icon = { icon = "󰛔", color = "blue" } },
  { "<leader>sw",       desc = "Search word (Spectre)",      icon = { icon = "󰛔", color = "blue" } },
  { "<leader>w",        group = "Window/Splits", icon = { icon = "󰕮", color = "grey" } },
  { "<leader>x",        group = "Session",       icon = { icon = "󰆓", color = "cyan" } },
  -- Standalone
  { "<leader>gg",       desc = "LazyGit",                icon = { icon = "", color = "orange" } },
  { "<leader>e",        desc = "Toggle Neo-tree",        icon = { icon = "󰙅", color = "green" } },
  { "<leader>z",        desc = "Zen Mode",               icon = { icon = "󱅻", color = "grey" } },
  { "<leader>q",        desc = "Close file",             icon = { icon = "󰅖", color = "red" } },
  { "<leader><leader>", desc = "Alternate last 2 files", icon = { icon = "󰓁", color = "blue" } },
})
