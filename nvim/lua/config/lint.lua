local lint = require("lint")
local tools = require("config.project_tools")

-- Si no tenés eslint_d instalado, cambiá a "eslint"
local ESLINT_LINTER = "eslint_d"

local function set_linters_for(ft, linter)
  lint.linters_by_ft[ft] = linter and { linter } or nil
end

local function is_js_ts_ft(ft)
  return ft == "javascript"
    or ft == "javascriptreact"
    or ft == "typescript"
    or ft == "typescriptreact"
end

local function run_lint(bufnr)
  local ft = vim.bo[bufnr].filetype
  if not is_js_ts_ft(ft) then return end

  local det = tools.detect(bufnr)

  if det.use_biome then
    set_linters_for(ft, "biomejs")
  elseif det.use_eslint then
    set_linters_for(ft, ESLINT_LINTER)
  else
    set_linters_for(ft, nil)
    return
  end

  lint.try_lint()
end

-- Debounce timer for TextChanged — avoids running the linter on every keystroke.
local _timers = {}
local function debounce_lint(bufnr)
  if _timers[bufnr] then
    _timers[bufnr]:stop()
    _timers[bufnr]:close()
  end
  _timers[bufnr] = vim.uv.new_timer()
  _timers[bufnr]:start(800, 0, vim.schedule_wrap(function()
    if _timers[bufnr] then
      _timers[bufnr]:close()
      _timers[bufnr] = nil
    end
    if vim.api.nvim_buf_is_valid(bufnr) then
      run_lint(bufnr)
    end
  end))
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function(args) run_lint(args.buf) end,
})

vim.api.nvim_create_autocmd("TextChanged", {
  callback = function(args) debounce_lint(args.buf) end,
})