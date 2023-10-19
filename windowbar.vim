function! RenderWinbar()
    " LEFT SIDE
    set winbar=\ [bufnr]\ %{bufnr('%')}\ -\ %f\ %m\ %r

    " RIGHT SIDE
    set winbar+=%=
    set winbar+=[winnr]\ %{winnr()}\ 
endfunction

augroup Winbar
    au!
    au BufEnter * call RenderWinbar()
augroup END
