" File: Neovim config (init.vim)
" Author: Demetris Procopiou
" Last Updated: 24/01/2017

filetype plugin indent on

" vim-plug
call plug#begin()
Plug 'vim-scripts/xoria256.vim'
Plug 'kien/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdcommenter'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
    Plug 'zchee/deoplete-jedi'
else
    Plug 'Shougo/neocomplete.vim'
endif
Plug 'tacahiroy/ctrlp-funky'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'justinmk/vim-syntax-extra'
Plug 'SirVer/ultisnips'
Plug 'skmpz/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'rhysd/clever-f.vim'
call plug#end()

nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gu :Gpull<cr>

" syntastic - options
let g:syntastic_always_populate_loc_list = 1
nnoremap <leader>n :lnext<CR>
nnoremap <leader>N :lprev<CR>

" clever-f - ignore case
let g:clever_f_ignore_case = 1

" deoplete - multiple options
let g:deoplete#enable_at_startup           = 1
let g:deoplete#auto_complete_start_length  = 1
"let g:deoplete#disable_auto_complete       = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header  = '/usr/include/clang'
let g:deoplete#sources#clang#std#cpp       = 'c++11'
let g:deoplete#sources#clang#sort_algo     = 'priority'
set completeopt-=preview "no scratch window

" supertab - default completion ctrl-n
let g:SuperTabDefaultCompletionType = "<C-n>"

" ultisnips - use tab key
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" nerdtree - toggle with F12
let g:NERDTreeDirArrowExpandable  = '+' "expandable character
let g:NERDTreeDirArrowCollapsible = '~' "collapsible character
let NERDTreeIgnore                = ['\.o'] "ignore .o files
noremap <F11> :NERDTreeToggle<CR>
nnoremap <leader>r :NERDTreeFind<CR>
autocmd BufEnter * silent! lcd %:p:h "dir of current file

" lightline - config
let g:lightline = {
\ 'colorscheme': 'PaperColor',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
\ },
\ 'component': {
\   'readonly': '%{&filetype=="help"?"":&readonly?"READONLY":""}',
\   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
\   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
\ },
\ 'component_visible_condition': {
\   'readonly': '(&filetype!="help"&& &readonly)',
\   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
\   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
\ },
\ }

" new line above/below and back in normal mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

" delete without yanking
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <Leader>C "_C
nnoremap <Leader>c "_c
nnoremap <Leader>x "_x

" ctrlpfunky - open with leader f
nnoremap <leader>f :CtrlPFunky<Cr>

" colorscheme & custom colors
colorscheme xoria256
set background=dark
hi Normal ctermbg=233 ctermfg=blue
hi VertSplit ctermbg=none
hi Split ctermbg=none
hi CursorLineNr ctermbg=233 ctermfg=6
hi LineNr ctermbg=233 ctermfg=7
hi Function ctermfg=darkblue
hi Comment ctermfg=8
hi Pmenu ctermfg=black ctermbg=blue
hi PmenuSel ctermfg=blue ctermbg=black
hi Visual ctermfg=232 ctermbg=96
hi Type ctermbg=none ctermfg=146
hi SpecialKey ctermbg=none ctermfg=none
hi String ctermfg=31 ctermbg=none
hi CursorLine cterm=NONE ctermbg=16 ctermfg=none

" enable cursorline
set cursorline

" disable mouse
set mouse=

" disable arrow keys
nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

" move up/down one line (include wraps)
nnoremap j gj
nnoremap k gk

" insert mode to normal mode maps
inoremap jk <esc>
inoremap kj <esc>
inoremap ;; <esc>

" use number & relativenumber
set number
set relativenumber

" clipboard
set clipboard=unnamedplus

" revert command-findnext mappings
nno ; :
nno : ,
nno , ;
vno : ;
vno ; :

" use space for leader key
nmap <space> /
vmap <space> /
nmap <bs> <leader>
vmap <bs> <leader>

