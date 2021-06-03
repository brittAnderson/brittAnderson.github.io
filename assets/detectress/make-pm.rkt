#lang racket

(provide batch-pmd->pm)
(require pollen)
(require pollen/unstable/typography)

;;sentences for testing while developing
(define a " some text with asterisks bounding words like *this*, and we want to replace them")
(define b "this is some text with /emphasis/ but also a bold *comment* and then some other stuff")
(define c "some text with /emphasis/ and  another /word emphasized/ plus some *bold* and a funky \"quote\" and \" one with spaces \" .")
(define e "this is a test \\...  and here is a second, third, fourth \\... one")

;;defining my regexps for producing the pollen mark-up
(define my-title-line (list #rx"^# +.*$" "◊title{" "}" 2 0))
(define my-ital-rx (list #rx"\\/.*?\\/"  "◊em{" "}" 1 1))
(define my-em-rx (list #rx"\\*.*?\\*" "◊bold{" "}" 1 1))
(define my-ell-rx (list #px"\\\\\\.{3,}" "◊ellipsis{" "}" 1 0))
(define my-em-list (list my-title-line my-ital-rx my-em-rx my-ell-rx))

(define (batch-pmd->pm (dir-with-files "/home/britt/progLang/racket/detectress-pollen"))
  (current-directory dir-with-files)
  (define dl (directory-list))
  (define pmd-files (filter (lambda (fn) (regexp-match? #rx"(?<!_).pmd$" fn)) dl))
  (for ([f pmd-files])
    (define inp (open-input-file f #:mode 'text))
    (define outp (open-output-file (path-replace-extension f ".html.pm") #:mode 'text #:exists 'replace))
    (println (format "processing file ~a " outp))
    (read-write-file-pmd-pm my-em-list inp outp)
    (close-output-port outp)))

(define flip (lambda (f x y) (f y x))) 

(define (read-write-file-pmd-pm list-of-rxs file-port-in file-port-out)
  (let ((line1 (read-line file-port-in 'any)))
    (unless (eof-object? line1)
      (displayln (foldr (curry flip my-new-string) (smart-quotes line1) list-of-rxs) file-port-out)
      (read-write-file-pmd-pm list-of-rxs file-port-in file-port-out))))

(define (my-new-string s my-rx)
  (let ((myids (regexp-match-positions (first my-rx) s)))
    (if (not myids)
      s
      (my-new-string (my-string-append (first myids) s my-rx) my-rx)))) 

(define my-string-append (lambda (ids s my-rx)
                    (string-append (substring s 0 (car ids))
                                   (list-ref my-rx 1)
                                   (substring s (+ (car ids) (list-ref my-rx 3)) (- (cdr ids) (list-ref my-rx 4)))
                                   (list-ref my-rx 2)
                                   (substring s (cdr ids)))))
