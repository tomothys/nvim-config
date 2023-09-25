set laststatus=3

function! GetGitBranch()
    let l:gitbranch=substitute(system('git symbolic-ref --short HEAD 2>/dev/null'), '\n', '', '')
    return l:gitbranch
endfunction

" LEFT SIDE
set statusline=\ \>_

" RIGHT SIDE
set statusline+=%=
set statusline+=[branch]\ %{GetGitBranch()}\ \ 

