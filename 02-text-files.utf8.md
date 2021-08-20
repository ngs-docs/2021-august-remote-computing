# Creating and modifying text files on remote computers

This two hour workshop will introduce attendees to the concepts and skills needed to create, modify, and search text files on remote computers. We will discuss files and content types, and cover the most common ways to work with remote text files.

As with
[the first workshop introducing the UNIX command line](introduction-to-the-unix-command-line.html),
we'll be using an interactive Web site running on a
[binder](https://mybinder.org/). To start your binder, please click on
the "launch" button below; it will take up to a minute to start.

[![Binder](https://binder.pangeo.io/badge_logo.svg)](https://binder.pangeo.io/v2/gh/ngs-docs/2021-remote-computing-binder/stable?urlpath=rstudio)

Once it's launched, go to the "Terminal" tab.

## Text files vs other files

Text files are a fairly narrow but very important subset of the kinds
of files that we will work with in data science. Text files are,
loosely defined, files that are human-readable without any special
machine interpretation needed - such as text-only e-mails, CSV files,
configuration files, and Python and R scripts.

The list above is interesting, because it makes the point that just
because a human can "read" the files doesn't mean that they are
_intended_ for humans, necessarily. For example, CSV files can be more
or less strictly defined in terms of formatting, and Python and R
scripts still need to be valid Python or R code. DNA sequence data
files like we saw yesterday are another case in point - it's pretty
rare (and a bad idea) to edit them manually, but you _could_ if you
really wanted to.

The operational distinction really comes down to this: text files can
be created, edited, changed, and otherwise manipulated with
text-format based tools, like text editors, grep (which we saw
yesterday), and other programs.  Text files are a common and standard
format that _many_ tools can interact with.

In comparison, binary files are files that need special programs to
interact with them. Some of them are more standard than others - for
example, Word files can be read or written by many programs. Images
(JPG and PNG and...) can be manipulated by many programs as well. Zip
files are another semi-standard format that can be manipulated by several
different programs. The main thing is that you can't just look at them
with standard text-focused tools - and typically this is because binary
files are meant to be used for different kinds of data than text.

As a side note, one of the most important aspects of text files is that
there are some really powerful tools for tracking changes to them,
and collaboratively editing them - we'll cover that in workshop 8,
version control!

<!-- @CTB link in workshop materials here -->

### OK, OK, what does this all mean in practice?

Let's look at a simple text file - `2cities/README.md`:

```
cat 2cities/README.md
```

As you may remember, 'cat' (short for 'catenate') displays the content
of the file.

This is a file in a format called Markdown, that is a lightly
decorated text file with a title and so on. While it can be nicely
formatted by an interpreting program (see [the way github renders this
file!](https://github.com/ngs-docs/2021-remote-computing-binder/blob/latest/2cities/README.md),
it can also just be viewed and read with cat.

This is different from the other file in `2cities/`; take a look at
what's there by running,
```
ls 2cities/
```
and you should see

> > ~~~
> > README.md       book.txt.gz
> > ~~~

In this directory, there is one text file and one binary file.

If you want to see if it's a file type that UNIX recognizes you can run
the `file` command, e.g.
```
file 2cities/README.md
```
will report that it's ASCII text, while
```
file 2cities/book.txt.gz
```
will report that it's "gzip compressed data", which is a compressed data
type. What do we do with that?

### Working with gzipped files

gzip is a common type of file, and all that it means is that it's been
compressed (made smaller) with the `gzip` program.

Look at it's file size first --

```
ls -lh 2cities/book.txt.gz
```
and you'll see that it's about 300k.

You can uncompress a gzip file with `gunzip`; in this case,
```
gunzip 2cities/book.txt.gz
```
will produce `2cities/book.txt`

CHALLENGE: what two commands will tell you the file type and size of `2cities/book.txt`?

---

Yep, it's almost 3 times bigger when it's uncompressed!

And it's file type is "UTF-8 Unicode (with BOM) text, with CRLF line
terminators" which is a fancy way of saying "text, supporting extended
characters (unicode), and with both a carriage return (CR) and a line
feed (LF) at the end of each line." The important thing is that pretty
much any text editor should be able to edit this kind of file.

Let's take a quick look at the beginning of the file with `head`:

```
head 2cities/book.txt
```

yep, looks like text!

### Digression: file extensions are often meaningful (but don't have to be)

Couldn't we have guessed at what these files were based on their
names? Yes, the .md extension usually means it's a text file with
Markdown formatting, and the .gz extension typically means it's a
compressed file, and the .txt extension typically means it's a text
file. So you can read `book.txt.gz` to mean that it's a text file that's
been compressed.

But this isn't guaranteed - it's a convention, rather than a requirement.
Many programs will actively "sniff" the file type by looking at the content
(which is what `file` does), and you should never blindly trust the file type
indicated by the extension.

### Let's edit this file!

Let's start with the `nano` editor. `nano` and its sibling `pico` are
simple text editors that let you get started, but are ultimately limited
in their functionality.

Note: If you've ever used the 'pine' e-mailer, you've used these
editors!

nano (and all of the editors we'll use below in the terminal) are
"text graphics" editors that give you a visual interface that is not
the command line (which is good, trust us) but that also exist only
within the terminal program and **do not support mouse movements**.
This is important - you can't use the mouse to move the cursor or make
changes (although you can select things).

### Running the editor and exiting/saving

To get started, let's open the file:

```
nano 2cities/book.txt
```

this will put you in an editor window.

First things first: you can immediately exit by typing CTRL-X (that's
holding down the CTRL key, and then typing X, lowercase or uppercase -
no shift key is needed. If you haven't changed anything, it will
simply exit.

Now edit the file with nano again (use the up arrow on the command line
to find and rerun the previous command!) --

```
nano 2cities/book.txt
```

Now change something - just type. You should see the new characters added.

Use CTRL-X again, and it will ask "Save modified buffer?" If you say "No",
it will not save; if you type 'y', it will ask you for the name of the file.
Just hit ENTER to overwrite the file you edited here.

Now, you should be back at the command line. Run:
```
head 2cities/book.txt
```
and you should see your changes!

Note, there's no 'undo' possible once you've saved.

### Navigating in nano

Let's go back into nano and learn how to move around.

Run:
```
nano 2cities/book.txt
```

and use the arrow keys to move up and down and left and right.

For big files, this can be tedious! If you look down on the bottom,
you can see a bunch of help text telling you what control+keys to use
- use CTRL-V to page down, and CTRL-Y to page back up.

### Long lines - note!

One of my least favorite features of nano is the way it handles long lines (lines that extend off the right of the screen).

Try making one - go to the end of a line, and add a bunch of text.

What it does is shift the whole line left while you're typing, and then when you scroll back over to the left, it puts a $ at the last column on the screen to tell you that it's a long line. Very confusing. But there you are.

### Slightly more advanced features

^K will delete the current line, and ^U will put the last deleted line into
the current location. (It's a slightly janky version of cut and paste that
many editors use in UNIX, for some reason.)

### Getting help!

In nano, CTRL-G will put you in "help" mode, and you can now navigate
around (CTRL-V and CTRL-Y to read), and then CTRL-X to exit.

Note again that ^ in front of a key means control, so e.g. ^K means
"type CTRL+K" (which will delete the current line).

Note also that M- means "hit Escape _and then_ the key after", so
pressing the "escape" key, letting go of it, and then hitting "g" will
go to a line and column number. Try it out - type Escape, then g, then
type 500,10 and hit enter.

Why do CTRL and Escape work differently? You hold down CTRL and another
key, but you press Escape and then type something. Why!?

The answer is that CTRL and ALT are "modifier keys", like SHIFT - they
modify the character sent when you hold them down. Escape is its own
character, however, so you're first saying "here's an escape character!"
and then "here's another character!" (We don't make the rules, we just
explain them - sorry!)

### Challenges:

Use the help screen to answer (and experiment with) the following challenges -
remember, CTRL-G gets you into help, CTRL-V pages down, and CTRL-X exits help.

**CHALLENGE:** How do you delete the character at the current cursor position?

**CHALLENGE 2:** How do you move to the end of the file?

You can do a lot in these but as soon as you're dealing with really large
files, or many files, we suggest other editors. That having been said,
we teach nano because it's a good "basic" editor that is usually available
and can almost always be used if you don't have access to your favorite
editor.

## Big Powerful Editors

There are two fairly dominant editors that work at the command line.
They've been around for decades, and they have many advocates who
care for them with a near-religious fervor.  We will demo them for you,
and point you at learning resources for them, and then leave it up to
you to pick one. (We'll probably use nano for most of the work we do in these
workshops.)

### Big Powerful Editor 1: vi

'vi' stands for "visual editor" and it's available on most systems.
It's incredibly powerful, and incredibly robust, and is correspondingly
cryptic and hard to use. It involves a lot of remembering specific character
commands, in particular.

(We're actually using 'vim', but never mind that - it's compatible with vi.
[Read more here](https://www.shell-tips.com/linux/vi-vs-vim/).)

To run vi, type:
```
vi 2cities/book.txt
```
(You should see all your changes from before, right?)

vi starts in "normal mode", which allows you to navigate around the file.
In normal mode, what you type does not change the file - instead, it lets
you issue commands to vi.

The first and most important (?) command - to exit, type:
```
:q
```
and if there are no changes, it will simply exit.

Run vi again, and let's edit --
```
vi 2cities/book.txt
```
and then type 'i' to go to "insert" mode, and type something.

Then hit the escape key to go back to "normal" mode.

Now try to exit with `:q`. It won't work! You have to either save, or quit.

To force-quit without saving, run `:q!`.

Now let's learn to save! Go back and edit (`i`, then type something,
then escape).

To save, type `:wq`. (You can also (mystifyingly) type `ZZ` to do the same
thing. shrug.)

The main thing that vi does is give you a "normal" mode (where you can navigate
around - use CTRL-F and CTRL-V to page down and up, for example) and an
edit mode (use 'i' for insert or 'a' for append) where what you type goes
directly into the file. You use Escape to get out of edit mode.

In normal mode, 'x' will delete the character you're on, and 'dd' will delete
the line you're on (and put it in the cut buffer), and `P` will pull the
line out of the cut buffer into the file at the current location.

And that's what you really need to know :).

A few tips for normal mode -

* to get help, type `:help`
* to go to a specific line, type the line number followed by G. `500G`

As a side note, we've just taught you the single most asked question on the
Internet about UNIX: [how to exit vi](https://stackoverflow.blog/2017/05/23/stack-overflow-helping-one-million-developers-exit-vim/)!!

### Big Powerful Editor 2: emacs

The _other_ editor to know about is emacs. (This is what Titus uses the
most.)

To run emacs,
```
emacs 2cities/book.txt
```

This is automatically in edit mode (there's no normal mode) so it behaves
kind of like nano.

To exit emacs, type CTRL-X and then CTRL-C.

If you've modified things (by typing something), it will ask you if you
want to save.

To page down, type CTRL-V.

To page up, type Escape V.

To go to the beginning of a line, type CTRL-A. End of line, CTRL-E.

(I'm telling you these specific keys because they _also_ work at the
command line.)

There's a pretty nice interactive tutorial for via that you can access
with CTRL-H t (CTRL-H, followed by a 't').

Emacs shines when editing _multiple_ files, but it can do a lot more, too.
Some people spend their entire computing lives in emacs... see, for example,
[org-mode](https://orgmode.org/).

### An opinion

You only need to learn nano, and be basically familiar with vi and emacs.
Read on for why!

## Remote vs local, and why editors?

So we've just shown you a bunch of editors that work on the command
line/in the Terminal window, but don't support mouse and copy paste
and multiple windows and other nice things. Why can't you just always
use a **nice** editor that supports mouse commands etc etc??

Well.

There are a few reasons!

First is that it's always nice to have backup options. Even if you
resolutely stick with something that runs on your laptop, every now
and then you may find yourself in a situation where you're using someone
else's computer to debug or demonstrate something.

Second is that these are platform independent options, in some sense -
if you are connected to a UNIX system, you can pretty much always use
nano or vi or emacs, no matter how you are connecting or from what
type of computer.

Third, sometimes it's just faster to fix something locally in the shell.
And it's nice to have the option.

Fourth, and related, is that remote file editing from your laptop or
desktop requires that certain things be available on the remote
computer - ssh and authentication (see next two workshops, Workshops 3
and 4!). Unfortunately, these *aren't* always available - for example,
we can't actually *use* the nice editors on this binder, for technical
reasons; we'd have to use the RStudio editor (which is also nice, but
is also not always available).

Last and probably least, if you're in the Matrix and you're Trinity and
you're trying to hack through the machine firewall after breaking into
a heavily guarded compound, you're unlikely to want to take the time to
install an editor on a laptop you bring with you. Better to be able to
use what's already on the system, eh? ([Yes, this is a Matrix reference.](https://www.reddit.com/r/todayilearned/comments/28nanl/til_that_the_scene_in_matrix_reloaded_when/))

## Editors that run locally on your laptop/desktop

That all having been said, there is no reason you can't use nice friendly
editors most of the time! I asked [on twitter](https://twitter.com/ctitusbrown/status/1421102631557025796) about what editors people liked, and
several popped up -

* [Visual Studio Code](https://code.visualstudio.com/) was a hands-down winner. It works on Windows, Mac OS X, and Linux, and is free.
* [BBEdit](https://www.barebones.com/products/bbedit/) was beloved by many. Runs on Mac OS X. Free, with pay option.
* [NotePad++](https://notepad-plus-plus.org/downloads/) is a nice free Windows editor that I've used in the distant past.
* Some people really liked [Atom](https://atom.io/) too, which is free and runs on Windows, Mac OS X, and Linux.

Any or all of these will work for editing remote files, support
a wide variety of languages nicely, and otherwise are excellent choices.
Pick one! Thrive!

(We can't use these yet because we need to configure remote access in a
particular way - that will come next week :).)

## Thinking about editors as a means to an end

At the end of the day, whatever editor you choose needs to be one that
lets you achieve your end goal - which is to quickly and reliably edit
text files.

I personally switch between vi and emacs on a regular basis. Emacs is
where I do long-form writing and editing (because I've got mine configured
nicely for that), while vi is what I use for
quick edits (because it's fast to start, and I don't need to configure it
at all for it to be useful - so I can use it more places).

Again, most people will probably end up using something like VScode,
which got many rave reviews online and supports robust syntax
highlighting and many different languages, as well as remote editing.

But it **really doesn't matter**.  I think of an editor like a kitchen -
you may customize your kitchen layout and tools differently from someone
else, but at the end of the day, your goal is to cook something, and
you (in this analogy) only really need to worry about another editor if you're
using an unfamiliar system, just like if you're cooking in a strange kitchen.
And then it will be maddening and infuriating but that's ok :).

## Other ways to create, edit, filter, and modify files

So editing is pretty cool, but if you're in a hurry, or want to make a
small change without switching windows, or need to work with some
pretty big files, there are other approaches you can use. Read on!

### Redirection, appending, and piping.

By default, many UNIX commands like `cat` send output to something called
standard out, or "stdout". This is a catch-all phrase for "the basic
place we send regular output." (There's also standard error, or "stderr",
which is where errors are printed; and standard input, or "stdin", which
is where input comes from.)

Much of the power of the UNIX command line comes from working with
stdout output, and if you work with UNIX a lot, you'll see characters
like `>` (redirect), `>>` (append) and `|` (pipe) thrown around. These
are redirection commands that say, respectively, "send stdout to a new
file", "append stdout to an existing file", and "send stdout from one
program to another program's stdin."

Let's start by going to our home directory:
```
cd ~/
```

### The simplest possible "editor" - echo

You can create a file with `echo` and redirection, like so:

```
echo this is some content > file.txt
```

which will put the words `this is some content` in the file named
`file.txt`.

CHALLENGE: how do you view the contents of `file.txt`?

---

If you then run
```
echo this is other content > file.txt
```
it will overwrite file.txt.

(Note: if you don't like this overwriting behavior, you can run `set
-o noclobber` so that bash will complain.)

Instead of overwriting, you can  _append_ by specifying `>>`, like so --

```
echo more content >> file.txt
```

This doesn't just work with echo - you can do this with many UNIX commands,
e.g.
```
cat file.txt file.txt > newfile.txt
```

will create `newfile.txt` with two copies of file.txt in it, and you can
add a third with
```
cat file.txt >> newfile.txt
```

You can also e.g. search for words with grep and then save the results --
for example, this will search for the word "worst" in the Tale of Two
Cities, and save the results to `worst-lines.txt`.

```
grep worst 2cities/book.txt > worst-lines.txt
```

### Piping and filtering

What if you wanted to count the number of lines in which the word
`worst` shows up in the Tale of Two Cities?

You _could_ use the "wc" (wordcount) program -

```
grep worst 2cities/book.txt > worst-lines.txt
wc -l worst-lines.txt
```
(the answer is 18 :)

but this creates an unnecessary intermediate file, `worst-lines.txt`.
You can avoid creating this file by using **piping**:
```
grep worst 2cities/book.txt | wc -l
```
which says "send the output of grep to the input of wordcount".

You'll see this a lot in UNIX, and below we'll explore this on a new
file type - CSV files!

## Working with CSV files

CSV files - Comma Separated Value files - are another very common type
of text files, especially in data science. Let's explore working with them!

We've put a list of South Park TV show quotes under `SouthParkData/All-seasons.csv.gz`. Let's change into that directory to work with the CSV file.
```
cd ~/SouthParkData
```

Let's now uncompress the file -- remember, you can use Tab completion here by
typing `gunzip A<TAB>` -- 
```
gunzip All-seasons.csv.gz
```
and look at the first few rows of the result `All-seasons.csv` file --
```
head All-seasons.csv
```

It looks like there are four columns, and the quotes are multi-line quotes.
(I've never seen this before, but it seems to work!)

Suppose you want to see if the word 'computer' is in there anywhere. You
can use `grep` to do that --

```
grep computer All-seasons.csv
```
-- and you get a lot of results!

First, let's count them:
```
grep computer All-seasons.csv | wc -l
```
-- this will count the number of _lines_ the word 'computer' shows up on.
(It's 78.)

If you browse through the file, you might release that 'Computer' is a
character on the show, but it turns out that grep is really literal
and doesn't match 'Computer' when you search for 'computer' - you need
to provide 'grep' with '-i' to do case-insensitive search! Let's
try that --

```
grep -i computer All-seasons.csv | wc -l
```
-- and now it's 101.

How would we get at *just* the lines spoken by the computer? Well, if you look
at the header of the file,
```
head All-seasons.csv
```
you'll see that the third column is the one with the character in it. You
can use the `cut` command to pick out just the third column by specifying
comma as a separator with `-d` and `-f3` as the field number --
```
cut -d, -f3 All-seasons.csv | grep Computer
```
which will give you a manageable number of results - about 16.

You might note that there is an inconsistency in the way the character
is named - Computer vs Computer Voice (maybe these are different characters?
I don't watch enough South Park to know...) Let's do some counting --

```
cut -d, -f3 All-seasons.csv | grep Computer | sort | uniq -c
```

This is hard to pull apart but let's do so -

* first, cut out column 3
* then, search for Computer
* then, sort them alphabetically
* then, count the number of times each character shows up

There are lots of ways this can come in handy for digging into csv files
and figuring out where values are wonky.

### Use csvtk when working with CSV files, maybe.

This section was mostly to show you other ways of interacting with generic
text files with CSV as an example, but if you work a lot with CSV or TSV
files, I wanted to suggest looking into [the csvtk program](https://bioinf.shenwei.me/csvtk/usage/) -- we'll show you how to install it with conda in workshop 5, but we pre-installed it for you on this binder.

With `csvtk`, you can run commands that make use of column headers - for
example,
```
csvtk cut -f Character All-seasons.csv | grep Computer | sort | uniq -c
```
gives you the same output, but it uses the header name.

csvtk is a really nice piece of software that I am starting to use heavily.
Highly recommended when doing a lot of CSV/TSV work - definitely [check out the manual](https://bioinf.shenwei.me/csvtk/usage/).

## A quick primer on compression.

Make sure you're in the `SouthParkData` directory and have uncompressed
`All-seasons.csv` --

```
cd ~/SouthParkData
gunzip All-seasons.csv
```
(it's ok if you've already run these and they fail, just want to make sure!)

Text files can be large, so often they are distributed in compressed version.

### Gzip and `.gz` files.

gzip is a common compression format that works with .gz files. It works
with one file at a time, so `gzip` compresses that one file and makes a new
.gz file.

To compress `All-seasons.csv` with gzip, you can use:

```
gzip All-seasons.csv
```

If you try to run it again, you'll get an error message; try it!
```
gzip All-seasons.csv
```
...because the file no longer exists - it's been compressed into a new file, `All-seasons.csv.gz`!

If you run `gunzip`, it will uncompress the file and delete the old
one.  Sometimes this isn't what you want -- you can use output
redirection to uncompress it and make a new copy:
```
gunzip -c All-seasons.csv.gz > All-seasons.csv
```

but, then, if you try to run `gzip All-seasons.csv` it will tell you that
the .gz file already exists. Say 'n' or use CTRL-C to exit.

### zip and compressing _multiple_ files.

The big downside to `gzip` is that it works one file at a time. What if
you wanted to bundle up multiple files AND compress them?

Our recommended approach is to use `zip` to build a zip bundle or archive.
This will both compress files, and store multiple files (even a directory
hierarchy!)

First, create the archive -
```
cd ~/
zip -r south-park.zip SouthParkData/
```
(the `-r` is needed on some versions of zip to package up directories.)

Then make a copy in a new place (just to demonstrate that it all works :) -
```
mkdir new-place/
cd new-place/
unzip ../south-park.zip
ls -R
```

and you will see a complete new copy under
`~/new-place/south-park/SouthParkData`. This is handy for making quick
backup copies of things and downloading them (see Workshop 4!) as well
as sending people collections of files. We'll show you a different
way, using version control, in Workshop 8.

Note, you can use `unzip -v` to see what's _in_ a zip archive,
```
unzip -v ../south-park.zip
```
and selectively unzip specific files by specifying them on the command line like so:
```
unzip ../south-park.zip SouthParkData/README.md
```

## Concluding thoughts

What we've shown you is a whole plethora of hopefully
not-too-confusing options for editing and working with text files.

In terms of editing, the only thing you really need to do is (1)
bookmark this page when you need to figure out how to exit vi, and (2)
remember to use nano!

The redirection and compression stuff is really useful, but again,
you just need to know it exists and that there's this tutorial on it.

Taking a step back, these first two workshops have been about
introductory skills that you will use every day when you use a UNIX
computer.

These skills may seem confusing, but they will become second nature if
you use them regularly. And we'll be doing that through the next 9
workshops!
