#!/bin/bash

source modules.sh

for nodes in 1 2 4 8 12
do
    for strong_N in 3072 6144 18432
    do
        echo "Strong scaling using $nodes nodes and $curr_N particles"
        srun -p fpga -A hpc-lco-kenter --constraint=19.4.0_max -N $nodes --fpgalink=ringN -t 10:00 -l --cpu-bind=cores --ntasks-per-node=1 \
        ./main.out -t lrbd -suffix _no_sync_local_s13 -i lf -order 2 -N $strong_N  -T 30.0 -f_max 243.33 -LPE 4 -RPE 4 -nd -topology ringN -warm-up 2 -o strong_scaling.csv
        #Let the previous job finish
        sleep 120
    done
done 

for nodes in 1 2 4 8 12
do
    for weak_N in 1536 32768
    do
        curr_N=$(( $weak_N * $nodes ))
        echo "Weak scaling using $nodes nodes and $curr_N particles"
        srun -p fpga -A hpc-lco-kenter --constraint=19.4.0_max -N $nodes --fpgalink=ringN -t 10:00 -l --cpu-bind=cores --ntasks-per-node=1 \
        ./main.out -t lrbd -suffix _no_sync_local_s13 -i lf -order 2 -N $curr_N  -T 30.0 -f_max 243.33 -LPE 4 -RPE 4 -nd -topology ringN -warm-up 2 -o weak_scaling.csv
        #Let the previous job finish
        sleep 120
    done
done 


