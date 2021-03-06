" ~/.config/nvim/init.vim
syntax on
set number
set relativenumber
set smarttab
set ignorecase
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set clipboard+=unnamed  " use the clipboards of vim and win
set go+=a               " Visual selection automatically copied to the clipboard
set mouse-=a
set encoding=utf-8
set backspace=indent,eol,start
set cursorline
set encoding=utf-8

" set tabs width 4 when file type is python
autocmd Filetype py setlocal shiftwidth=4 tabstop=4
filetype plugin indent on

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
" ================= looks and basic stuff ================== "

" autocomplete for javascript
" NOTE: :CocInstall coc-json coc-tsserver coc-vetur, run in command mode after installing coc.nvim
" more information: https://github.com/neoclide/coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/syntastic' " Syntastic is a syntax checking plugin for Vim created by Martin Grenfell
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mattn/emmet-vim' " for autocomplete html:5
Plug '1995parham/tomorrow-night-vim' " theme for vim
Plug 'hail2u/vim-css3-syntax' " syntax highlighting css3
Plug 'ap/vim-css-color' " css3 color
Plug 'jiangmiao/auto-pairs' " tag autopairs like (),[],{} etc.
Plug 'alvan/vim-closetag' " auto close html tag
Plug 'vim-python/python-syntax' " python syntax highlighting
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'  " to highlight files in nerdtree
" NOTE: go to https://github.com/ryanoasis/vim-devicons to more information
" how to install icons in linux
Plug 'ryanoasis/vim-devicons' " icon for vim
Plug 'glench/vim-jinja2-syntax' " styling jinja2 syntax
" post install (yarn install | npm install) then load plugin only for editing supported files
" NOTE: run sudo npm i -g prettier in command mode after installing vim-prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'posva/vim-vue' " syntax highlighting for vue
Plug 'maxmellon/vim-jsx-pretty'
Plug 'ekalinin/Dockerfile.vim' " syntax highlighting Dockerfile
Plug 'tpope/vim-commentary' " commentary in vim

"================= Functionalities ================= "

" autocompletion using ncm2
Plug 'ncm2/ncm2' " dependency of ncm2
Plug 'roxma/nvim-yarp' " awesome autocomplete plugin
Plug 'ncm2/ncm2-bufword' " Words in buffer completion
Plug 'ncm2/ncm2-path' " Filepath completion
Plug 'othree/csscomplete.vim' " css autocomplete for ncm2
" autocomplete for python
Plug 'davidhalter/jedi-vim'
Plug 'ncm2/ncm2-jedi'
" enable css completion in file javascript
Plug 'ncm2/ncm2-html-subscope'

Plug 'dense-analysis/ale' " syntax checking and semantic errors

" search plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'unkiwii/vim-nerdtree-sync' " for synchronizing current open file with NERDtree

call plug#end()
" List ends here. Plugins become visible to Vim after this call.

let NERDTreeShowHidden=1 " show hidden file in nerd tree
let NERDTreeIgnore=['\.DS_Store$', '\.git$','__pycache__'] " ignore files in nerd tree
" unkiwii/vim-nerdtree-sync options
let g:nerdtree_sync_cursorline = 1
let g:NERDTreeHighlightCursorline = 1

" set color scheme to 1995parham/tomorrow-night-vim
colorscheme naz
let g:airline_theme='minimalist'
let g:airline_powerline_fonts = 1
" make colorscheme transparent
hi Normal guibg=NONE ctermbg=NONE

" change color to none when vertical split
highlight VertSplit ctermfg=NONE
highlight VertSplit ctermbg=NONE

" init setting for hail2u/vim-css3-syntax
augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END

let mapleader = ","

nmap <Leader>m :e $MYVIMRC<cr>
nmap <Leader>t :NERDTreeToggle<cr>
nmap <Leader>p :PrettierAsync<cr>
nmap <Leader>l :GFiles<cr>
nmap <Leader>; :Files<cr>
nmap <Leader>< :wincmd h<cr>
nmap <Leader>> :wincmd l<cr>
nmap <Leader>j :wincmd j<cr>
nmap <Leader>k :wincmd k<cr>

" coc.nvim options
let g:coc_disable_startup_warning = 1
" posva/vim-vue options
let g:vue_pre_processors = 'detect_on_enter'

