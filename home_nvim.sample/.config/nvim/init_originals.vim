
" NOTE: 背景
" - タブは `gt``gT` で扱えるように1~2つ程度を使用する
"   多用するとタブで開くかどうかの選択でショートカットが増えすぎる
"   (かつて多用していたがやめてみる...)
" - ウィンドウ分割は <C-w> を素直に使用する
" - tmuxである程度作業するフォルダを分離しているので前後フォルダ移動が早いほうがいい
"   そのため fzf はさほど必要ないと思われる
"   - 同じフォルダにあるファイルをさくっと開けるといい
"   - 番号指定でファイルを開けるといい
"   - 同じフォルダの前後に変更したファイルがさくっと開けるといい
" - コーディング中に一時的にコードを退避させることがよくある
"   .memo をさくっと開けるほうがいい
"   .memo のみを対象とした検索があったほうがいい


" -----------------------
"
" Command / Shortcut ルール
" - 何かバッファに対して挿入する処理系は ,<KEY> のようにカンマを前置する(マイルール)
" - 表示/非表示等の切り替え系は s(et)*y(es)/s(et)*n(o) を意図して y/n を使う
"   - 例えば、行番号の表示/非表示は s(et)n(umber)y(es)/s(et)n(umber)n(o) を割り当てている
" - 現バッファのフォルダはピリオド(.)、カレントディレクトリはスラッシュ(/)を用いる
"   - 例えば、`:edit %:h` は `e.` で `:edit ./` は `e/`
"
" Leader or Ctrl
" - 基本的にLeaderに割り当てる
"
" -----------------------

" 日本語切り替え処理
" - デフォルトで <Esc>と<C-[>があるがやや押しにくい
inoremap <silent> <C-j> <Esc>


" CR で行を単純追加
nnoremap <CR> o<Esc>


" yank
" - いろいろするのでfunctionへ
vnoremap y y:YankAnd<CR>
nnoremap Y y$


" メモ
" - プロジェクト中では同じフォルダの.memoを使い、
" - ライブラリの閲覧中などは固定の.memoを使う想定
vnoremap m. :Memo <C-r>=Curdir()<CR>.memo<CR>
vnoremap m/ :Memo /srv/tmp/.memo<CR>

