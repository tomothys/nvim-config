local M = {}

---@param highlight boolean
local function render_winbar(highlight)
    local hlgroup = ''

    if highlight then
        hlgroup = '%#Search#'
    end

    local winbar_string = ' [bufnr] %n ' .. hlgroup .. ' %t %#WinbarNC# %m'

    vim.api.nvim_set_option_value("winbar", winbar_string, { scope = "local" })
end

M.setup = function()
    local augroup = vim.api.nvim_create_augroup("CustomWinbar", {})

    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "WinLeave" }, {
        group = augroup,
        callback = function(opt)
            if opt.file ~= "" then
                render_winbar(opt.event == "BufEnter" or opt.event == "WinEnter")
            end
        end,
    })
end

return M
