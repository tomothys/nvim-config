vim.cmd [[
    source $HOME/.config/nvim/core-config.vim
    source $HOME/.config/nvim/abbrevs.vim
    source $HOME/.config/nvim/commands.vim
    source $HOME/.config/nvim/keymaps.vim
    source $HOME/.config/nvim/statusbar.vim
    source $HOME/.config/nvim/windowbar.vim
    source $HOME/.config/nvim/bufferbar.vim
]]

-- Initilize own plugins
-- require("own-plugins.git-blame").setup()
require("own-plugins.meowser").setup()

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
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd [[
                colorscheme tokyonight

                highlight! @text.uri gui=NONE
                highlight! link Comment StatusLineNC

                highlight LineNr gui=bold guibg=#373640 guifg=#7aa2f7
                highlight! link CursorLineNr LineNr
                highlight LineNrAbove guibg=#373640 guifg=#db4b4b
                highlight LineNrBelow guibg=#373640 guifg=#9ece6a

                highlight StatusLine gui=bold guifg=#000000 guibg=#e0af68
                highlight StatusLineNC guifg=#e0af68 guibg=#373640
                highlight! link Winbar StatusLine
                highlight! link WinbarNC StatusLineNC
                highlight! link TablineFill StatusLineNC
                highlight! link TablineSel StatusLine

                highlight SignColumn guibg=#373640
                highlight DiagnosticSignError guifg=#db4b4b guibg=#373640
                highlight DiagnosticSignWarn guifg=#e0af68 guibg=#373640
                highlight DiagnosticSignInfo guifg=#0db9d7 guibg=#373640
                highlight DiagnosticSignHint guifg=#1abc9c guibg=#373640
                highlight DiagnosticSignOk ctermfg=10 guifg=LightGreen guibg=#373640
                highlight GitSignsAdd guibg=#373640
                highlight GitSignsChange guibg=#373640
                highlight GitSignsDelete guibg=#373640

                highlight NormalFloat guifg=#c0caf5 guibg=#373640
                highlight! link FloatBorder StatusLineNC
                highlight! link FloatTitle FloatBorder
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

            -- Use K to show documentation in preview window
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

            vim.keymap.set("i", "<c-j>", [[coc#pum#visible() ? coc#pum#next(1) : coc#refresh()]],
                { silent = true, noremap = true, expr = true, replace_keycodes = false })
            vim.keymap.set("i", "<c-k>", [[coc#pum#visible() ? coc#pum#prev(1) : coc#refresh()]],
                { silent = true, noremap = true, expr = true, replace_keycodes = false })
            vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<cr>"]],
                { silent = true, noremap = true, expr = true, replace_keycodes = false })
        end
    },
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        config = function()
            vim.cmd [[
                let $FZF_DEFAULT_OPTS='--layout=reverse'
                let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!{node_modules/*,.git/*}"'
                let g:fzf_preview_window = []
                let g:fzf_layout = {'window': { 'width': 0.6, 'height': 0.6, 'border': 'rounded' }}
            ]]

            vim.keymap.set("n", "<leader>p", ":Files<cr>", { silent = true })
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
            vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", { noremap = true, silent = true })
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
    },
    {
        "kana/vim-arpeggio",
        config = function()
            vim.cmd [[
                " Global chords
                Arpeggio inoremap fk ,<c-]>
                Arpeggio inoremap je <Esc>
                Arpeggio inoremap jo <esc>O

                Arpeggio inoremap or \|
                Arpeggio inoremap and &&<space>
                Arpeggio inoremap sl /
                Arpeggio inoremap bl \
                Arpeggio inoremap le ;
                Arpeggio inoremap dp :<space>
                Arpeggio inoremap gh <><left>
                Arpeggio nnoremap dp :

                Arpeggio inoremap aw await<space>
                Arpeggio inoremap ud undefined
                Arpeggio inoremap nl null
                Arpeggio inoremap fj false
                Arpeggio inoremap tj true
                Arpeggio inoremap fn function
                Arpeggio inoremap fm ()<c-o>mb {<cr>}<c-o>O
                Arpeggio inoremap fa ()<c-o>mb => {}<left>
                Arpeggio inoremap ma .map(() => {})<c-o>F)
                Arpeggio inoremap fl .filter(() => {})<c-o>F)
                Arpeggio inoremap re .reduce((acc, ) => {}, undefined)<c-o>F)
                Arpeggio inoremap cn const<space><space>=<space><left><left><left>
                Arpeggio inoremap if if () {<cr>}<esc>kf)i
                Arpeggio inoremap cl console.log("");<c-o>F"
                Arpeggio nnoremap gö viwyoconsole.log("<c-r>0", <c-r>0);<esc>
                Arpeggio vnoremap gö yoconsole.log("<c-r>0", <c-r>0);<esc>
                Arpeggio inoremap iew import {}<c-o>mb from "";<left><left>

                Arpeggio inoremap ij ===<space>
                Arpeggio inoremap in !==<space>
            ]]
        end
    },
})
-- LAZY.NVIM [END]
