#lang scribble/manual

Title: Learning Racket via some Pollen
Date: 2021-05-26T16:21:50
Tags: raisin,racket,pollen,programming,qod,haskell

Learning a new programming language has two characteristic early stages: the tutorial stage where everything is scripted and goes well; and the stage where you first try to do something yourself and it all gets much more real. This entry records some of my impressions on this process as regards @hyperlink["https://racket-lang.org/"]{racket} and @hyperlink["https://docs.racket-lang.org/pollen/"]{pollen}. Can I turn the children's story I wrote for my wife into a series of web pages?

<!-- more -->

@section{The Project}

@subsection{The Story}

One night I woke up early and had some melange of dream and hypnogogic hallucination about a child detective. I scratched a few notes down and told my wife about it the next morning over coffee. She loved the story and wanted to know what would happen next. Well, I had no idea. I had not really considered that there would be a next, but I began to mull it over and one chapter led to another and finally to an actual story. My wife was working remotely by this stage and so I would record myself reading each chapter to her as I finished them, which was an intermittent process that took several months. She was happy enough with it that I thought she might like a hard copy. The easiest way for me to make a pdf that looked like a book at that point was to transcribe the notes to LaTeX. It was mostly just text with a few @tt{\chapter} and @tt{\textbf} folded in that then was assembled using the @tt{memoir} class. And that was that until prodded by a few family members and pandemic @italic{ennui} I decided to make it available for anyone to read. 

@subsection{First Task}

Putting LaTeX on the web is not trivial. I did for awhile maintain a personal website using @tt{htlatex} and it worked okay, but it was rather brittle, and required a lot of personal editing. I did not want to repeat that process. Just going through each file and manually editing things would have given me the chance to fix typos and grammar errors, but that seemed too easy, and while running it all through @hyperlink["https://pandoc.org/MANUAL.html"]{pandoc} to end up with HTML would have been the practical solution the goal was not so much to get it done, as to get it done in a way that also taught me something. Having recently skimmed some of the pollen manual as my foray into racket I decided to use that.

@section{Some General Lessons}

The problems were not too severe or, with hindsight, that unexpected, but they do serve as good reminders to myself, and maybe to others, of things to think about before beginning on something like this.

@subsection{First Lesson: Think of first things first}

In my case, I wanted some experience with racket and there were some nice tutorials in the pollen document. I began with my first effort concentrating on pollen, when I should have begun working on racket itself. Rather than a means to an end my focus on pollen turned into a bit of a delaying tactic. If your goal is to learn pollen, then starting with pollen and backfilling your racket knowledge is the right way to go, but since pollen uses a different syntax for its commands, it was not the best choice for me to gain racket experience. 

@subsection{Second Lesson: Think hardest about your earliest choices}

I knew that pollen understood markdown, and without much thinking I decided to just format the LaTeX files to markdown via pandoc. Then the serious practice could begin. This was a mistake. I should have just started using racket and its regexp capacities to convert the few LaTeX commands being used into pollen markup directly. I ended up with a more complicated file to parse (plain markdown uses series of equal signs underneath the title --- that means I had to process the second line to learn how to treat the first line). After fiddling with that, and remembering that other title styles were an option, I spent time learning how to use an optional argument to pandoc to force @italic{atx style} headings. This was completely orthogonal to all my learning goals, and not something I expect to use again. If I had thought harder about that early choice, especially when looking at the first pandoc output, I would have saved myself some time and frustration. 

@subsection{Third Lesson: When the goal is learning the measure is learning}

I called my casually constructed plan to convert the LaTeX to markdown by pandoc a mistake, but it required me to end up learning how to call a command line program (I ended up using @tt{subprocess}) within a racket script. From a project design standpoint I still recommend that you consider your earliest decision most carefully; those are the ones where the consequences will have the longest duration of effect and the greatest potential to cascade complications. But for a learning exercise whether something is a mistake or not is measured by whether it led you to or away from learning something in the domain you were targeting. 

@subsection{Fourth Lesson: Learning to do @italic{A} often means learning to do @italic{B}}

Even a simple project like converting some text files from one format to another is not an isolated activity. Searching for and finding out a fair amount about regexp syntax was not directly related to my interest in learning some racket coding, but it was nice to learn that racket has such nice support. The moral here is that one should expect there will be digressions and not to get unduly frustrated when they arise. 

@section{Specific Comments on the Coding}

@subsection{Tooling}

