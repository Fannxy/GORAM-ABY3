#!/bin/bash

# install the dependencies
cmake_version=$(cmake --version 2>/dev/null | grep "cmake version 3.18.5")

if [ -z "$cmake_version" ]; then
    echo "Installing cmake 3.18.5..."
    wget https://github.com/Kitware/CMake/releases/download/v3.18.5/cmake-3.18.5.tar.gz
    tar -zxvf cmake-3.18.5.tar.gz
    cd cmake-3.18.5
    ./bootstrap
    make
    sudo make install
    cd ..
    rm -rf cmake-3.18.5
    rm cmake-3.18.5.tar.gz
else
    echo "cmake 3.18.5 is already installed."
fi

pip install -r ./aby3/requirements.txt

# build ABY3
python ./aby3/build.py --setup

cd ./aby3/thirdparty/libOTe/out/macoro;
git checkout cfd155c11bd52c000c0c1afd6f03ed247c49610e; 
cd ../../../../..

# fix the bug in the thirdparty library.
FILE_PATH="./aby3/thirdparty/libOTe/cryptoTools/cryptoTools/Circuit/BetaLibrary.cpp"
LINE_NUMBER=1203
NEW_TEXT="           G = GateType::na_And;"

sed -i "${LINE_NUMBER}s/.*/${NEW_TEXT}/" "$FILE_PATH"

# then rebuild.
python ./aby3/build.py --setup
