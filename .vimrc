set nocompatible

filetype indent on  " load indent files for filetypes

" Appearance {{{
set number          " show line numbers
set tabstop=4       " number of columns per tab
set softtabstop=4   " number of spaces per tab
set shiftwidth=4    " number of columns per indent
set expandtab       " tabs are spaces
set ruler           " show row and column numbers
set cursorline      " hilight line cursor is on for easier placefinding
set visualbell      " flash instead of beeping ear-splittingly
set lazyredraw      " only redraw when necessary
" }}}

" Functionality {{{
let mapleader=","   " use , for leader
" searching {{{
set hlsearch        " hilight search terms
set incsearch       " search as you type
" turn off search hilighting using ,<space>
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" use ,m to run make
nnoremap <leader>m :w\|:!make<CR>
" repeat last normal-mode command while in visual mode
" Warning: powerful as fuck
vnoremap . :norm .<CR>
" Use os and X clipboards (?)
set clipboard=unnamedplus,autoselect
" }}}

" colors {{{
colorscheme default " I guess
syntax enable       " enable syntax hilighting
" highlight 81st column if we go over {{{
" this line creates a highlighting scheme to use
highlight ColorColumn ctermbg=red
" matchadd applies a colorscheme to the matching regex
" call matchadd('ColorColumn', '\%81v')
" or hilight entire column
" I think I like this better
set colorcolumn=81
" }}}
" }}}

" fold things {{{
set foldlevelstart=0    " start with everything folded
set foldmethod=indent   " fold on indents
" }}}

" restore place when opening file (apparently default) {{{
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" I don't know how this works. That is not great.
"   - BufReadPost is an autocommand (?) that gets executed after (post) the file
"       (buffer) is read.
"   - line() returns the line number corresponding to top or bottom of file, or
"       window, current position, top of visual range, or a mark.
"       The above uses the mark " which apparently is the last line you were on
"       when previously editing the file.
"   - The if makes sure the line is within the file before going to the mark
"       (using normal g' instead of normal ' so the jumplist (accessible with
"       C-i and C-o) will not be affected)
" Now I know how this works!
" }}}

" Settings for specific filetypes {{{
augroup configgroup
    autocmd FileType md setlocal spell
    autocmd FileType make setlocal noexpandtab
    autocmd FileType tex setlocal spell
    autocmd FileType tex setlocal commentstring=\%\ %s
augroup END
" }}}

" Command-T settings {{{
" change selected color so it doesn't blend into footer
let g:CommandTHighlightColor='TabLineSel'
" try using escape to get out
if &term =~ "rxvt-unicode"
    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif
" start search from working directory
let g:CommandTTraverseSCM='pwd'
" press enter to open in a new tab
let g:CommandTAcceptSelectionTabMap='<CR>'
" press ctrl + enter to open in current tab
let g:CommandTAcceptSelectionMap='<C-CR>'
" press shift + enter to open in new split (Shift for Split)
let g:CommandTAcceptSelectionSplitMap='<S-CR>'
" ignore certain files when searching
set wildignore+=node_modules/*,tmp/*
" }}}

" use the last line of the file to configure specific settings
set modelines=1

" vim:foldmethod=marker:foldlevel=0
