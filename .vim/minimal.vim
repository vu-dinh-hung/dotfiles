filetype plugin indent on

set mouse=a
set ttymouse=sgr
set hidden

syntax enable
set number
set ruler
set cursorline

set expandtab
set tabstop=4
set shiftwidth=4

set hlsearch
set incsearch
set ignorecase
set smartcase

set clipboard=unnamed

" Mappings
let mapleader = ' '

nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>b :ls!<cr>:b
nnoremap <leader>qq :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>h :h  \| only<left><left><left><left><left><left><left>
nnoremap <leader>tl :set number!<cr>

nnoremap ; :

vnoremap < <gv
vnoremap > >gv
