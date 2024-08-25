local utils = require("utils")

local M = {}

local function set_syntax_highlighting()
    vim.cmd [[
        if exists("b:current_syntax")
            finish
        end

        syntax match BowserLine /^.*$/
        highlight BowserLine guifg=#737aa2

        syntax match BowserSpecial /<esc>\|<q>/ containedin=BowserLine
        highlight BowserSpecial guifg=#e0af68

        syntax match BowserBufNr /^\s\+\d\+/ containedin=BowserLine
        highlight link BowserBufNr BowserSpecial

        syntax match BowserFileName / \zs\S\+\ze/
        highlight BowserFileName guifg=#7aa2f7

        syntax match BowserColumn /:/
        highlight link BowserColumn BowserLine

        syntax match BowserFilePath /-.*$/
        highlight BowserFilePath guifg=#737aa2

        let b:current_syntax = "bowser"
    ]]
end

local last_used_win = nil
local index_bufnr_dict = {}

local function set_index_bufnr_entry(index, bufnr)
    index_bufnr_dict["index_" .. index] = bufnr
end

local function get_bufnr_by_index(index)
    local bufnr = index_bufnr_dict["index_" .. index]

    if bufnr == nil then
        error("Bowser Error: bufnr not found for index " .. index)
    end

    return bufnr
end

local function get_index_by_bufnr(bufnr)
    for key, indexed_bufnr in pairs(index_bufnr_dict) do
        if indexed_bufnr == bufnr then
            return utils.split_string(key, "_")[2]
        end
    end

    error("Bowser Error: Index not found for bufnr: " .. bufnr)
end

local function jump_to_index(index)
    vim.fn.search("  " .. index .. ":")
end

local function jump_to_bufnr(bufnr)
    vim.fn.search("  " .. get_index_by_bufnr(bufnr) .. ":")
end

local function render_win_header(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "  Press <q> or <esc> to close bowser", "" })
end

local function render_buffer_list(bufnr)
    local open_buffers = vim.fn.getbufinfo({ buflisted = true })

    local buf_names = {}

    for i, buf in ipairs(open_buffers) do
        set_index_bufnr_entry(i, buf.bufnr)

        local name = buf.name

        if #name == 0 then
            name = "[No_Name]"

            table.insert(buf_names, "  " .. i .. ": " .. name)
        else
            local split_path_list = utils.split_string(name, "/")

            local filename = table.remove(split_path_list, #split_path_list)

            local modified_marker = ""

            if buf.changed ~= 0 then
                modified_marker = " [+]"
            end

            local path = table.concat(split_path_list, "/")

            table.insert(buf_names, "  " .. i .. ": " .. filename .. modified_marker .. " - " .. path)
        end
    end

    if #buf_names ~= 0 then
        table.insert(buf_names, "")
    end

    vim.api.nvim_buf_set_lines(bufnr, 3, -1, false, {}) -- clear buffer list before rendering a new one
    vim.api.nvim_buf_set_lines(bufnr, 3, -1, false, buf_names)
end

local function create_bowser_buffer()
    return vim.api.nvim_create_buf(false, true)
end

local function open_bowser(bowser_bufnr, pos)
    if pos == nil then
        pos = "above"
    end

    local height = vim.api.nvim_buf_line_count(bowser_bufnr)

    return vim.api.nvim_open_win(bowser_bufnr, true, {
        height = height + 1,
        split = pos,
        style = "minimal"
    })
end

local function close_bowser(bowser_bufnr)
    local win_ids = vim.api.nvim_list_wins()

    if #win_ids == 1 then
        local new_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_open_win(new_buf, false, { split = "below" })
    end

    local bufinfo = vim.fn.getbufinfo(bowser_bufnr)[1]
    for _, win_id in ipairs(bufinfo.windows) do
        vim.api.nvim_win_close(win_id, false)
    end
end

local function get_index_of_line()
    local possible_index = utils.split_string(vim.api.nvim_get_current_line(), ":")[1]

    local index = utils.trim_string(possible_index)

    if index == "" then
        error("Bowser Error: Index required")
    end

    return index
end

local function open_buffer(split_pos)
    local index = get_index_of_line()

    local bufnr = get_bufnr_by_index(index)

    if bufnr == nil then
        error("Bowser Error: Buffer not found")
    end

    if last_used_win == nil then
        last_used_win = vim.api.nvim_win_open({ bufnr, false, { split = "below" } })
        return last_used_win
    end

    if split_pos ~= nil then
        return vim.api.nvim_open_win(bufnr, false, { win = last_used_win, split = split_pos })
    end

    vim.api.nvim_win_set_buf(last_used_win, get_bufnr_by_index(index))
    return last_used_win
end

local function close_buffer()
    local index = get_index_of_line()
    local bufnr = get_bufnr_by_index(index)

    vim.api.nvim_buf_delete(bufnr, {})

    set_index_bufnr_entry(index, nil)
    return index
end

local function set_keymaps(bufnr)
    vim.keymap.set("n", "q", function()
        close_bowser(bufnr)
    end, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<esc>", function()
        close_bowser(bufnr)
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "j", function()
        vim.fn.search("  \\d\\+:", "W")
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "k", function()
        vim.fn.search("  \\d\\+:", "bW")
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "o", open_buffer, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<cr>", open_buffer, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "v", function()
        last_used_win = open_buffer("right")
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "s", function()
        last_used_win = open_buffer("below")
    end, { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "x", function()
        close_buffer()
        local row = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, {})
    end, { buffer = bufnr, noremap = true, silent = true })
end

M.setup = function()
    vim.keymap.set("n", "<leader>b", function()
        local bowser_bufnr = create_bowser_buffer()

        render_win_header(bowser_bufnr)
        render_buffer_list(bowser_bufnr)

        last_used_win = vim.api.nvim_get_current_win()

        local bowser_win = open_bowser(bowser_bufnr)
        vim.api.nvim_set_option_value("cursorline", true, { win = bowser_win })

        local last_used_win_bufnr = vim.api.nvim_win_get_buf(last_used_win)
        jump_to_bufnr(last_used_win_bufnr)

        set_syntax_highlighting()

        set_keymaps(bowser_bufnr)
    end)
end

return M
