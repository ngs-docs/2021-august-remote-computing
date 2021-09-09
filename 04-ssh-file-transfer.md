# Running programs on remote computers and retrieving the results

This two hour workshop will show attendees how to use remote computers
to run their analyses, work with the output files, and copy the
results back to their laptop and desktop computers. We will discuss
input and output formats, where files are usually read from and
written to, and how to use the ssh software to copy files to and from
remote computers.

In workshop 4, we will do more with running remote commands, getting
files onto your remote system, file permissions, and actually working
effectively on remote systems. We will also talk a bit about processes
and other aspects of multiuser systems.

## Using SSH private/public key pairs

Today we're going to start by using a different way to log in - ssh key pairs.

Key pairs are a different way to provide access, and they rely on some
mathematical magic called asymmetric cryptography or public-key cryptography
(see [wikipedia](https://en.wikipedia.org/wiki/Public-key_cryptography)).
(The details are far beyond the scope of this lesson, but it's a fascinating
read!)

There are two parts to key pairs - the private part, which you keep
private; and the public part, which you can post publicly. Anyone with
the public key can challenge you to verify that you have the private
key, and only the person with the private key can verify, so it's a
way to "prove" your identity and access. (The same idea can be used to
sign e-mails!)

Key pairs solve some of the problems with passwords. In brief,

- they are (much!) harder to guess than passwords.
- key pairs enable programs to do things without you having to type in your password.
- the private part of a key pair is NEVER shared, unlike with passwords where you have to type the password in.
- but the public part of pair can be shared widely.

Because of these features, some systems demand that you use them. Farm
is (usually) one of them; we have a special exception for the datalab-XX
accounts, because key pairs are a confusing concept to teach right off
the bat.

## Mac OS X and Linux: Using ssh private keys to log in

Your private key for your datalab-XX account is kept in `.ssh/id_rsa`.
We need to copy it locally to make use of it.

Run the following command in your Terminal window:
```
cd ~/
scp datalab-XX@farm.cse.ucdavis.edu:.ssh/id_rsa datalab.pem
```
and then
```
chmod og-rwx datalab.pem
```
(we'll explain the second command below!)

`datalab.pem` is your private key pair!

Now, to log into farm using the key pair, run

```
ssh -i datalab.pem datalab-XX@farm.cse.ucdavis.edu
```
and voila, you are in!

(VICTORY!)

You'll need to keep track of your datalab.pem file. I recommend
keeping it in your home directory for now, which is where we
downloaded it.

## Windows/MobaXterm: Using ssh private keys to log in

For MobaXterm, connect as you did [in workshop 3](connecting-to-remote-computers-with-ssh.html) and download `.ssh/id_rsa` to some location on your
computer, named `datalab.pem`.

Now, create a new session and go to "Advanced SSH options" and select it the
private key pair (see screenshot).

![](moba-private-key.png)

Now connect.

Voila! No password needed!

VICTORY!!

Note that if you change the location of your private key file, you'll need
to go find it again :).

## Some tips on your private key

NEVER SHARE YOUR PRIVATE KEY.

We'll talk more about private key management in the future, but the
basic idea is that you should create a new private key for each computer
you are using, and only share the public key from that computer.

## Working on farm

So farm is a shared computer with persistent storage (which is typical
of a remote workstation or campus compute cluster (HPC). This means a few
different things!

Let's start by logging back into farm. (You got this!)

### First, download some files:

Let's make sure you have the right set of files from the last workshop --
this will take the set of files [here](https://github.com/ngs-docs/2021-remote-computing-binder/) and make them appear in your farm account:
```
cd ~/
git clone https://github.com/ngs-docs/2021-remote-computing-binder/
```
(If you've already done this, you can run this again and it will just fail, and that's fine.)

### Configuring your account on login

One thing you can do is configure your account on login the way you want.
This typically involves configuring your login shell. The shell we're using
is [bash](https://www.gnu.org/software/bash/), and it runs the `.bash_profile`
text file on login.

Let's add a 'hello' message!

Edit the file `~/.bash_profile`, e.g. with nano:
```
nano ~/.bash_profile
```
and type `echo Hello and welcome to farm` at the top of the file.
If using nano, save with `CTRL-X`, say "yes" to save, hit ENTER.

Now log out and log back in.

You should now see 'Hello and welcome to farm' every time you log in!
(You can easily delete it too, if you find it annoying :)

The commands in `.bash_profile` are run every time you log in; there's
also a file called `.bashrc` that is run for *every* shell, [not just login shells](https://unix.stackexchange.com/questions/38175/difference-between-login-shell-and-non-login-shell).

There are two important differences between `.bash_profile` and
`.bashrc`.

**FIRST**, `.bash_profile` is run only on login, while `.bashrc` is
run every time a shell starts. So you can add commands like this:

> ~~~
> alias lf='ls -FC'
> ~~~

to your `.bashrc` if you want to have the `lf` command available at every
shell; we'll cover more configuration commands in
[workshop 6](structuring-your-projects-for-current-and-future-you.html)
and beyond.

**SECOND**, `.bashrc` should not output anything via `echo` (or any
other command), as that will
[prevent the `scp` file copy command from working](https://stackoverflow.com/questions/12440287/scp-doesnt-work-when-echo-in-bashrc).

---

When editing these files, you can see changes without having to log out and log back in using the `source` command. If you add the `alias` command above
into your `.bashrc`, you can test it out like so:
```
source ~/.bashrc
```
and now `lf` will automatically run `ls` with your favorite options.

For another example, here you could make `rm` ask you for confirmation
when deleting files:
```
alias rm='rm -i'
```

**CHALLENGE QUESTION:** Create an alias of `hellow` that prints out
`hello, world` and add it to your `.bashrc`; verify that it works!

## Using multiple terminals

You don't have to be logged in just once.

On Mac OS X, you can use Command-N to open a new Terminal window, and then
ssh into farm from that window too.

On Windows, you can open a new connection from MobaXterm simply by double
clicking your current session under "User sessions."

What you'll end up with are different command-line prompts on the same
underlying system.

They share:

* directory and file access (filesystem)
* access to run the same programs, potentially at the same time

They do not have the same:

* current working directory (`pwd`)
* running programs, and stdin and stdout (e.g. `ls` in one will not go to the other)

These are essentially different _sessions_ on the same computer, much like
you might have multiple folders or applications open on your Mac or Windows
machine.

You can log out of one independently of the other, as well.

And you can have as many terminal connections as you want! You just have
to figure out how to manage them :).

**CHALLENGE:** Open two terminals logged into farm simultaneously - let's call them A and B.

In A, create a file named `~/hello.txt`, and add some text to it. (You
can use an editor like `nano`, or you can use `echo` with a redirect,
for example. If you use an editor, remember to save and exit!)

In B, view the contents of `~/hello.txt`. (You can use `cat` or `less`
or an editor to do so.)

---

A tricky thing here is that B does not necessarily have a way to know that
you're editing a file in A. So you have to be sure to save what you're
doing in one window, before trying to work with it in the other.

We'll cover more of how to work in multiple shell sessions in
[workshop
7](automating-your-analyses-and-executing-long-running-analyses-on-remote-computers.html)
and later.

### Who am I and where am I running!?

If you start using remote computers frequently, you may end up logging
into several different computers and have several different sessions
open at the same time. This can get ...confusing! (We'll show you a
particularly neat way to confuse yourself in [workshop
7](automating-your-analyses-and-executing-long-running-analyses-on-remote-computers.html)!)

There are several ways to help track where you are and what you're doing.

One is via the command prompt. You'll notice that on farm, the command
prompt contains three pieces of information by default: your username,
the machine name ('farm'), and your current working directory!  This is
precisely so that you can look at a terminal window and have some idea
of where you're running.

You might also find the following commands useful:

This command will give you your current username:
```
whoami
```

and this command will give you the name of the machine you're logged
into:
```
hostname
```

These can be useful when you get confused about where you are and who
you're logged in as :)

### Looking at what's running

You can use the `ps` command to see what your account, and other accounts,
are running:
```
ps -u datalab-09
```

This lists all of the different programs being run by that user, across
all their shell sessions.

The key column here is the last one, which tells you what program is
running under that process.

You can also get a sort of "leaderboard" for what's going on on the shared
computer by running
```
top
```
(use 'q' to exit).

This gives a lot of information about running processes, sorted by who is
using the most CPU time. If the system is really slow, it may be because
one or more people are running a lot of things, and `top` will help you
figure out if that's the problem. (Another problem could be if a lot of
people are downloading things simultaneously, like we did in
[workshop 3](connecting-to-remote-computers-with-ssh.html); and yet another
problem that is much harder to diagnose could be that one or more people
are writing a lot to the disk.)

---

This is one of the consequences of having a shared system. You have
access to extra compute, disk, and software that's managed by
professionals (yay!), but you also have to deal with other users
(boo!)  who may be competing with you for resources. We'll talk more
about this when we come to [workshop
10](executing-large-analyses-on-hpc-clusters-with-slurm.html), where
we talk about bigger analyses and the SLURM system for making use of
compute clusters by reserving or scheduling compute.

---

If performance problems persist for more than a few minutes, it can be
a good idea to e-mail the systems administrators, so that they are
alerted to the problem.  How to do so is individual on each computer
system.

On that note --

### E-mailing the systems administrators

When sending an e-mail to support about problems you're having with a
system, it's really helpful if you include:

* your username and the system you're working on
* the program or command you're trying to use, together with as much information about it as possible (version, command line, etc.)
* what you're trying to do and what's going wrong ("I'm trying to log in from my laptop to farm on the account datalab-06, and it's saying 'connection closed'.")
* a screenshot or copy/paste of the confusing behavior
* a thank you

This information is all useful because they deal with dozens of users
a day, and may be managing many systems, and may not be directly familiar
with the software you're using. So the more information you can provide
the better!

## File systems, directories, and shared systems

One of the other consequences of working on a shared system is that you're
often sharing _file systems_ with other people. That means you need to
make sure they don't have access to things they shouldn't have access to.

### Read and write permissions into other directories

Try running this:
```
ls ~datalab-09/
```
what do you see?

That's right, that's _my_ account, and _my_ files.

Now run it again:
```
ls ~datalab-09/
```

By default, home directories on many systems are
readable by everyone.  However, they're never _writable_ unless you
enable that intentionally for a directory.

To see that, try creating a file in my home directory:
```
echo hi > ~datalab-09/test.txt
```
and you will see `Permission denied`.

### Listing directory and file permissions

Let's look at your home directory:

```
ls -lad ~/
```
you should see something like:

> ~~~
> drwx------ 3 datalab-08 datalab-08 3 Aug  5 18:32 /home/datalab-08
> ~~~

and compare that to what you get if you look at my home directory:

```
ls -lad ~datalab-09/
```
where you will see:

> ~~~
> drwxr-xr-x 8 datalab-09 datalab-09 10 Aug 11 17:59 /home/datalab-09
> ~~~

what does this all mean?

In order, you have:

* 'd' means directory
* the first 'rwx' means 'readable, writable, executable by owner'
* the second 'r-x' means 'readable, not writable, executable by group'
* the third 'r-x' means 'readable, not writable, executable by others'
* the first 'datalab-09' is the owner of the directory
* the second 'datalab

In the context of directories, the "x" means "can change into it." If a
directory is not +x for a particular user, that means they cannot change
into it or into any directory _underneath_ it.

(We'll talk more about what "executable" means in [workshop
7](automating-your-analyses-and-executing-long-running-analyses-on-remote-computers.html),
when we talk about scripting.)

If you go back and look at your own home directory, you can see that 
by default (the way these accounts were set up), only you have

> ~~~
> drwx------ 3 datalab-08 datalab-08 3 Aug  5 18:32 /home/datalab-08
> ~~~

Now let's modify it so that other members of group `datalab-08` can access it --
```
chmod g+rx ~/
ls -lad ~/
```
and you should see:

> ~~~
> drwxr-x--- 3 datalab-08 datalab-08 3 Aug  5 18:32 /home/datalab-08
> ~~~

Likewise, you could make it group _writable_ with `g+w`, and you
could make it world readable with `o+rx` - for example, `~ctbrown` is
world readable.

You can set user, group, and 'other' permissions all at once with 'a' -
so, for example, `chmod a+rx ~/` would make your home directory
readable/executable by the user, the group, and everyone else.

One particularly useful thing you can do is make files _read only_ for
yourself! This prevents you from changing or deleting them by accident.
For example,
```
echo do not change me > important-file.txt
chmod a-w important-file.txt
echo new information > important-file.txt
```
and you should see 'permission denied.'

### Files have the same permission options

So far we've been talking about directories, but files have the same
permission settings. Try running
```
ls -la ~/
```
and you'll see the same kind of output for files. Here you can set
`+r` or `-r` for read, `+w` or `-w` for write, etc.

### How do groups work?

You might be puzzled to note that your files belong to a group with the
same name as your username. What's up with that?

On many systems (farm included) users are set up with a default group
that only they belong to. Then users are added to additional groups as
needed. This gives them the option of using groups for sharing files
via group permissions, but decreases the likelihood that files get
shared by accident.

For this reason, all of the datalab-XX users belong to multiple groups:
one group that is uniquely yours, and one group that is shared by all
of the datalab-XX users.

You can see what groups you (and other users) are members of like so:
```
groups datalab-09
```
where you will see that I am a member of two groups, `datalab-09` and
`datalab`.

If you are a member of a group, you can use the `chgrp` command to
change the owning group of a file to that group:

```
echo test > test-file.txt
chgrp datalab test-file.txt
ls -lad test-file.txt
```

**CHALLENGE:** What commands would you run to change the permissions on
`test-file.txt` so that all the datalab-XX users have read and execute
(but not write!) access to it? Note that all datalab-XX users belong
to the `datalab` group.

(You may not want to run these commands, but it won't hurt if you do.
Plus you can always change them back.)

### How can you use this?

I rarely use group permissions in my home directory, because I usually
default to having my files be `a+r`

But sometimes on farm there are large files that people in my research
group want to share with each other but not with others, and you can
use group permissions to manage access to things like that.

Good practice (or at least practice that I recommend) is to do the
following:

* put research-private files under directories that are `g+rx` and `o-rwx`.
* if you have a directory where you want people to be able to add new files but not change old ones, you can make the directory itself `g+rwx` but keep the files `g+r` and `g-w` (which is usually the default).

That having been said, when setting something like this up for the
first time, it's worth writing down what you want the access
permissions to be, then setting them up with chmod, and then checking
with someone experienced (like the systems administrators) that you've
got the right permissions for the policies you want to enforce.

Note also that UNIX file permissions are kind of a blunt instrument,
so I recommend keeping it as simple as possible. Generally you want to
be using a separate system for tracking raw data and making sure that
it's backed up, etc. - there are various archival systems that we can
recommend, depending on your file sizes and your research needs.

### Things that regular users cannot do

There are basically no exceptions to the permissions rules above for
regular users. Linux has (by default) only two "tiers" of users - a
regular user, and a "superuser", usually referred to as "root".  Only
root can do things like change the ownership of files, access files
with restrictive permissions, etc.

One situation where this can be important is when someone leaves a
research group and you need access to their files but they no longer
have access to the system themselves because their account is disabled.

In this case, you might have to have a supervisor or the researcher
themselves e-mail the farm systems administrators to fix the access
problem, because they are the only people besides the owner of the
file(s) who can change the permissions.

It's also a good reminder that on shared systems, other people _will_
have access to your files - that's completely legal and
correct (because they're the people running the system!) But this is why
you need to be careful about what systems you use to store sensitive
information, and why words like "HIPAA compliant" become important -
it ensures that certain security and access policies are in place to
protect sensitive data.

## Disk space, file size, and temporary files

You can see how much free disk space you have in the current directory
with this command:

```
df -h .
```

You can see how much disk space a directory is using with `du`:
```
du -sh ~/
```

I highly recommend using `/tmp` for small temporary files. For bigger
files that you might want to persist but only need on one particular
system, there is often a location called `/scratch` where you can make
a directory for yourself and store things. We'll talk more about that
in [workshop
10](executing-large-analyses-on-hpc-clusters-with-slurm.html).

Finally, the command
```
free
```
will show you how much system memory is available and being used.

This command:
```
cat /proc/cpuinfo
```
will give you far too much information about what processors are available.

Again, we'll talk more about this in workshop 10 :).

## Summing things up

In this workshop, we talked a fair bit about working on shared systems,
setting permissions on files, transferring files around, and otherwise
being effective with using remote computers to do things.

In [workshop
5](installing-software-on-remote-computers-with-conda.html), we'll
show you how to customize your _software_ environment so you can do
the specific work you want to do. We'll use CSV files, R, and some
bioinformatics tools as examples.
