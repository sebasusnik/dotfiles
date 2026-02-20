-- ~/.config/nvim/lua/config/image.lua
-- ============================================
-- IMAGE.NVIM: Renderizado de imágenes inline
-- Requiere: imagemagick + luarocks + magick rock
-- ============================================

require("image").setup({
    backend = "kitty", -- Ghostty soporta kitty graphics protocol
    integrations = {
        markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
            filetypes = { "markdown" },
        },
    },
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    -- hijack deshabilitado: causa race condition al abrir desde neo-tree
    -- los archivos de imagen se abren en Chrome via config/filetypes.lua
    hijack_file_patterns = {},
})
