inoreab k, <c-o>O

" JavaScript abbrevs
function! JavaScriptAbbrevs()
    inoreab <buffer> isu, === undefined
    inoreab <buffer> isnu, !== undefined
    inoreab <buffer> isn, === null
    inoreab <buffer> isnn, !== null
    inoreab <buffer> isf, === false

    inoreab <buffer> imp, import {}<c-o>mb from "";<left><left>

    inoreab <buffer> cn, const<space><space>=<space><left><left><left>

    inoreab <buffer> try, try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O

    inoreab <buffer> aw, await<space>
    inoreab <buffer> pall, await Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals, await Promise.allSettled([<cr>])<c-o>O

    inoreab <buffer> th, <bs>.then((_param) => {<cr>})<c-o>O
    inoreab <buffer> ca, <bs>.catch((error) => {<cr>console.error(error);<cr>})<c-o>O
    inoreab <buffer> fi, <bs>.finally(() => {<cr>})<c-o>O

    inoreab <buffer> r, return
endfunction

augroup javascript_abbrevs
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptAbbrevs()
augroup END

" Svelte abbrevs
function! SvelteAbbrevs()
    inoreab <buffer> sif, {#if }<cr>{/if}<up><esc>0f}i
    inoreab <buffer> sel, <esc>/{\/if}<cr>O{:else}<cr>
    inoreab <buffer> selif, <esc>/{\(\/\\|:\)\(if\\|else\).<cr>O{:else if }<left>
    inoreab <buffer> se {#each array as item, index}<cr>{/each}<esc>k02fave<c-g>
endfunction

augroup svelte_abbrevs
    autocmd!
    autocmd FileType svelte call SvelteAbbrevs()
augroup END

" Lua abbrevs
function! LuaAbbrevs()
    inoreab <buffer> ne, ~=
    inoreab <buffer> fn, function()<cr>end<c-o>O
    inoreab <buffer> if, if<space><space><c-o>mzthen<cr>end<c-o>O
endfunction

augroup lua_abbrevs
    autocmd!
    autocmd FileType lua call LuaAbbrevs()
augroup END

" VimL abbrevs
function! VimAbbrevs()
    inoreab <buffer> fn, function! name()<cr>endfunction<esc>k$Fnve<c-g>
    inoreab <buffer> ne, !=
    inoreab <buffer> if, if<cr>endif<esc>kA<space>
endfunction

augroup vim_abbrevs
    autocmd!
    autocmd FileType vim call VimAbbrevs()
augroup END

" CSS abbrevs
function! CssAbbrevs()
    inoreab <buffer> c, color: ;<left>
    inoreab <buffer> bg, background: ;<left>
    inoreab <buffer> bgc, background-color: ;<left>
    inoreab <buffer> bo, border: ;<left>
    inoreab <buffer> bor, border-radius: ;<left>
    inoreab <buffer> fs, font-size: ;<left>
    inoreab <buffer> fw, font-weight: ;<left>
    inoreab <buffer> ff, font-family: ;<left>
    inoreab <buffer> bs, box-sizing: border-box;
    inoreab <buffer> m, margin: ;<left>
    inoreab <buffer> p, padding: ;<left>
    inoreab <buffer> v, var(--)<left>
    inoreab <buffer> pe, pointer-event: none;
    inoreab <buffer> w, width: ;<left>
    inoreab <buffer> mw, min-width: ;<left>
    inoreab <buffer> h, height: ;<left>
    inoreab <buffer> mh, min-height: ;<left>
    inoreab <buffer> dn, display: none;
    inoreab <buffer> dc, display: content;
    inoreab <buffer> db, display: block;
    inoreab <buffer> dib, display: inline-block;
    inoreab <buffer> df, display: flex;
    inoreab <buffer> dif, display: inline-flex;
    inoreab <buffer> jc, justify-content: center;<esc>bviw<c-g>
    inoreab <buffer> ai, align-items: center;<esc>bviw<c-g>
    inoreab <buffer> dg, display: grid;
    inoreab <buffer> gc, grid-template-columns: ;<left>
    inoreab <buffer> gr, grid-template-rows: ;<left>
    inoreab <buffer> g, gap: ;<left>
    inoreab <buffer> tf, transform: ;<left>
    inoreab <buffer> ts, transition: ;<left>
    inoreab <buffer> o, opacity: ;<left>
    inoreab <buffer> cp, cursor: pointer;<left>
    inoreab <buffer> lg, linear-gradient()<left>
    inoreab <buffer> cm, color-mix(in srgb, color_one, white)<esc>4bve<c-g>
endfunction

augroup css_abbrevs
    autocmd!
    autocmd FileType scss,css,vue,svelte,html call CssAbbrevs()
augroup END
