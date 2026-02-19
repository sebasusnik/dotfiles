local M = {}
local uv = vim.uv or vim.loop

local function exists(path)
  return type(path) == "string" and path ~= "" and uv.fs_stat(path) ~= nil
end

local function dirname(path)
  if type(path) ~= "string" or path == "" then
    return nil
  end
  return vim.fs.dirname(path)
end

-- Encuentra el workspace root (pnpm/turbo/etc) o .git
local function workspace_root(startpath)
  local dir = startpath
  local parent = dirname(dir)

  while dir and parent and dir ~= parent do
    if exists(dir .. "/pnpm-workspace.yaml")
      or exists(dir .. "/turbo.json")
      or exists(dir .. "/nx.json")
      or exists(dir .. "/lerna.json")
      or exists(dir .. "/.git")
    then
      return dir
    end
    dir = parent
    parent = dirname(dir)
  end

  return uv.cwd() or ""
end

-- Encuentra el package root (el package.json más cercano) dentro del workspace
local function package_root(file_path, ws_root)
  local dir = dirname(file_path)
  local parent = dirname(dir)

  while dir and parent and dir ~= parent do
    if exists(dir .. "/package.json") then
      return dir
    end
    if dir == ws_root then break end
    dir = parent
    parent = dirname(dir)
  end

  return ws_root
end

-- Busca config hacia arriba hasta ws_root
local function find_up(start_dir, ws_root, names)
  local dir = start_dir
  local parent = dirname(dir)

  while dir and parent and dir ~= parent do
    for _, n in ipairs(names) do
      if exists(dir .. "/" .. n) then
        return dir .. "/" .. n, dir
      end
    end
    if dir == ws_root then break end
    dir = parent
    parent = dirname(dir)
  end

  return nil, nil
end

-- Agrega node_modules/.bin al PATH (package primero, luego workspace)
local function add_bins_to_path(pkg_root, ws_root)
  if type(pkg_root) ~= "string" or type(ws_root) ~= "string" then return end

  local paths = {}
  local pkg_bin = pkg_root .. "/node_modules/.bin"
  local ws_bin = ws_root .. "/node_modules/.bin"

  if exists(pkg_bin) then table.insert(paths, pkg_bin) end
  if ws_root ~= pkg_root and exists(ws_bin) then table.insert(paths, ws_bin) end
  if #paths == 0 then return end

  local current = vim.env.PATH or ""
  for _, p in ipairs(paths) do
    if not current:find(p, 1, true) then
      current = p .. ":" .. current
    end
  end
  vim.env.PATH = current
end

local function empty_result()
  local cwd = uv.cwd() or ""
  return {
    ws_root = cwd,
    pkg_root = cwd,
    root = cwd,
    use_biome = false,
    use_prettier = false,
    use_eslint = false,
  }
end

-- ============================================================
-- detect_by_path: acepta string (path) o number (bufnr)
-- ============================================================
function M.detect_by_path(input)
  local fname ---@type string?

  if type(input) == "string" then
    fname = input
  elseif type(input) == "number" then
    fname = vim.api.nvim_buf_get_name(input)
  end

  if not fname or fname == "" then
    return empty_result()
  end

  local file_dir = dirname(fname)
  if not file_dir then
    return empty_result()
  end

  local ws_root = workspace_root(file_dir)
  local pkg_root = package_root(fname, ws_root)

  add_bins_to_path(pkg_root, ws_root)

  local biome_names = { "biome.json", "biome.jsonc" }
  local eslint_names = {
    "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
    ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc.yml", ".eslintrc.yaml",
  }
  local prettier_names = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.js", ".prettierrc.cjs",
    "prettier.config.js", "prettier.config.cjs",
  }

  local biome_path = find_up(pkg_root, ws_root, biome_names)
  local eslint_path = find_up(pkg_root, ws_root, eslint_names)
  local prettier_path = find_up(pkg_root, ws_root, prettier_names)

  local use_biome = biome_path ~= nil
  local use_prettier = (not use_biome) and (prettier_path ~= nil)
  local use_eslint = (not use_biome) and (eslint_path ~= nil)

  return {
    ws_root = ws_root,
    pkg_root = pkg_root,
    root = pkg_root,
    use_biome = use_biome,
    use_prettier = use_prettier,
    use_eslint = use_eslint,
  }
end

function M.detect(bufnr)
  return M.detect_by_path(bufnr)
end

return M