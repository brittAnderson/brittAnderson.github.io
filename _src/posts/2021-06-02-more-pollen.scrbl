#lang scribble/manual

Title: More Pollen
Date: 2021-06-02T16:39:34
Tags: raisin,qod

Working with Pollen is powerful, but challenging. A few brief comments on converting my Queen's Own Detectress Children's story.

<!-- more -->

@hyperlink["https://github.com/mbutterick/pollen"]{Pollen} is a powerful text processing/publishing toolkit written in Racket, and I have been using it to gain some
familiarity with writing racket code. Given that it brings with it its own special syntax I am not sure it is the best place to start for learning Racket. It might be the
right place to start if your primary goal is publishing, and it is definitely a good place to visit once you have some basic racket down, but trying to learn both
together is tougher than it needs to be.

As just one example you have to use the lozenge ◊ with one of two different styles of commands, and some of them are slightly different in what you can expect from how they
are going to handle strings. But all of this gives you great power, and I was able to write a simple template with a next and back page link adapting the example from the tutorials.

@codeblock[#:line-numbers 1]{
 ;; template.html.p                            
 ◊(->html (html (head (meta #:charset "UTF-8")
 ;(title (select 'h1 doc))
 (link #:rel "stylesheet" #:type "text/css" #:href "styles.css"))
 (body doc
 ◊(when/splice (previous here) (a #:href
     (format "~a" ◊|(previous here)|)
         (format "Prior Chapter ~a" ◊select['h1 ◊previous[here]])))
 ◊(when/splice (next here) (p (a #:href (format "~a" ◊|(next here)|)
     (format "Next Chapter ~a" ◊select['h1 ◊next[here]])))))))
 }

If you look at lines 6 and 9 I am still not quite clear why I had to leave off the lozenge for the predicate to @tt{when/splice}, but with a little bit of fiddling
you can get it to work, and I think with time the balance between pollen functions and racket functions would become better understood.

In sum, I recommend everyone racket competent try Pollen for a small publishing project, but I recommend newer users --- like me --- stick more with base racket for a while.

To read the result head over to @hyperlink["the-queen-s-own-detectress.html"]{Queen's Own Detectress} and follow the links there. 
