;; turn off early (like starter-kit)
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(set-default-font "Envy Code R-10")
;; (set-default-font "Inconsolata-8")

(add-to-list 'load-path "~/work/emacs/el-get")

;;(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(require 'el-get)

(setq my:el-get-packages
      '(
        escreen                ; screen for emacs, C-\ C-h
        switch-window          ; take over C-x o
        auto-complete
        full-ack
        minimap
        highlight-parentheses
        highlight-indentation
        rainbow-mode         ; pretty css colors, etc
        smooth-scrolling
        color-theme  ;; borked
        ;;python
	python-mode
        python-pep8
        virtualenv
        ;; this is for html mmm editing
        django-mode
        sudo-save
        undo-tree
	predictive
	magit))

(setq el-get-sources
      '(
        ;; (:name emacs-for-python
        ;;        :type git
        ;;        :url "git://github.com/gabrielelanaro/emacs-for-python.git"
        ;;        :load-path "."
        ;;        :post-init (lambda ()
        ;;                     (require 'epy-setup)
        ;;                     (require 'epy-python)
        ;;                     (require 'epy-completion))
        ;;        )

        (:name yasnippet
       :type svn
       :url "http://yasnippet.googlecode.com/svn/trunk/"
       :features yasnippet
       :post-init (lambda ()
		    (yas/initialize)
		    ;;(add-to-list 'yas/snippet-dirs (concat el-get-dir "yasnippet/snippets"))
		    (add-to-list 'yas/snippet-dirs "~/work/emacs/emacs-kicker/snippets")

		    (yas/reload-all)))
                                        ;yasnippet emacs-starter-kit python has these

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
                   (global-set-key [f6] 'point-stack-push)
                   (global-set-key [f7] 'point-stack-pop)
                   (global-set-key [f8] 'point-stack-forward-stack-pop)))

   (:name tango-theme
          :type git
	  :depends color-theme
          :url "https://github.com/mattharrison/emacs-tango-theme.git"
          :after (lambda () (if (eq window-system 'x)
				(color-theme-tango)

                        (if (not (window-system))
                            (color-theme-tty-dark))))
          :features tango-theme
          )
   ;; color-theme-solarized
   ;; (:name python
   ;;        :after (lambda ()
   ;; 		   (message "PYTHON@!")
   ;; 		   (add-hook 'python-mode-hook
   ;;                           (lambda ()

   ;;                             (define-key python-mode-map "\C-m" 'newline-and-indent)))))




   ;; (:name python
   ;; 	  :type git
   ;; 	  :url "https://github.com/fgallina/python.el.git"
   ;; 	  :require 'python)



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


   ;; trying out emacs-for-python virtualenv
   ;;mmm-mode
   (:name nxhtml
          :after (lambda() (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mumamo-mode)))
          )
   (:name pony-mode
          :type git
          :url "https://github.com/davidmiller/pony-mode.git"
	  :features pony-mode
          :after (lambda()
                   (add-to-list 'load-path (concat el-get-dir "pony-mode"))))
   ;; this is for django nav
   (:name django-mode2
          :type git
          :url "https://github.com/myfreeweb/django-mode.git"
          :after (lambda()
                   (require 'django-html-mode)
                   ;; (require 'django-mode)
                   (yas/load-directory "~/.emacs.d/el-get/django-mode2/snippets")
                   (add-to-list 'auto-mode-alist '("\\.djhtml$" . django-html-mode))))

   (:name nose
          :type git
          :url "https://github.com/mattharrison/nose.git"
          :after (lambda() ))

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
   (:name protbuf
          :type emacswiki
          :features protbuf)


   ;; javascript stuff
   ;; don't use yegge's use better indent version
   (:name js2-mode
       :type git
       :url "https://github.com/mooz/js2-mode.git"
       :compile "js2-mode.el"
       :post-init (lambda ()
                    (autoload 'js2-mode "js2-mode" nil t)))
   (:name writegood-mode
          :type git
          :url "https://github.com/bnbeckwith/writegood-mode.git"
          :features writegood-mode )
   (:name monky
	  :type git
	  :url "https://github.com/ananthakumaran/monky.git"
	  :features monky)
   (:name ace-jump-mode
	  :website "http://www.emacswiki.org/emacs/AceJump"
	  :description "a quick cursor location minor mode for emacs"
	  :type git
	  :url "https://github.com/winterTTr/ace-jump-mode")
   ))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

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


(setq matt-font-size 10)
(defun toggle-font-size (arg)
  "Toggle font size between 10 and 30 (or prefix variable)"
  (interactive "p")
  ;; make this use prefix arg someday...
  (message "raw prefix arg is %s" arg)
    (if (= matt-font-size 10)
	(setq matt-font-size 30)
      (setq matt-font-size 10))
      (set-default-font (format "Envy Code R-%d" matt-font-size))
      (redraw-display))
(global-set-key '[(f11)]  'toggle-font-size)


;; function keys
(global-set-key [f5] (lambda nil (interactive) (revert-buffer nil t t) (message (concat "Reverted buffer " (buffer-name)))))
(global-set-key [C-f6] 'bookmark-set)
(global-set-key [C-f7] 'bookmark-jump)
(global-set-key [C-f8] 'bookmark-bmenu-list)
(global-set-key [f12] (lambda () (interactive) (switch-to-buffer nil)))

;; change cursor on overwrite-mode
;; http://www.reddit.com/r/emacs/comments/ix6h8/what_do_you_guys_bind_your_functionkeypad_keys_to/
(setq default-cursor-type '(bar . 2))
(defadvice overwrite-mode (after overwrite-mode)
  (if overwrite-mode
      (setq cursor-type 'box)
    (setq cursor-type '(bar . 2))))
(ad-activate 'overwrite-mode)

;; get menu from 3rd mouse button
(global-set-key (kbd "<mouse-3>") 'mouse-major-mode-menu)
(global-set-key (kbd "<C-mouse-3>") 'mouse-popup-menubar)


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
(line-number-mode 1)
(column-number-mode 1)

;; scrolly stuff
;; http://emacs-fu.blogspot.com/2009/12/scrolling.html
(setq
 scroll-margin 0
 scroll-conservatively 100000
 scroll-preserve-screen-position 1)
;; scroll by line
(global-set-key (kbd "<M-up>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "<M-down>") (lambda () (interactive) (scroll-up 1)))

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
;; ;; We rule out filenames starting with < as these aren't files.
;; ;; (pdb "^> *\\([^(< ][^(]*\\)(\\([0-9]+\\))" 1 2)
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
        ;;(border-width . 0)
        ;;(internal-border-width . 64)
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


;; https://www.bunkus.org/blog/2009/12/switching-identifier-naming-style-between-camel-case-and-c-style-in-emacs/
(defun mo-toggle-identifier-naming-style ()
  "Toggles the symbol at point between C-style naming,
    e.g. `hello_world_string', and camel case,
    e.g. `HelloWorldString'."
  (interactive)
  (let* ((symbol-pos (bounds-of-thing-at-point 'symbol))
	 case-fold-search symbol-at-point cstyle regexp func)
    (unless symbol-pos
      (error "No symbol at point"))
    (save-excursion
      (narrow-to-region (car symbol-pos) (cdr symbol-pos))
      (setq cstyle (string-match-p "_" (buffer-string))
	    regexp (if cstyle "\\(?:\\_<\\|_\\)\\(\\w\\)" "\\([A-Z]\\)")
	    func (if cstyle
		     'capitalize
		   (lambda (s)
		     (concat (if (= (match-beginning 1)
				    (car symbol-pos))
				 ""
			       "_")
			     (downcase s)))))
      (goto-char (point-min))
      (while (re-search-forward regexp nil t)
	(replace-match (funcall func (match-string 1))
		       t nil))
      (widen))))

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

;; (load "~/.emacs.d/el-get/python/python.el")
;; (require 'python)
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil
		  tab-width 2)
            (hungry-delete-mode)
	    (define-key	python-mode-map (kbd ".")	'python-insert-end-dunder)
	    (define-key	python-mode-map (kbd "SPC")	'python-insert-end-dunder)
	    (define-key	python-mode-map (kbd "(")	'python-insert-end-dunder)
	    (define-key	python-mode-map	(kbd "C-;")	'python-insert-start-self)))

(defun virtualenv-activate (directory)
"Activate a venv directory (without virtualenv-wrapper)"
(interactive "DVirtualenv directory")
(let* ((virtualenv-workon-session (file-name-nondirectory (directory-file-name directory)))
      (virtualenv-root (file-name-directory (directory-file-name directory))))
      (virtualenv-workon)))

(defun python-venv-activate (directory)
  "Activate new python.el virtualenv"
  (interactive "DDirectory:")
  (let ((bin-dir (format "%sbin" directory)))
    (message directory)
    (message bin-dir)
    (setq python-shell-process-environment
          (list
           (format "PATH=%s" (mapconcat
                              'identity
                              (reverse
                               (cons (getenv "PATH")
                                     (list bin-dir)))
                              ":"))
           (format "VIRTUAL_ENV=%s" directory)))
    (setq python-shell-exec-path (list bin-dir))))

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

;; tango shell
;; http://tapoueh.org/blog/2011/07/29-emacs-ansi-colors.html
(setq ansi-color-names-vector
         (vector (frame-parameter nil 'background-color)
               "#f57900" "#8ae234" "#edd400" "#729fcf"
               "#ad7fa8" "cyan3" "#eeeeec")
         ansi-term-color-vector ansi-color-names-vector
         ansi-color-map (ansi-color-make-color-map))


;; make shell colors work
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; http://emacs-fu.blogspot.com/2009/11/making-buffer-names-unique.html
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator ":")


;; replace elisp with contents
;; http://stackoverflow.com/questions/3035337/in-emacs-can-you-evaluate-an-elisp-expression-and-replace-it-with-the-result
(defun replace-last-sexp ()
  (interactive)
  (let ((value (eval (preceding-sexp))))
    (kill-sexp -1)
    (insert (format "%s" value))))

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

;; C-x C-+ is normal
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-increase)
;; (global-set-key (kbd "C--") (lambda () (interactive) (text-scale-adjust -1)))
(global-set-key (kbd "C--") 'text-scale-decrease)

;; process to save a keyboard macro
;; record it using f3 and f4 (to signal start/stop)
;; C-x C-k n  Give a command name (for the duration of the Emacs session) to the most recently defined keyboard macro (kmacro-name-last-macro).
;;  M-x insert-kbd-macro <RET> macroname <RET>
;; not used but here for example
(fset 'rerun-pdb
      (lambda (&optional arg)
        "Goto next window.  Kill pdb (gud).  Start pdb and hit
        the c character to
        continue" (interactive "p") (kmacro-exec-ring-item (quote ([24
        111 24 98 103 117 100 return 24 107 return 134217848 112
        100 98 return return 99 return] 0 "%d")) arg)))


;; bind it to f11
;;(global-set-key '[(f11)]  'rerun-pdb)


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
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


;; shell customizations - http://snarfed.org/why_i_run_shells_inside_emacs
;;
;; (defvar my-shells
;;   '("*matt*" "*shell0*" "*shell1*" "*shell2*" "*music*"))

;; (custom-set-variables
;;  '(tramp-default-method "ssh")          ; uses ControlMaster
;;  '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
;;  '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
;;  '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
;;  ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
;;  '(comint-input-ignoredups t)           ; no duplicates in command history
;;  '(comint-completion-addsuffix t)       ; insert space/slash after file completion
;;  '(comint-buffer-maximum-size 100000)   ; max length of the buffer in lines
;;  '(comint-prompt-read-only nil)         ; if this is t, it breaks shell-command
;;  '(comint-get-old-input (lambda () "")) ; what to run when i press enter on a
;;                                         ; line above the current prompt
;;  '(comint-input-ring-size 5000)         ; max shell history size
;;  '(protect-buffer-bury-p nil)
;; )

;; (setenv "PAGER" "cat")

;; ;; truncate buffers continuously
;; (add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

;; (defun make-my-shell-output-read-only (text)
;;   "Add to comint-output-filter-functions to make stdout read only in my shells."
;;   (if (member (buffer-name) my-shells)
;;       (let ((inhibit-read-only t)
;;             (output-end (process-mark (get-buffer-process (current-buffer)))))
;;         (put-text-property comint-last-output-start output-end 'read-only t))))
;; (add-hook 'comint-output-filter-functions 'make-my-shell-output-read-only)

;; (defun dirtrack-mode-locally ()
;;   "Add to shell-mode-hook to use dirtrack mode in my local shell buffers."
;;   (when (member (buffer-name) (cdr my-shells))
;;     (dirtrack-mode t)
;;     (set-variable 'dirtrack-list '("^[A-Za-z0-9]+:\\([~/][^\\n>]*\\)>" 1 nil))))
;; (add-hook 'shell-mode-hook 'dirtrack-mode-locally)

;; ; interpret and use ansi color codes in shell output windows
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; (defun set-scroll-conservatively ()
;;   "Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
;;   (set (make-local-variable 'scroll-conservatively) 10))
;; (add-hook 'shell-mode-hook 'set-scroll-conservatively)

;; (defun unset-display-buffer-reuse-frames ()
;;   "Add to shell-mode-hook to prevent switching away from the shell buffer
;; when emacsclient opens a new buffer."
;;   (set (make-local-variable 'display-buffer-reuse-frames) t))
;; (add-hook 'shell-mode-hook 'unset-display-buffer-reuse-frames)

;; ;; make it harder to kill my shell buffers
;; (require 'protbuf)
;; (add-hook 'shell-mode-hook 'protect-buffer-from-kill-mode)

;; (defun make-comint-directory-tracking-work-remotely ()
;;   "Add this to comint-mode-hook to make directory tracking work
;; while sshed into a remote host, e.g. for remote shell buffers
;; started in tramp. (This is a bug fix backported from Emacs 24:
;; http://comments.gmane.org/gmane.emacs.bugs/39082"
;;   (set (make-local-variable 'comint-file-name-prefix)
;;        (or (file-remote-p default-directory) "")))
;; (add-hook 'comint-mode-hook 'make-comint-directory-tracking-work-remotely)

;; (defun comint-close-completions ()
;;   "Close close the comint completions buffer.
;; Used in advice to various comint functions to automatically close
;; the completions buffer as soon as I'm done with it. Based on
;; Dmitriy Igrishin <dmitigr@gmail.com>'s patched version of
;; comint.el."
;;   (if comint-dynamic-list-completions-config
;;       (progn
;;         (set-window-configuration comint-dynamic-list-completions-config)
;;         (setq comint-dynamic-list-completions-config nil))))

;; (defadvice comint-send-input (after close-completions activate)
;;   (comint-close-completions))

;; (defadvice comint-dynamic-complete-as-filename (after close-completions activate)
;;   (if ad-return-value (comint-close-completions)))

;; (defadvice comint-dynamic-simple-complete (after close-completions activate)
;;   (if (member ad-return-value '('sole 'shortest 'partial))
;;       (comint-close-completions)))

;; (defadvice comint-dynamic-list-completions (after close-completions activate)
;;     (comint-close-completions)
;;     (if (not unread-command-events)
;;         ;; comint's "Type space to flush" swallows space. put it back in.
;;         (setq unread-command-events (listify-key-sequence " "))))

;; (defun enter-again-if-enter ()
;;   "Make the return key select the current item in minibuf and shell history isearch.
;; An alternate approach would be after-advice on isearch-other-meta-char."
;;   (when (and (not isearch-mode-end-hook-quit)
;;              (equal (this-command-keys-vector) [13])) ; == return
;;     (cond ((active-minibuffer-window) (minibuffer-complete-and-exit))
;;           ((member (buffer-name) my-shells) (comint-send-input)))))
;; (add-hook 'isearch-mode-end-hook 'enter-again-if-enter)

;; (defadvice comint-previous-matching-input
;;     (around suppress-history-item-messages activate)
;;   "Suppress the annoying 'History item : NNN' messages from shell history isearch.
;; If this isn't enough, try the same thing with
;; comint-replace-by-expanded-history-before-point."
;;   (let ((old-message (symbol-function 'message)))
;;     (unwind-protect
;;       (progn (fset 'message 'ignore) ad-do-it)
;;     (fset 'message old-message))))



(put 'ido-exit-minibuffer 'disabled nil)
