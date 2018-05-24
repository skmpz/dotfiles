" File: Neovim config (init.vim)
" Author: Demetris Procopiou
" Last Updated: 14/11/2017

filetype plugin indent on
set nocompatible
" set hidden

" vim-plug
call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'gcmt/taboo.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/xoria256.vim'     " plugin_xoria256
Plug 'kien/ctrlp.vim'               " plugin_ctrlp
Plug 'Shougo/echodoc.vim'           " plugin_echodoc
Plug 'scrooloose/nerdtree'          " plugin_nerdtree
Plug 'terryma/vim-expand-region'    " plugin_expand_region
Plug 'w0rp/ale'                     " plugin_ale
Plug 'MattesGroeger/vim-bookmarks'  " plugin_vim_bookmarks
Plug 'rhysd/clever-f.vim'           " plugin_clever_f
Plug 'skmpz/vim-uncrustify'         " plugin_uncrustify
if has('nvim')
    Plug 'Shougo/deoplete.nvim',    " plugin_deoplete
                \{ 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-clang'
    Plug 'zchee/deoplete-jedi'
else
    Plug 'Shougo/neocomplete.vim'   " plugin_neocomplete
endif
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-syntax-extra'
Plug 'SirVer/ultisnips'
Plug 'skmpz/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'breuckelen/vim-resize'
call plug#end()
let g:gitgutter_max_signs = 500
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ]

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

" colorscheme & custom colors [plugin_xoria256]
" silent! colorscheme xoria256
set background=dark
if has("unix")
    let s:uname = system("uname -s")
    if s:uname == ("Darwin\n")
        hi Normal ctermbg=233 ctermfg=lightblue
        hi Function ctermfg=blue
    else
        hi Normal ctermbg=54 ctermfg=blue
        hi Function ctermfg=darkblue
    endif
endif

" stop highlight after search
inoremap <ESC> <ESC>:nohl<CR>

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
nnoremap bh :bprev<CR>
nnoremap bl :bnext<CR>

" set backspace as leader key
let mapleader = "<BackSpace>"

