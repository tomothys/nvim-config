local utils = require("utils")

local M = {}


local function get_current_task()
    local tasks = vim.fn.system("cat ~/tasks.md | grep -E '^-'")

    local current_task = utils.split_string(tasks, "\n")[1]

    if (current_task ~= nil) then
        return string.sub(current_task, 5)
    else
        return ""
    end
end

local function render_current_task()
    vim.o.tabline = "%=" .. get_current_task() .. " 🗒️ "
end

local function add_new_task(task_str)
    vim.fn.system('echo "-   ' .. task_str .. '\n$(cat ~/tasks.md)"' .. ' > ~/tasks.md')
    render_current_task()
end

local function create_user_commands()
    vim.api.nvim_create_user_command('AddTask', function(opts)
        add_new_task(opts.fargs[1])
        render_current_task()
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('RerenderCurrentTask', render_current_task, {})
end

local function create_key_maps()
    vim.api.nvim_set_keymap('n', '<leader>at', ':AddTask ', { noremap = true })
end

M.setup = function()
    print("taskmanager initialized")

    -- Turn tabline on. Current Task will be rendered in tabline
    vim.api.nvim_set_option("showtabline", 2)

    render_current_task()
    create_user_commands()
    create_key_maps()
end

return M
