inoreab (),, (<cr>)<c-o>O
inoreab [],, [<cr>]<c-o>O
inoreab {},, {<cr>}<c-o>O

inoreab imp,, import
inoreab cn,, const
inoreab s,, string
inoreab b,, boolean
inoreab n,, number
inoreab l,, let
inoreab fn,, function
inoreab r,, return
inoreab u,, undefined
inoreab aw,, await

" JavaScript abbrevs
function! JavaScriptAbbrevs()
    inoreab <buffer> com,, /***/<left><left><cr><cr><del><bs><esc>kA<space>

    inoreab <buffer> import,, import {} from "";<esc>hi
    inoreab <buffer> const,, <bs><esc>bdeaconst<space><c-r>-<space>=<space>;<left>
    inoreab <buffer> let,, <bs><esc>bdealet<space><c-r>-<space>=<space>;<left>

    inoreab <buffer> iife,, (() => {<cr>})();<c-o>O

    inoreab <buffer> if,, if () {<cr>}<esc>[{F(a
    inoreab <buffer> el,, <esc>]}a<space>else {<cr>}<c-o>O
    inoreab <buffer> elif,, <esc>]}a<space>else if () {<cr>}<esc>[{F(a

    inoreab <buffer> function,, function () {<cr>}<esc>[{F(i
    inoreab <buffer> fa,, () => {}

    inoreab <buffer> ma,, <bs>.map((item) => )<left>{}
    inoreab <buffer> so,, <bs>.sort(([item_a, item_b]) => )<left>{}
    inoreab <buffer> fil,, <bs>.filter((item) => )<left>{}
    inoreab <buffer> red,, <bs>.reduce((acc, item) => , [])<c-o>F,{}
    inoreab <buffer> foe,, <bs>.forEach((item) => )<left>{}

    inoreab <buffer> try,, try {<cr>} catch(err) {<cr>console.error(err)<cr>}<c-o>2k<c-o>O

    inoreab <buffer> pall,, await Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals,, await Promise.allSettled([<cr>])<c-o>O

    inoreab <buffer> th,, <bs>.then((response) => {<cr>})<c-o>O
    inoreab <buffer> ca,, <bs>.catch((error) => {<cr>console.error(error);<cr>})<c-o>O
    inoreab <buffer> fi,, <bs>.finally(() => {<cr>})<c-o>O

    inoreab <buffer> undefined,, null
    inoreab <buffer> null,, undefined

    inoreab <buffer> await,, async
    inoreab <buffer> async,, await

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
