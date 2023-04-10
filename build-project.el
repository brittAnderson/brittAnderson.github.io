(let ((default-directory  "~/.emacs.d/straight/build/"))
  (normal-top-level-add-subdirs-to-load-path ))


(add-to-list 'load-path "~/.emacs.d/straight/repos/org/lisp")

;;needed for a bug when setting property (seems a 9.6 issue)


(load (expand-file-name "~/.emacs.d/ox-rss.el"))
(require 'org-loaddefs)
(require 'ox-publish)
(require 'citeproc)
(require 'oc-csl)

(setq org-cite-global-bibliography '("/home/britt/gitRepos/masterBib/britt.bib"))
(setq org-cite-export-processors '((csl "/home/britt/gitRepos/brittAnderson.github.io/raw/assets/chicago-note-bibliography-16th-edition.cls")))

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
	     (fpths (get-link my-list)))
	(dolist (fp fpths)
	  (insert "\n")
	  (let* ((fn (plist-get (elt fp 1) :path))
		 (my-date (format-time-string (car org-time-stamp-formats) (org-publish-find-date fn my-proj-plist)))
		 (full-fn (expand-file-name fn bd)))
	    (insert (format "* [[file:%s][%s]]\n" full-fn (org-publish-find-title fn my-proj-plist)))
	    (insert (format ":PROPERTIES:\n:PUBDATE: %s 
:RSS_PERMALINK: %s\n:END:\n" my-date (concat (file-name-sans-extension full-fn) ".html")))))
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
	 :html-head    "<link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/css/tufte.css\" />"
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
	 :sitemap-function test-sitemap
	 :sitemap-filename "sitemap.org"
	 :sitemap-title "Britt Anderson's Personal Web Log"
	 :sitemap-sort-files anti-chronologically)
	("britt-blog-rss"
         :base-directory "~/gitRepos/brittAnderson.github.io/raw/posts/"
         :base-extension "org"
         :html-link-home "https://brittanderson.github.io"
         :html-link-use-abs-url t
         :rss-extension "xml"
	 :html-link-home "https://brittAnderson.github.io/"
         :publishing-directory "~/gitRepos/brittAnderson.github.io/docs/"
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

(setq org-fold-core-style  'overlay)
;(org-publish "britt-blog-sitemap" t)
;(org-publish "britt-blog-rss" t)
(org-publish-all t)
(message (org-version))
(message "Done")

;; add in the css
;; fix the date format
;; fix the link in xml output
;; add the blurb
;; make sure antichronological formatting