local utils = require("utils")

local M = {
    bowser_bufnr = -1,
    buffer_list = {},
    marked_bufnr_list = {},
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
        for _=1, rightpad_filename_count do
            filename_with_rightpad = filename_with_rightpad .. " "
        end

        local rightpad_fileext_count = longest_fileext:len() - fileext:len()
        local fileext_with_rightpad = fileext:upper() .. ""
        for _=1, rightpad_fileext_count do
            fileext_with_rightpad = fileext_with_rightpad .. " "
        end


        local line = "  " .. i .. ":"

        local is_marked = utils.array_contains(M.marked_bufnr_list, buf.bufnr)
        if is_marked then
            line = line .. MARKER
        else
            line = line .. " "
        end

        line = line .. " " .. fileext_with_rightpad .. "  " .. filename_with_rightpad .. "  " .. buf.name:gsub(filename, "")
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

    for i,bufnr in ipairs(M.marked_bufnr_list) do
        if i == 1 then
            tabline_str = ""
        end

        local bufinfo = vim.fn.getbufinfo(bufnr)[1]

        local filename = extract_filename(bufinfo.name)

        tabline_str = tabline_str .. "| " .. bufinfo.bufnr .. " " .. filename .. " "
    end

    vim.o.tabline = tabline_str
end

local function setup_tabline()
    vim.api.nvim_set_option_value('showtabline', 2, {})
    render_tabline()
end

---@param bufnr integer
local function remove_marked_bufnr(bufnr)
    local pos = nil

    for i,_bufnr in ipairs(M.marked_bufnr_list) do
        if _bufnr == bufnr then
            pos = i
        end
    end

    if pos == nil then
        return
    end

    table.remove(M.marked_bufnr_list, pos)
    render_tabline()
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

            for _,win in ipairs(buffer.windows) do
                vim.api.nvim_win_set_buf(win, scratch_bufnr)
            end
        end

        vim.api.nvim_buf_delete(buffer.bufnr, {})

        ---Remove line
        local current_cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_row = current_cursor_pos[1]
        vim.api.nvim_buf_set_lines(M.bowser_bufnr, current_row - 1, current_row, false, { "" })

        remove_marked_bufnr(buffer.bufnr)
        M.buffer_list[index] = nil
    end, { buffer = M.bowser_bufnr })
    ---#endregion

    ---#region - Open Buffer keymaps
    local win_id = vim.fn.win_getid(vim.fn.winnr("#"))
    local keys_to_open_buffer_with = { "o", "<cr>", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
    for _,key in ipairs(keys_to_open_buffer_with) do
        vim.keymap.set("n", key, function()
            if key == "o" or key == "cr" then
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
        local is_marked = utils.array_contains(M.marked_bufnr_list, bufnr)
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local first_char = " "

        if is_marked then
            remove_marked_bufnr(bufnr)
        else
            table.insert(M.marked_bufnr_list, M.buffer_list[index].bufnr)
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
