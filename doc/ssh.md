# ssh and vim

ssh hostname -t tmux a

the t flag is for "force pseudo-terminal allocation". This is useful if you want
to run an interactive command on the remote host, such as tmux or vim.

## netrw

from 'ssh hints':

- <http://thomer.com/howtos/netrw_ssh.html>
- <https://web.archive.org/web/20120319233142/https://www.usevim.com/2012/03/16/editing-remote-files/>

Also read:

- `:h netrw-netrc`
- `:h netrw-ssh-hack`
- `:h netrw_ssh_cmd`

