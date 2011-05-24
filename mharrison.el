;; turn off early (like starter-kit)
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(set-default-font "Envy Code R-10")


(add-to-list 'load-path "~/work/emacs/el-get")

(require 'el-get)
(setq
 el-get-sources
 '(el-get
   escreen                ; screen for emacs, C-\ C-h
   switch-window          ; take over C-x o
   auto-complete
   (:name yasnippet
       :type svn
       :url "http://yasnippet.googlecode.com/svn/trunk/"
       :features yasnippet
       :post-init (lambda ()
		    (yas/initialize)
		    (add-to-list 'yas/snippet-dirs (concat el-get-dir "yasnippet/snippets"))
		    (add-to-list 'yas/snippet-dirs "~/work/python/emacs-for-python/extensions/yasnippet/snippets")

		    (yas/reload-all)))
                                        ;yasnippet emacs-starter-kit python has these
   full-ack
   minimap
   highlight-parentheses
   highlight-indentation
   (:name hungry-delete
          :type git
          :url "https://github.com/nflath/hungry-delete.git"
          :features hungry-delete
          ;;:require 'hungry-delete
          ;; :after (lambda ()
          ;;          (turn-on-hungry-delete-mode))
    )
   (:name pycoverage
          :type git
          :url "https://github.com/mattharrison/pycoverage.el.git"
   	  :features pycov2)
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
   rainbow-mode         ; pretty css colors, etc
   smooth-scrolling
   ;; (:name rainbow-delimiters  ;; borked
   ;;        :type http
   ;;        :url "http://www.emacswiki.org/emacs/download/rainbow-delimiters.el"
   ;;        :features rainbow-delimiters)

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
   color-theme
   (:name tango-theme
          :type git
          :url "https://github.com/mattharrison/emacs-tango-theme.git"
          :after (lambda () (if (eq window-system 'x)
                            (color-theme-tango)

                        (if (not (window-system))
                            (color-theme-tty-dark))))
          :features tango-theme
          )

   (:name emacs-for-python
       :type git
       :url "git://github.com/gabrielelanaro/emacs-for-python.git"
       :load-path "."
       :post-init (lambda ()
   		    (require 'epy-setup)
   		    (require 'epy-python)
   		    (require 'epy-completion))
       )
   ;; (:name python
   ;;        :after (lambda ()
   ;; 		   (message "PYTHON@!")
   ;; 		   (add-hook 'python-mode-hook
   ;;                           (lambda ()

   ;;                             (define-key python-mode-map "\C-m" 'newline-and-indent)))))

   ;;python-mode
   python

   ;; (:name python
   ;; 	  :type git
   ;; 	  :url "https://github.com/fgallina/python.el.git"
   ;; 	  :require 'python)


   python-pep8
   (:name flymake-python
   	  :type git
   	  :url "https://github.com/mattharrison/flymake-python.git"
   	  :after (lambda ()
   		   (add-hook 'find-file-hook 'flymake-find-file-hook)
   		   (when (load "flymake" t)
   		     (defun flymake-pylint-init ()
   		       (let* ((temp-file (flymake-init-create-temp-buffer-copy
   					  'flymake-create-temp-inplace))
   			      (local-file (file-relative-name
   					   temp-file
   					   (file-name-directory buffer-file-name))))
   			 (list "~/.emacs.d/el-get/flymake-python/pyflymake.py" (list local-file))))
   		     ;;     check path
   		     (add-to-list 'flymake-allowed-file-name-masks
   				  '("\\.py\\'" flymake-pylint-init))))
   	  )

   virtualenv
   ;;mmm-mode
   (:name nxhtml
          :after (lambda() (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mumamo-mode)))
          )
   ;; this is for html mmm editing
   django-mode
   ;; this is for django nav
   (:name django-mode2
          :type git
          :url "https://github.com/myfreeweb/django-mode.git"
          :after (lambda()
                   (require 'django-html-mode)
                   ;; (require 'django-mode)
                   (yas/load-directory "~/.emacs.d/el-get/django-mode2/snippets")
                   (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mode))))
   sudo-save
   undo-tree
   (:name perspective
          :type git
          :url "https://github.com/nex3/perspective-el.git"
          )
   (:name sr-speedbar
          :type emacswiki)
   (:name idle-highlight-mode
          :type git
          :url "https://github.com/emacsmirror/idle-highlight-mode.git"
          )

   ;; javascript stuff
   ;; don't use yegge's use better indent version
   (:name js2-mode
       :type git
       :url "https://github.com/mooz/js2-mode.git"
       :compile "js2-mode.el"
       :post-init (lambda ()
                    (autoload 'js2-mode "js2-mode" nil t)))


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

;; (add-to-list 'load-path "~/.emacs.d/el-get/python")
;; (require 'python)


;; from https://github.com/nflath/emacs-repos/blob/master/internal/python.el
(defun python-insert-end-dunder ()
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

(defun python-insert-start-self ()
  "Insert self. at the beginning of the current word."
  (interactive)
  (save-excursion
    (search-backward-regexp
     "[
 \t,(-]\\|^")
    (if (not (looking-at "^"))
        (forward-char))
    (insert "self.")))

(load "~/.emacs.d/el-get/python/python.el")
(require 'python)
(add-hook 'python-mode-hook
	  (lambda ()
            (hungry-delete-mode)
	    (define-key	python-mode-map (kbd ".")	'python-insert-end-dunder)
	    (define-key	python-mode-map (kbd "SPC")	'python-insert-end-dunder)
	    (define-key	python-mode-map (kbd "(")	'python-insert-end-dunder)
	    (define-key	python-mode-map	(kbd "C-;")	'python-insert-start-self)))


;; make backward delete whitespace hungry
;; (custom-set-variables
;;  '(backward-delete-char-untabify-method 'all))
;; use M-\ for forward hungry delete

;; Kill trailing whitespace
(add-hook 'before-save-hook (lambda () (delete-trailing-whitespace)))

;; centralize backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;;
;; kill ping while C-x C-f (emacs-starter-kit issue #39)
(setq ffap-machine-p-known 'reject)


;; starter-kit copies
(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'ansi-color)
(require 'recentf)

;; make shell colors work
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; http://emacs-fu.blogspot.com/2009/11/making-buffer-names-unique.html
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")

;; coda swap  http://en.myfreeweb.ru/coda-like-swapping-in-emacs
(defun coda-swap (expr)
  (interactive "sExpr: ")
  (query-replace-regexp
   (replace-regexp-in-string "$[1-2]" "\\\\([0-9a-zA-Z]*\\\\)" expr)
   (replace-regexp-in-string "$[1-2]" (lambda (m) (if (equal m "$1") "\\\\2" "\\\\1")) expr)))

;; Example:
; enter
; width="$1" height="$2"
; and it will replace
; width="240" height="320"
; with
; width="320" height="240"

;; from https://github.com/myfreeweb/emacs/blob/master/useful-stuff.el
;;; FIXME/TODO/BUG/XXX highlight
(defun markers-hl ()
  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|TODO\\|BUG\\|XXX\\):" 1 font-lock-warning-face t))))
(add-hook 'python-mode-hook 'markers-hl)
(add-hook 'ruby-mode-hook 'markers-hl)
(add-hook 'perl-mode-hook 'markers-hl)
(add-hook 'js-mode-hook 'markers-hl)
(add-hook 'css-mode-hook 'markers-hl)
(add-hook 'coffee-mode-hook 'markers-hl)
(add-hook 'nxml-mode-hook 'markers-hl)