" JavaScript keymaps
function! JavaScriptAbbrevs()
    inoreab <buffer> a, &&
    inoreab <buffer> o, \|\|
    inoreab <buffer> e, ===
    inoreab <buffer> ne, !==
    inoreab <buffer> b, []<left>
    inoreab <buffer> c, {<cr>}<c-o>O
    inoreab <buffer> p, ()<left>
    inoreab <buffer> h, <><left>
    inoreab <buffer> t, true
    inoreab <buffer> f, false
    inoreab <buffer> u, undefined
    inoreab <buffer> n, null

    inoreab <buffer> com, //<space>

    inoreab <buffer> isu, === undefined
    inoreab <buffer> isnu, !== undefined
    inoreab <buffer> isn, === null
    inoreab <buffer> isnn, !== null
    inoreab <buffer> isf, === false
    inoreab <buffer> isnf, !== false

    inoreab <buffer> fa, (_param) => {}<esc>vb
    inoreab <buffer> fn, function name(_param) {<cr>}<esc>k03fnve<c-g>
    inoreab <buffer> fm, _name() {<cr>}<esc>k0f_ve<c-g>
    inoreab <buffer> clog, console.log("");<c-o>F"
    inoreab <buffer> if, if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> el, <esc>/}<cr>:nohl<cr>a else {}<left><cr><esc>O
    inoreab <buffer> elif, <esc>/}<cr>:nohl<cr>a else if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> imp, import {}<c-o>mb from "";<left><left>
    inoreab <buffer> cn, const<space><space>=<space>;<left><left><left><left>

    inoreab <buffer> try, try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O

    inoreab <buffer> aw, await<space>
    inoreab <buffer> pall, await Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals, await Promise.allSettled([<cr>])<c-o>O

    inoreab <buffer> th, .then((_param) => {<cr>})<c-o>O
    inoreab <buffer> ca, .catch((error) => {<cr>console.error(error);<cr>})<c-o>O
    inoreab <buffer> fi, .finally(() => {<cr>})<c-o>O
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
    inoreab <buffer> cl, .class {<cr>}<esc>k0fcviw<c-g>
    inoreab <buffer> hv, :hover
    inoreab <buffer> af, :after
    inoreab <buffer> bf, :before
    inoreab <buffer> da, :disabled
    inoreab <buffer> no, :not()<left>
    inoreab <buffer> fc, :first-child
    inoreab <buffer> lc, :last-child
    inoreab <buffer> nc, :nth-child()<left>

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
    inoreab <buffer> jc, justify-content: center;<esc>bciw<c-g>
    inoreab <buffer> ai, align-items: center;<esc>bciw<c-g>
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
