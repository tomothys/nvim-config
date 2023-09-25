function! RunPrettier()
    if executable('./node_modules/.bin/prettier') == 1
        execute '!./node_modules/.bin/prettier % --write'
        echo 'Ran prettier on ' .. expand('%')
    endif
endfunction

command! Prettier :silent call RunPrettier()
