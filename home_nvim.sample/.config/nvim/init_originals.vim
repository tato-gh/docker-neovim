
" NOTE
" - タブは `gt``gT` で扱えるように1~2つ程度を使用する
"   多用するとタブで開くかどうかの選択でショートカットが増えすぎる
"   (かつて多用していたがやめてみる...)
" - ウィンドウ分割は <C-w> を素直に使用する
" - tmuxである程度作業するフォルダを分離しているので前後フォルダ移動が早いほうがいい
"   そのため fzf はさほど必要ないと思われる
" - コーディング中に一時退避用ファイルとして .memo を作ることがある
"   .memo をさくっと開けるほうがいい
"   .memo のみを対象とした検索があったほうがいい

" 同フォルダのファイルを中心に作業する運用のショートカット要件
" - 課題
"   - `:e %:h` ではタブ補完後に入力が必要なのでひと手間かかる
"   - fzf 系も基本的に入力が必要
"   - netrw(等)は行移動でもいいのでやや楽
" - 同じフォルダにあるファイルをさくっと開けること
" - 番号指定でファイルを開けること
" - 同じフォルダの前後に変更したファイルがさくっと開けること


" -----------------------
"
" Command / Shortcut
" - 何かを読み書きする処理系は ,<KEY> のようにカンマを前置する(マイルール)
" - 表示/非表示等の切り替え系は s*y(es)/s*n(o) を意図して y/n を使う
"   - 例えば行番号 表示/非表示は rt/rf を割り当てている
" -----------------------

" 日本語切り替え処理
" - デフォルトで <Esc>と<C-[>があるがやや押しにくい
inoremap <silent> <C-j> <Esc>


" CR で行を単純追加
nnoremap <CR> o<Esc>


" yank
" - いろいろするのでfunctionへ
vnoremap y y:YankAnd<CR>
vnoremap b d:DeletedBackup<CR>


" paste
"
" viminfo読み込み
" - Vim間(コピー)ペースト用
nnoremap ,p :rv<CR>"0p


" set paste
" - Windows側クリップボードからの貼り付け時にautoindent等を防止用途
" - 抜けるときにset nopasteに自動で戻す
nnoremap <Leader>i :set paste<CR>i
autocmd! InsertLeave * set nopaste


" 履歴移動
" - デフォルト
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>


" ディレクトリパス表示
" - %% でフォルダを展開 (%は表示しているファイル)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'


" 新規バッファ
" - d はディレクトリの意
" - m はメモ用ファイル
nnoremap <Leader>ee :e<Space>
nnoremap <Leader>ed :e <C-r>=Curdir()<CR>
nnoremap <Leader>em :e <C-r>=Curdir()<CR>.memo<CR>
nnoremap <Leader>es :execute 'wincmd s' <CR> :e<Space>
nnoremap <Leader>ev :execute 'wincmd v' <CR> :e<Space>
nnoremap <Leader>tt :tabnew<Space>
nnoremap <Leader>td :tabnew <C-r>=Curdir()<CR>
nnoremap <Leader>tm :tabnew <C-r>=Curdir()<CR>.memo<CR>


" ファイル/フォルダ ショートカット
" - vim からよくある操作は直下ファイル/フォルダ作成
nnoremap <Leader>cf :silent !touch <C-r>=Curdir()<CR>
nnoremap <Leader>cd :silent !mkdir -p <C-r>=Curdir()<CR>
nnoremap <Leader>df :silent !rm <C-r>=Curdir()<CR>
nnoremap <Leader>dd :silent !rm -r <C-r>=Curdir()<CR>


" 日付挿入 時刻挿入
let weeks = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
nnoremap ,tt <Esc>$a<C-R>=strftime('%Y-%m-%d (').weeks[strftime("%w")].')'<CR><Esc>
nnoremap ,tm <Esc>$a<C-R>=strftime('%m-%d')<CR><Esc>
nnoremap ,th <Esc>$a<C-R>=strftime('%H:%M')<CR><Esc>


" 行番号 表示/非表示
nnoremap <Leader>sny :set number<CR>
nnoremap <Leader>snn :set nonumber<CR>


" バッファ 一覧移動用
nnoremap <silent><Leader>b :ls<CR>:b<Space>


