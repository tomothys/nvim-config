" set mapleader to a space
let g:mapleader = ' '

inoremap jk <esc>
inoremap je <esc>
nnoremap <leader>s :w<cr>
nnoremap <leader>as :wa<cr>

" Use search register to mark word under cursor
nnoremap <silent> <leader>j :let @/="<c-r><c-w>" \| set hlsearch<cr>
" Use search register to mark selected part
vnoremap <silent> <leader>j "zy:let @/="<c-r>z" \| set hlsearch<cr>

" Make using the clipboard a little bit easier/faster
nnoremap + "+
vnoremap + "+

" Remove search highlight on esc keypress
nnoremap <silent> <esc> :nohl<cr><esc>

" select pasted before
nnoremap p p`[v`]
nnoremap P P`[v`]
vnoremap p p`[v`]
vnoremap P P`[v`]

" change behavior of o - stay in normal mode
nnoremap o o<esc>
nnoremap O O<esc>

" surround selected text
vnoremap " c""<esc>"-Pl
vnoremap ' c''<esc>"-Pl
vnoremap ( c()<esc>"-Pl
vnoremap { c{}<esc>"-Pl
vnoremap [ c[]<esc>"-Pl

" quickfix list
nnoremap <silent> gl :cclose<cr>
nnoremap <silent> go :copen<cr>
nnoremap <silent> gn :cnext<cr>
nnoremap <silent> gp :cprev<cr>

" normal mode mappings for leader keys
nnoremap <silent> <leader>w <c-w>

" save current buffer
nnoremap <silent> <c-s> :w<cr>

" insert mode mappings for ctrl+arrow keys
inoremap <c-l> <right>
inoremap <c-h> <left>

" command mode mappings for ctrl+arrow keys
cnoremap <c-l> <right>
cnoremap <c-h> <left>

" add j and k jumps to jump-list
nnoremap <expr> j v:count > 1 ? "m'" . v:count . 'j' : 'j'
nnoremap <expr> k v:count > 1 ? "m'" . v:count . 'k' : 'k'

" trigger abbreviations
inoremap <c-k> ,<c-]>
inoremap fk ,<c-]>

nnoremap <s-scrollwheelup> zh
nnoremap <s-scrollwheeldown> zl

" JavaScript keymaps
function! JavaScriptKeyMaps()
    vnoremap <buffer> gv "zyoconsole.log("##### <c-r>z", <c-r>z);<esc>
endfunction

augroup javascript_keymaps
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptKeyMaps()
augroup END
