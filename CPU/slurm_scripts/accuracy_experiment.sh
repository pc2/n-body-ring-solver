#!/bin/bash

#SBATCH -N 1
#SBATCH -J NBody_accuracy
#SBATCH -p short
#SBATCH -t 30:00
#SBATCH --collectors=off

source modules.sh

#N-Body force accumulation error experiment
env OMP_NUM_THREADS=4 ./main.out -start 1024 -step 2 -n 8 -ratio-start 1e3 -ratio-stop 1e12 -ratio-steps 3 -t omp-accuracy -p dp -o force-acc.csv
env OMP_NUM_THREADS=4 ./main.out -start 1024 -step 2 -n 8 -ratio-start 1e3 -ratio-stop 1e12 -ratio-steps 3 -t omp-accuracy -p sp -o force-acc.csv

#N-Body analytic system collapse expirement
env OMP_NUM_THREADS=4 ./main.out -start 1536 -step 1536 -step 1 -s 3000 -rev-steps 1000 -ratio-start 1e3 -ratio-stop 1e9 -ratio-steps 24 -p dp -t omp-ratio -max-error 0.01 -o ratio-collapse.csv 
env OMP_NUM_THREADS=4 ./main.out -start 1536 -step 1536 -step 1 -s 3000 -rev-steps 1000 -ratio-start 1e3 -ratio-stop 1e9 -ratio-steps 24 -p sp -t omp-ratio -max-error 0.01 -o ratio-collapse.csv 
env OMP_NUM_THREADS=4 ./main.out -start 1536 -step 1536 -step 1 -s 3000 -rev-steps 1000 -ratio-start 1e3 -ratio-stop 1e9 -ratio-steps 24 -p dp -t omp-ratio -max-error 0.001 -o ratio-collapse.csv 
env OMP_NUM_THREADS=4 ./main.out -start 1536 -step 1536 -step 1 -s 3000 -rev-steps 1000 -ratio-start 1e3 -ratio-stop 1e9 -ratio-steps 24 -p sp -t omp-ratio -max-error 0.001 -o ratio-collapse.csv 