" paste
"
" viminfo読み込み
" - Vim間(コピー)ペースト用
nnoremap ,p :rv<CR>"0p
" コピー後に元位置にもどる
" - gv みたいな操作感なので gp とした
nnoremap gp :normal! `[<CR>


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
" - a は全体の意
" - m はメモ用ファイル
nnoremap <Leader>e. :e <C-r>=Curdir()<CR>
nnoremap <Leader>e/ :e<Space>
nnoremap <Leader>em :e <C-r>=Curdir()<CR>.memo<CR>
nnoremap <Leader>em. :e <C-r>=Curdir()<CR>.memo<CR>
nnoremap <Leader>em/ :e /srv/tmp/.memo<CR>
nnoremap <Leader>t. :tabnew <C-r>=Curdir()<CR>
nnoremap <Leader>t/ :tabnew<Space>
nnoremap <Leader>tm. :tabnew <C-r>=Curdir()<CR>.memo<CR>
nnoremap <Leader>tm/ :tabnew /srv/tmp/.memo<CR>


" ファイル/フォルダ ショートカット
" - vim からよくある操作は直下ファイル(f)/フォルダ(d)作成
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


" 変更可能
nnoremap <Leader>smy :set modifiable<CR>


" バッファ 一覧移動用
nnoremap <silent><Leader>b :ls<CR>:b<Space>


" マーク 一覧移動用
" - 当初 `<Leader>ml/h` にしていたが便宜上 `<Leader>l/h` に変更
" nnoremap <silent><Leader>mm :<C-u>marks<CR>:normal! `
" nnoremap <silent><Leader>ml :<C-u>call <SID>JumpMark(1)<CR>
" nnoremap <silent><Leader>mh :<C-u>call <SID>JumpMark(-1)<CR>
nnoremap <silent><Leader>m :<C-u>marks<CR>:normal! `
nnoremap <silent><Leader>l :<C-u>call <SID>JumpMark(1)<CR>
nnoremap <silent><Leader>h :<C-u>call <SID>JumpMark(-1)<CR>


" マーク 手動でのインクリメント採番
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>
nnoremap <silent>M :<C-u>call <SID>AutoMarkrementBig()<CR>


" oldfiles 一覧移動用
nnoremap <silent><Leader>o :browse :oldfiles<CR>


" Grep
" gr(ep)
nnoremap <Leader>gr :TRipGrep
nnoremap <Leader>gr<Space> :TRipGrep<Space>
nnoremap <Leader>grw :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'
nnoremap <Leader>grw<Space> :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<Space>
nnoremap <Leader>grw. :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<Space><C-r>=Curdir()<CR><CR>
" nnoremap <Leader>grw/ :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<CR>
nnoremap <Leader>gry :TRipGrep<Space>'<C-r>=@"<CR>'
nnoremap <Leader>gry<Space> :TRipGrep<Space>'<C-r>=@"<CR>'<Space>
nnoremap <Leader>gry. :TRipGrep<Space>'<C-r>=@"<CR>'<Space><C-r>=Curdir()<CR><CR>
" nnoremap <Leader>gry/ :TRipGrep<Space>'<C-r>=@"<CR>'<CR>
nnoremap <Leader>grg :MyTerm git grep<Space>


" 現バッファのファイル/フォルダ一覧
nnoremap <Leader>. :DirectoryFiles <C-r>=substitute(Curdir(), '/\.\./', '/', '')<CR> <C-r>=expand('%:t')<CR><CR>
nnoremap <Leader>f. :FindDirectoryFiles <C-r>=Curdir()<CR><Space>
nnoremap <Leader>f/ :FindDirectoryFiles <C-r>=getcwd()<CR><Space>
nnoremap <Leader>fg :FindGitFiles<Space>
nnoremap <Leader>fl :MovePostFile 'atime' <C-r>=expand('%')<CR><CR>
nnoremap <Leader>fh :MovePrevFile 'atime' <C-r>=expand('%')<CR><CR>


" 行番号を指定してファイル移動
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
" - git周りの情報出力
" - どうもnowrapが効かなくて改行されるので vsplit ではなくssplit で出力が無難
tnoremap <C-j> <C-\><C-n>
nnoremap <C-t> :MyTerm<Space>
nnoremap <Leader>gitll :MyTerm git log -p <C-r>=expand('%')<CR><CR>
nnoremap <Leader>gitl. :MyTerm git log -p <C-r>=expand('%:h')<CR><CR>
nnoremap <Leader>gitl/ :MyTerm git log -p<CR>
nnoremap <Leader>gitdd :MyTerm git diff <C-r>=expand('%')<CR><CR>
nnoremap <Leader>gitd. :MyTerm git diff <C-r>=expand('%:h')<CR><CR>
nnoremap <Leader>gitd/ :MyTerm git diff<CR>
nnoremap <Leader>gitst :MyTerm git status<CR>
nnoremap <Leader>gitgr :MyTerm git grep<Space>
command! -nargs=* -complete=file MyTerm wincmd v | terminal <args>
command! -nargs=* -complete=file MyTermSelf terminal <args>


" ヒューリスティック(便利機能案)
" " 別ファイル参照 / 画面分割してファイル一覧
nnoremap <Leader>r :wincmd v<CR>:DirectoryFiles <C-r>=Curdir()<CR> <C-r>=expand('%:t')<CR><CR>
nnoremap <Leader>j :wincmd v<CR>:DirectoryFiles <C-r>=substitute(expand('%:r'), '/\.\./', '/', '')<CR><CR>
" nnoremap <Leader>k :wincmd v<CR>:DirectoryFiles <C-r>=Curdir()<CR>../<CR>
nnoremap <Leader>k :wincmd v<CR>:e <C-r>=expand('%:h')<CR>.<C-r>=expand('%:e')<CR><CR>
" " 別ファイル移動 / 現フォルダの最後に変更したファイル
nnoremap <Leader>; :MovePostFile 'mtime' <C-r>=Curdir()<CR><CR>
" " 現在のファイル:行をファイル出力 (テスト利用)。
" " 結果も同一ファイルに書き込まれることを想定 // ...アナログ感
nnoremap <Leader>qw :WriteCurrentLine /srv/tmp/.test<CR>
nnoremap <Leader>qr :tabnew /srv/tmp/.test<CR>




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
" - 自動マーキング
"   ただし、マークを使った移動時(g:flug_mark_jump)は除く
augroup vimrc_inout_buffer
  autocmd!

  autocmd BufLeave * let b:linenr = line('.')
  autocmd BufWinEnter * if exists('b:linenr') | execute ':' . b:linenr | endif

  autocmd BufLeave * if &filetype == 'netrw' | let w:bnum_to_delete = bufnr('%') | endif
  autocmd BufWinEnter * if exists('w:bnum_to_delete') | execute 'bwipeout! ' . w:bnum_to_delete | endif
  autocmd BufWinEnter * if &filetype != 'netrw' | unlet! w:bnum_to_delete | endif

  autocmd BufNewFile,BufRead * if &filetype != 'netrw' && !g:flug_mark_jump | call s:AutoMarkrementBig() | endif
augroup END


" ファイルタイプ設定
augroup vimrc_my_filetypes
  autocmd!
  " autocmd BufNewFile,BufRead *.txt      set filetype=markdown
  autocmd BufNewFile,BufRead *.ruby     set filetype=ruby
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
  autocmd BufNewFile,BufRead *.html.heex set filetype=html
  " 下記を設定すると `:e term://ls` 等が表示されなくなる現象あり
  " autocmd TermOpen * set filetype=terminal
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


