syntax on

set showmode
set nu
set mouse=a

" Show matching brackets
set showmatch

" Always show location in file (line #)
set ruler

" Relative line-numbers
set number

" Ignore case in searches
set ignorecase
" Searches update as you type, not just after pressing enter
set incsearch
" Highlights matches as you search
set hlsearch

set clipboard=unnamed
" Copy and paste to Mac copy buffer
vmap <D-c> :w !pbcopy<CR><CR>

" Sane tab settings
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

" Automatically line-break at 72 columns when writing git commits
autocmd Filetype gitcommit setlocal spell textwidth=72

command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

