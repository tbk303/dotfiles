
" Automatic indenting, on new line.
set autoindent

" Use spaces instead of tabs
set expandtab

" Real tab chars for Haskell files.
autocmd FileType haskell
  \ set noexpandtab

" Tab spacing.
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Use tabs at the start of a line, spaces elsewhere
set smarttab

" Show line numbers.
set number

" Proper autocomplete when opening files
set wildmode=longest,list,full
set wildmenu

" Tabbing
map <F7> :tabp<CR>
map <F8> :tabn<CR>

" Highlight searches
set hlsearch

" Show some whitespace characters
set listchars=eol:¶,tab:▸\ ,trail:·,extends:>,precedes:<
set list

" Do not wrap long lines
set nowrap

" Some color
set t_Co=88

let g:inkpot_black_background=1
colorscheme inkpot

highlight NonText ctermfg=81 guifg=#4a4a59
highlight SpecialKey ctermfg=81 guifg=#4a4a59

" Source the vimrc file after saving it
if has("autocmd")
  autocmd BufWritePost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

