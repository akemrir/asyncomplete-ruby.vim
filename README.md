ruby source for asyncomplete.vim
================================

Provide ruby completions for [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim)

Distionary source thanks to [fishbullet/deoplete-ruby](https://github.com/fishbullet/deoplete-ruby)

### Installing

```viml
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'akemrir/asyncomplete-ruby.vim'
```

#### Registration

```viml
call asyncomplete#register_source(asyncomplete#sources#ruby#get_source_options({
      \ 'name': 'ruby',
      \ 'priority': 1,
      \ 'whitelist': ['ruby'],
      \ 'completor': function('asyncomplete#sources#ruby#completor'),
      \ }))
```


#### Todo

* Implementation of startcol to allow suggestions from middle of line
