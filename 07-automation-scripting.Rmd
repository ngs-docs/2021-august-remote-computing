# Automating your analyses and executing long-running analyses on remote computers

This two hour workshop will show attendees how to automate their
analyses using shell scripts, as well as run and manage software that
takes minutes, hours, or days to execute. We’ll also show you how to
disconnect from and resume running processes using the ‘screen’ and 'tmux'
commands.


This lesson was adapted from [a lesson](https://github.com/ngs-docs/2021-GGG298/tree/latest/Week8-project_organization_and_UNIX_shell#file-manipulation) co-authored by Shannon Joslin for GGG 298 at UC Davis.

Learning objectives:

- Commands `for`, `basename`, `echo`, `if`
- How to write and execute shell scripts
- Learning how to use multiple sessions with screen for long-running analyses

## What is a script?

A script is like a recipe of commands for the computer to execute. We're teaching you how to make shell scripts today, but scripts can be in any programming language (R, python, etc.).

Why and when would we want to use scripts vs. typing commands directly at the terminal?

   - Automate: don't have to remember all the commands and type then one at a time
   - Scale up: can use same script for multiple samples, multiple processes
   - Reproduce & share: easier to reproduce or share analyses because it's all written down
   - Version control: stay tuned for [workshop 8](keeping-track-of-your-files-with-version-control.html)!

Note that scripts are especially helpful for processing many files with the same commands - but sometimes it's not always worth the time/effort for an uncommon task. See [xkcd comic](https://xkcd.com/1205/) - is it worth the time? :)

## Getting started

As per the instructions in [workshop
3](connecting-to-remote-computers-with-ssh.html) and [workshop
4](running-programs-on-remote-computers-and-retrieving-the-results.html),
log into farm.cse.ucdavis.edu using your datalab-XX account.

When you log in, your prompt should look like this:

> ~~~
> (base) datalab-09@farm:~$
> ~~~

If it doesn't, please alert a TA and we will help you out!

## Automating commands by putting them in a text file

### Running scripts with `bash`

At the terminal, we can type:
```
echo Hello, this is the terminal!
```

In a script, we can do the same thing - (we covered how to create and edit files with `nano` from [Workshop 2!](creating-and-modifying-text-files-on-remote-computers.html)):

Create a script file with nano - The file extension for shell scripts is '.sh'.
```
nano first_script.sh
```

Add the following 3 lines to the script:
```
#!/bin/bash
echo Hello, this is a script!
echo I am on the next line!
```

The `#!/bin/bash` header (this is known as a "[sha-bang](https://en.wikipedia.org/wiki/Shebang_(Unix))" or hashbang) tells the shell how to interpret the script file.  It will be used later!

Execute the script
```
bash first_script.sh
```

Note that commands are executed in the order that they appear in the script


## `for` Loops

Scripts can do far more than print echo statements! We're gonna take a detour to learn about for loops and then run loops in scripts.

In workshop 6, we showed you a way to create a list of the md5sum numbers for the autosome files:
```
cd ~/seqdata/mini_A-torda

md5sum mini-chr[1-9]*.fna.gz  >> autosomes.md5
```

This approach uses wildcards to tell the shell to grab the md5sum for all files starting with `mini-chr`, with a number from 1 to 9, and ending with '.fna.gz'. Another way to do this, and include the Z chromosome file as well, is to write a for loop that runs the `md5sum` command for each '.fna.gz' file in the directory:

(To type this in the terminal, type 'enter' or 'return' after each line)
```
for i in *.fna.gz
do
   echo md5sum $i
done
```

**QUESTION:** why did we put `echo` here?

Another way to enter the for loop code into the terminal uses `;`:
```
for i in *.fna.gz; do echo md5sum $i; done
```

for loop structure:

- we set the counter for the thing we want to iterate ("loop") through with the `for i in *.fna.gz`. In this case, we are running the same command for each file in our current directory that ends in '.fna.gz'. The `i` represents the ith file in our loop and we refer to it with the `$` notation (more on variables later!) - also, "i" is an arbitrary name; it could be "potato" :)
- starts with `do` and ends with `done`
- loop components are separated by `;` or new lines.

*We have used indentation to make it easier to read the for loops in the notes, but the shell does NOT need indentation to interpret the loop! Note that other programming languages like Python do require indentation!*

Now, let's append those md5sum numbers to a text file
```
for i in *.fna.gz; do md5sum $i >> my_md5sum_list.txt; done
```

**Reminder:** The `>>` are appending the md5sum values to 1 text file.

