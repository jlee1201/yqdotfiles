
;;; Code:
;; Get current system's name
(defun my-insert-system-name()
  (interactive)
  "Get current system's name"
  (insert (format "%s" system-name))
  )

;; Get current system type
(defun my-insert-system-type()
  (interactive)
  "Get current system type"
  (insert (format "%s" system-type))
  )

;; Check if system is Darwin/Mac OS X
(defun my-system-type-is-darwin ()
  "Return true if system is darwin-based (Mac OS X)"
  (string-equal system-type "darwin")
  )

;; Check if system is Microsoft Windows
(defun my-system-type-is-windows ()
  "Return true if system is Windows-based (at least up to Win7)"
  (string-equal system-type "windows-nt")
  )

(when (my-system-type-is-darwin)
  (defun locate-make-mdfind-command-line (search-string)
    (list "mdfind" (concat "kMDItemDisplayName=*" search-string "*")))
  (defun spotlight ()
    "Search for files by name using spotlight"
    (interactive)
    (let ((locate-command "mdfind")
          (locate-make-command-line 'locate-make-mdfind-command-line))
      (call-interactively 'locate nil)))
  (defun spotlight-full ()
    "Search using spotlight"
    (interactive)
    (let ((locate-command "mdfind"))
      (call-interactively 'locate nil)))
  )
;; http://www.wilfred.me.uk/.emacs.d/init.html#org1752acf
(defun yq/start-scratch-html-file (file-name)
  "Create a test HTML file in ~/Downloads/scratch/FILE-NAME to play around with."
  (interactive "sName of scratch HTML file: ")
  (yq/start-scratch-file (format "%s.html" file-name))
  (erase-buffer)
  (insert "<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">
        <title>
        </title>
        <style type=\"text/css\">
        </style>
    </head>
    <body>

    </body>
</html>")
  (forward-line -2)
  (move-end-of-line nil))

(defun start--file (path)
  "Create a file at PATH, creating any containing directories as necessary.
Visit the file after creation."
  (make-directory (file-name-directory path) t)
  (find-file path))

(defun yq/start-scratch-file (file-name)
  "Create a file in ~/scratch for the given FILE-NAME."
  (interactive "sName of scratch file: ")
  (start--file (expand-file-name (format "~Downloads/scratch/%s" file-name))))

(defun ivy-insert-org-entity ()
  "Insert an org-entity using ivy."
  (interactive)
  (ivy-read "Entity: " (loop for element in (append org-entities org-entities-user)
                             when (not (stringp element))
                             collect
                             (cons
                              (format "%10s | %s | %s | %s"
                                      (car element) ;name
                                      (nth 1 element) ; latex
                                      (nth 3 element) ; html
                                      (nth 6 element)) ;utf-8
                              element))
            :require-match t
            :action '(1
                      ("u" (lambda (element) (insert (nth 6 (cdr element)))) "utf-8")
                      ("o" (lambda (element) (insert "\\" (cadr element))) "org-entity")
                      ("l" (lambda (element) (insert (nth 1 (cdr element)))) "latex")
                      ("h" (lambda (element) (insert (nth 3 (cdr element)))) "html"))))

(defun duplicate-line ()
  "Duplicate current line."
  (interactive)
  (kill-whole-line)
  (yank)
  (yank))

(defun untabify-all ()
  "Untabify the current buffer, unless `untabify-this-buffer' is nil."
  (interactive)
  (untabify (point-min) (point-max)))

(define-key global-map (kbd "H-i") 'open-terminal-here)
(defun open-terminal-here ()
  (interactive)
  (shell-command "open -a iTerm ."))

(defvar snwob-starting-window-or-buffer nil)

(defun snwob-single-buffer-p ()
  "Return non-nil if the current frame has one buffer only."
  (null (cdr (buffer-list (selected-frame)))))

(defun snwob-single-frame-p ()
  "Return non-nil if the selected frame is the only one."
  (null (cdr (frame-list))))

(defun snwob--current-window-or-buffer ()
  "Return the current buffer if there is a single window.
Otherwise, return the selected window."
  (if (one-window-p)
    (current-buffer)
  (selected-window)))

(defun yqrashawn-copy-file-name-to-clipboard ()
  "Put the current file name into the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))