" Border color for fzf
let g:fzf_layout =
      \ {'up':'~90%',
      \ 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" init vim-python/python-syntax plugin
let g:python_highlight_all = 1

" NCM SETTINGS BEGIN
" NOTE: when launch neovim given following error like this [ncm2_core@yarp] Job is dead.
" RUN: sudo pip3 install --upgrade neovim, tested on ubuntu 18.04, macOS Catalina
" NOTE: required install jedi from pip when use autocomplete ncm2-jedi
" RUN: sudo pip3 install jedi
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
set shortmess+=c
inoremap <c-c> <ESC>
" init css complete for ncm2
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
au User Ncm2Plugin call ncm2#register_source({
        \ 'name' : 'css',
        \ 'priority': 9,
        \ 'subscope_enable': 1,
        \ 'scope': ['css','scss'],
        \ 'mark': 'css',
        \ 'word_pattern': '[\w\-]+',
        \ 'complete_pattern': ':\s*',
        \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
        \ })
" make it fast
let ncm2#popup_delay = 5
let ncm2#complete_length = [[1, 1]]
" NCM SETTINGS END

" Disable Jedi-vim autocompletion and enable call-signatures options
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = 1

" ale options
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '∙∙'
let g:ale_python_flake8_options = '--ignore=E302,E231,E501,E701,E401,E128,E251,F403,F405,E402,E221,W504,F722'

let g:ale_list_window_size = 8
let g:ale_sign_column_always = 0
let g:ale_open_list = 1

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.vue,*.jsx,*.js'
" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
" let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,jsx,js'
" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
" let g:closetag_xhtml_filetypes = 'xhtml,jsx'
" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
" Shortcut for closing tags, default is '>'
" let g:closetag_shortcut = '>'
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'
" vim-jsx-pretty
let g:vim_jsx_pretty_template_tags = ['html', 'jsx', 'js']
let g:vim_jsx_pretty_highlight_close_tag = 1
let g:vim_jsx_pretty_colorful_config = 1


" ================= other configuration ================== "

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" Remap Esc for touchbar problem
vnoremap qw <C-C>
vnoremap QW <C-C>
inoremap jk <ESC>
cnoremap jk <C-C>
inoremap JK <ESC>
cnoremap JK <C-C>

" disable all mouse wheel
nmap <ScrollWheelUp> <nop>
nmap <S-ScrollWheelUp> <nop>
nmap <C-ScrollWheelUp> <nop>
nmap <ScrollWheelDown> <nop>
nmap <S-ScrollWheelDown> <nop>
nmap <C-ScrollWheelDown> <nop>
nmap <ScrollWheelLeft> <nop>
nmap <S-ScrollWheelLeft> <nop>
nmap <C-ScrollWheelLeft> <nop>
nmap <ScrollWheelRight> <nop>
nmap <S-ScrollWheelRight> <nop>
nmap <C-ScrollWheelRight> <nop>

imap <ScrollWheelUp> <nop>
imap <S-ScrollWheelUp> <nop>
imap <C-ScrollWheelUp> <nop>
imap <ScrollWheelDown> <nop>
imap <S-ScrollWheelDown> <nop>
imap <C-ScrollWheelDown> <nop>
imap <ScrollWheelLeft> <nop>
imap <S-ScrollWheelLeft> <nop>
imap <C-ScrollWheelLeft> <nop>
imap <ScrollWheelRight> <nop>
imap <S-ScrollWheelRight> <nop>
imap <C-ScrollWheelRight> <nop>

vmap <ScrollWheelUp> <nop>
vmap <S-ScrollWheelUp> <nop>
vmap <C-ScrollWheelUp> <nop>
vmap <ScrollWheelDown> <nop>
vmap <S-ScrollWheelDown> <nop>
vmap <C-ScrollWheelDown> <nop>
vmap <ScrollWheelLeft> <nop>
vmap <S-ScrollWheelLeft> <nop>
vmap <C-ScrollWheelLeft> <nop>
vmap <ScrollWheelRight> <nop>
vmap <S-ScrollWheelRight> <nop>
vmap <C-ScrollWheelRight> <nop>

" disable arrow key
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>

vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>

" disable page down and up
inoremap <PageUp> <Nop>
inoremap <PageDown> <Nop>

nnoremap <PageUp> <Nop>
nnoremap <PageDown> <Nop>

vnoremap <PageUp> <Nop>
vnoremap <PageDown> <Nop>
