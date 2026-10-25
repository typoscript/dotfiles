" ******************************************************
" Set - General Setting
" ******************************************************
set belloff=all                         " Mute all beep sounds, or use 'set noerrorbells'
set clipboard=unnamed                   " Share the clipboard with the OS
set cursorline                          " Allow current line highlighting
set foldcolumn=0                        " If any, remove whitespaces before line number
set nrformats+=alpha                    " Add alphabet as number format to be incremented by <C-a> or decremented by <C-x>
set omnifunc=syntaxcomplete#Complete    " Auto-completion for most langauges (HTML, CSS, JS, Python, etc)
set scrolloff=8                         " Scroll up or down when the cursor is [num] lines far from the top or bottom of the screen
set timeoutlen=500                      " Time in miliseconds to aceept input as a possible mapping
set wildmenu                            " <Tab> to choose next suggestion. <Ctrl> + <Tab> to choose previous suggestion
set wildoptions=pum                     " Set wildmenu as a vertical wildmenu

" ******************************************************
" Set - Do not ...
" ******************************************************
set nowrap          " Do not break line for long lines
set noswapfile      " Do not create swap file
set nobackup        " Do not create backup file
set noshowmode      " Do not show modes at the bottom like, --INSERT--

" ******************************************************
" Set - Directory & File Path
" ******************************************************
set path+=**                        " Allow directory & file search to be recursive
set wildignore+=**/node_modules/**  " For :find, ignore searching for files in node_modules directory

" ******************************************************
" Set - File
" ******************************************************
set encoding=utf-8
set listchars=tab:→\ ,eol:↲,space:· " Show tab characters as → and newline characters as ↲ character
set re=2                            " Prevent lag while editing Typescript files
set hidden                          " Allow switching unsaved files to other files

" ******************************************************
" Set - Indentation 
" ******************************************************
set ts=4 sw=4 sts=4 " Set shift width to 4 spaces and tab width to 4 spaces
set autoindent

" ******************************************************
" Set - Number
" ******************************************************
set number          " Show the current line number
set relativenumber  " Show the relative line number from the current line

" ******************************************************
" Set - Search
" ******************************************************
set hlsearch        " Allow higlight on searched results
set incsearch       " Incremental search which means highlight any matches as typing
set ignorecase      " Ignore case for search
set smartcase       " Allow case sensitive search even if capital letter is typed

" ******************************************************
" Set - Show
" ******************************************************
set showmatch       " Highlight matching bracket
set showcmd         " Show currently typed keys in normal mode. Must be after 'set nocompatible'

" ******************************************************
" Set - Tab
" ******************************************************
set showtabline=2   " Show tabs at the top even if there's one tab
set tabpagemax=10   " Open up to 10 tabs when opening files with 'vim -p file1,file2,fil3'
