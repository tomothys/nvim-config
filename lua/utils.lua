local M = {}

M.create_floating_window = function(bufnr, title)
    local width = 0

    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        if #line > width then
            width = #line + 2
        end
    end

    local height = vim.api.nvim_buf_line_count(bufnr)

    local winId = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        col = vim.api.nvim_get_option("columns") / 2 - (width / 2),
        row = vim.api.nvim_get_option("lines") / 2 - (height / 2),
        style = "minimal",
        border = "rounded",
        title = title
    })

    vim.api.nvim_win_set_option(winId, "wrap", false)

    return winId
end

M.trim_string = function(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

M.split_string = function(str, delimiter)
    local sub_str_list = {}

    for sub_str in str:gmatch("[^" .. delimiter .. "]+") do
        table.insert(sub_str_list, sub_str)
    end

    return sub_str_list
end

M.join_strings = function(sub_str_list, delimiter)
    return table.concat(sub_str_list, delimiter);
end

M.hide_cursor_line = function()
    local winId = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_option(winId, 'cursorline', false)
end

return M
