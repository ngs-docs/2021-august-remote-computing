# 2021-august-remote-computing

Remote computing workshops in August 2021. Built with bookdown based
on the
[datalab workshop template](https://github.com/datalab-dev/template_workshop).

See rendered site at:
[ngs-docs.github.io/2021-august-remote-computing/](https://ngs-docs.github.io/2021-august-remote-computing/)

## To contribute:

- Clone this repo
- Create a branch and add changes
- Enter the following commands to re-build the bookdown (`make`) and view the website (`open`):
   ```
   mamba env create -f environment.yml -n bookdown
   conda activate bookdown
   make
   open docs/index.html
   ```
- Commit changes
  ```
  git add .
  git commit -am 'message about changes'
  git push origin <branch name>
  ```
- Create a PR, request review, merge
