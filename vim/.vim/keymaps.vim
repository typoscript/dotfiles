" ******************************************************
" Keymaps (merged mappings.vim, abbrevs.vim, snippets.vim)
" ******************************************************

" Normal / Insert Mode Navigation
inoremap jk <Esc>
inoremap a' <Esc><S-a>
noremap! qq <C-c>

" Delete line without storing into default register
nnoremap d_ "_dd

" Copy from current column to end of line
nnoremap Y y$

" Command-line Mode Navigation
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" ******************************************************
" Leader Switches
" ******************************************************
nnoremap <Leader>nh :noh<Return>
nnoremap <Leader>l  :set list<Cr>
nnoremap <Leader>nl :set nolist<Cr>

" File Explorer (Netrw)
nnoremap <Leader>e :Lex<Cr>
nnoremap - :e %:h<Cr>

" Window Quit
nnoremap <Leader>qa :qa!<Cr>
nnoremap <Leader>qq :q<Cr>

" Window Navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Window Resize
nnoremap <Up>    <C-w>+
nnoremap <Down>  <C-w>-
nnoremap <Left>  <C-w><
nnoremap <Right> <C-w>>

" ******************************************************
" Shortcuts & Aliases
" ******************************************************
nnoremap ; :
vnoremap ; :
cnoremap vt vert
vnoremap <Leader><Leader> <Esc>

" Command-line Abbreviations (abbrevs.vim)
cnorea vrc tabe ~/.vimrc
cnorea vp  ~/.vim/
cnorea te  tabe
cnorea tv  tabe ~/.vimrc
cnorea th  tab help

" ******************************************************
" Code Snippets (snippets.vim)
" ******************************************************
nnoremap snp.html :r $HOME/.vim/snippets/skeleton.html<CR>
nnoremap snp.java :r $HOME/.vim/snippets/skeleton.java<CR>
nnoremap snp.rfc  :r $HOME/.vim/snippets/skeleton-react.js<CR>

" ******************************************************
" Brackets and Quotes Surrounding
" ******************************************************
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

" Auto indent curly bracket on enter
inoremap {<Enter> {<Enter><Enter>}<Up><Tab>

" Auto close pairs
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

inoremap "" "
inoremap '' '
inoremap `` `
inoremap () (
inoremap [] [
inoremap {} {
