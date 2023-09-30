" JavaScript keymaps
function! JavaScriptAbbrevs()
    inoreab <buffer> and, &&<space>
    inoreab <buffer> or, \|\|<space>
    inoreab <buffer> eq, ===<space>
    inoreab <buffer> ne, !==<space>
    inoreab <buffer> ud, undefined
    inoreab <buffer> fa, () =><space><c-o>F)
    inoreab <buffer> fn, function () {}<left><cr><up><esc>0f)i
    inoreab <buffer> clog, console.log("");<c-o>F"
    inoreab <buffer> if, if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> el, <esc>/}<cr>:nohl<cr>a else {}<left><cr><esc>O
    inoreab <buffer> elif, <esc>/}<cr>:nohl<cr>a else if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> imp, import {}<c-o>mb from "";<left>
    inoreab <buffer> cn, const<space><space>=<space>;<left><left><left><left>
    inoreab <buffer> try, try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O
    inoreab <buffer> aw, await<space>
    inoreab <buffer> pall, Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals, Promise.allSettled([<cr>])<c-o>O
endfunction

augroup javascript_abbrevs
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptAbbrevs()
augroup END

" Svelte abbrevs
function! SvelteAbbrevs()
    inoreab <buffer> sif, {#if }<cr>{/if}<up><esc>0f}i
    inoreab <buffer> sel, <esc>/{\/if}<cr>O{:else}<cr>
    inoreab <buffer> selif, <esc>/{\(\/\\|:\)\(if\\|else\).<cr>O{:else if }<Left>
endfunction

augroup svelte_abbrevs
    autocmd!
    autocmd FileType svelte call SvelteAbbrevs()
augroup END

" Lua keymaps
function! LuaAbbrevs()
    inoreab <buffer> ne, ~=
    inoreab <buffer> fn, function()<cr>end<c-o>O
    inoreab <buffer> if, if<space><space><c-o>mzthen<cr>end<c-o>O
endfunction

augroup lua_keymaps
    autocmd!
    autocmd FileType lua call LuaAbbrevs()
augroup END
