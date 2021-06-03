#lang racket/base
(require pollen/tag pollen/decode pollen/misc/tutorial txexpr)

(provide root em bold title)
(define (em . elements)
  `((em ,@elements)))
(define (title . elements)
  `(h1 ,@elements))
(define (bold . elements)
  `(b ,@elements))
;(define (ellipsis . elements)
;  )

(define (my-lbr elements)
  (decode-linebreaks elements #f))

(define (my-parabr elements)
  (decode-paragraphs elements #:linebreak-proc my-lbr))

(define (root . elements)
  (txexpr 'root empty (decode-elements elements
				       #:txexpr-elements-proc my-parabr 
				       #:string-proc (compose1 smart-ellipses smart-quotes smart-dashes))))
