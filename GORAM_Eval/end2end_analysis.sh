# cd ./aby3/;

# # ulimit -v 419430400; python ./GORAM/end2end_analysis.py --providers 2 --threads 2 --preprocess True >> /scratch1/log.txt 2>&1

# (
#     # set trap to catch the kill signal
#     trap 'echo "Process killed by signal at $(date)" >> /scratch1/log.txt; exit 1' SIGTERM SIGKILL

#     # set the memory limit to 400GB
#     ulimit -v 419430400
#     python ./GORAM/end2end_analysis.py --providers 2 --threads 2 --preprocess True
# ) >> /scratch1/log.txt 2>&1

# exit_code=$?

# if [ $exit_code -ne 0 ]; then
#     echo "Memory limit exceeded during the end2end analysis." >> /scratch1/log.txt
#     exit 1
# fi

# cd ..;


cd ./aby3/;

cp ./frontend/main.e2e ./frontend/main.cpp;
python build.py

# data prepare
echo -e "\e[32mTwitter\e[0m"
N_list=(2 4)
data_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/"
data_file="twitter_2dpartition.txt"
meta_file="twitter_meta.txt"

for N in ${N_list[@]}; do
    (
        echo "N: $N"
        save_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/twitter_${N}/"

        if [ ! -d $save_folder ]; then
            echo "Creating folder $save_folder"
            mkdir -p $save_folder
        fi

        echo "Data folder: $save_folder"

        ./out/build/linux/frontend/frontend -prepare True -data_folder $data_folder -data_file_path $data_file -meta_file_path $meta_file -save_folder $save_folder -N $N;

        cat ./debug.txt
        rm ./debug.txt
    ) &
done
# save_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/twitter_${N}/"

# if [ ! -d $save_folder ]; then
#     echo "Creating folder $save_folder"
#     mkdir -p $save_folder
# fi

# echo "Data folder: $save_folder"

# ./out/build/linux/frontend/frontend -prepare True -data_folder $data_folder -data_file_path $data_file -meta_file_path $meta_file -save_folder $save_folder -N $N;

# cat ./debug.txt
# rm ./debug.txt

# cd ../;