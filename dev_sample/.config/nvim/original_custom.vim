
" Utility
" -----------------------

" 自動リロードを有効化
set autoread
augroup vimrc_autoread
  autocmd!
  autocmd WinEnter * checktime
augroup END

" ファイルタイプ設定
augroup vimrc_variable_filetype
  autocmd!
  " autocmd BufNewFile,BufRead *.txt      set filetype=markdown
  autocmd BufNewFile,BufRead *.ruby     set filetype=ruby
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
augroup END



" Command
" -----------------------

" 日本語切り替え処理
inoremap <silent> <C-j> <Esc>

" CR で行を追加
nnoremap <CR> o<Esc>

" viminfo を使用したウインドウ間コピー
" および /tmp/yanked にヤンク内容を書き出す
" - なぜか空行が2つ入るため除去済み
vnoremap y y:wv<CR>:redir! > /tmp/yanked_tmp<CR>:silent echo getreg("0")<CR>:redir end<CR>:!sed -e '1,2d' -e '$d' /tmp/yanked_tmp > /tmp/yanked<CR>:redraw<CR>
" (以前sedで調整していたがinodeが変わってhost側のinotifywaitで検知できなくなるため没)
" vnoremap y y:wv<CR>:redir! > /tmp/yanked<CR>:silent echo getreg("0")<CR>:redir end<CR>:!sed -i -e '1,2d' /tmp/yanked<CR>:redraw<CR>

" ヤンクレジスタからの貼り付け
"   この操作時のみ(viminfoロードも行う)
nnoremap ,p :rv<CR>"0p

" command-mode での履歴移動のショートカット
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" ディレクトリパス表示のショートカット
" %:h -> %%
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Quickfix ショートカット
" " オープン
nnoremap <Leader>co :copen 30 <CR>
" " ファイル移動
nnoremap <Leader>cc :.cc <CR>

" ペースト
nnoremap <Leader>p :set paste<CR>i
autocmd InsertLeave * set nopaste

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
nnoremap <Leader>t :tabnew 

" ウィンドウ切り替え
nnoremap <Leader>h :execute 'wincmd h' <CR>
nnoremap <Leader>j :execute 'wincmd j' <CR>
nnoremap <Leader>k :execute 'wincmd k' <CR>
nnoremap <Leader>l :execute 'wincmd l' <CR>
nnoremap <Leader>v :execute 'wincmd v' <CR>
nnoremap <Leader>s :execute 'wincmd s' <CR>
nnoremap <Leader>e :e 


" 日付挿入 時刻挿入
let weeks = [ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ]
nnoremap ,t <Esc>$a<C-R>=strftime('%Y-%m-%d (').weeks[strftime("%w")].')'<CR><Esc>
"nnoremap ,iT <Esc>$a<C-R>=strftime('%m-%d')<CR><Esc>
"nnoremap ,ih <Esc>$a<C-R>=strftime('%H:%M')<CR><Esc>

" Silent処理
command! -nargs=1 Silent execute ':silent ! '.<q-args>|execute ':redraw!'


" バッファ一覧/移動
nnoremap <silent><Leader>bb :ls<CR>:b<Space>

" marks一覧/移動
nnoremap <silent><Leader>bm :<C-u>marks<CR>:normal! `

" 保存時の行末空白削除
" - 場合によっては必要なファイルもあるため拡張子が明確な場合は明示して除外
let ftToIgnore = ['vim']
autocmd BufWritePre * if index(ftToIgnore, &ft) < 0 | :%s/\s\+$//ge
" autocmd BufWritePre * :%s/\s\+$//ge
" autocmd BufWritePre *.{rb,ex,coffee,txt,md,js} :%s/\s\+$//ge


" Function
" -----------------------

" ファイルを開いた際に、以前のカーソル位置を復元する
function! s:RestoreCursorPostion()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup vimrc_restore_cursor_position
  autocmd!
  autocmd BufWinEnter * call s:RestoreCursorPostion()
augroup END


" タブに番号表示など
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


" マーキング自動化
" ref: http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
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

