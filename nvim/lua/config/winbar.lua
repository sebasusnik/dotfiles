-- ~/.config/nvim/lua/config/winbar.lua
-- ============================================
-- WINBAR: filename + diagnostics + git branch
-- ============================================

-- Git state cache: updated async on BufEnter/FocusGained, zero render cost
-- dirty = repo-wide (like oh-my-posh), ahead/behind vs remote
local _git = { ahead = 0, behind = 0, dirty = false }
local function _refresh_git()
    vim.fn.jobstart("git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null", {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data and data[1] and data[1] ~= "" then
                local a, b = data[1]:match("(%d+)%s+(%d+)")
                _git.ahead  = tonumber(a) or 0
                _git.behind = tonumber(b) or 0
            else
                _git.ahead, _git.behind = 0, 0
            end
        end,
    })
    vim.fn.jobstart("git status --porcelain 2>/dev/null", {
        stdout_buffered = true,
        on_stdout = function(_, data)
            _git.dirty = data ~= nil and data[1] ~= nil and data[1] ~= ""
        end,
    })
end
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "BufWritePost" }, { callback = _refresh_git })

-- Dynamic winbar: filename + line count + diagnostics (per-window)
local _no_winbar_ft = { "neo-tree", "lazy", "mason", "help", "qf", "TelescopePrompt" }
_G._winbar = function()
    if vim.bo.buftype ~= "" then return "" end
    local ft = vim.bo.filetype
    for _, v in ipairs(_no_winbar_ft) do
        if ft == v then return "" end
    end

    local left = "%#WinBar# %f %#Comment#%l/%L"

    -- Diagnostics for current buffer (errors + warnings only, subtle)
    local diag_str = ""
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warns  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if errors > 0 then diag_str = diag_str .. "%#DiagnosticError# " .. errors .. " " end
    if warns  > 0 then diag_str = diag_str .. "%#DiagnosticWarn# " .. warns  .. " " end

    -- Git branch from gitsigns + repo-wide dirty + ahead/behind (mirrors oh-my-posh zen.toml)
    local branch = vim.b.gitsigns_head
    local git_str = ""
    if branch and branch ~= "" then
        local dirty  = _git.dirty and "*" or ""
        local behind = _git.behind > 0 and "⇣" or ""
        local ahead  = _git.ahead  > 0 and "⇡" or ""
        git_str = "%#Comment#  " .. branch .. dirty .. " " .. behind .. ahead .. " "
    end

    return left .. "%=" .. diag_str .. git_str
end
vim.opt.winbar = "%{%v:lua._winbar()%}"
