" ======
" Vundle
" ======

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'
Plugin 'MarcWeber/vim-addon-mw-utils' " Для snipmate
Plugin 'tomtom/tlib_vim' " Для snipmate
Plugin 'garbas/vim-snipmate'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'bling/vim-airline'
Plugin 'fatih/vim-go'
"Plugin 'klen/python-mode'
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'sickill/vim-monokai'

call vundle#end()    
filetype plugin indent on

"==============================

" Позволить использовать backspace в insert mode
set backspace=indent,eol,start

set history=500

" Отображать позицию курсора
set ruler

" Отображать вводимую команду
set showcmd
    
" Меню автодополнения команд
set wildmenu 

" Переносить длинные строки
set wrap

" Не перерисовывать экран во время выполнения скриптов
set lazyredraw

" Начинать прокручивать экран когда остается 7 строк до края
set so=7

if has('mouse')
    set mouse=a
endif

" Включаем подсветку синтаксиса и поиска
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" не выгружать буфер когда переключаешься на другой
set hidden
" скрывать мышь в режиме ввода текста
set mousehide

" Преобразование Таба в пробелы
set expandtab

" Размер табуляции
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smarttab

" Включаем нумерацию строк
set number

" Фолдинг по отсупам
set foldenable
set foldmethod=indent
set foldlevel=99

" Поиск во врямя набора текста
set incsearch

" Включаем "умные" отспупы ( например, автоотступ после {)
set smartindent

" Подсветка строки с курсором
set cul
highlight CursorLine cterm=none ctermbg=235
"highlight CursorColumn cterm=none ctermbg=235

" Устанавливаем цветовую тему
if has('gui_running')
    set background=light
else
    set background=dark
endif
let g:solarized_termcolors=256
colorscheme solarized

" переключаем на русский в insert mode нажатием Ctrl+^ 
" при этом все шорткаты работают нормально
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformat=unix
set fileformats=unix,dos

" Языки для spell checker'а. Русский с буквой "ё". 
" Проверку правописания включать через set spell
set spelllang=ru_yo,en_us

" =========
" syntastic
" =========

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" =======
" airline
" =======

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


" =================
"  Горячие клавишы
" =================

let mapleader=","

" F2 - обозреватель файлов
nmap <C-\> :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$','\~$']

" F3 - показать окно Taglist
map <F3> :TagbarToggle<cr>
vmap <F3> <esc>:TagbarToggle<cr>
imap <F3> <esc>:TagbarToggle<cr>

" F5 - показать буферы
nmap <F5> <Esc>:BufExplorer<cr>
vmap <F5> <esc>:BufExplorer<cr>
imap <F5> <esc>:BufExplorer<cr>

" F6 - предыдущий буфер
nmap <F6> :bp<cr>
vmap <F6> <esc>:bp<cr>
imap <F6> <esc>:bp<cr>

" F7 - следующий буфер
nmap <F7> :bn<cr>
vmap <F7> <esc>:bn<cr>
imap <F7> <esc>:bn<cr>

" Переход между окнами по ctrl+[hjkl]
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Используем <leader>l для отображения пробельных символов
" И устанавливаем эти символы
nmap <leader>l :set list!<CR>
set listchars=tab:»\ ,eol:¬

" Выключить подсвеченный поиск
nnoremap <silent> <Leader>/ :nohlsearch<CR>
