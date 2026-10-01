-- ~/.config/nvim/lua/config/ts_nav.lua
-- ============================================
-- Navegación por declaraciones (TS/JS) con treesitter.
-- Compartido por config/hydra.lua (<leader>n) y config/textobjects.lua (]m/[m)
-- ============================================

local M = {}

local supported_ft = {
  typescript = true,
  javascript = true,
  typescriptreact = true,
  javascriptreact = true,
}

local valid_node_types = {
  function_declaration = true,
  method_definition = true,
  function_expression = true,
  arrow_function = true,
  lexical_declaration = true,    -- const/let
  variable_declaration = true,   -- var
  type_alias_declaration = true, -- type
  interface_declaration = true,  -- interface
  enum_declaration = true,       -- enum
  class_declaration = true,      -- class
}

local function is_valid_node(node)
  local node_type = node:type()
  if valid_node_types[node_type] then return true end
  -- Incluir export_statement si su hijo es válido
  if node_type == "export_statement" then
    for child in node:iter_children() do
      if valid_node_types[child:type()] then return true end
    end
  end
  return false
end

---Mueve el cursor a la declaración siguiente (dir = 1) o anterior (dir = -1)
---@param dir 1|-1
function M.goto_declaration(dir)
  if not supported_ft[vim.bo.filetype] then
    vim.notify("Navegación solo disponible en archivos TS/JS", vim.log.levels.INFO)
    return
  end

  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then
    vim.notify("Treesitter no disponible para este archivo", vim.log.levels.WARN)
    return
  end

  local trees = parser:parse()
  if not trees or #trees == 0 then return end

  local current_row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
  local best_row = dir == 1 and math.huge or -1

  -- Recorre el árbol podando subárboles que no pueden mejorar el resultado
  -- (los hijos empiezan entre start_row y end_row del padre). Antes se
  -- visitaba el árbol entero en cada tecla.
  local function visit(n)
    local start_row, _, end_row = n:range()
    if dir == 1 then
      if end_row <= current_row or start_row >= best_row then return end
      if start_row > current_row and is_valid_node(n) then
        best_row = start_row
        return -- los hijos empiezan en start_row o después: no mejoran
      end
    else
      if start_row >= current_row or end_row <= best_row then return end
      if start_row > best_row and is_valid_node(n) then
        best_row = start_row
      end
    end
    for child in n:iter_children() do
      visit(child)
    end
  end

  visit(trees[1]:root())

  if best_row ~= math.huge and best_row ~= -1 then
    vim.cmd("normal! m'") -- dejar la posición en el jumplist (<C-o> para volver)
    vim.api.nvim_win_set_cursor(0, { best_row + 1, 0 })
  end
end

return M
