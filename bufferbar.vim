set showtabline=2

nnoremap <silent> <expr> <bs> ':b ' .. v:count .. '<cr>'

function! GetBufferbarString() abort
    let listed_buffers = getbufinfo({ 'buflisted': 1 })

    let l:string = ''

    for buf in listed_buffers
        let l:name = '[No Name]'

        if buf.name != ''
            let l:name = split(buf.name, '/')[-1]
        endif

        if buf.bufnr == bufnr('%')
            let l:string .= '%#TabLineSel# '
        else
            let l:string .= ' '
        endif

        let l:string .= buf.bufnr .. ':' .. l:name

        if buf.changed
            let l:string .= ' [+]'
        endif

        if buf.bufnr == bufnr('%')
            let l:string .= ' %#TabLineFill#'
        else
            let l:string .= ' '
        endif

        let l:string .= ' '
    endfor

    return l:string
endfunction

function! RenderBufferbar() abort
    set tabline=%!GetBufferbarString()
endfunction

call RenderBufferbar()

augroup Bufferbar
    au!
    au BufDelete,BufWipeout * call RenderBufferbar()
augroup END
