" vim-plug
call plug#begin()
Plug 'MattesGroeger/vim-bookmarks'              " plugin_vimbookmark
Plug 'SirVer/ultisnips'                         " plugin_snippets
Plug 'airblade/vim-gitgutter'                   " plugin_gitgutter
Plug 'airblade/vim-rooter'                      " no_config
Plug 'ervandew/supertab'                        " plugin_supertab
Plug 'junegunn/fzf'                             " plugin_fzf
Plug 'junegunn/fzf.vim'                         " plugin_fzf
Plug 'neoclide/coc.nvim', {'branch': 'release'} " plugin_coc
Plug 'octol/vim-cpp-enhanced-highlight'         " plugin_cppenhancedhighlight
Plug 'powerman/vim-plugin-AnsiEsc'              " plugin_ansiesc
Plug 'rust-lang/rust.vim'                       " no_config
Plug 'skmpz/vim-snippets'                       " plugin_snippets
Plug 'terryma/vim-expand-region'                " plugin_expandregion
Plug 'tpope/vim-commentary'                     " no_config
Plug 'tpope/vim-fugitive'                       " no_config
Plug 'tpope/vim-surround'                       " no_config
Plug 'vim-airline/vim-airline'                  " plugin_airline
Plug 'vim-airline/vim-airline-themes'           " plugin_airline
Plug 'vim-scripts/xoria256.vim'                 " plugin_xoria256
Plug 'w0rp/ale'                                 " plugin_ale
Plug 'wellle/targets.vim'                       " no_config
call plug#end()

"==============================================================================
" GENERAL CONFIG
"==============================================================================

" filetype indent
filetype plugin indent on

" space as leader key
let mapleader = "\<space>"

" set number and relativenumber
set number
set relativenumber

" tab navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>

" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces

" search improve
set ignorecase
set incsearch
set smartcase

" clipboard
set clipboard=unnamedplus

" enable cursorline
set cursorline

" disable mouse
set mouse=

" ignore stupid warning
set shortmess+=A

" stop highlight after search
noremap <ESC> <ESC>:nohl<CR>

" revert command-findnext mappings
nno ; :
nno : ,
nno , ;
vno : ;
vno ; :

" search with s/S
nnoremap s /
nnoremap S ?

" indent right after pasting
nmap p pgV=
nmap P PgV=

" make Y behave like other capital letters
nnoremap Y y$

" visual select last inserted text
nnoremap gV `[V`]

" reselect visual block after indenting
vnoremap > >gv
vnoremap < <gv

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

" add matching braces
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

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

" show trailing
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<

" go to first word with 0
nnoremap 0 0w

" go to end of line and enter insert mode
imap jj <ESC>A

" yank to system clipboard
nnoremap <leader>y "*y
vnoremap <leader>y "*y

" smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" always show signcolumns
set signcolumn=yes

" Better display for messages
set cmdheight=1

" don't give |ins-completion-menu| messages.
set shortmess+=c