" no overwrite when pasting
xnoremap p pgvy

" reselect visual block after indenting
vnoremap > >gv
vnoremap < <gv

" disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" ignore files
set wildignore+=*.o,*.swp,*.pyc,*.class,*.zip

" search improve
set ignorecase
set incsearch
set smartcase
set nohlsearch
nnoremap <F10> :set hlsearch!<CR>

" paste mode with F2
set pastetoggle=<F2>

let g:bookmark_sign = '→'
function! LoadCscope()
let db = findfile("cscope.out", ".;")
if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
endif
endfunction
au BufEnter /* call LoadCscope()

" change cursor in each mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[3 q"
let &t_EI = "\<esc>[2 q"

" overlength highlight
highlight OverLength ctermbg=red ctermfg=white
match OverLength /\%110v.\+/

" watch for file changes
set autoread

" tags path
set tags=tags;/

" backspace
set backspace=indent,eol,start
set backspace=2

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" motion for "next object". For example, "din(" would
" go to the next "()" pair and delete its contents.
onoremap an :<c-u>call <SID>NextTextObject('a')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i')<cr>
function! s:NextTextObject(motion)
echo
let c = nr2char(getchar())
exe "normal! f".c."v".a:motion.c
endfunction

" print hidden characters
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" auto end bracket
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {      {
inoremap {}     {}

" cscope load & maps
if has("cscope")
set cscopetag
set csto=0
if filereadable("cscope.out")
    cs add cscope.out
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
set cscopeverbose
nnoremap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>g    :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>t    :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>e    :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>f    :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>i    :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-\>d    :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" intuitive splitting
set splitbelow        " new hoz splits go below
set splitright        " new vert splits go right

" map ctrl-s to ctrl-b
nmap <C-s> <C-b>

" tabularize - use with <leader>t
nnoremap <leader>t :Tabularize /
vnoremap <leader>t :'<,'>Tabularize /

" use arrow keys to resize windows
noremap <up>    <C-W>+
noremap <down>  <C-W>-
noremap <left>  3<C-W><
noremap <right> 3<C-W>>

" tab maps
nnoremap tn :tabnew<Space>
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>

" map ctrl-{hjkl} to move in insert mode
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>

" make Y behave like other capital letters
nnoremap Y y$

" custom .todo filetype with syntax highlighting
autocmd BufRead,BufNewFile *.todo set filetype=todo
autocmd BufRead,BufNewFile *.todo highlight TODOSRC ctermfg=12 ctermbg=none
autocmd BufRead,BufNewFile *.todo highlight TODOUTS ctermfg=26 ctermbg=none
autocmd BufRead,BufNewFile *.todo highlight TODOPTS ctermfg=13 ctermbg=none
autocmd BufRead,BufNewFile *.todo syntax match TODOSRC /^\[src\].*/
autocmd BufRead,BufNewFile *.todo syntax match TODOUTS /^\[uts\].*/
autocmd BufRead,BufNewFile *.todo syntax match TODOPTS /^\[pts\].*/

" visual select last inserted text
nnoremap gV `[V`]

" indent right after pasting
nmap p pgV=

" move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" go substitute because the default map for sleeping is silly
nnoremap gs :s//g<Left><Left>
vnoremap gs :s//g<Left><Left>

nnoremap <F5> :!cd /home/sk/workspace/WI_BE_Client/ && generate_tags<CR>:cs reset<CR><CR>

" Disable automatic label dedent.
" Can also be set in ~/.vim/after/ftplugin/cpp.vim
autocmd FileType cpp setlocal cinoptions+=L0;w

" grep word in file and open location list
nnoremap gl :lvim <cword> % <bar> :lopen<cr>
nmap gcc <leader>cc
nmap gcu <leader>cu

nmap <tab> ?
set shortmess+=A
nnoremap [[ []
nnoremap ]] ][
