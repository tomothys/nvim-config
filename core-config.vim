set encoding=utf-8
set fileencoding=utf-8

set wildmenu
set wildignore+=node_modules/**,.git/**,infrastructure/**
set wildignorecase
set wildmode=longest:full,full
set path+=./**

set foldmethod=marker
set foldmarker=#region,#endregion

set signcolumn=yes
set number
set relativenumber
set cursorline
set nowrap
set breakindent
set expandtab

set tabstop=4
set softtabstop=4
set shiftwidth=4
" set smartindent
set autoindent

set incsearch
set inccommand=split
set ignorecase
set smartcase

set mouse=a

set numberwidth=6
set laststatus=2
set cmdheight=1

set hidden
set splitright
set splitbelow
set scrolloff=3
set list
set showtabline=0
set belloff=all
set termguicolors
set backspace=start,eol,indent

set completeopt-=preview
set completeopt+=noselect,menuone

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

let g:loaded_python3_provider = 0
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
