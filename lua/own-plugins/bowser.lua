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






local INDEX_PREFIX = "index_"
local BUFFER_PREFIX = "buffer_"

local index_to_buf_nr_map = {}
local buf_nr_to_index_map = {}

local current_win_id = nil
local bowser_bufnr = nil
local bowser_win_id = nil






local function set_next_lines(bufnr, lines)
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
end






local function render_buffer_list(bufnr)
    set_next_lines(bufnr, { "  Press <q> or <esc> to close bowser", "" })

    local buffers = vim.fn.getbufinfo({ buflisted = true })

    local buf_names = {}

    for i, buf in ipairs(buffers) do
        index_to_buf_nr_map[INDEX_PREFIX .. i] = buf.bufnr
        buf_nr_to_index_map[BUFFER_PREFIX .. buf.bufnr] = i

        local name = buf.name

        if #name == 0 then
            name = "[No_Name]"

            table.insert(buf_names, "  " .. i .. ": " .. name)
        else
            local split_path_list = utils.split_string(name, "/")

            local filename = table.remove(split_path_list, #split_path_list)
            local path = table.concat(split_path_list, "/")

            table.insert(buf_names, "  " .. i .. ": " .. filename .. " - " .. path)
        end
    end

    if #buf_names ~= 0 then
        table.insert(buf_names, "")
    end

    set_next_lines(bufnr, buf_names)
end







local function clear_buffer(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
end







local function clear_buf_keymap(bufnr)
    local key_list = { "a", "b", "c", "d", "e", "f", "h", "i", "j", "k", "l", "m", "n", "o", "p", "r", "s", "t",
        "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
        "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "<space>", "<cr>", "<bs>", "<esc>" }

    for _, key in ipairs(key_list) do
        vim.keymap.set("n", key, "<Nop>", { buffer = bufnr, silent = true })
    end
end






local function open_buffer(index)
    if index_to_buf_nr_map[INDEX_PREFIX .. index] == nil then
        print("Bowser Error: Buffer not found")
        return nil
    end

    if vim.api.nvim_win_is_valid(current_win_id) == false then
        current_win_id = vim.api.nvim_list_wins()[1]
    end

    if bowser_win_id == nil then
        print("Bowser Error: Bowser Window not found")
        return nil
    end

    local bufnr = index_to_buf_nr_map[INDEX_PREFIX .. index]

    vim.api.nvim_win_set_buf(current_win_id, bufnr)
    vim.api.nvim_win_close(bowser_win_id, false)
end






local function close_buffer(index)
    if utils.get_table_length(index_to_buf_nr_map) == 0 then
        return
    end

    local bufnr = index_to_buf_nr_map[INDEX_PREFIX .. index]

    if bufnr == nil then
        print("Bowser Error: Buffer not found")
        return
    end

    local win_ids = vim.api.nvim_list_wins()

    local loaded_bufnr = {}

    for _, win in ipairs(win_ids) do
        table.insert(loaded_bufnr, vim.api.nvim_win_get_buf(win))
    end

    if utils.array_contains(loaded_bufnr, bufnr) then
        -- vim.api.nvim_buf_delete(bufnr, { force = true }) -- this does nothing :(
        vim.api.nvim_buf_call(bufnr, function() vim.cmd("bwipeout!") end)
    else
        vim.api.nvim_buf_delete(bufnr, {})
    end
end







local function get_index_of_line(line)
    local possible_index = utils.split_string(line, ":")[1]

    local index = utils.trim_string(possible_index)

    if index == "" then
        print("Bowser Error: Index required")
        return nil
    end

    return index
end






local function set_keymaps(bufnr)
    clear_buf_keymap(bufnr)

    local close_win = function()
        vim.api.nvim_win_close(bowser_win_id, false)
    end

    vim.keymap.set("n", "q", close_win, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<esc>", close_win, { buffer = bufnr, noremap = true, silent = true })

    local jump_next = function()
        vim.fn.search("  \\d\\+:", "W")
    end

    vim.keymap.set("n", "j", jump_next, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<c-n>", jump_next, { buffer = bufnr, noremap = true, silent = true })

    local jump_prev = function()
        vim.fn.search("  \\d\\+:", "bW")
    end

    vim.keymap.set("n", "k", jump_prev, { buffer = bufnr, noremap = true, silent = true })

    local close_buf = function()
        local index = get_index_of_line(vim.api.nvim_get_current_line())
        local current_cursor_pos = vim.api.nvim_win_get_cursor(bowser_win_id)

        close_buffer(index)

        clear_buffer(bufnr)
        render_buffer_list(bufnr)

        utils.reset_floating_windows_size(bowser_win_id)

        vim.api.nvim_win_set_cursor(bowser_win_id, { current_cursor_pos[1] - 1, 0 })
        jump_next()
    end

    vim.keymap.set("n", "<bs>", close_buf, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "x", close_buf, { buffer = bufnr, noremap = true, silent = true })

    local open = function()
        local index = get_index_of_line(vim.api.nvim_get_current_line())
        open_buffer(index)
    end

    vim.keymap.set("n", "o", open, { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<cr>", open, { buffer = bufnr, noremap = true, silent = true })
end







M.setup = function(options)
    local trigger = options.trigger or "<leader>b"

    vim.keymap.set({ "n" }, trigger, function()
        current_win_id = vim.api.nvim_get_current_win()

        bowser_bufnr = vim.api.nvim_create_buf(false, true)
        render_buffer_list(bowser_bufnr)

        bowser_win_id = utils.create_floating_window(bowser_bufnr, " Bowser ")
        vim.o.cursorline = true

        local current_buf_index = buf_nr_to_index_map[BUFFER_PREFIX .. vim.api.nvim_win_get_buf(current_win_id)]

        if current_buf_index ~= nil then
            vim.fn.search("  " .. current_buf_index .. ":")
        end

        set_syntax_highlighting()
        set_keymaps(bowser_bufnr)
    end)
end

return M