" custom maps
nmap     <space>n <Plug>(ale_next_wrap)
nmap     <space>N <Plug>(ale_previous_wrap)
nnoremap <space>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>r :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>x :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>sg :scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>sr :scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>v :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <space>i :Tabularize /
vnoremap <space>i :'<,'>Tabularize /
nnoremap <space>u :GitGutterUndoHunk<cr>
nnoremap <space>e :%s/\(<c-r>=expand("<cword>")<cr>\)//g<Left><Left>
nnoremap <space>o :CtrlP<CR>
nnoremap <space>w :w<CR>
nnoremap <space>q :q<CR>
nnoremap <space>d "_d
nnoremap <space>D "_D
nmap     ciq ci"
nmap     cip ci(
nmap     cib ci[
nmap     cic ci{
nmap     cia ?[,?]<cr>l
nmap     cinq f"ciq
nmap     cinp f(cip
nmap     cinb f[cib
nmap     cinc f{cic
nnoremap C "_C
nnoremap c "_c
nnoremap x "_x
noremap  <F1> "a
noremap  <F2> "b
noremap  <F3> "c
noremap  <F4> "d
noremap  <F5>  :!cd /home/sk/workspace/WI_BE_Client/ && generate_tags<cr>:cs reset<cr><cr>
noremap  <F11> :NERDTreeToggle<cr>
nnoremap <F10> :set hlsearch!<CR>
set pastetoggle=<F8>
nnoremap s /
nnoremap S ?
map m* #*
nnoremap <space>, :mks! ~/.sess<cr>
set noshowmode

" print hidden characters
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" move up/down one line (include wraps)
nnoremap j gj
nnoremap k gk

" insert mode to normal mode maps
inoremap jk <esc>:nohl<CR>
inoremap ;; <esc>:nohl<CR>

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

" comment/uncomment lines with <space>c
nmap <space>c gcc
vmap <space>c gc

" copy line(s)
nnoremap <space>y : co .<left><left><left><left><left>

" navigation between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" terminal navigation
tnoremap <Esc> <C-\><C-n>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" lazy redraw
set lazyredraw

" watch for file changes
set autoread

" tags path
set tags=tags;/

" backspace
set backspace=indent,eol,start
set backspace=2

" auto end bracket
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" map ctrl-{hjkl} to move in insert mode
inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>

" make Y behave like other capital letters
nnoremap Y y$

" Disable automatic label dedent.
autocmd FileType cpp setlocal cinoptions+=L0;w

" grep word in file and open location list
nnoremap gl :lvim <cword> % <bar> :lopen<cr>

" remove search highlights with <Esc>
nnoremap <Esc> :nohl<cr>
inoremap <Esc> <Esc>:nohl<cr>

" intuitive splitting
set splitbelow
set splitright

" move to tabs
noremap <space>1 1gt
noremap <space>2 2gt
noremap <space>3 3gt
noremap <space>4 4gt
noremap <space>5 5gt
noremap <space>6 6gt
noremap <space>7 7gt
noremap <space>8 8gt
noremap <space>9 9gt

" load cscope
function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose
        exe "cs add " . db . " " . path
        set cscopeverbose
    endif
endfunction
au BufEnter /* call LoadCscope()

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

" plugin_expand_region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" plugin_nerdtree
let g:NERDTreeDirArrowExpandable  = '+'     "expandable character
let g:NERDTreeDirArrowCollapsible = '~'     "collapsible character
let NERDTreeIgnore = ['\.o']                "ignore .o files
autocmd BufEnter * silent! lcd %:p:h        "dir of current file

" plugin_clever_f
let g:clever_f_ignore_case = 1

" plugin_deoplete
if has('nvim')
    let g:deoplete#enable_at_startup           = 1
    let g:deoplete#auto_complete_start_length  = 1
    if has("unix")
        let s:uname = system("uname -s")
        if s:uname == "Linux\n"
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
            "let g:deoplete#sources#clang#clang_header  = '/usr/include/clang'
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
    set completeopt-=preview "no scratch window
else
" plugin_neocomplete
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_complete = 1
endif

" plugin_supertab
let g:SuperTabDefaultCompletionType = "<C-n>"

" plugin_ultisnips
let g:UltiSnipsExpandTrigger="`"
let g:UltiSnipsJumpForwardTrigger="`"
let g:UltiSnipsJumpBackwardTrigger="~"

" plugin_ale
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_lint_on_text_changed = 'never'
let g:ale_c_gcc_options = '-Wall -std=gnu89'
" let g:ale_cpp_gcc_options = '-lstdc++'
let g:ale_linters = { 'c': ['gcc', 'clangtidy'], 'cpp': ['g++', 'cppcheck', 'clangtidy'] }
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_c_clangtidy_checks = [ '*' , '-google-readability-braces-around-statements',
            \'-readability-braces-around-statements', '-readability-named-parameter',
            \'-readability-else-after-return', '-google-readability-function-size',
            \'-readability-function-size', '-android-cloexec-open',
            \'-cert-env33-c', '-android-cloexec-fopen',
            \'-clang-diagnostic-address-of-packed-member',
            \'-llvm-header-guard', '-hicpp-braces-around-statements']
" let g:ale_cpp_clangtidy_header_suffixes = ['h', 'hpp', 'hxx', 'tcc']

" plugin_uncrustify
autocmd FileType c noremap <buffer> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>
autocmd FileType cpp noremap <buffer> <c-f> :call Uncrustify('cpp')<CR>
autocmd FileType cpp vnoremap <buffer> <c-f> :call RangeUncrustify('cpp')<CR>

" plugin_vim_bookmarks
let g:bookmark_sign = '→'

" plugin_vim_resize
let g:vim_resize_disable_auto_mappings = 1
nnoremap <silent> <left> :CmdResizeLeft<cr>
nnoremap <silent> <down> :CmdResizeDown<cr>
nnoremap <silent> <up> :CmdResizeUp<cr>
nnoremap <silent> <right> :CmdResizeRight<cr>

" plugin_ctrlp
nnoremap <space>l :CtrlPLine<CR>
nnoremap <space>f :CtrlPBufTag<CR>
nnoremap <space>b :CtrlPBuffer<CR>
nnoremap <space>m :CtrlPMRUFiles<CR>

" plugin_echodoc
let g:echodoc#enable_at_startup = 1

" plugin_indentline
let g:indentLine_color_dark = 1
let g:indentLine_color_term = 239
nnoremap <C-h> :e %:r.h<CR>
nnoremap <C-s> :e %:r.cc<CR>

hi TabLine      ctermfg=16  ctermbg=DarkBlue  cterm=NONE
hi TabLineFill  ctermfg=16  ctermbg=DarkBlue  cterm=NONE
hi TabLineSel   ctermfg=LightBlue ctermbg=16  cterm=NONE

set background=dark
hi Normal ctermbg=none
hi VertSplit ctermbg=none
hi Split ctermbg=none ctermfg=none
hi CursorLineNr ctermbg=none ctermfg=6
hi LineNr ctermbg=none ctermfg=7
hi Comment ctermfg=8
hi Pmenu ctermfg=16 ctermbg=blue
hi PmenuSel ctermfg=blue ctermbg=black
hi Visual ctermfg=white ctermbg=25
" hi Search ctermfg=none ctermbg=52
" hi Type ctermbg=none ctermfg=146
" hi SpecialKey ctermbg=8 ctermfg=8
hi Special ctermbg=none ctermfg=243
" hi String ctermfg=31 ctermbg=none
hi CursorLine cterm=NONE ctermbg=none ctermfg=none
hi MatchParen cterm=none ctermbg=none ctermfg=127
" hi ColorColumn ctermbg=16
" set colorcolumn=110
hi StatusLine ctermbg=237
hi CursorLine ctermbg=235

let g:taboo_tab_format = " %N:[%f]%m "
let g:taboo_modified_tab_flag = "[+]"

let g:lightline = {
      \ 'papercolor': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
let g:lightline.active = { 'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
            \    [ 'lineinfo' ],
            \    [ 'percent' ],
            \    [ 'fileformat', 'fileencoding', 'filetype' ] ] }

inoremap <C-a> <Esc>A
nnoremap 0 ^
" nnoremap <Tab> :tablast<cr>
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <Tab> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <Tab> :exe "tabn ".g:lasttab<cr>
inoremap <C-a> <Esc>A
inoremap <C-i> <Esc>I
highlight ALEWarningSign ctermbg=none ctermfg=94
highlight ALEWarning ctermbg=none ctermfg=94
