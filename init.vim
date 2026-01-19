set nocompatible
set number rnu
set expandtab shiftwidth=2 smarttab
set backspace=indent,eol,start
set incsearch
set mouse=a
set ruler
set hidden
set fillchars+=vert:\ 
syntax on
filetype plugin indent on
autocmd FileType text,tex,mail,markdown,rst setlocal spell
autocmd FileType text,tex,markdown,rst setlocal tw=76
autocmd FileType mail setlocal tw=0
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType python setlocal shiftwidth=4
hi VertSplit ctermfg=235
hi Search cterm=NONE ctermfg=red ctermbg=lightyellow
hi PopupNotification ctermbg=lightblue guibg=lightblue

if has('nvim')
  autocmd TermOpen * setlocal nonumber nornu
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'FStarLang/VimFStar', {'for': 'fstar'}
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'junegunn/goyo.vim'
Plug 'elzr/vim-json'
Plug 'junegunn/limelight.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'imsnif/kdl.vim'
Plug 'preservim/vim-markdown'
Plug 'preservim/nerdcommenter'
Plug 'digitaltoad/vim-pug'
Plug 'wlangstroth/vim-racket'
Plug 'rust-lang/rust.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'
call plug#end()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

autocmd User lsp_float_opened call setwinvar(lsp#document_hover_preview_winid(), '&wincolor', 'PopupNotification')

noremap <silent> ,h :LspHover<CR>
noremap <silent> ,d :LspDefinition<CR>
noremap <silent> ,r :LspReferences<CR>
noremap <silent> ,n :LspRename<CR>
noremap <silent> ,s :LspDocumentSymbol<CR>

colorscheme lore
let g:airline_theme = "simple"
let g:go_fmt_command = "goimports"
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:NERDSpaceDelims = 1
let g:rustfmt_autosave = 1
let g:vim_markdown_folding_disabled = 1
let g:limelight_conceal_ctermfg = 'darkgrey'
let g:goyo_width = '90%'
let g:goyo_height = '88%'

inoremap <S-Tab> <C-V><Tab>
noremap <C-e> $
command MyGoyo :Goyo | :Limelight!!
noremap = :MyGoyo<CR>
command M :w | :make
noremap M :M<CR>
noremap W :w<CR>
noremap <C-c> :call NERDComment(0, 'toggle')<CR>
vnoremap <C-c> :call NERDComment(1, 'minimal')<CR>
noremap <silent> ,u :UndotreeToggle<CR>
