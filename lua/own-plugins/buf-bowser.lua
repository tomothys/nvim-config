local utils = require("utils")

vim.api.nvim_set_option("showtabline", 2)

local INDEX_PREFIX = "index_"
local index_to_buf_nr_map = {}

local get_bufnr = function(count)
    return index_to_buf_nr_map[INDEX_PREFIX .. count]
end

local set_bufnr = function(index, bufnr)
    index_to_buf_nr_map[INDEX_PREFIX .. index] = bufnr
end

local set_keymaps = function()
    vim.keymap.set("n", "<bs>", function()
        local bufnr = get_bufnr(vim.v.count)

        if bufnr == nil then
            print("Buf-Bowser: Buffer " .. vim.v.count .. " not found")
            return
        end

        vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), bufnr)
    end, { silent = true, noremap = true })
end

local M = {}

local get_bufferbar_str = function()
    local str = ""

    for i, buf in ipairs(vim.fn.getbufinfo({ buflisted = true })) do
        local name = "[No_Name]"

        if buf.name ~= "" then
            local split_name = utils.split_string(buf.name, "/")
            name = split_name[#split_name]
        end

        if buf.bufnr == vim.api.nvim_get_current_buf() then
            str = str .. "%#TabLineSel# "
        else
            str = str .. " "
        end

        str = str .. i .. ":" .. " " .. name
        set_bufnr(i, buf.bufnr)

        if buf.changed ~= 0 then
            str = str .. " [+]"
        end

        if buf.bufnr == vim.api.nvim_get_current_buf() then
            str = str .. " %#TabLineFill#"
        else
            str = str .. " "
        end
    end

    return str
end

local render_buffer_list = function()
    vim.o.tabline = get_bufferbar_str()
end

local set_autocmd = function()
    local group = vim.api.nvim_create_augroup("Buf-Bowser", { clear = true })

    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout", "BufEnter", "BufModifiedSet", "BufWrite" }, {
        pattern = { "*" },
        callback = function()
            vim.defer_fn(render_buffer_list, 10)
        end,
        group = group
    })
end

M.setup = function()
    render_buffer_list()
    set_keymaps()
    set_autocmd()
end

return M