Check out the list (exit by pressing q)
```
less my_md5sum_list.txt
```

Now, let's practice for loops by renaming MiSeq sequence file names - we're going to build a for loop step by step. Go to this directory: `~/2021-remote-computing-binder/data/MiSeq`:
```
cd ~/2021-remote-computing-binder/data/MiSeq
```

and then type

```
for i in *.fastq
do
   echo $i
done
```

This is running the command `echo` for every value of the variable `i`, which is set (one by one) to all the values in the expression '*.fastq'.

If we want to get rid of the extension '.fastq', we can use the `basename` command:

```
for i in *.fastq
do
   basename $i .fastq
done
```

Now, this doesn't actually rename the files - it just prints out the name, with the suffix '.fastq' removed.  To rename the files, we need to capture the new name in a variable:

```
for i in *.fastq
do
   newname=$(basename $i .fastq).fq
   echo $newname
done
```

What `$( ... )` does is run the command in the middle, and then replace the `$( )` with the output of running the command. This output is assigned to the variable "newname".

*Side note:* you may see backticks used instead of `$(...)`. It does the same thing but the syntax is trickier to get right, so we teach `$(...)` instead of `` `...` ``. Note that `$( ... )` can be nested, to, so you can do `$( command $( command2 ))` which is occasionally handy.

Now we have the old name (`$i`) and the new name (`$newname`) and we're ready to write the rename command --

```
for i in *.fastq
do
   newname=$(basename $i .fastq).fq
   echo mv $i $newname
done
```

**CHALLENGE:** Run the above loop in a shell script called `rename_file.sh`.


Now that we're pretty sure it all looks good, let's run it for realz - the shell script should look like this:

```
#!/bin/bash

for i in *.fastq
do
   newname=$(basename $i .fastq).fq
   mv $i $newname
done
```


### Subsetting

Let's do something quite useful - subset a bunch of FASTQ files.

If you look at one of the FASTQ files with head,

```
head F3D0_S188_L001_R1_001.fq
```

you'll see that it's full of FASTQ sequencing records.  Often I want to run a bioinformatics pipeline on some small set of records first, before running it on the full set, just to make sure all the syntax for all the commands work ("data forensics"). So I'd like to subset all of these files *without* modifying the originals.

First, let's make sure the originals are read-only

```
chmod u-w *.fq
```

Now, let's make a 'subset' directory

```
mkdir subset
```

Now, to subset each file, we want to run a 'head' with an argument that is the total number of lines we want to take.  In this case, it should be a multiple of 4, because FASTQ records have 4 lines each. Let's take the first 100 records of each file by using `head -400`.

The for loop will now look something like:

```
for i in *.fq
do
   echo "head -400 $i > subset/$i"
done
```

**QUESTION:** We need to use `" "` for the echo statement above - why?

If that command looks right, run it for realz:

```
for i in *.fq
do
   head -400 $i > subset/$i
done
```

and voila, you have your subsets! We can check the number of lines for all the subset files:
```
wc -l ./subset/*
```

(This is incredibly useful. You have no idea :)

**CHALLENGE:** Can you rename all of your files in subset/ to have 'subset.fq' at the end?

### Variables

Let's backtrack a bit - what are variables?

We've seen 2 examples of variables so far - `$i` and `$newname`:
```
for i in *.fastq
do
   newname=$(basename $i .fastq).fq
   mv $i $newname
done
```

You can use either $varname or ${varname}.  The latter is useful when you want to construct a new filename, e.g.

```
MY${varname}SUBSET
```

would expand ${varname} and then put "MY" and "SUBSET" on either end, while

```
MY$varnameSUBSET
```

would try to put "MY" in front of $varnameSUBSET which won't work - unknown/uncreated variables are evaluated to empty by default, so this would just expand
to `MY`.

We recommend always using `${name}` instead of `$name`, because it
always works the way you expect, unlike `$name`, which can be
confusing when constructing new filenames as above.

NOTE: `${varname}` is quite different from `$(expression)`! The former is replaced by the value assigned to `varname`; the latter is replaced by the result of running `expression`. So, both *replace* but they do different things. Think of `$` here as meaning, "replace me with something".

## Troubleshooting scripts

As we've seen above, the `echo` statements help to make sure the commands look correct before running for real.

There are several `set` options that are useful to determine what happens to your script on failure. We recommend:

- Always put `set -e` at the top.
- Sometimes put `set -x` at the top.

### Practicing `set -e` in bash scripts

1. We're going to use the MiSeq .fq files again. Create an output report directory
```
cd ~/2021-remote-computing-binder/data
mkdir ./MiSeq/fastqc_reports
```

