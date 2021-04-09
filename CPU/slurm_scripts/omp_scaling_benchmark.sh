#!/bin/bash

#SBATCH -N 1
#SBATCH -J single_core_Nbody_benchmark
#SBATCH -A hpc-lco-kenter
#SBATCH -p batch
#SBATCH -t 2:00:00

#source load_likwid.sh
module load toolchain/gompi

#Cache Benchmark
#env OMP_NUM_THREADS=40 ./main.out -t omp-cache -start 10000 -step 10000 -n 50 -s 10 -o cache_benchmark.csv

#Weak scaling Benchmark
env OMP_NUM_THREADS=40 ./main.out -t omp-weak -N 2048 -s 10 -o omp_weak_scaling_rsqrt.csv -V AVX512-RSQRT
env OMP_NUM_THREADS=40 ./main.out -t omp-weak -N 2048 -s 10 -o omp_weak_scaling_rsqrt_4I.csv -V AVX512-RSQRT-4I

#Strong scaling Benchmark
env OMP_NUM_THREADS=40 ./main.out -t omp-strong -N 65536 -s 10 -o omp_strong_scaling_rsqrt.csv -V AVX512-RSQRT
env OMP_NUM_THREADS=40 ./main.out -t omp-strong -N 65536 -s 10 -o omp_strong_scaling_rsqrt_4I.csv -V AVX512-RSQRT-4I
