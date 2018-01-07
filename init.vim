set nocompatible
set number rnu
set expandtab shiftwidth=2 smarttab
set backspace=indent,eol,start
set incsearch
set mouse=a
syntax on
filetype plugin indent on
autocmd FileType text,tex,mail,markdown,rst setlocal tw=76 spell
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python,rust,javascript,typescript,go LanguageClientStart

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'
Plug 'digitaltoad/vim-pug'
Plug 'wlangstroth/vim-racket'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'leafgarland/typescript-vim'
Plug 'autozimu/LanguageClient-neovim', {'tag': 'binary-*-x86_64-apple-darwin'}
call plug#end()

let g:LanguageClient_autoStart = 0
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'go': ['go-langserver'] }
noremap <silent> ,h :call LanguageClient_textDocument_hover()<CR>
noremap <silent> ,d :call LanguageClient_textDocument_definition()<CR>
noremap <silent> ,r :call LanguageClient_textDocument_rename()<CR>
noremap <silent> ,s :call LanugageClient_textDocument_documentSymbol()<CR>

let g:airline_theme='simple'
let g:go_fmt_command = "goimports"
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:rustfmt_autosave = 1
let g:vim_markdown_folding_disabled = 1

let s:commenters_left = {
    \   "bashrc": '#',
    \   "c": '//',
    \   "conf": '#',
    \   "cpp": '//',
    \   "fstab": '#',
    \   "go": '//',
    \   "java": '//',
    \   "javascript": '//',
    \   "lua": '--',
    \   "make": '#',
    \   "matlab": '%',
    \   "perl": '#',
    \   "php": '//',
    \   "plaintex": '%',
    \   "python": '#',
    \   "rust": '//',
    \   "scala": '//',
    \   "scheme": ';',
    \   "sh": '#',
    \   "tex": '%',
    \   "vim": '"',
    \   "yml": '#',
    \   "yaml": '#',
    \ }
let s:commenters_surround = {
    \   "html": ['<!--', '-->'],
    \   "markdown": ['<!--', '-->'],
    \   "ocaml": ['(\*', '\*)'],
    \ }
function! ToggleComment()
  if has_key(s:commenters_left, &filetype)
    let commenter_og = s:commenters_left[&filetype]
    for commenter in [commenter_og." ", commenter_og]
      if getline('.') =~ "^\\s*".commenter
        execute "silent s_^\\(\\s*\\)".commenter."_\\1_"
        return
      endif
    endfor
    execute "silent s_^\\(\\s*\\)_\\1".commenter." _"
  elseif has_key(s:commenters_surround, &filetype)
    let [c_l, c_r] = s:commenters_surround[&filetype]
    " TODO: make this multiline, rather than commenting each line
    if getline('.') =~ "^\\s*".c_l && getline('.') =~ c_r."\\s*$"
      execute "silent s_^\\(\\s*\\)".c_l." _\\1_"
      execute "silent s_ ".c_r."\\(\\s*\\)$_\\1_"
      return
    else
      execute "silent s_^\\(\\s*\\)_\\1".c_l." _"
      execute "silent s_\\(\\s*\\)$_ ".c_r."\\1_"
    endif
  else
    echo "No commenter found for filetype"
  endif
endfunction

inoremap <S-Tab> <C-V><Tab>
noremap <C-a> 0
noremap <C-e> $
command M :w | :make
noremap M :M<CR>
noremap W :w<CR>
noremap <C-c> :call ToggleComment()<cr>
