#lang racket
(require racket/path)

(define (read-write-file-by-line file-port-in file-port-out)
  (let ((line (read-line file-port-in 'any)))
    (unless (eof-object? line)
      (display (string-append line "\n") file-port-out)
      (read-write-file-by-line file-port-in file-port-out))))
      
(define mycwd (current-directory))
(define dpd "/home/britt/progLang/racket/detectress-pollen/")
(define suffix ".md")
(current-directory "/home/britt/gitRepos/detectress/chaps")
(define dl (directory-list))
(define tex-files (filter (lambda (fn) (regexp-match? #rx"(?<!_).tex" fn)) dl))
(define md-files (for/list ([fn tex-files]) (path->string (path-replace-extension fn ".md"))))
(for ([fn tex-files]) (let ([out-name-md (string-append dpd (path->string (path-replace-extension fn ".md")))]
                            [out-port-pmd (open-output-file (string-append dpd (path->string (path-replace-extension fn ".pmd"))) #:mode 'text #:exists 'replace)])
                        (displayln out-name-md)
                        (define-values (sp a b c) (subprocess #f #f #f "/home/britt/.cabal/bin/pandoc"
                                    (path->string fn) "--atx-headers" "--wrap" "none" "--to" "markdown_strict" "-o" out-name-md))
                        (subprocess-wait sp)
                        (flush-output)
                        (close-input-port a)
                        (close-output-port b)
                        (close-input-port c)
                        (display "#lang pollen\n\n" out-port-pmd)
                        (let ([inp (open-input-file (string->path out-name-md) #:mode 'text)]
                              [outp out-port-pmd])
                          (read-write-file-by-line inp outp)
                          (close-output-port outp))))
                                 
                        
