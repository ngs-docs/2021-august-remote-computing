# An Introduction to Remote Computing

These are the source materials for the August 2021 offering of An
Introduction to Remote Computing.

See
[the course Web site](https://ngs-docs.github.io/2021-august-remote-computing)
for the rendered materials, including links to recordings!

See
[the base repository](https://github.com/ngs-docs/remote-computing-base)
for material that may be more up to date and can be reused/remixed.

## Legacy material

Remote computing workshops in August 2021. Built with bookdown based
on the
[datalab workshop template](https://github.com/datalab-dev/template_workshop).

See rendered site at:
[ngs-docs.github.io/2021-august-remote-computing/](https://ngs-docs.github.io/2021-august-remote-computing/)

### To build locally:

- Enter the following commands to re-build the bookdown (`make`) and view the website (`open`). (You only have to create the `bookdown` environment once!):
   ```
   mamba env create -f environment.yml -n bookdown
   conda activate bookdown
   make
   open docs/index.html
   ```
