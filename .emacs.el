;;; .emacs.el --- steckemacs
;; * header

;; Copyright 2013, Steckerhalter

;; Author: steckerhalter
;; Keywords: emacs configuration init
;; URL: https://github.com/steckerhalter/steckemacs

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Emacs configuration that tries to fetch everything necessary from
;; ELPA, Marmelade and MELPA on startup. Instead of splitting
;; everything up I try to keep everything in one file. My theme called
;; `grandshell` is loaded from MELPA too.

;;; Requirements:

;; Emacs 24, should also work with Emacs 23 but I'm not testing that very often

;;; Code:

(setq emacs<24 (if (< emacs-major-version 24) t nil))

;; * load-path

;; http://emacswiki.org/emacs/LoadPath
(let ((default-directory "~/.emacs.d/elisp/"))
  (unless (file-exists-p default-directory)
    (make-directory default-directory))
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path))) ;; Shadow
           (append
            (copy-sequence (normal-top-level-add-to-load-path '(".")))
            (normal-top-level-add-subdirs-to-load-path)))
         load-path)))

;; * el-get

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(setq el-get-install-skip-emacswiki-recipes t)

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(setq el-get-sources
      '(
        (:name php-documentor
               :type http
               :url "https://raw.github.com/wenbinye/dot-emacs/master/site-lisp/contrib/php-documentor.el")
        (:name php-align
               :type http
               :url "https://raw.github.com/tetsujin/emacs-php-align/master/php-align.el")
        (:name mysql
               :type http
               :url "http://www.emacswiki.org/emacs/download/mysql.el")
        (:name sql-completion
               :type http
               :url "http://www.emacswiki.org/emacs/download/sql-completion.el")
        (:name rcirc-color
               :type http
               :url "http://www.emacswiki.org/emacs/download/rcirc-color.el")
        (:name ac-php-doc
               :type http
               :url "https://raw.github.com/steckerhalter/ac-php-doc/master/ac-php-doc.el")
        ))

;; need to install package.el for emacs below 24
(when emacs<24
  (add-to-list 'el-get-sources
               '(:name package
                       :type http
                       :url "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el")))

