syntax enable
filetype plugin indent on
set nocompatible

" <LEADER> 設定
let mapleader = "\<Space>"


" netrw
" - 行指定ファイル移動のため番号表示
" - 移動以外に使用しないのでヘッダーは必要ない
let g:netrw_bufsettings = 'noma nomod number nobl nowrap ro'
let g:netrw_banner=0


" 行番号表示/非表示
" - 主にテスト時などで何行目か見えたほうがよい
" - shortcut キーで切り替えられればいいかもしれない
" set nonumber
set number

" " 自動での折り返しを禁止
" set nowrap


" 補完候補
" see https://medium.com/usevim/set-complete-e76b9f196f0f
" - include先までは必要ない。言語依存
set complete-=i
set completeopt=menuone,noinsert,noselect


" テキスト幅とハイライトする列
" - 160+1列目に色がつくので記述は控える
" - 現代は横幅のあるディスプレイが多いので目安
" set textwidth=160
" set formatoptions=q
set textwidth=0
set colorcolumn=+1


" ステータスライン
" - ファイル名/行列番号の表示
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P


" スワップ
" - 有効に機能した記憶がない(git任せ)
set noswapfile
" set directory=/tmp


" バックアップ
" - 有効に機能した記憶がない(git任せ)
set nobackup
" set backupdir=/tmp


" shellでaliasを有効化
set shell=/bin/bash\ -l\ -O\ expand_aliases


" クリップボード共有
" - WSLがメインになった今ではあまり意味がない
" set clipboard+=unnamedplus,unnamed


" word 区切り文字
" - 言語ごとに設定が望ましい
" - 当初設定していたが、この処理はプラグインに任せることにした
" set iskeyword-=_
" set iskeyword-=-


" ファイル名補完
" 例: <Tab>=list, <Tab><Tab>=full
" set wildmode=list,full
" - <Tab>時に一致する名前の一覧を表示
set wildmode=list:longest


" インデント各種設定
" - tabはスペース扱いとする
" - tabを入力するには <ctrl-v>tab で入れられる
set autoindent
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2


" その他
set ambiwidth=double " 記号系で文字が重なる問題対応
set cmdheight=1 " コマンド行高さ
set incsearch " 検索
set splitright " ウィンドウ分割 右
set splitbelow " ウィンドウ分割 下
set lazyredraw " 遅延再描画
set showtabline=2 " タブは必ず表示(ファイル名確認のため)
set nofoldenable


" Originals (shortcut, etc)
if filereadable(expand('~/.config/nvim/init_originals.vim'))
  source ~/.config/nvim/init_originals.vim
endif

" Plugins
if filereadable(expand('~/.config/nvim/init_plugins.vim'))
  source ~/.config/nvim/init_plugins.vim
endif
