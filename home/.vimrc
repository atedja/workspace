" Install pathogen
execute pathogen#infect()

let g:netrw_liststyle=3

" Set ESC delay to 0
set timeoutlen=1000 ttimeoutlen=0

" Enter will move the line down
nnoremap <cr> i<cr><esc>

" Set Ctrl-I to toggle word
nnoremap <c-i> gUiw

" Set syntax highlighting
syntax enable
set background=dark

" Set no horizontal wrapping
set nowrap

" This will search as you type
set incsearch

" This will highlight searched texts
set hlsearch

" This will set line number
set number

" This will show filename
set ls=2

" This will set case insensitive by default, unless upper-case is specified or overridden with a \c
set ignorecase
set smartcase

" This will use spaces instead of tabs
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype python setlocal ts=4 sts=4 sw=4 expandtab

" This will insert/uninsert Tab on selected text
vnoremap <tab> >gv
vnoremap <s-tab> <gv
nnoremap <tab> v>
nnoremap <s-tab> v<

" Autoindent
set autoindent

" git grep from vim
nnoremap <silent> <leader>a :!git grep -nw --color <cword><cr>

" clear highlights
nnoremap <silent> <leader>c :noh<cr>

" Search in new window
function SearchAll(word, case_sensitive)
  if a:case_sensitive
    execute "Ack " . a:word
  else
    execute "Ack " . a:word
  end
  copen
endfunction

nnoremap <Leader>f :call SearchAll(expand("<cword>"), 0)<CR>
nnoremap <Leader>F :call SearchAll(expand("<cword>"), 1)<CR>

" Draw line at column 80
" set colorcolumn=80
" highlight ColorColumn ctermbg=41 guifg=#00d75f

" Shortcut to map Ctrl+L Ctrl+H and Ctrl+N to tabs
map <C-l> :tabn<cr>
map <C-h> :tabp<cr>
map <C-n> :tabnew<cr>

" Shortcut Ctrl+Space to Ctrl+N in input mode for autocomplete
inoremap <C-@> <C-n>

" Map CTAGS command
noremap <silent> <leader>t :!ctags -R --exclude=.git --exclude=.bundle<cr>

" Ctags mapping to show a window when there are more than one match
nnoremap <C-]> g<C-]>
vnoremap <C-]> g<C-]>
nnoremap g<C-]> <C-]>
vnoremap g<C-]> <C-]>

" Map $ to ; for end of line.
noremap ; $

" Smooth Scrolling
function SmoothScroll(up)
  if a:up
    let scrollaction=""
  else
    let scrollaction=""
  endif
  exec "normal " . scrollaction
  redraw
  let counter=1
  while counter<&scroll
    let counter+=1
    sleep 5m
    redraw
    exec "normal " . scrollaction
  endwhile
endfunction

nnoremap <C-k> :call SmoothScroll(1)<Enter>
nnoremap <C-j> :call SmoothScroll(0)<Enter>
inoremap <C-k> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <C-j> <Esc>:call SmoothScroll(0)<Enter>i

" Pasting default from register 0, just like yank
nnoremap <expr> p (v:register ==# '"' ? '"0' : '') . 'p'
nnoremap <expr> P (v:register ==# '"' ? '"0' : '') . 'P'
xnoremap <expr> p (v:register ==# '"' ? '"0' : '') . 'p'
xnoremap <expr> P (v:register ==# '"' ? '"0' : '') . 'P'

" X is for cutting, so we also want it to go to register 0
nnoremap <expr> x (v:register ==# '"' ? '"0' : '') . 'x'
nnoremap <expr> X (v:register ==# '"' ? '"0' : '') . 'X'
xnoremap <expr> x (v:register ==# '"' ? '"0' : '') . 'x'
xnoremap <expr> X (v:register ==# '"' ? '"0' : '') . 'X'

" Search selected text in VISUAL mode by pressing *
vnoremap <silent> * :<c-u>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<c-r><c-r>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<cr><cr>
  \gV:call setreg('"', old_reg, old_regtype)<cr>

" Reload all files from disk, discarding unsaved changes
function Reload()
  set noconfirm
  bufdo e!
  set confirm
  echo "Files are reloaded"
endfun

noremap <leader>l :call Reload()<Enter>

" Use Leader g to map using git grep and search
set grepprg=git\ grep\ $*

function! GitGrep(...)
  let s = 'silent! grep!'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  botright copen
  exe "redraw!"
endfun
command! -complete=file -nargs=+ G call GitGrep(<f-args>)

nnoremap <leader>g :call GitGrep('-w -e', expand("<cword>"))<cr>
vnoremap <leader>g "gy:call GitGrep('-e', shellescape(@g))<cr>

filetype indent on

" Enable snipmate
filetype plugin on

" Using a different color scheme on vimdiff
if &diff
  colorscheme pablo
endif

" Leader s is to shell out
noremap <leader>s :sh<cr>

" Ctrl Y to copy to system clipboard
vnoremap <C-y> "+y

" Ctrl P to paste from system clipboard
noremap <C-p> "+p

" Leader r to repeat the current character
nnoremap <leader>r ylp

" Mark all text beyond 80 characters
nnoremap <leader>] /\%>80v.\+<cr>

" Surround word with a char
" nnoremap <leader>r" i"<esc>ea"<esc>
" nnoremap <leader>r' i'<esc>ea'<esc>
" nnoremap <leader>r< i<<esc>ea><esc>
" nnoremap <leader>r( i(<esc>ea)<esc>
" nnoremap <leader>r{ i{<esc>ea}<esc>
vnoremap <leader>r" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>r' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>r< <esc>`>a><esc>`<i<<esc>
vnoremap <leader>r( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>r{ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>r[ <esc>`>a]<esc>`<i[<esc>
