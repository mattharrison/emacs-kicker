(add-to-list 'load-path "~/work/emacs/el-get")

(require 'el-get)
(setq
 el-get-sources
 '(el-get
   escreen                ; screen for emacs, C-\ C-h
   switch-window          ; take over C-x o
   ;auto-complete
                                        ;yasnippet emacs-starter-kit python has these
   full-ack
   minimap
   (:name pycoverage
          :type git
          :url "https://github.com/mattharrison/pycoverage.el.git")
   (:name pomodoro
          :type http
          :url "http://kanis.fr/hg/lisp/ivan/pomodoro.el")



   (:name smex				; a better (ido like) M-x
	  :after (lambda ()
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name dot-mode
          :type git
          :url "https://github.com/emacsmirror/dot-mode.git"
          :features dot-mode
          )
   rainbow-mode
   (:name pretty-mode
          :type git
          :url "https://github.com/mattharrison/pretty-mode.git"
          :features pretty-mode)
   (:name point-stack
          :type git
          :url "https://github.com/mattharrison/point-stack.git"
          :features point-stack
          :after (lambda ()
                   (global-set-key '[(f5)] 'point-stack-push)
                   (global-set-key '[(f6)] 'point-stack-pop)
                   (global-set-key '[(f7)] 'point-stack-forward-stack-pop)))
   (:name my-tango-theme
          :type git
          :url "https://github.com/mattharrison/emacs-tango-theme.git"
          :features tango-theme)

   ))

;; install new packages and init already installed packages
(el-get 'sync)

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

;; show flymake problems in minibuffer
;; https://gist.github.com/415429
(defun my-flymake-show-help ()
   (when (get-char-property (point) 'flymake-overlay)
     (let ((help (get-char-property (point) 'help-echo)))
       (if help (message "%s" help)))))
(add-hook 'post-command-hook 'my-flymake-show-help)

;; Notes
;; C-x +  (balanced windows after split)

;; C-c left (undo) C-c right (redo)
(winner-mode t)

;; when I paste with mouse, do it at click (and not at point)
(setq mouse-yank-at-point nil)

(global-font-lock-mode 1)
(setq inhibit-splash-screen t)
(setq font-lock-maximum-decoration 3)
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(fset 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(show-paren-mode 1)
(transient-mark-mode t)
(setq case-fold-search t)
(blink-cursor-mode 0)

(custom-set-variables
 '(indent-tabs-mode nil))

(line-number-mode 1)
(column-number-mode 1)

;; scrolly stuff
;; http://emacs-fu.blogspot.com/2009/12/scrolling.html
(setq
 scroll-margin 0                  
 scroll-conservatively 100000
 scroll-preserve-screen-position 1)

(set-default-font "Envy Code R-10")

;; make shift arrows move between windows
;; http://justinsboringpage.blogspot.com/2009/09/directional-window-movement-in-emacs.html
(windmove-default-keybindings)

;; window resizing http://www.emacswiki.org/emacs/WindowResize
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; make printer work - http://www.emacswiki.org/emacs/CupsInEmacs
(setq lpr-command "kprinter")

;; xml indent
(defun indent-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n")
      )
    (mark-whole-buffer)
    (indent-region begin end)
    ;(indent-region point-min point-max)
    )
  (message "Ah, much better!"))


(fset 'indent-xml
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217848 109 97 114 tab 45 119 tab 104 tab return 134217848 105 110 100 101 tab 45 120 109 tab return] 0 "%d")) arg)))
(global-set-key '[(f9)]  'indent-xml)

;; bind M-n to next flymake error
;; inspired by http://www.emacswiki.org/emacs/FlyMake comments
(defun matt-next-flymake-err ()
  (interactive)
  (flymake-goto-next-error)
  (let ((err (get-char-property (point) 'help-echo)))
    (when err
      (message err)))
  )
(defun matt-prev-flymake-err ()
  (interactive)
  (flymake-goto-prev-error)
  (let ((err (get-char-property (point) 'help-echo)))
    (when err
      (message err)))
  )

(global-set-key "\M-n" 'matt-next-flymake-err)
(global-set-key "\M-p" 'matt-prev-flymake-err)

;; if compilation-shell-minor-mode is on, then these regexes
;; will make errors linkable
;; thanks Gerard Brunick
(defun matt-add-global-compilation-errors (list)
  (dolist (x list)
    (add-to-list 'compilation-error-regexp-alist (car x))
    (setq compilation-error-regexp-alist-alist
          (cons x
                (assq-delete-all (car x)
                                 compilation-error-regexp-alist-alist)))))
;; (matt-add-global-compilation-errors
;;  `(
;;    (matt-python ,(concat "^ *File \\(\"?\\)\\([^,\" \n    <>]+\\)\\1"
;;                         ", lines? \\([0-9]+\\)-?\\([0-9]+\\)?")
;;                2 (3 . 4) nil 2 2)
;;    (matt-pdb-stack ,(concat "^>?[[:space:]]*\\(\\([-_./a-zA-Z0-9 ]+\\)"
;;                            "(\\([0-9]+\\))\\)"
;;                            "[_a-zA-Z0-9]+()[[:space:]]*->")
;;                   2 3 nil 0 1)
;;    (matt-python-unittest-err "^  File \"\\([-_./a-zA-Z0-9 ]+\\)\", line \\([0-9]+\\).*" 1 2)
;;    )
 ;; We rule out filenames starting with < as these aren't files.
 ;;(pdb "^> *\\([^(< ][^(]*\\)(\\([0-9]+\\))" 1 2)
;; )

(defun matt-set-local-compilation-errors (errors)
  "Set the buffer local compilation errors.

Ensures than any symbols given are defined in
compilation-error-regexp-alist-alist."
  (dolist (e errors)
    (when (symbolp e)
      (unless (assoc e compilation-error-regexp-alist-alist)
        (error (concat "Error %s is not listed in "
                       "compilation-error-regexp-alist-alist")
               e))))
  (set (make-local-variable 'compilation-error-regexp-alist)
       errors))

(add-hook 'shell-mode-hook (lambda () (compilation-shell-minor-mode)))

;; from dimitri fontaine's blog
;; C-c . in org-mode
(defun insert-date ()
  "Insert a time-stamp according to locale's date and time format.\"
(interactive)
(insert (format-time-string "%a, %e %b %Y, %k:%M" (current-time)))'")

(defun darkroom-mode ()
	"Make things simple-looking by removing decoration 
and choosing a simple theme."
        (interactive)
        (setq left-margin 10)
        (menu-bar-mode -1)
        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (border-width . 0)
        (internal-border-width . 64)
        (auto-fill-mode 1))
;; need to toggle

;;
;; Use archive mode to open Python eggs
(add-to-list 'auto-mode-alist '("\\.egg\\'" . archive-mode))
(add-to-list 'auto-mode-alist '("\\.odp\\'" . archive-mode))
(add-to-list 'auto-mode-alist '("\\.otp\\'" . archive-mode))
;; also for .xo files (zip)
(add-to-list 'auto-mode-alist '("\\.xo\\'" . archive-mode))
;; google gadget
(add-to-list 'auto-mode-alist '("\\.gg\\'" . archive-mode))


;; from https://github.com/nflath/emacs-repos/blob/master/internal/python.el
(defun python-self-insert-command ()
  "Appends __ to the current word if it started with __."
  (interactive)
  (save-excursion
    (let ((cur (point)))
      (search-backward-regexp "[
\t .(-]\\|^" 0 t)
      (if (not (looking-at "^"))
          (forward-char 1))
      (if (looking-at "\\s\__")
          (setq my-temp-var t)
        (setq my-temp-var nil))))
  (save-excursion
    (when (> (point) 2)
      (backward-char 2)
      (if (looking-at "__")
          (setq my-temp-var nil))))
  (if my-temp-var (insert "__"))
  (self-insert-command 1))
(require 'python)
(define-key	python-mode-map (kbd ".")	'python-self-insert-command)
(define-key	python-mode-map (kbd "SPC")	'python-self-insert-command)
(define-key	python-mode-map (kbd "(")	'python-self-insert-command)


