#!/bin/bash

data_folder="./aby3/aby3-GORAM/data/micro_benchmark"
multiparty_folder="./aby3/aby3-GORAM/data/multiparty"

# generate test data.
# mkdirs
if [ ! -d "$data_folder" ]; then
    mkdir -p "$data_folder"
else
    echo "Directory $data_folder already exists."
fi

if [ ! -d "$multiparty_folder" ]; then
    mkdir -p "$multiparty_folder"
else
    echo "Directory $multiparty_folder already exists."
fi

# star graph
python ./aby3/aby3-GORAM/privGraphQuery/micro_benchmark_generation.py --type "star" --n 32 --file_prefix ${data_folder}"/star"

# tmp_graph
python ./aby3/aby3-GORAM/privGraphQuery/micro_benchmark_generation.py --n 32 --file_prefix ${data_folder}"/tmp_graph"

# edgelist graphs.
python ./aby3/aby3-GORAM/privGraphQuery/micro_benchmark_generation.py --n 32 --file_prefix ${data_folder}"/adj_tmp" --saving_type "edgelist"

# multiparty graph
python ./aby3/aby3-GORAM/privGraphQuery/micro_benchmark_generation.py --n 32 --file_prefix ${multiparty_folder}"/random_n-16_k-2" --p 8

python ./aby3/aby3-GORAM/privGraphQuery/micro_benchmark_generation.py --n 32 --file_prefix ${multiparty_folder}"/random_n-16" --saving_type "edgelist" --p 8


# run the unit test.
cp ./aby3/frontend/main.test ./aby3/frontend/main.cpp
current_path=$(pwd)
debugFile="${current_path}/aby3/debug.txt"
graphFolder="${current_path}/aby3/aby3-GORAM/data/"
echo "Current path: ${debugFile}"
cd ./aby3/;
python ./build.py --DEBUG_FILE ${debugFile} --GRAPH_FOLDER ${graphFolder}

# clean debugging files party-*.txt if exist.
for pfile in ./party-*.txt; do
    rm ${pfile};
done
cd ../;

test_args=" -Shuffle -ORAM -Graph -GraphQuery"
cd ./aby3;
./Eval/dis_exec.sh "${test_args}"
wait;
cd ../;

cat ./aby3/debug.txt
rm ./aby3/debug.txt