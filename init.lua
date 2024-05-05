vim.cmd [[
    source $HOME/.config/nvim/core-config.vim
    source $HOME/.config/nvim/abbrevs.vim
    source $HOME/.config/nvim/commands.vim
    source $HOME/.config/nvim/keymaps.vim
    source $HOME/.config/nvim/statusbar.vim
    source $HOME/.config/nvim/windowbar.vim
]]

-- Initilize own plugins
-- require("own-plugins.git-blame").setup()
require("own-plugins.meowser").setup()
require("own-plugins.bowser").setup({ trigger = "<leader>b" })
require("own-plugins.buf-bowser").setup()

-- INSTALL LAZY.NVIM IF NOT INSTALLED [BEGIN]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
-- INSTALL LAZY.NVIM IF NOT INSTALLED [END]

-- LAZY.NVIM [BEGIN]
require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd [[
                colorscheme catppuccin

                highlight! @text.uri gui=NONE

                highlight Winbar gui=bold guibg=#9ece6a guifg=#000000
                highlight WinbarNC guibg=#181825 guifg=#ffffff
                highlight TablineFill guibg=#181825 guifg=#ffffff
                highlight TablineSel gui=bold guibg=#9ece6a guifg=#000000

                highlight! link StatusLine Winbar
                highlight! link StatusLineNC WinbarNC

                highlight FloatTitle guifg=#89b4fa
            ]]
        end,
    },
    {
        lazy = false,
        priority = 999,
        "airblade/vim-rooter",
        config = function()
            vim.cmd [[
                let g:rooter_patterns = []
            ]]
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "svelte", "vue", "c", "lua", "vim", "vimdoc", "query", "tsx", "typescript",
                    "javascript", "html", "css", "scss", "json", "yaml", "toml", "bash", "rust", "regex", "comment" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true }
            })
        end
    },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true

            -- empty setup using defaults
            require("nvim-tree").setup({
                view = {
                    width = 70,
                    side = 'right',
                    number = true
                },
            })

            vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", { silent = true })
        end
    },
    {
        "neoclide/coc.nvim",
        config = function()
            -- Some servers have issues with backup files, see #649
            vim.opt.backup = false
            vim.opt.writebackup = false

            function _G.show_docs()
                local cw = vim.fn.expand('<cword>')
                if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
                    vim.api.nvim_command('h ' .. cw)
                elseif vim.api.nvim_eval('coc#rpc#ready()') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
                end
            end

            vim.keymap.set("n", "gh", '<CMD>lua _G.show_docs()<CR>', { silent = true })

            vim.keymap.set("n", "ge", "", { silent = true, expr = true, noremap = true })
            vim.keymap.set("n", "gr", "<Plug>(coc-rename)", { silent = true, noremap = true })
            vim.keymap.set("n", "gR", "<plug>(coc-references)", { silent = true, noremap = true })
            vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, noremap = true })
            vim.keymap.set("n", "ga", "<Plug>(coc-codeaction-cursor)", { silent = true, noremap = true })

            vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<cr>"]],
                { silent = true, noremap = true, expr = true, replace_keycodes = false })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<c-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>p", builtin.find_files, {})
            vim.keymap.set("n", "<c-h>", builtin.help_tags, {})
            vim.keymap.set("n", "<c-f>", builtin.live_grep, {})
        end
    },
    { "mg979/vim-visual-multi" },
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gg", ":vert Git<cr>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>gp", ":Git push<cr>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>gP", ":Git pull<cr>", { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>gf", ":Git fetch<cr>", { noremap = true, silent = true })
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require "gitsigns".setup {
                on_attach = function()
                    vim.keymap.set("n", "<leader>gk", ":Gitsigns prev_hunk<cr>", { noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>gj", ":Gitsigns next_hunk<cr>", { noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<cr>", { noremap = true, silent = true })
                    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<cr>", { noremap = true, silent = true })
                end
            }
        end
    }
})
-- LAZY.NVIM [END]
