
" vim-plug
" - 先に#endまで記述しないと、例えば `lua require'hop'` 等がエラーになる
" ------------------------------------
call plug#begin('~/.config/nvim/plugged')

" カラースキーマ
Plug 'sjl/badwolf'

" カーソル移動
" Plug 'phaazon/hop.nvim'
Plug 'easymotion/vim-easymotion'

" コーディング
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tomtom/tcomment_vim'
Plug 'hrsh7th/vim-vsnip'

" ユーティリティ
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'tpope/vim-surround'
Plug 'h1mesuke/vim-alignta'
Plug 'nelstrom/vim-visual-star-search'
Plug 'LeafCage/yankround.vim'

call plug#end()
" ------------------------------------




" カラースキーマ
colorscheme badwolf


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


" yankround
nmap p <Plug>(yankround-p)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
