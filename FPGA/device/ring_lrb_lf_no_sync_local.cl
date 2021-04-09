#pragma OPENCL EXTENSION cl_intel_channels : enable

#ifdef DBG_PRINT
#else
    #define printf(fmt,...) (0)
#endif

__constant double G = 1.0;
#define ZERO 0.

// only 2x2 PEs for reduced solver implemented
// alternative implementation could provide 1x1 PEs for full solver
#define PE_LOCAL_SIZE 2
#define PE_REMOTE_SIZE 2

// default configuration
#ifndef PE_LOCAL_CNT
    #define PE_LOCAL_CNT 2
    #define PE_LOCAL_CNT_ALLOC 2
    #define PE_REMOTE_CNT 3
    #define PE_REMOTE_CNT_ALLOC 4
#endif

#define PE_LOCAL_PROD (PE_LOCAL_SIZE * PE_LOCAL_CNT)
#define PE_REMOTE_PROD (PE_REMOTE_SIZE * PE_REMOTE_CNT)

#define LATENCY_FACTOR 16
#define LOCAL_BLOCK_SIZE (LATENCY_FACTOR * PE_LOCAL_PROD)
#define REMOTE_BLOCK_SIZE (LATENCY_FACTOR * PE_REMOTE_PROD)

#define PRELOAD_BLOCKS 1
#define PRELOAD_CHANNEL_DEPTH (PRELOAD_BLOCKS * LOCAL_BLOCK_SIZE)

#define MAX_N 16384
#define MAX_LOCAL_BLOCKS (1 +((MAX_N-1)/LOCAL_BLOCK_SIZE))
#define MAX_REMOTE_BLOCKS (1 + ((MAX_N-1)/REMOTE_BLOCK_SIZE))
#define MAX_LOCAL_N (MAX_LOCAL_BLOCKS*LOCAL_BLOCK_SIZE)
#define MAX_REMOTE_N (MAX_REMOTE_BLOCKS*REMOTE_BLOCK_SIZE)

#define MAX_LF_COEFFICIENTS 512

// structs with and without valid flag
//typedef struct __attribute__ ((packed)) particle{
//    double3 pos;
//    double coeff;
//} particle_t;
typedef double4 particle_t;

typedef double3 force_t;


// aggregate struct as return type of 2x2 PE
typedef struct force_quad{
    force_t local_force[PE_LOCAL_SIZE];
    force_t remote_force[PE_REMOTE_SIZE];
} force_quad_t;

channel particle_t          chan_remote_particle_to_local_particle __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel particle_t          chan_remote_particle_to_compute        __attribute__((depth(REMOTE_BLOCK_SIZE)));
channel particle_t          chan_local_particle_to_compute         __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_compute_to_local_force            __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_compute_to_remote_force           __attribute__((depth(REMOTE_BLOCK_SIZE)));
channel force_t             chan_local_force_to_integrator         __attribute__((depth(LOCAL_BLOCK_SIZE)));
channel force_t             chan_remote_force_to_integrator        __attribute__((depth(MAX_N)));
channel particle_t          chan_integrator_to_remote_particle     __attribute__((depth(MAX_N)));

//channel double4 io_chan_input_part   __attribute__((io("input_0_output_1_part"), depth(CHANNEL_DEPTH)));
//channel double4 io_chan_output_part  __attribute__((io("input_1_output_0_part"), depth(CHANNEL_DEPTH)));
//channel double4 io_chan_input_force  __attribute__((io("input_0_output_1_force"), depth(CHANNEL_DEPTH)));
//channel double4 io_chan_output_force __attribute__((io("input_1_output_0_force"), depth(CHANNEL_DEPTH)));

//channel particle_t io_chan_input_part    __attribute__((io("kernel_input_ch0"), depth(REMOTE_BLOCK_SIZE)));
//channel particle_t io_chan_output_part   __attribute__((io("kernel_output_ch1"), depth(REMOTE_BLOCK_SIZE)));
//channel force_t    io_chan_input_force   __attribute__((io("kernel_input_ch2"), depth(REMOTE_BLOCK_SIZE)));
//channel force_t    io_chan_output_force  __attribute__((io("kernel_output_ch3"), depth(REMOTE_BLOCK_SIZE)));