Tooling is great. I like emacs and found @hyperlink["https://nongnu.org/geiser/"]{geiser mode} to be easy to install and set-up, and robust and helpful in its use. I also found @hyperlink["https://docs.racket-lang.org/drracket/index.html"]{Dr Racket} a perfectly pleasant and useful IDE. Either worked well for me, and were a far cry from any experience I had using Haskell and emacs together.

@subsection{Documentation}

Racket has great documentation that is up to date, and contained in one place. However, it is not always written with different skill levels in mind, and it can be hard for a novice to find the right entry point to a subject. I don't really see how it could be much different, but it is useful in planning to consider also looking for some other complementary introductory materials.

@subsection{It was scary sometimes how well things worked}


And very frustrating when things did not work out. Sometimes this was the combination of my newness to the language and the style of the documentation, which often doesn't make simple things clear; how exactly, for example, does one write a @literal|{@hyperlink}|? Do you quote one section? Both? What bracketing pattern is recommended? It was necessary for me to search the sources and read about @literal|{@}| syntax to see how to create a hyperlink. Searching hyperlink itself doesn't give you a simple working example. I suspect to someone grown up on the language it is hard to understand that these sorts of problems even occur. There is a challenge to being a solitary user with no fellow travellers in the lecture hall sitting near you and to whom you can refer your questions. For example, I still don't know how to put the "at" sign in a typewriter font in this scribble document.

@subsection{Scripting the Conversion from LaTeX to PMD}

I cribbed from somewhere forgotten a short function to copy a file line by line (checking and halting when it reached the @tt{eof-object}). With a list of my tex files in hand I discovered some weird temp versions that I had left around marked by underscores. This was my first prompt to begin to explore the @hyperlink["https://docs.racket-lang.org/guide/regexp.html?q=regexp#%28tech._regexp%29"]{regexp tools}, which is of course great and only hard to use, because regex is hard to use - or at least arcane to use. Armed then with a couple of refined file lists I was ready to script my conversion from LaTex -> markdown (via pandoc) -> then to pollen markdown. 


