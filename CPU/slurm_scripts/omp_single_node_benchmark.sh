#!/bin/bash

#SBATCH -N 1
#SBATCH -J single_node_Nbody_benchmark
#SBATCH -A hpc-lco-kenter
#SBATCH -p batch
#SBATCH -t 6:00:00

source load_likwid.sh

echo "N, Performance[MPairs/s], P_total[W], Efficiency[MPairs/s/W]" > omp_efficiency_rsqrt4i.csv

for curr_N in {4096..327680..4096}
do
    echo "N = $curr_N"
    likwid-perfctr -C S0:0-19 -g ENERGY ./main.out -t omp -N $curr_N -s 10 -V AVX512-RSQRT-4I > tmp_out.txt
    POWER=$(grep "Power \[W\] STAT" tmp_out.txt)
    POWER=${POWER#|*|}
    POWER=${POWER%%|*|}
    echo "CPU Power consumption: $POWER W"

    POWER_DRAM=$(grep "Power DRAM \[W\] STAT" tmp_out.txt)
    POWER_DRAM=${POWER_DRAM#|*|}
    POWER_DRAM=${POWER_DRAM%%|*|}
    echo "DRAM Power consumption: $POWER_DRAM W"

    POWER_TOTAL=$(echo "$POWER + $POWER_DRAM" | bc -l)
    echo "Total Power consumption: $POWER_TOTAL W"
    PERFORMANCE=$(grep "Performance:" tmp_out.txt)
    PERFORMANCE=${PERFORMANCE#Performance: }
    PERFORMANCE=${PERFORMANCE%MPairs/s}
    echo "Performance: $PERFORMANCE MPairs/s"
    EFFICIENCY=$(echo "$PERFORMANCE / $POWER_TOTAL" | bc -l)
    echo "Efficiency: $EFFICIENCY MPairs/s/W"
    echo "$curr_N, $PERFORMANCE, $POWER_TOTAL, $EFFICIENCY" >> omp_efficiency_rsqrt4i.csv
    echo " "
done

echo "N, Performance[MPairs/s], P_total[W], Efficiency[MPairs/s/W]" > omp_efficiency_rsqrt.csv

for curr_N in {4096..327680..4096}
do
    echo "N = $curr_N"
    likwid-perfctr -C S0:0-19 -g ENERGY ./main.out -t omp -N $curr_N -s 10 -V AVX512-RSQRT > tmp_out.txt
    POWER=$(grep "Power \[W\] STAT" tmp_out.txt)
    POWER=${POWER#|*|}
    POWER=${POWER%%|*|}
    echo "CPU Power consumption: $POWER W"

    POWER_DRAM=$(grep "Power DRAM \[W\] STAT" tmp_out.txt)
    POWER_DRAM=${POWER_DRAM#|*|}
    POWER_DRAM=${POWER_DRAM%%|*|}
    echo "DRAM Power consumption: $POWER_DRAM W"

    POWER_TOTAL=$(echo "$POWER + $POWER_DRAM" | bc -l)
    echo "Total Power consumption: $POWER_TOTAL W"
    PERFORMANCE=$(grep "Performance:" tmp_out.txt)
    PERFORMANCE=${PERFORMANCE#Performance: }
    PERFORMANCE=${PERFORMANCE%MPairs/s}
    echo "Performance: $PERFORMANCE MPairs/s"
    EFFICIENCY=$(echo "$PERFORMANCE / $POWER_TOTAL" | bc -l)
    echo "Efficiency: $EFFICIENCY MPairs/s/W"
    echo "$curr_N, $PERFORMANCE, $POWER_TOTAL, $EFFICIENCY" >> omp_efficiency_rsqrt.csv
    echo " "
done

echo "N, Performance[MPairs/s], P_total[W], Efficiency[MPairs/s/W]" > omp_efficiency.csv

for curr_N in {4096..327680..4096}
do
    echo "N = $curr_N"
    likwid-perfctr -C S0:0-19 -g ENERGY ./main.out -t omp -N $curr_N -s 10 -V AVX2 > tmp_out.txt
    POWER=$(grep "Power \[W\] STAT" tmp_out.txt)
    POWER=${POWER#|*|}
    POWER=${POWER%%|*|}
    echo "CPU Power consumption: $POWER W"

    POWER_DRAM=$(grep "Power DRAM \[W\] STAT" tmp_out.txt)
    POWER_DRAM=${POWER_DRAM#|*|}
    POWER_DRAM=${POWER_DRAM%%|*|}
    echo "DRAM Power consumption: $POWER_DRAM W"

    POWER_TOTAL=$(echo "$POWER + $POWER_DRAM" | bc -l)
    echo "Total Power consumption: $POWER_TOTAL W"
    PERFORMANCE=$(grep "Performance:" tmp_out.txt)
    PERFORMANCE=${PERFORMANCE#Performance: }
    PERFORMANCE=${PERFORMANCE%MPairs/s}
    echo "Performance: $PERFORMANCE MPairs/s"
    EFFICIENCY=$(echo "$PERFORMANCE / $POWER_TOTAL" | bc -l)
    echo "Efficiency: $EFFICIENCY MPairs/s/W"
    echo "$curr_N, $PERFORMANCE, $POWER_TOTAL, $EFFICIENCY" >> omp_efficiency.csv
    echo " "
done