/* 
***********************************************************************  GENERAL KERNEL COMMUNICATION STRUCTURE **********************************************************************************

––––––––––––––––––––                –––––––––––––––––––––––                  ______________________________                 –––––––––––––––––––––––                 ______________________________
|                  |                |                     |                  |                            |                 |                     |                 |                            |
| Integrator at t  | -------------> | Remote part buffer  | ---------------> |                            |---------------> | Remote force cache  | --------------->|                            |
|––––––––––––––––––|                |–––––––––––––––––––––|                  |                            |                 |–––––––––––––––––––––|                 |                            |
                                                |                            |                            |                                                         |                            |
                                                |                            |                            |                                                         |                            |
                                                |                            |          Compute           |                                                         |          Integrator        |
                                                V                            |                            |                                                         |            at t+1          |
                                    –––––––––––––––––––––––                  |                            |                 –––––––––––––––––––––––                 |                            |
                                    |                     |                  |                            |                 |                     |                 |                            |
                                    | Local part buffer   | ---------------> |                            |---------------> | Local force cache   | --------------->|                            |
                                    |–––––––––––––––––––––|                  |____________________________|                 |–––––––––––––––––––––|                 |____________________________|



*/

// return force between two particles or 0 if one of the particles is invalid
force_t compute_pair(
                particle_t local_particle,
                particle_t remote_particle,
                bool eq_cond)
{
    double3 diff = remote_particle.xyz - local_particle.xyz;
    double dist = rsqrt(diff.x * diff.x + diff.y * diff.y + diff.z*diff.z);
    double3 result = local_particle.w * remote_particle.w * (dist*dist*dist) * diff;
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
    
    
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps * (lf_steps-1); s++)
    {
        printf("1:Starting new compute iteration\n");
        // process complete remote block before using the next one
        for(uint r_block=0; r_block<r_block_max; r_block++)
        {
            uint r_base = r_block * REMOTE_BLOCK_SIZE;
            //printf("r_base: %u, r_block: %u\n", r_base, r_block);
            // replicated local memory
            // memory depth is only LATENCY_FACTOR, rest is banked
            particle_t    b_remote_particles[LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE];

            // R1: load remote particles
            for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
            {
                b_remote_particles[rr/PE_REMOTE_PROD][(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT][rr%PE_REMOTE_SIZE] = read_channel_intel(chan_remote_particle_to_compute);
                particle_t p = b_remote_particles[rr/PE_REMOTE_PROD][(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT][rr%PE_REMOTE_SIZE];
                if(p.w != 0.0)
                    printf("Remote[%u][%u][%u] = { pos: [%f,%f,%f] , coeff: %f }\n",rr/PE_REMOTE_PROD, (rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT, rr%PE_REMOTE_SIZE, p.x, p.y, p.z, p.w);
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
                particle_t          b_local_particles[LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE];
                double3             b_local_forces   [LATENCY_FACTOR][PE_LOCAL_CNT_ALLOC][PE_LOCAL_SIZE];
                double3             b_remote_forces   [LATENCY_FACTOR][PE_REMOTE_CNT_ALLOC][PE_REMOTE_SIZE];

                // L1: load local particles
                for(uint ll=0; ll<LOCAL_BLOCK_SIZE; ++ll)
                {
                    uint l_global = l_base + ll;
                    b_local_particles[ll/PE_LOCAL_PROD][(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT][ll%PE_LOCAL_SIZE] = read_channel_intel(chan_local_particle_to_compute);
                    particle_t p = b_local_particles[ll/PE_LOCAL_PROD][(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT][ll%PE_LOCAL_SIZE];
                    if(p.w != 0.0)
                        printf("Local[%u][%u][%u] = { pos: [%f,%f,%f] , coeff: %f }\n",ll/PE_REMOTE_PROD, (ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT, ll%PE_LOCAL_SIZE, p.x, p.y, p.z, p.w);
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
                    force_quad_t pe_force_quads[PE_LOCAL_CNT][PE_REMOTE_CNT];
                    //printf("Quad[%u][%u]\n",r_block * PE_REMOTE_PROD + o_part, l_block * PE_LOCAL_PROD + l_part);
                    #pragma unroll
                    for(int l=0; l<PE_LOCAL_CNT; l++)
                    {
                        #pragma unroll
                        for(int o=0; o<PE_REMOTE_CNT; o++)
                        {
                            // TODO: verify condition, current take is that since bb iterates through corresponding sub-partitions, can ignore it or derived values l_part / o_part
                            uint ll = l_base + l_part * PE_LOCAL_PROD + l * PE_LOCAL_SIZE;
                            uint rr = r_base + o_part * PE_REMOTE_PROD + o * PE_REMOTE_SIZE;

                            //if(ll < local_N && rr < remote_N)printf("[l%u l%u] x [r%u r%u]\n",ll,ll+1,rr,rr+1);

                            bool lr_cond = ll < rr;
                            bool eq_cond = ll == rr;
                            pe_force_quads[l][o] = PE_2x2(b_local_particles[l_part][l],
                                                        b_remote_particles[o_part][o],
                                                        lr_cond,
                                                        eq_cond);
                            double3 ql0 = pe_force_quads[l][o].local_force[0];
                            double3 ql1 = pe_force_quads[l][o].local_force[1];
                            double3 qr0 = pe_force_quads[l][o].remote_force[0];
                            double3 qr1 = pe_force_quads[l][o].remote_force[1];
                            //if(ll < local_N && rr < remote_N)printf("[%f,%f,%f , %f,%f,%f]\n[%f,%f,%f , %f,%f,%f]\n", ql0.x, ql0.y,ql0.z, ql1.x,ql1.y,ql1.z, qr0.x,qr0.y,qr0.z, qr1.x,qr1.y,qr1.z);
                        }
                    }
                    // reduce over PEs here
                    // example 4x4 PE_2x2: reduction over 64*3 doubles
                    double3 pe_local_forces[PE_LOCAL_CNT][PE_LOCAL_SIZE] = {ZERO};
                    double3 pe_remote_forces[PE_REMOTE_CNT][PE_REMOTE_SIZE] = {ZERO};
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
                    write_channel_intel(chan_compute_to_local_force, b_local_forces[ll/PE_LOCAL_PROD]
                                                                            [(ll/PE_LOCAL_SIZE)%PE_LOCAL_CNT]
                                                                            [ll%PE_LOCAL_SIZE]);
                }
                // L3/R3: accumulate remote forces in remote kernel
                for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
                {
                    write_channel_intel(chan_compute_to_remote_force, b_remote_forces[rr/PE_REMOTE_PROD]
                                                                              [(rr/PE_REMOTE_SIZE)%PE_REMOTE_CNT]
                                                                              [rr%PE_REMOTE_SIZE]);
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
        particle_t local_part[MAX_N];
        #pragma loop_coalesce 3
        for(uint r_block=0; r_block<r_block_max; r_block++)
        {
            for(uint l_block=0; l_block<l_block_max; l_block++)
            {
                uint l_base = l_block*LOCAL_BLOCK_SIZE;
                for(uint ll = 0;ll < LOCAL_BLOCK_SIZE;ll++)
                {
                    uint l_global = l_base + ll;
                    particle_t part;
                    //Phase 1: Read in all forwarded particles from remote particle buffer
                    if(r_block == 0)
                    {
                        part = read_channel_intel(chan_remote_particle_to_local_particle);
                        local_part[l_global] = part;
                    }
                    //Phase 2: Use previously streamed in particles
                    else 
                        part = local_part[l_global];

                    particle_t forward_part;
                    bool valid = l_global < local_N;
                    forward_part = valid ? part : ZERO;
                    write_channel_intel(chan_local_particle_to_compute, forward_part);
                    //printf("Local Particle Buffer: Forwarding particle[%u]\n", l_global);
                }
            }
        }
    }
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
    const uint l_max = l_block_max * LOCAL_BLOCK_SIZE;
    const uint r_max = r_block_max * REMOTE_BLOCK_SIZE;
    const uint l_total = max(l_max, (uint)REMOTE_BLOCK_SIZE);
    const uint inner_trips = l_total +(r_max -REMOTE_BLOCK_SIZE);

    
    //Second approach
    //Recv directly from integrator and forward to local pos buffer
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        particle_t remote_part[MAX_N];
        //Phase 1: All local particles have to be used with the first remote block;
        //         Accept all particles from Integrator and forward to local particle buffer;
        //         Advantage: Integrator can stream out all particles without blocking and accept new incoming forces for the next timestep;
        for(uint l=0; l<inner_trips; l++)
        {
            particle_t part;
            if(l < l_total)
            {
                part = l < local_N ? read_channel_intel(chan_integrator_to_remote_particle) : ZERO;
                if(l < l_max) write_channel_intel(chan_remote_particle_to_local_particle, part);
                if(l < remote_N) remote_part[l] = part;
            }
            else
            {
                uint r_global = l - l_total + REMOTE_BLOCK_SIZE;
                part = r_global < remote_N ? remote_part[r_global] : ZERO;
            }
            if((l < REMOTE_BLOCK_SIZE && l < l_total) || l >= l_total) write_channel_intel(chan_remote_particle_to_compute, part);
            
        }
    }
}

// simple cache that can hold the first FORCE_CACHE_DEPTH elements of g_local_force
// and accumulates incoming values in BRAM
// further values are accumulated in global memory
// key benefit: for the global interface, can guarantee ivdep safelen of FORCE_CACHE_DEPTH
__kernel void local_force_cache(
                             __global double3* restrict g_local_force,
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
    const uint inner_trips_required = r_block_max*l_block_max*LOCAL_BLOCK_SIZE;
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        force_t force_cache[MAX_LOCAL_N];
        uint r_block=0, l=0;
        #pragma ivdep safelen(LOCAL_BLOCK_SIZE)
        for(uint rl=0; rl<inner_trips_required; rl++)
        {
            force_t val = read_channel_intel(chan_compute_to_local_force);
            force_t old_val = r_block == 0 ? ZERO : force_cache[l];
            force_t new_val = old_val + val;
            force_cache[l] = new_val;
            //printf("old_force[%u] = [%v4lf]\n", l, old_val);
            //printf("new_force[%u] = [%v4lf]\n", l, new_val);
            //Stream out local forces to integrator when the corresponding local particle was used with all remote particles
            if(r_block == r_block_max - 1 && l < local_N)
            {
               // printf("Local Force Cache: Finished local force[%u]\n", l);
                write_channel_intel(chan_local_force_to_integrator, force_cache[l]);
            }
            
            //increment + wrap counter
            l++;
            if (l==l_block_max*LOCAL_BLOCK_SIZE)
            {
                l=0;
                r_block++;
            }
            

        }
    }
}

__kernel void remote_force_cache(
                             __global double3* restrict g_remote_force,
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
    const uint inner_trips_required = r_block_max * l_block_max * REMOTE_BLOCK_SIZE;
    // rounded up tripcount
    //#pragma disable_loop_pipelining
    for(uint s=0; s<steps*(lf_steps-1); s++)
    {
        
        for(uint r_block=0; r_block<r_block_max; r_block++)
        {
            force_t force_buffer[REMOTE_BLOCK_SIZE];
            #pragma ivdep safelen(REMOTE_BLOCK_SIZE)
            #pragma loop_coalesce 2
            for(uint l_block = 0;l_block < l_block_max;l_block++)
            {
                for(uint rr=0; rr<REMOTE_BLOCK_SIZE; ++rr)
                {
                    const uint r_global = r_block * REMOTE_BLOCK_SIZE + rr;
                    //Accumulate into same cached force buffer, as each remote block is used immediately with all local particles
                    //double3 remote_force = read_channel_intel(chan_compute_to_remote_force);
                    //double3 old_force = l_block == 0 ? 0.0 : force_buffer[rr & (REMOTE_BLOCK_SIZE - 1)];
                    //double3 new_force = old_force + remote_force;
                    //force_buffer[rr & (REMOTE_BLOCK_SIZE - 1)] = new_force;
                    double3 remote_force = read_channel_intel(chan_compute_to_remote_force);
                    force_buffer[rr] = l_block == 0 ? remote_force : force_buffer[rr] + remote_force;
                    //Stream out remote forces at the same pace as local forces are streamed out, such that neither the integrator nor the local force cache stalls
                    if(l_block == l_block_max - 1 && r_global < remote_N)
                    {
                        write_channel_intel(chan_remote_force_to_integrator, force_buffer[rr]);
                    }
                }
            }
        }
    }
}



__kernel void integrator(
                          __global particle_t* restrict g_local_part,
                          __global double3* restrict g_local_vel,
                          __global double* restrict g_local_mass,
                          __global double* restrict g_c,
                          __global double* restrict g_d,
                          const uint local_N,
                          const uint remote_N,
                          const uint rank,
                          const uint comm_sz,
                          const uint steps,
                          const uint lf_steps,
                          const double delta_t
                         )
{
    printf("Started Integrator Kernel\n");
    printf("Device: sizeof(particle_t) = %u\n",sizeof(particle_t));
    const uint r_block_max = 1 + (((int)remote_N-1) / REMOTE_BLOCK_SIZE);
    const uint l_block_max = 1 + (((int)local_N-1) / LOCAL_BLOCK_SIZE);

    double c[MAX_LF_COEFFICIENTS];
    double d[MAX_LF_COEFFICIENTS];

    particle_t local_part[MAX_N];
    double3 local_vel[MAX_N];
    double local_mass[MAX_N];

    for(uint lf_step = 0;lf_step < lf_steps;lf_step++)
    {
        c[lf_step] = g_c[lf_step];
        d[lf_step] = lf_step == lf_steps - 1 ? 0.0 : g_d[lf_step];
        printf("c[%u] = %f, d[%u] = %f\n", lf_step, c[lf_step], lf_step, d[lf_step]);
    }

    //Do first position step s_0^1 <- s_0 + v_0 * c_0 * delta_t
    for(uint l = 0;l < local_N;l++)
    {
        double3 vel = g_local_vel[l];
        local_vel[l] = vel;
        particle_t old_part = g_local_part[l];
        double3 new_pos = old_part.xyz + vel * delta_t * c[0];
        particle_t new_part = (double4)(new_pos, old_part.w);
        local_part[l] = new_part;
        local_mass[l] = g_local_mass[l];
        write_channel_intel(chan_integrator_to_remote_particle, new_part);
    }
    printf("Written out all particles for first timestep\n");

    uint s = 0;
    uint lf_step = 0;
    #pragma disable_loop_pipelining
    for(uint sf=0; sf<steps * (lf_steps-1); sf++)
    {
        //Merge the last lf position step of a timestep with the first lf position step of the next timestep,
        //except for the last timestep where only the last lf position step ist needed
        double curr_c = lf_step < lf_steps - 2 ? c[lf_step + 1] : (s < steps - 1 ? c[lf_steps - 1] + c[0] : c[lf_steps-1]);
        double curr_d = d[lf_step];
        printf("s = %u, lf_step = %u, Using curr_c = %f, curr_d = %f\n", s, lf_step, curr_c, curr_d);
        //Note: Down below is neither a functioning Euler integrator, nor a functioning leapfrog integrator
        //TODO: Implement leapfrog
        
        for(uint l=0; l<local_N; l++)
        {
            force_t local_force = read_channel_intel(chan_local_force_to_integrator);
            force_t remote_force = read_channel_intel(chan_remote_force_to_integrator);
            force_t total_force = local_force - remote_force;
            printf("Pre-update velocity[%u] = [%f,%f,%f]\n", l, local_vel[l].x,local_vel[l].y,local_vel[l].z);
            
            
            double3 new_vel = local_vel[l] + (total_force * delta_t * curr_d)/local_mass[l];
            particle_t old_part = local_part[l];
            double3 new_pos = old_part.xyz + new_vel * delta_t * curr_c;
            particle_t new_part = (double4)(new_pos, old_part.w);
            local_vel[l] = new_vel;
            
            printf("Post-update velocity[%u] = [%f,%f,%f]\n", l, local_vel[l].x,local_vel[l].y,local_vel[l].z);
            printf("Pre-update position[%u] = [%f,%f,%f]\n", l, local_part[l].x,local_part[l].y,local_part[l].z);
            local_part[l] = new_part;
            printf("Post-update position[%u] = [%f,%f,%f]\n", l, local_part[l].x,local_part[l].y,local_part[l].z);
            printf("Received new local_force[%u]  = [%f,%f,%f]\n", l, local_force.x, local_force.y, local_force.z);
            printf("Received new remote_force[%u] = [%f,%f,%f]\n", l, remote_force.x, remote_force.y, remote_force.z);
            printf("Received new total_force[%u]  = [%f,%f,%f]\n\n", l, total_force.x, total_force.y, total_force.z);
            //Buffer enough positions to start next timestep
            if(s < steps - 1 || lf_step < lf_steps - 2)
            {
                write_channel_intel(chan_integrator_to_remote_particle, new_part);
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
