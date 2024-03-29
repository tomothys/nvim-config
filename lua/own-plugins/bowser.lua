local utils = require("utils")

local M = {}

local function set_syntax_highlighting()
    vim.cmd [[
        if exists("b:current_syntax")
            finish
        end

        syntax match MeowserFirstLine "^  Press.*$"
        highlight link MeowserFirstLine Conceal

        syntax match MeowserSpecial /<esc>\|<q>/ containedin=MeowserFirstLine
        highlight link MeowserSpecial WarningMsg

        syntax match BowserBufNr "^  \S\+:"
        highlight link BowserBufNr Comment

        syntax match BowserFileName " \S\+ "
        highlight link BowserFileName Directory

        syntax match BowserFilePath "- \S\+$"
        highlight link BowserFilePath Conceal

        let b:current_syntax = "bowser"
    ]]
end

local function set_next_lines(bufnr, lines)
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
end

local function clear_buf_keymap(bufnr)
    local key_list = { "a", "b", "c", "d", "e", "f", "i", "m", "n", "o", "p", "r", "s", "t",
        "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
        "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "<space>", "<cr>", "<bs>", "<esc>" }

    for _, key in ipairs(key_list) do
        vim.keymap.set("n", key, "<Nop>", { buffer = bufnr, silent = true })
    end
end

local INDEX_PREFIX = "index_"
local index_to_buf_nr_map = {}

local current_win_id = nil
local bowser_win_id = nil

local function choose_buffer(pressed_nr)
    local index = vim.fn.input("BufNr: ", pressed_nr)

    if index_to_buf_nr_map[INDEX_PREFIX .. index] == nil then
        print("Bowser Error: Buffer not found")
        return
    end

    if current_win_id == nil then
        print("Bowser Error: Window not found")
        return
    end

    if bowser_win_id == nil then
        print("Bowser Error: Bowser Window not found")
        return
    end

    vim.api.nvim_win_set_buf(current_win_id, index_to_buf_nr_map[INDEX_PREFIX .. index])
    vim.api.nvim_win_close(bowser_win_id, false)
end

local function show_buffer_list()
    current_win_id = vim.api.nvim_get_current_win()

    local bufnr = vim.api.nvim_create_buf(false, true)

    clear_buf_keymap(bufnr)
    vim.keymap.set("n", "q", "<c-w>c", { buffer = bufnr, noremap = true, silent = true })
    vim.keymap.set("n", "<esc>", "<c-w>c", { buffer = bufnr, noremap = true, silent = true })

    vim.keymap.set("n", "1", function() choose_buffer('1') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "2", function() choose_buffer('2') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "3", function() choose_buffer('3') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "4", function() choose_buffer('4') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "4", function() choose_buffer('4') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "5", function() choose_buffer('5') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "6", function() choose_buffer('6') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "7", function() choose_buffer('7') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "8", function() choose_buffer('8') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })
    vim.keymap.set("n", "9", function() choose_buffer('9') end,
        { buffer = bufnr, noremap = true, silent = true, expr = true })

    set_next_lines(bufnr, { "  Press <q> or <esc> to close bowser", "" })

    local buffers = vim.fn.getbufinfo({ buflisted = true })

    local buf_names = {}

    for i, buf in ipairs(buffers) do
        if #buf.name ~= 0 then
            index_to_buf_nr_map[INDEX_PREFIX .. i] = buf.bufnr

            local split_path_list = utils.split_string(buf.name, "/")

            local filename = table.remove(split_path_list, #split_path_list)
            local path = table.concat(split_path_list, "/")

            table.insert(buf_names, "  " .. i .. ": " .. filename .. " - " .. path)
        end
    end

    if #buf_names ~= 0 then
        table.insert(buf_names, "")
    end

    set_next_lines(bufnr, buf_names)

    bowser_win_id = utils.create_floating_window(bufnr, " Bowser ")
    set_syntax_highlighting()
    utils.hide_cursor_line()
end

M.setup = function()
    vim.keymap.set({ "n" }, "<leader>b", show_buffer_list)
end

return M
