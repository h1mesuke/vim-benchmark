" Vim script benchmark

let s:bm = benchmark#new("List Concatanation")

let s:NUMS = range(10000)

function! s:bm.add()
  let a = []
  for n in s:NUMS
    call add(a, n)
  endfor
endfunction

function! s:bm.op_plus()
  let a = []
  for n in s:NUMS
    let a += [n]
  endfor
endfunction

call s:bm.run(3)

" vim: filetype=vim
