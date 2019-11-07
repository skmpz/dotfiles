" File: Neovim config (init.vim)
" Author: Demetris Procopiou
" Last Updated: 02/02/2019

filetype plugin indent on

" vim-plug
call plug#begin()
Plug 'ervandew/supertab'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'vim-scripts/xoria256.vim'     " plugin_xoria256
Plug 'aserebryakov/vim-todo-lists.git'
Plug 'Shougo/echodoc.vim'
Plug 'janko-m/vim-test'
Plug 'aserebryakov/vim-todo-lists'
Plug 'derekwyatt/vim-scala'
Plug 'terryma/vim-expand-region'
Plug 'rust-lang/rust.vim'
" Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'rhysd/clever-f.vim'           " plugin_clever_f
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips'
Plug 'skmpz/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'w0rp/ale'
call plug#end()

highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = 'M'
let g:bookmark_highlight_lines = 1

" enable echodoc
let g:echodoc_enable_at_startup = 1

autocmd FileType c setlocal omnifunc=LanguageClient#complete

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:VimTodoListsDatesEnabled = 1
let g:VimTodoListsDatesFormat = "%a %b, %Y"

let g:UltiSnipsExpandTrigger="`"
let g:UltiSnipsJumpForwardTrigger="`"

" let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
            \ 'cpp': ['clangtidy', 'cppcheck', 'cpplint'],
            \ 'c': ['clangtidy', 'gcc']
            \ }

let g:ale_fixers = {
            \ 'cpp': ['uncrustify'],
            \ 'c': ['uncrustify'],
            \ 'rust': ['rustfmt']
            \ }
" let g:ale_c_gcc_options='-Wall -Wextra'
let g:ale_lint_on_save = 1

let g:ale_cpp_cquery_executable = "/Users/sk/dotfiles/cquery/build/release/bin/cquery"
let g:ale_cpp_cpplint_options= "--filter=-legal/copyright,-build/c++11,-build/include_subdir,-build/include_order --linelength=110"
let g:ale_cpp_clangtidy_checks = ['*', '-android-cloexec-accept', '-android-cloexec-fopen'. '-hicpp-signed-bitwise', '-clang-diagnostic-pointer-sign', '-fuchsia-default-arguments', '-cppcoreguidelines-owning-memory', '-cppcoreguidelines-pro-bounds-array-to-pointer-decay', '-cppcoreguidelines-pro-bounds-pointer-arithmetic']
let g:ale_cpp_gcc_options = '-std=c++11 -Wall'

let g:ale_c_parse_compile_commands = 1
let g:ale_c_cquery_executable = "/Users/sk/dotfiles/cquery/build/release/bin/cquery"
let g:ale_c_clangtidy_checks = ['*', '-android-cloexec-accept', '-android-cloexec-fopen', '-hicpp-signed-bitwise', '-clang-diagnostic-pointer-sign']
let g:ale_c_cppcheck_options = '--enable=all'
let g:ale_c_gcc_options= "-std=gnu99 -Wall"
let g:ale_c_uncrustify_options = '-c /Users/sk/dotfiles/default.cfg'

" let g:ale_fix_on_save = 1
" let g:ale_max_signs = 20

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

let g:VimTodoListsDatesEnabled = 1
let g:VimTodoListsDatesFormat = "%d|%m|%Y"

" LanguageClient config
" let g:LanguageClient_useVirtualText = 0 " do not show error in line
" let g:LanguageClient_useFloatingHover = 1 "opens documentation in a floating window instead of preview
" let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
" " let g:LanguageClient_settingsPath = '/home/sk/.config/nvim/settings.json'
" let g:LanguageClient_serverCommands = {
"     \ 'cpp': ['/home/sk/dotfiles/cquery/build/release/bin/cquery',
"         \'--log-file=/tmp/cq-cpp.log', 
"         \'--init={"cacheDirectory":"/tmp/cq-cpp.cache/"}'],
"     \ 'c': ['/home/sk/dotfiles/cquery/build/release/bin/cquery', 
"         \'--log-file=/tmp/cq-c.log',
"         \'--init={"cacheDirectory":"/tmp/cq-c.cache/"}'],
"     \ 'python': ['/home/sk/.local/bin/pyls', '--log-file=/tmp/py.log'],
"     \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
"     \ }


nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" set completefunc=LanguageClient#complete
set formatexpr=LanguageClient_textDocument_rangeFormatting()
let g:LanguageClient_rootMarkers = {
\ 'cpp': ['compile_commands.json', 'build'],
\ }

"call LanguageClient#textDocument_definition({'gotoCmd': 'split'})

" preview function on completion
set cot-=preview

" language server bindings
" nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
" nnoremap <silent> gs :call LanguageClient#textDocument_documentSymbol()<CR>
" nnoremap <silent> gm :call LanguageClient#textDocument_rename()<CR>
" nnoremap <silent> gf :call LanguageClient#textDocument_formatting()<CR>

let g:airline#extensions#tabline#enabled = 0

