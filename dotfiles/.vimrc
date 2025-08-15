"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible        " Disable vi compatibility
filetype on             " Enable file type detection
filetype plugin on      " Load file-type plugins
filetype indent on      " Load file-type indent settings
syntax on               " Enable syntax highlighting
set number              " Show line numbers
set cursorline          " Highlight current line
set shiftwidth=4        " Indent size is 4 spaces
set tabstop=4           " Tab width = 4 columns
set expandtab           " Convert tabs to spaces
set nobackup            " Disable backup files
set scrolloff=10        " Keep 10 lines above/below cursor
set nowrap              " Don't wrap long lines
set incsearch           " Highlight matches as you type
set ignorecase          " Ignore case in search
set smartcase           " Override ignorecase if caps used
set showcmd             " Show command in progress
set showmode            " Show current mode
set showmatch           " Highlight matching brackets
set hlsearch            " Highlight all search matches
set history=1000        " Command history length
set wildmenu            " Enable command-line completion menu
set wildmode=list:longest " Bash-like completion behavior
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx " Ignore these files

if v:version < 802
    packadd! dracula
endif
syntax enable
colorscheme dracula
    
" ---- STATUS LINE SETTINGS ----
set statusline=          " Clear status line before setup
set statusline+=\ %F\ %M\ %Y\ %R   " File name, modified flag, file type, readonly
set statusline+=%=       " Separator between left/right
set statusline+=\ row:\ %l\ col:\ %c\ percent:\ %p%% " Right side info
set laststatus=2         " Always show status line