" メモ: .memo に書き出し
" - コードリーディング中の重要箇所
" - 消すと戻すのに手間取りそうな箇所
command! -nargs=1 -range Memo silent call s:Memo(<f-args>)
function! s:Memo(filepath) range
  let chk = getftype(a:filepath)
  if chk == ""
    execute '!echo "----" > ' . a:filepath
  endif

  let location = expand('%') . ':' . line('.')
  let sentence = ["", "```:" . location] + GetVisualSelection() + ["```", ""]
  call writefile(sentence, "/tmp/.memo")
  call system("cat " . a:filepath . " >> /tmp/.memo")
  call system("mv /tmp/.memo " . a:filepath)
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
  if !exists('g:markrement_pos_big')
    let g:markrement_pos_big = 0
  else
    let g:markrement_pos_big = (g:markrement_pos_big + 1) % len(g:markrement_bigchar)
  endif
  execute 'mark' g:markrement_bigchar[g:markrement_pos_big]
  echo 'marked' g:markrement_bigchar[g:markrement_pos_big]
endfunction


" マーキングジャンプ
if !exists('g:flug_jump')
  let g:flug_mark_jump = 0
endif

function! s:JumpMark(direction)
  let g:markrement_pos_big = (g:markrement_pos_big + a:direction) % len(g:markrement_bigchar)
  let l:marked_char = g:markrement_bigchar[g:markrement_pos_big]
  let g:flug_mark_jump = 1
  execute 'normal! `' . l:marked_char
  let g:flug_mark_jump = 0
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
command! -nargs=? -complete=file TRipGrep silent call s:TRipGrep(<f-args>)
function! s:TRipGrep(query)
  let l:from = Curdir()
  if getbufinfo(bufnr('%'))[0].changed
    w
  endif
  execute 'MyTermSelf rg -A 1 -B 1 ' . a:query
  let b:dir = l:from
endfunction


" 同フォルダファイル一覧
command! -nargs=* DirectoryFiles silent! call s:DirectoryFiles(<f-args>)
function! s:DirectoryFiles(...)
  if getbufinfo(bufnr('%'))[0].changed
    w
  endif
  execute 'e ' . a:1
  if exists('a:2')
    execute 'silent /' . a:2
  endif
endfunction


" find ファイル名検索
command! -nargs=* FindDirectoryFiles silent call s:FindDirectoryFiles(<f-args>)
function! s:FindDirectoryFiles(...)
  let l:from = Curdir()

  if getbufinfo(bufnr('%'))[0].changed
    w
  endif
  execute 'MyTermSelf find ' . a:1 . ' -name "*' . a:2 . '*"'
  let b:dir = l:from
endfunction


" find git管理下検索
command! -nargs=* FindGitFiles silent call s:FindGitFiles(<f-args>)
function! s:FindGitFiles(...)
  let l:from = Curdir()

  if getbufinfo(bufnr('%'))[0].changed
    w
  endif
  execute 'MyTermSelf git ls-files |grep ' . a:1
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

    if getbufinfo(bufnr('%'))[0].changed
      w
    endif
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

    if getbufinfo(bufnr('%'))[0].changed
      w
    endif
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


" 指定ファイルに現カーソル位置を出力
command! -nargs=1 WriteCurrentLine silent! call s:WriteCurrentLine(<f-args>)
function! s:WriteCurrentLine(filepath)
  execute ':redir! >' . a:filepath
  :silent! echon expand('%') . ':' . line('.')
  redir END
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


" 現visual領域取得
function! GetVisualSelection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    if lnum1 == 0 && lnum2 == 0 && col1 == 0 && col2 == 0
        return ''
    endif
    let lines[-1] = lines[-1][:col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return lines
endfunction
