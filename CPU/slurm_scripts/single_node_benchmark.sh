#!/bin/bash

#SBATCH -N 1
#SBATCH -J single_node_Nbody_benchmark
#SBATCH -p batch
#SBATCH -t 2:00:00
#SBATCH --recommendations=on

source modules.sh

for curr_N in 128 256 384
do
    curr_S=$((  30 * 300 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 512 768 1024
do
    curr_S=$((  30 * 4000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 1536 2048 3072
do
    curr_S=$((  30 * 16000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 4096 6144 8192
do
    curr_S=$((  30 * 28000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 12288 16384 24576 
do
    curr_S=$((  30 * 42000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 32768 49152 65536
do
    curr_S=$((  30 * 52000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
for curr_N in 98304 131072 196608 262144 393216 524288
do
    curr_S=$((  30 * 58000 * 1000000 / ( $curr_N * $curr_N ) ))
    echo "N = $curr_N"
    echo "S = $curr_S"
    srun --ntasks-per-node=2 --cpu_bind=verbose,sockets ./main.out -t hybrid-strong -N $curr_N -s $curr_S -o single_node_performance.csv -V AVX512-RSQRT-4I
    sleep 60
done
