#!/bin/bash

source modules.sh

srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s42 -i lf -order 2 -start 128 -step 128   -n 32 -f_max 286    -LPE 1 -RPE 1 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0
srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s42 -i lf -order 2 -start 4096 -step 2048 -n 14 -f_max 286    -LPE 1 -RPE 1 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0

srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s42 -i lf -order 2 -start 128 -step 128   -n 32 -f_max 308.33 -LPE 2 -RPE 2 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0
srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s42 -i lf -order 2 -start 4096 -step 2048 -n 14 -f_max 308.33 -LPE 2 -RPE 2 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0

srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s13 -i lf -order 2 -start 128 -step 128   -n 32 -f_max 243.33  -LPE 4 -RPE 4 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0
srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _no_sync_local_s13 -i lf -order 2 -start 4096 -step 2048 -n 14 -f_max 243.33  -LPE 4 -RPE 4 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0

srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _L32_sp_s42        -i lf -order 2 -start 128 -step 128   -n 32 -f_max 272.22 -LPE 8 -RPE 8 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0
srun -l --cpu-bind=cores --ntasks-per-node=1 ./main.out -t lrbd -suffix _L32_sp_s42        -i lf -order 2 -start 4096 -step 2048 -n 14 -f_max 272.22 -LPE 8 -RPE 8 -nd -topology ringN -warm-up 2 -o single_node.csv -T 10.0
