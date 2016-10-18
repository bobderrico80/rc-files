execute pathogen#infect()
syntax on
filetype plugin indent on
set number
set smartindent
set smarttab
set showmatch
set foldmethod=marker
set foldlevel=0
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set nowrap
set omnifunc=javascriptcomplete#CompleteJS
set omnifunc=csscomplete#CompleteCSS
set omnifunc=htmlcomplete#CompleteTags
set omnifunc=syntaxcomplete#Complete
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let mapleader = "\<space>"
nnoremap <Leader>w :w<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>q :wq<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>b :sh<CR>
nnoremap <leader>r :w<CR>:!!<CR>
nnoremap <leader>e :e<space>%<CR>
nnoremap <leader>E :e!<space>%<CR>
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
nnoremap <leader>H <C-W>H
nnoremap <leader>J <C-W>J
nnoremap <leader>K <C-W>K
nnoremap <leader>L <C-W>L
nnoremap <leader>o <C-W>r
nnoremap <leader>O <C-W>R
nnoremap <leader>p "0p
nnoremap <leader>P "0P
nnoremap <leader>g :%s/
nnoremap <leader>t :!<space>
nnoremap <leader>[ <C-w>10<
nnoremap <leader>] <C-w>10>
nnoremap <leader>- <C-w>10-
nnoremap <leader>+ <C-w>10+
nnoremap <leader>= <C-w>=
nnoremap <leader>s :sp<CR>
nnoremap <leader>v :vsp<CR>
nnoremap . >>
nnoremap , <<
nnoremap <leader>4 $
nnoremap <leader>6 ^
vnoremap <leader>4 $
vnoremap <leader>6 ^
vnoremap , <gv
vnoremap . >gv
nnoremap ; <C-d>
nnoremap ' <C-u>
vnoremap ; <C-d>
vnoremap ' <C-u>
nnoremap <leader>; $a;<esc>
