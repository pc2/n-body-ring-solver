#!/bin/bash

#SBATCH -J "NBody Reduced LRBD solver single precision syn"
#SBATCH -p fpgasyn
#SBATCH --mem=120000MB
#SBATCH -t 36:00:00

module reset 
module load nalla_pcie/19.4.0_max
module load intelFPGA_pro/20.4.0

aoc -v -board=p520_max_sg280l device/ring_lrbd_lf_sp.cl -global-ring -duplicate-ring -seed=42 -o bin/ring_lrbd_8x8PE_L32_sp_s42.aocx -DPE_LOCAL_CNT=8 -DPE_LOCAL_CNT_ALLOC=8 -DPE_REMOTE_CNT=8 -DPE_REMOTE_CNT_ALLOC=8 -DLATENCY_FACTOR=32
