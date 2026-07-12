" Bottom terminal drawer
"
" Public interface:
"   g:terminal_drawer_bufnr    - drawer buffer number
"   g:terminal_drawer_height   - drawer height persists on open/close
"   ToggleTerminal()           - open/close the drawer
"   <Plug>(toggle-terminal)    - keymap target (normal/visual/terminal/insert)
"   User TerminalDrawerOpenPre - autocmd before drawer opens

if exists('g:loaded_terminal_drawer')
    finish
endif
let g:loaded_terminal_drawer = 1

function! ToggleTerminal()
    let tbuf = get(g:, 'terminal_drawer_bufnr', -1)

    if bufexists(tbuf) && bufwinnr(tbuf) > 0
        "" Close the terminal drawer
        let g:terminal_drawer_height = winheight(bufwinnr(tbuf))
        execute bufwinnr(tbuf) . 'hide'
        return
    endif

    silent doautocmd User TerminalDrawerOpenPre
    if !bufexists(tbuf)
        "" Create a new terminal drawer buffer
        let g:terminal_drawer_bufnr = term_start(&shell, {'hidden': 1, 'term_kill': 'hup'})
        call setbufvar(g:terminal_drawer_bufnr, '&buflisted', 0)
        let tbuf = g:terminal_drawer_bufnr
    endif

    "" Open the terminal drawer
    execute 'sbuf ' . tbuf
    wincmd J
    if exists('g:terminal_drawer_height')
        execute 'resize ' . g:terminal_drawer_height
    endif
    if term_getstatus(tbuf) =~# 'normal'
        call feedkeys('i', 'n')
    endif
    setlocal nonumber norelativenumber foldcolumn=0 winfixbuf winfixheight
endfunction

nnoremap <Plug>(toggle-terminal) :call ToggleTerminal()<CR>
vnoremap <Plug>(toggle-terminal) :<C-u>call ToggleTerminal()<CR>
tnoremap <Plug>(toggle-terminal) <C-\><C-n>:call ToggleTerminal()<CR>
inoremap <Plug>(toggle-terminal) <Esc>:call ToggleTerminal()<CR>
