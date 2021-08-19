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
- Learning how to use multiple screens for long-running analyses

## What is a script?

A script is like a recipe of commands for the computer to execute. We're teaching you how to make shell scripts today, but scripts can be in any programming language (R, python, etc.).

Why and when would we want to use scripts vs. typing commands directly at the terminal?

   - Automate: don't have to remember all the commands and type then one at a time
   - Scale up: can use same script for multiple samples, multiple processes
   - Reproduce & share: easier to reproduce or share analyses because it's all written down
   - Version control: stay tuned for workshop 8!

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

In a script, we can do the same thing - (we covered how to create and edit files with `nano` from Workshop 2!):

Create a script file with nano:
```
nano first_script.sh
```

Add the following 3 lines to the script:
```
#!/bin/bash
echo Hello this is a script!
echo I'm on the next line!
```

Execute the script
```
bash first_script.sh
```

- Note that commands are executed in the order that they appear in the script
- The file extension for shell scripts is '.sh'
- `#!/bin/bash` header (this is known as a "[shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))") - it tells the shell how to interpret the script file



## `for` Loops

Scripts can do far more than print echo statements! We're gonna take a detour to learn about for loops and then run loops in scripts.

In workshop 6, we showed you a way to create a list of the md5sum numbers for the autosome files:
```
md5sum mini-chr[1-9]*.fna.gz  >> autosomes.md5
```

This approach uses wildcards to tell the shell to grab the md5sum for all files starting with `mini-chr`, with a number from 1 to 9, and ending with '.fna.gz'. Another way to do this, and include the Z chromosome file as well, is to write a for loop that runs the `md5sum` command for each '.fna.gz' file in the directory:

```
for i in *.fna.gz; do echo md5sum $i; done

# or enter this way, you type enter at the end of each line in the terminal
for i in *.fna.gz
do
   echo md5sum $i
done
```

for loop structure:

- we set the counter for the thing we want to iterate ("loop") through with the `for i in *.fna.gz`. In this case, we are running the same command for each file in our current directory that ends in '.fna.gz'. The `i` represents the ith file in our loop and we refer to it with the `$` notation (more on variables later!) - also, "i" is an arbitrary name; it could be "potato" :)
- starts with `do` and ends with `done`
- loop components are separated by `;` or indentation

```
# now, let's append those md5sum numbers to a text file
for i in *.fna.gz; do md5sum $i >> my_md5sum_list.txt;done

# check out the list (exit by pressing q)
less my_md5sum_list.txt
```

**Question:** why did we put `echo` here?

Now, let's practice for loops by renaming MiSeq sequence file names. Go to this directory: `2021-remote-computing-binder/data/MiSeq`.

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

*Side note:* you may see backticks used instead of `$(...)`. It does the same thing but the syntax is trickier to get right, so we teach `$(...)` instead of `` `...` ``.

Now we have the old name (`$i`) and the new name (`$newname`) and we're ready to write the rename command --

```
for i in *.fastq
do
   newname=$(basename $i .fastq).fq
   echo mv $i $newname
done
```

**Challenge:** Run the above loop in a shell script called `rename_file.sh`.


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
head F3D0_S188_L001_R1.fq
```

you'll see that it's full of FASTQ sequencing records.  Often I want to run a bioinformatices pipeline on some small set of records first, before running it on the full set, just to make sure all the syntax for all the commands works ("data forensics"). So I'd like to subset all of these files *without* modifying the originals.

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

If that command looks right, run it for realz:

```
for i in *.fq
do
   head -400 $i > subset/$i
