" Vim script benchmark

let s:bm = benchmark#new("for vs while")

let s:lines = map(range(0, 9999), '"This is a line."')

function! s:bm.for()
  for line in s:lines
  endfor
endfunction

function! s:bm.while()
  let idx = 0 | let n_lines = len(s:lines)
  while idx < n_lines
    let line = s:lines[idx]
    let idx += 1
  endwhile
endfunction

call s:bm.run(3)

" vim: filetype=vim
