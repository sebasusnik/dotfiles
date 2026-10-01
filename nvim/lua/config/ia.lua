-- ~/.config/nvim/lua/config/ia.lua
-- ============================================
-- UNIFIED AI INTEGRATION (OpenCode + Claude Code)
-- ============================================

-- ============================================
-- Helpers: Treesitter para funciones
-- ============================================

local function get_function_node_at_cursor(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype

  -- Solo para lenguajes donde esto tiene sentido
  local ok_ft = (ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact")
  if not ok_ft then return nil end

  -- FORZAR inicialización de treesitter
  local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser or not parser then return nil end

  -- Forzar parse
  pcall(function() parser:parse() end)

  local node = vim.treesitter.get_node({ bufnr = bufnr })
  if not node then return nil end

  -- Subimos por los parents buscando algo que "sea una función"
  while node do
    local t = node:type()
    local found_node ---@type TSNode?

    -- Casos directos
    if t == "function_declaration"
      or t == "method_definition"
      or t == "function_expression"
      or t == "arrow_function"
    then
      found_node = node
    end

    -- Caso: const foo = () => {}  (variable_declarator con función)
    if t == "variable_declarator" then
      for child in node:iter_children() do
        local ct = child:type()
        if ct == "arrow_function" or ct == "function_expression" then
          found_node = node
          break
        end
      end
    end

    -- Caso: lexical_declaration (const/let) o variable_declaration (var)
    if t == "lexical_declaration" or t == "variable_declaration" then
      -- Buscar si contiene una función
      for child in node:iter_children() do
        if child:type() == "variable_declarator" then
          for grandchild in child:iter_children() do
            local gct = grandchild:type()
            if gct == "arrow_function" or gct == "function_expression" then
              found_node = node
              break
            end
          end
        end
        if found_node then break end
      end
    end

    -- Si encontramos un nodo válido, verificar si su parent es export_statement
    if found_node then
      local parent = found_node:parent()
      if parent and parent:type() == "export_statement" then
        return parent  -- Retornar export completo
      else
        return found_node
      end
    end

    node = node:parent()
  end

  return nil
end

local function get_type_node_at_cursor(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype

  -- Solo para TS
  if not (ft == "typescript" or ft == "typescriptreact") then return nil end

  -- FORZAR inicialización de treesitter
  local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser or not parser then return nil end

  -- Forzar parse
  pcall(function() parser:parse() end)

  local node = vim.treesitter.get_node({ bufnr = bufnr })
  if not node then return nil end

  while node do
    local t = node:type()
    local found_node ---@type TSNode?

    -- Types, interfaces, enums, variables - SOLO OUTER nodes
    if t == "type_alias_declaration"
       or t == "interface_declaration"
       or t == "enum_declaration"
       or t == "lexical_declaration"
       or t == "variable_declaration" then
      found_node = node
    end

    -- Si encontramos un nodo válido, verificar si su parent es export_statement
    if found_node then
      local parent = found_node:parent()
      if parent and parent:type() == "export_statement" then
        return parent  -- Retornar export completo
      else
        return found_node
      end
    end

    node = node:parent()
  end

  return nil
end

local function select_node_range(node)
  local srow, _, erow, _ = node:range()
  -- node:range() devuelve 0-indexed, erow es EXCLUSIVO

  local start_line = srow + 1
  local end_line = erow + 1  -- Sumar 1 para incluir la última línea

  -- Método oficial de nvim-treesitter-textobjects
  vim.cmd('normal! V')
  vim.api.nvim_win_set_cursor(0, {start_line, 0})
  vim.cmd('normal! o')
  vim.api.nvim_win_set_cursor(0, {end_line, 0})
end

-- ============================================
-- Tmux Integration: enviar a pane derecho
-- ============================================

local function is_in_tmux()
  return os.getenv("TMUX") ~= nil
end

-- Obtener path relativo del archivo actual
local function get_relative_path()
  local full_path = vim.fn.expand('%:p')
  -- Obtener path relativo desde el cwd
  local relative = vim.fn.fnamemodify(full_path, ':~:.')
  return relative
end

-- Enviar referencia de archivo con líneas al AI (sin Enter)
local function send_file_reference(filepath, start_line, end_line)
  if not is_in_tmux() then
    print("⚠️  No estás en tmux")
    return false
  end

  local reference
  if start_line and end_line then
    reference = string.format("@%s#L%d-%d ", filepath, start_line, end_line)
  else
    reference = string.format("@%s ", filepath)
  end

  -- Enviar sin Enter - el usuario agrega su pregunta
  local cmd = string.format(
    "tmux send-keys -t right %s",
    vim.fn.shellescape(reference)
  )

  vim.fn.system(cmd)

  if vim.v.shell_error == 0 then
    return true
  else
    print("⚠️  Error al enviar a tmux (¿existe pane derecho?)")
    return false
  end
end

-- Guardar contenido en archivo temporal y enviar referencia
local function send_temp_file_reference(content, filename)
  if not is_in_tmux() then
    print("⚠️  No estás en tmux")
    return false
  end

  -- Crear archivo temporal
  local tmpfile = string.format("/tmp/%s", filename)
  local file = io.open(tmpfile, "w")
  if not file then
    print("⚠️  Error al crear archivo temporal")
    return false
  end

  file:write(content)
  file:close()

  -- Enviar referencia al archivo temporal
  return send_file_reference(tmpfile, nil, nil)
end

-- ============================================
-- Comandos de integración
-- ============================================

-- Enviar selección visual como referencia de líneas
vim.keymap.set('v', '<leader>ac', function()
  -- Obtener las posiciones de la selección visual actual
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- Asegurar que start esté antes que end
  local start_line = math.min(start_pos[2], end_pos[2])
  local end_line = math.max(start_pos[2], end_pos[2])

  local filepath = get_relative_path()

  if send_file_reference(filepath, start_line, end_line) then
    print("✓ Referencia enviada: @" .. filepath .. "#L" .. start_line .. "-" .. end_line)
    print("💬 Escribe tu pregunta en el AI")
  end
end, { desc = 'Enviar selección a AI' })

-- Enviar función/type/enum donde está el cursor (inteligente)
vim.keymap.set("n", "<leader>af", function()
  local filepath = get_relative_path()

  -- Intentar encontrar función primero
  local node = get_function_node_at_cursor(0)
  local node_type = "función"

  -- Si no hay función, intentar type/interface/enum
  if not node then
    node = get_type_node_at_cursor(0)
    node_type = "type/enum"
  end

  if node then
    local srow, _, erow, _ = node:range()
    -- node:range() devuelve 0-indexed, erow es EXCLUSIVO
    -- Para 1-indexed: start = srow + 1, end = erow + 1
    local start_line = srow + 1
    local end_line = erow + 1

    if send_file_reference(filepath, start_line, end_line) then
      print("✓ " .. node_type .. " enviada: @" .. filepath .. "#L" .. start_line .. "-" .. end_line)
      print("💬 Escribe tu pregunta en el AI")
    end

    -- Seleccionar visualmente para que veas qué se envió
    select_node_range(node)
    return
  end

  -- Si no encontró nada con Treesitter, notificar
  print("⚠️  No se encontró función ni type/enum en el cursor")
end, { desc = "Enviar función/type a AI" })

-- Enviar type/interface/enum donde está el cursor
vim.keymap.set("n", "<leader>ay", function()
  local filepath = get_relative_path()
  local node = get_type_node_at_cursor(0)

  if node then
    local srow, _, erow, _ = node:range()
    -- node:range() es 0-indexed, erow es EXCLUSIVO
    local start_line = srow + 1
    local end_line = erow + 1  -- Sumar 1 para incluir la última línea

    if send_file_reference(filepath, start_line, end_line) then
      print("✓ Type enviado: @" .. filepath .. "#L" .. start_line .. "-" .. end_line)
      print("💬 Escribe tu pregunta en el AI")
    end

    -- Seleccionar visualmente para que veas qué se envió
    select_node_range(node)
    return
  end

  print("⚠️  No hay type/interface/enum en el cursor (solo TS)")
end, { desc = "Enviar type/interface a AI" })

-- Enviar líneas específicas (pregunta rango)
vim.keymap.set('n', '<leader>al', function()
  local filepath = get_relative_path()
  local current = vim.fn.line('.')

  vim.ui.input({ prompt = 'Inicio (default ' .. current .. '): ', default = tostring(current) },
    function(start_input)
      if not start_input then return end
      local start_line = tonumber(start_input) or current
      vim.ui.input({ prompt = 'Fin: ', default = tostring(start_line + 20) },
        function(end_input)
          if not end_input then return end
          local end_line = tonumber(end_input)

          if send_file_reference(filepath, start_line, end_line) then
            print("✓ Líneas enviadas: @" .. filepath .. "#L" .. start_line .. "-" .. end_line)
            print("💬 Escribe tu pregunta en el AI")
          end
        end)
    end)
end, { desc = 'Enviar líneas a AI' })

-- Enviar archivo completo
vim.keymap.set('n', '<leader>aa', function()
  local filepath = get_relative_path()
  local lines = vim.fn.getline(1, '$')

  if send_file_reference(filepath, nil, nil) then
    print("✓ Archivo enviado: @" .. filepath .. " (" .. #lines .. " líneas)")
    print("💬 Escribe tu pregunta en el AI")
  end
end, { desc = 'Enviar archivo a AI' })

-- Buscar palabra bajo cursor en proyecto
vim.keymap.set('n', '<leader>*', function()
  require('telescope.builtin').grep_string()
end, { desc = 'Buscar palabra' })

-- Enviar cambios git del archivo actual
vim.keymap.set('n', '<leader>ag', function()
  local file = vim.fn.expand('%')
  -- Lista de args (sin shell): paths con espacios/caracteres raros no rompen
  local diff = vim.fn.system({ 'git', 'diff', '--', file })
  if diff == '' then
    diff = vim.fn.system({ 'git', 'diff', '--cached', '--', file })
  end
  if diff == '' then
    print("⚠️  No hay cambios git en este archivo")
    return
  end

  local filename = vim.fn.expand('%:t')
  local formatted = string.format("Git diff de %s:\n\n```diff\n%s\n```", filename, diff)

  if send_temp_file_reference(formatted, "nvim-git-diff.md") then
    print("✓ Git diff guardado: @/tmp/nvim-git-diff.md")
    print("💬 Escribe tu pregunta en el AI")
  end
end, { desc = 'Enviar git diff a AI' })

-- Enviar estructura del proyecto (tree)
vim.keymap.set('n', '<leader>ao', function()
  local output ---@type string
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

  local formatted = string.format("📂 Estructura del proyecto:\n\n```\n%s\n```", output)

  if send_temp_file_reference(formatted, "nvim-project-tree.md") then
    print("✓ Estructura guardada: @/tmp/nvim-project-tree.md" .. method)
    print("💬 Escribe tu pregunta en el AI")
  end
end, { desc = 'Enviar estructura a AI' })
