set nocompatible
set history=50
set undolevels=100
set viminfo='20,\"50
set showmode
set term=xtermc
syntax on
set ignorecase
set tabstop=4
set shiftwidth=4
set background=light
highlight Normal guibg=White guifg=Black
set backspace=2
set noerrorbells
set laststatus=2
set cmdheight=1
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ line:%l\ col:%c%V
set foldenable
set showmatch
set lz
nnoremap <F3> <Esc>nl
inoremap <F3> <Esc>nli
inoremap <C-H> <Esc>:%s/search/replace/gc
nnoremap <C-W> gti
inoremap <C-W>  <Esc>gti
"set nowrap   "// do not wrap lines
""set number   "// turn on line numbers
set nobackup
