# Encapsulator

[![DOI](https://zenodo.org/badge/94570522.svg)](https://zenodo.org/badge/latestdoi/94570522)

## Installation

### Fedora 25

```
$ sudo dnf install ruby
$ gem install encapsulator
$ encapsulator --install fedora
$ encapsulator -h
```

### Ubuntu

```
$ sudo apt install ruby
$ gem install encapsulator
$ encapsulator --install ubuntu
$ encapsulator -h
```

### MacOS

```
$ brew install ruby
$ gem install encapsulator
$ encapsulator --install mac
$ encapsulator -h
```

## USAGE

```
# see
$ encapsulator -h
--version display encapsulator version
--info <path to R script> display information about the R script
--jpg [--all] <path to R script> output graph as jpg
--png [--all] <path to R script> output graph as png
--svg [--all] <path to R script> output graph as svg
--code <path to R script> <output> [output] ... [output] create the source necessary to generate the specified output
--run <path to R script> run the provided r script
--encapsulate <user>/<project> <script> <output> [output] ... [output] create the specified capsule
--decapsulate <user>/<project> download the coresponding capsule
```
