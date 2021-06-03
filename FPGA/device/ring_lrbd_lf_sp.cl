#pragma OPENCL EXTENSION cl_intel_channels : enable

#define ZERO 0.f

//Struct with valid bit lead to a bad access pattern for b_remote_particles, also 512b were used
//Use compact float4 instead: xyz are the position, w the coefficient, if w == 0.0 the particle is invalid
typedef float4 particle_t;

typedef float3 force_t;
#define PE_LOCAL_SIZE 2
#define PE_REMOTE_SIZE 2

// only 2x2 PEs for reduced solver implemented
// alternative implementation could provide 1x1 PEs for full solver

#ifdef DBG_PRINT
#else
    #define printf(fmt,...) (0)
#endif

#ifdef COMPILE_EMULATION 

    //Always choose PE_LOCAL_CNT >= PE_REMOTE_CNT
    #define PE_LOCAL_CNT 8
    #define PE_LOCAL_CNT_ALLOC 8
    #define PE_REMOTE_CNT 8
    #define PE_REMOTE_CNT_ALLOC 8

    #define PE_LOCAL_PROD (PE_LOCAL_SIZE * PE_LOCAL_CNT)
    #define PE_REMOTE_PROD (PE_REMOTE_SIZE * PE_REMOTE_CNT)

    #define LATENCY_FACTOR 8
    #define LOCAL_BLOCK_SIZE (LATENCY_FACTOR * PE_LOCAL_PROD)
    #define REMOTE_BLOCK_SIZE (LATENCY_FACTOR * PE_REMOTE_PROD)

    #define PRELOAD_REMOTE_BLOCKS 2
    #define PRELOAD_REMOTE_SIZE (PRELOAD_REMOTE_BLOCKS * REMOTE_BLOCK_SIZE)

    #ifdef EMULATION0
        channel float8 io_chan_input_part   __attribute__((io("input_0_output_3_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_output_part  __attribute__((io("input_1_output_0_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_input_force  __attribute__((io("input_0_output_3_force"), depth(REMOTE_BLOCK_SIZE)));
        channel float8 io_chan_output_force __attribute__((io("input_1_output_0_force"), depth(REMOTE_BLOCK_SIZE)));
    #elif EMULATION1
        channel float8 io_chan_input_part   __attribute__((io("input_1_output_0_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_output_part  __attribute__((io("input_2_output_1_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_input_force  __attribute__((io("input_1_output_0_force"), depth(REMOTE_BLOCK_SIZE)));
        channel float8 io_chan_output_force __attribute__((io("input_2_output_1_force"), depth(REMOTE_BLOCK_SIZE)));
    #elif EMULATION2
        channel float8 io_chan_input_part   __attribute__((io("input_2_output_1_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_output_part  __attribute__((io("input_3_output_2_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_input_force  __attribute__((io("input_2_output_1_force"), depth(REMOTE_BLOCK_SIZE)));
        channel float8 io_chan_output_force __attribute__((io("input_3_output_2_force"), depth(REMOTE_BLOCK_SIZE)));
    #elif EMULATION3
        channel float8 io_chan_input_part   __attribute__((io("input_3_output_2_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_output_part  __attribute__((io("input_0_output_3_part"), depth(PRELOAD_REMOTE_SIZE)));
        channel float8 io_chan_input_force  __attribute__((io("input_3_output_2_force"), depth(REMOTE_BLOCK_SIZE)));
        channel float8 io_chan_output_force __attribute__((io("input_0_output_3_force"), depth(REMOTE_BLOCK_SIZE)));
    #endif
#else
    //Always choose PE_LOCAL_CNT >= PE_REMOTE_CNT
    #ifndef PE_LOCAL_CNT
        #define PE_LOCAL_CNT 3
    #endif
    #ifndef PE_LOCAL_CNT_ALLOC
        #define PE_LOCAL_CNT_ALLOC 4
    #endif
    #ifndef PE_REMOTE_CNT
        #define PE_REMOTE_CNT 2
    #endif
    #ifndef PE_REMOTE_CNT_ALLOC
        #define PE_REMOTE_CNT_ALLOC 2
    #endif

    #define PE_LOCAL_PROD (PE_LOCAL_SIZE * PE_LOCAL_CNT)
    #define PE_REMOTE_PROD (PE_REMOTE_SIZE * PE_REMOTE_CNT)
    #ifndef LATENCY_FACTOR
        #define LATENCY_FACTOR 8
    #endif
    #define LOCAL_BLOCK_SIZE (LATENCY_FACTOR * PE_LOCAL_PROD)
    #define REMOTE_BLOCK_SIZE (LATENCY_FACTOR * PE_REMOTE_PROD)
    
    #define PRELOAD_REMOTE_BLOCKS 2
    #define PRELOAD_REMOTE_SIZE (PRELOAD_REMOTE_BLOCKS * REMOTE_BLOCK_SIZE)

    channel float8 io_chan_input_part    __attribute__((io("kernel_input_ch0"), depth(PRELOAD_REMOTE_SIZE)));
    channel float8 io_chan_output_part   __attribute__((io("kernel_output_ch1"), depth(PRELOAD_REMOTE_SIZE)));
    channel float8 io_chan_input_force   __attribute__((io("kernel_input_ch2"), depth(REMOTE_BLOCK_SIZE)));
    channel float8 io_chan_output_force  __attribute__((io("kernel_output_ch3"), depth(REMOTE_BLOCK_SIZE)));
#endif



#define MAX_N 16384
#define MAX_LOCAL_BLOCKS (1 +((MAX_N-1)/LOCAL_BLOCK_SIZE))
#define MAX_REMOTE_BLOCKS (1 + ((MAX_N-1)/REMOTE_BLOCK_SIZE))
#define MAX_LOCAL_N (MAX_LOCAL_BLOCKS*LOCAL_BLOCK_SIZE)
#define MAX_REMOTE_N (MAX_REMOTE_BLOCKS*REMOTE_BLOCK_SIZE)

#define MAX_LF_COEFFICIENTS 512



// aggregate struct as return type of 2x2 PE
typedef struct force_quad{
    force_t local_force[PE_LOCAL_SIZE];
    force_t remote_force[PE_REMOTE_SIZE];
} force_quad_t;

channel particle_t          chan_remote_particle_buffer_to_compute        __attribute__((depth(PRELOAD_REMOTE_SIZE)));
channel particle_t          chan_local_particle_buffer_to_compute        __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_compute_to_local_force_cache             __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_compute_to_remote_force_cache            __attribute__((depth(REMOTE_BLOCK_SIZE)));
channel force_t             chan_local_force_cache_to_integrator          __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_remote_force_comm_to_integrator          __attribute__((depth(REMOTE_BLOCK_SIZE)));
channel particle_t          chan_integrator_to_local_particle_buffer      __attribute__((depth(MAX_N)));
channel particle_t          chan_integrator_to_remote_particle_buffer     __attribute__((depth(REMOTE_BLOCK_SIZE)));
channel force_t             chan_remote_force_comm_to_remote_force_cache  __attribute__((depth(REMOTE_BLOCK_SIZE)));




/* 
***********************************************************************  GENERAL KERNEL COMMUNICATION STRUCTURE **********************************************************************************

––––––––––––––––––––                –––––––––––––––––––––––                  ______________________________                 –––––––––––––––––––––––                 ______________________________
|                  |                |                     |                  |                            |                 |                     |                 |                            |
| Integrator at t  | -------------> | Remote part buffer  | ---------------> |                            |---------------> | Remote force cache  | --------------->|                            |
|––––––––––––––––––|                |–––––––––––––––––––––|                  |                            |                 |–––––––––––––––––––––|                 |                            |
                     \                                                       |                            |                                                         |                            |
                      \                                                      |                            |                                                         |                            |
                       \                                                     |          Compute           |                                                         |          Integrator        |
                        \                                                    |                            |                                                         |            at t+1          |
                         \           –––––––––––––––––––––––                 |                            |                 –––––––––––––––––––––––                 |                            |
                          \          |                     |                 |                            |                 |                     |                 |                            |
                           --------> | Local part buffer   | --------------->|                            |---------------> | Local force cache   | --------------->|                            |
                                     |–––––––––––––––––––––|                 |____________________________|                 |–––––––––––––––––––––|                 |____________________________|



*/

// return force between two particles or 0 if one of the particles is invalid
force_t compute_pair(
                particle_t local_particle,
                particle_t remote_particle,
                bool eq_cond)
{
    //printf("Computing pair: local = [%f,%f,%f,%f], remote = [%f,%f,%f,%f]\n", local_particle.x, local_particle.y, local_particle.z, local_particle.w,remote_particle.x, remote_particle.y, remote_particle.z, remote_particle.w);
    float3 diff = remote_particle.xyz - local_particle.xyz;
    float dist = rsqrt(diff.x * diff.x + diff.y * diff.y + diff.z*diff.z);
    float3 result = local_particle.w * remote_particle.w * (dist*dist*dist) * diff;
    return (local_particle.w != 0.0 && remote_particle.w != 0.0 && !eq_cond) ? result : ZERO;
}

// aggregate 2x2 PE for reduced solver, performs only 2 out of 4 calculations
force_quad_t PE_2x2(particle_t p_l[2], particle_t p_o[2], bool lr_cond, bool eq_cond)
{
    // compute forces with selected inputs
    // either l0 x r0 and l0 x r1
    // or     l0 x r1 and l1 x r1
    force_t forces[2] __attribute__((register));
    forces[0] = compute_pair(p_l[0], lr_cond ? p_o[0] : p_o[1], false);
    forces[1] = compute_pair(lr_cond ? p_l[0] : p_l[1], p_o[1], eq_cond);

    // one of the results will use a local reduction
    force_t force_sum = forces[0] + forces[1];

    // two quadrants return individual forces
    // one quadrant returns the sum
    // one quadrant returns ZERO
    force_quad_t force_out __attribute__((register));
    // local forces
    force_out.local_force[0] = lr_cond ? force_sum : forces[0];
    force_out.local_force[1] = lr_cond ? ZERO      : forces[1];
    // remote forces
    force_out.remote_force[0] = lr_cond ? forces[0] : ZERO;
    force_out.remote_force[1] = lr_cond ? forces[1] : force_sum;
    return force_out;
}

__kernel void compute_forces(
                             const uint local_N,
                             const uint remote_N,
                             const uint rank,
                             const uint comm_sz,
                             const uint steps,
                             const uint lf_steps
                             )
{
    printf("Started Compute Kernel\n");
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    const uint l_dev_offset = rank*local_N;
    
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps * (lf_steps-1); s++)
    {
        //printf("1:Starting new compute iteration\n");
        // process complete remote block before using the next one
        for(uint dev = 0;dev < comm_sz;dev++)
        {
            uint r_dev_offset = ((rank - dev + comm_sz) % comm_sz)*remote_N;
            for(uint r_block=0; r_block<r_block_max; r_block++)
            {
                uint r_base = r_block * REMOTE_BLOCK_SIZE;
                //printf("r_base: %u, r_block: %u\n", r_base, r_block);
                // replicated local memory
                // memory depth is only LATENCY_FACTOR, rest is banked
                #ifdef COMPILE_EMULATION
                particle_t    b_remote_particles[LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE] = {nan((ulong)0)};
                #else
                particle_t    b_remote_particles[LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE];
                #endif

                // R1: load remote particles
                for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
                {
                    b_remote_particles[rr/PE_REMOTE_PROD][(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT][rr%PE_REMOTE_SIZE] = read_channel_intel(chan_remote_particle_buffer_to_compute);
                    particle_t p = b_remote_particles[rr/PE_REMOTE_PROD][(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT][rr%PE_REMOTE_SIZE];
                    //if(p.w != 0.0)
                    //    printf("Remote[%u][%u][%u] = { pos: [%f,%f,%f] , coeff: %f }\n",rr/PE_REMOTE_PROD, (rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT, rr%PE_REMOTE_SIZE, p.x, p.y, p.z, p.w);
                    //else
                    //    printf("Remote[%u][%u][%u] = invalid\n",rr/PE_REMOTE_PROD, (rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT, rr%PE_REMOTE_SIZE);
                }
                // R2: all local blocks for one remote block
                for(uint l_block=0; l_block<l_block_max; l_block++)
                {
                    uint l_base = l_block * LOCAL_BLOCK_SIZE;
                    //printf("l_base: %u, l_block: %u\n", l_base, l_block);
                    // replicated local memory
                    // memory depth is only LATENCY_FACTOR, rest is banked
                    #ifdef COMPILE_EMULATION
                    particle_t          b_local_particles[LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE] = {nan((ulong)0)};
                    float3             b_local_forces   [LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE] = {nan((ulong)0)};
                    float3             b_remote_forces   [LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE] = {nan((ulong)0)};
                    #else
                    particle_t          b_local_particles[LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE];
                    float3             b_local_forces   [LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE];
                    float3             b_remote_forces   [LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE];
                    #endif

                    // L1: load local particles
                    for(uint ll=0; ll<LOCAL_BLOCK_SIZE; ++ll)
                    {
                        uint l_global = l_base + ll;
                        b_local_particles[ll/PE_LOCAL_PROD][(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT][ll%PE_LOCAL_SIZE] = read_channel_intel(chan_local_particle_buffer_to_compute);
                        particle_t p = b_local_particles[ll/PE_LOCAL_PROD][(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT][ll%PE_LOCAL_SIZE];
                        //if(p.w != 0.0)
                        //    printf("Local[%u][%u][%u] = { pos: [%f,%f,%f] , coeff: %f }\n",ll/PE_LOCAL_PROD, (ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT, ll%PE_LOCAL_SIZE, p.x, p.y, p.z, p.w);
                        //else
                        //    printf("Local[%u][%u][%u] = invalid\n",ll/PE_REMOTE_PROD, (ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT, ll%PE_LOCAL_SIZE);

                    }

                    // L2: compute block in diagonal+shift order, l_part updated and end of loop
                    /* example 4x4
                        l0 l1 l2 l3
                    r0  0  4  8 12
                    r1 13  1  5  9
                    r2 10 14  2  6
                    r3  7 11 15  3
                    */
                    //#pragma ivdep
                    #pragma ivdep safelen(LATENCY_FACTOR-1)
                    // Achieves II 1 at 8 with estimated 349.92 MHz, recommend somewhat higher factor
                    for(uint bb=0, l_part=0; bb<LATENCY_FACTOR*LATENCY_FACTOR; ++bb)
                    {
                        uint o_part = bb % LATENCY_FACTOR;
                        // compute forces in PEs
                        
                        #ifdef COMPILE_EMULATION
                        force_quad_t pe_force_quads[PE_LOCAL_CNT][PE_REMOTE_CNT] = {nan((ulong)0)};
                        #else
                        force_quad_t pe_force_quads[PE_LOCAL_CNT][PE_REMOTE_CNT];
                        #endif
                        //printf("Quad[%u][%u]\n",r_block * PE_REMOTE_PROD + o_part, l_block * PE_LOCAL_PROD + l_part);
                        #pragma unroll
                        for(int l=0; l<PE_LOCAL_CNT; l++)
                        {
                            #pragma unroll
                            for(int o=0; o<PE_REMOTE_CNT; o++)
                            {
                                // TODO: verify condition, current take is that since bb iterates through corresponding sub-partitions, can ignore it or derived values l_part / o_part
                                uint ll = l_dev_offset + l_base + l_part * PE_LOCAL_PROD  + l * PE_LOCAL_SIZE;
                                uint rr = r_dev_offset + r_base + o_part * PE_REMOTE_PROD + o * PE_REMOTE_SIZE;

                                //if(ll < local_N && rr < remote_N)
                                //printf("[l%u l%u] x [r%u r%u]\n",ll,ll+1,rr,rr+1);

                                bool lr_cond = ll < rr;
                                bool eq_cond = ll == rr;
                                pe_force_quads[l][o] = PE_2x2(b_local_particles[l_part][l],
                                                            b_remote_particles[o_part][o],
                                                            lr_cond,
                                                            eq_cond);
                                float3 ql0 = pe_force_quads[l][o].local_force[0];
                                float3 ql1 = pe_force_quads[l][o].local_force[1];
                                float3 qr0 = pe_force_quads[l][o].remote_force[0];
                                float3 qr1 = pe_force_quads[l][o].remote_force[1];
                                //if(ll < local_N && rr < remote_N)
                                //printf("[%.13f,%.13f,%f , %.13f,%.13f,%f]\n[%.13f,%.13f,%f , %.13f,%.13f,%f]\n", ql0.x, ql0.y,ql0.z, ql1.x,ql1.y,ql1.z, qr0.x,qr0.y,qr0.z, qr1.x,qr1.y,qr1.z);
                            }
                        }
                        // reduce over PEs here
                        // example 4x4 PE_2x2: reduction over 64*3 floats
                        float3 pe_local_forces[PE_LOCAL_CNT][PE_LOCAL_SIZE] = {ZERO};
                        float3 pe_remote_forces[PE_REMOTE_CNT][PE_REMOTE_SIZE] = {ZERO};
                        #pragma unroll
                        for(int l=0; l<PE_LOCAL_CNT; l++)
                        {
                            #pragma unroll
                            for(int o=0; o<PE_REMOTE_CNT; o++)
                            {
                                #pragma unroll
                                for(int ll=0; ll<PE_LOCAL_SIZE; ll++)
                                {
                                    pe_local_forces[l][ll] += pe_force_quads[l][o].local_force[ll];
                                }
                                #pragma unroll
                                for(int oo=0; oo<PE_REMOTE_SIZE; oo++)
                                {
                                    pe_remote_forces[o][oo] += pe_force_quads[l][o].remote_force[oo];
                                }
                            }
                        }
                        // accumulate forces inside block
                        #pragma unroll
                        for(int l=0; l<PE_LOCAL_CNT; l++)
                        {
                            #pragma unroll
                            for(int ll=0; ll<PE_LOCAL_SIZE; ll++)
                            {
                                b_local_forces[l_part][l][ll] =
                                    (bb < LATENCY_FACTOR) ? pe_local_forces[l][ll]
                                                            : b_local_forces[l_part][l][ll] + pe_local_forces[l][ll];
                            }
                        }
                        #pragma unroll
                        for(int o=0; o<PE_REMOTE_CNT; o++)
                        {
                            #pragma unroll
                            for(int oo=0; oo<PE_REMOTE_SIZE; oo++)
                            {
                                b_remote_forces[o_part][o][oo] =
                                    bb < LATENCY_FACTOR ? pe_remote_forces[o][oo]
                                                        : b_remote_forces[o_part][o][oo] + pe_remote_forces[o][oo];
                            }
                        }
                        // shift-wrap l_part
                        bool wrap = (bb % LATENCY_FACTOR == LATENCY_FACTOR -1);
                        l_part = wrap ? (l_part+2) % LATENCY_FACTOR : (l_part+1) % LATENCY_FACTOR;
                    }

                    // L3: accumulate local forces to global cache
                    for(uint ll=0; ll<LOCAL_BLOCK_SIZE; ll++)
                    {
                        write_channel_intel(chan_compute_to_local_force_cache, b_local_forces[ll/PE_LOCAL_PROD]
                                                                                [(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT]
                                                                                [ll%PE_LOCAL_SIZE]);
                    }
                    // L3/R3: accumulate remote forces in remote kernel
                    for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
                    {
                        write_channel_intel(chan_compute_to_remote_force_cache, b_remote_forces[rr/PE_REMOTE_PROD]
                                                                                    [(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT]
                                                                                    [rr%PE_REMOTE_SIZE]);
                    }
                }
            }
        }
    }
}


__kernel void local_particle_buffer(__global particle_t* restrict g_local_part,
                               const uint local_N,
                               const uint remote_N,
                               const uint rank,
                               const uint comm_sz,
                               const uint steps,
                               const uint lf_steps
                              )
{
    printf("Started Local Particle Buffer Kernel\n");
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);


    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        
        #ifdef COMPILE_EMULATION
        particle_t local_part[MAX_LOCAL_N] = {nan((ulong)0)};
        uint l_channel_in_count = 0;
        uint l_channel_out_count = 0;
        #else
        particle_t local_part[MAX_LOCAL_N];
        #endif
        #pragma loop_coalesce 3
        for(uint r_block=0; r_block<r_block_max*comm_sz; r_block++)
        {
            for(uint l_block=0; l_block<l_block_max; l_block++)
            {
                uint l_base = l_block*LOCAL_BLOCK_SIZE;
                for(uint ll = 0;ll < LOCAL_BLOCK_SIZE;ll++)
                {
                    uint l_global = l_base + ll;
                    #ifdef COMPILE_EMULATION
                    particle_t part = nan((ulong)0);
                    #else
                    particle_t part;
                    #endif
                    //Phase 1: Read in all forwarded particles from remote particle buffer
                    if(r_block == 0)
                    {
                        //printf("local buffer: receiving part[%u]\n",l_global);
                        part = l_global < local_N ? read_channel_intel(chan_integrator_to_local_particle_buffer) : ZERO;
                        local_part[l_global] = part;
                        #ifdef COMPILE_EMULATION
                        if(l_global < local_N)l_channel_in_count++;
                        #endif
                    }
                    //Phase 2: Use previously streamed in particles
                    else 
                        part = local_part[l_global];

                    particle_t forward_part;
                    bool valid = l_global < local_N;
                    forward_part = valid ? part : ZERO;
                    write_channel_intel(chan_local_particle_buffer_to_compute, forward_part);
                    #ifdef COMPILE_EMULATION
                    l_channel_out_count++;
                    #endif
                    //printf("Local Particle Buffer: Forwarding particle[%u]\n", l_global);
                }
            }
        }
        printf("Local Particle buffer:  timestep = %u, channel_reads = %u, channel_writes = %u\n", s, l_channel_in_count, l_channel_out_count);
    }
    printf("Finished local particle buffer\n");
}

__kernel void remote_particle_buffer(__global particle_t* restrict g_remote_particle,
                                     const uint local_N,
                                     const uint remote_N,
                                     const uint rank,
                                     const uint comm_sz,
                                     const uint steps,
                                     const uint lf_steps
                                     )
{
    printf("Started Remote Particle Buffer Kernel\n");
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    const uint r_preload = PRELOAD_REMOTE_BLOCKS * REMOTE_BLOCK_SIZE;
    const uint r_req = r_block_max * REMOTE_BLOCK_SIZE;
    const uint r_max = max(r_block_max * REMOTE_BLOCK_SIZE, r_preload);
    const uint total_trips = r_max * (comm_sz+1) - r_preload;
    const uint r_buffer_max = r_max - r_preload;
    printf("r_preload = %u, r_req = %u, r_max = %u, r_buffer_max = %u\n",r_preload, r_req, r_max, r_buffer_max);
    
    //Second approach
    //Recv directly from integrator and forward to local pos buffer
    //#pragma disable_loop_pipelinin
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        #ifdef COMPILE_EMULATION
        particle_t remote_part[MAX_REMOTE_N] = {nan((ulong)0)};
        uint r_channel_in_count = 0;
        uint r_channel_out_count = 0;
        uint r_io_channel_in_count = 0;
        uint r_io_channel_out_count = 0;
        #else
        particle_t remote_part[MAX_REMOTE_N];
        #endif
        //Phase 1: (r < r_max)
        //         Accept all incoming particles from integrator
        //         Stream out first remote block to the compute kernel
        //         Exchange first remote block with the previous and next device
        //Phase 2: (r_max + REMOTE_BLOCK_SIZE < r < r_max * comm_sz)
        //         Stream out a remote block to the compute kernel
        //         Exchange this remote block with the previous and next device
        //         Note: The first block was already streamed out in Phase 1, hence the offset of REMOTE_BLOCK_SIZE
        int r_global = r_buffer_max - r_preload;
        uint rr = 0;

        for(uint r=0; r<total_trips; r++)
        {
            #ifdef COMPILE_EMULATION
            particle_t in_part = nan((ulong)0);
            particle_t out_part = nan((ulong)0);
            #else
            particle_t in_part;
            particle_t out_part;
            #endif
            if(r < r_max)
            {
                in_part = r < remote_N ? read_channel_intel(chan_integrator_to_remote_particle_buffer) : ZERO;
                #ifdef COMPILE_EMULATION
                if(r < remote_N)r_channel_in_count++;
                #endif
            }
            else if(r < r_max*comm_sz)
            {
                in_part = read_channel_intel(io_chan_input_part).xyzw;
                #ifdef COMPILE_EMULATION
                r_io_channel_in_count++;
                #endif
            }
            if(r < r_preload || r >= r_max)
            {
                out_part = r < r_max || r_buffer_max == 0 ? in_part : remote_part[r_global];
                //printf("out_part = [%f,%f,%f,%f], r_global = %d\n", out_part.x,out_part.y,out_part.z,out_part.w, r_global);
            }
            if(r < r_preload || (r >= r_max && r < r_max * comm_sz - r_preload))
            {
                write_channel_intel(io_chan_output_part, (float8)(out_part,0.0,0.0,0.0,0.0));
                #ifdef COMPILE_EMULATION
                r_io_channel_out_count++;
                #endif
            }
            if(r < r_preload || r >= r_max)
            {
                if(rr < r_req)
                {
                    //printf("rr = %u\n",rr);
                    write_channel_intel(chan_remote_particle_buffer_to_compute, out_part);
                    #ifdef COMPILE_EMULATION
                    r_channel_out_count++;
                    #endif
                }
            }
            if(r >= r_preload && r < r_max * comm_sz)
            {
                remote_part[r_global] = in_part;
                //printf("remote_part[%d] = [%f,%f,%f,%f],\n", r_global, in_part.x,in_part.y,in_part.z,in_part.w);
            }

            r_global++;
            rr++;
            if(r_global == r_buffer_max)
            {
                r_global = 0;
            }
            if(rr == r_max)
            {
                rr = 0;
            }
            //printf("r_global_recv = %u\n", r_global);
        }
        printf("Remote Particle buffer: timestep = %u, channel_reads = %u, channel_writes = %u, io_channel_reads = %u, io_channel_writes = %u\n", s, r_channel_in_count, r_channel_out_count, r_io_channel_in_count, r_io_channel_out_count);
    }
    printf("Finished remote particle buffer\n");
}

// simple cache that can hold the first FORCE_CACHE_DEPTH elements of g_local_force
// and accumulates incoming values in BRAM
// further values are accumulated in global memory
// key benefit: for the global interface, can guarantee ivdep safelen of FORCE_CACHE_DEPTH
__kernel void local_force_cache(
                             __global float3* restrict g_local_force,
                             const uint local_N,
                             const uint remote_N,
                             const uint rank,
                             const uint comm_sz,
                             const uint steps,
                             const uint lf_steps)
{
    printf("Started Local Force Cache Kernel\n");
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    // actually required tripcount
    const uint inner_trips_required = r_block_max*l_block_max*LOCAL_BLOCK_SIZE*comm_sz;
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        #ifdef COMPILE_EMULATION
        force_t force_cache[MAX_LOCAL_N] = {nan((ulong)0)};
        uint l_channel_in_count = 0;
        uint l_channel_out_count = 0;
        #else
        force_t force_cache[MAX_LOCAL_N];
        #endif

        uint r_block=0, l=0;
        #pragma ivdep safelen(LOCAL_BLOCK_SIZE)
        for(uint rl=0; rl<inner_trips_required; rl++)
        {
            force_t val = read_channel_intel(chan_compute_to_local_force_cache);
            #ifdef COMPILE_EMULATION
            l_channel_in_count++;
            #endif
            force_t old_val = r_block == 0 ? ZERO : force_cache[l];
            force_t new_val = old_val + val;
            force_cache[l] = new_val;
            //printf("old_force[%u] = [%v4lf]\n", l, old_val);
            //printf("new_force[%u] = [%v4lf]\n", l, new_val);
            //Stream out local forces to integrator when the corresponding local particle was used with all remote particles
            if(r_block == r_block_max * comm_sz - 1 && l < local_N)
            {
                //printf("%u: Local Force Cache: Finished local force[%u]\n", comm_sz, l);
                write_channel_intel(chan_local_force_cache_to_integrator, force_cache[l]);
                #ifdef COMPILE_EMULATION
                l_channel_out_count++;
                #endif
            }
            
            //increment + wrap counter
            l++;
            if (l==l_block_max*LOCAL_BLOCK_SIZE)
            {
                l=0;
                r_block++;
            }

        }
        printf("Local Force Cache:      timestep = %u, channel_reads = %u, channel_writes = %u\n", s, l_channel_in_count, l_channel_out_count);

    }
    printf("Finished local force cache\n");
}

__kernel void remote_force_cache(
                             const uint local_N,
                             const uint remote_N,
                             const uint rank,
                             const uint comm_sz,
                             const uint steps,
                             const uint lf_steps)
{
    printf("Started Remote Force Cache Kernel\n");
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    const uint r_max = r_block_max * REMOTE_BLOCK_SIZE;
    const uint inner_trips_required = comm_sz * r_block_max * l_block_max * REMOTE_BLOCK_SIZE;
    // rounded up tripcount
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        #ifdef COMPILE_EMULATION
        uint r_channel_compute_in_count = 0;
        uint r_channel_comm_in_count = 0;
        uint r_io_channel_out_count = 0;
        #endif
        for(uint dev = 0;dev < comm_sz;dev++)
        {
            for(uint r_block=0; r_block<r_block_max; r_block++)
            {
                #ifdef COMPILE_EMULATION
                force_t force_buffer[REMOTE_BLOCK_SIZE] = {nan((ulong)0)};
                #else
                force_t force_buffer[REMOTE_BLOCK_SIZE];
                #endif
                #pragma ivdep safelen(REMOTE_BLOCK_SIZE)
                #pragma loop_coalesce 2
                for(uint l_block = 0;l_block < l_block_max;l_block++)
                {
                    for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
                    {
                        const uint r_global = r_block * REMOTE_BLOCK_SIZE + rr;
                        //Accumulate into same cached force buffer, as each remote block is used immediately with all local particles
                        //float3 remote_force = read_channel_intel(chan_compute_to_remote_force);
                        //float3 old_force = l_block == 0 ? 0.0 : force_buffer[rr & (REMOTE_BLOCK_SIZE - 1)];
                        //float3 new_force = old_force + remote_force;
                        //force_buffer[rr & (REMOTE_BLOCK_SIZE - 1)] = new_force;
                        
                        float3 remote_force = read_channel_intel(chan_compute_to_remote_force_cache);
                        #ifdef COMPILE_EMULATION
                        r_channel_compute_in_count++;
                        #endif
                        //printf("Received remote force[%u][%u] = [%f,%f,%f]\n", r_block*REMOTE_BLOCK_SIZE,rr,remote_force.x,remote_force.y,remote_force.z);
                        float3 old_force = dev == 0 && l_block == 0 ? ZERO : (l_block == 0 ? read_channel_intel(chan_remote_force_comm_to_remote_force_cache) : force_buffer[rr]);
                        #ifdef COMPILE_EMULATION
                        if(!(dev == 0 && l_block == 0))
                        {
                            if(l_block == 0)
                                r_channel_comm_in_count++;
                        }
                        #endif
                        force_buffer[rr] = old_force + remote_force;
                        //Stream out remote forces at the same pace as local forces are streamed out, such that neither the integrator nor the local force cache stalls
                        if(l_block == l_block_max - 1)
                        {
                            //printf("%u:Sending remote force[%u]\n", rank, r_global);
                            write_channel_intel(io_chan_output_force, (float8)(force_buffer[rr],0.0,0.0,0.0,0.0,0.0));
                            #ifdef COMPILE_EMULATION
                            r_io_channel_out_count++;
                            #endif
                        }
                        
                        
                    }
                }
            }
        }
        printf("Remote Force Cache:     timestep = %u, compute_channel_reads = %u, comm_channel_reads = %u, io_channel_writes = %u\n", s, r_channel_compute_in_count, r_channel_comm_in_count, r_io_channel_out_count);
    }
    printf("Finished remote force cache\n");
}

__kernel void remote_force_comm(
                             __global float3* restrict g_remote_force,
                             const uint local_N,
                             const uint remote_N,
                             const uint rank,
                             const uint comm_sz,
                             const uint steps,
                             const uint lf_steps)
{
    printf("Started Remote Force Cache Kernel\n");
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);
    const uint r_max = r_block_max * REMOTE_BLOCK_SIZE;
    const uint r_buffer_max = (r_block_max-1) * REMOTE_BLOCK_SIZE;
    const uint r_trips = (comm_sz+1) * r_max - REMOTE_BLOCK_SIZE;
    // rounded up tripcount
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        #ifdef COMPILE_EMULATION
        force_t recv_force_buffer[MAX_REMOTE_N] = {nan((ulong)0)};
        uint r_channel_cache_out_count = 0;
        uint r_channel_integrator_out_count = 0;
        uint r_io_channel_in_count = 0;
        #else
        force_t recv_force_buffer[MAX_REMOTE_N];
        #endif
        int  r_int = -(r_max * comm_sz - REMOTE_BLOCK_SIZE);
        uint r_global = 0;
        
        for(uint r = 0;r < r_trips;r++)
        {
            #ifdef COMPILE_EMULATION
            force_t in_force = nan((ulong)0);
            force_t out_force = nan((ulong)0);
            #else
            force_t in_force;
            force_t out_force;
            #endif
            if(r < r_max * comm_sz - REMOTE_BLOCK_SIZE || r >= r_trips - REMOTE_BLOCK_SIZE)
            {
                in_force = read_channel_intel(io_chan_input_force).xyz;
                #ifdef COMPILE_EMULATION
                r_io_channel_in_count++;
                #endif
            }

            if(r >= r_max - REMOTE_BLOCK_SIZE && r < r_trips - REMOTE_BLOCK_SIZE)
            {
                out_force = r_buffer_max != 0 ? recv_force_buffer[r_global] : in_force;
            }
            if(r >= r_max - REMOTE_BLOCK_SIZE && r < r_max*comm_sz - REMOTE_BLOCK_SIZE)
            {
                write_channel_intel(chan_remote_force_comm_to_remote_force_cache, out_force);
                #ifdef COMPILE_EMULATION
                r_channel_cache_out_count++;
                #endif
            }
            if(r < r_max * comm_sz - REMOTE_BLOCK_SIZE)
            {
                //printf("%u:Receiving force %u\n", rank, r_recv);
                if(r_buffer_max != 0)recv_force_buffer[r_global] = in_force;
            }
            else 
            {
                if(r - (r_max * comm_sz - REMOTE_BLOCK_SIZE) < remote_N)
                {
                    //printf("%u:Forwarding remote force[%u] to integrator\n", rank, r_global);
                    write_channel_intel(chan_remote_force_comm_to_integrator, r < r_trips - REMOTE_BLOCK_SIZE ? out_force : in_force);
                    #ifdef COMPILE_EMULATION
                    r_channel_integrator_out_count++;
                    #endif
                }
            }
            r_global++;
            if(r_global == r_buffer_max && r < r_trips - REMOTE_BLOCK_SIZE)
                r_global = 0;
        }
       printf("Remote Force Comm:      timestep = %u, cache_channel_writes = %u, integrator_channel_writes = %u, io_channel_reads = %u\n", s, r_channel_cache_out_count, r_channel_integrator_out_count, r_io_channel_in_count);
    }
    printf("Finished remote force comm\n");
}

__kernel void integrator(
                          __global particle_t* restrict g_local_part,
                          __global float3* restrict g_local_vel,
                          __global float* restrict g_local_mass,
                          __global float* restrict g_c,
                          __global float* restrict g_d,
                          const uint local_N,
                          const uint remote_N,
                          const uint rank,
                          const uint comm_sz,
                          const uint steps,
                          const uint lf_steps,
                          const float delta_t
                         )
{
    printf("Started Integrator Kernel\n");
    printf("Device: sizeof(particle_t) = %u\n",sizeof(particle_t));
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);

    #ifdef COMPILE_EMULATION
    float c[MAX_LF_COEFFICIENTS] = {nan((ulong)0)};
    float d[MAX_LF_COEFFICIENTS] = {nan((ulong)0)};
    particle_t local_part[MAX_N] = {nan((ulong)0)};
    float3 local_vel[MAX_N] = {nan((ulong)0)};
    float local_mass[MAX_N] = {nan((ulong)0)};
    #else
    float c[MAX_LF_COEFFICIENTS];
    float d[MAX_LF_COEFFICIENTS];
    particle_t local_part[MAX_N];
    float3 local_vel[MAX_N];
    float local_mass[MAX_N];
    #endif

    for(uint lf_step = 0;lf_step < lf_steps;lf_step++)
    {
        c[lf_step] = g_c[lf_step];
        d[lf_step] = lf_step == lf_steps - 1 ? 0.0 : g_d[lf_step];
        printf("c[%u] = %f, d[%u] = %f\n", lf_step, c[lf_step], lf_step, d[lf_step]);
    }

    //Do first position step s_0^1 <- s_0 + v_0 * c_0 * delta_t
    for(uint l = 0;l < local_N;l++)
    {
        float3 vel = g_local_vel[l];
        local_vel[l] = vel;
        particle_t old_part = g_local_part[l];
        float3 new_pos = old_part.xyz + vel * delta_t * c[0];
        particle_t new_part = (float4)(new_pos, old_part.w);
        local_part[l] = new_part;
        local_mass[l] = g_local_mass[l];
        write_channel_intel(chan_integrator_to_local_particle_buffer, new_part);
        write_channel_intel(chan_integrator_to_remote_particle_buffer, new_part);
    }
    printf("Written out all particles for first timestep\n");

    uint s = 0;
    uint lf_step = 0;
    #pragma disable_loop_pipelining
    for(uint sf=0; sf<steps * (lf_steps-1); sf++)
    {
        //Merge the last lf position step of a timestep with the first lf position step of the next timestep,
        //except for the last timestep where only the last lf position step ist needed
        float curr_c = lf_step < lf_steps - 2 ? c[lf_step + 1] : (s < steps - 1 ? c[lf_steps - 1] + c[0] : c[lf_steps-1]);
        float curr_d = d[lf_step];
        //printf("s = %u, lf_step = %u, Using curr_c = %f, curr_d = %f\n", s, lf_step, curr_c, curr_d);
        
        for(uint l=0; l<local_N; l++)
        {
            force_t local_force = read_channel_intel(chan_local_force_cache_to_integrator);
            force_t remote_force = read_channel_intel(chan_remote_force_comm_to_integrator);
            force_t total_force = local_force - remote_force;
            //printf("Pre-update velocity[%u] = [%f,%f,%f]\n", l, local_vel[l].x,local_vel[l].y,local_vel[l].z);
            
            
            float3 new_vel = local_vel[l] + (total_force * delta_t * curr_d)/local_mass[l];
            particle_t old_part = local_part[l];
            float3 new_pos = old_part.xyz + new_vel * delta_t * curr_c;
            particle_t new_part = (float4)(new_pos, old_part.w);
            local_vel[l] = new_vel;
            
            //printf("Post-update velocity[%u] = [%f,%f,%f]\n", l, local_vel[l].x,local_vel[l].y,local_vel[l].z);
            //printf("Pre-update position[%u] = [%f,%f,%f]\n", l, local_part[l].x,local_part[l].y,local_part[l].z);
            local_part[l] = new_part;
            //printf("Post-update position[%u] = [%f,%f,%f]\n", l, local_part[l].x,local_part[l].y,local_part[l].z);
            //printf("Received new local_force[%u]  = [%f,%f,%f]\n", l, local_force.x, local_force.y, local_force.z);
            //printf("Received new remote_force[%u] = [%f,%f,%f]\n", l, remote_force.x, remote_force.y, remote_force.z);
            //printf("Received new total_force[%u]  = [%f,%f,%f]\n\n", l, total_force.x, total_force.y, total_force.z);
            //Buffer enough positions to start next timestep
            if(s < steps - 1 || lf_step < lf_steps - 2)
            {
                write_channel_intel(chan_integrator_to_local_particle_buffer, new_part);
                write_channel_intel(chan_integrator_to_remote_particle_buffer, new_part);
            }

            //printf("pos[%u] = [%v3lf]\n", r, g_local_pos[r]);
            //printf("vel[%u] = [%v3lf]\n", r, g_local_vel[r]);
            //printf("force[%u] = [%v3lf]\n", r, total_force);
        }
        lf_step++;
        if(lf_step == lf_steps - 1)
        {
            lf_step = 0;
            s++;
        }
    }
    for(uint l = 0;l < local_N;l++)
    {
        g_local_vel[l] = local_vel[l];
        g_local_part[l] = local_part[l];
    }
}