2. Create and activate a conda environment that has `fastqc` installed in it (see [workshop 5 notes on conda](installing-software-on-remote-computers-with-conda.html)):

```
mamba create -n fqc -y fastqc
conda activate fqc
```

3. Write a for loop that runs fastqc on each .fq files with a shell script. Create a bash script using nano text editor (save and exit with CTRL-O, enter, CTRL-X on keyboard)
```
nano set_e.sh
```

Create a bash script with the following commands, this version includes `set -e`:

```
#!/bin/bash

set -e

OUTDIR='fastqc_reports'

for i in ./MiSeq/*.fq
do
   echo $i
   fastqc $i -o $OUTDIR
done
```

**Reminder:** Another way to type bash `for` loops is with the `;`, for example this syntax does the same thing as above:

```
for i in ./MiSeq/*.fq; do echo $i; fastqc $i -o $OUTDIR; done
```

This command runs the script:

```
bash set_e.sh
```

**CHALLENGE**

1. What happens when you run the bash script above **with** and **without** the `set -e` option?
2. There is an error in the bash script. How would you fix the script? (Bonus: try adding `set -x` to your bash script)


## If statements

If statements act on things conditionally. For example, you might want to do something if a file exists and a different thing if the file doesn't. In other words, if statements evaluate outputs as True or False and use the output to decide what action to take - it's like a decision tree.

