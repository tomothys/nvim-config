vim.api.nvim_create_user_command("Prettier", function()
    if vim.fn.executable("./node_modules/.bin/prettier") == 1 then
        vim.cmd("silent !./node_modules/.bin/prettier % --write")
    end
end, {})

