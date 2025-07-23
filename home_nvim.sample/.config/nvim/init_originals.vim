" 背景の思想
"
" - タブは `gt``gT` で扱えるように1~2つ程度を使用する
"   多用するとタブで開くかどうかの選択でショートカットが増えすぎる
" - ウィンドウ分割は <C-w> を素直に使用する
" - tmux(byobu)の利用を前提としている
" - コーディング中に一時的にコードを退避させることがよくある
"   .memo をさくっと開けるほうがいい


" Command / Shortcut ルール
"
" - 何かバッファに対して挿入する処理系は ,<KEY> のようにカンマを前置する(マイルール)
" - 表示/非表示等の切り替え系は s(et)*y(es)/s(et)*n(o) を意図して y/n を使う
"   - 例えば、行番号の表示/非表示は s(et)n(umber)y(es)/s(et)n(umber)n(o) を割り当てている
" - 現バッファのフォルダはピリオド(.)、カレントディレクトリはスラッシュ(/)を用いる
"   - 例えば、`:edit %:h` は `e.` で `:edit ./` は `e/`


" Leader or Ctrl
"
" - 基本的にLeaderに割り当てる


" 切り替え処理
" - デフォルトで <Esc>と<C-[>があるがやや押しにくい
inoremap <silent> <C-j> <Esc>


" CR で行を単純追加
nnoremap <CR> o<Esc>


" yank
" - visualモード時はclipboardに連携
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
nnoremap <Leader>o :set paste<CR>o
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
nnoremap <Leader>t. :tabnew <C-r>=Curdir()<CR><CR>
nnoremap <Leader>t/ :tabnew<Space>
nnoremap <Leader>tf :tabnew %<CR>
nnoremap <Leader>tm. :tabnew <C-r>=Curdir()<CR>.memo<CR>
nnoremap <Leader>tm/ :tabnew /srv/tmp/.memo<CR>


