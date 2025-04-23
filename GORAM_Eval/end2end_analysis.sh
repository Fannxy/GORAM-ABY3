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


MAIN_FOLDER=/root/GORAM-ABY3/aby3/

# THE FOLLOWING IS FOR DISTRIBUTED TEST
scp ${MAIN_FOLDER}out/build/linux/frontend/frontend aby31:${MAIN_FOLDER}out/build/linux/frontend/ &
scp ${MAIN_FOLDER}out/build/linux/frontend/frontend aby32:${MAIN_FOLDER}out/build/linux/frontend/ &
wait;

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


generate the random shares.
echo -e "\e[32mGenerate the random shares\e[0m"
unit_l=148735
bar_l=1024
b=64
joint_n_list=(8)
for N in ${joint_n_list[@]}; do
    (
        echo "N: $N"
        save_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/share_data_parallel/"

        if [ ! -d $save_folder ]; then
            echo "Creating folder $save_folder"
            mkdir -p $save_folder
        fi

        echo "Data folder: $save_folder"

        total_length=$((bar_l * b * b * 2 * 2))
        N_plus=$(( (unit_l / bar_l) * N ))

        # for i in $(seq 0 $((N_plus - 1))); do
        # (
        #     data_file_path="${save_folder}/provider_${i}.txt"
        #     meta_file_path="${save_folder}/provider_${i}_meta.txt"
        #     ./out/build/linux/frontend/frontend -getShare True -data_file_path ${data_file_path} -meta_file_path ${meta_file_path} -total_length ${total_length}
        # ) &
        # done
        # wait;

        seq 0 $((N_plus - 1)) | parallel -j 128 --progress --bar --joblog ./parallel.log -I{} ./out/build/linux/frontend/frontend -getShare True -data_file_path ${save_folder}/provider_{}.txt -meta_file_path ${save_folder}/provider_{}_meta.txt -total_length ${total_length}

        cat ./debug.txt
        rm ./debug.txt
    )
done
wait;

# benchmark transmission!
unit_l=148735
bar_l=8
b=64
joint_n_list=(2 4 8)
for N in ${joint_n_list[@]}; do
    (
        echo "N: $N"
        data_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/share_data_parallel/"

        if [ ! -d $save_folder ]; then
            echo "Creating folder $save_folder"
            mkdir -p $save_folder
        fi

        echo "Data folder: $save_folder"

        # total_length=$((bar_l * b * b * 2 * 2))
        N_plus=$(( (unit_l / bar_l) * N ))
        # N_plus=16

        parallel_size=256
        N_times=$((N_plus / parallel_size))
        for i in $(seq 0 $((N_times - 1))); do
            (
                # start server.
                ssh aby31 "ulimit -n 65536; cd ${MAIN_FOLDER}; ./out/build/linux/frontend/frontend -transfer True -role 0 -N ${parallel_size} -provider_id -1 -server_ip \"10.5.0.41\" -data_folder \"/root/GORAM-ABY3/aby3/aby3-GORAM/data/real_world/share_data_parallel/\" -data_file_path \"tmp\" -meta_file_path \"meta\" -n_plus ${N_plus}" &

                for j in $(seq 0 $((parallel_size - 1))); do
                (
                    provider_id=$((i * parallel_size + j))
                    data_file_path="provider_${provider_id}.txt"
                    meta_file_path="provider_${provider_id}_meta.txt"
                    record_folder="/root/GORAM-ABY3/aby3/aby3-GORAM/record/deployment/"
                    if [ ! -d $record_folder ]; then
                        echo "Creating folder $record_folder"
                        mkdir -p $record_folder
                    fi

                    # start provider.
                    ./out/build/linux/frontend/frontend -transfer True -role 1 -N $parallel_size -provider_id $j -server_ip "10.5.0.41" -data_folder $data_folder -data_file_path $data_file_path -meta_file_path $meta_file_path -n_plus ${N_plus};
                ) &
                done
                wait;
            )
        done

        # start server.
        # ./out/build/linux/frontend/frontend -role 0 -N $data_folder -file_path $file_path -meta_file_path $meta_file_path -record_folder $record_folder -record_file $record_file_path;

        # for i in $(seq 0 $((N_plus - 1))); do
        # (
        #     data_file_path="${save_folder}/provider_${i}.txt"
        #     meta_file_path="${save_folder}/provider_${i}_meta.txt"
        #     ./out/build/linux/frontend/frontend -getShare True -data_file_path ${data_file_path} -meta_file_path ${meta_file_path} -total_length ${total_length}
        # ) &
        # done
        # wait;

        # seq 0 $((N_plus - 1)) | parallel -j 128 --progress --bar --joblog ./parallel.log -I{} ./out/build/linux/frontend/frontend -getShare True -data_file_path ${save_folder}/provider_{}.txt -meta_file_path ${save_folder}/provider_{}_meta.txt -total_length ${total_length}

        cat ./debug.txt
        rm ./debug.txt
    )
done
wait;

