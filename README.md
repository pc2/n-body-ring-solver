## N-Body Ring Solver FPGA and CPU Implementations

This repository contains implementations of an N-Body

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

To get power consumption data, please apply for job-specific monitoring. The single node benchmark waits 60s between executions with different problem sizes, such that the power consumption data can be related to executions.
If job-specific monitoring is not accessible, it is sufficient to assume that the power consumption for problem sizes larger than 2048 is in the range of [210W+20W - 300W+20W] for CPUs+DRAM. Before that it is somewhat inconsistant, but in the range of [190W+20W - 210W+20W].


### FPGA Benchmarks

Switch to the FPGA directory, load the necessary modules and make.
