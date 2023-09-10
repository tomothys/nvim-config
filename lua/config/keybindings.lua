vim.g.mapleader = " "

vim.keymap.set("n", "s", ":", {noremap = true})
vim.keymap.set("n", "<esc>", ":nohl<cr><esc>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>s", ":vimgrep //gjf %<left><left><left><left><left><left>", {noremap = true})
vim.keymap.set("n", "<leader>S", ":grep ", {noremap = true})
vim.keymap.set("n", "gq", ":cclose<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "go", ":copen<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "gn", ":cnext<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "gp", ":cprev<cr>", {noremap = true, silent = true})

vim.keymap.set("i", "g0", "=", {noremap = true})
vim.keymap.set("i", "g1", "!", {noremap = true})
vim.keymap.set("i", "g2", '""<left>', {noremap = true})
vim.keymap.set("i", "g4", "$", {noremap = true})
vim.keymap.set("i", "g5", "[]<left>", {noremap = true})
vim.keymap.set("i", "g7", "/", {noremap = true})
vim.keymap.set("i", "g8", "()<left>", {noremap = true})
vim.keymap.set("i", "g9", "{}<left>", {noremap = true})
vim.keymap.set("i", "g0", "=", {noremap = true})
vim.keymap.set("i", "g<", "<><left>", {noremap = true})
vim.keymap.set("i", "g+", "``<left>", {noremap = true})
vim.keymap.set("i", "g#", "''<left>", {noremap = true})

vim.keymap.set("n", "<leader>w", "<c-w>", {noremap = true})
vim.keymap.set("n", "<leader>e", ":Ex<cr>", {silent = true})

vim.keymap.set("i", "<c-l>", "<right>")
vim.keymap.set("i", "<c-h>", "<left>")
vim.keymap.set("i", "<c-j>", "<down>")
vim.keymap.set("i", "<c-k>", "<up>")

-- Add j and k jumps to jump-list
vim.keymap.set("n", "j", function()
    if vim.v.count > 1 then return "m'" .. vim.v.count .. "j" else return "j" end
end, { silent = true, expr = true })

vim.keymap.set("n", "k", function()
    if vim.v.count > 1 then return "m'" .. vim.v.count .. "k" else return "k" end
end, { silent = true, expr = true })

-- Trigger abbrevs
vim.keymap.set("i", "fk", ",<C-]>")

