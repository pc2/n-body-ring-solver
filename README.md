
[![DOI](https://zenodo.org/badge/356306604.svg)](https://zenodo.org/badge/latestdoi/356306604)
## N-Body Ring Solver FPGA and CPU Implementations

This repository contains a novel design and implementation for distributed FPGA and CPU N-Body solvers. An accompanying publication is in preparation. The benchmarks presented in the paper can be carried out by following the steps below on the [noctua](https://wikis.uni-paderborn.de/pc2doc/Noctua) cluster of [PC²](https://pc2.uni-paderborn.de/). For information on accessing the system, also refer to [this page](https://pc2.uni-paderborn.de/hpc-services/our-services/system-access-application).
For further information on how to use the FPGA and CPU programs, refer to the Readme files in the corresponding directories.

### CPU Benchmarks

Switch to the CPU directory, load the necessary modules and make.

```
cd CPU
source modules.sh
make single_core_bench
make
```

Then, submit the following jobscripts
```
sbatch -A your-account slurm_scripts/single_core_benchmark.sh
sbatch -A your-account slurm_scripts/single_node_benchmark.sh
sbatch -A your-account slurm_scripts/scaling_benchmark.sh
```
Make sure to specify your account. The results of the Benchmarks will be saved to the following csv files: 
- **single_core.csv**
- **single_node_performance.csv**
- **strong_scaling_CPU.csv**
- **weak_scaling_CPU.csv**

To get power consumption measurements, please apply for job-specific monitoring:
https://wikis.uni-paderborn.de/pc2doc/Job-Specific-Monitoring  
The single node benchmark idles 60 seconds between executions with different problem sizes, such that the power consumption data can be related to the executions.
If job-specific monitoring is not accessible, it is sufficient to assume that the power consumption for problem sizes larger than 2048 is in the range of [210W+20W - 300W+20W] for the CPUs+DRAM. For smaller problem sizes the power consumption is more inconsistant, but in the range of [190W+20W - 210W+20W].


### FPGA Benchmarks

Switch to the FPGA directory, load the necessary modules and make.
```
cd FPGA
source modules.sh
make
```
Then, start the hardware synthesis for the FPGA images by submitting the following job scripts:
```
mkdir bin
sbatch -A your-account syn_scripts/syn_lrbd_lf_no_sync_local_2x2_s42.sh
sbatch -A your-account syn_scripts/syn_lrbd_lf_no_sync_local_4x4_s13.sh
sbatch -A your-account syn_scripts/syn_lrbd_lf_sp_8x8L32_s42.sh
```
This will synthesize hardware images for a 2x2, 4x4 solver in double precision and an 8x8 solver in single precision.
Note, that the performance results for the 4x4 solver will deviate from the results shown in the paper. This is due to a different seed used in synthesis. For the image used in the paper no seed was specified and it could not be determined after the fact. Still, the authors would be able to provide the hardware image on request.      
After the hardware synthesis has finished, the single node benchmark can be obtained using the `single_node_experiments.sh` script.
Here, the synthesized implementations will be tested for input sizes ranging from N=128-32768.
```
srun -p fpga -A your-account --constraint=19.4.0_max -N 1 --fpgalink=ringN -t 1:00:00 --pty /bin/bash
exec_scripts/single_node_experiments.sh
exit
```
The results are stored in **single_node.csv**.

The scaling benchmark is carried out by using the `scaling_experiments.sh` script. This will test the strong- and weak scalability of the 4x4PE implementation.
```
exec_scripts/scaling_experiments.sh
```
The results are stored in **weak_scaling.csv** and **strong_scaling.csv**.

The performance for a specific number of nodes for a given input size can be obtained by the following command:
```
srun -p fpga -A your-account --constraint=19.4.0_max -N $nodes --fpgalink=ringN -t 10:00 -l --cpu-bind=cores --ntasks-per-node=1 \
./main.out -t lrbd -suffix _no_sync_local_s13 -i lf -order 2 -N $curr_N  -T 30.0 -f_max 243.33 -LPE 4 -RPE 4 -nd -topology ringN -warm-up 2 -o output.csv
```
Where `$nodes` is the number of requested nodes and `$curr_N` is the input size.

### Accuracy Experiments

Switch back to the CPU directory. The accuracy experiments can be carried out by submitting the following jobscript:
```
sbatch -A hpc-lco-kenter slurm_scripts/accuracy_experiment.sh
```
The result of the force accumulation experiment are stored in the **force-acc.csv** file.   
The result of the ratio dependent analytic system collapse experiment are stored in the **ratio-collapse.csv** file.   

### Plotting
The plotting was done using the scripts and csv files in the **final_results** directory with matplotlib 3.1.2.
The plots are rendered by the following scripts invocations:
```
cd final_results
python3 csvplot_single_core.py single_core.csv 0,0,0,0,0,0,0,0 4,8,10,12,17,18,19,20 0,0,0,0,0,0,0,0 64,64,64,64,64,64,64,64 1 "Single Core Performance" "N" "Effective MPairs/s" "AVX2,AVX512,AVX512RSQRT,AVX512RSQRT4I, est. max. performance"
python3 csvplot_single_node.py single_node_combined.csv 2,3,2,3 4,6,7,10 1,26,1,26 24,44,24,44 0 "Single Node Performance and Efficiency" "N" "Effective MPairs/s" "CPU Performance, FPGA Performance, CPU Efficiency, FPGA Efficiency"
python3 csvplot_designspace.py single_node_designspace.csv 3,3,3,2 6,6,6,4 65,81,97,31 81,97,113,47 0 "Single Node FPGA Variants" "N" "Effective MPairs/s" "FPGA-2x2-DP@308.33MHz, FPGA-4x4-DP@262.50MHz, FPGA-8x8-SP@272.22MHz, CPU-40Core-DP"
python3 csvplot_strong.py strong_scaling.csv 0,0,0,0,0,0 2,2,4,6,4,2 1,20,8,27,13,39 6,25,13,32,18,44 0 "Strong Scaling" "\#Nodes" "Effective MPairs/s" "CPU N=3072, FPGA N=3072, CPU N=6144, FPGA N=6144, CPU N=18432, FPGA N=18432"
python3 csvplot_weak.py weak_scaling.csv 0,0,0,0,0,0 4,6,4,6,6,9 1,13,6,19,6,13 6,18,11,24,11,18 0 "Weak Scaling" "\#Nodes" "Effective MPairs/s" "CPU N=1536  per Node, FPGA N=1536  per Node, CPU  N=32768 per Node, FPGA N=32768 per Node, CPU N=32768 per Node timestep duration, FPGA N=1536 per Node timestep duration"
```
The csvplot script synopsis is:
```
python3 csvplot.py input.csv [list of x-axis columns] [list of y-axis columns] [list of first rows] [list of last rows] ignored "Title" "x-Axis Label" "y-Axis Label" "List of legend entries"
```
The csv files themselves are stitched together from a mixture of CPU and FPGA results and older results, but all results should be reproducible using the CPU and FPGA scripts.


