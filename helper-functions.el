(defun get-post-metadata ()
  (goto-char (point-min))
  (let ((meta-data '((:reg ?t :search-for "#+title: " :start "**  ")
		     (:reg ?d :search-for "#+date: "  :start "Date: ")
		     (:reg ?a :search-for "#+author: " :start "Author: "))))
    (dolist (md meta-data)
      (set-register (plist-get md ':reg) (plist-get md ':start))
      (append-to-register (plist-get md ':reg) (goto-char (search-forward (plist-get md ':search-for))) (line-end-position)))
    (forward-paragraph)
    (copy-to-register ?s (point) (progn
				   (forward-paragraph)
				   (point)))))

(defun put-post-metadata (fn)
  (let ((reg-list '(?t ?d ?a ?s)))
    (dolist (r reg-list)
      (insert-register r t)
      (insert "\n"))
    (insert (format "[[%s][%s]] \n\n" fn "read full entry"))))

(defun get-post-list (post-dir n-posts)
  (setq ps (directory-files post-dir t "[0-9]\\{4\\}.*[org]$"))
  (setq most-recent (nreverse (last ps n-posts)))
  most-recent)

(defun erase-recent-posts ()
  (goto-char (point-min))
  (search-forward "Recent Posts")
  (let ((begin-posts (point))
	(end-posts (progn (search-forward "Older Posts")
			  (beginning-of-line)
			  (point))))
    (delete-region begin-posts end-posts)
    (insert "\n\n")))

(defun insert-recent-posts (list-post-files)
  (dolist (p (nreverse list-post-files))
    (with-temp-buffer
      (insert-file-contents p)
      (goto-char (point-min))
      (get-post-metadata))
    (goto-char (point-min))
    (search-forward "Recent Posts")
    (forward-line)
    (put-post-metadata p)))

(defun clean-and-refresh-new-posts (pd np)
  (goto-char (point-min))
  (erase-recent-posts)
  (let ((list-recent-posts (get-post-list pd np)))
    (insert-recent-posts list-recent-posts)))
