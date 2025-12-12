# Initialization

At startup, Nvim checks environment variables and files and sets values
accordingly, proceeding as follows:

1. Set the 'shell' option			*SHELL* *COMSPEC*
	The environment variable SHELL, if it exists, is used to set the
	'shell' option.  On Win32, the COMSPEC variable is used
	if SHELL is not set.

2. Process the arguments
	The options and file names from the command that start Vim are
	inspected.
	The |-V| argument can be used to display or log what happens next,
	useful for debugging the initializations.
	The |--cmd| arguments are executed.
	Buffers are created for all files (but not loaded yet).

3. Start a server (unless |--listen| was given) and set |v:servername|.

4. Wait for UI to connect.
	Nvim started with |--embed| waits for the UI to connect before
	proceeding to load user configuration.

5. Setup |default-mappings| and |default-autocmds|.  Create |popup-menu|.

6. Enable filetype and indent plugins.
	This does the same as the command: >
		:runtime! ftplugin.vim indent.vim
<	Skipped if the "-u NONE" command line argument was given.

7. Load user config (execute Ex commands from files, environment, …).
	$VIMINIT environment variable is read as one Ex command line (separate
	multiple commands with '|' or <NL>).
					*config* *init.vim* *init.lua* *vimrc* *exrc*
	A file containing initialization commands is generically called
	a "vimrc" or config file.  It can be either Vimscript ("init.vim") or
	Lua ("init.lua"), but not both. *E5422*
	See also |vimrc-intro| and |base-directories|.

	The config file is located at:
	Unix			~/.config/nvim/init.vim		(or init.lua)
	Windows			~/AppData/Local/nvim/init.vim	(or init.lua)
	|$XDG_CONFIG_HOME|	$XDG_CONFIG_HOME/nvim/init.vim	(or init.lua)

	If Nvim was started with "-u {file}" then {file} is used as the config
	and all initializations until 8. are skipped. $MYVIMRC is not set.
	"nvim -u NORC" can be used to skip these initializations without
	reading a file.  "nvim -u NONE" also skips plugins and syntax
	highlighting.  |-u|

	If Nvim was started with |-es| or |-Es| or |-l| all initializations until 8.
	are skipped.
						*system-vimrc* *sysinit.vim*
     a. The system vimrc file is read for initializations.  If
	nvim/sysinit.vim file exists in one of $XDG_CONFIG_DIRS, it will be
	used.  Otherwise the system vimrc file is used. The path of this file
	is given by the |:version| command.  Usually it's "$VIM/sysinit.vim".

						*VIMINIT* *EXINIT* *$MYVIMRC*
     b. Locations searched for initializations, in order of preference:
	-  $VIMINIT environment variable (Ex command line).
	-  User |config|: $XDG_CONFIG_HOME/nvim/init.vim (or init.lua).
	-  Other config: {dir}/nvim/init.vim (or init.lua) where {dir} is any
	   directory in $XDG_CONFIG_DIRS.
	-  $EXINIT environment variable (Ex command line).
	|$MYVIMRC| is set to the first valid location unless it was already
	set or when using $VIMINIT.

     c. If the 'exrc' option is on (which is NOT the default), the current
	directory is searched for the following files, in order of precedence:
	- ".nvim.lua"
	- ".nvimrc"
	- ".exrc"
	The first that exists is used, the others are ignored.

8. Enable filetype detection.
	This does the same as the command: >
		:runtime! filetype.lua
<	Skipped if ":filetype off" was called or if the "-u NONE" command line
	argument was given.

9. Enable syntax highlighting.
	This does the same as the command: >
		:runtime! syntax/syntax.vim
<	Skipped if ":syntax off" was called or if the "-u NONE" command
	line argument was given.

10. Set the |v:vim_did_init| variable to 1.

11. Load the plugin scripts.					*load-plugins*
	This does the same as the command: >
		:runtime! plugin/**/*.{vim,lua}
<	The result is that all directories in 'runtimepath' will be searched
	for the "plugin" sub-directory and all files ending in ".vim" or
	".lua" will be sourced (in alphabetical order per directory),
	also in subdirectories. First "*.vim" are sourced, then "*.lua" files,
	per directory.

	However, directories in 'runtimepath' ending in "after" are skipped
	here and only loaded after packages, see below.
	Loading plugins won't be done when:
	- The 'loadplugins' option was reset in a vimrc file.
	- The |--noplugin| command line argument is used.
	- The |--clean| command line argument is used.
	- The "-u NONE" command line argument is used |-u|.
	Note that using `-c 'set noloadplugins'` doesn't work, because the
	commands from the command line have not been executed yet.  You can
	use `--cmd 'set noloadplugins'` or `--cmd 'set loadplugins'` |--cmd|.

	Packages are loaded.  These are plugins, as above, but found in the
	"start" directory of each entry in 'packpath'.  Every plugin directory
	found is added in 'runtimepath' and then the plugins are sourced.  See
	|packages|.

	The plugins scripts are loaded, as above, but now only the directories
	ending in "after" are used.  Note that 'runtimepath' will have changed
	if packages have been found, but that should not add a directory
	ending in "after".

12. Set 'shellpipe' and 'shellredir'
	The 'shellpipe' and 'shellredir' options are set according to the
	value of the 'shell' option, unless they have been set before.
	This means that Nvim will figure out the values of 'shellpipe' and
	'shellredir' for you, unless you have set them yourself.

13. Set 'updatecount' to zero, if "-n" command argument used.

14. Set binary options if the |-b| flag was given.

15. Read the |shada-file|.

16. Read the quickfix file if the |-q| flag was given, or exit on failure.

17. Open all windows
	When the |-o| flag was given, windows will be opened (but not
	displayed yet).
	When the |-p| flag was given, tab pages will be created (but not
	displayed yet).
	When switching screens, it happens now.  Redrawing starts.
	If the |-q| flag was given, the first error is jumped to.
	Buffers for all windows will be loaded, without triggering |BufAdd|
	autocommands.

18. Execute startup commands
	If a |-t| flag was given, the tag is jumped to.
	Commands given with |-c| and |+cmd| are executed.
	The starting flag is reset, has("vim_starting") will now return zero.
	The |v:vim_did_enter| variable is set to 1.
	The |VimEnter| autocommands are executed.

