
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

" エコシステム
Plug 'vim-denops/denops.vim'

" ランチャー / MRU
" - 外部スクリプト実行インターフェース
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-launcher'
Plug 'tacahiroy/ctrlp-funky'

" LSP 設定集/インストール用UI
Plug 'neovim/nvim-lsp'
Plug 'kabouzeid/nvim-lspinstall'

" コーディング
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tomtom/tcomment_vim'
Plug 'hrsh7th/vim-vsnip'
"   completion framework
Plug 'Shougo/ddc.vim'
"   completion sources
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'delphinus/ddc-tmux'
"   completion utils
Plug 'matsui54/denops-popup-preview.vim'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'

"   in elixir
Plug 'elixir-editors/vim-elixir'

"   in html
Plug 'mattn/emmet-vim'

" ユーティリティ
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'machakann/vim-sandwich'
Plug 'h1mesuke/vim-alignta'
Plug 'nelstrom/vim-visual-star-search'
Plug 'LeafCage/yankround.vim'
" Plug 't9md/vim-quickhl'

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
nmap gh <Plug>(easymotion-bd-w)
nmap gl <Plug>(easymotion-bd-jk)


" ctrlp
let g:ctrlp_map = '<Nop>'
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_lazy_update = 1
nnoremap <C-e> :<C-u>CtrlPLauncher<CR>
nnoremap <C-f> :<C-u>CtrlPMRUFiles<CR>
nnoremap <C-g> :<C-u>CtrlPFunky<CR>
" nnoremap <C-g> :execute 'CtrlPFunky ' . expand('<cword>')<CR>

" LSP
" - lspinstallを通して管理している言語をビルトインのLSPクライアントにsetup(通知)する

lua << EOF

-- Neovim doesn't support snippets out of the box, so we need to mutate the
-- capabilities we send to the language server to let them know we want snippets.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- A callback that will get called when a buffer connects to the language server.
-- Here we create any key maps that we want to have on that buffer.
local on_attach = function(_, bufnr)
  local function map(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local map_opts = {noremap = true, silent = true}

  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
  map("n", "<c-h>", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
end

--   elixir `:LspInstall eixir`
require'lspconfig'.elixirls.setup{
  cmd = { "/home/nvim/.local/share/nvim/lspinstall/elixir/elixir-ls/language_server.sh" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    elixirLS = {
      dialyzerEnabled = false,
    }
  }
}

require'lspinstall'.setup() -- important
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{}
end

-- require'lspconfig'.efm.setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
--   filetypes = {"elixir"}
-- })
EOF


" " treesitter
" " - 試用段階
" " - elixir が取れない様子
" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   ensure_installed = "all",   -- one of "all", "maintained" (parsers with maintainers), or a list of languages
"   ignore_install = {}, -- List of parsers to ignore installing
"   highlight = {
"     enable = true,              -- false will disable the whole extension
"     disable = {},  -- list of language that will be disabled
"   },
" }
" EOF


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


" ddc and other arounds

"   ddc sources
call ddc#custom#patch_global('sources', ['around', 'nvim-lsp', 'tmux'])

"   ddc settings
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ 'around': {'mark': 'A'},
      \ 'nvim-lsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ 'tmux': {'mark': 'T'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'nvim-lsp': {'kindLabels': {'Function': '', 'Keyword': '', 'Snippet': ''}},
      \ })

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()
call popup_preview#enable()


" yankround
nmap p <Plug>(yankround-p)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)


" mattn/emmet
let g:user_emmet_leader_key=',y'


" machakann/vim-sandwich
" およびその他ショートカット
nmap saiwc saiwfconsole.log<CR>
" " シンボル/アトムと文字列の切り替え
" " `:hoge` と `"hoge"`
nmap ,s:" bea:<Esc>sr:"
nmap ,s": sr":eex
" " 簡易的なマップキー変換ショートカット
" " `hoge:` と `"hoge" => `
nmap ,sk" bi"<Esc>elr"a =><Esc>
nmap ,sk: bhxelr:w3x
" " @spec 記述用 (elixir)
nmap ,s@spec yykpciw@spec<Esc>f(


" " vim-quickhl
" let g:quickhl_manual_keywords = [
"       \  { 'pattern': '\C\<\(TODO\|FIXME\|NOTE\|INFO\)\>', 'regexp': 1 },
"       \]
" nnoremap <C-h>e :<C-u>QuickhlManualEnable<CR>
" nnoremap <C-h>d :<C-u>QuickhlManualDisable<CR>
" nnoremap <C-h>a :<C-u>QuickhlManualAdd<Space>
