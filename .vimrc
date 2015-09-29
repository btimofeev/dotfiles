" ===========================
"  Vundle - packages control
" ===========================
    set nocompatible
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    Plugin 'gmarik/Vundle.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'scrooloose/nerdtree'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'bufexplorer.zip'
    "Plugin 'taglist.vim'
    Plugin 'snipmate'
	Plugin 'fatih/vim-go'
	Plugin 'majutsushi/tagbar'
    "Plugin 'Lokaltog/vim-easymotion'
    "Plugin 'Rykka/riv.vim'
	"Plugin 'Rykka/clickable.vim'
    "Plugin 'klen/python-mode'
	"Plugin 'tpope/vim-fugitive'

    call vundle#end()    
    filetype plugin indent on

" ===============
"  Misc settings
" ===============

    " allow backspacing over everything in insert mode
    set backspace=indent,eol,start

    set history=50  " keep 50 lines of command line history
    set ruler       " show the cursor position all the time
    set showcmd     " display incomplete commands

    " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
    inoremap <C-U> <C-G>u<C-U>

    " In many terminal emulators the mouse works just fine, thus enable it.
    if has('mouse')
        set mouse=a
    endif

    " Switch syntax highlighting on, when the terminal has colors
    " Also switch on highlighting the last used search pattern.
    if &t_Co > 2 || has("gui_running")
        syntax on
        set hlsearch
    endif

    " Only do this part when compiled with support for autocommands.
    if has("autocmd")

        " Enable file type detection.
        " Use the default filetype settings, so that mail gets 'tw' set to 72,
        " 'cindent' is on in C files, etc.
        " Also load indent files, to automatically do language-dependent indenting.
        filetype plugin indent on

        " Put these in an autocmd group, so that we can delete them easily.
        augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

        augroup END

    else
        set autoindent		" always set autoindenting on
    endif " has("autocmd")

    " Convenient command to see the difference between the current buffer and the
    " file it was loaded from, thus the changes you made.
    " Only define it when not defined already.
    if !exists(":DiffOrig")
          command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        		  \ | wincmd p | diffthis
    endif

    "set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

    " переключаем на русский в insert mode нажатием Ctrl+^ 
    " при этом все шорткаты работают нормально
    set keymap=russian-jcukenwin
    set iminsert=0
    set imsearch=0
    highlight lCursor guifg=NONE guibg=Cyan
     

    set fileencodings=utf-8,cp1251,koi8-r,cp866
    set fileformat=unix
    set fileformats=unix,dos

    set hidden " не выгружать буфер когда переключаешься на другой
    set mousehide " скрывать мышь в режиме ввода текста

    " Преобразование Таба в пробелы
    "set expandtab

    " Размер табуляции
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set smarttab

    " Включаем нумерацию строк
    set nu

    " Фолдинг по отсупам
    set foldenable
    set foldmethod=indent
    set foldlevel=99

    " Поиск по набору текста (очень полезная функция)
    set incsearch

    " Включаем "умные" отспупы ( например, автоотступ после {)
    set smartindent

    " Курсор
    set cul
    highlight CursorLine                    cterm=none ctermbg=235
    "highlight CursorColumn                  cterm=none ctermbg=235
    
    " Устанавливаем цветовую тему
    if has('gui_running')
        set background=light
    else
        set background=dark
    endif
    let g:solarized_termcolors=256
    colorscheme solarized

    " Языки для spell checker'а. Русский с буквой "ё". 
    " Проверку правописания включать через set spell
    set spelllang=ru_yo,en_us

" =================
"  Горячие клавишы
" =================
    
    " F2 - обозреватель файлов
    map <F2> :NERDTreeToggle<cr>
    vmap <F2> <esc>:NERDTreeToggle<cr>
    imap <F2> <esc>:NERDTreeToggle<cr>
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
    
    " Use <leader>l to toggle display of whitespace
    nmap <leader>l :set list!<CR>
    " And set some nice chars to do it with
    set listchars=tab:»\ ,eol:¬

    " Switch off the current search
    nnoremap <silent> <Leader>/ :nohlsearch<CR>
