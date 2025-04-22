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

# prepare the random shares.

N_list=(8 16)
data_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/"
data_file="twitter_2dpartition.txt"
meta_file="twitter_meta.txt"

# for N in ${N_list[@]}; do
#     (
#         echo "N: $N"
#         save_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/twitter_${N}/"

#         if [ ! -d $save_folder ]; then
#             echo "Creating folder $save_folder"
#             mkdir -p $save_folder
#         fi

#         echo "Data folder: $save_folder"

#         ./out/build/linux/frontend/frontend -prepare True -data_folder $data_folder -data_file_path $data_file -meta_file_path $meta_file -save_folder $save_folder -N $N;

#         cat ./debug.txt
#         rm ./debug.txt
#     ) &
# done
# wait;

# partition initialization.
# echo -e "\e[32mPartition initialization\e[0m"
# for N in ${N_list[@]}; do
#     data_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/twitter_${N}/"
#     file_path="provider_0.txt"
#     meta_file_path="provider_0_meta.txt"
#     record_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/record/deployment/"
#     if [ ! -d $record_folder ]; then
#         echo "Creating folder $record_folder"
#         mkdir -p $record_folder
#     fi
#     record_file_path="provider_0_${N}.txt"

#     ./out/build/linux/frontend/frontend -init True -data_folder $data_folder -file_path $file_path -meta_file_path $meta_file_path -record_folder $record_folder -record_file $record_file_path;
# done


# generate the random shares.
echo -e "\e[32mGenerate the random shares\e[0m"
unit_l=148735
bar_l=8
b=64
joint_n_list=(2 4 8)
for N in ${joint_n_list[@]}; do
    (
        echo "N: $N"
        save_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/share_data_${N}/"

        if [ ! -d $save_folder ]; then
            echo "Creating folder $save_folder"
            mkdir -p $save_folder
        fi

        echo "Data folder: $save_folder"

        total_length=$((bar_l * b * b * 2 * 2))
        N_plus=$(( (unit_l / bar_l) * N ))

        for i in $(seq 0 $((N_plus - 1))); do
        (
            data_file_path="${save_folder}/provider_${i}.txt"
            meta_file_path="${save_folder}/provider_${i}_meta.txt"
            ./out/build/linux/frontend/frontend -getShare True -data_file_path ${data_file_path} -meta_file_path ${meta_file_path} -total_length ${total_length}
        ) &
        done
        wait;

        cat ./debug.txt
        rm ./debug.txt
    )
done
wait;
