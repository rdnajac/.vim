function! s:parse(repo, ...) abort
  if a:0 > 1
    return s:err('Invalid number of arguments (1..2)')
  endif

  try
    let repo = s:trim(a:repo)
    let opts = a:0 == 1 ? s:parse_options(a:1) : s:base_spec
    let name = get(opts, 'as', s:plug_fnamemodify(repo, ':t:s?\.git$??'))
    let spec = extend(s:infer_properties(name, repo), opts)
    if !has_key(g:plugs, name)
      call add(g:plugs_order, name)
    endif
    let g:plugs[name] = spec
    let s:loaded[name] = get(s:loaded, name, 0)
  catch
    return s:err(repo . ' ' . v:exception)
  endtry
endfunction

" examples from the `vim-plug` docs
let s:cases = [
      \ 'junegunn/seoul256.vim',
      \ 'https://github.com/junegunn/vim-easy-align.git',
      \ 'fatih/vim-go', { 'tag': '*' },
      \ 'neoclide/coc.nvim', { 'branch': 'release' },
      \ 'junegunn/fzf', { 'dir': '~/.fzf' },
      \ 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' },
      \ 'junegunn/fzf', { 'do': { -> fzf#install() } },
      \ 'nsf/gocode', { 'rtp': 'vim' },
      \ 'preservim/nerdtree', { 'on': 'NERDTreeToggle' },
      \ 'tpope/vim-fireplace', { 'for': 'clojure' },
      \ '~/my-prototype-plugin',
      \ ]

function! plug#test#() abort
  for case in s:cases
    if type(case) == type('')
      let spec = s:parse(case)
    elseif type(case) == type([])
      let repo = case[0]
      let opts = len(case) > 1 ? case[1] : {}
      let spec = s:parse(repo, opts)
    else
      let spec = []
    endif
    echo string(spec)
    echo '-------------------------'
  endfor
endfunction
