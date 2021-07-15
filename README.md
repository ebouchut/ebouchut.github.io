

This git repository, hosted on Github.com, is composed of 2 main branches:
- **`master`** contains the source of my blog (https://EricBouchut.com)
- **`gh-pages`** contains the published version of my blog.

The **publishing process:** consists of using Hugo to transform the source into the published version:  
`master`branch (source version) → `hugo` → `gh-pages` branch (published version)  
I use [Hugo](https://gohugo.io) to generate my blog. It is a fast CLI blogging engine.

The **deployment process** consists of:
- committing the changes of the published version to the the `gh-pages`branch
- pushing the `gh-pages` branch to the repository on Github

`gh-pages` branch (published version) → Push changes to Github  
Github notices I pushed to the `gh-pages` branch and automatically replicates it to its Web servers.
 
## Configuration

### Clone

```shell
git clone git@github.com:ebouchut/ebouchut.github.io.git
cd ebouchut/github.io
```

### Create the public folder

This needs to be done once after the clone (or if you remove the publish worktree).

```shell
git checkout master

# make sure no `public` folder is present or else remove it

git worktree add public gh-pages
```

I use the `worktree` git subcommand here, to create the `public` folder.
Git populates it with the content of the `gh-pages` as if we cloned the repository inside then checked out the `gh-pages`branches.
The main advantage f using git worktree is to have the ability to work on multiple branches at the same time depending on the folder we are in:
- under `public/` we work on the `gh-pages` branch, the published version of the blog.
- everywhere else (in the working area) we work on the checked out branch (`master`in this case) the source version of the blog.

The benefit here is to have the `publish` folder handy with a cloned version of the repository with the target branch `gh-pages` checked out.
Once I generate the published version of the blog using `hugo` I then only need to cd into `publish` commit the changes and push the `gh-pages` branch to github. Github then automatically notices a push occurred and replicates the published site on its servers.

## Usage

### Preview the blog

```shell
git checkout master
hugo serve
```

You can then view the blog locally at http://localhost:1313/  
The changes are updated live.

### Publish the Blog

```shell
git checkout master

# => Write the published version of the blog in the `publish` folder.
hugo

cd public
# => Note that in public/ and only in this folder the current branch is `gh-pages` due to worktree magic
git add .
git commit -m "Published at YYYY-MM-DD" -m "Additional description if needed"

cd ..
```

