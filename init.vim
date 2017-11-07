" File: Neovim config (init.vim)
" Author: Demetris Procopiou
" Last Updated: 16/02/2017

filetype plugin indent on

" vim-plug
call plug#begin()

Plug 'vim-scripts/CmdlineComplete'
Plug 'Shougo/echodoc.vim'
Plug 'vim-syntastic/syntastic'
Plug 'vim-scripts/SearchComplete'
Plug 'vim-scripts/xoria256.vim'
Plug 'vimwiki/vimwiki'
Plug 'kien/ctrlp.vim'
Plug 'ggVGc/vim-fuzzysearch'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-expand-region'
" Plug 'neomake/neomake'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'justinmk/vim-syntax-extra'
Plug 'SirVer/ultisnips'
Plug 'skmpz/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'rhysd/clever-f.vim'
Plug 'skmpz/vim-uncrustify'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'breuckelen/vim-resize'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
    Plug 'zchee/deoplete-jedi'
else
    Plug 'Shougo/neocomplete.vim'
endif

call plug#end()

" vim sneak - move with repeating s/S
" autocmd ColorScheme * hi! link Sneak Normal
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" neomake run on write
let g:neomake_java_javac_maker = 0
let g:neomake_cpp_enabled_makers=['clang']
let g:neomake_cpp_clang_maker = {'exe' : 'clang' }
let g:neomake_cpp_clang_args = ["-std=c++14"]
" autocmd! BufWritePost * Neomake
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" syntastic
let g_syntastic_c_include_dirs = [ '/usr/lib','/usr/include', '/usr/include/pcap' ]
let g:syntastic_c_check_header = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_include_dirs = ['/home/sk/workspace/sproxy/env/include' ]
let g:syntastic_cpp_compiler_options = '-std=c++14'
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_check_header = 1

" uncrustify
autocmd FileType c noremap <buffer> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>
autocmd FileType cpp noremap <buffer> <c-f> :call Uncrustify('cpp')<CR>
autocmd FileType cpp vnoremap <buffer> <c-f> :call RangeUncrustify('cpp')<CR>

" enable cursorline
set cursorline

" disable mouse
set mouse=

" ignore stupid warning
set shortmess+=A

" colorscheme & custom colors
colorscheme xoria256
set background=dark
if has("unix")
    let s:uname = system("uname -s")
    if s:uname == ("Darwin\n")
        hi Normal ctermbg=233 ctermfg=lightblue
        hi Function ctermfg=blue
    else
        hi Normal ctermbg=233 ctermfg=blue
        hi Function ctermfg=darkblue
    endif
endif
hi VertSplit ctermbg=none
hi Split ctermbg=none
hi CursorLineNr ctermbg=233 ctermfg=6
hi LineNr ctermbg=233 ctermfg=7
hi Comment ctermfg=8
hi Pmenu ctermfg=black ctermbg=blue
hi PmenuSel ctermfg=blue ctermbg=black
hi Visual ctermfg=white ctermbg=25
hi Search ctermfg=none ctermbg=52
hi Type ctermbg=none ctermfg=146
hi SpecialKey ctermbg=none ctermfg=none
hi String ctermfg=31 ctermbg=none
hi CursorLine cterm=NONE ctermbg=16 ctermfg=none
hi MatchParen cterm=none ctermbg=none ctermfg=red
hi ColorColumn ctermbg=16
set colorcolumn=110

" stop highlight after search with backspace
inoremap <ESC> <ESC>:nohl<CR>

" visual using expand
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

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

" go substitute because the default map for sleeping is silly
nnoremap gs :s//g<Left><Left>
vnoremap gs :s//g<Left><Left>

" use arrow keys to resize windows
noremap <up>    <C-W>+
noremap <down>  <C-W>-
noremap <left>  3<C-W><
noremap <right> 3<C-W>>

" tab maps
nnoremap tn :tabnew<Space>
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>

" set space as leader key
let mapleader = "\<BackSpace>"

