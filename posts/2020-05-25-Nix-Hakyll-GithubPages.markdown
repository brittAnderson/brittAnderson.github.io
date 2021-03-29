---
title: Using Nix, Hakyll, and GithubPages
author: Britt Anderson
---

<<<<<<< HEAD
The first exercise is to get to stitch together a blog with the use of these tools. First, download and install NixOS. That is a big step and a lot of work on its own. I am not detailing that here. And that is good for you, because I don't really know what I am doing.  Compilation /= competency.

Next, you need some Haskell tooling. A secondary reason for using NixOS was the fact that haskell seems to play nice with nix, and my intermittent forays into haskell over the years have already made me aware that is not a trivial point. However, just like nix as a whole, the documentation is patchy, and it is easy to find popular, but out of date resources. A good source as of May 2020 is (Maybe Void)[https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html].
=======
The first exercise is to get to stitch together a blog with the use of these tools. First, download and install NixOS. That is a big step and a lot of work on its own. I am not detailing that here. And that is good for you, because I don\'t really know what I am doing.  Compilation /= competency.


Next, you need some Haskell tooling. A secondary reason for using NixOS was the fact that haskell seems to play nice with nix, and my intermittent forays into haskell over the years have already made me aware that is not a trivial point. However, just like nix as a whole, the documentation is patchy, and it is easy to find popular, but out of date resources. A good source as of May 2020 is [Maybe Void](https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html).
>>>>>>> develop

The consensus seems to be that a couple of things you will want globally are `cabal2nix`, `nix-prefetch-git`, and `cabal-install`. The rest you can use via the `nix store`.

You can then use a `shell.nix` file to pull in the packages your need from haskell to have an environment that lets you use `cabal` to build your `site.hs` file. Then instead of stack you can use the compiled `site` from deep inside your `dist-newstyle` subdirectory to run the various hakyll commands. 

<<<<<<< HEAD
In addition, I adapted the instructions on deploying from the (tutorial)[https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html] to read from a file the deploy command. I just wrote it in the top directory and cobbled together some poorly understood code at the start of the `main` function in `site.hs` to build a configuration and supply it to `hakyllWith`. I think my files and commands should be readable from the develop branch. 
=======
In addition, I adapted the instructions on deploying from the [tutorial](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html) to read from a file the deploy command. I just wrote it in the top directory and cobbled together some poorly understood code at the start of the `main` function in `site.hs` to build a configuration and supply it to `hakyllWith`. I think my files and commands should be readable from the develop branch. 
>>>>>>> develop
