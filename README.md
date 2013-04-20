# Steckemacs

An Emacs configuration that integrates around 60 modes (packages). Stock Emacs is not very useful and lacks many convenient commands. Over the years I've discovered many good extensions and added them to this setup. The goal is to keep everything in one file and not as many others to split it over lots of files and directories. Packages are retrieved from the Emacs package repositories on the internet on the first startup.

If you want to know more about how that works, read my blog entry here:  http://postmomentum.ch/blog/201304/steckemacs

**To use this setup please use Emacs 24 or later. Older versions might not work properly.**

## Installation

As the whole setup is just one file the easiest way to use it is like this:

Change to a directory of your choice and clone **steckemacs**:

    cd <my directory>
    git clone https://github.com/steckerhalter/steckemacs.git
    
And symlink `.emacs.el` into your home directory:

    cd ~
    ln -s <path to the directory from above>/.emacs.el
    
That's it. Then you can run emacs and it should pick up the config, install all the packages and make you happy ;)

## Keyboard shortcuts

By using the `key-chord` mode we can avoid having to type C- or M- all the time. It allows for using keys pressed simultaneously and I'm using it quite often.

When I write `fg` as a key combo it means you would have to press `f` and `g` at the same time.

I only describe my custom key combinations currently. To learn the standard Emacs commands, go through the Tutorial `C-h t`, use `C-S-h` or `M-x` to see/filter the available commands/shortcuts.

**the list is not complete yet, work in progress**

        Topic              |   Combo   | Description
---------------------------|-----------|----------------------------------------------------------------------
**General**                | `C-c X`   | kill emacs (including the daemon if it is running)
                           | `C-S-h`   | show current keyboard shortcuts, allows search too
                           | `C-S-l`   | list available packages
**Appearance**             | `C-c m`   | show/hide menu
                           | `C--`     | decrease the font size
                           | `C-=`     | increase the font size
                           | `ln`      | show/hide the line numbers
**Buffers / Files**        | `C-tab`   | buffer switcher (helm-mini)
                           | `F6`      | delete the current buffer
                           | `F8`      | switch to the "last" buffer
                           | `C-c r`   | revert a buffer to the saved state
                           | `C-c n`   | copy the full path of the current file to the clipboard
**Windows / Frames**       | `C-0`     | previous window
                           | `C-9`     | next window
                           | `F2`      | split window vertically
                           | `F3`      | split window horizontally
                           | `F4`      | delete current window (not the buffer)
                           | `F5`      | only keep the current window and delete all others
                           | `F7`      | switch arrangement of two windows horizontally/vertically
                           | `F9`      | split window and show last buffer, another press hides that window again
                           | `C-left`  | shrink window
                           | `C-right` | enlarge window
                           | `C-up`    | shrink window horizontally
                           | `C-down`  | enlarge window horizontally
                           | `M-up`    | move buffer to window above
                           | `M-down`  | move buffer to window below
                           | `M-left`  | move buffer to left window
                           | `M-right` | move buffer to right window 
                           | `,.`      | Delete the current frame
**Movement / Selections**  | `M-p`     | move to next expression
                           | `M-n`     | move to previous expression
                           | `C-3`     | go to last automatically saved position
                           | `C-4`     | go to next automatically saved  position
                           | `M-2`     | show all symbols like the one cursor is located at
                           | `M-3`     | previous symbol like the one the cursor is on
                           | `M-4`     | next symbol like the one the cursor is on
                           | `i9`      | toggle automatic identation
                           | `M-i`     | select symbol under cursor, pressing again will smartly expand the region
                           | `M-o`     | narrow the selection again
                           | `M-I`     | select stuff inside "pairs" e.g. inside ()
                           | `C->`     | add cursor downwards (try to get next occurrence if sth. is marked)
                           | `C-<`     | add cursor upwards (try to get previous occurrence if sth. is marked)
**Undo/Redo**              | `C-/`     | Undo
                           | `C-'`     | Redo
                           | `C-,`     | Visualize undo/redo tree
**Completion**             | `C-7`     | Trigger auto-completion explicitly (with fuzzy matching)
**Formatting**             | `C-c w`   | cleanup whitespace
                           | `C-c j`   | join two lines
                           | `90`      | toggle `INSERT` (overwrite-mode)
                           | `ac`      | align expressions, e.g. align all `=` in 3 lines with assignments
**Search / Replace**       | `34`      | find definitions (functions, headings etc.) in current file
                           | `gt`      | google selection / word under cursor (in web browser)
                           | `gs`      | google (prompt and search in web browser)
                           | `vr`      | search/replace with visual regexp
                           | `C-;`     | edit occurences of current word on the fly, press again to exit
**Project related**        | `fr`      | find files in current project
                           | `rg`      | grep through current project
                           | `ok`      | show occurrences of a string in current project
                           | `aw`      | ack through current project
                           | `C-c g`   | magit status - manual: http://magit.github.io/magit/
**Code/Spell checking**    | `cf`      | toggle code checking (flycheck)
                           | `C-c f`   | toggle spell checking (flyspell)
                           | `C-c d`   | change dictionary
**Shell**                  | `C-c s`   | open emacs shell
**PHP**                    | `vd`      | insert var_dump around selection
                           | `vb`      | insert var_dump + die around selection

## Contributions

I'm using **outline-mode** to keep `emacs.el` organized. There's a key map defined with the prefix `C-t`. When you open up `emacs.el` it will fold everything and only show the top level headings. Top level headings have one star:

```lisp
;; * Top Level Heading
```

And so on:

```lisp
;; ** Second Level Heading
```

You can use `C-t C-t` to show and hide parts of the document. Additionally there are these commands defined:

 combo  | description
--------|-------------------------------------------------
`C-t q` | Hide everything but the top-level headings
`C-t t` | Hide everything but headings (all body lines)
`C-t o` | Hide other branches
`C-t c` | Hide this entry's body
`C-t l` | Hide body lines in this entry and sub-entries
`C-t d` | Hide everything in this entry and sub-entries
`C-t a` | Show (expand) everything
`C-t e` | Show this heading's body
`C-t i` | Show this heading's immediate child sub-headings
`C-t k` | Show all sub-headings under this heading
`C-t s` | Show (expand) everything in this heading & below
`C-t u` | Up
`C-t n` | Next
`C-t p` | Previous
`C-t f` | Forward - same level
`C-t b` | Backward - same level

So... that's what should make it easier to keep an overview. If you want to help me out improving the config, fork the repo, create a new branch and open up a Pull Request so we can discuss the merge.

Of course you can also just [report issues](https://github.com/steckerhalter/steckemacs/issues) :)
