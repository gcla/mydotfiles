(require 'package)
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives 
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives 
	     '("melpa-stable" . "http://stable.melpa.org/packages/") t)
;;(add-to-list 'package-archives
;;	     '("melpa-stable" . "http://stable.melpa.org/packages/")
;;	     t)

(setq package-enable-at-startup nil)
(package-initialize)

(use-package ensime
  :ensure t
  :pin melpa-stable)

(defvar gcla/packages
  '(all anything-complete anything-config anything-git auto-complete popup browse-kill-ring+ browse-kill-ring browse-kill-ring cmake-mode color-theme dictionary link connection egg emacs-eclim s popup dash ensime popup s dash company yasnippet sbt-mode scala-mode f dash s gccsense helm-ack helm helm-core async popup async helm-ag helm helm-core async popup async helm-anything anything helm helm-core async popup async helm-c-yasnippet yasnippet helm helm-core async popup async helm-cmd-t helm-delicious helm-descbinds helm helm-core async popup async helm-dired-recent-dirs helm helm-core async popup async helm-emmet emmet-mode helm helm-core async popup async helm-filesets filesets+ helm helm-core async popup async helm-flymake helm helm-core async popup async helm-gist gist gh marshal ht dash logito pcache dash s helm helm-core async popup async helm-git helm-git-grep helm-core async helm-go-package deferred go-mode helm helm-core async popup async helm-gtags helm helm-core async popup async helm-helm-commands helm helm-core async popup async helm-ls-git helm helm-core async popup async helm-ls-hg helm helm-core async popup async helm-make projectile pkg-info epl helm helm-core async popup async helm-migemo migemo helm-core async helm-open-github gh marshal ht dash logito pcache dash s helm-core async helm-orgcard helm-core async helm-project-persist project-persist helm helm-core async popup async helm-projectile projectile pkg-info epl helm helm-core async popup async helm-projectile-all s dash projectile pkg-info epl helm helm-core async popup async helm-rails inflections helm helm-core async popup async helm-rb helm-ag-r helm helm-core async popup async helm helm-core async popup async helm-recoll helm helm-core async popup async helm-rubygems-local helm helm-core async popup async helm-sheet helm helm-core async popup async helm-spaces spaces helm-core async helm-spotify multi helm helm-core async popup async helm-swoop helm helm-core async popup async helm-themes helm-core async icicles inflections link logito magit-annex magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-filenotify magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-find-file dash magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-gitflow magit-popup dash async magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-push-remote magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-tramp magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async marshal ht dash migemo mo-git-blame multi pcache popup project-persist projectile pkg-info epl protobuf-mode s sbt-mode scala-mode scala-mode2 spaces tabulated-list thrift uuidgen w3 with-editor dash async xml-rpc yasnippet))

(require 'cl-lib)

(defun gcla/install-packages ()
  "Ensure the packages I use are installed. See `gcla/packages'."
  (interactive)
  (let ((missing-packages (cl-remove-if #'package-installed-p gcla/packages)))
    (when missing-packages
      (message "Installing %d missing package(s)" (length missing-packages))
      (package-refresh-contents)
      (mapc #'package-install missing-packages))))

(defun gcla/ensime-reset ()
  (interactive)
  (ensime-shutdown)
  (ensime)
  )

(defun gcla/tmux-neww ()
  (interactive)
  (shell-command "tmux neww")
  )

(defun gcla/process-marked-files ()
  (interactive)
  (dolist (file (dired-get-marked-files))
    (find-file file)
    (eclim-java-import-organize)
    (save-buffer)
    ;;(kill-buffer nil)
    ))

(defmacro gcla/push-mark-first (fn)
  `(progn
     (push-mark)
     (,fn)))

;;(macroexpand (gcla/push-mark-first helm-git-grep))

;;(popup-menu* '("Foo" "Bar" "Baz"))
;; => "Baz" if you select Baz
(defun gcla/common-tasks ()
  (interactive)
  (require 'popup)
  (let ((task 
	 (popup-menu* 
	  (list
	   (popup-make-item "git grep at point")
	   (popup-make-item "git grep")
	   (popup-make-item "git ls-files")
	   (popup-make-item "eclim go to declaration")
	   (popup-make-item "eclim rename symbol")
	   (popup-make-item "eclim find refs")
	   (popup-make-item "git blame")
	   )
	  :margin-left 2 :margin-right 2 :isearch t :around t 
	  )))
    (cond
     ((equal task "git grep at point")
      (gcla/push-mark-first helm-git-grep-at-point))
     ((equal task "git grep")
      (gcla/push-mark-first helm-git-grep))
     ((equal task "git ls-files")
      (gcla/push-mark-first helm-ls-git-ls))
     ((equal task "eclim go to declaration")
      (gcla/push-mark-first eclim-java-find-declaration))
     ((equal task "eclim rename symbol")
      (eclim-java-refactor-rename-symbol-at-point))
     ((equal task "eclim find refs")
      (gcla/push-mark-first eclim-java-find-references))
     ((equal task "git blame")
      (mo-git-blame-current))
     )))


;;(t (message "uh oh")))))

;; https://stackoverflow.com/a/29757750/784226
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

;;(gcla/install-packages)


;;(package-initialize)

;;(modify-syntax-entry ?< "(>" c++-mode-syntax-table)
;;(modify-syntax-entry ?> "(<" c++-mode-syntax-table)

(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )

(defun gcla-helm-multi-all ()
  "multi-occur in all buffers backed by files."
  (interactive)
  (helm-multi-occur
   (delq nil
         (mapcar (lambda (b)
                   (when (buffer-file-name b) (buffer-name b)))
                 (buffer-list)))))

(defun goto-matching-paren-or-insert (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (if (= arg 1)
      (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
	        ((looking-at "[])}]") (forward-char) (backward-sexp 1))
		    (t (self-insert-command arg)))
    (self-insert-command 1)))

(defun term-handle-exit--close-buffer (&rest args)
  (when (null (get-buffer-process (current-buffer)))
    (insert "Press <C-d> to kill the buffer.")
    (use-local-map (let ((map (make-sparse-keymap)))
                     (define-key map (kbd "C-d")
                       (lambda ()
                         (interactive)
                         (kill-buffer (current-buffer))))
                     map))))
(advice-add 'term-handle-exit :after #'term-handle-exit--close-buffer)

(defun delete-char-or-kill-terminal-buffer (N &optional killflag)
  (interactive "p\nP")
  (if (string= (buffer-name) "*terminal*")
  (kill-buffer (current-buffer))
(delete-char N killflag)))

(global-set-key (kbd "C-d") 'delete-char-or-kill-terminal-buffer)

(defun gcla-mark-enclosed-region (arg)
  "Mark the maximal region inside closest outer set of brackets."
  (interactive "p")
  (backward-up-list 1)
  (forward-char)
  (set-mark (point))
  (backward-char)
  (goto-matching-paren-or-insert 1)
  )  

;; based on scottfrazer's code
(defun gcla/save-as-and-switch (filename)
  "Clone the current buffer and switch to the clone"
  (interactive "FCopy and switch to file: ")
  (save-restriction
    (widen)
    (write-region (point-min) (point-max) filename nil nil nil 'confirm))
  (find-file filename))

;; based on Chris McMahan's code
(defun gcla/save-as-but-do-not-switch (filename)
  "Clone the current buffer but don't switch to the clone"
  (interactive "FCopy (without switching) to file:")
  (write-region (point-min) (point-max) filename)
  (find-file-noselect filename))

;; My own function for combining the two above.
(defun gcla/save-as (filename)
  "Prompt user whether to switch to the clone."
  (interactive "FCopy to file: ")
  (if (y-or-n-p "Switch to new file?")
    (gcla/save-as-and-switch filename)
    (gcla/save-as-but-do-not-switch filename)))

(defun html-quote (start end &optional arg)
      "Quote html code in region for inclusion into other HTML.
    With optional argument ARG reverse operation.
    This applies to the region between START and END."
      (interactive "r\nP")
      (let ((commands (if arg
                          '(("&amp class=\"comment\">;" . "&")
                            ("&lt class=\"comment\">;" . "<")
                            ("&gt class=\"comment\">;" . ">"))
                        '(("&" . "&amp class=\"comment\">;")
                          ("<" . "&lt class=\"comment\">;")
                          (">" . "&gt class=\"comment\">;"))))
            (text (buffer-substring start end)))
        (with-temp-buffer
          (insert text)
          (while commands
            (let ((from-str (caar commands))
                  (to-str (cdar commands)))
              (goto-char (point-min))
              (while (search-forward from-str nil t)
                (replace-match to-str nil t)))
            (setq commands (cdr commands)))
          (setq text (buffer-substring (point-min) (point-max))))
        (kill-region start end)
        (goto-char start)
        (insert text)))

;; https://emacs.stackexchange.com/a/8167
(defun gcla/replace-symbols-with-entity-names (start end)
  (interactive "r")
  (let ((count (count-matches "&")))
    (replace-string "&" "&amp;" nil start end)
    (setq end (+ end (* count 4))))
  (dolist (pair web-mode-html-entities)
    (unless (= (cdr pair) 38)
      (let* ((str (char-to-string (cdr pair)))
              (count (count-matches str start end)))
        (setq end (+ end (* count (1+ (length (car pair))))))
        (replace-string str
          (concat "&" (car pair) ";")
          nil start end)))))

;; https://emacs.stackexchange.com/a/20038
(defun gcla/html-entity-encode (b e)
  (interactive "r")
  (call-process-region b e "recode" t t nil "..HTML_4.0"))

(defun gcla/html-entity-decode (b e)
  (interactive "r")
  (call-process-region b e "recode" t t nil "HTML_4.0.."))

(defvar bookmark-register 200
  "*Used for storing point")

(defun marker-is-point-p (marker)
  "test if marker is current point"
  (and (eq (marker-buffer marker) (current-buffer))
       (= (marker-position marker) (point))))

(defun push-mark-maybe () 
  "push mark onto `global-mark-ring' if mark head or tail is not current location"
  (interactive)
  (if (not global-mark-ring) (error "global-mark-ring empty")
    (unless (or (marker-is-point-p (car global-mark-ring))
                (marker-is-point-p (car (reverse global-mark-ring))))
      (progn
	(push-mark)
	(message "Stored point!"))
      )))

(defun backward-global-mark () 
  "use `pop-global-mark', pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark)
  (message "Restored point!")
  )

(defun forward-global-mark ()
  "hack `pop-global-mark' to go in reverse, pushing current point if not on ring."
  (interactive)
  (push-mark-maybe)
  (setq global-mark-ring (nreverse global-mark-ring))
  (when (marker-is-point-p (car global-mark-ring))
    (call-interactively 'pop-global-mark))
  (call-interactively 'pop-global-mark)
  (setq global-mark-ring (nreverse global-mark-ring))
  (message "Forward point!")   
  )

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

(defhydra hydra-launcher (:color blue :columns 2)
   "Launch"
   ("h" man "man")
   ("r" (browse-url "http://www.reddit.com/r/emacs/") "reddit")
   ("w" (browse-url "http://www.emacswiki.org/") "emacswiki")
   ("s" shell "shell")
   ("q" nil "cancel"))

(global-set-key (kbd "C-c r") 'hydra-launcher/body)

(defhydra gcla/projectile-popup (:color blue :columns 1)
   "Functions"
   ("p" (helm-projectile-switch-project) "switch projects")
   ("b" (helm-projectile-switch-to-buffer) "switch buffer")
   )

(defhydra gcla/hydra-popup (:color blue :columns 1)
   "Functions"
   ("g" (helm-git-grep-at-point) "git grep at point")
   ("l" (helm-ls-git-ls) "git ls-files")
   ("d" (go-guru-definition) "go guru definitions")
   ("c" (go-guru-callers) "go guru callers")
   ("f" (go-guru-referrers) "go guru referrers")
   ("i" (go-guru-implements) "go guru implements")
   ("r" (go-rename) "go rename")
   ("p" (gcla/projectile-popup/body) "switch projects")
   ("b" (magit-blame) "git blame")
   ("t" (compile "cd $(git rev-parse --show-toplevel) && make install && make test") "build and test")
   )

(global-set-key (kbd "C-c r") 'gcla/hydra-popup/body)
;;(global-set-key (kbd "f6") 'gcla/hydra-popup/body)


;;(define-key ctl-x-4-map "t" 'toggle-window-split)

;; (global-set-key [(control x) (f1)] 'point-stack-push)
;; (global-set-key [(f1)] 'point-stack-push)
;; (global-set-key [(kp_f1)] 'point-stack-push)
;; (global-set-key [(kp-f1)] 'point-stack-push)
;; (global-set-key [(kp_0)] 'point-stack-push)
;; (global-set-key [(kp-0)] 'point-stack-push)
;; (global-set-key [(control x) (f3)] 'point-stack-push)
;; (global-set-key [(f3)] 'point-stack-push)
;; (global-set-key [(kp_f3)] 'point-stack-push)
;; (global-set-key [(kp-f3)] 'point-stack-push)
;; (global-set-key [(kp_2)] 'point-stack-push)
;; (global-set-key [(kp-2)] 'point-stack-push)

;; (global-set-key [(control x) (f2)] 'point-stack-pop)
;; (global-set-key [(f2)] 'point-stack-pop)
;; (global-set-key [(kp_f2)] 'point-stack-pop)
;; (global-set-key [(kp-f2)] 'point-stack-pop)
;; (global-set-key [(kp_1)] 'point-stack-pop)
;; (global-set-key [(kp-1)] 'point-stack-pop)

(global-set-key [(control x) (f4)] 'gcla/tmux-neww)
(global-set-key [(f4)] 'gcla/tmux-neww)
(global-set-key [(kp_f4)] 'gcla/tmux-neww)
(global-set-key [(kp-f4)] 'gcla/tmux-neww)
(global-set-key [(kp_3)] 'gcla/tmux-neww)
(global-set-key [(kp-3)] 'gcla/tmux-neww)

(global-set-key [(control x) (f5)] 'company-complete-common)
(global-set-key [(f5)] 'company-complete-common)
(global-set-key [(kp_f5)] 'company-complete-common)
(global-set-key [(kp-f5)] 'company-complete-common)
(global-set-key [(kp_4)] 'company-complete-common)
(global-set-key [(kp-4)] 'company-complete-common)

(global-set-key [(control x) (f6)] 'gcla/hydra-popup/body)
(global-set-key [(f6)] 'gcla/hydra-popup/body)
(global-set-key [(kp_f6)] 'gcla/hydra-popup/body)
(global-set-key [(kp-f6)] 'gcla/hydra-popup/body)
(global-set-key [(kp_5)] 'gcla/hydra-popup/body)
(global-set-key [(kp-5)] 'gcla/hydra-popup/body)
;; (global-set-key [(control x) (f6)] 'gcla/common-tasks)
;; (global-set-key [(f6)] 'gcla/common-tasks)
;; (global-set-key [(kp_f6)] 'gcla/common-tasks)
;; (global-set-key [(kp-f6)] 'gcla/common-tasks)
;; (global-set-key [(kp_5)] 'gcla/common-tasks)
;; (global-set-key [(kp-5)] 'gcla/common-tasks)

(global-set-key [(control \\)] 'er/expand-region)

;; (global-set-key [(control x) (f3)] 'forward-global-mark)
;; (global-set-key [(f3)] 'forward-global-mark)
;; (global-set-key [(kp_f3)] 'forward-global-mark)
;; (global-set-key [(kp-f3)] 'forward-global-mark)
;; (global-set-key [(kp_2)] 'forward-global-mark)
;; (global-set-key [(kp-2)] 'forward-global-mark)

					;(global-set-key [M-left] (quote backward-global-mark))
;(global-set-key [M-right] (quote forward-global-mark))



(defvar gcla-buffer-bookmark nil)
(make-variable-buffer-local 'gcla-buffer-bookmark)


(defun store-point ()
  (interactive)
  (setq gcla-buffer-bookmark (point))
  (message "Stored point!")) 

(defun restore-point ()
  (interactive)
  (goto-char gcla-buffer-bookmark)
  (message "Restored point!")) 

(defun gcla-revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )

(require 'bs)
;;(require 'magit)
(load-file "~/emacs/emacs/xcscope.el")
(load-file "~/.emacs.d/helm-cscope.el")
(load-file "~/.emacs.d/helm-lacarte.el")
;(load-file "~/emacs/emacs/browse-kill-ring.el")
(load-file "~/emacs/emacs/egg/egg.el")
(load-file "~/emacs/emacs/egg/egg-grep.el")
;(load-file "~/emacs/emacs/mo-git-blame/mo-git-blame.el")

;; change magit diff colors
;; (eval-after-load 'magit
;;   '(progn
;;      (set-face-foreground 'magit-diff-add "green3")
;;      (set-face-foreground 'magit-diff-del "red3")
;;      (when (not window-system)
;;        (set-face-background 'magit-item-highlight "black"))))

;; http://stackoverflow.com/a/1242366/784226
(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun gcla-add-fileset-source-to-preferred-list (source)
  "Add a fileset to the preferred list for helm-for-files"
  (interactive "SSource: ")
  (setq helm-for-files-preferred-list
	(remove-duplicates (cons source helm-for-files-preferred-list))))

(defun gcla-remove-fileset-source-from-preferred-list (source)
  "Remove a fileset from the preferred list for helm-for-files"
  (interactive "SSource: ")
  (setq helm-for-files-preferred-list
	(delete source helm-for-files-preferred-list)))

(defun gcla/select-file ()
  "Run company-files."
  (interactive)
  (company-begin-backend 'company-files)
  )

;;(require 'helm-filesets)
;;(defvar gcla/helm-source-boost-156 (helm-make-source-filesets "boost 1.56"))


;; (defadvice gcla-find-file-advice (around find-file activate)
;;   "If prefix arg, use helm-ls-git-ls."
;;   (progn
;;     (message (format "cur arg is %s" current-prefix-arg))
;;     (if (not (eq current-prefix-arg nil))
;; 	ad-do-it
;;       (helm-ls-git-ls)))) 


;;(require 'anything-config)

(defun really-quit (arg) (interactive "p")
  (if (yes-or-no-p "Really quit? ") (save-buffers-kill-emacs) nil))

(defun my-get-source-directory (path)
  "Please implement me. Currently returns `path' inchanged."
  "/home/gcla/source/appid-1004-64")

(defvar my-anything-c-source-file-search
  '((name . "File Search")
    (init . (lambda ()
              (setq anything-default-directory
                    default-directory)))
    (candidates . (lambda ()
                    (let ((args
                           (format "'%s' \\( -path \\*/.svn \\) -prune -o -iregex '.*%s.*' -print"
                                   (my-get-source-directory anything-default-directory)
                                   anything-pattern)))
                    (start-process-shell-command "file-search-process" nil
                                   "find" args))))
    (type . file)
    (requires-pattern . 4)
    (delayed))
  "Source for searching matching files recursively.")

(defvar anything-c-source-git-project-files-cache nil "(path signature cached-buffer)")

(defvar anything-c-source-git-project-files
  '((name . "Files from Current GIT Project")
    (init . (lambda ()
              (let* ((top-dir (file-truename (magit-get-top-dir (if (buffer-file-name)
                                                                    (file-name-directory (buffer-file-name))
                                                                  default-directory))))
                     (default-directory top-dir)
                     (signature (magit-rev-parse "HEAD")))

                (unless (and anything-c-source-git-project-files-cache
                             (third anything-c-source-git-project-files-cache)
                             (equal (first anything-c-source-git-project-files-cache) top-dir)
                             (equal (second anything-c-source-git-project-files-cache) signature))
                  (if (third anything-c-source-git-project-files-cache)
                      (kill-buffer (third anything-c-source-git-project-files-cache)))
                  (setq anything-c-source-git-project-files-cache
                        (list top-dir
                              signature
                              (anything-candidate-buffer 'global)))
                  (with-current-buffer (third anything-c-source-git-project-files-cache)
                    (dolist (filename (mapcar (lambda (file) (concat default-directory file))
                                              (magit-git-lines "ls-files")))
		      ;;(if (string-match "\.cpp$|\.hpp$|\.c$|\.h$XEmacs\\|Lucid" filename)
		      (insert filename)
		      (newline))))
		;;)
                (anything-candidaate-buffer (third anything-c-source-git-project-files-cache)))))

    (type . file)
    (candidates-in-buffer)))

(setq anything-sources
      '(
	;;anything-c-source-buffers-list
	;;anything-c-source-recentf
	;;anything-c-source-files-in-current-dir+
	;;anything-c-source-git-project-files
	anything-c-source-recentf
	))

;;(load-file "~/emacs/helm-ls-git.el")

(defun helm-git-grep-process-short-name ()
  (helm-aif (helm-attr 'default-directory)
      (let ((default-directory it))
        (apply 'start-process "git-grep-process" nil
               "git" "--no-pager" "grep" "-n" "--no-color"
               (nbutlast
                (apply 'append
                       (mapcar
                        (lambda (x) (list "-e" x "--and"))
                        (split-string helm-pattern " +" t))))))
    '()))

(defvar helm-source-git-grep-cwd
  '((name . "Git Grep cwd")
    (init . (lambda () (helm-attrset
                        'default-directory
			(file-name-directory (buffer-file-name (current-buffer)))
			)))
    (default-directory . (file-name-directory (buffer-file-name (current-buffer))))
    (candidates-process . helm-git-grep-process-short-name)
    (type . file-line)
    (candidate-number-limit . 300)
    (requires-pattern . 3)
    ;;(recenter)
    (volatile)
    (delayed)))

(defun helm-git-grep-cwd ()
  "Helm git grep cwd"
  (interactive)
  (helm-other-buffer '(helm-source-git-grep-cwd)
   "*helm git grep cwd"))


(defun helm-do-grep-recursive (&optional non-recursive)
  "Like `helm-do-grep', but greps recursively by default."
  (interactive "P")
  (let* ((current-prefix-arg (not non-recursive))
         (helm-current-prefix-arg non-recursive))
    (call-interactively 'helm-do-grep)))

;; (with-eval-after-load 'ensime
;;   (unless (display-graphic-p)
;;     (setq ensime-sem-high-faces
;;           (assq-delete-all 'implicitConversion ensime-sem-high-faces))))

(require 'eclim)
;;(global-eclim-mode)
(require 'eclimd)

(defun my-java-mode-hook ()
    (eclim-mode t))

(add-hook 'java-mode-hook 'my-java-mode-hook)

(require 'company)
(require 'company-emacs-eclim)
(company-emacs-eclim-setup)
(global-company-mode t)

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.1)
(help-at-pt-set-timer)

;; regular auto-complete initialization
;;;;;;(require 'auto-complete-config)
;;(ac-config-default)

;; add the emacs-eclim source
;;;;;;(require 'ac-emacs-eclim)
;;(require 'ac-emacs-eclim-source)
;;;;;;(ac-emacs-eclim-config)

;; regular auto-complete initialization
;;(require 'auto-complete-config)
;;(ac-config-default)

;; add the emacs-eclim source
;;(require 'ac-emacs-eclim-source)
;;(ac-emacs-eclim-config)

;;(require 'company)
;;(require 'company-emacs-eclim)
;;(company-emacs-eclim-setup)
;;(global-company-mode t)

;;;; wiresdeep

(defun gcla/common-tasks ()
  (interactive)
  (require 'popup)
  (let ((task
         (popup-menu*
          (list
           (popup-make-item "git grep at point")
           (popup-make-item "git ls-files")
           (popup-make-item "go guru definitions")
           (popup-make-item "go guru callers")
           (popup-make-item "go guru referrers")
           (popup-make-item "go guru implements")
           (popup-make-item "go rename")
           (popup-make-item "switch project")
           (popup-make-item "git blame")
           (popup-make-item "build and test")
           (popup-make-item "open menu")
           )
          :margin-left 2 :margin-right 2 :isearch t :around t
          )))
    (cond
     ((equal task "git grep at point")
      (helm-git-grep-at-point))
     ((equal task "git ls-files")
      (helm-ls-git-ls))
     ((equal task "go guru definitions")
      (go-guru-definition))
     ((equal task "go guru callers")
      (go-guru-callers))
     ((equal task "go guru referrers")
      (go-guru-referrers))
     ((equal task "go guru implements")
      (call-interactively 'go-guru-implements))
     ((equal task "go rename")
      (call-interactively 'go-rename))
     ((equal task "switch project")
      (call-interactively 'helm-projectile-switch-project))
     ((equal task "git blame")
      (call-interactively 'mo-git-blame-current))
     ((equal task "build and test")
      (compile "cd $(git rev-parse --show-toplevel) && make install && make test"))
     ((equal task "open menu")
      (call-interactively 'menu-bar-open))
     )))

(setq compilation-scroll-output 'first-error)

;; (ac-define-source go
;;   '((candidates . ac-go-candidates)
;;     (candidate-face . ac-candidate-face)
;;     (selection-face . ac-selection-face)
;;     (document . ac-go-document)
;;     (action . ac-go-action)
;;     (prefix . ac-go-prefix)
;;     (requires . 0)
;;     (cache)))

(defun my-ac-golang-mode ()
  (setq ac-sources '
	(
	 ;;ac-source-filename
	 ;;ac-source-functions
	 ;;ac-source-yasnippet
	 ;;ac-source-variables
	 ;;ac-source-symbols

	 ;;ac-source-go
	 
	 ;;ac-source-golang
	 ;;ac-source-features
	 ;;ac-source-abbrev
	 ;;ac-source-words-in-same-mode-buffers
	 ;;ac-source-dictionary
	 )))

(add-hook 'go-mode-hook 'my-ac-golang-mode)

(add-hook 'go-mode-hook
          (lambda ()
            (setq tab-width 4)))

(add-hook 'go-mode-hook
          (lambda ()
            (local-set-key [(control c) (control c)] 'compile)))

(defun gcla/company-complete-go ()
  (interactive)
  (company-begin-backend 'company-go))

(defun complete-or-indent ()
  (interactive)
  (if (company-manual-begin)
      (company-complete-common)
    (indent-according-to-mode)))

(defun indent-or-complete ()
    (interactive)
    (if (looking-at "\\_>")
        (company-complete-common)
      (indent-according-to-mode)))

(setenv "GOPATH" "/home/gcla/go")

(add-to-list 'exec-path "/home/gcla/go/bin")

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           ;;"go build -v && go test -v && go vet"))
           "go build"))
  ; Godef jump key binding
  ;;(local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-.") 'go-guru-definition)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'go-mode-hook
      (lambda ()
        (set (make-local-variable 'company-backends) '(company-go company-files))
        (company-mode)))

;; (setq gofmt-command "goimports")
;; ;;(add-to-list 'load-path "/home/you/somewhere/emacs/")
;; (require 'go-mode-autoloads)
;; (add-hook 'before-save-hook 'gofmt-before-save)

(require 'company-go)
;; (global-set-key [(f4)] 'gcla/company-complete-go)
(global-set-key [(f6)] 'gcla/common-tasks)


;; https://txt.arboreus.com/2013/02/21/jedi.el-jump-to-definition-and-back.html
(defvar jedi:goto-stack '())
(defun jedi:jump-to-definition ()
  (interactive)
  (add-to-list 'jedi:goto-stack
               (list (buffer-name) (point)))
  (jedi:goto-definition))
(defun jedi:jump-back ()
  (interactive)
  (let ((p (pop jedi:goto-stack)))
    (if p (progn
            (switch-to-buffer (nth 0 p))
            (goto-char (nth 1 p))))))

;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; redefine jedi's C-. (jedi:goto-definition)
;; to remember position, and set C-, to jump back
(add-hook 'python-mode-hook
          '(lambda ()
             (local-set-key (kbd "M-.") 'jedi:jump-to-definition)
             (local-set-key (kbd "M-,") 'jedi:jump-back)
             (local-set-key (kbd "C-c d") 'jedi:show-doc)
             (local-set-key (kbd "C-<tab>") 'jedi:complete)))


;;;; end of wiresdeep


(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

;; inifinite loop :(
;; (add-hook 'python-mode-hook 'my/python-mode-hook)

;;(setq ensime-sem-high-faces

;;      '(ensime-sem-high-enabled-p nil
;;				  ;; disable semantic highlighting
;;				  ))

;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
;; gcla new
;;(require 'auto-complete-config)
;;(ac-config-default)

(setq ido-enable-flex-matching t)

;;(setq ido-everywhere t)
;;(ido-mode 1) 

;; (when (> emacs-major-version 23)
;;         (require 'package)
;;         (package-initialize)
;;         (add-to-list 'package-archives 
;;                      '("melpa" . "http://melpa.milkbox.net/packages/")
;;                      'APPEND))


;; for git commits
(add-hook 'text-mode-hook
          (lambda ()
            (set-fill-column 70)))

;; (setq helm-projectile-fuzzy-match nil)
(require 'helm-projectile)
(helm-projectile-on)

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
This command select between any bracket chars, not the inner text of a bracket. For example, if text is

 (a(b)c▮)

 the selected char is “c”, not “a(b)c”.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-12-18"
  (interactive)
  (let (
        ($skipChars
         (if (boundp 'xah-brackets)
             (concat "^\"" xah-brackets)
           "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"))
        $pos
        )
    (skip-chars-backward $skipChars)
    (setq $pos (point))
    (skip-chars-forward $skipChars)
    (set-mark $pos)))

(global-set-key [(control c) (L)] 'org-insert-link-global)
(global-set-key [(control c) (o)] 'org-open-at-point-global)

(global-set-key [(backtab) (L)] 'company-complete-common)

(global-set-key [(control x) (control c)] 'really-quit)
(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Makefile" . makefile-gmake-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.g4$" . antlr-mode) auto-mode-alist))

(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))

(global-set-key [(control x) (control o)] 'ff-find-other-file)
;;(global-set-key [(control x) (control b)] 'bs-show)
(global-set-key [(control x) (control b)] 'helm-buffers-list)
(global-set-key [ ?% ] 'goto-matching-paren-or-insert)
(global-set-key [(control x) (control g)] 'helm-for-files)

(global-set-key [(control x) (f1)] 'store-point)
(global-set-key [(f1)] 'store-point)
(global-set-key [(kp_f1)] 'store-point)
(global-set-key [(kp-f1)] 'store-point)
(global-set-key [(kp_0)] 'store-point)
(global-set-key [(kp-0)] 'store-point)

(global-set-key [(control x) (f3)] 'store-point)
(global-set-key [(f3)] 'store-point)
(global-set-key [(kp_f3)] 'store-point)
(global-set-key [(kp-f3)] 'store-point)
(global-set-key [(kp_2)] 'store-point)
(global-set-key [(kp-2)] 'store-point)

(global-set-key [(control x) (f2)] 'restore-point)
(global-set-key [(f2)] 'restore-point)
(global-set-key [(kp_f2)] 'restore-point)
(global-set-key [(kp-f2)] 'restore-point)
(global-set-key [(kp_1)] 'restore-point)
(global-set-key [(kp-1)] 'restore-point)

(global-set-key [(control x) (control o)] 'ff-find-other-file)

(global-set-key [(f9)] 'gcla-mark-enclosed-region)
;;(global-set-key [(f7)] 'egg-grep)
(global-set-key [(f7)] 'gcla/select-file)
(global-set-key [(f8)] 'magit-status)
(global-set-key [(f10)] 'helm-resume)
(global-set-key [(f11)] 'helm-git-grep-at-point)

(defun gcla/backward-copy-word ()
  (interactive)
  (save-excursion
    (copy-region-as-kill (point) (progn (backward-word) (point)))))

(defun gcla/helm-git-grep-submodule-parent ()
  (interactive)
  (save-excursion
    (let ((word (thing-at-point 'word)))
      (progn
	(dired "/home/gcla/bigdisk/netsight-811/")
	(helm-git-grep-1 word)))))

(global-set-key (kbd "ESC <f11>") 'gcla/helm-git-grep-submodule-parent)

;;(global-set-key [(control x) (control b)] 'bs-show)

(add-hook 'python-mode-hook (function cscope:hook))

;; '(url-proxy-services (quote (("https" . "proxyserver.enterasys.com:80") ("http" . "proxyserver.enterasys.com:80")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-menu-height 25)
 '(column-number-mode t)
 '(company-go-show-annotation t)
 '(company-minimum-prefix-length 1)
 '(company-tooltip-limit 25)
 '(compilation-scroll-output (quote first-error))
 '(cscope-program "/home/gcla/bin/cscope-noerr")
 '(cscope-use-relative-paths nil)
 '(desktop-save-mode t)
 '(display-time-mode t nil (time))
 '(eclim-eclipse-dirs (quote ("/home/gcla/eclipse/")))
 '(eclim-executable "/home/gcla/eclipse/eclim")
 '(eclimd-default-workspace "~/workspace-gcp")
 '(ediff-diff-options "-w")
 '(filesets-data
   (quote
    (("boost 1.56"
      (:tree "/home/gcla/bigdisk/boost_1_56_0" "")))))
 '(fill-column 150)
 '(google-translate-default-target-language "en")
 '(gud-gdb-command-name "/opt/gdb8/bin/gdb -i=mi")
 '(helm-ack-use-ack-grep t)
 '(helm-always-two-windows t)
 '(helm-boring-buffer-regexp-list
   (quote
    ("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf" "\\*")))
 '(helm-buffer-max-length 40)
 '(helm-for-files-preferred-list
   (quote
    (helm-source-ls-git helm-source-buffers-list helm-source-recentf helm-source-bookmarks helm-source-file-cache helm-source-files-in-current-dir helm-source-locate)))
 '(helm-git-grep-candidate-number-limit 1000)
 '(helm-git-grep-max-length-history 1000)
 '(helm-locate-command "locate %s -e --regex %s")
 '(helm-never-delay-on-input nil)
 '(helm-source-projectile-projects-actions
   (quote
    (("Open project root in vc-dir or magit `M-g'" . helm-projectile-vc)
     ("Switch to project" .
      #[257 "\301\302!)\207"
	    [projectile-completion-system helm projectile-switch-project-by-name]
	    3 "

(fn PROJECT)"])
     ("Open Dired in project's directory `C-d'" . dired)
     ("Switch to Eshell `M-e'" . helm-projectile-switch-to-eshell)
     ("Grep in projects `C-s'" . helm-projectile-grep)
     ("Compile project `M-c'. With C-u, new compile command" . helm-projectile-compile-project)
     ("Remove project(s) from project list `M-D'" . helm-projectile-remove-known-project))))
 '(idle-highlight-idle-time 2.0)
 '(jedi:environment-root "wiresdeepenv3")
 '(jedi:install-python-jedi-dev-command
   (quote
    ("pip" "install" "--index-url=https://pypi.python.org/simple/" "--upgrade" "git+https://github.com/davidhalter/jedi.git@dev#egg=jedi")))
 '(magit-diff-options nil)
 '(magit-item-highlight-face nil)
 '(magit-log-arguments (quote ("--graph" "--decorate" "--follow" "-n256")))
 '(magit-popup-use-prefix-argument (quote default))
 '(mo-git-blame-git-blame-args "-w")
 '(mo-git-blame-use-magit (quote if-available))
 '(org-agenda-tags-column -100)
 '(org-drawers (quote ("PROPERTIES" "CLOCK" "HIDEME")))
 '(org-hide-leading-stars t)
 '(org-odd-levels-only t)
 '(org-startup-folded t)
 '(org-tags-column 100)
 '(org-todo-keyword-faces (quote (("CANCELLED" . "ForestGreen"))))
 '(org-todo-keywords
   (quote
    ((sequence "TODO" "STARTED" "WAITING" "CANCELLED" "DONE"))))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(package-selected-packages
   (quote
    (jedi pyvenv virtualenv virtualenvwrapper hydra realgud dired-collapse dired-dups json-navigator toml toml-mode highlight-symbol idle-highlight-mode company-quickhelp counsel which-key fuff define-word google-translate company-jedi company-go imenu-anywhere expand-region aggressive-indent ag clang-format xref-js2 company-tern tern jss websocket ace-isearch ace-jump-helm-line ace-jump-mode ace-popup-menu java-snippets helm-commandlinefu helm-company yasnippet-snippets discover discover-js2-refactor js2-highlight-vars js2-refactor js2-mode web-mode web-mode-edit-element multiple-cursors org-projectile projectile popup-imenu ant markdown-mode go-autocomplete go-direx go-dlv gore-mode go-snippets go-rename go-mode go-guru yaml-mode use-package popup lacarte string-inflection ac-emacs-eclim company-emacs-eclim eclim helm-git-files list-processes+ scala-mode thrift ensime icicles emacs-eclim sbt-mode scala-mode2 magit xml-rpc w3 uuidgen tabulated-list protobuf-mode mo-git-blame magit-tramp magit-push-remote magit-popup magit-gitflow magit-find-file magit-filenotify magit-annex json helm-themes helm-swoop helm-spotify helm-spaces helm-sheet helm-rubygems-local helm-recoll helm-rb helm-rails helm-projectile-all helm-projectile helm-project-persist helm-orgcard helm-open-github helm-migemo helm-make helm-ls-hg helm-ls-git helm-helm-commands helm-gtags helm-go-package helm-git-grep helm-git helm-gist helm-flymake helm-filesets helm-emmet helm-dired-recent-dirs helm-descbinds helm-delicious helm-cmd-t helm-c-yasnippet helm-anything helm-ag helm-ack git-commit gccsense f egg dictionary color-theme cmake-mode browse-kill-ring+ auto-complete anything-git anything-config anything-complete all)))
 '(pgg-default-user-id "gcla@yahoo.com")
 '(realgud:gdb-command-name "/opt/gdb-7.9.1/bin/gdb")
 '(safe-local-variable-values
   (quote
    ((sh-indent-comment . t)
     (eval orgstruct-mode)
     (eval orgstruct++-mode))))
 '(transient-mark-mode t)
 '(truncate-lines nil)
 '(url-proxy-services nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ensime-implicit-highlight ((t (:underline nil))))
 '(helm-selection ((t (:background "#222222" :underline t))))
 '(magit-item-highlight ((t nil))))
(put 'narrow-to-region 'disabled nil)
