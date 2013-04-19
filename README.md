# Steckemacs - Steckerhalter's Emacs Configuration

To use this setup please use Emacs 24 or later. Older versions might not work properly.

Most importantly this setup pulls in a lot of packages via ELPA as described in my blog: http://postmomentum.ch/blog/201304/steckemacs

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
                           | `C-2`     | show all symbols like the one cursor is located at
                           | `C-3`     | previous symbol like the one the cursor is on
                           | `C-4`     | next symbol like the one the cursor is on
                           | `i9`      | toggle automatic identation
                           | `M-i`     | select symbol under cursor, pressing again will smartly expand the region
                           | `M-o`     | narrow the selection again
                           | `M-I`     | select stuff inside "pairs" e.g. inside ()
                           | `C->`     | add cursor downwards (try to get next occurrence if sth. is marked)
                           | `C-<`     | add cursor upwards (try to get previous occurrence if sth. is marked)
**Undo/Redo**              | `C-/`     | Undo
                           | `C-'`     | Redo
                           | `C-,`     | Visualize undo/redo tree
**Completion**             | `C-;`     | Trigger auto-completion explicitly (with fuzzy matching)
**Formatting**             | `C-c w`   | cleanup whitespace
                           | `C-c j`   | join two lines
                           | `90`      | toggle `INSERT` (overwrite-mode)
                           | `ac`      | align expressions, e.g. align all `=` in 3 lines with assignments
**Searching / Grepping**   | `34`      | find definitions (functions, headings etc.) in current file
                           | `gt`      | google selection / word under cursor (in web browser)
                           | `gs`      | google (prompt and search in web browser)
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
