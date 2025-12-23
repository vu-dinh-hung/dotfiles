filetype plugin indent on

set mouse=a
set ttymouse=sgr

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
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>b :ls<cr>:b

nnoremap ; :

vnoremap < <gv
vnoremap > >gv
