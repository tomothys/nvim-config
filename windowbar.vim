function! SetWinbar()
    set winbar=\ [%{bufnr('%')}]\ -\ %f\ %m\ %r
endfunction

augroup Winbar
    au!
    au BufEnter * call SetWinbar()
augroup END

