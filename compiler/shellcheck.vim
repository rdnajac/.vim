CompilerSet makeprg=shellcheck\ -f\ gcc
CompilerSet errorformat=%f:%l:%c:\ %trror:\ %m\ [SC%n],
               \%f:%l:%c:\ %tarning:\ %m\ [SC%n],
               \%f:%l:%c:\ %tote:\ %m\ [SC%n],
               \%-G%.%#