" tab numbers
function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")
        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . tab .' '
        let s .= (bufname != '' ? fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif
    endfor

    let s .= '%#TabLineFill#'
    if (exists("g:tablineclosebutton"))
        let s .= '%=%999XX'
    endif
    return s
endfunction
set tabline=%!Tabline()

" delete without yanking
nnoremap <leader>d "_d
nnoremap <leader>D "_D
nnoremap c "_c
nnoremap C "_C
vnoremap c "_c
vnoremap C "_C

" create session
nnoremap <leader>, :mks! ~/.sess<cr>

" go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" registers for multiple yanks
noremap  <F1> "a
noremap  <F2> "b
noremap  <F3> "c
noremap  <F4> "d

" write/quit using leader
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" jk for escape
imap jk <Esc>

" paste toggle
set pastetoggle=<F8>

" go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> tt :exe "tabn ".g:lasttab<cr>
vnoremap <silent> tt :exe "tabn ".g:lasttab<cr>

" wildignore
set wildignore+=build/**

" cpp source/header/tests files open
nnoremap <leader>ps :e **/%:t:r.cc<CR>
nnoremap <leader>ph :e **/%:t:r.hh<CR>
nnoremap <leader>pt :e **/%:t:r_test.cc<CR>
nnoremap <leader>pvs :vsp **/%:t:r.cc<CR>
nnoremap <leader>pvh :vsp **/%:t:r.hh<CR>
nnoremap <leader>pvt :vsp **/%:t:r_test.cc<CR>
nnoremap <leader>pxs :sp **/%:t:r.cc<CR>
nnoremap <leader>pxh :sp **/%:t:r.hh<CR>
nnoremap <leader>pxt :sp **/%:t:r_test.cc<CR>

" splits
set splitright
set splitbelow

" no swap file
set noswapfile

" colors
silent! colorscheme xoria256
hi Normal ctermbg=none
hi Search ctermfg=160 ctermbg=none
hi LineNr ctermbg=none
hi NonText ctermbg=none
hi CursorLine ctermbg=235
hi MatchParen cterm=none ctermbg=magenta ctermfg=black
hi VertSplit ctermbg=none ctermfg=8
hi TabLineFill ctermbg=none ctermfg=1
hi TabLine ctermfg=0 ctermbg=7
hi TabLineSel ctermfg=1 ctermbg=0
hi SignColumn ctermbg=NONE
hi Pmenu ctermfg=0 ctermbg=33
hi PmenuSel ctermfg=33 ctermbg=0
hi TabLineFill ctermfg=16 ctermbg=16
hi TabLine ctermfg=7 ctermbg=16
hi TabLineSel ctermfg=45 ctermbg=16

"==============================================================================
" PLUGINS CONFIG
"==============================================================================

"------------------------------
" plugin_supertab
"------------------------------
let g:SuperTabDefaultCompletionType = "<C-n>"

" plugin_vimbookmark
let g:bookmark_sign = '•'
let g:bookmark_highlight_lines = 0
highlight BookmarkSign ctermbg=none ctermfg=12

" plugin_fzf
nnoremap <leader>o :FZF<CR>
noremap <leader>k :Rg <c-r>=expand("<cword>")<CR><CR>

"------------------------------
" plugin_gitgutter
"------------------------------
" update signs on write
autocmd BufWritePost * GitGutter

" colors
hi GitGutterAdd ctermbg=none ctermfg=green
hi GitGutterChange ctermbg=none ctermfg=gray
hi GitGutterDelete ctermbg=none ctermfg=red

"------------------------------
" plugin_airline
"------------------------------
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" signs and colors
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

"------------------------------
" plugin_coc
"------------------------------
" maps
nnoremap <leader>f :CocList outline<CR>
nnoremap <leader>n :call CocAction('diagnosticNext')<CR>
nnoremap <leader>N :call CocAction('diagnosticPrevious')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" colors
hi CocFloating ctermbg=16
hi CocErrorHighlight ctermbg=none ctermfg=1
hi CocErrorSign ctermbg=none ctermfg=1
hi CocWarningHighlight ctermbg=none ctermfg=172
hi CocWarningSign ctermbg=none ctermfg=172

"------------------------------
" plugin_vimcommentary
"------------------------------
" comment/uncomment lines with <leader>c
nmap <leader>c gcc
vmap <leader>c gc

"------------------------------
" plugin_ansiesc
"------------------------------
" disable <leader>swp for AnsiEsc
let g:no_plugin_maps = 1

"------------------------------
" plugin_cppenhancedhighlight
"------------------------------
" cpp highlight extras
let g:cpp_member_variable_highlight = 1
let g:cpp_posix_standard = 1

"------------------------------
" plugin_expandregion
"------------------------------
" expand region mappings
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"------------------------------
" plugin_ale
"------------------------------
" linters
let g:ale_linters = {
            \ 'cpp': ['cppcheck', 'cpplint'],
            \ 'c': ['clangtidy', 'gcc']
            \ }

" fixers
let g:ale_fixers = {
            \ 'cpp': ['clang-format'],
            \ 'c': ['clang-format'],
            \ 'rust': ['rustfmt']
            \ }

" signs and colors
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
hi ALEWarning ctermbg=none ctermfg=172
hi ALEWarningSign ctermbg=none ctermfg=172
hi ALEError ctermbg=none ctermfg=1
hi ALEErrorSign ctermbg=none ctermfg=1

" options
let g:ale_cpp_cppcheck_options = '--enable=all'
let g:ale_cpp_cpplint_options= "--filter=-legal/copyright,-build/c++11,-build/include_subdir,-build/include_order,-readability/braces,-whitespace/newline,-whitespace/blank_line,-runtime/references,-whitespace/indent --linelength=110"

" mappings
noremap <leader>j :CocFix<CR>
autocmd FileType c noremap <buffer> <c-f> :ALEFix<CR>:e<CR>
autocmd FileType cpp noremap <buffer> <c-f> :ALEFix<CR>:e<CR>
autocmd FileType rust noremap <buffer> <c-f> :RustFmt<CR>:w<CR>:e<CR>

"------------------------------
" plugin_airline
"------------------------------
let g:airline_theme='serene'

"------------------------------
" plugin_snippets
"------------------------------
let g:UltiSnipsExpandTrigger="`"
let g:UltiSnipsJumpForwardTrigger="`"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
