
" -----------------------
" Command / Shortcut
" - 何かを読み書きする処理系は ,<KEY> のようにカンマを前置する(マイルール)
" - バッファ移動のための処理系も ctrl を使っていく
"   - grep: <C-g>
"   - fils: <C-f>
"   - current dir: <C-.>
" - 表示/非表示等の切り替え系は t(rue)/f(alse) を意図して t/f を使う
"   - 例えば行番号 表示/非表示は rt/rf を割り当てている
" -----------------------

" 日本語切り替え処理
" - デフォルトで <Esc>と<C-[>があるがやや押しにくい
inoremap <silent> <C-j> <Esc>


" CR で行を単純追加
nnoremap <CR> o<Esc>


" yank
" - いろいろするのでfunctionへ
vnoremap y y:MyYank<CR>


" paste
"
" viminfo読み込み
" - Vim間(コピー)ペースト用
nnoremap ,p :rv<CR>"0p


" set paste
" - Windows側クリップボードからの貼り付け時にautoindent等を防止
" - 抜けるときにset nopasteに自動で戻す
nnoremap <Leader>i :set paste<CR>i
autocmd InsertLeave * set nopaste


" 履歴移動
" - デフォルト
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>


" ディレクトリパス表示
" - % は表示しているファイル。%% でフォルダを展開
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'


" 新規バッファ
" - d はディレクトリの意
nnoremap <Leader>ee :e 
nnoremap <Leader>ed :e <C-r>=expand('%:h')<CR>/
nnoremap <Leader>es :execute 'wincmd s' <CR> :e 
nnoremap <Leader>ev :execute 'wincmd v' <CR> :e 
nnoremap <Leader>tt :tabnew 
nnoremap <Leader>td :tabnew <C-r>=expand('%:h')<CR>/


" ファイル/フォルダ ショートカット
" - vim からよくある操作は直下ファイル/フォルダ作成
nnoremap <Leader>cf :silent !touch <C-r>=expand('%:h')<CR>/
nnoremap <Leader>cd :silent !mkdir -p <C-r>=expand('%:h')<CR>/
nnoremap <Leader>df :silent !rm <C-r>=expand('%:h')<CR>/
nnoremap <Leader>dd :silent !rm -r <C-r>=expand('%:h')<CR>/


" タブ切り替え
nnoremap <Leader>1 :tabn1 <CR>
nnoremap <Leader>2 :tabn2 <CR>
nnoremap <Leader>3 :tabn3 <CR>
nnoremap <Leader>4 :tabn4 <CR>
nnoremap <Leader>5 :tabn5 <CR>
nnoremap <Leader>6 :tabn6 <CR>
nnoremap <Leader>7 :tabn7 <CR>
nnoremap <Leader>8 :tabn8 <CR>
nnoremap <Leader>9 :tabn9 <CR>


" ウィンドウ分割系
nnoremap <Leader>h :execute 'wincmd h' <CR>
nnoremap <Leader>j :execute 'wincmd j' <CR>
nnoremap <Leader>k :execute 'wincmd k' <CR>
nnoremap <Leader>l :execute 'wincmd l' <CR>
nnoremap <Leader>v :execute 'wincmd v' <CR>
nnoremap <Leader>s :execute 'wincmd s' <CR>


" 日付挿入 時刻挿入
let weeks = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
nnoremap ,tt <Esc>$a<C-R>=strftime('%Y-%m-%d (').weeks[strftime("%w")].')'<CR><Esc>
nnoremap ,tm <Esc>$a<C-R>=strftime('%m-%d')<CR><Esc>
nnoremap ,th <Esc>$a<C-R>=strftime('%H:%M')<CR><Esc>


" 行番号 表示/非表示
nnoremap <Leader>rt :set number<CR>
nnoremap <Leader>rf :set nonumber<CR>



" バッファ 一覧移動用
nnoremap <silent><C-b> :ls<CR>:b<Space>


