let s:is_win = has('win32') || has('win64')

function! asyncomplete#sources#ruby#get_source_options(opt)
    return a:opt
endfunction

function! asyncomplete#sources#ruby#completor(opt, ctx) abort
    let l:col = a:ctx['col']
    let l:typed = a:ctx['typed']

    let l:kw = matchstr(l:typed, '\v\S+$')
    let l:kwlen = len(l:kw)

    let l:startcol = l:col - l:kwlen

    "INFO KJG: array of complex disctionary items, 2018-02-13
    let l:matches = asyncomplete#sources#ruby#build_cache()
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
endfunction

function! asyncomplete#sources#ruby#build_cache()
  let source_files = [
        \ 'autoload/asyncomplete/sources/ruby_core_methods',
        \ 'autoload/asyncomplete/sources/ruby_keywords',
        \ ]

  let l:matches = []

  for source_file in source_files
    let meths = readfile(globpath(&rtp, source_file))
    for meth in meths
      let cache = {}
      let l:word = split(meth)[0]
      let l:kind = split(meth)[1]

      let cache.word = l:word
      let cache.dup = 1
      let cache.icase = 1
      let cache.menu = "[rb] ".l:kind

      " let l:matches = map(keys(l:matches),'{"word":v:val,"dup":1,"icase":1,"menu": "[".v:val."]"}')
      " let l:matches[cache.word] = cache.kind
      " call add(g:deopleteruby#words_cache, cache)

      call add(l:matches, cache)
    endfor
  endfor

  return l:matches
endfunction

" vim8/neovim jobs wrapper {{{
function! s:exec(cmd, callback) abort
    if has('nvim')
        return jobstart(a:cmd, {
            \ 'on_stdout': a:callback,
            \ 'on_stderr': a:callback,
            \ 'on_exit': a:callback,
            \ })
    else
        let l:job = job_start(a:cmd, {
            \ 'out_cb': function('s:on_vim_job_event', [a:callback, 'stdout']),
            \ 'err_cb': function('s:on_vim_job_event', [a:callback, 'stderr']),
            \ 'exit_cb': function('s:on_vim_job_event', [a:callback, 'exit']),
            \ 'mode': 'raw',
            \ })
        let l:channel = job_getchannel(job)
        return ch_info(l:channel)['id']
    endif
endfunction

function! s:on_vim_job_event(callback, event, id, data) abort
    " normalize to neovim's job api
    if (a:event == 'exit')
        call a:callback(a:id, a:data, a:event)
    else
        call a:callback(a:id, split(a:data, "\n", 1), a:event)
    endif
endfunction
" }}}
