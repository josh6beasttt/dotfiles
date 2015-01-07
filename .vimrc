set showmode
set nu
set mouse=a
syntax on

set incsearch
set hlsearch

set cindent

" CTRL-H to get vim help on current word
map <C-H> :h <C-R><C-W><CR>

" CTRL-R to reload current file
map <C-R> :source %<CR>

" Copy and paste to Mac copy buffer
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <F2> :.w !pbcopy<CR><CR>
vmap <F2> :w !pbcopy<CR><CR>

" Sane tab settings
set tabstop=8
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
