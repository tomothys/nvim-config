local utils = require("utils")

local M = {}

local function set_syntax_highlighting()
    vim.cmd [[
        if exists("b:current_syntax")
            finish
        end

        syntax match MeowserFirstLine "^  Press.*"
        highlight link MeowserFirstLine Comment

        syntax match MeowserMarker "^  .:"
        syntax match MeowserMarker "<esc>"
        highlight link MeowserMarker WarningMsg

        syntax match MeowserFilePath "^  \/.*"
        syntax match MeowserFilePath "^  \\.*"
        highlight link MeowserFilePath Title

        let b:current_syntax = "meowser"
    ]]
end

local function show_buffer_markers()
    local local_marker_names = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "r", "s", "t", "u", "v", "w", "x", "y", "z" }

    local bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<c-w>c", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<c-w>c", {noremap = true, silent = true})

    local meowser_lines = {}

    table.insert(meowser_lines, "  Press <q> or <esc> to close meowser")

    local local_lines_to_write = {}

    for _, marker_name in ipairs(local_marker_names) do
        vim.keymap.set("n", marker_name, "<Nop>", {buffer = bufnr})

        local marker = vim.api.nvim_buf_get_mark(0, marker_name)

        if marker[1] ~= 0 or marker[2] ~= 0 then
            local line = vim.api.nvim_buf_get_lines(0, marker[1] - 1, marker[1], false)[1]

            if line == nil then
                vim.cmd("delmarks " .. marker_name)
            else
                table.insert(local_lines_to_write, "  " .. marker_name .. ": " .. utils.trim_string(line))

                vim.keymap.set("n", marker_name, function()
                    vim.api.nvim_win_close(0, true)
                    vim.api.nvim_win_set_cursor(0, {marker[1], marker[2]})
                end, {buffer = bufnr})
            end
        end
    end

    if local_lines_to_write[1] ~= nil then
        table.insert(meowser_lines, "")

        for _, line in ipairs(local_lines_to_write) do
            table.insert(meowser_lines, line)
        end
    end

    local global_marker_names = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

    for _, global_marker_name in ipairs(global_marker_names) do
        vim.keymap.set("n", global_marker_name, "<Nop>", {buffer = bufnr})
    end

    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        local global_marker_lines_to_write = {}

        if vim.api.nvim_buf_get_option(buffer, "buflisted") then
            table.insert(global_marker_lines_to_write, "")
            table.insert(global_marker_lines_to_write, "  " .. vim.api.nvim_buf_get_name(buffer))

            for _, global_marker_name in ipairs(global_marker_names) do
                local global_marker = vim.api.nvim_buf_get_mark(buffer, global_marker_name)

                if global_marker[1] ~= 0 or global_marker[2] ~= 0 then
                    local line = vim.api.nvim_buf_get_lines(buffer, global_marker[1] - 1, global_marker[1], false)[1]

                    if line == nil then
                        vim.cmd("delmarks " .. global_marker_name)
                    else
                        table.insert(global_marker_lines_to_write, "  " .. global_marker_name .. ": " .. utils.trim_string(line))

                        vim.keymap.set("n", "<s-" .. global_marker_name .. ">", function()
                            vim.api.nvim_win_close(0, true)
                            vim.api.nvim_set_current_buf(buffer)
                            vim.api.nvim_win_set_cursor(0, {global_marker[1], global_marker[2]})
                        end, {buffer = bufnr})
                    end
                end
            end

            if global_marker_lines_to_write[3] ~= nil then
                for _, line in ipairs(global_marker_lines_to_write) do
                    table.insert(meowser_lines, line)
                end
            end
        end
    end

    table.insert(meowser_lines, "")

    for _, line in ipairs(meowser_lines) do
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {line})
    end

    utils.create_floating_window(bufnr, " Meowser ")
    set_syntax_highlighting()
    utils.hide_cursor_line()
end

M.setup = function()
    vim.keymap.set({"n", "v"}, "gm", show_buffer_markers)
end

return M
