set statusline= " Clear the statusline in case of re-opening a file

set statusline+=%#statusline_mode#			" Hightlight "statusline_mode" highlighting group
set statusline+=\ %n						" Show the current buffer number
set statusline+=\ %{g:currentMode[mode()]}	" Show the current mode
set statusline+=\ %m						" Show "[+]" if the file is modified
set statusline+=%*							" End highlighting

set statusline+=%#statusline_path#	" Hightlight "statusline_path" highlighting group
set statusline+=\ %F				" Show Full path
set statusline+=%*					" End highlighting

set statusline+=%=						" Start adding statusline options to the right of the screen
set statusline+=\ Ln:\ %l,\ Col:\ %c	" Show line & column number
set statusline+=\ \|\ %p%%				" Show percentage of the current line from the top
set statusline+=\ \|\ %Y				" Show file type in uppercase
set statusline+=\ \|\ %{&fileencoding}  " Show file encoding
set statusline+=\ \|\ %{ConvertByteToMegaByte(GetFileSize())}MB				" Show file size in MB
set statusline+=\ [%{strftime('%b\ %d\ %a\ %H:%M',getftime(expand('%')))}]  " Show the current time

set laststatus=2 " Show the statusline even for the last window
