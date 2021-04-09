### Short Instructions

Connect to noctua and load the following modules: 
- intelFPGA_pro/20.1.0 
- nalla_pcie/19.4.0_max 
- toolchain/gompi/2018b  

Then type make to build all necessary programs.
This generates 2 executables along with corresponding opencl kernels, which are compiled for emulation.
The executables are:
- main.emu
    - used for testing functionality of both emulated reduced and full solver kernels 
- main.out
    - used for execution of both reduced and full solver kernels on the FPGA nodes

The kernels follow a specific naming scheme, this scheme is different for emulation and full compilation:
- emulation:
    - ring_**type**_**integration** **suffix** **#kernelnum**.aocx
    - type: either **full** or **red**
    - integration: lf (leapfrog) or euler (can be neglected)
    - suffix: any additional information; should start with _
    - #kernelnum: 0 or 1, explaination:
        - 2 different kernels are required for emulation, due to the emulation of I/O channels
        - I/O channels are emulated as files, 2 are needed to form a ring, as they can only be used as either input or output
        - The channel that is input for the first kernel has to be output for the second kernel and vice versa
        - Therefore, the 2 needed kernels differ only in the order in which they access the channels
        - The channel files are named input_0_output_1 and input_1_output_0
        - As the names suggest kernel0 has input_0_output_1 as its input and input_1_output_0 as its output
    - examples:
        - ring_full0.aocx (full solver implementation, kernel number 0)
        - ring_full_lf1.aocx (full solver leap frog implementation, kernel number 1)
        - ring_red0.aocx (reduced solver implemenation, kernel number 0)
        - ring_red_my_test_implementation1.aocx (reduced solver implemenation testing something as pointed out in the suffix, kernel number 1)
- full compilation:
    - ring_**type**_**#CU**_**integration** **suffix**.aocx
    - type: either **full** or **red**
    - #CU: Number of compute units, should match the number specified in the kernel source
    - integration: lf (leapfrog) or euler (can be neglected)
    - suffix: any additional information; should start with _
    - examples:
        - ring_full_2CU.aocx (full solver with 2 CUs)
        - ring_red_4CU_my_test.aocx (reduced solver with 4 CUs testing something as pointed out in the suffix)

#### Emulation of solvers
For emulation, the following command line arguments are important:
- -N: number of particles in the system
- -s: number of simulation timesteps
- -nd: no debug; hide debug messages for cleaner output
- -v: verbose; output particle details after simulation
- -i: integration kind; currently only "lf" supported, otherwise default to euler integration
- -order: order of leapfrog integration; only 2,4,6,8 are supported
- -t: type of the solver (full/reduced)
- -suffix: the suffix string needed for the kernel name

The emulated simulations run on virtual devices on the CPU, which have to be created before execution. For this, set the environment variable CL_CONFIG_CPU_EMULATE_DEVICES=\<N\> to create N virtual devices. The emulation only supports 2 devices, therefore N=2 is enough.

A few examples:  
- Run simulation using full solver with 100 particles for 100 timsteps:  
    - env CL_CONFIG_CPU_EMULATE_DEVICES=2 ./main.emu -N 100 -s 100 -t full
- Run simulation using full solver with 100 particles for 100 timsteps using 2nd order leapfrog integration:
    - env CL_CONFIG_CPU_EMULATE_DEVICES=2 ./main.emu -N 100 -s 100 -nd -i lf -order 2
- Run simulation using reduced solver with 100 particles for 2 timesteps with special implementation:
    - env 

If the simulation takes too long and it has to be canceled, make sure to delete the I/O-channel files input_0_output_1 and input_1_output_0. Otherwise, the results of the next simulation may be incorrect.

#### Generating reports and hardware

Reports about resource usage can be generated from the files found in the device/ folder. Here, files not ending on 0.cl or 1.cl are meant for report generation and eventually hardware generation. The parameters for increasing/decreasing the hardware resource usage are the number of CUs and the blocksize block_N. Both can be found at the beginning of the .cl files:  
```
#define block_N ((uint)(512))
#define CU 18
#define CU_ALLOC 32
```
For the direct solver kernels, the blocksize block_N does not need to be changed.  
When increasing the the number of CUs, the variable CU_ALLOC has to be adjusted to $`2^{ceil(log_2(CU))}`$. This is necessary because the aoc can only allocate local memory with a number of banks that is a power of 2. (This is also the reason why the RAM usage between the 18 and 20 CU version(thesis table 2) does not significantly increase)

For the reduced solver, block_N has to be increased to $`2^{ceil(log_2(CU * L^2))}`$, where L=30. This ensures that the computation loop takes longer than the accumulation loop. 

Lastly, ivdep directives have to be inserted/deleted when increasing/decreasing the number of CUs. For that, a stack of ivdep directives can be found in the compute_block function. This stack has to be adjusted to the number of CUs. For the direct solver version, two of these stacks have to be adjusted.

In total 5 different files may be used for report and hardware generation:  
- ring_new_sr.cl (direct solver)
- ring_new_sr_lf.cl (direct solver with leapfrog integration)
- ring_new_sr_single_precision.cl (direct solver in single precision to showcase possible speed increase)
- ring_red_new_sr.cl (reduced solver with additional loop for accumulation)
- ring_red_new_sr_unroll.cl (reduced solver with extended outer loop pipeline)

For report generation use:  
- aoc -c device/\<kernel_name\>.cl -I \$INTELFPGAOCLSDKROOT/include/kernel_headers 
- aoc -rtl device/\<kernel_name\>.cl -I \$INTELFPGAOCLSDKROOT/include/kernel_headers 

#### Execution on FPGA nodes 

Synthesized results for the direct solver kernels can be found at /scratch/hpc-lco-kenter/jmenzel/nbody-solver/FPGA/bin/.
In order to test the different versions, create a bin/ folder and copy the kernels ring_new_sr_18CU_s42.aocx, ring_new_sr_16CU.aocx, and ring_new_sr_lf_18CU.aocx into it. Also, remove the _s42 suffix from the 18CU version.

For execution, the number of CUs used and the corresponding operating clock frequency have to be specified by the -CU command line argument and the -f_max [in MHz] argument. The execution is carried out by srun by the following command:

- srun -A hpc-lco-kenter -N #nodes -p fpga --constraint=19.4.0_max --fpgalink=ringN -l --cpu-bind=cores --ntasks-per-node=1 ./full_host_mpi.out -N #particles -s #steps -CU #CU -f_max freq_in_MHz -nd

Sometimes, especially for larger number of nodes, the execution does not finish. If this happens, try a different node list using the srun --nodelist argument.

Lastly, for power measurement, the execution has to take more than 5 seconds. Below that, no power measurement is done.

#### Troubleshooting and known issues

1. The kernel arguments concerning the simulation size are of type uint. Thereby, the maximum simulation size is around 4 million particles.
2. During emulation the error CL_OUT_OF_RESOURCES might occur. This is most likely due to a too large number of CUs or a too large block_N. Adjust both, so that the expected number of bytes in local memory is well below the CL_DEVICE_LOCAL_MEM_SIZE attribute.
