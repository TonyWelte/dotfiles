" Set colorsheme
syntax on
set t_Co=256
colo molokai

" Remap movement keys
noremap m l
noremap l k
noremap k j
noremap j h

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

" Fix Ctrl-Space weird behaviour
imap <Nul> <Space>

" Line number
set number relativenumber

" Cursor style in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim'
Plug 'zchee/deoplete-jedi'
Plug 'zchee/deoplete-clang'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'w0rp/ale'
Plug 'euclio/vim-markdown-composer'
Plug 'donRaphaco/neotex'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
" Python linter
let g:ale_python_flake8_options = '--ignore E221,E226'
" Airline 
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" NERD tree
map <c-t> :NERDTreeToggle<CR>
