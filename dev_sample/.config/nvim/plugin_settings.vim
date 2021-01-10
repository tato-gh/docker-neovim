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
nnoremap <silent> <Leader>f  :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> <Leader>m  :<C-u>CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent> <Leader>n  :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> <Leader>gs :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <Leader>ga :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <Leader>g; :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> <Leader>gr :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
nnoremap <silent> <Leader>/  :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> <Leader>*  :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>



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
