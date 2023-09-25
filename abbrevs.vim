function! JavaScriptAbbrevs()
    inoreab <buffer> and, &&<space>
    inoreab <buffer> or, \|\|<space>
    inoreab <buffer> eq, ===<space>
    inoreab <buffer> neq, !==<space>
    inoreab <buffer> ud, undefined
    inoreab <buffer> fa, () => <c-o>F)
    inoreab <buffer> fn, function () {}<left><cr><up><esc>0f)i
    inoreab <buffer> clog, console.log("");<c-o>F"
    inoreab <buffer> vlog, <bs><esc>^Daconsole.log("<c-r>-", <c-r>-);
    inoreab <buffer> if, if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> el, <esc>/}<cr>:nohl<cr>a else {}<left><cr><esc>O
    inoreab <buffer> elif, <esc>/}<cr>:nohl<cr>a else if () {}<left><cr><up><esc>0f)i
    inoreab <buffer> imp, import {}<c-o>mb from ""<left>
    inoreab <buffer> cn, const<space><space>=<space><left><left><left>
    inoreab <buffer> try, try {<cr>} catch(error) {<cr>console.error(error)<cr>}<c-o>2k<c-o>O
    inoreab <buffer> aw, await<space>
    inoreab <buffer> pall, Promise.all([<cr>])<c-o>O
    inoreab <buffer> pals, Promise.allSettled([<cr>])<c-o>O
endfunction

augroup javascript_abbrevs
    autocmd!
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,svelte,vue call JavaScriptAbbrevs()
augroup END

function! SvelteAbbrevs()
    inoreab <buffer> sif, {#if }<cr>{/if}<up><esc>0f}i
    inoreab <buffer> sel, <esc>/{\/if}<cr>O{:else}<cr>
    inoreab <buffer> selif, <esc>/{\(\/\\|:\)\(if\\|else\).<cr>O{:else if }<Left>
endfunction

augroup svelte_abbrevs
    autocmd!
    autocmd FileType svelte call SvelteAbbrevs()
augroup END

