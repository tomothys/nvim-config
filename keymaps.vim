" set mapleader to a space
let g:mapleader = ' '

" Use search register to mark word under cursor
nnoremap <silent> <leader>j :let @/="<c-r><c-w>" \| set hlsearch<cr>
" Use search register to mark selected part
vnoremap <silent> <leader>j "zy:let @/="<c-r>z" \| set hlsearch<cr>

nnoremap + "+
vnoremap + "+

" general mappings to make life a little bit more convenient
nnoremap s :
nnoremap <silent> <esc> :nohl<cr><esc>
inoremap jke <esc>

" select pasted before
nnoremap p p`[v`]
nnoremap P P`[v`]
vnoremap p p`[v`]
vnoremap P P`[v`]

" change behavior of o - stay in normal mode
nnoremap o o<esc>
nnoremap O O<esc>

" reindent when entering insert mode via i/I
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

" normal mode mappings for leader keys
nnoremap <silent> <leader>w <c-w>

" save current buffer
nnoremap <silent> gw :w<cr>
nnoremap <silent> gW :wa<cr>

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
    let l:input = input('HTML-Tag: ')

    let l:tag = matchstr(l:input, '^\S\+')
    let l:class = strpart(l:input, len(l:tag)+1)

    let l:pos = getpos('.')
    let l:line = l:pos[1]
    let l:col = l:pos[2]

    let l:newline = '<' . l:tag

    if len(l:class) != 0
        let l:newline = l:newline . ' class="' . l:class . '"'
    endif

    if a:is_selfclosing
        let l:newline = l:newline . ' />'
    else
        let l:newline = l:newline . '></' . l:tag . '>'
    endif

    exec 'normal i' .. l:newline

    call setpos('.', l:pos)
endfunction

" Add attributes to HTML Elements
function! AddAttrToHtmlTag()
    let l:input = input('Attributes: ')

    let l:attr = matchstr(l:input, '^\S\+')
    let l:value = strpart(l:input, len(l:attr)+1)

    let l:pos = getpos('.')
    let l:line = l:pos[1]
    let l:col = l:pos[2]

    let l:is_self_closing_tag = search('/>', 'cn')

    if l:is_self_closing_tag
        normal f/
    else
        normal f>
    endif

    let l:string = l:attr

    if len(l:value)
        let l:string .= '="' .. l:value .. '"'
    endif

    execute 'normal i ' .. l:string

    call setpos('.', l:pos)
endfunction

function! HtmlKeyMaps()
    inoremap <silent> <buffer> jktt <esc>:call CreateHtmlTag(v:false)<cr>
    nnoremap <silent> <buffer> <leader>ht :call CreateHtmlTag(v:false)<cr>

    inoremap <silent> <buffer> jkts <esc>:call CreateHtmlTag(v:true)<cr>
    nnoremap <silent> <buffer> <leader>hs :call CreateHtmlTag(v:true)<cr>

    inoremap <silent> <buffer> jka <esc>:call AddAttrToHtmlTag()<cr>
    nnoremap <silent> <buffer> <leader>ha :call AddAttrToHtmlTag()<cr>
endfunction

augroup html_keymaps
    autocmd!
    autocmd FileType html,javascriptreact,typescriptreact,svelte,vue call HtmlKeyMaps()
augroup END
