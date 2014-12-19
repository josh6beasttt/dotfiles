" Vundle requirements
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'


call vundle#end()
filetype plugin indent on


set showmode
set nu
set mouse=a
syntax on
set shiftwidth=2
set softtabstop=2
set incsearch
set hlsearch

" CTRL-H to get vim help on current word
map <C-H> :h <C-R><C-W><CR>

" CTRL-R to reload current file
map <C-R> :source %<CR>

