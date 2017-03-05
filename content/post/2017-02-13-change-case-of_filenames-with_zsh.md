---
date: 2017-02-13T13:14:15Z
title: Change the case of filenames with Zsh
categories:
  - shell
keywords:
  - zsh
  - file
  - filename
  - rename
  - convert
  - lowercase
  - uppercase
tags:
  - zsh
  - shell
  - file
  - filename
  - rename
  - convert
  - lowercase
  - uppercase
---

Today, after importing photos from my iPhone to my Mac, I noticed 
their filenames were all uppercase whereas I want them to be all lowercase.
This is a task `zsh` can perform easily with a oneliner.
<!--more-->

The files before the renaming.
``` bash
IMG_4575.PNG
IMG_4576.PNG
IMG_4577.PNG
```

This oneliner iterates over the files whose name starts with `IMG` and ends with
`.PNG` and rename each one to lowercase.
``` shell
for file in IMG*.PNG ; do  mv $file ${file:l}  ; done
```
The key trick here is `${file:l}` (with an 'l' as in lowercase) that outputs 
the content of the variable `file` all lowercase. 

The files have been successfully renamed all lowercase.
``` shell
img_4575.png
img_4576.png
img_4577.png
```

Should you need to perform the opposite ie. convert the file names 
to **uppercase**, use `${file:u}` instead, like so:


``` shell
for file in img*.png ; do  mv $file ${file:u}  ; done
```
