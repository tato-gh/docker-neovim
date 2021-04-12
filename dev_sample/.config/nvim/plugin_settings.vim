call plug#begin('~/.config/nvim/plugged')

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"   coc-fzf-preview
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" utilities
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'h1mesuke/vim-alignta'
Plug 'nelstrom/vim-visual-star-search'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'LeafCage/yankround.vim'
Plug 'hrsh7th/vim-vsnip'

" launcher
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-launcher'

" filer
Plug 'Shougo/defx.nvim'
" Plug 'mattn/vim-molder'

" for services
Plug 'rhysd/git-messenger.vim'

" languages
Plug 'elixir-editors/vim-elixir'

" color scheme
Plug 'sjl/badwolf'

call plug#end()

colorscheme badwolf


" Coc
"   ref: https://github.com/yuki-ycino/fzf-preview.vim#coc-extensions-2
" -----------------------
let g:fzf_preview_floating_window_rate = 0.9
nnoremap <silent> <Leader>f  :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> <Leader>m  :<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <Leader>tm :tabnew<CR>:<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <Leader>;  :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> <Leader>gf :<C-u>CocCommand fzf-preview.FromResources git<CR>
nnoremap <silent> <Leader>gs :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Leader>ga :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <Leader>gl :<C-u>CocCommand fzf-preview.GitLogs<CR>
nnoremap <silent> <Leader>gr :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap <silent> <Leader>gw :<C-u>CocCommand fzf-preview.ProjectGrep<Space><C-r>=expand('<cword>')<CR><CR>
nnoremap <silent> <Leader>gy :<C-u>CocCommand fzf-preview.ProjectGrep<Space><C-r>=@"<CR><CR>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)


" Easy Motion
" -----------------------
let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap s <Plug>(easymotion-bd-w)
nmap <C-l> <Plug>(easymotion-bd-jk)

" yankround
" -----------------------
nmap p <Plug>(yankround-p)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" git-messenger.vim
" -----------------------
nmap <C-w>m <Plug>(git-messenger)
let g:git_messenger_always_into_popup = v:true

" defx
" NOTE :UpdateRemotePlugins
" -----------------------
" nnoremap <silent> <Leader>e :<C-u> Defx <CR>
nnoremap <silent><Leader>d  :<C-u>Defx `expand('%:p:h')`<CR>
nnoremap <silent><Leader>td :tabnew %<CR>:<C-u>Defx `expand('%:p:h')`<CR>
autocmd FileType defx call s:defx_my_settings()
call defx#custom#option('_', {
      \ 'split': 'no',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': 'exlorer',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ })

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR> defx#is_directory() ? defx#do_action('open_tree', 'recursive:2') : defx#do_action('open')
  nnoremap <silent><buffer><expr> t defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> o defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> C defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> c defx#do_action('new_file')
  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> h defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> r defx#do_action('redraw')
  nnoremap <silent><buffer><expr> p defx#do_action('preview')
  nnoremap <silent><buffer><expr> v defx#do_action('open', 'vsplit')
endfunction

" ctrlp
let g:ctrlp_map = '<Nop>'
nnoremap <c-e> :<c-u>CtrlPLauncher<cr>

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

" vim-elixir
let g:elixir_fold = 0
