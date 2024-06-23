" Copies the current sh file over to the remote server at 'my-ec2'
" (e.g) !scp % my-ec2:/home/ubuntu/ " Copies the current file to the remote
" server at 'my-ec2' and places it in the /home/ubuntu/ directory
" it makes it an executable file and runs it on the remote server
finish
function! RunScriptOnMyEC2() abort
  let l:remote_server = 'my-ec2'
	let l:remote_dir = '/home/ubuntu/'
	let l:remote_file = l:remote_dir . expand('%:t')
	let l:remote_executable = l:remote_file . '.sh'

	let l:cmd = '!scp % ' . l:remote_server . ':' . l:remote_dir
	call system(l:cmd)

	let l:cmd = '!ssh ' . l:remote_server . ' chmod +x ' . l:remote_file
	call system(l:cmd)

	let l:cmd = '!ssh ' . l:remote_server . ' ' . l:remote_executable
	call system(l:cmd)
