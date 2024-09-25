local utils = require("utils")

local M = {
    bowser_bufnr = -1,
    buffer_list = {},
    open_markers = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
        "u", "v", "w", "x", "y", "z" },
    marked_buf_list = {},
    marked_buf_count = 0,
}

local MARKER = "_"

local function set_syntax_highlighting()
    vim.cmd [[
        if exists("b:current_syntax")
            finish
        end

        syntax match BowserFiletypeWhite / MD /
        highlight BowserFiletypeWhite guifg=#1f1f28 guibg=#ffffff

        syntax match BowserFiletypeGreen / VIM /
        highlight BowserFiletypeGreen guifg=#1f1f28 guibg=#00a855

        syntax match BowserFiletypeBlue / TS \| TSX \| LUA /
        highlight BowserFiletypeBlue guifg=#dcd7ba guibg=#1254b0

        syntax match BowserFiletypeYellow / JS \| JSX \| JSON /
        highlight BowserFiletypeYellow guifg=#1f1f28 guibg=#e8c900

        syntax match BowserFilepath / \S*$/
        highlight link BowserFilepath NonText

        syntax match BowserMarked /:\zs_\ze/
        highlight BowserMarked guifg=#ff9e3b guibg=#ff9e3b

        let b:current_syntax = "bowser"
    ]]
end

