---
title: "Go to the previous branch with git checkout -"
date: 2021-07-14T11:02:48+02:00
categories:
- git
tags:
- git
- change
- branch
- history
- navigate
keywords:
- git
- change
- branch
- history
- navigate
---

You are used to use `cd` in the shell (*bash*, *zsh*) to change folder then 
`cd -` to go back to the folder you were previously in.

Good news, `git` offers a similar kind of shortcut when switching branches.

<!--more-->
Below, we first change directory to go from `folderA` to `folderB`, 
then go back to `folderA` using `cd -`.
```
cd folderA
cd folderB  

cd -   # => back to the previous folder (folderA)
```

In the same vein, we can switch branches with `git checkout branchname` 
and use `git checkout -` to jump on the branch we were previously on.
Here is an example:
```
git checkout master
git checkout branch-a
git checkout branch-b

git checkout -
```
We first jump on the `master` branch, then on `branch-a` and finally on `branch-b`  

Then **`git checkout -` jumps back on the branch we were previously on**, that is `branch-a`.  
Note that in this case `git checkout` is followed by a dash sign (`-`) instead of a branch name.
This provides a branch agnostic way to go to the previous git branch, without having to type its name.

The table below provides the content of the jump stack for each command in the above example.

| Revision |           Description | git checkout master | git checkout branch-a | git checkout branch-b |
| ---      |                   --- | ---                 | ---                   | ---                   |
| @{0}     |        Current branch | `master`            | `branch-a`            | `branch-b`            |
| @{-1}    |       Previous branch |                     | `master`              | `branch-a`            |
| @{-2}    | Second to last branch |                     |                       | `master`              |

Each time you jump on a new branch the existing branches on the stack are shifted towards the bottom and the branch you jump on is pushed onto the stack.

git provides [revisions][git revisions],  among which we find the handy shortcut
notations `@{0}`, `@{-1}`, `@{-2}` ... we can use to reference the jump stack elements.

`git checkout -` is simply a notation equivalent to  `git checkout @{-1}` to go
to the previous branch you were on.

[git revisions]: https://mirrors.edge.kernel.org/pub/software/scm/git/docs/gitrevisions.html#_specifying_revisions