@codeblock[#:keep-lang-line? #f #:line-numbers 0]{
#lang racket
(define tex-files (filter (lambda (fn) (regexp-match? #rx"(?<!_).tex" fn)) dl))
(define md-files (for/list ([fn tex-files]) (path->string (path-replace-extension fn ".md"))))
(for ([fn tex-files]) (let ([out-name-md
     (string-append dpd (path->string (path-replace-extension fn ".md")))]
                            [out-port-pmd (open-output-file (string-append dpd
			    		(path->string
					(path-replace-extension fn ".pmd")))
					#:mode 'text #:exists 'replace)])
                        (displayln out-name-md)
                        (define-values (sp a b c) (subprocess #f #f #f "/home/britt/.cabal/bin/pandoc"
                              (path->string fn) "--atx-headers" "--to" "markdown_strict" "-o" out-name-md))
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
}

The interesting examples for me are the ease of adjusting the file names, and my discovery that it is not so easy to add text to the beginning of a file. Since I had to create a new file with the new extension anyway when going from @tt{md} to @tt{pmd} it was not a big deal to pre-pend the hashlang for @tt{pollen} to the front of the file. Another discovery for me was the sort of lazy approach to the subprocess command. Racket is not an imperative language. Things don't hang around waiting for other things to finish. Of course, one knows that when asked, but it is easy to forget in practice that your serial thinking does not necessarily translate to code execution. Fortunately, racket developers seem sensitive to the fact that their users may be novices and provide the right hints and commands, in this case @tt{subprocess-wait}, @italic{line 12}.

@subsection{Functions for Converting PMD to PM}

On viewing the resulting PMD files via the pollen server I decided that I needed to move on. There were backslashes and other characters strings that for various reasons had not converted nicely. Plus, the goal was to learn some pollen too, in addition to the racket code. This took longer than expected (or wanted), but eventually I think the learning was sufficient to justify the time. This calculation is hard to work out with confidence in advance.

@subsubsection{Regexps for Pollen}

I had only a few markdown elements that needed conversion to pollen markup. I used this as an exercise to work on my regexp knowledge. It is still very incomplete, and I don't know that I have gained much understanding, but I got a few workable examples.

@racketblock[
;;defining my regexps for producing the pollen mark-up
(define my-title-line (list #rx"^# +.*$" "◊title{" "}" 2 0))
(define my-ital-rx (list #rx"\\/.*?\\/"  "◊em{" "}" 1 1))
(define my-em-rx (list #rx"\\*.*?\\*" "◊bold{" "}" 1 1))
(define my-ell-rx (list #px"\\\\\\.{3,}" "◊ellipsis{" "}" 1 0))
(define my-em-list (list my-title-line my-ital-rx my-em-rx my-ell-rx))
]

If this were more than an exercise I would convert these to a different datatype, probably a structure so that I could use the named fields. But for the short, one-off use, I needed these conversions for they were good enough. The basic organization is a list with the regexp expression, the text to be used as substitute on the front of the pollen markup, the text to be placed on the end, and the offsets at the beginning and end of the replacement. Some things like titles don't need any offsets at the end, but some like bold and emphases do. Then, I put all my elements into a badly named list that bore the title of an earlier incarnation, but which had become engrained in my mind at this time, and so was not changed.

Writing the functions that used these regexp's was quite a bit of fun. The batch function is a pretty mundane cycling through of all my files. But the @tt{read-write-file-pmd-pm} lent itself, I eventually saw, to a rather concise expression. The real meat of the conversion happens in @italic{line 17}. There we are able to start with our initial version of the line and apply our regexp based replacements one at a time. However, these can be sequenced and so with a @bold{fold} operation we can traverse our list of regexps and gradually accumulate the result, which we then write out to the file. If there were more regexps to be added they could simply be appended to the list and this function would need no changing.

Why did I think to try this? It was all that time spent writing and reading useless Haskell code (my code was useless, not Haskell itself, which I still love, but just can't figure out a way to use productively). All those functional tools are present in Racket. Either one comes to learn about them in a course or from a colleague, or one can be a renegade from another functional language. But if you want those features they are accessible in Racket, though maybe not as directly as one would like. I missed things like @tt{flip} that I got almost for free in Haskell, and the automatic currying was nice, but had to be invoked manually here. As I think about it now though, maybe forcing a conscious use of currying is not all bad. It requires that one think and know what one is doing. Perhaps the same goes for composition. 

There are a couple of helper functions below. I like being able to write my functions assuming that a helper function will be written later, rather than being forced to order my code such that nothing is used before it is defined. And the helper functions also show a couple of habits carried over from Haskell (or maybe Unix by some extended line of inheritance). Write small functions. It is easier to understand and debug. Here we can step through each element of our regexp replacment lists and use the pieces to get the result we want. Then we can use that piece to write a simple recursive function with a base case and the case where there is more than one regexp of a particular type to be parsed in a line (say several words that are italicized). Of course this will not work well if I have a line break in the middle of such a markdown expression, but it was good enough for this.

Then having something that works on one line for multiple examples, we can put all of those into the fold and create our new line of output text. I added a display for which file was going to be processed, but I didn't need it. Everything was very fast. 

@codeblock[#:keep-lang-line? #f #:line-numbers 0]{
#lang racket
(define (batch-pmd->pm (dir-with-files "/home/britt/progLang/racket/detectress-pollen"))
  (current-directory dir-with-files)
  (define dl (directory-list))
  (define pmd-files (filter (lambda (fn) (regexp-match? #rx"(?<!_).pmd$" fn)) dl))
  (for ([f pmd-files])
    (define inp (open-input-file f #:mode 'text))
    (define outp (open-output-file (path-replace-extension f ".pm") #:mode 'text #:exists 'replace))
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
}

@section{Summary, Morals, and Preview of Coming Attractions}

@subsection{Summary}
Racket is a powerful and accessible language with a lot of power features. It allowed me to take only 10 times as long on this conversion as if I had done it by hand. But the learning process was fairly smooth and I am confident I will be paid back in time and accomplishments down the road. I recommend Racket as a first functional language and as a language for the mid-tier programmer as well. This is the programmer for whom programming is a side-activity (e.g. you are really a cognitive scientist or a physician or both) or it is a hobby or you are just isolated without the team of experts that is needed to really exploit the potential of something like Haskell.

@subsection{Morals}
Learning a new language is hard. Harder than you think from your tutorial exercises, but Racket is very accessible given the complexity of the features that it offers. Prior experience with a functional language will help you make use of some of the power. There is no substitution for time and effort. Yes, the answer to your question is easily accessible in the documentation, but you often cannot find your answer until you know the answer (a coding koan?). Until you do know your answer there will be a lot of searching, but the second time things will go much more quickly. Searching for answers in documentation is not a preliminary to learning it is part of the education.

@subsection{Preview of Coming Attractions}
What about the children's story? It is coming. Watch this space. But this post was about Racket and learning via text conversion. The story itself will be its own blog post. 

