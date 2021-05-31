
" vim-plug
" - 先に#endまで記述しないと、例えば `lua require'hop'` 等がエラーになる
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')

" カラースキーマ
" Plug 'sjl/badwolf'
Plug 'cocopon/iceberg.vim'

" カーソル移動
" Plug 'phaazon/hop.nvim'
Plug 'easymotion/vim-easymotion'

" ランチャー / MRU
" - 外部スクリプト実行インターフェース
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-launcher'

" コーディング
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tomtom/tcomment_vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" ユーティリティ
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'tpope/vim-surround'
Plug 'h1mesuke/vim-alignta'
Plug 'nelstrom/vim-visual-star-search'
Plug 'LeafCage/yankround.vim'

call plug#end()
" ------------------------------------




" カラー
" colorscheme badwolf
colorscheme iceberg


" カラー / iceberg
" - 暗い紫がみにくいのでmagentaにする
" - コメントはむしろ目立つほうがいい(試用)。区切りにもなっている
" - TODO: rg結果がみにくいけれどどの色かわからない(terminal_color_Nとは違った)
" https://github.com/cocopon/iceberg.vim/blob/master/colors/iceberg.vim
" https://oki2a24.com/2019/02/15/make-mintty-theme-like-iceberg/
highlight Constant ctermfg=magenta
highlight Comment ctermfg=245
highlight LineNr ctermfg=245



" hop
" - easymotionより軽いらしい(未計)
" - 日本語に対応していない
" nnoremap s :HopWord<CR>
" nnoremap gl :HopLine<CR>
" lua require'hop'.setup { keys = 'etovxqpdygfblzhckisura', term_seq_bias = 0.5 }


" vim-easymotion
let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap s <Plug>(easymotion-bd-w)
nmap gl <Plug>(easymotion-bd-jk)


" ctrlp
let g:ctrlp_map = '<Nop>'
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_lazy_update = 1
nnoremap <C-e> :<C-u>CtrlPLauncher<CR>
nnoremap <C-f> :<C-u>CtrlPMRUFiles<CR>


" treesitter
" - 試用段階
" - elixir が取れない様子
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",   -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}
EOF


" vim-vsnip
" samples: https://github.com/rafamadriz/friendly-snippets/tree/main/snippets
imap <expr> <C-l>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-l>'
smap <expr> <C-l>   vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-l>'
imap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" deoplete
let g:deoplete#enable_at_startup = 1


" yankround
nmap p <Plug>(yankround-p)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
