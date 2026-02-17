-- ~/.config/nvim/lua/opencode.lua
-- ============================================
-- OPENCODE INTEGRATION
-- ============================================

-- Copiar selección visual a clipboard (sistema)
vim.keymap.set('v', '<leader>oc', '"*y', { desc = 'Copiar selección' })

-- Copiar función completa donde está el cursor
vim.keymap.set('n', '<leader>oc', function()
    local pos = vim.fn.getpos('.')
    vim.cmd('normal! [[')
    local start_line = vim.fn.line('.')
    vim.cmd('normal! V][')
    vim.cmd('normal! "*y')
    vim.fn.setpos('.', pos)
    print("✓ Función copiada")
end, { desc = 'Copiar función' })

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

-- Buscar palabra bajo cursor en proyecto
vim.keymap.set('n', '<leader>*', function()
    vim.cmd('Rg ' .. vim.fn.expand('<cword>'))
end, { desc = 'Buscar palabra' })

-- Preparar para OpenCode (guardar)
vim.keymap.set('n', '<leader>os', function()
    vim.cmd('w')
    print("✓ Guardado. Cambia a OpenCode y pega con Ctrl+V")
end, { desc = 'Preparar para OpenCode' })