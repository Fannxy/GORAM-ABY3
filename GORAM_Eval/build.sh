#!/bin/bash

# install the dependencies
apt-get install -y software-properties-common
add-apt-repository ppa:george-edison55/cmake-3.x
apt-get update
apt-get install -y cmake=3.18.5-0kitware1

apt-get install -y mpich=3.2-2

pip install -r ./aby3/requirements.txt

# build ABY3
python ./aby3/build.py --setup

# fix the bug in the thirdparty library.
FILE_PATH="./aby3/thirdparty/libOTe/cryptoTools/cryptoTools/Circuit/BetaLibrary.cpp"
LINE_NUMBER=1203
NEW_TEXT="           G = GateType::na_And;"

sed -i "${LINE_NUMBER}s/.*/${NEW_TEXT}/" "$FILE_PATH"

# then rebuild.
python ./aby3/build.py --setup
