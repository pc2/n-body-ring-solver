#!/bin/bash

source load_likwid.sh

for weak_N in 2048
do
    #Determine baseline for weak scaling
    #srun -n 1 --cpu_bind=cores --cpus-per-task=1 ./main.out -N $weak_N -s 10 -t hybrid-weak -o "hybrid_weak_full_N${weak_N}.csv" -S full
    #Run weak scaling benchmark for all #ranks which are multiples of 8
    #for ranks in {8..80..8}
    #do
    #    srun -n $ranks --cpu_bind=cores --cpus-per-task=1 ./main.out -N $weak_N -s 10 -t hybrid-weak -o "hybrid_weak_full_N${weak_N}.csv" -S full
    #done

    #Determine baseline for weak scaling
    #srun -N 1 -n 1 --cpu_bind=verbose,sockets --cpus-per-task=20 ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I
    #srun -N 1 -n 2 --cpu_bind=verbose,sockets --cpus-per-task=20 ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I
    #srun -N 2 -n 4 --cpu_bind=verbose,sockets --cpus-per-task=20 ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I

    srun -N 1 -n 1 --cpu_bind=verbose,sockets ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I
    srun -N 1 -n 2 --cpu_bind=verbose,sockets ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I
    srun -N 2 -n 4 --cpu_bind=verbose,sockets ./main.out -N $weak_N -s 5 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}_rsqrt4i.csv" -V AVX512-RSQRT-4I
    #Run weak scaling benchmark for all #ranks which are multiples of 8
    #for ranks in {2..4..2}
    #do
    #    srun -n $ranks --cpu_bind=sockets --cpus-per-task=20 ./main.out -N $weak_N -s 10 -t hybrid-weak -o "hybrid_weak_red_N${weak_N}.csv"
    #done
done

exit

for strong_N in 20160 40320 60480 100800
do
    #Determine baseline for weak scaling
    #srun -n 1 --cpu_bind=cores --cpus-per-task=1 ./main.out -N $strong_N -s 10 -t hybrid-strong -o "hybrid_strong_full_N${stong_N}.csv" -S full
    #Run weak scaling benchmark for all #ranks which are multiples of 8
    #for ranks in {8..80..8}
    #do
    #    srun -n $ranks --cpu_bind=cores --cpus-per-task=1 ./main.out -N $strong_N -s 10 -t hybrid-strong -o "hybrid_strong_full_N${strong_N}.csv" -S full
    #done

    #Determine baseline for weak scaling
    srun -n 1 --cpu_bind=sockets --cpus-per-task=20 ./main.out -N $strong_N -s 10 -t hybrid-strong -o "hybrid_strong_red_N${strong_N}.csv"
    #Run weak scaling benchmark for all #ranks which are multiples of 8
    for ranks in {8..80..8}
    do
        srun -n $ranks --cpu_bind=sockets --cpus-per-task=20 ./main.out -N $strong_N -s 10 -t hybrid-strong -o "hybrid_strong_red_N${strong_N}.csv"
    done
done
