" Vim compiler file
" Compiler:	Markdownlint
" Maintainer:	Ryan Najac <ryan.najac@columbia.edu>
" Last Change:	2024 Jul 23 

if exists("current_compiler")
  finish
endif
let current_compiler = "markdownlint"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=markdownlint\ --fix
CompilerSet errorformat=%f:%l:%c\ MD%n/%m,
		       \%f:%l\ MD%n/%m,

let &cpo = s:cpo_save
unlet s:cpo_save

