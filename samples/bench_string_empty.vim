" Vim script benchmark

let bm = benchmark#new("String is empty?")

let s:N = 10000
let s:str = "hello"

function! bm.empty()
  let i = 0
  while i < s:N
    if empty(s:str)
    endif
    let i += 1
  endwhile
endfunction

function! bm.op_equal()
  let i = 0
  while i < s:N
    if s:str == ""
    endif
    let i += 1
  endwhile
endfunction

function! bm.op_match()
  let i = 0
  while i < s:N
    if s:str =~ '^\s*$'
    endif
    let i += 1
  endwhile
endfunction

call bm.run(3)

" vim: filetype=vim
