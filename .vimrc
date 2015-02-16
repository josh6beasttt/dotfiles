set showmode
set nu
set mouse=a
syntax on

set incsearch
set hlsearch

set cindent

" CTRL-R to reload current file
map <C-R> :source %<CR>

set clipboard=unnamed
" Copy and paste to Mac copy buffer
vmap <D-c> :w !pbcopy<CR><CR>

" Sane tab settings
set tabstop=8
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab

" Automatically line-break at 72 columns when writing git commits
autocmd Filetype gitcommit setlocal spell textwidth=72



















"fjeiwofjewiofjweofjewoi

"jwfiwejfiowejfoi
"jeiwofjweoifjwo
