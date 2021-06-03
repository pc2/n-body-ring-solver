#!/bin/bash
#SBATCH -N 4
#SBATCH -p fpga
#SBATCH -A hpc-lco-kenter
#SBATCH -t 30:00
#SBATCH --constraint=emul

source modules.sh

for strong_N in 3072 6144 18432 
do
    for nodes in 1 2 4 #8 12
    do
        num_tasks=$(( 2 * $nodes ))
        srun -N $nodes -n $num_tasks --cpu_bind=verbose,sockets ./main.out -N $strong_N -s 10000 -t hybrid-strong -o "strong_scaling_CPU.csv" -V AVX512-RSQRT-4I
    done
done

for weak_N in 1536 32768
do
    for nodes in 1 2 4 #8 12
    do
        #Determine baseline for weak scaling
        num_tasks=$(( 2 * $nodes ))
        curr_N=$(( $weak_N * $nodes ))
        single_performance=0
        if [[ "$weak_N" == "1536" ]]
        then
            single_performance=12
        elif [[ "$weak_N" == "32768" ]]
        then
            single_performance=50000
        else
            single_performance=50000
        fi
        
        curr_S=$((  $nodes * 30 * $single_performance * 1000000 / ( $curr_N * $curr_N ) ))
        echo "nodes: $nodes, tasks: $num_tasks, curr_N: $curr_N, curr_S: $curr_S"
        srun -N $nodes -n $num_tasks --cpu_bind=verbose,sockets ./main.out -N $curr_N -s $curr_S -t hybrid-strong -o "weak_scaling_CPU.csv" -V AVX512-RSQRT-4I
    done
done
