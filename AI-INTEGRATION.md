# 🤖 AI Integration (Claude Code + OpenCode)

Integración unificada con AI via tmux usando referencias de archivos `@file#L10-20`.

### Enviar código al AI
```
<leader>ac  → Enviar selección visual (lo más útil!)
<leader>aa  → Enviar archivo completo
<leader>af  → Enviar función donde está el cursor
<leader>at  → Enviar type/interface donde está el cursor
<leader>al  → Enviar líneas específicas (te pregunta el rango)
<leader>ad  → Enviar git diff
<leader>ao  → Enviar estructura del proyecto (tree)
```

### Workflow recomendado

**Opción 1: Selección visual manual**
```
1. Coloca el cursor al inicio del código
2. Presiona V para modo visual línea
3. Selecciona las líneas que quieres (con j/k o números)
4. Presiona <leader>ac
5. El AI recibe: @src/file.ts#L10-25
6. Escribe tu pregunta en el AI
```

**Opción 2: Enviar función/type automáticamente**
```
<leader>af → Envía la función donde está el cursor
<leader>at → Envía el type/interface donde está el cursor
```

**Opción 3: Archivo completo**
```
<leader>aa → Envía todo el archivo actual
```

**Opción 4: Rango específico**
```
<leader>al → Te pregunta inicio/fin
```

## Helpers útiles
```
<leader>*   → Buscar palabra bajo cursor en proyecto (Telescope)
```

**Nota:** Para seleccionar código usa los textobjects directamente:
- `vaf` / `vif` → Seleccionar función
- `vac` / `vic` → Seleccionar clase
- `V` → Selección visual línea

## ✅ Textobjects

Los text objects de treesitter están configurados con keymaps manuales:

**Selección:**
- `vaf` / `vif` → Seleccionar función (outer/inner)
- `vac` / `vic` → Seleccionar clase (outer/inner)
- `vaa` / `via` → Seleccionar parámetro (outer/inner)
- `vab` / `vib` → Seleccionar bloque (outer/inner)
- `va/` → Seleccionar comentario

**Navegación:**
- `]m` / `[m` → Siguiente/anterior función
- `]c` / `[c` → Siguiente/anterior clase
- `]a` / `[a` → Siguiente/anterior parámetro

## 🎯 Resumen

**Lo que SÍ funciona y es muy útil:**
- Selección visual + `<leader>ac` → Perfecto para cualquier código
- `<leader>af` → Función actual (con Treesitter)
- `<leader>at` → Type/Interface actual (con Treesitter)
- `<leader>aa` → Archivo completo
- `<leader>al` → Líneas específicas
- **Textobjects:** `vaf`, `]m`, `[m` → ¡Ahora funcionan!

**Workflow completo:**
1. Navega con `]m` / `[m` entre funciones
2. Selecciona con `vaf` la función completa (o usa `<leader>af`)
3. Envía al AI con `<leader>ac` (o directamente `<leader>af`)
4. Escribe tu pregunta en el AI 🚀
