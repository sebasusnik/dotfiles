-- ~/.config/nvim/lua/config/filetypes.lua
-- ============================================
-- FILETYPE OVERRIDES Y HANDLERS ESPECIALES
-- ============================================

vim.filetype.add({
    pattern = {
        [".*tailwind.*%.css"] = "scss",
        [".*%.css"]           = "css",
        [".*%.svg"]           = "svg",
    },
})

-- SVG: interceptar apertura antes de leer el archivo y abrir directo en Chrome
local function open_svg_in_browser(file)
    local tmp = vim.fn.tempname() .. ".html"
    local filename = vim.fn.fnamemodify(file, ":t")
    local html = string.format([[<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>%s</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #1a1a1a; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
  img { max-width: 100vw; max-height: 100vh; object-fit: contain; }
</style>
</head>
<body><img src="file://%s"></body>
</html>]], filename, file)
    local f = io.open(tmp, "w")
    if f then
        f:write(html)
        f:close()
        vim.fn.jobstart({ "open", "-a", "Google Chrome", tmp })
    end
end

vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "*.svg",
    callback = function(ev)
        local file = vim.fn.fnamemodify(ev.match, ":p")
        open_svg_in_browser(file)
        vim.schedule(function() vim.cmd("bd!") end)
    end,
    desc = "Abrir SVG en Chrome sin cargar en Neovim",
})
