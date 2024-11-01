(let ((default-directory  "~/.emacs.d/"))
  (normal-top-level-add-subdirs-to-load-path ))


(add-to-list 'load-path "~/.emacs.d/elpa")

;;needed for a bug when setting property (seems a 9.6 issue)


(load (expand-file-name "~/.emacs.d/ox-rss.el"))
(require 'org-loaddefs)
(require 'ox-publish)
(require 'citeproc)
(require 'oc-csl)

(setq org-cite-global-bibliography '("/home/britt/gitRepos/masterBib/britt.bib"))
(setq org-cite-export-processors '((csl "/home/britt/gitRepos/brittAnderson.github.io/raw/assets/chicago-note-bibliography-16th-edition.cls")))

(defun get-first-paragraph (fn)
  (with-temp-buffer
    (insert-file-contents fn)
    (goto-char (point-min))
    (kill-region 1 (search-forward "\n\n"))
    (forward-paragraph)
    (kill-region (point) (point-max))
    (buffer-string)))

;; In order to have a common navigation list at the top I add this to pages
;; via a function and file rather than just re-typing the string over and over. 
(setq brittgithub-header-file (expand-file-name "/home/britt/gitRepos/brittAnderson.github.io/raw/assets/html-preamble.html"))
(defun brittgithub-header (arg)
  (with-temp-buffer
    (insert-file-contents brittgithub-header-file)
    (buffer-string)))

(defun get-link (entries)
  (let ((fpths 
	 (mapcar #'(lambda (l) 
		     (with-temp-buffer
		       (insert (car l))
		       (org-mode)
		       (goto-char (point-min))
		       (org-element-link-parser)))
		 (cdr entries))))
    fpths))
	   
(defun test-sitemap (title my-list)
  (when (> (length my-list) 1)
    (with-temp-buffer
      (goto-char 1)
      (let* ((my-proj-plist (assoc "britt-blog-sitemap" org-publish-project-alist))
	     (bd (plist-get (cdr my-proj-plist) :base-directory))
	     (hl (plist-get (cdr (assoc "britt-blog-rss" org-publish-project-alist)) :html-link-home))
	     (fpths (get-link my-list)))
	(dolist (fp fpths)
	  (let* ((fn (plist-get (elt fp 1) :path))
		 (my-date (format-time-string (car org-time-stamp-formats) (org-publish-find-date fn my-proj-plist)))
		 (full-fn (expand-file-name fn bd)))
	    (insert (format "*  %s\n" (org-publish-find-title fn my-proj-plist)))
	    (insert (format ":PROPERTIES:\n:PUBDATE: %s\n:RSS_PERMALINK: %s\n:PERMALINK: %s\n:END:\n" my-date
(concat "posts/" (file-name-sans-extension fn) ".html") (concat (file-name-sans-extension full-fn) ".html")))
	    (insert (format "  - %s\n" my-date))
	    (insert (get-first-paragraph full-fn))
	    (insert (concat "#+begin_export html\n<a href=\"" (concat hl "/posts/" (file-name-sans-extension fn) ".html") "\">To Read More ...</a>\n#+end_export\n"))))
	(goto-char (point-min))
	(insert "#+OPTIONS: title:nil\n")
	(insert "#+TITLE: Blog - Britt Anderson's Personal Website\n")
	(insert "#+AUTHOR: Britt Anderson\n")
	(insert "#+EMAIL: britt@b3l.xyz\n")
	(buffer-string)))))

(setq org-publish-project-alist 
      '(
	("britt-blog-base"
	 :base-directory "~/gitRepos/brittAnderson.github.io/raw/"
	 :base-extension "org"
	 :publishing-directory "~/gitRepos/brittAnderson.github.io/docs/"
	 :recursive nil
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 :html-head nil
	 :html-preamble brittgithub-header
	 :with-author t
	 )
	("britt-blog-sitemap"
	 :base-directory "~/gitRepos/brittAnderson.github.io/raw/posts/"
	 :base-extension "org"
	 :publishing-directory "~/gitRepos/brittAnderson.github.io/docs/posts/"
	 :recursive nil
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 :auto-sitemap t
	 :html-preamble brittgithub-header
	 :sitemap-function test-sitemap
	 :sitemap-filename "sitemap.org"
	 :sitemap-title "Britt Anderson's Personal Web Log"
	 :sitemap-sort-files anti-chronologically
	 :exclude "theindex.org"
	 :makeindex t)
	("britt-blog-rss"
         :base-directory "~/gitRepos/brittAnderson.github.io/raw/posts/"
         :base-extension "org"
         :html-link-home "https://brittanderson.github.io"
         :html-link-use-abs-url t
         :rss-extension "xml"
         :publishing-directory "~/gitRepos/brittAnderson.github.io/docs/posts/"
         :publishing-function org-rss-publish-to-rss
         :section-numbers nil
         :exclude ".*"         
         :include ("sitemap.org")
         :table-of-contents nil
	 )
	("britt-blog-static"
	 :base-directory "~/gitRepos/brittAnderson.github.io/raw/"
	 :base-extension "css\\|jpg\\|pdf"
	 :publishing-directory "~/gitRepos/brittAnderson.github.io/docs/"
	 :recursive t
	 :publishing-function org-publish-attachment)
	("britt-blog-all" :components ("britt-blog-base" "britt-blog-sitemap" "britt-blog-static" "britt-blog-rss"))))

(setq org-export-with-broken-links t)
(setq org-fold-core-style  'overlay)
(org-publish "britt-blog-base" t)
(org-publish "britt-blog-sitemap" t)
(org-publish "britt-blog-static" t)
(org-publish "britt-blog-rss" t)
;(org-publish-all t)
(message (org-version))
(message "Done")

;; add in the css

