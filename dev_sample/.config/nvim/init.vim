syntax enable
filetype plugin on
filetype indent on
set number
set nocompatible
set complete-=i
set textwidth=160
set colorcolumn=+1
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set laststatus=2
set cmdheight=1

let mapleader = "\<Space>"

" shellでaliasを有効化
set shell=/bin/bash\ -l\ -O\ expand_aliases

" タブ補完
" 例: <Tab>=list, <Tab><Tab>=full
" set wildmode=list,full
set wildmode=list:longest

" スワップ
set noswapfile
" set directory=/tmp

" バックアップ
set nobackup
" set backupdir=/tmp

" ヤンクでクリップボード共有
set clipboard+=unnamedplus,unnamed

" viminfo
set viminfo='50,\"3000,:0,n~/.viminfo

" word区切り文字の変更
set iskeyword-=_
set iskeyword-=-

" インデント各種設定
" " MEMO: tab入力方法: <ctrl-v>tab
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

" 検索補助
set incsearch
" set hlsearch


" neovim Original Settings
if filereadable(expand('~/.config/nvim/original_custom.vim'))
  source ~/.config/nvim/original_custom.vim
endif

" Plugins Settings
if filereadable(expand('~/.config/nvim/plugin_settings.vim'))
  source ~/.config/nvim/plugin_settings.vim
endif
