## N-Body Ring Solver FPGA and CPU Implementations

This repository contains the FPGA and CPU N-Body solver implementations presented in the **Scalability and Efficiency of N-Body Simulations on Multiple FPGAs** paper submitted to SC21. The benchmarks presented in the paper can be carried out by following the steps below on the [noctua](https://wikis.uni-paderborn.de/pc2doc/Noctua) cluster of [PC²](https://pc2.uni-paderborn.de/). Besides 
For further information on how to control the FPGA and CPU programs, refer to the corresponding directory Readme files.

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
The single node benchmark waits 60s between executions with different problem sizes, such that the power consumption data can be related to executions.
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
This will synthesize hardware images for a 2x2, 4x4 solver in double precision and a 8x8 solver in single precision.
Note, that the performance results for the 4x4 solver will deviate from the results shown in the paper. This is due to a different seed used in synthesis. For the image used in the paper no seed was specified and it could not be determined after the fact. Still, the authors would be able to provide the hardware image on request.      
After the hardware synthesis finished, the single node benchmark can be obtained by using the `single_node_experiments.sh` script.
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
