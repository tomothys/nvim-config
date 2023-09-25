" set mapleader to a space
let g:mapleader = ' '

" normal mode mappings
nnoremap s :
nnoremap <silent> <esc> :nohl<cr><esc>
nnoremap <leader>s /
nnoremap <leader>S :grep

" change behavior of o - stay in normal mode
nnoremap o o<esc>
nnoremap O O<esc>

" 
nnoremap <silent> gc :cclose<cr>
nnoremap <silent> go :copen<cr>
nnoremap <silent> gn :cnext<cr>
nnoremap <silent> gp :cprev<cr>

" insert mode mappings
inoremap jk0 =
cnoremap jk0 =

inoremap jk1 !
cnoremap jk1 !

inoremap jk2 ""<left>
cnoremap jk2 ""<left>

inoremap jk4 $
cnoremap jk4 $

inoremap jk5 []<left>
cnoremap jk5 []<left>

inoremap jk7 /
cnoremap jk7 /

inoremap jk8 ()<left>
cnoremap jk8 ()<left>

inoremap jk9 {}<left>
cnoremap jk9 {}<left>

inoremap jk0 =
cnoremap jk0 =

inoremap jk< <><left>
cnoremap jk< <><left>

inoremap jk+ ``<left>
cnoremap jk+ ``<left>

inoremap jk# ''<left>
cnoremap jk# ''<left>

inoremap jk. :
cnoremap jk. :

inoremap jke <esc>
cnoremap jke <esc>

inoremap jkr <cr>
cnoremap jkr <cr>

" normal mode mappings for leader keys
nnoremap <silent> <leader>w <c-w>
nnoremap <silent> <leader>e :Ex<cr>

" insert mode mappings for ctrl+arrow keys
inoremap <c-l> <right>
inoremap <c-h> <left>
inoremap <c-j> <down>
inoremap <c-k> <up>

inoremap jktl <right>
cnoremap jktl <right>
inoremap jkth <left>
cnoremap jkth <left>

inoremap <silent> jkw <esc>:w<cr>

" add j and k jumps to jump-list
nnoremap <expr> j v:count > 1 ? "m'" . v:count . 'j' : 'j'
nnoremap <expr> k v:count > 1 ? "m'" . v:count . 'k' : 'k'

" trigger abbreviations
inoremap fk ,<c-]>

" fix tab
inoremap <tab> <tab><c-f>

" JavaScript keymaps
function! JavaScriptKeyMaps()
    inoremap <buffer> jkfn function() {}<c-o>F(
    inoremap <buffer> jku undefined
    inoremap <buffer> jkn null
    inoremap <buffer> jkfa () =>
    inoremap <buffer> jk! !==
    inoremap <buffer> jk= ===
    inoremap <buffer> jkan &&
    inoremap <buffer> jkor \|\|
    inoremap <buffer> jkaw await
    inoremap <buffer> jkpall Promise.all([<cr>])<c-o>O
    inoremap <buffer> jkpals Promise.allSettled([<cr>])<c-o>O
    inoremap <buffer> jkmap .map(() => {})<c-o>F)
    inoremap <buffer> jkfil .filter(() => {})<c-o>F)
    inoremap <buffer> jkduc .reduce((acc, )<c-o>mz => {<cr><c-o>Oreturn acc;}, )<left>
    inoremap <buffer> jkif if () {}<left><cr><up><esc>0f)i
    inoremap <buffer> jktry try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O
    inoremap <buffer> jkimp import {}<c-o>mb from ""<left>
    inoremap <buffer> jkvl <esc>^Daconsole.log("<c-r>-", <c-r>-);
    inoremap <buffer> jkcl console.log("");<c-o>F"
    inoremap <buffer> jkcn const =<space><c-o>F=<space><left>
endfunction

augroup javascript_keymaps
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptKeyMaps()
augroup END

" Lua keymaps
function! LuaKeyMaps()
    inoremap <buffer> jk! ~=
    inoremap <buffer> jkn nil
    inoremap <buffer> jkfn function()<cr>end<c-o>O
    inoremap <buffer> jkif if<space><space><c-o>mzthen<cr>end<c-o>O
endfunction

augroup lua_keymaps
    autocmd!
    autocmd FileType lua call LuaKeyMaps()
augroup END

" Vim keymaps
function! VimKeyMaps()
    inoremap <buffer> jkfn function!()<cr>endfunction<c-o>O
    inoremap <buffer> jkif if<cr>endif<c-o>O
    inoremap <buffer> jkimp source
    inoremap <buffer> jkin inoremap
    inoremap <buffer> jknn nnoremap
    inoremap <buffer> jkb buffer
endfunction

augroup vim_keymaps
    autocmd!
    autocmd FileType vim call VimKeyMaps()
augroup END