" タブ移動ショートカット
" あまり増やしても操作性が落ちるので最大で３に絞る
nnoremap <Leader>t1 :tabn 1<CR>
nnoremap <Leader>t2 :tabn 2<CR>
nnoremap <Leader>t3 :tabn 3<CR>


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
nnoremap <silent><Leader>m :<C-u>marks<CR>:normal! `
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>


" oldfiles 一覧移動用
" "   ctrlp を使うようにしたので廃止
" nnoremap <silent><Leader>o :browse :oldfiles<CR>


" Ctrl+w+fとgfの動作をF相当に変更
nnoremap gf gF
nnoremap <C-W>f <C-W>F


" Grep
" gr(ep)
nnoremap <Leader>gr :TRipGrep
nnoremap <Leader>gr<Space> :TRipGrep<Space>
nnoremap <Leader>gw :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<Space>
nnoremap <Leader>gw<Space> :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<Space>
nnoremap <Leader>gw. :tabnew<CR>:TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<Space><C-r>=Curdir()<CR><CR>
nnoremap <Leader>gwg :MyTermTab git grep -n '<C-r>=expand('<cword>')<CR>'<CR>
" nnoremap <Leader>grw/ :TRipGrep<Space>'<C-r>=expand('<cword>')<CR>'<CR>
nnoremap <Leader>gy :TRipGrep<Space>'<C-r>=@"<CR>'
nnoremap <Leader>gy<Space> :TRipGrep<Space>'<C-r>=@"<CR>'<Space>
nnoremap <Leader>gy. :TRipGrep<Space>'<C-r>=@"<CR>'<Space><C-r>=Curdir()<CR><CR>
nnoremap <Leader>gyg :MyTermTab git grep -n '<C-r>=@"<CR>'<CR>
" nnoremap <Leader>gry/ :TRipGrep<Space>'<C-r>=@"<CR>'<CR>
nnoremap <Leader>gg :MyTermTab git grep -n<Space>


" 現バッファのファイル/フォルダ一覧
nnoremap <Leader>. :DirectoryFiles <C-r>=substitute(Curdir(), '/\.\./', '/', '')<CR> <C-r>=expand('%:t')<CR><CR>
nnoremap <Leader>f. :FindDirectoryFiles <C-r>=Curdir()<CR><Space>
nnoremap <Leader>f/ :FindDirectoryFiles <C-r>=getcwd()<CR><Space>
nnoremap <Leader>fg :FindGitFiles<Space>
nnoremap <Leader>gf :FindGitFiles<Space>


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
command! -nargs=* -complete=file MyTerm silent wincmd v | terminal <args>
command! -nargs=* -complete=file MyTermSelf silent terminal <args>
command! -nargs=* -complete=file MyTermTab silent tabnew | terminal <args>
" - git周りの情報出力
" - どうもnowrapが効かなくて改行されるので vsplit ではなくssplit で出力が無難
tnoremap <C-j> <C-\><C-n>
nnoremap <C-t> :MyTerm<Space>
nnoremap <Leader>gitll :MyTermTab git log -p <C-r>=expand('%')<CR><CR>
nnoremap <Leader>gitl. :MyTermTab git log -p <C-r>=expand('%:h')<CR><CR>
nnoremap <Leader>gitl/ :MyTermTab git log -p<CR>
nnoremap <Leader>gitdd :MyTermTab git diff <C-r>=expand('%')<CR><CR>
nnoremap <Leader>gitd. :MyTermTab git diff <C-r>=expand('%:h')<CR><CR>
nnoremap <Leader>gitd/ :MyTermTab git diff<CR>
nnoremap <Leader>gitst :MyTermTab git status<CR>
nnoremap <Leader>gitgr :MyTermTab git grep -n<Space>
nnoremap <Leader>gitbl :MyTermTab git blame <C-r>=expand('%')<CR><CR>
nnoremap <Leader>gitsh :MyTermTab git show <C-r>=expand('<cword>')<CR><CR>

" ヒューリスティック(便利機能案)
" " 別ファイル参照 / 画面分割してファイル一覧
nnoremap <Leader>r :wincmd v<CR>:DirectoryFiles <C-r>=Curdir()<CR> <C-r>=expand('%:t')<CR><CR>
nnoremap <Leader>j :wincmd v<CR>:DirectoryFiles <C-r>=substitute(expand('%:r'), '/\.\./', '/', '')<CR><CR>
" nnoremap <Leader>k :wincmd v<CR>:DirectoryFiles <C-r>=Curdir()<CR>../<CR>
nnoremap <Leader>k :e <C-r>=expand('%:h')<CR>.<C-r>=expand('%:e')<CR><CR>

" " 現在のファイル:行をファイル出力 (自動テスト用途)
" " 結果も同一ファイルに書き込まれることを想定 // ...アナログ感
nnoremap t: :WriteCurrentLine tmp/.test<CR>
nnoremap t. :WriteCurrentFile tmp/.test<CR>
nnoremap <Leader>to :terminal watch -n 1 -c cat tmp/.output<CR>

" " ヘルプ ショートカット
nnoremap <Leader>h :Help<Space>

" " 関数の頭を大文字に変換するショートカット
" " hoge.foo.bar => Hoge.Foo.Bar
" " hoge.foo_bar => Hoge.FooBar
inoremap <C-u> <C-o>:call ConvertToModuleInsertMode()<CR>

" " Elixir 関数チェイン変換
nnoremap cfc :call ConvertToChain()<CR>
nnoremap cfi :call ConvertToNonChain()<CR>

" " Claude Code
nnoremap <Leader>cp :terminal claude -p
nnoremap <Leader>cc :terminal claude -p -c 
" " direction from Neovim
nnoremap <Leader>co :call <SID>OpenOrReloadDirection()<CR>
nnoremap <Leader>chf :silent SendListWindowFiles<CR>
nnoremap <Leader>chm :silent SendDirection 
vnoremap <Leader>chm :silent <C-u>SendDirectionV 
nnoremap <Leader>chd :silent SendDirection 慎重に解説してください<CR>
vnoremap <Leader>chd :silent <C-u>SendDirectionV 慎重に解説してください<CR>
nnoremap <Leader>chc :silent SendDirection 該当部分の下書き（あるいはメモ）に従って、その意図することを成してください<CR>
vnoremap <Leader>chc :silent <C-u>SendDirectionV 該当部分の下書き（あるいはメモ）の不備や欠損、不足を補って意図することを成してください<CR>


" " 共通
" 同名のmap value挿入が多いので@vで補完する
" もっと良いものが欲しいが暫定として使用する
nnoremap @v :execute "normal! 0f:Bhvt:yf:pa,"<CR>



" -----------------------
" Auto Command
" - autocmd はファイルを読むたびに登録される
" - 複数回の読み込みで上書きされるように、augroupで囲み、削除と追加を記述すること
" -----------------------

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

  autocmd WinEnter * checktime
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

function! s:AutoMarkrement()
  if !exists('b:markrement_pos')
    let b:markrement_pos = 0
  else
    let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
  endif
  execute 'mark' g:markrement_char[b:markrement_pos]
  echo 'marked' g:markrement_char[b:markrement_pos]
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


" 指定ファイルに現カーソル位置を出力
command! -nargs=1 WriteCurrentLine silent! call s:WriteCurrentLine(<f-args>)
function! s:WriteCurrentLine(filepath)
  execute ':redir! >' . a:filepath
  :silent! echon expand('%:.') . ':' . line('.')
  redir END
endfunction


" 指定ファイルに現ファイルを出力
command! -nargs=1 WriteCurrentFile silent! call s:WriteCurrentFile(<f-args>)
function! s:WriteCurrentFile(filepath)
  execute ':redir! >' . a:filepath
  :silent! echon expand('%:.')
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


" コード等のメモ群を参照するための方法
command -nargs=+ Help silent! call s:FindHelpFiles(<f-args>)

function! s:FindHelpFiles(...)
  let search_terms = a:000
  let search_dir = "~/.help/"
  let search_expr = "-path '*".join(search_terms, "*")."*'"

  let find_cmd = "find ".search_dir." ".search_expr." -print -type f"
  let files = split(system(find_cmd), "\n")
  let size = len(files)

  if size > 0 && size <= 4
    for file in files
      tabnew
      execute "edit " . fnameescape(file)
    endfor
  endif

  if size == 0
    echo "No matching files found."
  endif

  if size != 0 && size > 4
    echo "".size." matching files found. Open first one only."
    tabnew
    execute "edit " . files[0]
  endif
endfunction


" 関数形式に変換する処理
" created by ChatGPT(v4)
function! ConvertToModuleInsertMode()
  let l:col = col('.')
  call feedkeys("\<Esc>", 'n')
  call ConvertToModule()
  call cursor(line('.'), l:col)
  startinsert
endfunction

function! ConvertToModule()
  let l:cword = expand('<cWORD>')
  let l:words = split(l:cword, '\.')
  let l:result = []

  for l:word in l:words
    let l:subwords = split(l:word, '_')
    let l:subresult = []

    for l:subword in l:subwords
      let l:titlecased = toupper(substitute(l:subword[0], '\(\k\)', '\u\1', '')) . l:subword[1:]
      call add(l:subresult, l:titlecased)
    endfor

    call add(l:result, join(l:subresult, ''))
  endfor

  normal! diW
  execute "normal! a" . join(l:result, '.')
endfunction


" Elixirで関数をチェイン形式に変換
" created by ChatGPT(v4)
function! ConvertToChain()
  let line = getline('.')
  let indent = matchstr(line, '^\s*')
  let open_paren = stridx(line, '(')
  let close_paren = strridx(line, ')')
  let func_name = strpart(line, strlen(indent), open_paren - strlen(indent))
  let args = strpart(line, open_paren + 1, close_paren - open_paren - 1)

  let first_arg = GetFirstArgument(args)
  let remaining_args = strpart(args, len(first_arg) + 1)
  let remaining_args = substitute(remaining_args, '^\s*', '', '')

  if remaining_args != ''
    let remaining_args .= ')'
  endif

  let chain_first_line = indent . first_arg
  let chain_second_line = indent . "|> " . func_name . '(' . remaining_args

  call setline('.', chain_first_line)
  call append(line('.'), chain_second_line)
endfunction

function! GetFirstArgument(args)
  let depth = 0
  let curly_depth = 0
  let square_depth = 0
  let i = 0
  while i < len(a:args)
    let ch = a:args[i]
    if ch == ',' && depth == 0 && curly_depth == 0 && square_depth == 0
      return strpart(a:args, 0, i)
    elseif ch == '('
      let depth += 1
    elseif ch == ')'
      let depth -= 1
    elseif ch == '{'
      let curly_depth += 1
    elseif ch == '}'
      let curly_depth -= 1
    elseif ch == '['
      let square_depth += 1
    elseif ch == ']'
      let square_depth -= 1
    endif
    let i += 1
  endwhile
  return a:args
endfunction

" Elixirで関数をチェイン形式からまとめる
" created by ChatGPT(v4)
function! ConvertToNonChain()
  " 現在行と次の行を取得
  let line1 = getline('.')
  let line2 = getline(line('.') + 1)

  " 現在行のインデントを取得
  let indent = matchstr(line1, '^\s*')

  " '|>' が次の行に存在するか確認
  if stridx(line2, '|>') == -1
    echo "次の行にはチェーン記法 '|>' が見つかりません。"
    return
  endif

  " '|>' 以降のテキストを取得
  let chained_call = matchstr(line2, '|>\s*\zs.*')

  " 関数名と引数を分割
  let open_paren_idx = stridx(chained_call, '(')
  let close_paren_idx = strridx(chained_call, ')')
  let func_name = strpart(chained_call, 0, open_paren_idx)
  let args = strpart(chained_call, open_paren_idx + 1, close_paren_idx - open_paren_idx - 1)

  " 現在行のインデントを削除
  let line1 = substitute(line1, '^\s*', '', '')

  " 非チェーン記述を生成
  let non_chained_call = func_name . '(' . line1
  if len(args) > 0
    let non_chained_call .= ', ' . args . ')'
  else
    let non_chained_call .= ')'
  endif

  " インデントを追加
  let non_chained_call = indent . non_chained_call

  " 現在行を非チェーン記述に更新し、次の行を削除
  call setline('.', non_chained_call)
  execute (line('.') + 1) . 'delete'
  call cursor(line('.') - 1, len(indent) + 1)
endfunction


" Claude Direction

" " tmp/directionファイルへの書き込み関数
function! s:WriteToDirection(content)
  if !isdirectory('tmp')
    call mkdir('tmp', 'p')
  endif
  call writefile([a:content], 'tmp/direction')
  echo 'Written to tmp/direction'
endfunction

function! s:SendListWindowFiles()
  let files = []
  for winnr in range(1, winnr('$'))
    let bufnr = winbufnr(winnr)
    let filename = bufname(bufnr)
    if filename != ''
      call add(files, '@' . fnamemodify(filename, ':p'))
    endif
  endfor
  
  if len(files) > 0
    call s:WriteToDirection(join(files, ' '))
  else
    echo 'No files found in current tab'
  endif
endfunction

" " 現在の位置情報を取得する関数
function! s:GetLocationInfo(mode)
  let filename = expand('%:p')
  
  if a:mode ==# 'v' || a:mode ==# 'V'
    let start_line = line("'<")
    let end_line = line("'>")
  else
    let start_line = line('.')
    let end_line = start_line
  endif
  
  if start_line == end_line
    return filename . ':' . start_line
  else
    return filename . ':' . start_line . '-' . end_line
  endif
endfunction

" " SendDirectionコマンドの実装
function! s:SendDirection(instruction, mode)
  if &modified
    " よく忘れるので現在のバッファを保存
    write
  endif

  let location = s:GetLocationInfo(a:mode)
  let content = location . ' ' . a:instruction
  call s:WriteToDirection(content)
endfunction

"" tmp/directionを開く/再読み込みする
function! s:OpenOrReloadDirection()
  let direction_file = 'tmp/direction'
  let winnr = bufwinnr(direction_file)
  
  if winnr != -1
    " 既に開いている場合は再読み込み
    execute winnr . 'wincmd w'
    edit!
    echo 'Reloaded tmp/direction'
  else
    " 開いていない場合は新規で開く
    if filereadable(direction_file)
      execute 'vsplit ' . direction_file
      setlocal autoread
      echo 'Opened tmp/direction with autoread'
    else
      echo 'tmp/direction not found'
    endif
  endif
endfunction

" " コマンド定義
command! -nargs=1 SendDirection call s:SendDirection(<q-args>, mode())
command! -nargs=1 SendDirectionV call s:SendDirection(<q-args>, 'v')
command! SendListWindowFiles call s:SendListWindowFiles()

