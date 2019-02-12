" File: Neovim config (init.vim)
" Author: Demetris Procopiou
" Last Updated: 02/02/2019

filetype plugin indent on

" vim-plug
call plug#begin()
Plug 'ervandew/supertab'
Plug 'vim-scripts/xoria256.vim'     " plugin_xoria256
Plug 'natebosch/vim-lsc'
Plug 'HerringtonDarkholme/vim-worksheet'
Plug 'janko-m/vim-test'
Plug 'derekwyatt/vim-scala'
Plug 'terryma/vim-expand-region'
" Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'cloudhead/neovim-fuzzy'
Plug 'rhysd/clever-f.vim'           " plugin_clever_f
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'skmpz/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'Chiel92/vim-autoformat'
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"Plug 'w0rp/ale'
call plug#end()

let g:airline#extensions#tabline#enabled = 0

" Configuration for vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

" Configuration for vim-lsc
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
             \  'scala': {
             \    'command': 'metals-vim',
             \    'log_level': 'Log'
             \  }
             \}

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
autocmd Filetype scala set softtabstop=2
autocmd Filetype scala set sw=2
autocmd Filetype scala set ts=2

" tab navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>

" use number & relativenumber
set number
set relativenumber

" clipboard
set clipboard=unnamedplus

" enable cursorline
set cursorline

" disable mouse
set mouse=

" ignore stupid warning
set shortmess+=A

silent! colorscheme xoria256
"set background=none
hi Normal ctermbg=none
hi Search ctermfg=160 ctermbg=none
hi LineNr ctermbg=none
hi NonText ctermbg=none
hi CursorLine ctermbg=0

" stop highlight after search
noremap <ESC> <ESC>:nohl<CR>

" reselect visual block after indenting
vnoremap > >gv
vnoremap < <gv

" visual select last inserted text
nnoremap gV `[V`]

" indent right after pasting
nmap p pgV=
nmap P PgV=

" move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" use arrow keys to resize windows
noremap <up>    <C-W>+
noremap <down>  <C-W>-
noremap <left>  3<C-W><
noremap <right> 3<C-W>>

" navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" map ctrl-{hjkl} to move in insert mode
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" set backspace as leader key
let mapleader = "\<space>"

" make Y behave like other capital letters
nnoremap Y y$

" comment/uncomment lines with <space>c
nmap <leader>c gcc
vmap <leader>c gc

" grep word in file and open location list
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap <leader>f :lvim <cword> * <bar> :lopen<cr>
nnoremap <leader>j <C-]>
nnoremap <leader>n :cnext<CR>
nnoremap <leader>N :cprev<CR>
nnoremap <leader>o :FZF<CR>
nnoremap <leader>g :LSClientGoToDefinition<CR>
nnoremap <leader>x :LSClientGoToDefinitionSplit<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>t :call fzf#vim#tags("'".expand('<cword>'))<cr>
nnoremap <leader>w :w<CR>
nnoremap <leader>, :mks! ~/.sess<cr>
nnoremap s /
nnoremap S ?
noremap  <F1> "a
noremap  <F2> "b
noremap  <F3> "c
noremap  <F4> "d
set pastetoggle=<F8>

" search improve
set ignorecase
set incsearch
set smartcase

" call neomake#configure#automake('w')
" au BufWritePost *.scala Neomake! sbt
"let g:neomake_open_list = 2

let g:neomake_warning_sign = {
            \ 'text': 'W',
            \ 'texthl': 'WarningMsg',
            \ }
let g:neomake_error_sign = {
            \ 'text': 'E',
            \ 'texthl': 'ErrorMsg',
            \ }

" revert command-findnext mappings
nno ; :
nno : ,
nno , ;
vno : ;
vno ; :

" deoplete
let g:deoplete#auto_complete_delay         = 0
let g:deoplete#enable_at_startup           = 1
let g:deoplete#auto_complete_start_length  = 3
let g:deoplete#sources={}
let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
let g:deoplete#omni#input_patterns={}
let g:deoplete#omni#input_patterns.scala=['[^. *\t0-9]\.\w*',': [A-Z]\w', '[\[\t\( ][A-Za-z]\w*']
if has("unix")
    let s:uname = system("uname -s")
    if s:uname == "Linux\n"
        let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
        let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/'
    elseif s:uname == "FreeBSD\n"
        let g:deoplete#sources#clang#libclang_path = '/usr/local/llvm50/lib/libclang.so'
        let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/'
    elseif s:uname == "Darwin\n"
        let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/3.
        9.1/lib/libclang.dylib'
        let g:deoplete#sources#clang#clang_header  = '/usr/local/Cellar/llvm/3.
        9.1/include/clang'
    endif
endif
let g:deoplete#sources#clang#std#cpp       = 'c++11'
let g:deoplete#sources#clang#sort_algo     = 'priority'
let g:deoplete#sources={}
let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
let g:deoplete#omni#input_patterns={}
let g:deoplete#omni#input_patterns.scala='[^. *\t]\.\w*\|: [A-Z]\w*'
set completeopt-=preview "no scratch window

" supertab
let g:SuperTabDefaultCompletionType = "<C-n>"

" plugin_clever_f
let g:clever_f_ignore_case = 1

" go to the end of what copied/pasted and no overwrite
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
xnoremap p pgvy

" easy function move
nnoremap [[ []
nnoremap ]] ][
vnoremap [[ []
vnoremap ]] ][

" gitgutter - update signs on write
autocmd BufWritePost * GitGutter

" nerdtree
nnoremap <F12> :NERDTreeToggle<CR>

" show trailing
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

hi GitGutterAdd ctermbg=none ctermfg=green
hi GitGutterChange ctermbg=none ctermfg=gray
hi GitGutterDelete ctermbg=none ctermfg=red

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_left_alt_sep = '»'
let g:airline_right_alt_sep = '«'
let g:airline_symbols.paste = 'PASTE'
let g:airline_symbols.linenr = 'Ξ'
let g:airline_symbols.branch = '»'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.space = ' '
let g:airline_symbols.modified = '+'
let g:airline_symbols.readonly = 'READONLY'
let g:airline_symbols.maxlinenr = ''

nnoremap <leader>y "*y
vnoremap <leader>y "*y

" let g:lsc_auto_map = { 'GoToDefinition': 'gd' }

let g:fuzzy_bindkeys = 1
