local M = {}

---Creates a new floating window.
---It's centered and as big as it need to be to show whole text of buffer.
---@param bufnr integer
---@param title string
M.create_floating_window = function(bufnr, title)
    local width = 0

    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        if #line + 2 > width then
            width = #line + 2
        end
    end

    if width < 37 then
        width = 37
    end

    local height = vim.api.nvim_buf_line_count(bufnr) + 1

    local winId = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        col = vim.api.nvim_get_option_value("columns", {}) / 2 - (width / 2),
        row = vim.api.nvim_get_option_value("lines", {}) / 2 - (height / 2),
        style = "minimal",
        border = "solid",
        title = title
    })

    vim.api.nvim_set_option_value("wrap", false, { win = winId })
    vim.api.nvim_set_option_value("winbar", "%#WinbarPrompt#Press <q> or <esc> to close " .. title, { win = winId })

    vim.cmd("highlight link WinbarPrompt NonText")

    vim.keymap.set("n", "q", ":q<cr>", { buffer = bufnr, silent = true })
    vim.keymap.set("n", "<esc>", ":q<cr>", { buffer = bufnr, silent = true })

    return winId
end

M.create_split_window = function(bufnr, pos)
    local height = vim.api.nvim_buf_line_count(bufnr)

    local winId = vim.api.nvim_open_win(bufnr, true, {
        split = pos,
        height = height + 1,
        style = 'minimal'
    })

    return winId
end

M.reset_floating_windows_size = function(win_id)
    local bufnr = vim.api.nvim_win_get_buf(win_id)

    local width = 0

    for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        if #line + 2 > width then
            width = #line + 2
        end
    end

    local height = vim.api.nvim_buf_line_count(bufnr)

    vim.api.nvim_win_set_config(win_id, {
        width = width,
        height = height,
    })
end

---@param array table
---@param val unknown
M.array_contains = function(array, val)
    for _, table_val in ipairs(array) do
        if table_val == val then
            return true
        end
    end

    return false
end

M.get_table_length = function(table)
    local count = 0

    for _ in pairs(table) do
        count = count + 1
    end

    return count
end

---Trims whitespace infront and end of a string
---@param str string
---@return string
M.trim_string = function(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

---@param str string
---@param delimiter string
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
    vim.api.nvim_set_option_value('cursorline', false, { win = winId })
end

-- Check if directory or file exists
M.exists = function(path)
    local ok, errmsg, code = os.rename(path, path)

    -- permission denied but it exists
    if not ok and code == 13 then
        return true
    end

    return ok, errmsg
end

return M
