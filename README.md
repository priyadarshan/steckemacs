# Steckemacs - Steckerhalter's Emacs Configuration

To use this setup it's best you have Emacs 24 or later. Older versions might not work properly.

Most importantly this setup pulls in a lot of packages via ELPA as described in my blog: http://postmomentum.ch/blog/201304/steckemacs.creole

I'm going to describe what my config includes and what the custom keyboard shortcuts are.
## Keyboard shortcuts

By using this the `key-chord` mode we can avoid having to type C- or M- all the time. It allows for using keys pressed simultaneously and I'm using it quite often.

When I write `fg` as a key combo it means you would have to press `f` and `g` at the same time.

I only describe my custom key combinations.

**the list is not complete yet, work in progress **

### General 

`C-c X` kill emacs (including the daemon if it is running)
`C-S-h` show current keyboard shortcuts, allows search too
`C-S-l` list available packages

### Appearance 

`C-c m` show/hide menu
`C--` decrease the font size
`C-=` increase the font size

### Buffers / Files

`C-tab` buffer switcher (helm-mini)

`F6` delete the current buffer
`F8` switch to the "last" buffer

`C-c r` revert a buffer to the saved state
`C-c n` copy the full path of the current file to the clipboard

### Windows / Frames

`C-0` previous window
`C-9` next window

`F2` split window vertically
`F3` split window horizontally
`F4` delete current window (not the buffer)
`F5` only keep the current window and delete all others
`F7` switch arrangement of two windows horizontally/vertically
`F9` split window and show last buffer, another press hides that window again

`C-left` shrink window
`C-right` enlarge window
`C-up` shrink window horizontally
`C-down` enlarge window horizontally

`M-up` move buffer to window above
`M-down` move buffer to window below
`M-left` move buffer to left window
`M-right` move buffer to right window 

`C-4` Delete the current frame

### Buffer movement / Selections

`M-p` move to next expression
`M-n` move to previous expression

`C-2` show all symbols like the one cursor is located at
`C-3` previous symbol like the one the cursor is on
`C-5` next symbol like the one the cursor is on

`M-i` select symbol under cursor, pressing again will smartly expand the region
`M-o` narrow the selection again
`M-I` select stuff inside "pairs" e.g. inside ()

`C->` add cursor downwards (try to get next occurrence if sth. is marked)
`C-<` add cursor upwards (try to get previous occurrence if sth. is marked)

### Formatting

`C-c w` cleanup whitespace
`C-c j` join two lines
`ac` align expressions, e.g. align all `=`

### Project related

`fr` find files in current project
`rg` grep through current project
`ok` show occurrences of a string in current project
`aw` ack through current project
`C-c g` magit status - manual: http://magit.github.io/magit/

### Spell checking

`C-c f` activate spell checking
`C-c d` change dictionary

### Shell

`C-c s` open emacs shell

### PHP

`vd` insert var_dump around selection
`vb` insert var_dump + die around selection
