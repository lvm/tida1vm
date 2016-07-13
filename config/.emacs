(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
("melpa-stable" . "http://stable.melpa.org/packages/")))))

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

(add-hook 'isearch-update-post-hook 'redraw-display)

(add-to-list 'load-path "~/.elisp")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(require 'haskell-mode)
(require 'tidal)

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)


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
	        (lambda () (load-theme 'cyberpunk-transparent t)))
