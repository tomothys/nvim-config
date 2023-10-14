" set mapleader to a space
let g:mapleader = ' '

" general normal mode mappings
nnoremap s :
nnoremap <silent> <esc> :nohl<cr><esc>
nnoremap <leader>s /
nnoremap <leader>S :grep

" escape insert mode a little bit faster and more convenient
inoremap jke <esc>

" change behavior of o - stay in normal mode
nnoremap o o<esc>
nnoremap O O<esc>

nnoremap i i<c-f>
nnoremap I I<c-f>

" quickfix list
nnoremap <silent> gl :cclose<cr>
nnoremap <silent> go :copen<cr>
nnoremap <silent> gn :cnext<cr>
nnoremap <silent> gp :cprev<cr>

" insert mode mappings
inoremap g0 =
cnoremap g0 =

inoremap g1 !
cnoremap g1 !

inoremap g2 ""<left>
cnoremap g2 ""<left>

inoremap g4 $
cnoremap g4 $

inoremap g5 []<left>
cnoremap g5 []<left>

inoremap g8 ()<left>
cnoremap g8 ()<left>

inoremap g9 {}<left>
cnoremap g9 {}<left>

inoremap g0 =
cnoremap g0 =

inoremap g< <><left>
cnoremap g< <><left>

inoremap g+ ``<left>
cnoremap g+ ``<left>

inoremap g# ''<left>
cnoremap g# ''<left>

inoremap g. :
cnoremap g. :

" normal mode mappings for leader keys
nnoremap <silent> <leader>w <c-w>
nnoremap <silent> <leader>e :Lex<cr>

" save current buffer
nnoremap <silent> gw :w<cr>
nnoremap <silent> gW :wa<cr>

" insert mode mappings for ctrl+arrow keys
inoremap <c-l> <right>
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>

" command mode mappings for ctrl+arrow keys
cnoremap <c-l> <right>
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" add j and k jumps to jump-list
nnoremap <expr> j v:count > 1 ? "m'" . v:count . 'j' : 'j'
nnoremap <expr> k v:count > 1 ? "m'" . v:count . 'k' : 'k'

" trigger abbreviations
inoremap fk ,<c-]>

" JavaScript keymaps
function! JavaScriptKeyMaps()
    vnoremap <buffer> gv "zyoconsole.log("<c-r>z", <c-r>z);<esc>
endfunction

augroup javascript_keymaps
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptKeyMaps()
augroup END

" HTML keymaps
function! CreateHtmlTag(is_selfclosing)
    let l:tag = input('HTML-Tag: ')
    let l:class = input('Classes: ')
    let l:currentline = getline('.')

    let l:newline = l:currentline . '<' . l:tag

    if len(l:class) != 0
        let l:newline = l:newline . ' class="' . l:class . '"'
    endif

    if a:is_selfclosing
        let l:newline = l:newline . ' />'
    else
        let l:newline = l:newline . '></' . l:tag . '>'
    endif

    call setline('.', l:newline)

    normal f>
endfunction

function! HtmlKeyMaps()
    inoremap <silent> jktt <esc>:call CreateHtmlTag(v:false)<cr>
    inoremap <silent> jkts <esc>:call CreateHtmlTag(v:true)<cr>
endfunction

augroup html_keymaps
    autocmd!
    autocmd FileType html,javascriptreact,typescriptreact,svelte,vue call HtmlKeyMaps()
augroup END