(Note that [conditional operators in Unix](https://www.tutorialspoint.com/unix/unix-basic-operators.htm) are not all the same as in other programming languages)

`if` statement structure:

- starts with `if` and ends with `fi`
- loop components are separated by `;` or indentation

Here, we're wrapping if statements in a for loop:  

```
cd ~/
nano if-for.sh
```

Put this loop in the `if-for.sh` script file:
```
for i in *
do
   if [ -f $i ]; then
      echo $i is a file
   elif [ -d $i ]; then
      echo $i is a directory
   fi
done
```

(the version of above loop that uses the `;` separators)
```
for i in *; do if [ -f $i ]; then echo $i is a file; elif [ -d $i ]; then echo $i is a directory; fi; done
```

but what the heck is this `[ ]` notation? That's actually running the 'test' command; try `help test | less` to see the docs. This is a weird syntax that lets you do all sorts of useful things with files -- I usually use it to get rid of empty files.

```
touch emptyfile.txt
```

to create an empty file, and then:

```
for i in *
do
   if [ \! -s $i ]; then
      echo rm $i
   fi
done
```

...and as you can see here, I'm using '!' to say 'not'. (Why do I need to put a backslash in front of it, though??)

(`-s` tests if a file exists and is not empty)

### Running scripts in a loop

We can run loops in scripts AND scripts in loops!

Say we have an `ifs.sh` script that compares 2 numbers with an if statement:

```
#!/bin/bash

a=40
b=20

if [ $a != $b ]
then
  echo 'a is not equal to b!'
else
  echo 'a is equal to b!'
fi
```

Run the script:
```
bash ifs.sh
```

**QUESTION:** What does the `!=` conditional operator mean?

Now, let's edit this script to give it arguments. Instead of editing the values for "a" and "b" in the script, we'll create "a" and "b" arguments so we can change them when executing the script.

Here's how we change the script - `$` and the number assigns the argument a position in the line of code.

```
#!/bin/bash

a=$1
b=$2

if [ $a != $b ]
then
  echo 'a is not equal to b!'
else
  echo 'a is equal to b!'
fi
```

After the `bash <script name>`, the syntax now assigns the 1st element (`$1`) to `40` and the 2nd element (`$2`) to `20`. This means you can enter different numbers when executing the script, without needing to edit the script file at all!

```
bash ifs.sh 40 20
```

Note, you can add `echo` statements to the script to remind you what the arguments are. This is often helpful for troubleshooting and building the script, for example:
```
#!/bin/bash

echo running $0
echo a will be $1
echo b will be $2

a=$1
b=$2

if [ $a != $b ]
then
  echo 'a is not equal to b!'
else
  echo 'a is equal to b!'
fi
```

**CHALLENGE:** How might you use this script in a for loop to compare a range of numbers to one number? For example, suppose you wanted to check the $2 parameter against the numbers `20 30 40 50 60 70` to see if it matched one of them?


## Persistent sessions with screen and tmux

What if you want to run multiple scripts at once, or you want to put your computer to sleep to check later without stopping analyses that take a long time to complete?

There are two programs, `screen` and `tmux`, that allow you to create separate terminal screens that can continue to run in the background (as long as you don't turn your computer off!). If you're running these programs on the Farm, you can logout and even turn your computer off. :) We'll get back to these details in workshop 10, [Executing large analyses on HPC clusters with slurm]. These are a bit tricky to get used too, so we'll do a demo.

Basic command-line commands for `screen` and `tmux` are listed below. They both have many keyboard shortcuts as well ([screen cheat sheet](https://training.nih-cfde.org/en/latest/General-Tools/Cheat-Sheets/screen_cheatsheet.html)).

Description | screen | tmux
--- | --- | ---
start a screen session | `screen -S <session name>` | `tmux new -s <session name>`
close a session | `screen -d <session name>` | `tmux detach`
list existing sessions | `screen -ls`  | `tmux ls`
go to existing session | `screen -r <session name>` | `tmux attach -t <session name>`
end session | `exit`  | `tmux kill-session -t <session name>`

Like text editors, both programs basically do the same thing - choose the one you're most comfortable using!

There are several reasons to use screen or tmux --

* they keep output from long-running commands, including ones that are running interactively and need input;
* they provide a way to "detach" from a particular shell prompt with a particular configuration, and resume it later;
* they let you switch between terminal windows that are running on two different computers.

One last note - per [Configuring your account on login] from workshop
4, 'screen' and 'tmux' start new shells, but they are not login
shells.  So `.bash_profile` is not run inside of screen/tmux sessions,
but the configuration file `.bashrc` is.  Of course, you can always
execute the commands in `.bash_profile` by running `source ~/.bash_profile`!

## Concluding thoughts

* Break the task down into multiple commands
* Put commands in shell scripts, run in serial
* Automate and scale up using for loops and conditional statements
* Use `echo` and `set -e` to debug!

We'll return to the concept of using scripts to execute analysis workflows in workshops 9 (Snakemake) and 10 (Using SLURM on HPC).


## Appendix: exercise answers

*Answers for questions*

Why do we use `echo` in for loops?

- `echo` prints out the command without running it; this is a good way to double-check the for loop is doing what you expect!

Why did we need " " in the subset `echo` statement for loop?

- In this case, the shell will evaluate the `echo` statement as everything in the double-quotes. Without the quotes, the echo statement will send "head -400 $i" to a file in the `subset` directory; it will not run the subset command properly.

What does the `!=` conditional operator mean?

- This means "not equal to". The "!" means "not". Whereas, "==" means "equal to".

*Answer for subset exercise*
```
for i in *.fq; do echo "head -400 $i > subset/$i"; newname=$(basename $i .fq)subset.fq; echo mv subset/$i subset/$newname; done
```

*Answers for `set -e` exercises*

1. Fails on 1st iteration with `set -e`, fails each iteration of the loop without `set -e`

Output with `set -e`:

```
(base) ~$ bash set_e.sh
./MiSeq/F3D0_S188_L001_R1_001.fq
Specified output directory 'fastqc_reports' does not exist
```

Output without `set -e`:

```
(base) ~$ bash set_e.sh
./MiSeq/F3D0_S188_L001_R1_001.fq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D0_S188_L001_R2_001.fq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D141_S207_L001_R1_001.fq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D141_S207_L001_R2_001.fq
Specified output directory 'fastqc_reports' does not exist
...
```


2. Add `set -x` option to print out the commands computer is running. There's an error in the path to save FastQC output reports.

```
# wrong path
OUTDIR='fastqc_reports'

# correct path
OUTDIR='./data/fastqc_reports'
```

*Answer for ifs.sh in a loop exercise*

This is one approach to compare 20 30 40 50 60 70 to the $2 argument:
```
for i in 20 30 40 50 60 70
do
   bash ifs.sh $i 40
done
```

This output (including the helpful `echo` statements), looks like this:
```
a will be 20
b will be 40
a is not equal to b!
a will be 30
b will be 40
a is not equal to b!
a will be 40
b will be 40
a is equal to b!
a will be 50
b will be 40
a is not equal to b!
a will be 60
b will be 40
a is not equal to b!
a will be 70
b will be 40
a is not equal to b!
```

This is one approach to compare a range of numbers to the $2 argument:
```
for i in {1..5}
do
   bash ifs.sh $i 5
done
```

The output (including the helpful `echo` statements) will look like this:
```
a will be 1
b will be 5
a is not equal to b!
a will be 2
b will be 5
a is not equal to b!
a will be 3
b will be 5
a is not equal to b!
a will be 4
b will be 5
a is not equal to b!
a will be 5
b will be 5
a is equal to b
```
