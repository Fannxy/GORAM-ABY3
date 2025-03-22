cd ./aby3/;

ulimit -v 419430400; python ./GORAM/end2end_analysis.py --providers 2 --threads 2 --preprocess True >> /scratch1/log.txt 2>&1

if [ $? -eq 137 ]; then
    echo "Memory limit exceeded during the end2end analysis."
    exit 1
fi

cd ..;