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
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd[[
                colorscheme tokyonight

                highlight! @text.uri gui=NONE

                highlight LineNr gui=bold guibg=#373640 guifg=#7aa2f7
                highlight! link CursorLineNr LineNr
                highlight LineNrAbove guibg=#373640 guifg=#db4b4b
                highlight LineNrBelow guibg=#373640 guifg=#9ece6a

                highlight StatusLine gui=bold guifg=#000000 guibg=#e0af68
                highlight StatusLineNC guifg=#e0af68 guibg=#373640
                highlight! link Winbar StatusLine
                highlight! link WinbarNC StatusLineNC

                highlight SignColumn guibg=#373640
                highlight DiagnosticSignError guifg=#db4b4b guibg=#373640
                highlight DiagnosticSignWarn guifg=#e0af68 guibg=#373640
                highlight DiagnosticSignInfo guifg=#0db9d7 guibg=#373640
                highlight DiagnosticSignHint guifg=#1abc9c guibg=#373640
                highlight DiagnosticSignOk ctermfg=10 guifg=LightGreen guibg=#373640
                highlight GitSignsAdd guibg=#373640
                highlight GitSignsChange guibg=#373640
                highlight GitSignsDelete guibg=#373640
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
                ensure_installed = { "svelte", "vue", "c", "lua", "vim", "vimdoc", "query", "tsx", "typescript", "javascript", "html", "css", "scss", "json", "yaml", "toml", "bash", "rust", "regex", "comment" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true }
            })
        end
    },
    {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "tsserver", "cssls", "eslint", "html", "jsonls", "svelte", "tailwindcss", "vimls", "volar" }
            })

            local on_attach = function(client, buffer)
                vim.keymap.set("n", "gh", vim.lsp.buf.hover, { buffer = buffer })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer })
                vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = buffer })
                vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = buffer })
                vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = buffer })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer })
                vim.keymap.set("n", "ge", vim.diagnostic.open_float, { buffer = buffer })
                vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = buffer })

                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        command = "Prettier",
                        buffer = buffer,
                    })
                end
            end

            require("mason-lspconfig").setup_handlers({
                function (server_name)
                    require("lspconfig")[server_name].setup({ on_attach = on_attach })
                end,
                ["tailwindcss"] = function()
                    require("lspconfig")["tailwindcss"].setup({
                        on_attach = on_attach,
                        filetypes = { "html", "vue", "svelte", "css", "scss", "javascriptreact", "typescriptreact" },
                    })
                end,
                ["volar"] = function()
                    require("lspconfig")["volar"].setup({
                        on_attach = function(client, bufnr)
                            -- MAKE VOLAR TAKE OVER [BEGIN]
                            local active_tsserver_client = vim.lsp.get_active_clients({ name = "tsserver" })[1]

                            if active_tsserver_client ~= nil then
                                local buffers = vim.lsp.get_buffers_by_client_id(active_tsserver_client.id)

                                for _, buffer in ipairs(buffers) do
                                    vim.lsp.buf_attach_client(buffer, client.id)
                                end

                                active_tsserver_client.stop()
                            end
                            -- MAKE VOLAR TAKE OVER [END]

                            on_attach(client, bufnr)
                        end
                    })
                end,
                ["tsserver"] = function()
                    require("lspconfig")["tsserver"].setup({
                        on_attach = function(client, bufnr)
                            -- MAKE VOLAR TAKE OVER [BEGIN]
                            local active_volar_client = vim.lsp.get_active_clients({ name = "volar" })[1]

                            if active_volar_client ~= nil then
                                vim.lsp.buf_attach_client(bufnr, active_volar_client.id)
                            end

                            if active_volar_client ~= nil then
                                client.stop()
                                return;
                            end
                            -- MAKE VOLAR TAKE OVER [END]

                            on_attach(client, bufnr)
                        end
                    })
                end,
            })

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded"
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded"
            })

            vim.diagnostic.config({
                float = { border = "rounded" }
            })
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

            vim.keymap.set("n", "<leader>p", ":Files<cr>", { silent=true })
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
            vim.keymap.set("n", "<leader>gg", ":vert Git<cr>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>gp", ":Git push<cr>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>gP", ":Git pull<cr>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>gf", ":Git fetch<cr>", {noremap = true, silent = true})
            vim.keymap.set("n", "<leader>gc", ":Git commit<cr>", {noremap = true, silent = true})
        end
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require"gitsigns".setup {
               on_attach = function()
                   vim.keymap.set("n", "<leader>gk", ":Gitsigns prev_hunk<cr>", { noremap = true, silent = true })
                   vim.keymap.set("n", "<leader>gj", ":Gitsigns next_hunk<cr>", { noremap = true, silent = true })
                   vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<cr>", { noremap = true, silent = true })
                   vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<cr>", { noremap = true, silent = true })
               end
            }
        end
    },
})
-- LAZY.NVIM [END]
