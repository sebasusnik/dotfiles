-- ~/.config/nvim/lua/config/neotree.lua
-- ============================================
-- NEO-TREE: Navegación de archivos
-- ============================================

require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = false,
  popup_border_style = "rounded",
  window = {
    transparent_panel = true,  -- Make background transparent
    position = "right",
    width = 35,  -- Wider to show file info comfortably
    mappings = {
      ["<cr>"] = {
        function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            require("neo-tree.sources.filesystem.commands").set_root(state)
          else
            require("neo-tree.sources.filesystem.commands").open(state)
          end
        end,
        desc = "Open file or enter directory"
      },
      ["o"] = "toggle_node",  -- Toggle expand/collapse without moving
      ["-"] = "navigate_up",
      ["<space>"] = "none",
      ["<C-w>"] = "none",
    }
  },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = false,
    },
    group_empty_dirs = false,
    use_libuv_file_watcher = false,
  },
  default_component_configs = {
    container = {
      enable_character_fade = false,
    },
    indent = {
      with_markers = false,
      indent_size = 2,
      padding = 0,
    },
    icon = {
      folder_closed = "󰉋",
      folder_open = "󰝰",
      folder_empty = "󰉖",
      default = "󰈙",
    },
    modified = {
      symbol = "",
    },
    git_status = {
      symbols = {
        added     = "",
        modified  = "",
        deleted   = "",
        renamed   = "",
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
      }
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },
    file_size = {
      enabled = true,
      required_width = 30,  -- Show at smaller width
    },
    type = {
      enabled = true,
      required_width = 80,  -- Show file type at larger width
    },
    last_modified = {
      enabled = false,  -- Disable to save space
      required_width = 88,
    },
  },
})

-- Keymaps
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "-", ":Neotree reveal<CR>", { desc = "Reveal in Neo-tree" })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { desc = "Focus Neo-tree" })
