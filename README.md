# CodecleanR

## Installation

### Fedora 25

```
sudo dnf install ruby
gem install json rgl rake bundler
git clone https://github.com/tfjmp/codecleanR.git
cd codecleanR
rake install
codecleanR --install fedora
codecleanR -h
```

### Ubuntu

```
sudo apt install ruby
gem install json rgl rake bundler
git clone https://github.com/tfjmp/codecleanR.git
cd codecleanR
rake install
codecleanR --install ubuntu
codecleanR -h
```

### MacOS

```
brew install ruby
gem install json rgl rake bundler
git clone https://github.com/tfjmp/codecleanR.git
cd codecleanR
rake install
codecleanR --install mac
codecleanR -h
```

## USAGE

```
# extract info from ddg.json
codecleanR --info <your_RDT_prov.json>
# select an output node to generate the code to be generate
codecleanR --code <your_RDT_prov.json> <output_node_id>
```
