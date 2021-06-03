#!/bin/bash

#SBATCH -N 1
#SBATCH -J single_core_Nbody_benchmark
#SBATCH -A hpc-lco-kenter
#SBATCH -p short
#SBATCH -t 30:00
#SBATCH --collectors=off

source modules.sh

likwid-pin -C 1 ./single_core_bench.out -start 128 -step 128 -n 128

