;; tidal.el - (c) alex@slab.org, 20012, based heavily on...
;; hsc3.el - (c) rohan drape, 2006-2008

;; notes from hsc3:
;; This mode is implemented as a derivation of `haskell' mode,
;; indentation and font locking is courtesy that mode.  The
;; inter-process communication is courtesy `comint'.  The symbol at
;; point acquisition is courtesy `thingatpt'.  The directory search
;; facilities are courtesy `find-lisp'.

;; notes from tida1vm:
;; This mode is a modified version of the original `tidal.el`
;; written by Alex McLean.  Please note that any reference to
;; Dirt has been removed.
;;

(require 'scheme)
(require 'comint)
(require 'thingatpt)
(require 'find-lisp)
(require 'pulse)

(defvar tidal-buffer
  "*tidal*"
  "*The name of the tidal process buffer (default=*tidal*).")

(defvar tidal-interpreter
  "ghci"
  "*The haskell interpeter to use (default=ghci).")

(defvar tidal-interpreter-arguments
  (list "-XOverloadedStrings"
        )
  "*Arguments to the haskell interpreter (default=none).")

(defvar tidal-literate-p
  t
  "*Flag to indicate if we are in literate mode (default=t).")

(make-variable-buffer-local 'tidal-literate-p)

(defun tidal-unlit (s)
  "Remove bird literate marks"
  (replace-regexp-in-string "^> " "" s))

(defun tidal-intersperse (e l)
  (if (null l)
      '()
    (cons e (cons (car l) (tidal-intersperse e (cdr l))))))

(defun tidal-start-haskell ()
  "Start haskell."
  (interactive)
  (if (comint-check-proc tidal-buffer)
      (error "A tidal process is already running")
    (apply
     'make-comint
     "tidal"
     tidal-interpreter
     nil
     tidal-interpreter-arguments)
    (tidal-see-output))
  (tidal-send-string ":set prompt \"\"")
  (tidal-send-string ":module Sound.Tidal.Context")
  (tidal-send-string "syncType <- initializeSyncType")
  (tidal-send-string "nosync <- changeSyncType syncType NoSync")
  (tidal-send-string "esp <- changeSyncType syncType Esp")
  (tidal-send-string "(cpsNone,getNowNone) <- cpsUtils")
  (tidal-send-string "(cpsEsp,getNowEsp) <- cpsUtilsEsp")
  (tidal-send-string "(cps,getNow) <- multiModeCpsUtils (cpsNone,getNowNone) (cpsEsp,getNowEsp) syncType")
  (tidal-send-string "let bps x = cps (x/2)")
  (tidal-send-string "streamType <- initializeStreamType")
  (tidal-send-string "superDirt <- changeStreamType streamType SuperDirt")
  (tidal-send-string "import Sound.Tidal.MIDI.Context")
  (tidal-send-string "import Sound.Tidal.MIDI.VolcaBass")
  (tidal-send-string "import Sound.Tidal.MIDI.VolcaBeats")
  (tidal-send-string "import Sound.Tidal.MIDI.GMParams")
  (tidal-send-string "import Sound.Tidal.MIDI.GMPerc")
  (tidal-send-string "import Sound.Tidal.MIDI.GMSynth as GS")
  (tidal-send-string "devices <- midiDevices")
  (tidal-send-string "d1 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d2 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d3 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d4 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d5 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d6 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d7 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d8 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d9 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "d10 <- multiModeSetters getNowNone getNowEsp syncType streamType")
  (tidal-send-string "beat <- midiStream devices \"Midi Through Port-0\" 1 beatsController")
  (tidal-send-string "bass <- midiStream devices \"Midi Through Port-0\" 2 bassController")
  (tidal-send-string "midi3 <- midiStream devices \"Midi Through Port-0\" 3 GS.synthController")
  (tidal-send-string "midi4 <- midiStream devices \"Midi Through Port-0\" 4 GS.synthController")
  (tidal-send-string "midi5 <- midiStream devices \"Midi Through Port-0\" 5 GS.synthController")
  (tidal-send-string "midi6 <- midiStream devices \"Midi Through Port-0\" 6 GS.synthController")
  (tidal-send-string "midi7 <- midiStream devices \"Midi Through Port-0\" 7 GS.synthController")
  (tidal-send-string "midi8 <- midiStream devices \"Midi Through Port-0\" 8 GS.synthController")
  (tidal-send-string "midi9 <- midiStream devices \"Midi Through Port-0\" 9 GS.synthController")
  (tidal-send-string "drums <- midiStream devices \"Midi Through Port-0\" 10 percController")
  (tidal-send-string "midi11 <- midiStream devices \"Midi Through Port-0\" 11 GS.synthController")
  (tidal-send-string "midi12 <- midiStream devices \"Midi Through Port-0\" 12 GS.synthController")
  (tidal-send-string "midi13 <- midiStream devices \"Midi Through Port-0\" 13 GS.synthController")
  (tidal-send-string "midi14 <- midiStream devices \"Midi Through Port-0\" 14 GS.synthController")
  (tidal-send-string "midi15 <- midiStream devices \"Midi Through Port-0\" 15 GS.synthController")
  (tidal-send-string "midi16 <- midiStream devices \"Midi Through Port-0\" 16 GS.synthController")

  (tidal-send-string "let hush = mapM_ ($ silence) [beat,bass,drums,midi3,midi4,midi5,midi6,midi7,midi8,midi9,midi11,midi12,midi13,midi14,midi15,midi16,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10]")
  (tidal-send-string "let solo = (>>) hush")
  (tidal-send-string ":set prompt \"tidal> \"")
)

(defun tidal-see-output ()
  "Show haskell output."
  (interactive)
  (when (comint-check-proc tidal-buffer)
    (delete-other-windows)
    (split-window-vertically)
    (with-current-buffer tidal-buffer
      (let ((window (display-buffer (current-buffer))))
        (select-window window) ;; resize debug
        (shrink-window 9) ;; resize debug
	(goto-char (point-max))
	(save-selected-window
	  (set-window-point window (point-max)))))))

(defun tidal-quit-haskell ()
  "Quit haskell."
  (interactive)
  (kill-buffer tidal-buffer)
  (delete-other-windows))

(defun tidal-help ()
  "Lookup up the name at point in the Help files."
  (interactive)
  (mapc (lambda (filename)
	  (find-file-other-window filename))
	(find-lisp-find-files tidal-help-directory
			      (concat "^"
				      (thing-at-point 'symbol)
				      "\\.help\\.lhs"))))

(defun chunk-string (n s)
  "Split a string into chunks of 'n' characters."
  (let* ((l (length s))
         (m (min l n))
         (c (substring s 0 m)))
    (if (<= l n)
        (list c)
      (cons c (chunk-string n (substring s n))))))

(defun tidal-send-string (s)
  (if (comint-check-proc tidal-buffer)
      (let ((cs (chunk-string 64 (concat s "\n"))))
        (mapcar (lambda (c) (comint-send-string tidal-buffer c)) cs))
    (error "no tidal process running?")))

(defun tidal-transform-and-store (f s)
  "Transform example text into compilable form."
  (with-temp-file f
    (mapc (lambda (module)
	    (insert (concat module "\n")))
	  tidal-modules)
    (insert "main = do\n")
    (insert (if tidal-literate-p (tidal-unlit s) s))))


(defun tidal-get-now ()
  "Store the current cycle position in a variable called 'now'."
  (interactive)
  (tidal-send-string "now' <- getNow")
  (tidal-send-string "let now = nextSam now'")
  (tidal-send-string "let retrig = (now ~>)")
  (tidal-send-string "let fadeOut n = spread' (degradeBy) (retrig $ slow n $ envL)")
  (tidal-send-string "let fadeIn n = spread' (degradeBy) (retrig $ slow n $ (1-) <$> envL)")

  )

(defun tidal-run-line ()
  "Send the current line to the interpreter."
  (interactive)
  (tidal-get-now)
  (let* ((s (buffer-substring (line-beginning-position)
			      (line-end-position)))
	 (s* (if tidal-literate-p
		 (tidal-unlit s)
	       s)))
    (tidal-send-string s*))
  (pulse-momentary-highlight-one-line (point))
  (next-line)
  )

(defun tidal-run-multiple-lines ()
  "Send the current region to the interpreter as a single line."
  (interactive)
  (tidal-get-now)
  (save-excursion
   (mark-paragraph)
   (let* ((s (buffer-substring-no-properties (region-beginning)
                                             (region-end)))
          (s* (if tidal-literate-p
                  (tidal-unlit s)
                s)))
     (tidal-send-string ":{")
     (tidal-send-string s*)
     (tidal-send-string ":}")
     (mark-paragraph)
     (pulse-momentary-highlight-region (mark) (point))
     )
    ;(tidal-send-string (replace-regexp-in-string "\n" " " s*))
   )
  )

(defun tidal-run-region ()
  "Place the region in a do block and compile."
  (interactive)
  (tidal-transform-and-store
   "/tmp/tidal.hs"
   (buffer-substring-no-properties (region-beginning) (region-end)))
  (tidal-send-string ":load \"/tmp/tidal.hs\"")
  (tidal-send-string "main"))

(defun tidal-load-buffer ()
  "Load the current buffer."
  (interactive)
  (save-buffer)
  (tidal-send-string (format ":load \"%s\"" buffer-file-name)))

(defun tidal-run-main ()
  "Run current main."
  (interactive)
  (tidal-send-string "main"))

(defun tidal-interrupt-haskell ()
  (interactive)
  (if (comint-check-proc tidal-buffer)
      (with-current-buffer tidal-buffer
	(interrupt-process (get-buffer-process (current-buffer))))
    (error "no tidal process running?")))

(defvar tidal-mode-map nil
  "Tidal keymap.")

(defun tidal-mode-keybindings (map)
  "Haskell Tidal keybindings."
  (define-key map [?\C-c ?\C-s] 'tidal-start-haskell)
  (define-key map [?\C-c ?\C-v] 'tidal-see-output)
  (define-key map [?\C-c ?\C-q] 'tidal-quit-haskell)
  (define-key map [?\C-c ?\C-c] 'tidal-run-line)
  (define-key map [?\C-c ?\C-e] 'tidal-run-multiple-lines)
  (define-key map (kbd "<C-return>") 'tidal-run-multiple-lines)
  (define-key map [?\C-c ?\C-r] 'tidal-run-region)
  (define-key map [?\C-c ?\C-l] 'tidal-load-buffer)
  (define-key map [?\C-c ?\C-i] 'tidal-interrupt-haskell)
  (define-key map [?\C-c ?\C-m] 'tidal-run-main)
  (define-key map [?\C-c ?\C-h] 'tidal-help))

(defun turn-on-tidal-keybindings ()
  "Haskell Tidal keybindings in the local map."
  (local-set-key [?\C-c ?\C-s] 'tidal-start-haskell)
  (local-set-key [?\C-c ?\C-v] 'tidal-see-output)
  (local-set-key [?\C-c ?\C-q] 'tidal-quit-haskell)
  (local-set-key [?\C-c ?\C-c] 'tidal-run-line)
  (local-set-key [?\C-c ?\C-e] 'tidal-run-multiple-lines)
  (local-set-key (kbd "<C-return>") 'tidal-run-multiple-lines)
  (local-set-key [?\C-c ?\C-r] 'tidal-run-region)
  (local-set-key [?\C-c ?\C-l] 'tidal-load-buffer)
  (local-set-key [?\C-c ?\C-i] 'tidal-interrupt-haskell)
  (local-set-key [?\C-c ?\C-m] 'tidal-run-main)
  (local-set-key [?\C-c ?\C-h] 'tidal-help))

(defun tidal-mode-menu (map)
  "Haskell Tidal menu."
  (define-key map [menu-bar tidal]
    (cons "Haskell-Tidal" (make-sparse-keymap "Haskell-Tidal")))
  (define-key map [menu-bar tidal help]
    (cons "Help" (make-sparse-keymap "Help")))
  (define-key map [menu-bar tidal expression]
    (cons "Expression" (make-sparse-keymap "Expression")))
  (define-key map [menu-bar tidal expression load-buffer]
    '("Load buffer" . tidal-load-buffer))
  (define-key map [menu-bar tidal expression run-main]
    '("Run main" . tidal-run-main))
  (define-key map [menu-bar tidal expression run-region]
    '("Run region" . tidal-run-region))
  (define-key map [menu-bar tidal expression run-multiple-lines]
    '("Run multiple lines" . tidal-run-multiple-lines))
  (define-key map [menu-bar tidal expression run-line]
    '("Run line" . tidal-run-line))
  (define-key map [menu-bar tidal haskell]
    (cons "Haskell" (make-sparse-keymap "Haskell")))
  (define-key map [menu-bar tidal haskell quit-haskell]
    '("Quit haskell" . tidal-quit-haskell))
  (define-key map [menu-bar tidal haskell see-output]
    '("See output" . tidal-see-output))
  (define-key map [menu-bar tidal haskell start-haskell]
    '("Start haskell" . tidal-start-haskell)))

(if tidal-mode-map
    ()
  (let ((map (make-sparse-keymap "Haskell-Tidal")))
    (tidal-mode-keybindings map)
    (tidal-mode-menu map)
    (setq tidal-mode-map map)))

(define-derived-mode
  literate-tidal-mode
  tidal-mode
  "Literate Haskell Tidal"
  "Major mode for interacting with an inferior haskell process."
  (set (make-local-variable 'paragraph-start) "\f\\|[ \t]*$")
  (set (make-local-variable 'paragraph-separate) "[ \t\f]*$")
  (setq tidal-literate-p t)
  (setq haskell-literate 'bird)
  (turn-on-font-lock))

(add-to-list 'auto-mode-alist '("\\.ltidal$" . literate-tidal-mode))
;(add-to-list 'load-path "/usr/share/emacs/site-lisp/haskell-mode/") ;required by olig1905 on linux
;(require 'haskell-mode) ;required by olig1905 on linux
(define-derived-mode
  tidal-mode
  haskell-mode
  "Haskell Tidal"
  "Major mode for interacting with an inferior haskell process."
  (set (make-local-variable 'paragraph-start) "\f\\|[ \t]*$")
  (set (make-local-variable 'paragraph-separate) "[ \t\f]*$")
  (setq tidal-literate-p nil)
  (turn-on-font-lock))

(add-to-list 'auto-mode-alist '("\\.tidal$" . tidal-mode))

(provide 'tidal)
