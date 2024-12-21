
" ------------------------------------
" vim-plug
" - 先に#endまで記述しないと、例えば `lua require'hop'` 等がエラーになる
call plug#begin('~/.config/nvim/plugged')

" カラースキーマ
" Plug 'sjl/badwolf'
Plug 'cocopon/iceberg.vim'

" カーソル移動
Plug 'easymotion/vim-easymotion'

" エコシステム deno
Plug 'vim-denops/denops.vim'

" ランチャー / MRU
" - 外部スクリプト実行インターフェース
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-launcher'
Plug 'tacahiroy/ctrlp-funky'

" コーディング

" -- 構文
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" -- コメントアウト
Plug 'tomtom/tcomment_vim'

" -- ユーティリティ
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'machakann/vim-sandwich'
Plug 'h1mesuke/vim-alignta'
Plug 'nelstrom/vim-visual-star-search'
Plug 'LeafCage/yankround.vim'

" -- スニペット
Plug 'hrsh7th/vim-vsnip'

" -- lang elixir
Plug 'elixir-editors/vim-elixir'

" -- lang html
Plug 'mattn/emmet-vim'


" LSP 設定
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'


" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'


" markdown
" markdown-preview mermaidjsが古いので別途取得必要
"
"   cd ~/.config/nvim/plugged/markdown-preview.nvim/app/_static/
"   wget https://cdn.jsdelivr.net/npm/mermaid@10.2.1/dist/mermaid.min.js
"   and do `:call mkdp#util#install()` if not work.
"
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

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

" -- cmp
highlight CmpItemAbbr ctermfg=245
highlight CmpItemAbbrMatch ctermfg=245
highlight CmpItemAbbrMatchFuzzy ctermfg=245
highlight CmpItemKind ctermfg=245


" vim-easymotion
let g:EasyMotion_do_mapping = 0 "Disable default mappings
let g:EasyMotion_keys='h;klyuiopnm,wertcvbasdgjf'
nmap gh <Plug>(easymotion-bd-w)
nmap gl <Plug>(easymotion-bd-jk)


" ctrlp
let g:ctrlp_map = '<Nop>'
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_lazy_update = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_mruf_relative = 1
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'

" let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|.git'
nnoremap <C-e> :<C-u>CtrlPLauncher<CR>
nnoremap <C-f> :<C-u>CtrlPMRUFiles<CR>
nnoremap <C-g> :<C-u>CtrlPFunky<CR>
" nnoremap <C-g> :execute 'CtrlPFunky ' . expand('<cword>')<CR>


" treesitter
" - 試用段階
" - elixir はいまいちか...?
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {"vim", "markdown", "elixir", "ruby"},
  -- List of parsers to ignore installing
  ignore_install = {},
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = {}
  }
}
EOF


" yankround
nmap p <Plug>(yankround-p)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)


" machakann/vim-sandwich
"
" -- console.log
nmap saiwc saiwfconsole.log<CR>

" -- シンボル/アトムと文字列の切り替え
" " `:hoge` <=> `"hoge"`
" " 次の書き方がエラーになる/ nmap ,s :call setreg('a', 'F:r"ea"')
nmap ,s:" F:r"ea"<Esc>
nmap ,s": sr":f:x

" -- 簡易的なマップキー変換ショートカット
" " `hoge:` と `"hoge" => `
nmap ,sk" ebi"<Esc>f:r"a =><Esc>
nmap ,sk: ebhxelr:w3x

" -- 関数前の @spec 記述 (elixir)
nmap ,s@spec yykpciw@spec<Esc>f(


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



" mattn/emmet
" usage: ',y,'
let g:user_emmet_leader_key=',y'


" LSP
" - lspinstallを通して管理している言語をビルトインのLSPクライアントにsetup(通知)する

lua << EOF

-- setup config

require('mason').setup()
require('mason-lspconfig').setup()

-- completion

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
  }),
  window = {
    completion = {
      winhighlight = "Normal:CmpNormal",
    },
    documentation = {
      winhighlight = "Normal:CmpDocNormal",
    }
  }
})

-- lang

local home = vim.fn.getenv("HOME")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(_client, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = {noremap = true, silent = true}

  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", map_opts)
  map("n", "<c-h>", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
  map("n", "<space>f", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", map_opts)
  map("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<cr>", map_opts)
end

-- lang: elixir `:LspInstall eixir`

require'lspconfig'.elixirls.setup{
  cmd = { home .. "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
    }
  }
}

EOF

