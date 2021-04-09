### Usage

The repository consists of 3 different programs, which help to understand the achievable performance of an N-Body solver on Noctua compute nodes:
1. micro_bench.out, for micro benchmarking the latency and throughput of AVX2 and AVX512 instruction mixes
2. single_core_bench.out, for testing the performance of the forcepair calculation for various implementation approaches
3. main.out, for a parallelized N-Body solver implemented with either OpenMP, MPI, or a hybrid of both

#### Micro Benchmarking

Adjust benchmark by editing micro_bench.h:
- set **ind_instr**, for increasing the number of instructions with independent register inputs
- set **instr_rep**, for increasing the number of independent instructions executed for each loop iteration
- set **num_iter**, for increasing the runtime by more loop iterations of the same instructions mix

Build program by:
- ```source load_likwid.sh```
- ```make micro_bench```



There are 7 different benchmark types to try out for both 256 bit- and 512 bit instructions:
- sqrt
- div
- fma
- rsqrt 
- invsqrt (calculated by consecutive sqrt and div instructions)
- sqrt+fma (sqrt executed on the first execution port, fma on the second)
- rsqrt+iter (rsqrt + 2 iterative refinement steps)

The benchmark can then be run by:
- ```likwid-perfctr -C 1 -g FLOPS_DP -m ./micro_bench.out -t **BENCHMARK_TYPE** -w **BIT_WIDTH**```

likwid-perfctr collects data about the number of instructions executed, the number of cycles for execution, and the clock frequency at which the instructions are executed.   
Note, that the benchmarks should be executed on a compute node with job-collectors disabled. For this, use:
- ```source reserve_node.sh```

#### Singlecore benchmark

Build program by:
- ```source load_likwid.sh```
- ```make single_core_bench```

The benchmark tests the performance of 5 different forcepair calculation implementations:
- non-vectorized
- AVX2 vectorized
- AVX512 vectorized
- AVX2 using rsqrt
- AVX512 using rsqrt

The performance is always tested for all implementations over a range of problem sizes. Specify this range by the following command-line parameters:
- ```-start (int)```, initial problem sizes
- ```-step (int)```, factor to linearly increment the problem size
- ```-n (int)```, number of incrementations
- ```-o (string)```, name of output file in csv format (default: single_core.csv)

Execution example:
- ```./single_core_bench.out -start 1000 -step 1000 -n 10```
- All implementations are tested with problem sizes [1000,2000,...,10000]. The results are saved to single_core.csv

### Solver Implementations

Build program by:
- ```source load_likwid.sh```
- ```make```

The command-line parameters are:
- ```-N (int)```, problem size
- ```-start (int)```, initial problem sizes
- ```-step (int)```, factor to linearly increment the problem size
- ```-n (int)```, number of incrementations
- ```-o (string)```, name of output file in csv format (default: single_core.csv)
- ```-s (int)```, number of simulation timesteps
- ```-t (string)```, type of benchmark/solver, defaults to OpenMP solver
- ```-i (string)```, integration kind for solver, options are euler(default), leap-frog(lf), runge-kutta(rk)
- ```-order (int)```, integration kind order
- ```-V (string)```, Vectorization, options are AVX2, AVX512, AVX2-RSQRT, AVX512-RSQRT, AVX512-RSQRT-4I, only available for euler integrator

The command line arguments to execute this program depend on the type of the solver. The different types are:
- omp, for the solver
- omp-cache, for a benchmark evaluating a better caching strategy 
- omp-weak, for a weak scaling benchmark over all cores available on a compute node
- omp-strong, for a strong scaling benchmark over all cores available on a compute node
- hybrid, for the hybrid solver
- hybrid-weak, for a weak scaling benchmark over multiple compute nodes
- hybrid-strong, for a strong scaling benchmark over multiple compute nodes

#### OpenMP Solver

The number of cores for each omp program can be specified by the ```OMP_NUM_THREADS=<N>``` environment variable.  
The omp solver uses the ```-t, -N, -s, -i, -order, -V``` command line arguments. 
Example:
- ```env OMP_NUM_THREADS=8 ./main.out -t omp -N 1000 -s 10 -i lf -order 4```
- Execute the omp-solver using 8 threads for s=10 timesteps with a problem size of N=1000 particles using 4th order leapfrog integration   
The performance and energy efficiency on a single socket over a range of problem sizes can also be determined using the basic omp solver and the **slurm_scripts/single_socket_node_benchmark.sh** script. The results are stored in the omp_efficiency.csv file.

The omp-cache benchmark uses the ```-t, -start, -step, -n, -s, -o``` command line arguments. 
Example:
- ```env OMP_NUM_THREADS=40 ./main.out -t omp-cache -start 10000 -step 10000 -n 50 -s 1 -o cache_benchmark.csv```
- Execute the omp-cache benchmark using 40 threads for a single timestep
- Test over a range of N=[10000,20000,...,500000] to see the effects of good and bad cache usage
- The results are stored in cache_benchmark.csv

The omp-weak benchmark uses the ```-t, -N, -s, -o``` command line arguments.
Example:
- ```env OMP_NUM_THREADS=40 ./main.out -t omp-weak -N 5000 -s 1 -o omp_weak_scaling.csv```
- The benchmark is executed for 1 to 40 threads
- The problem size is adjusted to the number of threads as N*#threads
- The results are store in omp_weak_scaling.csv

The omp-strong benchmark uses the ```-t, -N, -s, -o``` command line arguments.
Example:
- ```env OMP_NUM_THREADS=40 ./main.out -t omp-strong -N 250000 -s 1 -o omp_weak_scaling.csv```
- The benchmark is executed for 1 to 40 threads
- The problem size stays fixed at 250000 particles
- The results are store in omp_weak_scaling.csv

#### Hybrid solver

The hybrid solver is a distributed implementation using MPI ranks. Each MPI rank calculates the force pair interactions using the omp-solver. For the balance between MPI ranks and OpenMP threads, srun is used. The solver itself uses the ```-t, -N -s, -V``` command line arguments. Example:
- ```srun -N <#Nodes> -n <#Mpi-ranks> --cpus-per-task=<#Threads-per-rank> --cpu_bind=cores ./main.out -t hybrid -N 10000 -s 10 -V AVX512-RSQRT-4I```
Also specify which account and partition srun should use.

The hybrid solver can also be used for weak- and strong scaling benchmarks. Both benchmarks use the ```-t, -N, -s, -o, -V``` command line arguments. The number of MPI-ranks can not be adjusted from within the solver. Therefore, a job script is used to carry out the benchmark. An example is the **hybrid_multi_node_script.sh** script.
```

For the strong scaling benchmark, make sure **N** is divisible by all tested numbers of MPI ranks. For that, determine the LCM of the set of MPI ranks and use a multiple of that. In case **N** is not divisible by the number of MPI ranks, the execution is skipped. An example for the strong scaling benchmark can also be found in the **hybrid_multi_node_script.sh** script:
```



