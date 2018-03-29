# Encapsulator

[![DOI](https://zenodo.org/badge/94570522.svg)](https://zenodo.org/badge/latestdoi/94570522)

Create a capsule that preserves a scientific experiment with
*encapsulator*.

The *encapsulator* software takes language specific provenance
collected for an analysis and uses it to extract the essential data,
dependencies and code needed to create a set of results, such as
figures or tables used in a manuscript.

Given the provenance and a list of results, *encapsulator* will
extract the essentials and package them up as a Virtual Machine that
will run on any system that can run VirtualBox. 

You can read more about data provenance and provenance powered
software at
[provenance@harvard](https://projects.iq.harvard.edu/provenance-at-harvard/home).


## Installation

```
gem install encapsulator
```

## Building from source

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

