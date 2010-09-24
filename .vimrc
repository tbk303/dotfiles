
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
set listchars=eol:¶,tab:»-,trail:·,extends:>,precedes:<
set list
hi NonText guifg=darkgrey ctermfg=darkgrey

set nowrap

