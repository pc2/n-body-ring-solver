#!/bin/bash

#SBATCH -J "NBody Reduced LRBD solver first synthesis"
#SBATCH -p fpgasyn
#SBATCH --mem=120000MB
#SBATCH -t 36:00:00

module reset 
module load nalla_pcie/19.4.0_max
module load intelFPGA_pro/20.4.0

aoc -v -board=p520_max_sg280l device/ring_lrbd_lf_no_sync_local.cl -global-ring -duplicate-ring -ffp-reassoc -ffp-contract=fast -seed=42 -o bin/ring_lrbd_4x4PE_lf_no_sync_local_s42.aocx -DPE_LOCAL_CNT=4 -DPE_LOCAL_CNT_ALLOC=4 -DPE_REMOTE_CNT=4 -DPE_REMOTE_CNT_ALLOC=4
