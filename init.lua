vim.cmd [[
    source $HOME/.config/nvim/core-config.vim
    source $HOME/.config/nvim/abbrevs.vim
    source $HOME/.config/nvim/commands.vim
    source $HOME/.config/nvim/keymaps.vim
    source $HOME/.config/nvim/statusbar.vim
]]

-- Initilize own plugins
-- require("own-plugins.git-blame").setup()
require("own-plugins.meowser").setup()
require("own-plugins.bowser").setup()
require("own-plugins.windowbar").setup()

-- #region - INSTALL LAZY.NVIM IF NOT INSTALLED
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
-- #endregion - INSTALL LAZY.NVIM IF NOT INSTALLED

require("lazy").setup({
    -- #region - Colorscheme
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function()
            vim.cmd [[
                colorscheme kanagawa
            ]]
        end
    },
    -- #endregion - Colorscheme
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
    -- #region - Treesitter
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
    -- #endregion - Treesitter
    -- #region - Filetree
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
                    number = false
                },
            })

            vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>", { silent = true })
        end
    },
    -- #endregion - Filetree
    -- #region - Neovim LSP
    --[[ {
        "neovim/nvim-lspconfig",
        config = function()
            require("lspconfig").setup()
        end
    },
    {
        "williamboman/mason.nvim",
        priority = 900,
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        priority = 800,
        dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "bashls",
                    "cssls",
                    "css_variables",
                    "cssmodules_ls",
                    "tailwindcss",
                    "dockerls",
                    "emmet_ls",
                    "glint",
                    "html",
                    "eslint",
                    "jsonls",
                    "marksman",
                    "sqlls",
                    "svelte",
                    "vuels",
                    "ts_ls",
                    "vimls",
                    "volar",
                }
            })

            local augroup = vim.api.nvim_create_augroup("lsp_augroup", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = augroup,
                callback = function()
                    ---Sets up keymap. Just to apply defaults.
                    ---@param mode string
                    ---@param lhs string
                    ---@param rhs string
                    local function bind(mode, lhs, rhs)
                        vim.keymap.set(mode, lhs, rhs, { buffer = 0 })
                    end

                    bind("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>")
                    bind("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
                    bind("n", "gD", "<cmd>lua vim.diagnostic.setqflist()<cr>")
                    bind("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
                    bind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
                    bind("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>")
                    bind("n", "gr", "<cmd>lua vim.lsp.buf.rename()<cr>")
                    bind("n", "gR", "<cmd>lua vim.lsp.buf.references()<cr>")
                    bind("i", "<c-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
                end
            })

            require("mason-lspconfig").setup_handlers {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function (server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {}
                end,
                -- Next, you can provide a dedicated handler for specific servers.
                ["lua_ls"] = function ()
                    require("lspconfig")["lua_ls"].setup {
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = { vim.env.VIMRUNTIME }
                                },
                            }
                        }
                    }
                end
            }
        end
    }, ]]
    -- #endregion - Neovim LSP
    -- #region - CoC LSP
    {
        "neoclide/coc.nvim",
        config = function()
            -- Some servers have issues with backup files, see #649
            vim.opt.backup = false
            vim.opt.writebackup = false

            ---Sets up keymap. Just to apply defaults.
            ---@param mode string
            ---@param lhs string
            ---@param rhs string
            local function bind(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
            end

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

            bind("n", "K", '<CMD>lua _G.show_docs()<CR>')
            bind("n", "gh", '<CMD>lua _G.show_docs()<CR>')
            bind("n", "ge", "<cmd>lua vim.diagnostic.setloclist()<cr>")
            bind("n", "gr", "<Plug>(coc-rename)")
            bind("n", "gR", "<plug>(coc-references)")
            bind("n", "gd", "<Plug>(coc-definition)")
            bind("n", "gD", "<cmd>lua vim.diagnostic.setqflist()<cr>")
            bind("n", "ga", "<Plug>(coc-codeaction-cursor)")

            vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<cr>"]],
                { silent = true, noremap = true, expr = true, replace_keycodes = false })
            vim.keymap.set("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })
        end
    },
    -- #endregion - CoC LSP
    -- #region - Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<c-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>p", builtin.find_files, {})
            vim.keymap.set("n", "<leader>P", builtin.builtin, {})
            vim.keymap.set("n", "<c-h>", builtin.help_tags, {})
            vim.keymap.set("n", "<c-f>", builtin.current_buffer_fuzzy_find, {})
            vim.keymap.set("n", "<leader>f", builtin.current_buffer_fuzzy_find, {})
            vim.keymap.set("n", "<leader>F", builtin.live_grep, {})
            -- vim.keymap.set("n", "<c-b>", builtin.buffers, {})
        end
    },
    -- #endregion - Telescope
    -- #region - Git Integration
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
    },
    -- #endregion - Git Integration
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    { "mg979/vim-visual-multi" },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    enabled = false
                }
            }
        },
        -- stylua: ignore
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash"
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter"
            },
        },
    },
})
