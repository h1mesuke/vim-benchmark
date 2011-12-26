" Vim script benchmark

let bm = benchmark#new("List Concatanation")

let s:NUMS = range(10000)

function! bm.add()
  let a = []
  for n in s:NUMS
    call add(a, n)
  endfor
endfunction

function! bm.op_plus()
  let a = []
  for n in s:NUMS
    let a += [n]
  endfor
endfunction

call bm.run(3)

" vim: filetype=vim
