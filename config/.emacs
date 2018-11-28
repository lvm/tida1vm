(require 'package)
(custom-set-variables
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
("melpa-stable" . "http://stable.melpa.org/packages/")))))

(add-to-list 'load-path "~/.elisp")
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(require 'haskell-mode)
(require 'tidal)

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(global-centered-cursor-mode +1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)
(defconst query-replace-highlight t)
(defconst search-highlight t)
(setq ecb-tip-of-the-day nil)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-r" ;; reload .emacs
  '(lambda () (interactive) (load-file "~/.emacs")))
(setq-default line-number-mode t)
(setq-default column-number-mode t)
(display-time)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq make-backup-files nil)
(setq version-control 'never)
(setq transient-mark-mode t)
(setq visible-bell t)
(setq scroll-step 1)
(setq truncate-partial-width-windows nil)
(menu-bar-mode -99) ;; no-x requires -99, x works with just -1
;;(global-hl-line-mode 1)
(add-hook 'isearch-update-post-hook 'redraw-display)

(fset 'stidal
      "\C-c\C-s")

(fset 'smarkall
      "\C-xh")

(fset 'sfocusother
      "\C-xo")

(fset 'seval
      "\C-c\C-e")

(fset 'skillbuff
      "\C-xk")

(find-file "~/livecode/helpers.tidal")
(execute-kbd-macro (symbol-function 'stidal))
(sleep-for 2)
(execute-kbd-macro (symbol-function 'sfocusother))
(sleep-for 2)
(execute-kbd-macro (symbol-function 'smarkall))
(sleep-for 2)
(execute-kbd-macro (symbol-function 'seval))
(sleep-for 2)
(execute-kbd-macro (symbol-function 'skillbuff))
(find-file "~/livecode/init.tidal")

(add-hook 'after-init-hook
	  (lambda ()
	    (load-theme 'monochrome-transparent t)
	    (kill-buffer "*scratch*")
	    ))
