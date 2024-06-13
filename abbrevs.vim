" JavaScript abbrevs
function! JavaScriptAbbrevs()
    inoreab <buffer> str,, string
    inoreab <buffer> boo,, boolean
    inoreab <buffer> num,, number

    inoreab <buffer> imp,, import
    inoreab <buffer> import,, <bs><esc>F"df"aimport {} from <c-r>-;<esc>F}i

    inoreab <buffer> cn,, const
    inoreab <buffer> const,, <bs><esc>bdeaconst<space><c-r>-<space>=<space>;<left>

    inoreab <buffer> l,, let
    inoreab <buffer> let,, <bs><esc>bdealet<space><c-r>-<space>=<space>;<left>

    inoreab <buffer> bra,, []<left>
    inoreab <buffer> obj,, {<cr>}<c-o>O
    inoreab <buffer> iife,, (() => {<cr>})();<c-o>O

    inoreab <buffer> if,, <bs><esc>d^aif (<c-r>-) {<cr>}<c-o>O
    inoreab <buffer> el,, <esc>/}<cr>a<space>else {<cr>}<c-o>O
    inoreab <buffer> elif,, <bs><esc>d^/}<cr>a else if (<c-r>-) {<cr>}<c-o>O

    inoreab <buffer> fa,, <bs><esc>d?##a<bs><bs>(<c-r>-) => {<cr>}<c-o>O

    inoreab <buffer> ma,, <bs>.map((item) => {<cr>})<c-o>O
    inoreab <buffer> so,, <bs>.sort(([item_a, item_b]) => {<cr>})<c-o>O
    inoreab <buffer> fil,, <bs>.filter((item) => {<cr>})<c-o>O
    inoreab <buffer> red,, <bs>.reduce((acc, item) => {<cr>}, [])<c-o>O
    inoreab <buffer> foe,, <bs>.forEach((item) => {<cr>})<c-o>O

    inoreab <buffer> try,, try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O

    inoreab <buffer> pall,, await Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals,, await Promise.allSettled([<cr>])<c-o>O

    inoreab <buffer> th,, <bs>.then((_param) => {<cr>})<c-o>O
    inoreab <buffer> ca,, <bs>.catch((error) => {<cr>console.error(error);<cr>})<c-o>O
    inoreab <buffer> fi,, <bs>.finally(() => {<cr>})<c-o>O

    inoreab <buffer> fn,, function
    inoreab <buffer> function,, <bs><esc>d^afunction (<c-r>-) {<cr>}<c-o>O
    inoreab <buffer> aw,, await<space>
    inoreab <buffer> r,, return<space>
    inoreab <buffer> u,, undefined
    inoreab <buffer> undefined,, null
    inoreab <buffer> null,, undefined

    inoreab <buffer> f,, false
    inoreab <buffer> false,, true
    inoreab <buffer> true,, false

    inoreab <buffer> is,, ===
    inoreab <buffer> ===,, !==
    inoreab <buffer> !==,, ===
endfunction

augroup javascript_abbrevs
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptAbbrevs()
augroup END

" Svelte abbrevs
function! SvelteAbbrevs()
    inoreab <buffer> sif,, {#if }<cr>{/if}<up><esc>0f}i
    inoreab <buffer> sel,, <esc>/{\/if}<cr>O{:else}<cr>
    inoreab <buffer> selif,, <esc>/{\(\/\\|:\)\(if\\|else\).<cr>O{:else if }<left>
    inoreab <buffer> seach,, {#each array as item, index}<cr>{/each}<esc>k02fave<c-g>
endfunction

augroup svelte_abbrevs
    autocmd!
    autocmd FileType svelte call SvelteAbbrevs()
augroup END

" Lua abbrevs
function! LuaAbbrevs()
    inoreab <buffer> ne,, ~=
    inoreab <buffer> fn,, function()<cr>end<c-o>O
    inoreab <buffer> if,, if<space><space><c-o>mzthen<cr>end<c-o>O
endfunction

augroup lua_abbrevs
    autocmd!
    autocmd FileType lua call LuaAbbrevs()
augroup END

" VimL abbrevs
function! VimAbbrevs()
    inoreab <buffer> fn,, function! name()<cr>endfunction<esc>k$Fnve<c-g>
    inoreab <buffer> ne,, !=
    inoreab <buffer> if,, if<cr>endif<esc>kA<space>
endfunction

augroup vim_abbrevs
    autocmd!
    autocmd FileType vim call VimAbbrevs()
augroup END
