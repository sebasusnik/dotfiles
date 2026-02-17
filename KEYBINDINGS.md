# ⌨️ Keybindings Cheatsheet - NVIM ZEN

> Todos los atajos de teclado de mi configuración de Neovim

## 📁 Navegación y Archivos

### Neo-tree (File Explorer)
```
<leader>e       Toggle Neo-tree
<leader>o       Focus Neo-tree
-               Reveal archivo actual en Neo-tree

Dentro de Neo-tree:
<CR>            Abrir archivo / Entrar carpeta
-               Subir un nivel
```

### Telescope (Búsqueda Fuzzy)
```
<leader>f       Buscar archivos
<leader>g       Buscar texto en proyecto (live grep)
<leader>/       Buscar en archivo actual
<leader>b       Buscar buffers abiertos
<leader>*       Buscar palabra bajo cursor en proyecto

Dentro de Telescope:
<Esc>           Cerrar
<C-j>           Siguiente resultado
<C-k>           Anterior resultado
```

## 💾 Básicos

### Archivo (comandos nativos de Vim)
```
:w              Guardar
:q              Salir
:q!             Salir sin guardar
:x / :wq        Guardar y salir
```

### Ventanas (Splits)
```
<C-h>           Ir a panel izquierda
<C-l>           Ir a panel derecha
<C-j>           Ir a panel abajo
<C-k>           Ir a panel arriba
```

## 🤖 AI Integration (Claude Code + OpenCode)

### Enviar código al AI
```
<leader>ac      Enviar selección visual
<leader>aa      Enviar archivo completo
<leader>af      Enviar función/type/enum donde está el cursor ⭐
<leader>at      Enviar type/interface donde está el cursor (obsoleto, usa af)
<leader>al      Enviar líneas específicas (te pregunta rango)
<leader>ad      Enviar git diff del archivo
<leader>ao      Enviar estructura del proyecto
```

**Nota:** `<leader>af` ahora es inteligente - detecta automáticamente si estás en una función, type, interface o enum!

## 🎯 Textobjects (Treesitter)

### Selección
```
vaf / vif       Seleccionar función/type/enum/interface (outer/inner) ⭐
vac / vic       Seleccionar clase (outer/inner)
vaa / via       Seleccionar parámetro (outer/inner)
vai / vii       Seleccionar condicional (outer/inner)
val / vil       Seleccionar loop (outer/inner)
vab / vib       Seleccionar bloque (outer/inner)
va/             Seleccionar comentario
```

**Nota:** `vaf` es inteligente - funciona tanto para funciones como para types, interfaces y enums en TypeScript!

### Navegación entre declaraciones (Modo Sticky 🔥)
```
<leader>n + ] / [   Navegar declaraciones: funciones, types, variables, etc.
<Esc>               Salir del modo sticky
```

**Modo Sticky 🔥:** Presiona `Space + n` una vez, luego `j` o `k` repetidamente para saltar entre cualquier declaración (funciones, types, interfaces, enums, variables)!

### Navegación estándar (sin sticky)
```
]m / [m         Siguiente/anterior declaración (funciones, types, variables, etc.)
]c / [c         Siguiente/anterior clase
]l / [l         Siguiente/anterior loop
]i / [i         Siguiente/anterior condicional
]b / [b         Siguiente/anterior bloque
]a / [a         Siguiente/anterior parámetro
```

### Swap (Intercambiar)
```
<leader>sn      Swap con siguiente parámetro
<leader>sp      Swap con parámetro anterior
```

## 📝 LSP (Language Server)

### Navegación de código
```
gd              Go to definition
K               Hover (documentación)
<leader>rn      Rename símbolo
<leader>ca      Code actions
```

## 🔍 Selección Visual

### Incremental (Treesitter)
```
<CR>            Iniciar/expandir selección
<BS>            Contraer selección
<TAB>           Expandir por scope
```

### Útiles
```
V               Modo visual línea
v               Modo visual carácter
<C-v>           Modo visual bloque
gv              Restaurar última selección visual
<Esc>           Salir de modo visual (guarda marcas)
```

## 🎨 Workflow: Seleccionar y enviar al AI

### Opción 1: Selección manual
```
1. V            Iniciar selección visual
2. jjj          Seleccionar líneas
3. <leader>ac   Enviar al AI
```

### Opción 2: Con textobjects
```
1. vaf          Seleccionar función
2. <Esc>        Salir (marcas persisten 3 seg)
3. Scrollea para revisar
4. gv           Restaurar selección
5. <leader>ac   Enviar al AI
```

### Opción 3: Directo
```
<leader>af      Envía función directamente (sin seleccionar)
<leader>at      Envía type/interface directamente
```

## 🎨 Visual Feedback

- **Selección activa**: Color gris `#4a4a4a`
- **Marcas después de salir**: Color gris sutil `#3a3a3a` (dura 3 segundos)
- Permite scrollear y revisar antes de enviar al AI

## 🔧 Git (comandos útiles)

### En Neovim (Gitsigns)
```
]h / [h         Siguiente/anterior cambio (hunk)
<leader>hp      Preview cambio
<leader>hs      Stage cambio
<leader>hr      Reset cambio (descartar)
```

