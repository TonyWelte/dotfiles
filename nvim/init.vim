" Set encoding to UTF-8
set encoding=utf-8

" Set colorsheme
syntax on
set t_Co=256
colorscheme molokai
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" Remove arrow keys binding
nnoremap <up> <Nop>
nnoremap <down> <Nop>
nnoremap <left> <Nop>
nnoremap <right> <Nop>


inoremap <up> <Nop>
inoremap <down> <Nop>
inoremap <left> <Nop>
inoremap <right> <Nop>

vnoremap <up> <Nop>
vnoremap <down> <Nop>
vnoremap <left> <Nop>
vnoremap <right> <Nop>

nnoremap <C-t> :tabnew<cr>
"Navigating with guides
" inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
" vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
" map <Space><Tab> <Esc>/<++><Enter>"_c4l

"For split navigation
map <C-h> <C-w>h
let g:Ctrl_j = 'off'
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Line number
set number relativenumber

" Cursor style in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Plugins
call plug#begin('~/.config/nvim/plugged')
" Auto complete
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Linter
Plug 'w0rp/ale'
" Markdown
Plug 'euclio/vim-markdown-composer'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rhysd/vim-grammarous'
" Latex
Plug 'donRaphaco/neotex'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" NERDTree
Plug 'scrooloose/nerdtree'

call plug#end()

" Plugin config
" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 0
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-3.8/lib/clang'
" ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" Python linter
let g:ale_python_flake8_options = '--ignore E221,E226'
" Airline 
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" NERD tree
map <c-t> :NERDTreeToggle<CR>
" Markdown
let g:markdown_composer_external_renderer ='pandoc -t html --standalone -m'
let g:markdown_composer_browser = 'firefox -new-window'
let g:markdown_composer_refresh_rate = 0
augroup pandoc_syntax
	au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
let g:pandoc#syntax#conceal#use = 0
