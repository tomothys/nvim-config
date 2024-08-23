local utils = require("utils")

local M = {}


local function get_current_task()
    local homedir = os.getenv("HOME")

    if not utils.exists(homedir .. '/tasks/') then
        vim.fn.system('mkdir ' .. homedir .. '/tasks/')
        print('Created "' .. homedir .. '/tasks/" folder')
    end

    vim.fn.system('touch ' .. homedir .. '/tasks/tasks.txt')

    local tasks = vim.fn.system('cat ' .. homedir .. '/tasks/tasks.txt | grep -E "^-"')
    local tasks_array = utils.split_string(tasks, "\n")

    local current_task = tasks_array[#tasks_array]

    if (current_task ~= nil) then
        return string.sub(current_task, 3)
    else
        return ""
    end
end


local function render_current_task()
    vim.o.tabline = "%=" .. get_current_task() .. " 🗒️ "
end


local function add_new_task(task_str)
    local time = os.date('%H:%M')

    vim.fn.system('echo "- ' .. time .. ' > ' .. task_str .. '" >> ~/tasks/tasks.txt')
end


local function archive_tasks()
    local date_and_time = os.date('%Y-%m-%d_%H-%M')
    local homedir = os.getenv("HOME")

    vim.fn.system("mv " .. homedir .. "/tasks/tasks.txt " .. homedir .. "/tasks/" .. date_and_time .. "_tasks.txt")
    vim.fn.system("touch " .. homedir .. "/tasks/tasks.txt")

    render_current_task()
end


local function create_user_commands()
    vim.api.nvim_create_user_command('TaskAdd', function(opts)
        add_new_task(opts.fargs[1])

        render_current_task()
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('TaskRerenderCurrent', render_current_task, {})

    vim.api.nvim_create_user_command('TaskArchiveList', archive_tasks, {})
end


local function create_key_maps()
    vim.keymap.set('n', '<leader>ta', function()
        add_new_task(vim.fn.input(' New Task > '))

        render_current_task()
    end, { noremap = true })

    vim.keymap.set('n', '<leader>to', ':split ~/tasks/tasks.txt<cr>', { noremap = true, silent = true })
end


M.setup = function()
    print('taskmanager initialized')

    -- Turn tabline on. Current Task will be rendered in tabline
    vim.api.nvim_set_option('showtabline', 2)

    render_current_task()
    create_user_commands()
    create_key_maps()
end

return M