done
```

and voila, you have your subsets!

(This is incredibly useful. You have no idea :)

**CHALLENGE:** Can you rename all of your files in subset/ to have 'subset.fq' at the end?

### Variables

Let's backtrack a bit - what are variables?

You can use either $varname or ${varname}.  The latter is useful when you want to construct a new filename, e.g.

```
MY${varname}SUBSET
```

would expand ${varname} and then put MY .. SUBSET on either end, while

```
MY$varnameSUBSET
```

would try to put MY in front of $varnameSUBSET which won't work.

(Unknown/uncreated variables are empty.)

NOTE: `${varname}` is quite different from `$(expression)`! The former is replaced by the value assigned to `varname`; the latter is replaced by the result of running `expression`. So, both *replace* but they do different things. Think of `$` here as meaning, "replace me with something".

## Troubleshooting scripts

As we've seen above, the `echo` statements help to make sure the commands look correct before running for real.

There are several `set` options that are useful to determine what happens to your script on failure. We recommend:

- Always put `set -e` at the top.
- Sometimes put `set -x` at the top.

### Practicing `set -e` in bash scripts

1. We're going to use the MiSeq .fq files again
2. Create a conda environment that has `fastqc` installed in it
3. Write a for loop that runs fastqc on each .fq files with a shell script

```
# create output report directory
cd ~/2021-remote-computing-binder/data
mkdir ./MiSeq/fastqc_reports

# create bash script using nano text editor
# save and exit with ctrl-o, enter, ctrl-x on keyboard
nano set_e.sh
```

Create a bash script with the following commands, this version includes `set -e`:

```
#!/bin/bash

set -e

OUTDIR='fastqc_reports'

for i in ./MiSeq/*.fastq
do
   echo $i
   fastqc $i -o $OUTDIR
done
```

**Reminder:** Another way to type bash `for` loops is with the `;`, for example this syntax does the same thing as above:

```
for i in ./MiSeq/*.fastq; do echo $i; fastqc $i -o $OUTDIR; done
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

- starts with `do` and ends with `fi`
- loop components are separated by `;` or indentation

Here, we're wrapping if statements in a for loop:  

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

**Question:** What does the `!=` conditional operator mean?

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

**Challenge:** How might you use this script in a for loop to compare a range of numbers to one number?




## Multiple screens

What if you want to run multiple scripts at once, or you want to put your computer to sleep to check later without stopping analyses that take a long time to complete?

There are 2 programs, `screen` and `tmux`, that allow you to create separate terminal screens that can continue to run in the background (as long as you don't turn your computer off!). These are a bit tricky to get used to, so we'll do a demo.

Basic commands for `screen` and `tmux` below. They both have keyboard shortcuts as well ([screen cheat sheet](https://training.nih-cfde.org/en/latest/General-Tools/Cheat-Sheets/screen_cheatsheet.html)).

Description | screen | tmux
--- | --- | ---
start a screen session | `screen -S <session name>` | `tmux new -s <session name>`
close a session | `screen -d <session name>` | `tmux detach`
list existing sessions | `screen ls`  | `tmux ls`
go to existing session | `screen -r <session name>` | `tmux attach -t <session name>`
end session | `exit`  | `tmux kill-session -t <session name>`

Like text editors, both programs basically do the same thing - choose the one you're most comfortable using!


## Concluding thoughts

* Break the task down into multiple commands
* Put commands in shell scripts, run in serial
* Automate and scale up using for loops and conditional statements
* Use `echo` and `set -e` to debug!

We'll return to the concept of using scripts to execute analysis workflows in workshops 9 (Snakemake) and 10 (Using SLURM on HPC).






## Appendix: exercise answers

*Answer for subset exercise*
```
for i in *.fastq; do echo "head -400 $i > subset/$i"; newname=$(basename $i .fastq).subset.fastq; echo mv subset/$i subset/$newname; done
```

*Answers for `set -e` exercises*

1. Fails on 1st iteration with `set -e`, fails each iteration of the loop without `set -e`

Output with `set -e`:

```
(base) ~$ bash set_e.sh
./MiSeq/F3D0_S188_L001_R1_001.fastq
Specified output directory 'fastqc_reports' does not exist
```

Output without `set -e`:

```
(base) ~$ bash set_e.sh
./MiSeq/F3D0_S188_L001_R1_001.fastq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D0_S188_L001_R2_001.fastq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D141_S207_L001_R1_001.fastq
Specified output directory 'fastqc_reports' does not exist
./MiSeq/F3D141_S207_L001_R2_001.fastq
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

This is one approach:
```
for i in {18..21}
do
   bash ifs.sh $i 20
done
```

The output will look like this:
```
a is not equal to b!
a is not equal to b!
a is equal to b!
a is not equal to b!
```
