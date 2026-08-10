" Bottom terminal drawer
"
" Public interface:
"   OpenTerminal()              - open drawer (returns: 1 - opened, 0 - no-op)
"   CloseTerminal()             - close drawer (returns: 1 - closed, 0 - no-op)
"   ToggleTerminal()            - toggle the drawer open/close state
"   g:terminal_drawer_bufnr     - drawer buffer number
"   g:terminal_drawer_height    - drawer window height (initial/current)
"   <Plug>(toggle-terminal)     - keymap target (normal/visual/terminal/insert)
"   User TerminalDrawerOpenPre  - autocmd before drawer opens

if exists('g:terminal_drawer_loaded')
    finish
endif
let g:terminal_drawer_loaded = 1

function! s:save_scroll_pos()
    let toplines = {}
    for info in getwininfo()
        let toplines[info.winid] = info.topline
    endfor
    return toplines
endfunction

function! s:restore_scroll_pos(toplines)
    for [id, topline] in items(a:toplines)
        if win_id2win(str2nr(id)) > 0
            call win_execute(str2nr(id), 'call winrestview({"topline":' . topline . '})')
        endif
    endfor
endfunction

function! CloseTerminal()
    let tbuf = get(g:, 'terminal_drawer_bufnr', -1)
    if bufexists(tbuf) && bufwinnr(tbuf) > 0
        let g:terminal_drawer_height = winheight(bufwinnr(tbuf))
        let toplines = s:save_scroll_pos()
        execute bufwinnr(tbuf) . 'hide'
        let prevwin = get(g:, 'terminal_drawer_prevwin', 0)
        if prevwin && win_id2win(prevwin) > 0
            call win_gotoid(prevwin)
        endif
        call s:restore_scroll_pos(toplines)
        return 1
    endif
    return 0
endfunction

function! OpenTerminal()
    let tbuf = get(g:, 'terminal_drawer_bufnr', -1)
    if bufexists(tbuf) && bufwinnr(tbuf) > 0
        return 0
    endif

    let g:terminal_drawer_prevwin = win_getid()
    let toplines = s:save_scroll_pos()
    silent doautocmd User TerminalDrawerOpenPre
    "" Create a new terminal buffer if it doesn't already exist
    if !bufexists(tbuf)
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
    call s:restore_scroll_pos(toplines)
    return 1
endfunction

function! ToggleTerminal()
    if !CloseTerminal()
        call OpenTerminal()
    endif
endfunction

nnoremap <Plug>(toggle-terminal) :call ToggleTerminal()<CR>
vnoremap <Plug>(toggle-terminal) :<C-u>call ToggleTerminal()<CR>
tnoremap <Plug>(toggle-terminal) <C-\><C-n>:call ToggleTerminal()<CR>
inoremap <Plug>(toggle-terminal) <Esc>:call ToggleTerminal()<CR>
