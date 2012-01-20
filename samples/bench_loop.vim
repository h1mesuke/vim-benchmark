" Vim script benchmark

let s:bm = benchmark#new("for vs while")

let s:LINES = map(range(0, 9999), '"This is a line."')

function! s:bm.for()
  for line in s:LINES
  endfor
endfunction

function! s:bm.while()
  let idx = 0 | let n_lines = len(s:LINES)
  while idx < n_lines
    let line = s:LINES[idx]
    let idx += 1
  endwhile
endfunction

call s:bm.run(3)
