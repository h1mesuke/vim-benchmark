" Vim script benchmark

let s:bm = benchmark#new("String is empty?")

let s:N = 10000
let s:STR = "hello"

function! s:bm.empty()
  let i = 0
  while i < s:N
    if empty(s:STR)
    endif
    let i += 1
  endwhile
endfunction

function! s:bm.op_equal()
  let i = 0
  while i < s:N
    if s:STR == ""
    endif
    let i += 1
  endwhile
endfunction

function! s:bm.op_match()
  let i = 0
  while i < s:N
    if s:STR =~ '^\s*$'
    endif
    let i += 1
  endwhile
endfunction

call s:bm.run(3)
