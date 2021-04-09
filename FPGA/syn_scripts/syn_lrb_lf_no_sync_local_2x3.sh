#!/bin/bash

#SBATCH -J "NBody Reduced LRB solver first synthesis"
#SBATCH -A hpc-lco-kenter
#SBATCH -p fpgasyn
#SBATCH --mem=120000MB
#SBATCH -t 48:00:00

module reset 
module load nalla_pcie/19.4.0_max
module load intelFPGA_pro/20.2.0

aoc -v -board=p520_max_sg280l device/ring_lrb_lf_no_sync_local.cl -global-ring -duplicate-ring -profile -ffp-reassoc -ffp-contract=fast -o bin/ring_lrb_lf_no_sync_local.aocx
