### Short Instructions

Connect to noctua and load the following modules: 
- intelFPGA_pro/20.4.0 
- nalla_pcie/19.4.0_max 
- toolchain/gompi/2018b  

Then type make to build the host side executables..
The executables are:
- main.emu
    - used for testing functionality of emulated kernels 
- main.out
    - used for execution of kernels on the FPGA nodes

The kernels follow a specific naming scheme, this scheme is different for emulation and full compilation:
- emulation:
    - ring\_**type**\_**integration**\_**suffix** **#program**.aocx
    - type: either **lrb** or **lrbd** for single device and multi device programs
    - integration: lf (leapfrog)
    - suffix: any additional information; should start with _
    - #program: 0,1, explaination:
        - 2 different programs are required for multi device emulation, due to the emulation of I/O channels
        - I/O channels are emulated as files, 2 are needed to form a ring, as they can only be used as either input or output
        - The channel that is input for the first kernel has to be output for the second kernel and vice versa
        - Therefore, the 2 needed programs differ only in the order in which they access the channels
        - The channel files are named input_0_output_1 and input_1_output_0
        - As the names suggest program0 has input_0_output_1 as its input and input_1_output_0 as its output
    - examples:
        - ring_lrbd_lf_no_sync_local0.aocx (lrbd solver leap frog implementation, program number 0)
        - ring_lrbd_lf_no_sync_local1.aocx (lrbd solver leap frog implementation, program number 1)
- full compilation and synthesis:
    - ring\_**type**\_**LDIMxRDIM**\_**integration**\_**suffix**.aocx
    - type: either **lrb** or **lrbd**
    - #LDIM: Number of PEs in local dimension
    - #RDIM: Number of PEs in remote dimension
    - integration: lf (leapfrog)
    - suffix: any additional information; should start with _
    - examples:
        - ring_lrbd_4x4_lf_no_sync_local.aocx (lrbd solver with 4x4 FCU,)

#### Emulation of solvers
Compile the programs for emulation using
- ```make ring_lrb_lf_no_sync_local```
- ```make ring_lrbd_lf_no_sync_local```

For emulation, the following command line arguments are important:
- -N: number of particles in the system
- -s: number of simulation timesteps
- -nd: no debug; hide debug messages for cleaner output
- -v: verbose; output particle details after simulation
- -i: integration kind; currently only "lf" supported
- -order: order of leapfrog integration; only 2,4,6,8 are supported
- -t: type of the solver (lrb/lrbd)
- -suffix: the suffix string needed for the kernel name

The emulated simulations run on virtual devices on the CPU, which have to be created before execution. For this, set the environment variable CL_CONFIG_CPU_EMULATE_DEVICES=\<N\> to create N virtual devices. The emulation only supports 2 devices, therefore N=2 is enough.

A few examples:  
- Run simulation using lrb solver with 128 particles for 3 timsteps using 2nd leapfrog:  
    - env CL_CONFIG_CPU_EMULATE_DEVICES=1 ./main.emu -t lrb -N 128 -s 3 -i lf -order 2 -suffix _no_sync_local
- Run simulation using lrbd solver with 256 particles for 3 timsteps using 2nd leapfrog:
    - env CL_CONFIG_CPU_EMULATE_DEVICES=2 ./main.emu -t lrbd -N 256 -s 3 -i lf -order 2 -suffix _no_sync_local

If the simulation takes too long and it has to be canceled, make sure to delete the I/O-channel files input_0_output_1 and input_1_output_0. Otherwise, the results of the next simulation may be incorrect.

#### Generating reports and hardware

Reports about resource usage can be generated from the files found in the device/ folder. The parameters for increasing/decreasing the hardware resource usage are the number of PEs in the local and remote dimension.

When increasing the the number of PEs, the variable LOCAL/REMOTE_PE_CNT_ALLOC has to be adjusted to $`2^{ceil(log_2(LOCAL/REMOTE_PE_CNT))}`$. This to ensure a good memory access pattern in the compute kernel.

For report generation use:  
- ```aoc -rtl -ffp-reassoc -ffp-contract=fast device/ring_lrb_lf_no_sync_local.cl -o report_lrb_lf_no_sync_local.aocr -DPE_LOCAL_CNT=3 -DPE_LOCAL_CNT_ALLOC=4 -DPE_REMOTE_CNT=2 -DPE_REMOTE_CNT_ALLOC=2```
- ```aoc -rtl -ffp-reassoc -ffp-contract=fast device/ring_lrbd_lf_no_sync_local.cl -o report_lrbd_lf_no_sync_local.aocr -DPE_LOCAL_CNT=3 -DPE_LOCAL_CNT_ALLOC=4 -DPE_REMOTE_CNT=2 -DPE_REMOTE_CNT_ALLOC=2```


#### Execution on FPGA nodes 
For synthesis use the synthesis scripts in the **syn_scripts** folder

For execution, the number of PEs used and the corresponding operating clock frequency have to be specified by the -LPE and RPE command line argument and the -f_max [in MHz] argument. The execution is carried out by srun by the following commands:

1. Allocate nodes
- srun -p fpga -A your-account --constraint=19.4.0_max -N 1 --fpgalink=ringN -t 1:00:00 --pty /bin/bash
2. Execute program
- srun --ntasks-per-node=1 --cpu-bind=cores -l ./main.out -t lrbd -suffix _no_sync_local -i lf -order 2 -N 3072 -s 10000 -f_max 262.5 -LPE 4 -RPE 4 -nd -topology ringN -warm-up 4

Lastly, for power measurement, the execution has to take more than 5 seconds. Below that, no power measurement is done.

#### Troubleshooting and known issues

2. During emulation the error CL_OUT_OF_RESOURCES might occur. This is most likely due to a too large number of PEs. Adjust it so that the expected number of bytes in local memory is well below the CL_DEVICE_LOCAL_MEM_SIZE attribute.
