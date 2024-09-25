vim.api.nvim_create_user_command("Column",
    function(opt)
        vim.cmd(opt.line1 .. "," .. opt.line2 .. "s%" .. opt.fargs[1] .. "%´&")
        vim.cmd(opt.line1 .. "," .. opt.line2 .. "!column -t -s ´")
        vim.cmd(opt.line1 .. "," .. opt.line2 .. "s%  " .. opt.fargs[1] .. "%" .. opt.fargs[1])
        vim.cmd("nohl")
    end,
    { nargs = 1, range = 2 }
)
