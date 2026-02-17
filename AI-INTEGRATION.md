# 🤖 AI Integration (Claude Code + OpenCode)

Integración unificada con AI via tmux usando referencias de archivos `@file#L10-20`.

## ✅ Lo que funciona PERFECTO

### Enviar código al AI
```
<leader>ic  → Enviar selección visual (lo más útil!)
<leader>ia  → Enviar archivo completo
<leader>il  → Enviar líneas específicas (te pregunta el rango)
<leader>id  → Enviar git diff
<leader>io  → Enviar estructura del proyecto (tree)
```

### Workflow recomendado

**Opción 1: Selección visual manual** (lo más confiable)
```
1. Coloca el cursor al inicio del código
2. Presiona V para modo visual línea
3. Selecciona las líneas que quieres (con j/k o números)
4. Presiona <leader>ic
5. El AI recibe: @src/file.ts#L10-25
6. Escribe tu pregunta en el AI
```

**Opción 2: Archivo completo**
```
<leader>ia → Envía todo el archivo actual
```

**Opción 3: Rango específico**
```
<leader>il → Te pregunta inicio/fin
```

## Helpers útiles
```
<leader>v   → Iniciar selección visual línea (alias de V)
<leader>*   → Buscar palabra bajo cursor en proyecto (Telescope)
<leader>is  → Guardar archivo
```

## Otros comandos AI
```
<leader>ix  → Enviar archivo completo (alias de <leader>ia)
<leader>id  → Git diff del archivo actual
<leader>io  → Estructura del proyecto (tree/eza)
```

## 📋 TODO: Textobjects (para el futuro)

Los text objects de treesitter (`vaf`, `]m`, `[m`) no están funcionando todavía.
Esto es un problema común con nvim-treesitter-textobjects.

**Intentos realizados:**
- ✅ Plugins instalados (treesitter + textobjects)
- ✅ Parsers instalados (typescript, javascript, tsx)
- ✅ Configuración agregada al init.lua
- ❌ Keymaps no se crean (`:verbose map af` → "No mapping found")

**Siguiente paso para investigar:**
- Probar configuración en archivo separado con `vim.defer_fn`
- O usar mini.ai como alternativa más simple
- O simplemente usar selección visual manual (que funciona perfecto)

## 🎯 Resumen

**Lo que SÍ funciona y es muy útil:**
- Selección visual + `<leader>ic` → Perfecto para cualquier código
- `<leader>ia` → Archivo completo
- `<leader>il` → Líneas específicas

**Lo que NO funciona (todavía):**
- `vaf` (text object para funciones)
- `]m`, `[m` (navegación entre funciones)

**Recomendación:** Usa selección visual manual por ahora. Es más flexible de todas formas! 🚀
