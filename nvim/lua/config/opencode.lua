-- ~/.config/nvim/lua/opencode.lua
-- ============================================
-- OPENCODE INTEGRATION
-- ============================================

-- ============================================
-- Treesitter: seleccionar/copiar función actual (robusto)
-- ============================================

local function get_function_node_at_cursor(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype

  -- Solo para lenguajes donde esto tiene sentido
  local ok_ft = (ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact")
  if not ok_ft then return nil end

  local ok_parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser then return nil end

  local node = vim.treesitter.get_node({ bufnr = bufnr })
  if not node then return nil end

  -- Subimos por los parents buscando algo que "sea una función"
  while node do
    local t = node:type()

    -- Casos directos
    if t == "function_declaration"
      or t == "method_definition"
      or t == "function_expression"
      or t == "arrow_function"
    then
      return node
    end

    -- Caso: const foo = () => {}  (variable_declarator)
    if t == "variable_declarator" then
      for child in node:iter_children() do
        local ct = child:type()
        if ct == "arrow_function" or ct == "function_expression" then
          return node -- devolvemos el declarator para incluir el "const foo ="
        end
      end
    end

    node = node:parent()
  end

  return nil
end

local function select_node_range(node)
  local srow, scol, erow, ecol = node:range()
  -- selección linewise (más cómodo para copiar)
  vim.api.nvim_win_set_cursor(0, { srow + 1, 0 })
  vim.cmd("normal! V")
  vim.api.nvim_win_set_cursor(0, { erow + 1, 0 })
end

-- Copiar selección visual a clipboard (sistema)
vim.keymap.set('v', '<leader>oc', '"*y', { desc = 'Copiar selección' })

-- Copiar función completa donde está el cursor (Treesitter)
vim.keymap.set("n", "<leader>oc", function()
  local node = get_function_node_at_cursor(0)
  if node then
    select_node_range(node)
    vim.cmd([[normal! "*y]])
    vim.cmd("normal! gv") -- deja la selección visible un toque
    print("✓ Función copiada (Treesitter)")
    return
  end

  -- Fallback (si Treesitter no engancha)
  local pos = vim.fn.getpos(".")
  vim.cmd("normal! [[")
  vim.cmd("normal! V][")
  vim.cmd([[normal! "*y]])
  vim.fn.setpos(".", pos)
  print("✓ Función copiada (fallback)")
end, { desc = "Copiar función" })

-- Copiar líneas específicas (pregunta rango)
vim.keymap.set('n', '<leader>ol', function()
    local current = vim.fn.line('.')
    vim.ui.input({ prompt = 'Inicio (default ' .. current .. '): ', default = tostring(current) },
        function(start_input)
            if not start_input then return end
            local start_line = tonumber(start_input) or current
            vim.ui.input({ prompt = 'Fin: ', default = tostring(start_line + 20) },
                function(end_input)
                    if not end_input then return end
                    local end_line = tonumber(end_input)
                    vim.cmd('normal! ' .. start_line .. 'GV' .. end_line .. 'G"*y')
                    print("✓ Líneas " .. start_line .. "-" .. end_line .. " copiadas")
                end)
        end)
end, { desc = 'Copiar líneas' })

-- Copiar archivo completo
vim.keymap.set('n', '<leader>oa', function()
    local file = vim.fn.expand('%:t')
    local lines = vim.fn.getline(1, '$')
    local content = table.concat(lines, '\n')
    local ext = file:match('%.([^%.]+)$') or 'txt'
    local formatted = string.format("Archivo: %s\n```%s\n%s\n```", file, ext, content)
    vim.fn.setreg('*', formatted)
    print("✓ Archivo copiado (" .. #lines .. " líneas)")
end, { desc = 'Copiar archivo' })

-- Iniciar selección visual línea
vim.keymap.set('n', '<leader>v', 'V', { desc = 'Selección línea' })

-- ============================================
-- Copiar/seleccionar type/interface/enum (TypeScript)
-- ============================================

local function get_type_node_at_cursor(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype

  -- Solo para TS
  if not (ft == "typescript" or ft == "typescriptreact") then return nil end

  local ok_parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser then return nil end

  local node = vim.treesitter.get_node({ bufnr = bufnr })
  if not node then return nil end

  while node do
    local t = node:type()

    if t == "type_alias_declaration" or
       t == "interface_declaration" or
       t == "enum_declaration" then
      return node
    end

    node = node:parent()
  end

  return nil
end

-- Copiar type/interface/enum donde está el cursor
vim.keymap.set("n", "<leader>oct", function()
  local node = get_type_node_at_cursor(0)
  if node then
    select_node_range(node)
    vim.cmd([[normal! "*y]])
    vim.cmd("normal! gv")
    print("✓ Type/Interface copiado (Treesitter)")
    return
  end

  print("⚠️  No hay type/interface/enum en el cursor (solo TS)")
end, { desc = "Copiar type/interface" })

-- Seleccionar type/interface/enum visualmente
vim.keymap.set("n", "<leader>vt", function()
  local node = get_type_node_at_cursor(0)
  if node then
    select_node_range(node)
    print("📍 Type/Interface seleccionado")
    return
  end

  print("⚠️  No hay type/interface/enum en el cursor")
end, { desc = "Seleccionar type/interface" })

-- Seleccionar función visualmente (para ver antes de copiar)
vim.keymap.set("n", "<leader>vf", function()
  local node = get_function_node_at_cursor(0)
  if node then
    select_node_range(node)
    print("📍 Función seleccionada - presiona 'y' para copiar")
    return
  end

  vim.cmd("normal! [[V][")
  print("📍 Función seleccionada (fallback)")
end, { desc = "Seleccionar función" })

-- Buscar palabra bajo cursor en proyecto
vim.keymap.set('n', '<leader>*', function()
    require('telescope.builtin').grep_string()
end, { desc = 'Buscar palabra' })

-- Preparar para OpenCode (guardar)
vim.keymap.set('n', '<leader>os', function()
    vim.cmd('w')
    print("✓ Guardado. Cambia a OpenCode y pega con Ctrl+V")
end, { desc = 'Preparar para OpenCode' })

-- Copiar contexto completo del archivo (imports + código actual)
vim.keymap.set('n', '<leader>ox', function()
    local file = vim.fn.expand('%:t')
    local lines = vim.fn.getline(1, '$')
    local content = table.concat(lines, '\n')
    local ext = file:match('%.([^%.]+)$') or 'txt'
    local path = vim.fn.expand('%:~:.')

    local formatted = string.format(
        "📁 %s\n\n```%s\n%s\n```\n\nLíneas: %d | Caracteres: %d",
        path, ext, content, #lines, #content
    )
    vim.fn.setreg('*', formatted)
    print("✓ Contexto completo copiado")
end, { desc = 'Copiar con contexto' })

-- Copiar cambios git del archivo actual
vim.keymap.set('n', '<leader>od', function()
    local file = vim.fn.expand('%')
    local diff = vim.fn.system('git diff ' .. file)
    if diff == '' then
        diff = vim.fn.system('git diff --cached ' .. file)
    end
    if diff == '' then
        print("⚠️  No hay cambios git en este archivo")
        return
    end
    local formatted = string.format("Git diff de %s:\n```diff\n%s\n```", vim.fn.expand('%:t'), diff)
    vim.fn.setreg('*', formatted)
    print("✓ Git diff copiado")
end, { desc = 'Copiar git diff' })

-- Copiar estructura del proyecto (tree)
vim.keymap.set('n', '<leader>ot', function()
    local output
    local method = ""

    -- Verificar si eza está disponible (preferido)
    if vim.fn.executable('eza') == 1 then
        output = vim.fn.system('eza --tree --level=3 --git-ignore --icons')
        method = " (eza)"
    -- Si no, intentar tree real (bypass de funciones de shell)
    elseif vim.fn.executable('tree') == 1 then
        output = vim.fn.system('command tree -L 2 -I "node_modules|.git|dist|build|.next" --charset ascii')
        method = " (tree)"
    else
        -- Fallback: estructura simple con find
        local cwd = vim.fn.getcwd()
        local project_name = vim.fn.fnamemodify(cwd, ':t')

        local structure_cmd = [[
echo "$(basename $(pwd))/"
find . -maxdepth 1 -type d ! -name "." ! -name ".git" ! -name "node_modules" ! -name "dist" ! -name "build" ! -name ".next" | sed 's|^\./|  |' | sort
find . -maxdepth 1 -type f \( -name "*.json" -o -name "*.js" -o -name "*.ts" -o -name "*.md" -o -name ".*rc" \) | sed 's|^\./|  |' | sort | head -10
echo ""
for dir in src app lib components pages; do
  if [ -d "$dir" ]; then
    echo "  $dir/"
    find "$dir" -maxdepth 1 -type f | sed 's|^|    |' | head -5
  fi
done
]]
        output = vim.fn.system(structure_cmd)
        method = " (find)"
        if output == "" or output:match("^%s*$") then
            output = project_name .. "/\n  (instala: brew install eza)"
        end
    end

    local formatted = string.format("📂 Estructura del proyecto:\n```\n%s\n```", output)
    vim.fn.setreg('*', formatted)
    print("✓ Estructura copiada" .. method)
end, { desc = 'Copiar tree' })