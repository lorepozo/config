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

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'
Plugin 'elzr/vim-json'
Plugin 'plasticboy/vim-markdown'
Plugin 'digitaltoad/vim-pug'
Plugin 'wlangstroth/vim-racket'
Plugin 'rust-lang/rust.vim'
Plugin 'cespare/vim-toml'
call vundle#end()

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
