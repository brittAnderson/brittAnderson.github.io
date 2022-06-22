#lang scribble/manual

Title: Getting Started Writing With Scribble
Date: 2022-06-22T17:23:27
Tags: 

I have been thinking of trying to write an online textbook for a course I teach. It involves some code and I thought that racket might be a good language choice for the coding material, and that seemed to suggest using scribble, the racket documentation tool, but then ...

<!-- more -->

I found myself stymied doing even the most basic of things when I tried to adapt my org-mode workflow to a scribble work flow. Including a graph or typesetting some math was difficult, and I could not figure out how to emulate the org-babel functionality. It took a lot of on-line search and pouring through the source code to get examples of what I needed, and still many things are not quite right.

As is often true of racket is that there is no middle level documentation. The quick and easy start from this file sort of stuff. You have exhaustive source code that you can read. And you have very basic step by step tutorials. But sometimes you don't want to learn from first principles. You just want to get something to work and for that it is sometimes ideal to have a short file that just works, and that you can use as a starting point for expanding your knowledge by adding features as you need them. So, to help myself in the future, and maybe others in the present I wrote this short explanation of a template to get one up and running.

@include-section{template-explained.scrbl}
