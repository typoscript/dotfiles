" ******************************************************
" Options - General Settings (merged set.vim & lets.vim)
" ******************************************************

" Leader key
let mapleader = ' '

" General
set belloff=all                         " Mute all beep sounds
set cursorline                          " Allow current line highlighting
set foldcolumn=0                        " Remove whitespaces before line number
set nrformats+=alpha                    " Add alphabet as number format (<C-a>/<C-x>)
set omnifunc=syntaxcomplete#Complete    " Auto-completion for most languages
set scrolloff=8                         " Scroll offset lines from screen edge
set timeoutlen=500                      " Mapping delay in milliseconds
set wildmenu                            " Command-line completion menu
set wildoptions=pum                     " Vertical wildmenu popup

" Performance & Safety
set nowrap                              " Do not wrap long lines
set noswapfile                          " Do not create swap file
set nobackup                            " Do not create backup file
set noshowmode                          " Do not show mode at bottom (handled by statusline)
set hidden                              " Allow switching unsaved buffers
set re=2                                " Prevent lag in Typescript files

" Directory & Search Path
set path+=**                            " Allow recursive search in :find
set wildignore+=**/node_modules/**      " Ignore node_modules
set wildignore+=**/.git/**

" Display & File Formatting
set encoding=utf-8
set listchars=tab:→\ ,eol:↲,space:·     " Visualize tabs and newlines (toggle with :set list)
set showmatch                           " Highlight matching brackets
set showcmd                             " Show currently typed keys in normal mode

" Indentation
set ts=4 sw=4 sts=4                     " Tab and shift width 4 spaces
set autoindent

" Line Numbers
set number                              " Show absolute line number
set relativenumber                      " Show relative line numbers

" Search
set hlsearch                            " Highlight search matches
set incsearch                           " Incremental search
set ignorecase                          " Case-insensitive search
set smartcase                           " Case-sensitive if uppercase is typed
let @/ = ""                             " Clear search highlight on startup

" Tabs
set showtabline=2                       " Always show tabline at the top
set tabpagemax=10                       " Max tabs on 'vim -p'

" Netrw File Explorer Settings
let g:netrw_winsize     = 30            " Netrw window width
let g:netrw_liststyle   = 3             " Tree listing style
let g:netrw_bufsettings = 'noma nomad nu nowrap ro nobl'
let g:netrw_banner      = 0             " Hide banner

" Cursor Shape in Terminal (xterm-compatible)
if &term =~ 'xterm\|rxvt\|screen\|tmux'
  let &t_SI = "\e[6 q"                  " Vertical bar cursor in Insert mode
  let &t_EI = "\e[2 q"                  " Block cursor in Normal mode
endif