" leader maps
nnoremap <space>n :lnext<cr>
nnoremap <space>N :lprev<cr>
nnoremap <space>r :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>x :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>s :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>v :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>i :Tabularize /
vnoremap <space>i :'<,'>Tabularize /
nnoremap <space>e :%s/\(<c-r>=expand("<cword>")<cr>\)//g<Left><Left>
nnoremap <space>o :CtrlP<CR>
nnoremap <space>w :w<CR>
nnoremap <space>q :q<CR>
" double leader maps
nnoremap <space>d "_d
nnoremap <space>D "_D
nnoremap C "_C
inoremap <C-b> <esc>bi
inoremap <C-w> <esc>lwi
inoremap <C-e> <esc>lea
inoremap <C-a> <esc>A
inoremap <C-i> <esc>I
inoremap <C-c><C-w> <esc>lcw
inoremap <C-c><C-i><C-w> <esc>lciw
nmap     ciq ci"
nmap     cip ci(
nmap     cib ci[
nmap     cic ci{
nmap     cia ?[,?]<cr>l
nmap     cinq f"ciq
nmap     cinp f(cip
nmap     cinb f[cib
nmap     cinc f{cic

nnoremap c "_c
nnoremap x "_x
vmap     <space><space>y  "*y
nmap     <space><space>p  "*p
nmap     <space><space>p  "*p
vmap     <space><space>p  "*p
vmap     <space><space>p  "*p

" F-key maps
noremap <F11> :NERDTreeToggle<cr>
noremap <F3>  :!cd /home/sk/workspace/WI_BE_Client/ && generate_tags<cr> :cs reset<cr><cr>

" neomake - signs and colors
let g:neomake_error_sign   = { 'text': 'e> ' }
let g:neomake_warning_sign = { 'text': 'w> ' }
let g:neomake_info_sign    = { 'text': 'i> ' }
let g:neomake_message_sign = { 'text': 'm> ' }
augroup my_neomake_signs
au!
autocmd colorscheme *
    \ hi neomakeerrorsign ctermfg=white ctermbg=red |
    \ hi neomakewarningsign ctermfg=white ctermbg=black |
    \ hi neomakeinfosign ctermfg=white ctermbg=blue |
    \ hi NeoMakeMessageSign ctermfg=white ctermbg=blue
augroup END

" clever-f - ignore case
let g:clever_f_ignore_case = 1

if has('nvim')
    " deoplete - multiple options
    let g:deoplete#enable_at_startup           = 1
    let g:deoplete#auto_complete_start_length  = 1
    if has("unix")
        let s:uname = system("uname -s")
        if s:uname == "Linux\n"
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
            "let g:deoplete#sources#clang#clang_header  = '/usr/include/clang'
            let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/'
        elseif s:uname == "Darwin\n"
            let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/3.9.1/lib/libclang.dylib'
            let g:deoplete#sources#clang#clang_header  = '/usr/local/Cellar/llvm/3.9.1/include/clang'
        endif
    endif
    let g:deoplete#sources#clang#std#cpp       = 'c++11'
    let g:deoplete#sources#clang#sort_algo     = 'priority'
    set completeopt-=preview "no scratch window
else
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_complete = 1
endif

" supertab - default completion ctrl-n
let g:SuperTabDefaultCompletionType = "<C-n>"

" ultisnips - use tab key
let g:UltiSnipsExpandTrigger="`"
let g:UltiSnipsJumpForwardTrigger="`"
let g:UltiSnipsJumpBackwardTrigger="~"

" nerdtree - toggle with F12
let g:NERDTreeDirArrowExpandable  = '+' "expandable character
let g:NERDTreeDirArrowCollapsible = '~' "collapsible character
let NERDTreeIgnore                = ['\.o'] "ignore .o files
autocmd BufEnter * silent! lcd %:p:h "dir of current file

" lightline - config
let g:lightline = {
\ 'colorscheme': 'Dracula',
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
inoremap jk <esc>:nohl<CR>
inoremap ;; <esc>:nohl<CR>

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

" disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" ignore files
set wildignore+=*.o,*.swp,*.pyc,*.class,*.zip,*.gcda,*.gcno,*.html

" search improve
set ignorecase
set incsearch
set smartcase
nnoremap <F10> :set hlsearch!<CR>

" paste mode with F2
set pastetoggle=<F5>

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

if has('nvim')
    set guicursor+=a:blinkon0
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
endif

set lazyredraw

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
" onoremap an :<c-u>call <SID>NextTextObject('a')<cr>
" xnoremap an :<c-u>call <SID>NextTextObject('a')<cr>
" onoremap in :<c-u>call <SID>NextTextObject('i')<cr>
" xnoremap in :<c-u>call <SID>NextTextObject('i')<cr>
" function! s:NextTextObject(motion)
" echo
" let c = nr2char(getchar())
" exe "normal! f".c."v".a:motion.c
" endfunction

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
inoremap {{     {
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
endif

" intuitive splitting
set splitbelow        " new hoz splits go below
set splitright        " new vert splits go right

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
autocmd BufRead,BufNewFile *.todo highlight TODODONE ctermfg=34 ctermbg=none
autocmd BufRead,BufNewFile *.todo syntax match TODOSRC /^\[src\].*/
autocmd BufRead,BufNewFile *.todo syntax match TODOUTS /^\[uts\].*/
autocmd BufRead,BufNewFile *.todo syntax match TODOPTS /^\[pts\].*/
autocmd BufRead,BufNewFile *.todo syntax match TODODONE /^\[d\].*/
autocmd BufRead,BufNewFile *.todo nnoremap <leader>d I[d]<esc>ddGpgg

" Disable automatic label dedent.
" Can also be set in ~/.vim/after/ftplugin/cpp.vim
autocmd FileType cpp setlocal cinoptions+=L0;w

" grep word in file and open location list
nnoremap gl :lvim <cword> % <bar> :lopen<cr>

" remove search highlights with <Esc>
nnoremap <Esc> :nohl<cr>
inoremap <Esc> <Esc>:nohl<cr>

" move to the end of the line in insert mode
inoremap ,, <Esc>A
inoremap '' <Esc>lwi
nnoremap 0 ^

" reload cscope with <F5>
nnoremap <F5> :!cd /home/sk/workspace/WI_BE_Client/ && generate_tags<CR>:cs reset<CR><CR>

" comment/uncomment lines with <leader>c
nmap <space>c gcc
vmap <space>c gc

" move up/down the file and center
nnoremap <C-d> <C-d>zz
nnoremap <space>y : co .<left><left><left><left><left>

" go to the end of what you pasted and no overwrite
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]
xnoremap p pgvy

" easy function move
nnoremap [[ []
nnoremap ]] ][
vnoremap [[ []
vnoremap ]] ][

" leader , - save session
nnoremap <space>, :mksess! ~/.sess<CR>
let g:vim_resize_disable_auto_mappings = 1

" resize with arrows
nnoremap <silent> <left> :CmdResizeLeft<cr>
nnoremap <silent> <down> :CmdResizeDown<cr>
nnoremap <silent> <up> :CmdResizeUp<cr>
nnoremap <silent> <right> :CmdResizeRight<cr>

noremap <space>1 1gt
noremap <space>2 2gt
noremap <space>3 3gt
noremap <space>4 4gt
noremap <space>5 5gt
noremap <space>6 6gt
noremap <space>7 7gt
noremap <space>8 8gt
noremap <space>9 9gt

let g:fuzzysearch_prompt = 'fuzzy /'
let g:fuzzysearch_hlsearch = 1
let g:fuzzysearch_ignorecase = 1
let g:fuzzysearch_max_history = 30
let g:fuzzysearch_match_spaces = 0
" let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

nnoremap <space>l :CtrlPLine<CR>
nnoremap <space>f :CtrlPBufTag<CR>
nnoremap <space>b :CtrlPBuffer<CR>

noremap <F1> "a
noremap <F2> "b
noremap <F3> "c
noremap <F4> "d
nnoremap s /
nnoremap S ?

map m* *#
set noshowmode