" Configuration for vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

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
hi MatchParen cterm=none ctermbg=green ctermfg=blue

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

let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1

" grep word in file and open location list
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap c "_c
nnoremap C "_C
nnoremap <leader>j :A<CR>
nnoremap <leader>f :IH<CR>
nnoremap <leader>g :lvim <cword> * <bar> :lopen<cr>
nnoremap <leader>n :cnext<CR>
nnoremap <leader>N :cprev<CR>
nnoremap <leader>o :FZF<CR>
nnoremap <leader>q :q<CR>
" nnoremap s /
" nnoremap S ?
nnoremap <leader>t :call fzf#vim#tags("'".expand('<cword>'))<cr>
nnoremap <leader>w :w<CR>
nnoremap <leader>, :mks! ~/.sess<cr>
noremap  <F1> "a
noremap  <F2> "b
noremap  <F3> "c
noremap  <F4> "d
set pastetoggle=<F8>

" search improve
set ignorecase
set incsearch
set smartcase

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
" let g:deoplete#sources={}
" let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
" let g:deoplete#omni#input_patterns={}
" let g:deoplete#omni#input_patterns.scala=['[^. *\t0-9]\.\w*',': [A-Z]\w', '[\[\t\( ][A-Za-z]\w*']
" if has("unix")
"     let s:uname = system("uname -s")
"     if s:uname == "Linux\n"
"         let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
"         let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/'
"     elseif s:uname == "FreeBSD\n"
"         let g:deoplete#sources#clang#libclang_path = '/usr/local/llvm50/lib/libclang.so'
"         let g:deoplete#sources#clang#clang_header  = '/usr/lib/clang/'
"     elseif s:uname == "Darwin\n"
"         let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/3.
"         9.1/lib/libclang.dylib'
"         let g:deoplete#sources#clang#clang_header  = '/usr/local/Cellar/llvm/3.
"         9.1/include/clang'
"     endif
" endif
" let g:deoplete#sources#clang#std#cpp       = 'c++11'
" let g:deoplete#sources#clang#sort_algo     = 'priority'
" let g:deoplete#sources={}
" let g:deoplete#sources._=['buffer', 'member', 'tag', 'file', 'omni', 'ultisnips']
" let g:deoplete#omni#input_patterns={}
" let g:deoplete#omni#input_patterns.scala='[^. *\t]\.\w*\|: [A-Z]\w*'
" set completeopt-=preview "no scratch window

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

let g:fuzzy_bindkeys = 1

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Some server have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    " highlight link TabNum Special
endif


















if !exists('g:tmp_file_uncrustify')
  let g:tmp_file_uncrustify = fnameescape(tempname())
endif

" Specify path to your Uncrustify configuration file.
let g:uncrustify_cfg_file_path =
    \ shellescape(fnamemodify('~/dotfiles/default.cfg', ':p'))

" http://stackoverflow.com/a/15513829/288089
" Restore cursor position, window position, and last search after running a
" command.
func! s:Preserve(command)
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunc

" Don't forget to add Uncrustify executable to $PATH (on Unix) or 
" %PATH% (on Windows) for this command to work.
func! Uncrustify(language)
  call s:Preserve(':silent %!uncrustify'
      \ . ' -q '
      \ . ' -l ' . a:language
      \ . ' -c ' . g:uncrustify_cfg_file_path)
endfunc

" Quoting string
" @param {String} str Any string
" @return {String} The quoted string
func! s:quote(str)
  return '"'.escape(a:str,'"').'"'
endfun

func! Uncrustify2(...)
  let l:lang = get(a:000, 0, 'c')
  let l:line1 = get(a:000, 1, '1')
  let l:line2 = get(a:000, 2, '$')

  " Get content from the files
  let content = getline(l:line1, l:line2)

  " Length of lines before beautify
  let lines_length = len(getline(l:line1, l:line2))

  " Write content to temporary file
  call writefile(content, g:tmp_file_uncrustify)
  let l:tmp_file_uncrustify_arg = s:quote(g:tmp_file_uncrustify)

  let cmd = "uncrustify -q -l " . l:lang . " --frag -c " . g:uncrustify_cfg_file_path . " -f " . l:tmp_file_uncrustify_arg
  let result = system(cmd)
  let lines_uncrustify = split(result, "\n")

  if !len(lines_uncrustify)
      return result
  endif

  silent exec line1.",".line2."j"
  call setline(line1, lines_uncrustify[0])
  call append(line1, lines_uncrustify[1:])
  return result
endfunc

func! RangeUncrustify(language) range
  return call('Uncrustify2', extend([a:language], [a:firstline, a:lastline]))
endfunc

autocmd FileType c noremap <buffer> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>
autocmd FileType cpp noremap <buffer> <c-f> :call Uncrustify('cpp')<CR>
autocmd FileType cpp vnoremap <buffer> <c-f> :call RangeUncrustify('cpp')<CR>

hi Sneak ctermfg=160 ctermbg=none

set splitright
set splitbelow
