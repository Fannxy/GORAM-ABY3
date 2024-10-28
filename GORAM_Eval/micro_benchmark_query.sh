#!/bin/bash

cd ./aby3/;
python ./GORAM/graph_format_benchmark.py;
python ./GORAM/graph_format_record_analysis.py;

python ./GORAM/graph_format_benchmark.py --target adjmat;
python ./GORAM/graph_format_record_analysis.py --target adjmat;

python ./GORAM/graph_format_benchmark.py --target edgelist;
python ./GORAM/graph_format_record_analysis.py --target edgelist;
cd ../;