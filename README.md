# CodecleanR

## Installation

(Fedora 25, look for package name on your unix distribution)

```
sudo dnf install ruby
gem install json rgl rake bundler open5
git clone https://github.com/tfjmp/codecleanR.git
cd codecleanR
rake install
codecleanR -h
# try it out!
codecleanR --code ./json/messy_ddg.json d17
```

## USAGE

```
# extract info from ddg.json
codecleanR --info <your_RDT_prov.json>
# select an output node to generate the code to be generate
codecleanR --code <your_RDT_prov.json> <output_node_id>
```
