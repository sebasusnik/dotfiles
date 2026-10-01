-- conform.nvim se carga recién al primer format (ver init.lua)
local tools = require("config.project_tools")

local function choose_formatter(bufnr)
  local det = tools.detect(bufnr)
  if det.use_biome then return { "biome" } end
  if det.use_prettier then return { "prettier" } end
  return nil
end

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if not (ft:match("typescript") or ft:match("javascript") or ft == "json") then return end

    local fmt = choose_formatter(args.buf)
    if not fmt then return end

    require("conform").format({
      bufnr = args.buf,
      formatters = fmt,
      timeout_ms = 2000,
      lsp_format = "never",
    })
  end,
})

vim.keymap.set("n", "<leader>p", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local fmt = choose_formatter(bufnr)
  if not fmt then
    vim.notify("No encontré biome/prettier config en este proyecto", vim.log.levels.WARN)
    return
  end
  require("conform").format({ bufnr = bufnr, formatters = fmt, lsp_format = "never" })
end, { desc = "Formatear (auto por proyecto)" })
