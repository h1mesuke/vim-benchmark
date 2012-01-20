"=============================================================================
" Simple Benchmarking Tool for Vim script
"
" File    : autoload/benchmark.vim
" Author  : h1mesuke <himesuke@gmail.com>
" Updated : 2012-01-20
" Version : 0.0.1
" License : MIT license {{{
"
"   Permission is hereby granted, free of charge, to any person obtaining
"   a copy of this software and associated documentation files (the
"   "Software"), to deal in the Software without restriction, including
"   without limitation the rights to use, copy, modify, merge, publish,
"   distribute, sublicense, and/or sell copies of the Software, and to
"   permit persons to whom the Software is furnished to do so, subject to
"   the following conditions:
"
"   The above copyright notice and this permission notice shall be included
"   in all copies or substantial portions of the Software.
"
"   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:PRECISION = 6
let s:benchmarker = {}

function! s:benchmarker.run(...) abort
  if !has('reltime') || !has('float')
    throw "benchmark: +reltime and +float features are required."
  endif
  echomsg "Benchmark: " . self.__caption__
  let bmfuncs = s:get_bmfuncs(self)
  let n_try = (a:0 ? a:1 : 1)
  let i = 1
  while i <= n_try
    echomsg ""
    if n_try > 1
      echomsg "Trial #" . i
    endif
    let results = {}
    let errors  = {}
    for func in bmfuncs
      try
        let result = {}
        let start = reltime()
        let retval = call(self[func], [], self)
        let result.used = str2float(reltimestr(reltime(start)))
        if s:is_sample(retval)
          let result.sample = retval
        endif
        let results[func] = result
      catch
        let errors[func] = v:exception
      endtry
    endfor
    let col_func_width = max(map(copy(bmfuncs), 'len(v:val)'))
    let col_used_width = max(map(values(results),
          \ 'float2nr(floor(log10(v:val.used)))')) + 2 + s:PRECISION
    for [func, result] in sort(items(results), 's:compare_used')
      echomsg printf("  %-*s : %*.*f%s",
            \ col_func_width, func,
            \ col_used_width, s:PRECISION, result.used,
            \ has_key(result, 'sample') ? "   => " . string(result.sample) : "")
    endfor
    for [func, errmsg] in items(errors)
      echomsg printf("  %-*s : Error (%s)", col_func_width, func, errmsg)
    endfor
    let i += 1
  endwhile
endfunction

function! s:get_bmfuncs(bm)
  let type_func = type(function('tr'))
  let is_valid_name = 'v:val != "run" && v:val !~ "^_"'
  let is_funcref = 'type(a:bm[v:val]) == type_func'
  return filter(keys(a:bm), is_valid_name . ' && ' . is_funcref)
endfunction

function! s:is_sample(value)
  return (type(a:value) != type(0) || a:value != 0)
endfunction

function s:compare_used(item1, item2)
  let used1 = a:item1[1].used
  let used2 = a:item2[1].used
  return (used1 == used2 ? 0 : (used1 > used2 ? 1 : -1))
endfunction

function! benchmark#new(...)
  let bm = copy(s:benchmarker)
  let bm.__caption__ = (a:0 ? a:1 : "")
  return bm
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
