
" Automatic indenting, on new line.
set autoindent

" Use spaces instead of tabs
set expandtab

" Real tab chars for Haskell files.
"autocmd FileType haskell
"  \ set noexpandtab

if has('autocmd')
  au BufEnter *.hamlet setlocal filetype=hamlet
  au BufEnter *.cassius setlocal filetype=cassius
  au BufEnter *.julius setlocal filetype=julius
  au BufEnter *.prawn setlocal filetype=ruby
endif

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

imap <F7> <ESC>:tabp<CR>
imap <F8> <ESC>:tabn<CR>

" Explorer
map <F9> :Te<CR>

" Highlight searches
set hlsearch

" Show some whitespace characters
set listchars=eol:¶,tab:▸\ ,trail:·,extends:>,precedes:<
set list

" Do not wrap long lines
set nowrap

highlight NonText ctermfg=240 guifg=#4a4a59
highlight SpecialKey ctermfg=240 guifg=#4a4a59

" Source the vimrc file after saving it
if has("autocmd")
  autocmd BufWritePost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

" Smart home key
function! SmartHome()
  let s:col = col(".")
  normal! ^
  if s:col == col(".")
    normal! 0
  endif
endfunction
nnoremap <silent> <Home> :call SmartHome()<CR>
inoremap <silent> <Home> <C-O>:call SmartHome()<CR>

" hexmode
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" Always load local vimrc (yes, I know, this is a security issue)
let g:localvimrc_ask=0

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

set runtimepath^=~/.vim/bundle/ctrlp.vim

" Sane Ignore For ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|vagrant)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager = 0

" Multi cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-m>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Line numbers
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>

execute pathogen#infect()

" Some color
" set t_Co=256

let g:inkpot_black_background=1
colorscheme inkpot
"set background=dark
"colorscheme solarized

