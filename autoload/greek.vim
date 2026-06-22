scriptencoding utf-8

let g:greek#alphabet = {'upper': {}, 'lower': {}}

let g:greek#alphabet.upper = {
\ 'Alpha': 'Α',
\ 'Beta': 'Β',
\ 'Gamma': 'Γ',
\ 'Delta': 'Δ',
\ 'Epsilon': 'Ε',
\ 'Zeta': 'Ζ',
\ 'Eta': 'Η',
\ 'Theta': 'Θ',
\ 'Iota': 'Ι',
\ 'Kappa': 'Κ',
\ 'Lambda': 'Λ',
\ 'Mu': 'Μ',
\ 'Nu': 'Ν',
\ 'Xi': 'Ξ',
\ 'Pi': 'Π',
\ 'Rho': 'Ρ',
\ 'Sigma': 'Σ',
\ 'Tau': 'Τ',
\ 'Upsilon': 'Υ',
\ 'Phi': 'Φ',
\ 'Chi': 'Χ',
\ 'Psi': 'Ψ',
\ 'Omega': 'Ω',
\ }

let g:greek#alphabet.lower = {
\ 'alpha': 'α',
\ 'beta': 'β',
\ 'gamma': 'γ',
\ 'delta': 'δ',
\ 'epsilon': 'ε',
\ 'zeta': 'ζ',
\ 'eta': 'η',
\ 'theta': 'θ',
\ 'iota': 'ι',
\ 'kappa': 'κ',
\ 'lambda': 'λ',
\ 'mu': 'μ',
\ 'nu': 'ν',
\ 'xi': 'ξ',
\ 'pi': 'π',
\ 'rho': 'ρ',
\ 'sigma': 'σ',
\ 'tau': 'τ',
\ 'upsilon': 'υ',
\ 'phi': 'φ',
\ 'chi': 'χ',
\ 'psi': 'ψ',
\ 'omega': 'ω',
\ }

" for [name, char] in items(g:greek#alphabet.upper)
"   exe printf('iabbrev \%s %s', name, char)
" endfor

" for [name, char] in items(g:greek#alphabet.lower)
"   exe printf('iabbrev \%s %s', name, char)
" endfor
