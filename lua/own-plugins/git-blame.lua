local utils = require("utils")

local M = {}

local function blame()
    local file = vim.fn.expand("%")
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    local cmd = string.format("git blame -L %d,%d %s", line, line, file)

    local output = vim.fn.system(cmd)
    print(utils.trim_string(output))
end

M.setup = function()
    vim.keymap.set("n", "<leader>gb", function()
        blame()
    end, {noremap = true})
end

return M
