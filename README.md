

My blog uses *Mkdocs* and *mkdocs-material* as a blogging platform.

This git repository, hosted on Github.com, is composed of 2 main branches:
- **`main`** contains the source of my blog
- **`gh-pages`** contains the published version of [my blog](https://EricBouchut.com).

I can publish the blog either locally or via remotely via *Github* *Continuous Deployment*.
 
## Installation
I use `venv` as a Python virtual environment, but feel free to use the one you are used to.

```shell
# ⓵
git clone git@github.com:ebouchut/ebouchut.github.io.git
cd ebouchut.github.io

# Create a Python virtual environment in your project
# IMPORTANT: Do this once
python3 -m venv venv 
  
# Activate the virtual environment 
# IMPORTANT: Do this each time you open a new shell/window/tab
source venv/bin/activate
```

- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this project
- Install _Python_ 3.  
  Review [Properly Installing Python](http://docs.python-guide.org/en/latest/starting/installation/) for help on getting *Python* installed.
- Install Python Virtual Environment.  
   In this example, I use [`venv`](https://realpython.com/python-virtual-environments-a-primer/#how-can-you-work-with-a-python-virtual-environment), but use whichever you prefer.
- Install the project's required _Python_ packages
## Add a Blog Post

To create a new blog post:

- Create a new Markdown file under `docs/blog/posts`  with this naming convention  `YYYY-MM-DD-post_title_here.md`,  where:
	- `YYYY` denotes the year number in a four-digit format (for instance `2023`) 
	- `MM` denotes the month number in a two-digit format  (`01` is January and `12` is December)
	- `DD` denotes the day of the month in two-digit format within the  range `01` to `31`
	- `post_title_here` denotes the title of the blog post. Separate each word with an underscore (`_`)
	- `.md`  is the Markdown file suffix
- Edit the blog post using:
  -  [Python Markdown](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown/)
  - [Python Markown Extensions](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown-extensions/)
  - [mkdocs-material extensions](https://squidfunk.github.io/mkdocs-material/reference/)

Most of these extensions are already installed and configured in `mkdocs.yml`.
Once you are done with the changes make sure the commits end up on the `main` branch.
## Preview 

You can preview blog and your changes  as you edit the files.

- Run the command below
  ```shell
  mkdocs serve
  ```
  This builds the website locally then runs a local web server listening on port `8000` . 
  
  If the default port (`8000`) is already used, you can use another one like `8080` for example:
  ```shell
  mkdocs serve -a 127.0.0.1:8080
  ```

  ℹ️ Keep this command running  as you make changes to the blog because it will continuously watch for file changes, build the changed files, and ask the browser to reload the updated pages.
  However, If you change the configuration file (`mkdocs.yml`), you will need to restart `mkdocs serve`.
- **Open** this URL in your **web browser**: http://127.0.0.1:8000/  
  
## Publish

There are 2 ways to publish your blog: locally or remotely.  
You can publish your blog from your local clone or set up and use *GitHub* *Continuous Deployment* that automatically triggers a remote deployment each time you push the `main` branch to your *GitHub* repository.
### Publish Locally

This needs to be done once after the clone.

```shell
git switch main
mkdocs gh-deploy
```

Let's break down what is happening here:
1. First we switch to the `main` branch.
2. This builds the blog from the `main` folder and store the output in the `site` folder.
3. 

### Write a new Blog Post

```
# git checkout main # If not on the main branch

# Generate a new blog post named xxx.md under content/
hugo new post/2021-07-17-xxx.md

# Edit content/post/2021-07-17-xxx.md

git add content/post/2021-07-17-xxx.md
git push  # origin main
```

### Publish the Blog

```shell
git checkout main


# => Generate the published version of the blog in the `publish` folder.
hugo

cd public
# => Note that in public/ and only in this folder the current branch is `gh-pages` due to worktree magic
git add .
git commit -m "Published at YYYY-MM-DD" -m "Additional description if needed"
git push   # origin gh-pages

cd ..
```

