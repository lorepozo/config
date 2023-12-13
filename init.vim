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

if has('nvim')
  autocmd TermOpen * setlocal nonumber nornu
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'FStarLang/VimFStar', {'for': 'fstar'}
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'junegunn/goyo.vim'
Plug 'elzr/vim-json'
Plug 'junegunn/limelight.vim'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdcommenter'
Plug 'digitaltoad/vim-pug'
Plug 'wlangstroth/vim-racket'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'
Plug 'mbbill/undotree'
call plug#end()

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
