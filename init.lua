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
            vim.cmd("")
            vim.cmd[[
                colorscheme tokyonight
                highlight! @text.uri gui=NONE
                highlight LineNr guibg=NONE guifg=#7aa2f7
                highlight LineNrAbove guibg=NONE guifg=#db4b4b
                highlight LineNrBelow guibg=NONE guifg=#9ece6a
                highlight StatusLine gui=bold guifg=#ffffff guibg=#db4b4b " guifg=#24283b 
                highlight! link Winbar StatusLine
                highlight! link WinbarNC StatusLineNC
            ]]
        end,
    },
    {
        lazy = false,
        priority = 999,
        "airblade/vim-rooter",
        config = function()
            vim.cmd [[
                " let g:rooter_patterns = [".git"]
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

                                for i, bufnr in ipairs(buffers) do
                                    vim.lsp.buf_attach_client(bufnr, client.id)
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
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = { theme = "dropdown" },
                    buffers = { theme = "dropdown" },
                }
            })
            require("telescope").load_extension("fzf")

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>p", builtin.find_files, {})
            vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>b", builtin.buffers, {})
            vim.keymap.set("n", "<leader>h", builtin.help_tags, {})
        end
    },
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
                   vim.keymap.set("n", "<leader>gj", ":Gitsigns prev_hunk<cr>", { noremap = true, silent = true })
                   vim.keymap.set("n", "<leader>gk", ":Gitsigns next_hunk<cr>", { noremap = true, silent = true })
                   vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<cr>", { noremap = true, silent = true })
               end
            }
        end
    },
})
-- LAZY.NVIM [END]