### En terminal (git nativos)
```
git status      Ver estado del repo
git add .       Agregar todos los cambios
git commit -m   Commit con mensaje
git push        Subir cambios
git pull        Bajar cambios
git log         Ver historial
git diff        Ver cambios sin stagear
git diff --cached  Ver cambios staged
```

## 📦 Tmux (Terminal multiplexer)

**Nota:** Tu prefix key es `Ctrl+a` (no el default `Ctrl+b`)

### Copy mode (selección y copiado)
```
Ctrl+a [        Entrar en copy mode
Ctrl+a PgUp     Entrar en copy mode (alternativo)

Dentro de copy mode (vi-mode):
h j k l         Moverse (vim keys)
w / b           Siguiente/anterior palabra
0 / $           Inicio/final de línea
g / G           Inicio/final del buffer
/texto          Buscar hacia adelante
?texto          Buscar hacia atrás
n / N           Siguiente/anterior resultado

v               Iniciar selección (vi-style)
y / Enter       Copiar selección y salir
q / Esc         Salir sin copiar

Ctrl+a ]        Pegar lo copiado
```

### Workflow: Copiar desde tmux
```
1. Ctrl+a [     Entrar en copy mode
2. Navegar con vim keys (h j k l)
3. v            Iniciar selección (vi-style)
4. Seleccionar con movimiento
5. y o Enter    Copiar al clipboard
6. Cmd+V        Pegar en cualquier aplicación
```

### Splits y paneles
```
Ctrl+a |        Split vertical (izq/der)
Ctrl+a -        Split horizontal (arriba/abajo)
Ctrl+h/j/k/l    Navegar entre paneles (sin prefix!)
Ctrl+a x        Cerrar panel actual
```

### Otras útiles
```
Ctrl+a c        Crear nueva ventana
Ctrl+a n        Siguiente ventana
Ctrl+a p        Anterior ventana
Ctrl+a d        Detach de la sesión
Ctrl+a r        Recargar tmux.conf
```

## 🎯 Movimiento (Vim nativo)

### Movimiento básico
```
h j k l         Izquierda, Abajo, Arriba, Derecha
w / b           Siguiente/anterior palabra
e               Final de palabra
0 / $           Inicio/final de línea
gg / G          Inicio/final del archivo
{ / }           Párrafo anterior/siguiente
<C-d> / <C-u>   Media página abajo/arriba
<C-f> / <C-b>   Página completa abajo/arriba
zz              Centrar cursor en pantalla
```

### Buscar y saltar
```
/texto          Buscar hacia adelante
?texto          Buscar hacia atrás
n / N           Siguiente/anterior resultado
*               Buscar palabra bajo cursor
f{char}         Saltar a carácter en línea
t{char}         Saltar antes de carácter
; / ,           Repetir f/t adelante/atrás
```

### Marcas
```
m{a-z}          Crear marca local
m{A-Z}          Crear marca global
'{a-z}          Saltar a marca
''              Saltar a posición anterior
`.              Saltar a último cambio
```

## ✏️ Edición (Vim nativo)

### Cambiar/Borrar
```
c               Change (cambiar + insertar)
d               Delete (borrar)
y               Yank (copiar)
p / P           Paste después/antes
x               Borrar carácter
r{char}         Reemplazar carácter
u               Undo
<C-r>           Redo
.               Repetir último comando
```

### Operator + Motion
```
ciw             Change inner word
di"             Delete inside quotes
ya{             Yank around brackets
cit             Change inside tag
```

### Buscar y reemplazar
```
:s/old/new      Reemplazar en línea actual
:s/old/new/g    Reemplazar todos en línea
:%s/old/new/g   Reemplazar en todo el archivo
:%s/old/new/gc  Reemplazar con confirmación
```

### Múltiples líneas
```
V               Visual línea
<C-v>           Visual bloque
J               Unir líneas
>               Indentar
<               Des-indentar
```

### Mover líneas (<leader>m + j/k - Modo Sticky)
```
<leader>m       Entrar en modo "mover" (sticky)
j               Mover línea/selección abajo (repetir sin Space)
k               Mover línea/selección arriba (repetir sin Space)
<Esc>           Salir del modo sticky
```

**Nota:** Modo "sticky" = presionas `Space + m` una vez, luego solo `j j j` o `k k k` repetidamente.

**Workflow:**
```
1. vaf           Seleccionar función
2. <leader>m     Entrar en modo mover (sale de visual, guarda posiciones)
3. j j j j       Mover abajo varias veces (sin presionar Space)
4. <Esc>         Salir de modo sticky
```

## 📋 Tips

- `<leader>` = `Space`
- Los textobjects funcionan en modo visual (`v`) y operator-pending (`d`, `y`, `c`)
- Ejemplos: `daf` (delete function), `yaf` (yank function), `cif` (change inner function)
- Las marcas visuales (`'<` y `'>`) se guardan al salir del modo visual
- **Filosofía de Vim:** operator + motion (ej: `d` + `iw` = delete inner word)
- Combina textobjects con operators: `daf` (delete a function), `yip` (yank inner paragraph)
