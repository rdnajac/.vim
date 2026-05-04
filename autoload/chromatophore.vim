if !exists('g:chromatophores')
  let g:chromatophores = [ 'String' ]
" let g:chromatophores = [
"       \ 'String',
"       \ 'FloatBorder',
"       \ 'FloatFooter',
"       \ 'MsgArea',
"       \ 'MsgSeparator',
"       \ 'Pmenu',
"       \ 'PmenuBorder',
"       \ 'PmenuSbar',
"       \ 'Title',
"       \ 'StatusLineNC',
"       \ 'StatusLineTermNC',
"       \ ]
endif

if has('nvim')
  function! s:add(group) abort
    call add(g:chromatophores, a:group)
  endfunction
  call s:add('WinBar')
  call s:add('helpSectionDelim')
  call s:add('manOptionDesc')
  " call s:add('@markup.raw.markdown_inline')
  call s:add('MiniIconsGreen')
  " call s:add('SnacksDashboardDesc')
  " call s:add('SnacksDashboardHeader')
  " call s:add('SnacksDashboardIcon')
  " call s:add('SnacksDashboardKey')
  " call s:add('SnacksDashboardNormal')
  " call s:add('SnacksDashboardSpecial')
  " call s:add('SnacksDashboardTerminal')
  " call s:add('SnacksIndentScope')
endif

function! s:hi(name, fg, bg, ...) abort
  execute printf('highlight %s guifg=%s guibg=%s%s',
	\ a:name, a:fg, a:bg, a:0 ? ' gui='..a:1 : '')
endfunction

function! chromatophore#setup() abort
  let black      = '#000000'
  let eigengrau  = '#16161d'
  let grey       = '#3b4261'
  let mode_color = chromatophore#color()

  highlight! Black guifg=black
  " highlight! Chromatophore_a guifg=
  call s:hi('Chromatophore',    mode_color, 'NONE')
  call s:hi('ChromatophoreB',   mode_color, 'NONE', 'bold')
  " call s:hi('Chromatophore_a',  mode_color, eigengrau,'bold,reverse')
  call s:hi('Chromatophore_a',  black,  mode_color, 'bold')
  call s:hi('Chromatophore_b',  mode_color, grey,       'bold')
  " call s:hi('Chromatophore_c',  mode_color, eigengrau)
  call s:hi('Chromatophore_c',  mode_color, 'NONE')
  call s:hi('Chromatophore_z',  mode_color, eigengrau, 'bold')
  call s:hi('Chromatophore_ab', mode_color, grey)
  call s:hi('Chromatophore_bc', grey,       eigengrau)
  call s:hi('Chromatophore_bc', grey,      'NONE')
  call s:hi('Chromatophore_cN', eigengrau, 'NONE')
  call s:hi('Chromatophore_ac', mode_color, eigengrau)
  for group in g:chromatophores
    exe $'highlight! link {group} Chromatophore'
  endfor
endfunction

let s:mode_color_map = {
      \ 'normal':   '#39FF14',
      \ 'visual':   '#F7768E',
      \ 'select':   '#FF9E64',
      \ 'replace':  '#FF007C',
      \ 'command':  '#E0AF68',
      \ 'terminal': '#BB9AF7',
      \ 'shell':    '#14AEFF',
      \ 'pending':  '#E0AF68',
      \ }
" \ 'command':  '#FFFFFF',
" \ 'insert':   '#9ECE6A',

" Map Vim mode chars to normalized mode keys
let s:mode_map = {
      \ 'n': 'normal',
      \ 'i': 'insert',
      \ 'v': 'visual',
      \ 'V': 'visual',
      \ "\<C-V>": 'visual',
      \ 's': 'select',
      \ "\<C-S>": 'select',
      \ 'R': 'replace',
      \ 'c': 'command',
      \ 'r': 'command',
      \ 't': 'terminal',
      \ '!': 'shell',
      \ }

function! s:color(...) abort
  let l:mode = a:0 ? a:1 : mode(1)
  " Detect true operator-pending only if we're still waiting
  if l:mode =~# '^no' && getchar(1) == 0
    return 'pending'
  endif
  return get(s:mode_map, l:mode[0], 'normal')
endfunction

function! chromatophore#color() abort
  return get(s:mode_color_map, s:color(), s:mode_color_map.normal)
endfunction

function! chromatophore#metachrosis() abort
  let color = chromatophore#color()
  for suffix in ['', '_ab', '_b', '_c', '_z']
    execute printf('highlight Chromatophore%s guifg=%s', suffix, color)
  endfor
  execute 'highlight Chromatophore_a guibg=' . l:color
endfunction

augroup chromatophore
  autocmd!
  autocmd ColorScheme * call chromatophore#setup()
  autocmd ModeChanged * call chromatophore#metachrosis()
  " HACK:
  au FileType snacks_dashboard lua vim.schedule(function() vim.cmd('doautocmd ColorScheme') end)
augroup END
