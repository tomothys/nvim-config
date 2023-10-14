set laststatus=3

function! GetModeLabel(mode) abort
    let l:mode_dict = {
                \ 'n': 'NORMAL',
                \ 'v': 'VISUAL',
                \ 'c': 'COMMAND',
                \ 'V': 'VISUAL',
                \ '': 'V-BLOCK',
                \ 'i': 'INSERT',
                \ 'R': 'REPLACE',
                \ 'Rv': 'V-Replace',
                \ 's': 'SELECT',
                \ 't': 'TERMINAL'
                \}

    return l:mode_dict[a:mode]
endfunction

function! GetGitBranch() abort
    let l:gitbranch=substitute(system('git symbolic-ref --short HEAD 2>/dev/null'), '\n', '', '')
    return l:gitbranch
endfunction

" LEFT SIDE
set statusline=\ \>_\ [mode]\ %{GetModeLabel(mode())}

" RIGHT SIDE
set statusline+=%=
set statusline+=[branch]\ %{GetGitBranch()}\ \ 

