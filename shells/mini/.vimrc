" .vimrc -*- mode: vimrc -*-
"

set nocompatible

filetype on
filetype plugin on
filetype indent on
syntax on
set number
set cursorline

imap jf <Esc>
imap jk <Esc>

function MaybeEnd ()
    if col(".") == (col("$") - 1)
        exe ":normal 0"
    else
        exe ":normal $"
    endif
endfunction

nmap <Bslash> :call MaybeEnd()<CR>

let mapleader=" "
nmap <Space> <Nop>