" マーク 一覧移動用
nnoremap <silent><C-m> :<C-u>marks<CR>:normal! `


" oldfiles 一覧移動用
" - TODO: <C-o>はつぶせない
" nnoremap <silent><C-o> :browse :oldfiles



" quickfix 関係
nnoremap <Leader>ql :lopen<CR>:set modifiable<CR>
nnoremap <Leader>qc :copen<CR>:set modifiable<CR>
nnoremap <Leader>qq :cclose<CR>:lclose<CR>
nnoremap <C-g> :MyRg 
"   行数を指定したgt
nnoremap <Leader>gn :OpenFileAtLine 
nnoremap <Leader>gt :OpenFileAtLineWithTab 


" -----------------------
" Auto Command
" - autocmd はファイルを読むたびに登録される
" - 複数回の読み込みで上書きされるように、augroupで囲み、削除と追加を記述すること
" -----------------------

" ファイルタイプ設定
"
augroup vimrc_my_filetypes
  autocmd!
  " autocmd BufNewFile,BufRead *.txt      set filetype=markdown
  autocmd BufNewFile,BufRead *.ruby     set filetype=ruby
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
augroup END


" 保存時の行末空白削除
" - 場合によっては必要なファイルもあるため拡張子が明確な場合は明示して除外
augroup vimrc_remove_tailspaces
  autocmd!
  let ignores = ['vim']
  autocmd BufWritePre * if index(ignores, &ft) < 0 | :%s/\s\+$//ge
augroup END


" カーソル位置復元
" - ファイルを開いた際に、以前のカーソル位置を復元する
augroup vimrc_restore_cursor_position
  autocmd!
  autocmd BufWinEnter * call s:RestoreCursorPostion()
augroup END


" quickfix
augroup vimrc_quickfix_open
  autocmd!
  " TODO: コマンド化
  autocmd QuickFixCmdPost lgrep vs | lopen | execute 'wincmd k'| q | execute 'wincmd w' | set modifiable
  autocmd QuickFixCmdPost make,grep copen
augroup END




" -----------------------
" Function
" -----------------------

" Yank に付随する追加処理用
" - Vim間コピーのため、viminfo に書き出し (`wv`)
" - WSLでのホストへのコピーのため、/tmp/yanked に書き出し
command! -range MyYank call s:MyYank()
function! s:MyYank() range
  wv
  redir! > ~/.yanked
  silent echo getreg("0")
  redir end
  !sed -e '1,1d' ~/.yanked > /tmp/yanked
  redraw
endfunction


" カーソル位置を最後の編集位置へ
function! s:RestoreCursorPostion()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
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

nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>
function! s:AutoMarkrement()
  if !exists('b:markrement_pos')
    let b:markrement_pos = 0
  else
    let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
  endif
  execute 'mark' g:markrement_char[b:markrement_pos]
  echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

nnoremap <silent>M :<C-u>call <SID>AutoMarkrementBig()<CR>
function! s:AutoMarkrementBig()
  if !exists('b:markrement_pos_big')
    let b:markrement_pos_big = 0
  else
    let b:markrement_pos_big = (b:markrement_pos_big + 1) % len(g:markrement_bigchar)
  endif
  execute 'mark' g:markrement_bigchar[b:markrement_pos_big]
  echo 'marked' g:markrement_bigchar[b:markrement_pos_big]
endfunction



" ファイル検索
" see: https//maxmellon.hateblo.jp/entry/2016/12/25/165545
" - 一時的に :grep 処理を変更することでquickfixに書き込むようにしている
" - 用途として locatonlist を使用
command! -nargs=? MyRg call s:RipGrep(<f-args>)
function! s:RipGrep(query)
  let l:current_grep = &grepprg " 設定値の保存
  setlocal grepprg=rg\ --vimgrep
  setlocal grepformat=%f " format指定がうまくいかない :h error-file-format
  execute 'silent lgrep! ' . a:query
  let &grepprg = l:current_grep
  redraw!
endfunction

" quickfix 行番号を指定ファイルオープン
command! -nargs=? OpenFileAtLine call s:OpenFileAtLine(<f-args>)
function! s:OpenFileAtLine(query)
  let l:line = getline(a:query)
  let l:file = split(l:line, ':')[0]
  echo l:file
  execute "lclose | e " . l:file
endfunction

" quickfix 行番号を指定ファイルオープン（新規タブ）
command! -nargs=? OpenFileAtLineWithTab call s:OpenFileAtLineTab(<f-args>)
function! s:OpenFileAtLineTab(query)
  let l:line = getline(a:query)
  let l:file = split(l:line, ':')[0]
  echo l:file
  execute "lclose | tabnew " . l:file
endfunction