" マーク 一覧移動用
nnoremap <silent><Leader>m :<C-u>marks<CR>:normal! `


" マーク 自動採番
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>
nnoremap <silent>M :<C-u>call <SID>AutoMarkrementBig()<CR>


" oldfiles 一覧移動用
nnoremap <silent><Leader>o :browse :oldfiles<CR>


" ターミナル関係
"   grep! grep!
nnoremap <C-g>r :TRipGrep<Space>
nnoremap <C-g>ww :TRipGrep<Space><C-r>=expand('<cword>')<CR><Space><C-r>=Curdir()<CR><CR>
nnoremap <C-g>wa :TRipGrep<Space><C-r>=expand('<cword>')<CR><CR>
nnoremap <C-g>yy :TRipGrep<Space><C-r>=@"<CR><Space><C-r>=Curdir()<CR><CR>
nnoremap <C-g>ya :TRipGrep<Space><C-r>=@"<CR><CR>
"   現バッファのファイル/フォルダ一覧
nnoremap <Leader>j :DirectoryFiles <C-r>=substitute(Curdir(), '/../', '/', '')<CR> <C-r>=expand('%')<CR><CR>
nnoremap <Leader>k :DirectoryFiles <C-r>=Curdir()<CR>../<CR>
nnoremap <Leader>f :FindDirectoryFiles <C-r>=Curdir()<CR><Space>
nnoremap <Leader>l :MovePostFile 'atime' <C-r>=expand('%')<CR><CR>
nnoremap <Leader>h :MovePrevFile 'atime' <C-r>=expand('%')<CR><CR>

"   行番号を指定してファイル移動
"   50行まで。ぱっと見でわからない場合は検索して直接行に移動するだけ
for n in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  execute 'nnoremap <Leader>' . n . '<Space> :OpenFileAtLine ' . n '<CR>'
  " e.g. nnoremap <Leader>0<Space> :OpenFileAtLine 0<CR>
endfor

for n in [
    \ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
    \ 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    \ 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
    \ 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
    \ 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
  execute 'nnoremap <Leader>' . n . ' :OpenFileAtLine ' . n '<CR>'
  " e.g. nnoremap <Leader>10 :OpenFileAtLine 10<CR>
endfor


" ターミナル
tnoremap <C-j> <C-\><C-n>
nnoremap <C-t> :MyTerm<Space>
nnoremap <C-g>ll :MyTerm git log -p <C-r>=expand('%')<CR><CR>
nnoremap <C-g>la :MyTerm git log -p<CR>
nnoremap <C-g>dd :MyTerm git diff <C-r>=expand('%')<CR><CR>
nnoremap <C-g>da :MyTerm git diff<CR>
nnoremap <C-g>st :MyTerm git status<CR>
command! -nargs=* MyTerm wincmd v | terminal <args>
command! -nargs=* MyTermSelf terminal <args>


" ヒューリスティック(便利機能案)
" " 別ファイル参照 / 画面分割してファイル一覧
nnoremap <Leader>r :wincmd v<CR>:DirectoryFiles <C-r>=Curdir()<CR> <C-r>=expand('%')<CR><CR>
" " 別ファイル移動 / 現フォルダの最後に変更したファイル
nnoremap <Leader>; :MovePostFile 'mtime' <C-r>=Curdir()<CR><CR>




" -----------------------
" Auto Command
" - autocmd はファイルを読むたびに登録される
" - 複数回の読み込みで上書きされるように、augroupで囲み、削除と追加を記述すること
" -----------------------

" " netrw カスタマイズ
" " - netrw はいつからかWinBufEnterが発火しない
" augroup vimrc_netrw_commands
" augroup END


" 起動時 MRU
" - 設定すると netrw がバグる。未調査
" autocmd! VimEnter * CtrlPMRUFiles


" バッファ操作
" - カーソル位置を保存/復元
" - (特に一時利用netrw等)バッファ削除。w:bnum_to_delete 変数の有無で実施
"   バッファ一覧があふれるため対応
augroup vimrc_inout_buffer
  autocmd!

  autocmd BufLeave * let b:linenr = line('.')
  autocmd BufWinEnter * if exists('b:linenr') | execute ':' . b:linenr | endif

  autocmd BufLeave * if &filetype == 'netrw' | let w:bnum_to_delete = bufnr('%') | endif
  autocmd BufWinEnter * if exists('w:bnum_to_delete') | execute 'bwipeout! ' . w:bnum_to_delete | endif
  autocmd BufWinEnter * if &filetype != 'netrw' | unlet! w:bnum_to_delete | endif
augroup END


" ファイルタイプ設定
augroup vimrc_my_filetypes
  autocmd!
  " autocmd BufNewFile,BufRead *.txt      set filetype=markdown
  autocmd BufNewFile,BufRead *.ruby     set filetype=ruby
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
  autocmd TermOpen * set filetype=terminal
augroup END


" 保存時の行末空白削除
" - 場合によっては必要なファイルもあるため拡張子が明確な場合は明示して除外
augroup vimrc_remove_tailspaces
  autocmd!
  let ignores = ['vim']
  autocmd BufWritePre * if index(ignores, &ft) < 0 | :%s/\s\+$//ge
augroup END




" -----------------------
" Function
" -----------------------

" Yank に付随する追加処理用
" - Vim間コピーのため、viminfo に書き出し (`wv`)
" - WSLでのホストへのコピーのため、/tmp/yanked に書き出し
command! -range YankAnd silent call s:YankAnd()
function! s:YankAnd() range
  wv

  redir! > ~/.yanked
  silent echo getreg("0")
  redir end
  !sed -e '1,1d' ~/.yanked > /tmp/yanked
endfunction


" Delete に付随する追加処理用
" - メモのため、.memo に書き出し。消すのをためらうもの等
command! -range DeletedBackup silent call s:DeletedBackup()
function! s:DeletedBackup() range
  redir! > /tmp/.deleted
  silent echo getreg("0")
  redir end
  !sed -i -e '1,1d' /tmp/.deleted

  let memofile = Curdir() . '.memo'
  execute '!touch ' . memofile
  execute '!cat /tmp/.deleted ' . memofile . ' > /tmp/.memo'
  execute '!mv /tmp/.memo ' . memofile
  execute '!sed -i 1i-----------------------------------------\\n ' . memofile
endfunction


" タブに番号表示
" ref: http://blog.remora.cx/2012/09/use-tabpage.html
set tabline=%!MyTabLine()
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  return s
endfunction

let g:use_Powerline_dividers = 1
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let altbuf = bufname(buflist[winnr - 1])
  " $HOME を消す
  let altbuf = substitute(altbuf, expand('$HOME/'), '', '')
  " カレントタブ以外はパスを短くする
  if tabpagenr() != a:n
    let altbuf = substitute(altbuf, '^.*/', '', '')
    " let altbuf = substitute(altbuf, '^.\zs.*\ze\.[^.]\+$', '', '')
  endif
  " タブ番号を付加
  let altbuf = a:n . ':' . altbuf
  return altbuf
endfunction


" シーケンスマーキング
" ref: http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
" - m/M を押すたびに順番に番号をふってマークする
if !exists('g:markrement_char')
  let g:markrement_char = [
  \     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
  \     'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  \ ]
endif
if !exists('g:markrement_bigchar')
  let g:markrement_bigchar = [
  \     'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  \     'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  \ ]
endif

function! s:AutoMarkrement()
  if !exists('b:markrement_pos')
    let b:markrement_pos = 0
  else
    let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
  endif
  execute 'mark' g:markrement_char[b:markrement_pos]
  echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

function! s:AutoMarkrementBig()
  if !exists('b:markrement_pos_big')
    let b:markrement_pos_big = 0
  else
    let b:markrement_pos_big = (b:markrement_pos_big + 1) % len(g:markrement_bigchar)
  endif
  execute 'mark' g:markrement_bigchar[b:markrement_pos_big]
  echo 'marked' g:markrement_bigchar[b:markrement_pos_big]
endfunction


" 行番号を指定ファイルオープン
" - netrw を開いた際のファイル一覧に対しての操作
"   `gf`でファイルが開いていないならフォルダなので`gd`実行
command! -nargs=? OpenFileAtLine silent call s:OpenFileAtLine(<f-args>)
function! s:OpenFileAtLine(query)
  execute ":" . a:query
  if &filetype == 'netrw'
    normal $
    if getline('.')[col('.')-1] == '/'
      normal gd
    else
      normal gf
    end
  else
    normal gF
  endif
endfunction


" ripgrep
" ターミナルを使用
command! -nargs=? TRipGrep silent call s:TRipGrep(<f-args>)
function! s:TRipGrep(query)
  let l:from = Curdir()
  execute 'MyTermSelf rg -A 1 -B 1 ' . a:query
  let b:dir = l:from
endfunction


" 同フォルダファイル一覧
command! -nargs=* DirectoryFiles silent! call s:DirectoryFiles(<f-args>)
function! s:DirectoryFiles(...)
  execute 'e ' . a:1
  if exists('a:2')
    execute 'silent /' . substitute(a:2, '/', '.', 'g')
  endif
endfunction


" find ファイル名検索
command! -nargs=* FindDirectoryFiles silent call s:FindDirectoryFiles(<f-args>)
function! s:FindDirectoryFiles(...)
  let l:from = Curdir()
  execute 'MyTermSelf find ' . a:1 . ' -name "*' . a:2 . '*"'
  let b:dir = l:from
endfunction


" 同一フォルダでアクセス/編集日時が１つ後のファイルを開く
" - `ls` で並びを指定して、1つ下の行のファイルを開く
" - pipeするとtermの結果が返ってこないときがある(system()と同様)
command! -nargs=* MovePostFile call s:MovePostFile(<f-args>)
function! s:MovePostFile(...)
  if exists('a:2')
    let l:curfile = fnamemodify(a:2, ":t")
    let l:result = s:CurdirFilesPrevOrPost(a:1, l:curfile, -1)
    execute 'e ' . l:result[0]

    if a:1 == 'atime'
      " alpine には `-a` がなかったので想定した動作にならない
      call system('touch -a --date "' . l:result[1] . '" ' . l:result[0])
    else
      call system('touch -m --date "' . l:result[1] . '" ' . l:result[0])
    endif
  else
    let l:files = DirFiles(a:1, Curdir())
    execute 'e ' . Curdir() . l:files[0]
  endif
endfunction


" 同一フォルダでアクセス/編集日時が１つ前のファイルを開く
" - `ls` で並びを指定して、1つ上の行のファイルを開く
command! -nargs=* MovePrevFile silent call s:MovePrevFile(<f-args>)
function! s:MovePrevFile(...)
  if exists('a:2')
    let l:curfile = fnamemodify(a:2, ":t")
    let l:result = s:CurdirFilesPrevOrPost(a:1, l:curfile, 1)
    execute 'e ' . l:result[0]

    if a:1 == 'atime'
      " alpine には `-a` がなかったので想定した動作にならない
      call system('touch -a --date "' . l:result[1] . '" ' . l:result[0])
    else
      call system('touch -m --date "' . l:result[1] . '" ' . l:result[0])
    endif
  else
    let l:files = s:DirFiles(a:1, Curdir())
    execute 'e ' . Curdir() . l:files[0][0]
  endif
endfunction

" 同一フォルダ ファイル移動用処理
" - 指定したファイル `curfile` の同フォルダのアクセス履歴 moveDiff 番目のファイルパスとアクセス日時を返す
function! s:CurdirFilesPrevOrPost(order, curfile, moveDiff)
  let l:files = s:DirFiles(a:order, Curdir())
  let l:ind = 0
  let l:moveind = 0
  for filename in l:files[0]
    if a:curfile == filename
      let l:moveind = l:ind + a:moveDiff
      break
    endif
    let l:ind = l:ind + 1
  endfor

  if l:moveind >= len(l:files[0])
    let l:moveind = 0
  endif

  return [Curdir() . l:files[0][l:moveind], l:files[1][l:moveind]]
endfunction

" 同一フォルダ ファイル移動用処理
" - 指定したフォルダに含まれるファイルとアクセス日時をアクセス履歴順で返す
function! s:DirFiles(order, dir)
  let l:files = []
  let l:timestamps = []

  if a:order == 'atime'
    let l:rows = split(system('ls -lut --full-time ' . a:dir), "\n")
  else
    let l:rows = split(system('ls -lt --full-time ' . a:dir), "\n")
  endif

  call remove(l:rows, 0) " total ~ の除去
  for row in l:rows
    " e.g. -rw-r--r--    1 nvim     nvim           162 2021-05-29 08:10:01 +0000 README.md
    let l:is_dir = (row[0] == 'd')
    if !l:is_dir
      let data = split(row, ' ')
      call add(l:files, data[-1])
      call add(l:timestamps, data[-4] . ' ' . data[-3])
    endif
  endfor

  return [l:files, l:timestamps]
endfunction


" 現フォルダ取得処理
function! Curdir()
  if exists('b:dir')
    return b:dir
  endif
  if exists('b:netrw_curdir') && &filetype == 'netrw'
    return b:netrw_curdir . '/'
  endif
  return expand('%:h') . '/'
endfunction
