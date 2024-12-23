#!/bin/bash

python ./aby3/GORAM/sampling.py --type random &
python ./aby3/GORAM/sampling.py --type powerlaw &
wait;

python ./aby3/GORAM/sampling.py --type k_regular &
python ./aby3/GORAM/sampling.py --type bipartite &
wait;

python ./aby3/GORAM/sampling.py --type geometric &
wait;