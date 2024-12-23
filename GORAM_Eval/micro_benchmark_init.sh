#!/bin/bash

cd ./aby3/;

# if [ -d "./aby3-GORAM/record_offline" ]; then
#     rm -r ./aby3-GORAM/record_offline/*
#     echo "Cleared records in ./aby3-GORAM/record_offline/"
# else
#     echo "Directory ./aby3-GORAM/record_offline/ does not exist."
# fi

# # clear the results if the directory exists
# if [ -d "./GORAM/results_offline" ]; then
#     rm -r ./GORAM/results_offline/*
#     echo "Cleared results in ./GORAM/results_offline/"
# else
#     echo "Directory ./GORAM/results_offline/ does not exist."
# fi

python ./GORAM/graph_format_integration_benchmark.py
python ./GORAM/graph_format_record_analysis.py --target privGraph --stage offline

python ./GORAM/graph_format_integration_benchmark.py --target edgelist
python ./GORAM/graph_format_record_analysis.py --target edgelist --stage offline

python ./GORAM/graph_format_integration_benchmark.py --target adjmat
python ./GORAM/graph_format_record_analysis.py --target adjmat --stage offline

cd ../;