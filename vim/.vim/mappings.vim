" For Java
inoremap sysout System.out.println();<Esc>hi

" Delete the current line but do not store it in the clipboard 
nnoremap d_ "_dd

" Copy from the current column to the end of line
nnoremap Y y$

" Go to the end of line in Insert mode
inoremap a' <Esc><S-a>

" Cursor Navigation in Command-line Mode
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" ******************************************************
" Switch
" ******************************************************
" On/Off Search Highlighting
nnoremap <Leader>nh :noh<Return>
		
" On/Off Showing Whitespace, Tab, Newline Characters
nnoremap <Leader>l :set list<Cr>
nnoremap <Leader>nl :set nolist<Cr>

" ******************************************************
" Shortcuts
" ******************************************************
" Back to Normal Mode
inoremap jk <Esc>
noremap! qq <C-c> | " Applies in Insert and Command-line Mode

" Netrw
nnoremap <Leader>e :Lex<Cr>
nnoremap - :e %:h<Cr>| " Open the current directory in Netrw

" Quit
nnoremap <Leader>qa :qa!<Cr>
nnoremap <Leader>qq :q<Cr>

" ******************************************************
" Key to Key
" ******************************************************
cnoremap vt vert
vnoremap <Leader><Leader> <Esc>

" ******************************************************
" Brackets and Quotes
" ******************************************************
" Enclose the current word with brackets or quotes
nnoremap sw" ciw""<Esc>hpl
nnoremap sw' ciw''<Esc>hpl
nnoremap sw( ciw()<Esc>hpl
nnoremap sw[ ciw[]<Esc>hpl
nnoremap sw{ ciw{}<Esc>hpl

nnoremap "aw caw""<Esc>hpl
nnoremap 'aw caw''<Esc>hpl
nnoremap (aw caw()<Esc>hpl
nnoremap [aw caw[]<Esc>hpl
nnoremap {aw caw{}<Esc>hpl

" Auto indent function body when an opening curly bracket and <Enter> is typed
inoremap {<Enter> {<Enter><Enter>}<Up><Tab>

" Insert the close bracket or quote when an opening bracket or quote is typed
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Do not insert close bracket if character is entered twice
inoremap "" "
inoremap '' '
inoremap `` `
inoremap () (
inoremap [] [
inoremap {} {


" ******************************************************
" Window
" ******************************************************
" Shortcuts - Navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Shortcuts - Resize
nnoremap <Up> <C-w>+
nnoremap <Down> <C-w>-
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>
