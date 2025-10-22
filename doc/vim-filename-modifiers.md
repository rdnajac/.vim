# Filename Modifiers

| modifier | description |
|----------|-------------|
| `:p`     | Make file name a full path. |
| `:~`     | Make file name relative to home directory. |
| `:.`     | Make file name relative to current directory. |
| `:h`     | Head of the file name (last component removed). |

These modifiers can be given, in this order:
	:~	Reduce file name to be relative to the home directory, if
		possible.  File name is unmodified if it is not below the home
		directory.
	:.	Reduce file name to be relative to current directory, if
		possible.  File name is unmodified if it is not below the
		current directory.
		For maximum shortness, use ":~:.".
	:h	Head of the file name (the last component and any separators
		removed).  Cannot be used with :e, :r or :t.
		Can be repeated to remove several components at the end.
		When the file name ends in a path separator, only the path
		separator is removed.  Thus ":p:h" on a directory name results
		on the directory name itself (without trailing slash).
		When the file name is an absolute path (starts with "/" for
		Unix; "x:\" for Win32), that part is not removed.
		When there is no head (path is relative to current directory)
		the result is empty.
	:t	Tail of the file name (last component of the name).  Must
		precede any :r or :e.
	:r	Root of the file name (the last extension removed).  When
		there is only an extension (file name that starts with '.',
		e.g., ".nvimrc"), it is not removed.  Can be repeated to
		remove several extensions (last one first).
	:e	Extension of the file name.  Only makes sense when used alone.
		When there is no extension the result is empty.
		When there is only an extension (file name that starts with
		'.'), the result is empty.  Can be repeated to include more
		extensions.  If there are not enough extensions (but at least
		one) as much as possible are included.
	:s?pat?sub?
		Substitute the first occurrence of "pat" with "sub".  This
		works like the |:s| command.  "pat" is a regular expression.
		Any character can be used for '?', but it must not occur in
		"pat" or "sub".
		After this, the previous modifiers can be used again.  For
		example ":p", to make a full path after the substitution.
	:gs?pat?sub?
		Substitute all occurrences of "pat" with "sub".  Otherwise
		this works like ":s".
	:S	Escape special characters for use with a shell command (see
		|shellescape()|).  Must be the last one.  Examples: >
		    :!dir <cfile>:S
		    :call system('chmod +w -- ' .. expand('%:S'))