(setq my-el-get-packages
      (append
       '()
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync my-el-get-packages)

;; * package.el

(when (fboundp 'package-initialize)
  (when (require 'cl nil t)

    (package-initialize)

    (setq package-archives '((     "elpa" . "http://elpa.gnu.org/packages/")
                             ("marmalade" . "http://marmalade-repo.org/packages/")
                             (    "melpa" . "http://melpa.milkbox.net/packages/")))

    ;; required because of a package.el bug
    (setq url-http-attempt-keepalives nil)

    (setq elpa-packages

          '(ack-and-a-half
            ac-slime
            auctex
            auto-install
            auto-complete
            back-button
            buffer-move
            calfw
            clojure-mode
            diff-hl
            dired+
            erc-hl-nicks
            expand-region
            fic-ext-mode
            flycheck
            geben
            gist
            google-this
            grandshell-theme
            haskell-mode
            hackernews
            helm
            helm-descbinds
            helm-c-yasnippet
            helm-gtags
            helm-git
            helm-projectile
            highlight-symbol
            iedit
            isearch+
            jinja2-mode
            js2-mode
            json-mode
            key-chord
            lorem-ipsum
            magit
            markdown-mode+
            mmm-mode
            mo-git-blame
            multi-web-mode
            multiple-cursors
            nav
            org
            outline-magic
            outlined-elisp-mode
            php-eldoc
            php-mode
            popup
            pos-tip
            rainbow-mode
            robe
            restclient
            slime-js
            undo-tree
            visual-regexp
            volatile-highlights
            yaml-mode
            yari
            yasnippet)
          )

    ;; excluded packages for emacs below 24
    (when emacs<24
      (setq elpa-packages (set-difference elpa-packages '(erc-hl-nicks js2-mode)))
      )

    (defun elpa-packages-installed-p ()
      (loop for p in elpa-packages
            when (not (package-installed-p p)) do (return nil)
            finally (return t)))

    (defun elpa-install-packages ()
      (unless (elpa-packages-installed-p)
        ;; check for new packages (package versions)
        (message "%s" "Emacs ELPA is now refreshing its package database...")
        (package-refresh-contents)
        (message "%s" " done.")
        ;; install the missing packages
        (dolist (p elpa-packages)
          (unless (package-installed-p p)
            (package-install p)))))

    (elpa-install-packages)
    )

  )

;; * key bindings (mode specific bindings are defined further below with the modes)

;; ** key-chord
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.03)

;; ** general
(global-set-key (kbd "C-c X") (lambda () (interactive) (shell-command "pkill emacs")))
(global-set-key (kbd "C-c s") 'shell)
(key-chord-define-global "cd" (lambda () (interactive) (dired (file-name-directory (or load-file-name buffer-file-name)))))
(key-chord-define-global "sb" 'speedbar)
(global-set-key (kbd "C-S-l") 'package-list-packages-no-fetch)
(global-set-key (kbd "C-c d")  'ispell-change-dictionary)
(key-chord-define-global "cg" 'customize-group)
(global-set-key (kbd "C-h C-f") 'find-function-at-point)
(global-set-key (kbd "C-h C-v") 'find-variable-at-point)

;; ** appearance
(global-set-key (kbd "C-c m") 'menu-bar-mode)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-=") 'text-scale-increase)
(key-chord-define-global "ln" 'linum-mode)

;; ** buffer / file
(global-set-key (kbd "C-c r")  'revert-buffer)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)   ;use ido to switch buffers
(global-set-key (kbd "<f6>") (lambda () (interactive) (kill-buffer (buffer-name)))) ;kill current buffer
(global-set-key (kbd "<f8>") (lambda () (interactive) (switch-to-buffer nil))) ;"other" buffer
(key-chord-define-global "jn" (lambda () (interactive) (switch-to-buffer nil))) ;"other" buffer
(key-chord-define-global "fv" (lambda () (interactive) (kill-buffer (buffer-name)))) ;kill current buff
(global-set-key (kbd "<M-up>")    'buf-move-up)
(global-set-key (kbd "<M-down>")  'buf-move-down)
(global-set-key (kbd "<M-left>")  'buf-move-left)
(global-set-key (kbd "<M-right>") 'buf-move-right)
(key-chord-define-global "eb" 'eval-buffer)
(key-chord-define-global "sv" 'save-buffer)
(key-chord-define-global "sc" (lambda () (interactive)(switch-to-buffer "*scratch*")))

;; ** window / frame
(global-set-key (kbd "C-0") (lambda () (interactive) (select-window (previous-window)))) ;select prev window
(global-set-key (kbd "C-9") (lambda () (interactive) (select-window (next-window))))     ;select next window
(key-chord-define-global "ef" (lambda () (interactive) (select-window (previous-window))))
(key-chord-define-global "ji" (lambda () (interactive) (select-window (next-window))))
(global-set-key (kbd "<C-f8>") (lambda () (interactive) (select-window (previous-window)))) ;for the terminal
(global-set-key (kbd "<C-f9>") (lambda () (interactive) (select-window (next-window)))) ;for the terminal
(global-set-key (kbd "<f2>") 'split-window-vertically)
(global-set-key (kbd "<f3>") 'split-window-horizontally)
(global-set-key (kbd "<f4>") 'delete-window)
(global-set-key (kbd "<f5>") 'delete-other-windows)
(global-set-key (kbd "<C-left>") 'shrink-window)
(global-set-key (kbd "<C-right>") 'enlarge-window)
(global-set-key (kbd "<C-up>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-down>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-8") (lambda () (interactive) (other-frame -1)))
(global-set-key (kbd "C-S-8") (lambda () (interactive) (other-frame 1)))
(key-chord-define-global "jo" 'delete-window)
(key-chord-define-global "fw" 'delete-other-windows)
(key-chord-define-global "sf" 'split-window-horizontally)
(key-chord-define-global "jl" 'split-window-vertically)
(key-chord-define-global ",." 'delete-frame)

;; ** movement / selections
(global-set-key (kbd "M-i") 'er/expand-region)
(global-set-key (kbd "M-I") 'er/mark-inside-pairs)
(global-set-key (kbd "M-o") 'er/contract-region)
(key-chord-define-global "sd" 'move-beginning-of-line)
(key-chord-define-global "kl" 'move-end-of-line)
(key-chord-define-global "wf" 'forward-word)
(key-chord-define-global "aj" (lambda ()  (interactive) (end-of-line) (set-mark (line-beginning-position))))
(key-chord-define-global "wa" 'backward-word)
(key-chord-define-global "i9" 'electric-indent-mode)
(global-set-key (kbd "M-W" ) 'delete-region)  ;delete region (but don't put it into kill ring)

;; ** formatting
(global-set-key (kbd "C-c w") 'whitespace-cleanup)     ;cleanup whitespaces
(global-set-key (kbd "C-c i") (lambda () (interactive) ;indent the whole the buffer
                          (indent-region (point-min) (point-max))))
(global-set-key (kbd "C-c j") 'join-line)
(key-chord-define-global "ac" 'align-current)
(key-chord-define-global "wd" 'kill-word)
(key-chord-define-global "wr" 'kill-whole-line)
(key-chord-define-global "90" 'overwrite-mode)
(global-set-key (kbd "C-c q") 'auto-fill-mode) ;toggles word wrap

;; ** searching / grepping
(key-chord-define-global "vg" 'vc-git-grep)
(key-chord-define-global "fg" 'grep-find)
(global-set-key (kbd "C-c o") 'occur) ;list matching regexp

;; ** my keymap to override problematic bindings
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; * general options

;; load the secrets if available
(when (file-readable-p "~/.secrets.el") (load "~/.secrets.el"))

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq
 inhibit-startup-message t
 backup-directory-alist `((".*" . ,temporary-file-directory)) ;don't clutter my fs and put backups into tmp
 browse-url-browser-function 'browse-url-generic ;default browser
 browse-url-generic-program "x-www-browser"      ;to open urls
 auto-save-default nil              ;disable auto save
 require-final-newline t            ;auto add newline at the end of file
 column-number-mode t               ;show the column number
 default-major-mode 'text-mode      ;use text mode per default
 truncate-partial-width-windows nil ;make side by side buffers break the lines
 mouse-yank-at-point t              ;middle click with the mouse yanks at point
 history-length 250                 ;default is 30
 locale-coding-system 'utf-8        ;utf-8 is default
 confirm-nonexistent-file-or-buffer nil
 vc-follow-symlinks t
 recentf-max-saved-items 5000
 )

(setq-default
 tab-width 4
 indent-tabs-mode nil                ;use spaces instead of tabs
 c-basic-offset 4
 c-auto-hungry-state 1
 )

(global-auto-revert-mode 1)          ;auto revert buffers when changed on disk
(show-paren-mode t)                  ;visualize()
(iswitchb-mode t)                    ;use advanced tab switching
(blink-cursor-mode -1)
(tool-bar-mode -1)                   ;disable the awful toolbar
(menu-bar-mode -1)                   ;no menu
(scroll-bar-mode -1)
(savehist-mode 1)                    ;save minibuffer history

;(global-hl-line-mode 0)

;(defun yes-or-no-p (&rest ignored) t)    ;turn off most confirmations
(defalias 'yes-or-no-p 'y-or-n-p)

; http://www.masteringemacs.org/articles/2010/11/14/disabling-prompts-emacs/
(setq kill-buffer-query-functions
  (remq 'process-kill-buffer-query-function
         kill-buffer-query-functions))

(put 'dired-find-alternate-file 'disabled nil) ;don't always open new buffers in dired

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector [("black" . "#8a8888") ("#EF3460" . "#F25A7D") ("#BDEF34" . "#DCF692") ("#EFC334" . "#F6DF92") ("#34BDEF" . "#92AAF6") ("#B300FF" . "#DF92F6") ("#3DD8FF" . "#5AF2CE") ("#FFFFFF" . "#FFFFFF")])
 '(ecb-options-version "2.40")
 '(send-mail-function (quote sendmail-send-it)))
 ;; '(session-use-package t nil (session)))

;; ** system specific settings
(when (eq system-type 'gnu/linux)
  (autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t) ;activate coloring
  (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)   ;for the shell
  (setq x-select-enable-clipboard t)                           ;enable copy/paste from emacs to other apps
  )

;; * theme / colors

(load-theme 'grandshell t)

(custom-set-faces
 '(default ((t (:background "black" :foreground "#babdb6" :family "Bitstream Vera Sans Mono" :height 89)))))

;; * custom functions

;; copy filename of current buffer to kill ring
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name))
  )
(global-set-key (kbd "C-c n") 'show-file-name)

(defun my/split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'my/split-window)
      (progn
        (jump-to-register :my/split-window)
        (setq this-command 'my/unsplit-window))
    (window-configuration-to-register :my/split-window)
    (switch-to-buffer-other-window nil)))

(global-set-key (kbd "<f9>") 'my/split-window)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
         (next-win-buffer (window-buffer (next-window)))
         (this-win-edges (window-edges (selected-window)))
         (next-win-edges (window-edges (next-window)))
         (this-win-2nd (not (and (<= (car this-win-edges)
                     (car next-win-edges))
                     (<= (cadr this-win-edges)
                     (cadr next-win-edges)))))
         (splitter
          (if (= (car this-win-edges)
             (car (window-edges (next-window))))
          'split-window-horizontally
        'split-window-vertically)))
    (delete-other-windows)
    (let ((first-win (selected-window)))
      (funcall splitter)
      (if this-win-2nd (other-window 1))
      (set-window-buffer (selected-window) this-win-buffer)
      (set-window-buffer (next-window) next-win-buffer)
      (select-window first-win)
      (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "<f7>") 'toggle-window-split)

(defun xfce4-terminal (project-root-p)
  "Open the terminal emulator either from the project root or
  from the location of the current file."
  (start-process "*xfce4-terminal*" nil "xfce4-terminal"
   (concat "--working-directory="
           (file-truename
            (if project-root-p (projectile-project-root)
              (file-name-directory (or dired-directory load-file-name buffer-file-name)))
    ))
   )
  )

(global-set-key (kbd "C-c t") (lambda () (interactive) (xfce4-terminal nil)))
(global-set-key (kbd "C-c T") (lambda () (interactive) (xfce4-terminal t)))

(when (executable-find "autojump")
  (defun ido-autojump (&optional query)
    "Use autojump to open a directory with dired"
    (interactive)
    (unless query (setq query (read-from-minibuffer "Autojump query? ")))
    (let ((dir
           (let ((results
                  (split-string
                   (replace-regexp-in-string
                    ".*__.__" ""
                    (replace-regexp-in-string
                     "^'\\|'\n" ""
                     (shell-command-to-string (concat "autojump --bash --completion " query))))
                   "\n" t)))
             (if (> (length results) 2)
                 (ido-completing-read "Dired: " results nil t)
               (car results)))
           ))
      (if (file-readable-p dir)
          (dired dir)
        (message "Directory %s doesn't exist" dir))
      ))

  (global-set-key (kbd "C-6") 'ido-autojump)

  (defun autojump-add-directory ()
    "Adds the directory of the current buffer/file to the autojump database"
    (start-process "*autojump*" nil "autojump" "--add" (file-name-directory (buffer-file-name)))
    )

  (add-hook 'find-file-hook 'autojump-add-directory)

  )

;; * advices

;; slick-copy: make copy-past a bit more intelligent
;; from: http://www.emacswiki.org/emacs/SlickCopy
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single
line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (message "Copied line")
      (list (line-beginning-position)
               (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single
line instead."
  (interactive
    (if mark-active (list (region-beginning) (region-end))
      (list (line-beginning-position)
        (line-beginning-position 2)))))

;; auto-close shell completion buffer from http://snarfed.org/automatically_close_completions_in_emacs_shell_comint_mode
(defun comint-close-completions ()
  "Close the comint completions buffer.
Used in advice to various comint functions to automatically close
the completions buffer as soon as I'm done with it. Based on
Dmitriy Igrishin's patched version of comint.el."
  (if comint-dynamic-list-completions-config
      (progn
        (set-window-configuration comint-dynamic-list-completions-config)
        (setq comint-dynamic-list-completions-config nil))))
(defadvice comint-send-input (after close-completions activate)
  (comint-close-completions))
(defadvice comint-dynamic-complete-as-filename (after close-completions activate)
  (if ad-return-value (comint-close-completions)))
(defadvice comint-dynamic-simple-complete (after close-completions activate)
  (if (member ad-return-value '('sole 'shortest 'partial))
      (comint-close-completions)))
(defadvice comint-dynamic-list-completions (after close-completions activate)
    (comint-close-completions)
    (if (not unread-command-events)
        ;; comint's "Type space to flush" swallows space. put it back in.
        (setq unread-command-events (listify-key-sequence " "))))

;; bury *scratch* buffer instead of kill it
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (let ((buffer-to-kill (ad-get-arg 0)))
    (if (equal buffer-to-kill "*scratch*")
        (bury-buffer)
      ad-do-it)))

;; * modes

;; ** auctex-mode
(setq TeX-PDF-mode t)
(setq TeX-parse-self t)
(setq TeX-auto-save t)
(setq TeX-save-query nil)

(add-hook 'doc-view-mode-hook 'auto-revert-mode)
(add-hook 'TeX-mode-hook
          '(lambda ()
             (define-key TeX-mode-map (kbd "<C-f8>")
               (lambda ()
                 (interactive)
                 (TeX-command-menu "LaTeX")))
             )
          )

;; ** auto-complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-show-menu 0.5)
(setq ac-quick-help-height 50)
(setq ac-quick-help-delay 1)
(setq ac-use-fuzzy t)
(setq ac-disable-faces nil)
(setq ac-quick-help-prefer-x nil)
(global-set-key (kbd "C-7") 'auto-complete)
(require 'pos-tip)
;; from http://emacswiki.org/emacs/AutoComplete
(defun stk/ac-show-help ()
  "show docs for symbol at point or at beginning of list if not on a symbol"
  (interactive)
  (let ((s (save-excursion
             (or (symbol-at-point)
                 (progn (backward-up-list)
                        (forward-char)
                        (symbol-at-point))))))
    (let ((doc-string (ac-symbol-documentation s)))
      (if doc-string
          (if ac-quick-help-prefer-x
              (pos-tip-show doc-string 'popup-tip-face (point) nil -1)
            (popup-tip doc-string :point (point)))
        (message "No documentation for %s" s)
        ))))
(define-key lisp-mode-shared-map (kbd "<f1>") 'stk/ac-show-help)
(define-key lisp-mode-shared-map (kbd "C-c C-h") 'stk/ac-show-help)

;; ** back-button
(global-set-key (kbd "C-3") 'back-button-local-backward)
(global-set-key (kbd "C-4") 'back-button-local-forward)
(back-button-mode 1)

;; ** calfw
(require 'calfw-ical)
(require 'calfw-org)
(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    (cfw:ical-create-source "gcal" gcal-url "Gray")  ; ICS source1
   )))
(key-chord-define-global "cv" 'my-open-calendar)
(global-set-key (kbd "C-c C") 'my-open-calendar)

;; ** conf-mode
(add-to-list 'auto-mode-alist '("\\.tks\\'" . conf-mode))
(add-to-list 'ac-modes 'conf-mode)
;; ** deft
(setq
 deft-extension "org"
 deft-directory "~/"
 deft-auto-save-interval 0
 deft-text-mode 'org-mode)

;; ** diff-hl
(unless emacs<24
  (global-diff-hl-mode 1)
  (defun diff-hl-update-each-buffer ()
    (interactive)
    (mapc (lambda (buffer)
            (condition-case nil
                (with-current-buffer buffer
                  (diff-hl-update))
              (buffer-read-only nil)))
          (buffer-list)))
  (defadvice magit-update-vc-modeline (after my-magit-update-vc-modeline activate)
    (progn (diff-hl-update-each-buffer)))
  )

;; ** dired+
(toggle-diredp-find-file-reuse-dir 1)

;; ** ecb
(setq
 ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2)
 ecb-tip-of-the-day nil
 )
(global-set-key (kbd "C-c e") (lambda () (interactive)
                                (if (not (fboundp 'ecb-toggle-ecb-windows))
                                    (ecb-activate)
                                  (ecb-toggle-ecb-windows))
                                ))

;; ** erc mode
(add-hook 'erc-mode-hook (lambda ()
                           (erc-truncate-mode t)
                           (set (make-local-variable 'scroll-conservatively) 1000)
                           )
          )
(setq erc-timestamp-format "%H:%M "
      erc-fill-prefix "      "
      erc-insert-timestamp-function 'erc-insert-timestamp-left)
(setq erc-interpret-mirc-color t)
(setq erc-kill-buffer-on-part t)
(setq erc-kill-queries-on-quit t)
(setq erc-kill-server-buffer-on-quit t)
(setq erc-server-send-ping-interval 45)
(setq erc-server-send-ping-timeout 180)
(setq erc-server-reconnect-timeout 60)
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))
(global-set-key (kbd "C-c E")
                (lambda ()
                  (interactive)
                  (erc-tls
                   :server erc-server
                   :port erc-port
                   :nick erc-nick
                   :full-name erc-user-full-name
                   :password erc-password
                   )))

;; ------ template for .secrets.el
;; (setq erc-prompt-for-nickserv-password nil)
;; (setq erc-server "hostname"
;;       erc-port 7000
;;       erc-nick "user"
;;       erc-user-full-name "user"
;;       erc-email-userid "user"
;;       erc-password "user:pw"
;;       )

(add-hook 'window-configuration-change-hook
          '(lambda ()
             (setq erc-fill-column (- (window-width) 2))))

(defun rgr/ido-erc-buffer()
  (interactive)
  (switch-to-buffer
   (ido-completing-read "Channel:"
                        (save-excursion
                          (delq
                           nil
                           (mapcar (lambda (buf)
                                     (when (buffer-live-p buf)
                                       (with-current-buffer buf
                                         (and (eq major-mode 'erc-mode)
                                              (buffer-name buf)))))
                                   (buffer-list)))))))

(global-set-key (kbd "C-c b") 'rgr/ido-erc-buffer)

;; ** fic-ext-mode
(add-hook 'prog-mode-hook 'fic-ext-mode) ;; highlight TODO/FIXME/...

;; ** flycheck-mode
(add-hook 'php-mode-hook 'flycheck-mode)
(add-hook 'sh-mode-hook 'flycheck-mode)
(add-hook 'json-mode-hook 'flycheck-mode)
(key-chord-define-global "fc" 'flycheck-mode)

;; ** flyspell-mode
(global-set-key (kbd "C-c f")  'flyspell-mode)

;; ** google-this
(google-this-mode 1)
(key-chord-define-global "gt" 'google-this)
(key-chord-define-global "gs" 'google-search)

;; ** hackernews
(key-chord-define-global "bn" 'hackernews)

;; ** haskell-mode
(require 'haskell-mode)
(setq haskell-indent-thenelse 3)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)

;; ** helm
(require 'helm-config)
(setq enable-recursive-minibuffers t)
(when (not emacs<24) (helm-mode 1))
(helm-gtags-mode 1)
(setq helm-idle-delay 0.1)
(setq helm-input-idle-delay 0.1)
(setq helm-buffer-max-length 50)
(global-set-key (kbd "M-x") 'helm-M-x)
(define-key my-keys-minor-mode-map (kbd "<C-tab>") 'helm-mini)
(global-set-key (kbd "<C-f7>") 'helm-mini) ; for the terminal
(global-set-key (kbd "<C-S-iso-lefttab>") 'helm-for-files)
(global-set-key (kbd "C-x f") 'helm-find-files)
;(global-set-key (kbd "M-3") 'helm-etags-select)
(global-set-key (kbd "M-5") 'helm-gtags-select)
(global-set-key (kbd "M-7") 'helm-show-kill-ring)
(global-set-key (kbd "M-8") (lambda () (interactive) (let ((current-prefix-arg t)) (helm-do-grep))))
(global-set-key (kbd "M-9") 'helm-occur)
(global-set-key (kbd "M--") 'helm-resume)
(global-set-key (kbd "C-S-h") 'helm-descbinds)
(global-set-key (kbd "C-c h") 'helm-projectile)
(key-chord-define-global "fw" 'helm-find-files)
(key-chord-define-global "fh" 'helm-for-files)
(key-chord-define-global "hg" (lambda () (interactive) (let ((current-prefix-arg t)) (helm-do-grep))))
(key-chord-define-global "hh" 'helm-descbinds)
(key-chord-define-global "lo" 'helm-locate)
(key-chord-define-global "34" 'helm-imenu)

(require 'helm-git)
(global-set-key (kbd "M-0") 'helm-git-find-files)

;; ** highlight-symbol
(setq highlight-symbol-on-navigation-p t)
(setq highlight-symbol-idle-delay 0.2)
(global-set-key (kbd "M-2") 'highlight-symbol-occur)
(global-set-key (kbd "M-3") (lambda () (interactive) (highlight-symbol-jump -1)))
(global-set-key (kbd "M-4") (lambda () (interactive) (highlight-symbol-jump 1)))
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

;; ** ido-mode
(setq ido-enable-flex-matching t
      ido-auto-merge-work-directories-length -1
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-everywhere t
      ido-default-buffer-method 'selected-window
      ido-max-prospects 32
      )
(ido-mode 1)

;; ** iedit
(require 'iedit)
(setq iedit-unmatched-lines-invisible-default t)

;; ** isearch+
(eval-after-load "isearch" '(require 'isearch+))

;; ** jinja2-mode for twig
(require 'jinja2-mode)
(add-to-list 'auto-mode-alist '("\\.twig$" . jinja2-mode))

;; ** js2-mode
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook
          (lambda ()
            (when (fboundp 'slime-js-minor-mode) (slime-js-minor-mode 1))
            (local-set-key (kbd "C-c C-v") 'slime-eval-region)
            (local-set-key (kbd "C-c b") 'slime-eval-buffer)
            (local-set-key (kbd "C-x C-e") (lambda () (interactive) (slime-eval-region (line-beginning-position) (line-end-position))))
            (local-set-key (kbd "C-c h") (lambda () (interactive) (mark-paragraph) (slime-eval-region (region-beginning) (region-end))))
            ))

;; ** json-mode
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

;; ** lorem-ipsum
(require 'lorem-ipsum)
(global-unset-key (kbd "C-x l"))
(global-set-key (kbd "C-x l l") 'Lorem-ipsum-insert-list)
(global-set-key (kbd "C-x l p") 'Lorem-ipsum-insert-paragraphs)
(global-set-key (kbd "C-x l s") 'Lorem-ipsum-insert-sentences)

;; ** magit
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c l") 'magit-log)
(setq magit-commit-all-when-nothing-staged t)

;; ** markdown
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; ** mu4e
(when (file-exists-p "/usr/local/share/emacs/site-lisp/mu4e")
  (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
  (autoload 'mu4e "mu4e" "Mail client based on mu (maildir-utils)." t)
  ;; enable inline images
  (setq mu4e-view-show-images t)
  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  (setq mu4e-html2text-command "html2text -utf8 -width 72")
  (setq mu4e-update-interval 60)
  (setq mu4e-auto-retrieve-keys t)
  (setq mu4e-headers-leave-behavior 'apply)
  (setq mu4e-headers-visible-lines 20)

  (add-hook 'mu4e-headers-mode-hook (lambda () (local-set-key (kbd "X") (lambda () (interactive) (mu4e-mark-execute-all t)))))
  (add-hook 'mu4e-view-mode-hook (lambda () (local-set-key (kbd "X") (lambda () (interactive) (mu4e-mark-execute-all t)))))

  (defun mu4e-headers-mark-all-unread-read ()
    (interactive)
    (mu4e~headers-mark-for-each-if
     (cons 'read nil)
     (lambda (msg param)
       (memq 'unread (mu4e-msg-field msg :flags)))))

  (defun mu4e-flag-all-read ()
    (interactive)
    (mu4e-headers-mark-all-unread-read)
    (mu4e-mark-execute-all t))

  (setq message-kill-buffer-on-exit t)

  (key-chord-define-global "nm" 'mu4e)
  )

;; ** multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)

;; ** multi-web-mode
;; (when (require 'multi-web-mode nil t)
;;   (setq mweb-default-major-mode 'html-mode)
;;   (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;;                     (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;;                     (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;;   (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;;   (multi-web-global-mode 1)
;;   )

(add-to-list 'ac-modes 'html-mode)
(dolist (hook '(css-mode-hook
                html-mode-hook
                js-mode-hook))
  (add-hook hook (lambda ()
                   (when (fboundp 'slime-js-minor-mode)
                     (add-hook 'after-save-hook 'slime-js-reload nil 'make-it-local))
                   )
            ))

;; ** mutt, load mail-mode
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode))
(add-hook 'mail-mode-hook (lambda ()
                            (flyspell-mode 1)
                            ))

;; ** org-mode
;; if todo.org exists, startup emacs with the org todo list
(let ((todo "~/org/todo.org"))
  (when (file-readable-p todo)
    (setq initial-buffer-choice (lambda ()
                                  (org-todo-list)
                                  (delete-other-windows)
                                  (current-buffer)
                                  ))
  ))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))
(setq
  appt-display-mode-line t     ; show in the modeline
  appt-display-format 'window)
(appt-activate 1)              ; activate appt (appointment notification)
(org-agenda-to-appt)           ; add appointments on startup
;; add new appointments when saving the org buffer, use 'refresh argument to do it properly
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook '(lambda () (org-agenda-to-appt 'refresh)) nil 'make-it-local)))
(setq appt-disp-window-function '(lambda (min-to-app new-time msg) (interactive)
    (shell-command (concat "notify-send -i /usr/share/icons/gnome/32x32/status/appointment-soon.png '" (format "Appointment in %s min" min-to-app) "' '" msg "'")))
)
(key-chord-define-global "89" 'org-todo-list)

;; ** outline-mode
(require 'outlined-elisp-mode)
(define-prefix-command 'cm-map nil "Outline-") ; Outline-minor-mode key map
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(define-key cm-map "\C-t" 'outline-cycle)
(global-set-key "\C-t" cm-map)
(add-hook 'emacs-lisp-mode-hook 'outlined-elisp-find-file-hook)
(add-hook 'outline-minor-mode-hook (lambda () (require 'outline-magic)))

;; ** php-mode
(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.module\\'" . php-mode))

(let ((manual "/usr/share/doc/php-doc/html/"))
  (when (file-readable-p manual)
    (setq php-manual-path manual)))

(defun setup-php-mode ()
  (require 'php-documentor nil t)
  (local-set-key (kbd "C-c p") 'php-documentor-dwim)
  (require 'php-align nil t)
  (php-align-setup)
  (php-eldoc-enable)
  (set-up-php-ac)
  )

(add-hook 'php-mode-hook 'setup-php-mode)

;; die me some var_dump quickly
(defun var_dump-die ()
  (interactive)
  (let ((expression (if (region-active-p)
                        (buffer-substring (region-beginning) (region-end))
                      (sexp-at-point)))
        (line (thing-at-point 'line))
        (pre "die(var_dump(")
        (post "));")
        )
    (if expression
        (progn
          (beginning-of-line)
          (if (string-match "return" line)
              (progn
                (newline)
                (previous-line))
            (next-line)
            (newline)
            (previous-line)
            )
          (insert pre)
          (insert (format "%s" expression))
          (insert post))
      ()
      (insert pre)
      (insert post)
      (backward-char (length post))
      )))
(key-chord-define-global "bv" 'var_dump-die)
(key-chord-define-global "pm" 'php-mode)

(defun var_dump ()
  (interactive)
  (if (region-active-p)
    (progn
      (goto-char (region-end))
      (insert ");")
      (goto-char (region-beginning))
      (insert "var_dump("))
    (insert "var_dump();")
    (backward-char 3)
    ))

(key-chord-define-global "dv" 'var_dump)

;; ** prog-mode
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1))) ; show whitespace errors

;; ** projectile
;(projectile-global-mode)
(require 'projectile nil t)
;(setq projectile-enable-caching t)
(key-chord-define-global "fr" 'projectile-find-file)
(key-chord-define-global "rg" 'projectile-grep)
(key-chord-define-global "ok" 'projectile-multi-occur)
(key-chord-define-global "aw" 'projectile-ack)

;; ** rainbow-mode
(dolist (hook '(css-mode-hook
                html-mode-hook
                js-mode-hook
                emacs-lisp-mode-hook
                org-mode-hook
                text-mode-hook
                ))
  (add-hook hook 'rainbow-mode)
  )

;; ** rcirc
(eval-after-load 'rcirc '(require 'rcirc-color))
(setq rcirc-fill-column 'frame-width)
(add-hook 'rcirc-mode-hook
          (lambda ()
            (flyspell-mode 1)
            (rcirc-omit-mode)
            (set (make-local-variable 'scroll-conservatively) 8192)))
(global-set-key (kbd "C-c I") 'irc)

;; ** robe
(add-hook 'ruby-mode-hook
          (lambda ()
            (robe-mode 1)
            (push 'ac-source-robe ac-sources)))

;; ** saveplace
(require 'saveplace)
(setq-default save-place t)

;; ** smartparens
(require 'smartparens-config)
(smartparens-global-mode t)
(define-key sp-keymap (kbd "M-p") 'sp-backward-sexp)
(define-key sp-keymap (kbd "M-n") 'sp-forward-sexp)
(define-key sp-keymap (kbd "C-{") 'sp-select-previous-thing-exchange)
(define-key sp-keymap (kbd "C-}") 'sp-select-next-thing-exchange)
(define-key sp-keymap (kbd "C-\\") 'sp-select-previous-thing)
(define-key sp-keymap (kbd "C-]") 'sp-select-next-thing)

;; ** sgml
(setq sgml-basic-offset 4)
(add-hook 'sgml-mode-hook 'sgml-electric-tag-pair-mode)

;; ** slime
(when (file-exists-p "~/quicklisp/slime-helper.el") (load "~/quicklisp/slime-helper.el"))
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))

;; ** sql-completion
(when (require 'sql-completion nil t)
  (setq sql-interactive-mode-hook
        (lambda ()
          (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
          (sql-mysql-completion-init)))
  )

;; ** term-mode
(add-hook 'term-mode-hook (lambda()
                (yas-minor-mode -1)))

;; ** tempo
(require 'tempo nil t)

;; ** undo-tree
(global-undo-tree-mode 1)
(global-set-key (kbd "C-'") 'undo-tree-redo)
(global-set-key (kbd "C-,") 'undo-tree-visualize)
(global-set-key (kbd "C-\"") 'undo-tree-visualize)
(setq undo-tree-visualizer-timestamps t)


;; ** uniqify
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-min-dir-content 2)

;; ** yasnippets
(yas-global-mode 1)
(setq yas-prompt-functions '(yas-completing-prompt yas-ido-prompt yas-x-prompt yas-dropdown-prompt yas-no-prompt))

;; ** visual-regexp
(key-chord-define-global "vr" 'vr/replace)

;; ** w3m, optional
(when (require 'w3m nil t)
  (setq
   w3m-use-favicon nil
   w3m-default-display-inline-images t
   w3m-search-word-at-point nil
   w3m-use-cookies t
   w3m-home-page "http://en.wikipedia.org/"
   w3m-cookie-accept-bad-cookies t
   w3m-session-crash-recovery nil)
  (add-hook 'w3m-mode-hook
            (function (lambda ()
                        (set-face-foreground 'w3m-anchor-face "LightSalmon")
                        (set-face-foreground 'w3m-arrived-anchor-face "LightGoldenrod")
                        ;;(set-face-background 'w3m-image-anchor "black")
                        (load "w3m-lnum")
                        (defun w3m-go-to-linknum ()
                          "Turn on link numbers and ask for one to go to."
                          (interactive)
                          (let ((active w3m-lnum-mode))
                            (when (not active) (w3m-lnum-mode))
                            (unwind-protect
                                (w3m-move-numbered-anchor (read-number "Anchor number: "))
                              (when (not active) (w3m-lnum-mode))))
                          (w3m-view-this-url)
                          )
                        (define-key w3m-mode-map "f" 'w3m-go-to-linknum)
                        (define-key w3m-mode-map "L" 'w3m-lnum-mode)
                        (define-key w3m-mode-map "o" 'w3m-previous-anchor)
                        (define-key w3m-mode-map "i" 'w3m-next-anchor)
                        (define-key w3m-mode-map "w" 'w3m-search-new-session)
                        (define-key w3m-mode-map "p" 'w3m-previous-buffer)
                        (define-key w3m-mode-map "n" 'w3m-next-buffer)
                        (define-key w3m-mode-map "z" 'w3m-delete-buffer)
                        (define-key w3m-mode-map "O" 'w3m-goto-new-session-url)
                        )))
  )

;; ** whole-line-or-region // actually the defadvice works better than this mode
;(whole-line-or-region-mode 1)

;; ** yaml-mode
(setq yaml-indent-offset 4)

;; * end

;; ** turn on the keyboard overrides
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " K" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)

;; **  makes it possible to do /sudo:host: , reads pws from ~/.authinfo.gpg
(add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist '((regexp-quote (system-name)) nil nil))

(provide '.emacs)

;;; .emacs.el ends here