---Extract filename
---@param path string
---@return string
local function extract_filename(path)
    local split_path = utils.split_string(path, "/")
    return split_path[#split_path]
end

---Extract file extension
---@param filename string
---@return string
local function extract_file_extension(filename)
    local split_filename = utils.split_string(filename, ".")
    return split_filename[#split_filename]
end

---Get list of open buffers
local function get_open_buffers()
    return vim.fn.getbufinfo({ buflisted = 1 })
end

---@param bufnr integer
---@return string|nil
local function get_key_by_bufnr(bufnr)
    for key, value in pairs(M.marked_buf_list) do
        if value.bufnr == bufnr then
            return key
        end
    end

    return nil
end

---Render buflist to buffer
local function render_buffer_list()
    local longest_filename = ""
    local longest_fileext = ""

    for _, buf in ipairs(M.buffer_list) do
        if buf.name == "" then
            goto continue
        end

        local filename = extract_filename(buf.name)
        local fileext = extract_file_extension(filename)

        if longest_filename == "" or filename:len() > longest_filename:len() then
            longest_filename = filename
        end

        if longest_fileext == "" or fileext:len() > longest_fileext:len() then
            longest_fileext = fileext
        end

        ::continue::
    end

    for i, buf in ipairs(M.buffer_list) do
        if buf.name == "" then
            goto continue
        end

        local filename = extract_filename(buf.name)
        local fileext = extract_file_extension(filename)

        local rightpad_filename_count = longest_filename:len() - filename:len()
        local filename_with_rightpad = filename .. ""
        for _ = 1, rightpad_filename_count do
            filename_with_rightpad = filename_with_rightpad .. " "
        end

        local rightpad_fileext_count = longest_fileext:len() - fileext:len()
        local fileext_with_rightpad = fileext:upper() .. ""
        for _ = 1, rightpad_fileext_count do
            fileext_with_rightpad = fileext_with_rightpad .. " "
        end


        local line = "  " .. i .. ":"

        local is_marked = get_key_by_bufnr(buf.bufnr) ~= nil
        if is_marked then
            line = line .. MARKER
        else
            line = line .. " "
        end

        line = line ..
            " " .. fileext_with_rightpad .. "  " .. filename_with_rightpad .. "  " .. buf.name:gsub(filename, "")
        vim.api.nvim_buf_set_lines(M.bowser_bufnr, -1, -1, false, { line })

        ::continue::
    end
end

---Create floating window
local function create_window()
    return utils.create_floating_window(M.bowser_bufnr, "Bowser")
end

---Get the Bowser Index from line under cursor. Returns nil if no index found
local function get_index_under_cursor()
    local current_line = vim.api.nvim_get_current_line()

    if current_line == "" then
        return nil;
    end

    local line_without_possible_marker = current_line:sub(2)

    local index = utils.trim_string(utils.split_string(line_without_possible_marker, ":")[1])

    return tonumber(index)
end

local function render_tabline()
    local tabline_str = " "

    local first_item = true

    for key, buf in pairs(M.marked_buf_list) do
        if buf == nil then
            goto continue
        end

        if first_item then
            tabline_str = ""
            first_item = false
        end

        local filename = extract_filename(buf.name)
        tabline_str = tabline_str .. "%#Title# [" .. key .. "] " .. filename .. " %#TabLine# "

        ::continue::
    end

    vim.o.tabline = tabline_str
end

local function setup_tabline()
    vim.api.nvim_set_option_value('showtabline', 2, {})
    render_tabline()
end

---@param bufnr integer
local function remove_marked_buf(bufnr)
    local key = get_key_by_bufnr(bufnr)

    if key == nil then
        print("BOWSER: Marker not found")
        return;
    end

    M.marked_buf_list[key] = nil
    M.marked_buf_count = M.marked_buf_count - 1

    vim.keymap.del("n", "<leader>j" .. key)

    table.insert(M.open_markers, 1, key)

    render_tabline()
end

---@param index integer
local function mark_buffer(index)
    local buffer = M.buffer_list[index]
    local new_key = M.open_markers[1]
    table.remove(M.open_markers, 1)
    M.marked_buf_list[new_key] = M.buffer_list[index]
    M.marked_buf_count = M.marked_buf_count + 1

    vim.keymap.set("n", "<leader>j" .. new_key, function()
        if M.marked_buf_count == 0 then
            print("BOWSER: 0 buffers marked")
            return;
        end

        local win_id = vim.api.nvim_get_current_win()

        vim.api.nvim_win_set_buf(win_id, buffer.bufnr)
    end, { silent = true })
end

---This will create keymaps for the Bowser Buffer
local function setup_keymaps()
    ---#region - Close buffer where the cursor is on
    vim.keymap.set("n", "x", function()
        local index = get_index_under_cursor()

        if index == nil then
            return;
        end

        local buffer = M.buffer_list[index]

        if #buffer.windows > 0 then
            local scratch_bufnr = vim.api.nvim_create_buf(false, true)

            for _, win in ipairs(buffer.windows) do
                vim.api.nvim_win_set_buf(win, scratch_bufnr)
            end
        end

        vim.api.nvim_buf_delete(buffer.bufnr, {})

        ---Remove line
        local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_row = current_cursor_pos[1]
        vim.api.nvim_buf_set_lines(M.bowser_bufnr, current_row - 1, current_row, false, { "" })

        remove_marked_buf(buffer.bufnr)

        M.buffer_list[index] = nil
    end, { buffer = M.bowser_bufnr })
    ---#endregion

    ---#region - Open Buffer keymaps
    local keys_to_open_buffer_with = { "o", "<cr>", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    for _, key in ipairs(keys_to_open_buffer_with) do
        vim.keymap.set("n", key, function()
            local win_id = vim.fn.win_getid(vim.fn.winnr("#"))

            if #vim.api.nvim_list_wins() > 2 then
                win_id = vim.fn.win_getid(tonumber(vim.fn.input("Window: ")))
            end

            if key == "o" or key == "<cr>" then
                local index = get_index_under_cursor()

                if index == nil then
                    return
                end

                vim.api.nvim_win_set_buf(win_id, M.buffer_list[index].bufnr)
            else
                local index = tonumber(key)
                local buffer = M.buffer_list[index]

                if buffer == nil then
                    print("BOWSER: Buffer with index " .. key .. "does not exist anymore.")
                    return
                end

                vim.api.nvim_win_set_buf(win_id, M.buffer_list[index].bufnr)
            end

            vim.api.nvim_buf_delete(M.bowser_bufnr, {})
        end, { buffer = M.bowser_bufnr })
    end
    ---#endregion

    ---#region - Toggle marker Buffer
    vim.keymap.set("n", "m", function()
        local index = get_index_under_cursor()

        if index == nil then
            return
        end

        local bufnr = M.buffer_list[index].bufnr
        local key = get_key_by_bufnr(bufnr)
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local first_char = " "

        -- if key exists there must be a marked buffer
        if key ~= nil then
            remove_marked_buf(bufnr)
        else
            mark_buffer(index)
            first_char = MARKER
        end

        vim.api.nvim_buf_set_text(M.bowser_bufnr, cursor_pos[1] - 1, 4, cursor_pos[1] - 1, 5, { first_char })

        render_tabline()
    end, { buffer = M.bowser_bufnr })
    ---#endregion
end

M.setup = function()
    vim.keymap.set("n", "<leader>b", function()
        M.bowser_bufnr = vim.api.nvim_create_buf(false, true)

        M.buffer_list = get_open_buffers()

        setup_keymaps()

        if #M.buffer_list == 1 and M.buffer_list[1].name == "" then
            print("BOWSER: No buffers open")
            return
        end

        render_buffer_list()
        create_window()
        set_syntax_highlighting()
    end)

    setup_tabline()
end

return M
