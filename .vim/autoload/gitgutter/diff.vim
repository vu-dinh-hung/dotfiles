" This overrides gitgutter's hunk processing to merge adjacent `added` and
" `modified` lines into the same `modified` hunk.
"
" Without this, a modified line right after a new blank line showing up as
" added.
"
" Shadows gitgutter's diff.vim (~/.vim precedes packages in runtimepath). This
" path is needed due to Vim's E746.

let s:self = resolve(expand('<sfile>:p'))
let s:real = filter(
\   globpath(&runtimepath, 'autoload/gitgutter/diff.vim', 0, 1),
\   {_, path -> resolve(fnamemodify(path, ':p')) isnot# s:self})

if empty(s:real)
    finish
endif

execute 'source' fnameescape(s:real[0])

let s:OriginalProcessHunks = funcref('gitgutter#diff#process_hunks')

" Turns `added` lines adjacent to `modified` lines to `modified`
function! gitgutter#diff#process_hunks(bufnr, hunks) abort
    " List of [line number, line change type e.g. 'added', 'modified', 'removed']
    let l:lines = s:OriginalProcessHunks(a:bufnr, a:hunks)

    let l:prev_line = [-99, ''] " -99 is not a real line
    for l:line in l:lines
        if l:line[1] is# 'added' && l:prev_line == [l:line[0] - 1, 'modified']
            let l:line[1] = 'modified'
        endif

        let l:prev_line = l:line
    endfor

    return l:lines
endfunction
