set whichwrap+=h,l,b,s,<,>,[,]
set nocp
set number
set nocompatible
syntax on
set showmode
set showcmd
set mouse=a
set encoding=utf-8 
set t_Co=256
filetype indent on
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set relativenumber
set cursorline
set wrap   
set linebreak
set wrapmargin=2
set scrolloff=5
set sidescrolloff=15
set laststatus=2
set ruler
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set nobackup
set noswapfile
set undofile
set backupdir=~/.vim/.backup//  
set directory=~/.vim/.swp//
set undodir=~/.vim/.undo// 
set autochdir
set noerrorbells
set history=1000
set autoread
set wildmenu
set wildmode=longest:list,full
set autoindent
set expandtab

func Run2()
    exec "w!"
    exec "!g++ % -o %< -O2"
    exec "!time ./%<"
endfunc

func Run()
	exec "w!"
	if &filetype == "cpp"
		exec "! g++ % -o %<"
        exec "!time ./%<"
	endif
	if &filetype == "html" 
		exec "!google-chrome %:p"
	endif
	if &filetype == "markdown"
		exec "!google-chrome %:p"
	endif
	if &filetype == "python"
		exec "!python %"
	endif
endfunc

map <F9> :call Run() <CR>
imap <F9> <Esc> <F9>
map <C-F9> :call Run2() <CR>
imap <C-F9> <ESC> <C-F9>

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

syntax enable
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

func Cppinit()
	call setline(1,          "/***************************************************************")
	call append(line("."),   "	File name: ".expand("%:t"))
	call append(line(".")+1, "	Author: ljfcnyali")
	call append(line(".")+2, "	Create time: ".strftime("%c"))
	call append(line(".")+3, "***************************************************************/")
	call append(line(".")+4, "#include<bits/stdc++.h>")
	call append(line(".")+5, "")
	call append(line(".")+6, "using namespace std;")
	call append(line(".")+7, "")
	call append(line(".")+8, "#define REP(i, a, b) for ( int i = (a), _end_ = (b); i <= _end_; ++ i ) ")
	call append(line(".")+9, "#define mem(a) memset ( (a), 0, sizeof ( a ) ) ")
	call append(line(".")+10,"#define str(a) strlen ( a ) ")
    call append(line(".")+11,"#define pii pair<int, int>")
	call append(line(".")+12,"typedef long long LL;")
	call append(line(".")+13,"")
	call append(line(".")+14,"int main()")
	call append(line(".")+15,"{")
	call append(line(".")+16,"#ifndef ONLINE_JUDGE")
	call append(line(".")+17,"    freopen(\"input.txt\", \"r\", stdin);")
	call append(line(".")+18,"    freopen(\"output.txt\", \"w\", stdout);")
	call append(line(".")+19,"#endif")
	call append(line(".")+20,"")
	call append(line(".")+21,"")
	call append(line(".")+22,"    return 0;")
	call append(line(".")+23,"}")
endfunc

function CurDir()
	let curdir = substitute(getcwd(), $HOME, "~", "g")
	return curdir
endfunc

map <F8> :call Cppinit()<CR>
imap <F8> <esc><F8>

set clipboard^=unnamedplus
