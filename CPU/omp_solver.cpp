#include "omp_solver.h"
#include<stdio.h>
#include<stdint.h>

#include <omp.h>
#include <immintrin.h>

#include <string.h>
#include <cmath>
#include <algorithm>

void compute_forces_avx2(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        double** thread_local_force = local_force[thread_rank];
        double** thread_local_recv_force = local_recv_force[thread_rank];

        //Reset all forces before each timestep
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0;
                local_force[thread][Y][i] = 0.0;
                local_force[thread][Z][i] = 0.0;
                local_recv_force[thread][X][i] = 0.0;
                local_recv_force[thread][Y][i] = 0.0;
                local_recv_force[thread][Z][i] = 0.0;
            }
        }
        
        //Main loop: vectorized calculation of all force pairs f_kq
#pragma omp for schedule(static, 1)
        for(size_t k = 0;k < local_N;k++)
        {
            // G-mass product can be precalculated as the mass does not change between timesteps
            double pre_calc = -G*nb_sys.mass[rank*local_N + k];
            
            //Fix alignment to the next 32-bit aligned address
            //All arrays are allocated as 64-bit aligned
            size_t q = rank < (rank+recv_round)%comm_sz ? k : k+1;
            size_t align_offset = (q & 0b11);
            size_t mass_q_offset = ((rank + recv_round)%comm_sz)*local_N;
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 4 - align_offset && q < local_N ;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = nb_sys.pos[X][k] - recv_pos[X][q];
                    diff[Y] = nb_sys.pos[Y][k] - recv_pos[Y][q];
                    diff[Z] = nb_sys.pos[Z][k] - recv_pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                    thread_local_force[X][k] += force_ij[X];
                    thread_local_force[Y][k] += force_ij[Y];
                    thread_local_force[Z][k] += force_ij[Z];
                    thread_local_recv_force[X][q] -= force_ij[X];
                    thread_local_recv_force[Y][q] -= force_ij[Y];
                    thread_local_recv_force[Z][q] -= force_ij[Z];
                }
                break;
            }

            //preload values of the kth particle to registers
            //The values are spread among an entire AVX2 register
            //e.g. pos[k].x -> AVX2_reg{pos[k].x, pos[k].x, pos[k].x, pos[k].x}
            __m256d force_k_x = _mm256_set1_pd(0.0);
            __m256d force_k_y = _mm256_set1_pd(0.0);
            __m256d force_k_z = _mm256_set1_pd(0.0);
            __m256d pos_k_x = _mm256_set1_pd(nb_sys.pos[X][k]);
            __m256d pos_k_y = _mm256_set1_pd(nb_sys.pos[Y][k]);
            __m256d pos_k_z = _mm256_set1_pd(nb_sys.pos[Z][k]);
            __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);

            //Vectorized loop body
            for(;q+3 < local_N;q+=4)
            {
                //diff = pos[k] - pos[q]
                __m256d diff_x = pos_k_x;
                __m256d diff_y = pos_k_y;
                __m256d diff_z = pos_k_z;
                __m256d pos_q_x = _mm256_load_pd(&(recv_pos[X][q]));
                __m256d pos_q_y = _mm256_load_pd(&(recv_pos[Y][q]));
                __m256d pos_q_z = _mm256_load_pd(&(recv_pos[Z][q]));
                diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                diff_z = _mm256_sub_pd(diff_z, pos_q_z);

                //dist^2 = dot_prod(diff,diff);
                __m256d dist = _mm256_mul_pd(diff_x,diff_x);
                __m256d tmp = _mm256_mul_pd(diff_y,diff_y);
                dist = _mm256_add_pd(dist,tmp);
                tmp = _mm256_mul_pd(diff_z,diff_z);
                dist = _mm256_add_pd(dist,tmp);

                //dist = sqrt(dist^2)
                dist = _mm256_sqrt_pd(dist);

                //dist^3 = dist * dist * dist
                __m256d dist3  = _mm256_mul_pd(dist,dist);
                dist3 = _mm256_mul_pd(dist, dist3);

                
                __m256d force_q_x = _mm256_load_pd(&(thread_local_recv_force[X][q]));
                __m256d force_q_y = _mm256_load_pd(&(thread_local_recv_force[Y][q]));
                __m256d force_q_z = _mm256_load_pd(&(thread_local_recv_force[Z][q]));

                //force_kq = ((-G * mass[k] * mass[q])/dist^3)*diff 
                __m256d scalar_factor = _mm256_load_pd(&nb_sys.mass[mass_q_offset + q]);
                scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm256_div_pd(scalar_factor, dist3);
                __m256d force_x = _mm256_mul_pd(scalar_factor,diff_x);
                __m256d force_y = _mm256_mul_pd(scalar_factor,diff_y);
                __m256d force_z = _mm256_mul_pd(scalar_factor,diff_z);

                
                //force_q -= force_kq
                force_q_x = _mm256_sub_pd(force_q_x, force_x);
                force_q_y = _mm256_sub_pd(force_q_y, force_y);
                force_q_z = _mm256_sub_pd(force_q_z, force_z);
                
                
                _mm256_store_pd(&(thread_local_recv_force[X][q]), force_q_x);
                _mm256_store_pd(&(thread_local_recv_force[Y][q]), force_q_y);
                _mm256_store_pd(&(thread_local_recv_force[Z][q]), force_q_z);

                //force_k += force_kq
                force_k_x = _mm256_add_pd(force_k_x, force_x);
                force_k_y = _mm256_add_pd(force_k_y, force_y);
                force_k_z = _mm256_add_pd(force_k_z, force_z);
            }
            //force_k has been partially calculated over the 4 entries of the AVX2 register
            //perform horizontal add across AVX2 register to get the resulting force[k]
            //{force_k0, force_k1, force_k2, force_k3} -> {force_k0 + force_k2, force_k1 + force_k3}
            //-> force_k0 + force_k1 + force_k2 + force_k3
            __m128d force_k_x_low = _mm256_castpd256_pd128(force_k_x);
            __m128d force_k_x_high = _mm256_extractf128_pd(force_k_x,1);
            __m128d force_k_y_low = _mm256_castpd256_pd128(force_k_y);
            __m128d force_k_y_high = _mm256_extractf128_pd(force_k_y,1);
            __m128d force_k_z_low = _mm256_castpd256_pd128(force_k_z);
            __m128d force_k_z_high = _mm256_extractf128_pd(force_k_z,1);
            force_k_x_low = _mm_add_pd(force_k_x_low, force_k_x_high);
            force_k_y_low = _mm_add_pd(force_k_y_low, force_k_y_high);
            force_k_z_low = _mm_add_pd(force_k_z_low, force_k_z_high);
            __m128d force_k_x_high64 = _mm_unpackhi_pd(force_k_x_low, force_k_x_low);
            __m128d force_k_y_high64 = _mm_unpackhi_pd(force_k_y_low, force_k_y_low);
            __m128d force_k_z_high64 = _mm_unpackhi_pd(force_k_z_low, force_k_z_low);
            thread_local_force[X][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_x_low, force_k_x_high64));
            thread_local_force[Y][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_y_low, force_k_y_high64));
            thread_local_force[Z][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_z_low, force_k_z_high64));

            //Loop remainder
            for(;q < local_N;q++)
            {
                
                double diff[DIM];
                diff[X] = nb_sys.pos[X][k] - recv_pos[X][q];
                diff[Y] = nb_sys.pos[Y][k] - recv_pos[Y][q];
                diff[Z] = nb_sys.pos[Z][k] - recv_pos[Z][q];
                double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                double force_ij[DIM];
                force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                thread_local_force[X][k] += force_ij[X];
                thread_local_force[Y][k] += force_ij[Y];
                thread_local_force[Z][k] += force_ij[Z];
                thread_local_recv_force[X][q] -= force_ij[X];
                thread_local_recv_force[Y][q] -= force_ij[Y];
                thread_local_recv_force[Z][q] -= force_ij[Z];
            }
        }
        //The accumulation of force[q] was split into a seperate array
        //The two arrays containing the results of force[k] and force[q] have to be accumulated
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads; thread++)
            {
                nb_sys.force[X][i] += local_force[thread][X][i];
                nb_sys.force[Y][i] += local_force[thread][Y][i];
                nb_sys.force[Z][i] += local_force[thread][Z][i];
                recv_force[X][i] += local_recv_force[thread][X][i];
                recv_force[Y][i] += local_recv_force[thread][Y][i];
                recv_force[Z][i] += local_recv_force[thread][Z][i];
            }
        }
    }
}

void compute_forces_avx2_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        double** thread_local_force = local_force[thread_rank];
        double** thread_local_recv_force = local_recv_force[thread_rank];

        //Reset all forces before each timestep
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0;
                local_force[thread][Y][i] = 0.0;
                local_force[thread][Z][i] = 0.0;
                local_recv_force[thread][X][i] = 0.0;
                local_recv_force[thread][Y][i] = 0.0;
                local_recv_force[thread][Z][i] = 0.0;
            }
        }

        //The inner loop iteration is chunked into blocks to improve cache usage
        //If each inner loop only iterates over a maximum of 2048 elements, then these elements remain in cache for all outer loop iterations
        //2048 elements/particles use 112KiB of data
        //The Xeon Gold 6148F has a L1 Cache size of 640 KiB
        //This blocksize leaves enough space for stack variables and for preloading outer loop particles
        //For a CPU with a smaller L1 Cache this value has to be adjusted
        const size_t block_size = 256;
        size_t num_blocks = local_N / block_size;
        if(num_blocks * block_size != local_N)num_blocks++;
        
        for(size_t b = 0;b < num_blocks;b++)
        {
            //Choose the index interval of the current block
            size_t curr_block = b * block_size;
            size_t next_block = (b+1) * block_size;

            //Limit the intervall by local_N
            size_t k_bound = std::min(next_block, local_N);

            //Only iterate over all indices smaller than the largest index in the current block interval
#pragma omp for schedule(static, 1)
            for(size_t k = 0;k < k_bound;k++)
            {
                // G-mass product can be precalculated as the mass does not change between timesteps
                double pre_calc = -G*nb_sys.mass[rank*local_N+k];

                //If k is in the interval of all previous block indices, then calculate all forcepairs
                //Otherwise only calculate if k < q
                size_t q = (rank < (rank+recv_round)%comm_sz ? k : k + 1);
                q = std::max(q, curr_block);

                //Fix alignment to the next 32-bit aligned address
                //All arrays are allocated as 64-bit aligned
                size_t align_offset = (q & 0b11);
                
                size_t mass_q_offset = ((rank + recv_round)%comm_sz)*local_N;
                switch(align_offset)
                {
                    case 0:
                        break;
                    default:
                    for(size_t peel = 0; peel < 4 - align_offset && q < k_bound ;peel++,q++)
                    {
                        double diff[DIM];
                        diff[X] = nb_sys.pos[X][k] - recv_pos[X][q];
                        diff[Y] = nb_sys.pos[Y][k] - recv_pos[Y][q];
                        diff[Z] = nb_sys.pos[Z][k] - recv_pos[Z][q];
                        double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        double force_ij[DIM];
                        force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                        force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                        force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                        thread_local_force[X][k] += force_ij[X];
                        thread_local_force[Y][k] += force_ij[Y];
                        thread_local_force[Z][k] += force_ij[Z];
                        thread_local_recv_force[X][q] -= force_ij[X];
                        thread_local_recv_force[Y][q] -= force_ij[Y];
                        thread_local_recv_force[Z][q] -= force_ij[Z];
                    }
                    break;
                }
                
                //preload values of the kth particle to registers
                //The values are spread among an entire AVX2 register
                //e.g. pos[k].x -> AVX2_reg{pos[k].x, pos[k].x, pos[k].x, pos[k].x}
                __m256d force_k_x = _mm256_set1_pd(0.0);
                __m256d force_k_y = _mm256_set1_pd(0.0);
                __m256d force_k_z = _mm256_set1_pd(0.0);
                __m256d pos_k_x = _mm256_set1_pd(nb_sys.pos[X][k]);
                __m256d pos_k_y = _mm256_set1_pd(nb_sys.pos[Y][k]);
                __m256d pos_k_z = _mm256_set1_pd(nb_sys.pos[Z][k]);
                __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);

                //Vectorized loop body
                for(;q+3 < k_bound;q+=4)
                {
                    //diff = pos[k] - pos[q]
                    __m256d diff_x = pos_k_x;
                    __m256d diff_y = pos_k_y;
                    __m256d diff_z = pos_k_z;
                    __m256d pos_q_x = _mm256_load_pd(&(recv_pos[X][q]));
                    __m256d pos_q_y = _mm256_load_pd(&(recv_pos[Y][q]));
                    __m256d pos_q_z = _mm256_load_pd(&(recv_pos[Z][q]));
                    diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                    diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                    diff_z = _mm256_sub_pd(diff_z, pos_q_z);

                    //dist^2 = dot_prod(diff,diff);
                    __m256d dist = _mm256_mul_pd(diff_x,diff_x);
                    __m256d tmp = _mm256_mul_pd(diff_y,diff_y);
                    dist = _mm256_add_pd(dist,tmp);
                    tmp = _mm256_mul_pd(diff_z,diff_z);
                    dist = _mm256_add_pd(dist,tmp);
                   
                    //dist = sqrt(dist^2)
                    dist = _mm256_sqrt_pd(dist);

                    //dist^3 = dist * dist * dist
                    __m256d dist3  = _mm256_mul_pd(dist,dist);
                    dist3 = _mm256_mul_pd(dist, dist3);

                    
                    __m256d force_q_x = _mm256_load_pd(&(thread_local_recv_force[X][q]));
                    __m256d force_q_y = _mm256_load_pd(&(thread_local_recv_force[Y][q]));
                    __m256d force_q_z = _mm256_load_pd(&(thread_local_recv_force[Z][q]));

                    //force_kq = ((-G * mass[k] * mass[q])/dist^3)*diff 
                    __m256d scalar_factor = _mm256_load_pd(&nb_sys.mass[mass_q_offset+q]);
                    scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm256_div_pd(scalar_factor, dist3);
                    __m256d force_x = _mm256_mul_pd(scalar_factor,diff_x);
                    __m256d force_y = _mm256_mul_pd(scalar_factor,diff_y);
                    __m256d force_z = _mm256_mul_pd(scalar_factor,diff_z);

                    
                    //force_q -= force_kq
                    force_q_x = _mm256_sub_pd(force_q_x, force_x);
                    force_q_y = _mm256_sub_pd(force_q_y, force_y);
                    force_q_z = _mm256_sub_pd(force_q_z, force_z);
                    
                    
                    _mm256_store_pd(&(thread_local_recv_force[X][q]), force_q_x);
                    _mm256_store_pd(&(thread_local_recv_force[Y][q]), force_q_y);
                    _mm256_store_pd(&(thread_local_recv_force[Z][q]), force_q_z);

                    //force_k += force_kq
                    force_k_x = _mm256_add_pd(force_k_x, force_x);
                    force_k_y = _mm256_add_pd(force_k_y, force_y);
                    force_k_z = _mm256_add_pd(force_k_z, force_z);
                }
                //force_k has been partially calculated over the 4 entries of the AVX2 register
                //perform horizontal add across AVX2 register to get the resulting force[k]
                //{force_k0, force_k1, force_k2, force_k3} -> {force_k0 + force_k2, force_k1 + force_k3}
                //-> force_k0 + force_k1 + force_k2 + force_k3
                __m128d force_k_x_low = _mm256_castpd256_pd128(force_k_x);
                __m128d force_k_x_high = _mm256_extractf128_pd(force_k_x,1);
                __m128d force_k_y_low = _mm256_castpd256_pd128(force_k_y);
                __m128d force_k_y_high = _mm256_extractf128_pd(force_k_y,1);
                __m128d force_k_z_low = _mm256_castpd256_pd128(force_k_z);
                __m128d force_k_z_high = _mm256_extractf128_pd(force_k_z,1);
                force_k_x_low = _mm_add_pd(force_k_x_low, force_k_x_high);
                force_k_y_low = _mm_add_pd(force_k_y_low, force_k_y_high);
                force_k_z_low = _mm_add_pd(force_k_z_low, force_k_z_high);
                __m128d force_k_x_high64 = _mm_unpackhi_pd(force_k_x_low, force_k_x_low);
                __m128d force_k_y_high64 = _mm_unpackhi_pd(force_k_y_low, force_k_y_low);
                __m128d force_k_z_high64 = _mm_unpackhi_pd(force_k_z_low, force_k_z_low);
                thread_local_force[X][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_x_low, force_k_x_high64));
                thread_local_force[Y][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_y_low, force_k_y_high64));
                thread_local_force[Z][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_z_low, force_k_z_high64));

                //Loop remainder
                for(;q < k_bound;q++)
                {
                    
                    double diff[DIM];
                    diff[X] = nb_sys.pos[X][k] - recv_pos[X][q];
                    diff[Y] = nb_sys.pos[Y][k] - recv_pos[Y][q];
                    diff[Z] = nb_sys.pos[Z][k] - recv_pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                    thread_local_force[X][k] += force_ij[X];
                    thread_local_force[Y][k] += force_ij[Y];
                    thread_local_force[Z][k] += force_ij[Z];
                    thread_local_recv_force[X][q] -= force_ij[X];
                    thread_local_recv_force[Y][q] -= force_ij[Y];
                    thread_local_recv_force[Z][q] -= force_ij[Z];
                }
            }
        }
        //The accumulation of force[q] was split into a seperate array
        //The two arrays containing the results of force[k] and force[q] have to be accumulated
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads; thread++)
            {
                nb_sys.force[X][i] += local_force[thread][X][i];
                nb_sys.force[Y][i] += local_force[thread][Y][i];
                nb_sys.force[Z][i] += local_force[thread][Z][i];
                recv_force[X][i] += local_recv_force[thread][X][i];
                recv_force[Y][i] += local_recv_force[thread][Y][i];
                recv_force[Z][i] += local_recv_force[thread][Z][i];
            }
        }
    }
}

void compute_forces_avx512_rsqrt_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        double* thread_local_force_x = local_force[thread_rank][X];
        double* thread_local_force_y = local_force[thread_rank][Y];
        double* thread_local_force_z = local_force[thread_rank][Z];
        double* thread_local_recv_force_x = local_recv_force[thread_rank][X];
        double* thread_local_recv_force_y = local_recv_force[thread_rank][Y];
        double* thread_local_recv_force_z = local_recv_force[thread_rank][Z];
        double* pos_x = nb_sys.pos[X];
        double* pos_y = nb_sys.pos[Y];
        double* pos_z = nb_sys.pos[Z];
        double* recv_pos_x = recv_pos[X];
        double* recv_pos_y = recv_pos[Y];
        double* recv_pos_z = recv_pos[Z];

        //Reset all forces before each timestep
        //TODO: Might be inefficient access pattern
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0;
                local_force[thread][Y][i] = 0.0;
                local_force[thread][Z][i] = 0.0;
                local_recv_force[thread][X][i] = 0.0;
                local_recv_force[thread][Y][i] = 0.0;
                local_recv_force[thread][Z][i] = 0.0;
            }
        }



        //The inner loop iteration is chunked into blocks to improve cache usage
        //If each inner loop only iterates over a maximum of 2048 elements, then these elements remain in cache for all outer loop iterations
        //2048 elements/particles use 112KiB of data
        //The Xeon Gold 6148F has a L1 Cache size of 640 KiB
        //This blocksize leaves enough space for stack variables and for preloading outer loop particles
        //For a CPU with a smaller L1 Cache this value has to be adjusted
        const size_t block_size = 256;
        size_t num_blocks = local_N / block_size;
        if(num_blocks * block_size != local_N)num_blocks++;
        
        for(size_t b = 0;b < num_blocks;b++)
        {
            //Choose the index interval of the current block
            size_t curr_block = b * block_size;
            size_t next_block = (b+1) * block_size;

            //Limit the intervall by local_N
            size_t k_bound = std::min(next_block, local_N);

            //Only iterate over all indices smaller than the largest index in the current block interval
#pragma omp for schedule(static, 1)
            for(size_t k = 0;k < k_bound;k++)
            {
                // G-mass product can be precalculated as the mass does not change between timesteps
                double pre_calc = -G*nb_sys.mass[rank*local_N+k];

                //If k is in the interval of all previous block indices, then calculate all forcepairs
                //Otherwise only calculate if k < q
                size_t q = (rank < (rank+recv_round)%comm_sz ? k : k + 1);
                q = std::max(q, curr_block);

                //Fix alignment to the next 32-bit aligned address
                //All arrays are allocated as 64-bit aligned
                size_t align_offset = (q & 0b111);
                
                size_t mass_q_offset = ((rank + recv_round)%comm_sz)*local_N;
                switch(align_offset)
                {
                    case 0:
                        break;
                    default:
                    for(size_t peel = 0; peel < 8 - align_offset && q < k_bound ;peel++,q++)
                    {
                        double diff[DIM];
                        diff[X] = pos_x[k] - recv_pos_x[q];
                        diff[Y] = pos_y[k] - recv_pos_y[q];
                        diff[Z] = pos_z[k] - recv_pos_z[q];
                        double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        double force_ij[DIM];
                        force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                        force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                        force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                        thread_local_force_x[k] += force_ij[X];
                        thread_local_force_y[k] += force_ij[Y];
                        thread_local_force_z[k] += force_ij[Z];
                        thread_local_recv_force_x[q] -= force_ij[X];
                        thread_local_recv_force_y[q] -= force_ij[Y];
                        thread_local_recv_force_z[q] -= force_ij[Z];
                    }
                    break;
                }
                
                //force[k] is calculated simultaneously across 8 registers
                __m512d force_k_x = _mm512_set1_pd(0.0);
                __m512d force_k_y = _mm512_set1_pd(0.0);
                __m512d force_k_z = _mm512_set1_pd(0.0);
                
                //preload innerloop constants to registers
                __m512d pos_k_x = _mm512_set1_pd(pos_x[k]);
                __m512d pos_k_y = _mm512_set1_pd(pos_y[k]);
                __m512d pos_k_z = _mm512_set1_pd(pos_z[k]);
                __m512d pre_calc_avx = _mm512_set1_pd(pre_calc);
                __m512d three = _mm512_set1_pd(3.0);
                __m512d half = _mm512_set1_pd(0.5);

                //Vectorized loop body
                for(;q+7 < k_bound;q+=8)
                {
                    //diff = pos[k] - pos[q]
                    __m512d diff_x = pos_k_x;
                    __m512d diff_y = pos_k_y;
                    __m512d diff_z = pos_k_z;
                    __m512d pos_q_x = _mm512_load_pd(&(recv_pos_x[q]));
                    __m512d pos_q_y = _mm512_load_pd(&(recv_pos_y[q]));
                    __m512d pos_q_z = _mm512_load_pd(&(recv_pos_z[q]));
                    diff_x = _mm512_sub_pd(diff_x, pos_q_x);
                    diff_y = _mm512_sub_pd(diff_y, pos_q_y);
                    diff_z = _mm512_sub_pd(diff_z, pos_q_z);

                    //dist^2 = <diff,diff>
                    __m512d inv_dist_sq = _mm512_mul_pd(diff_x,diff_x);
                    __m512d inv_dist = _mm512_mul_pd(diff_y,diff_y);
                    inv_dist_sq = _mm512_add_pd(inv_dist_sq, inv_dist);
                    inv_dist = _mm512_mul_pd(diff_z,diff_z);
                    inv_dist_sq = _mm512_add_pd(inv_dist_sq, inv_dist);


                    //Calculate invdist = 1/dist by using the rsqrt instruction and Refinement by Newton's Method:
                    //guess: y_0 = rsqrt(dist^2)
                    inv_dist = _mm512_rsqrt14_pd(inv_dist_sq);
                   
                    //First iterative refinement:
                    //y_n+1 = 0.5 * y_n * (3 - x * y_n * y_n)
                    __m512d tmp_approx = _mm512_mul_pd(inv_dist,inv_dist); // y*y
                    tmp_approx = _mm512_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                    tmp_approx = _mm512_sub_pd(three, tmp_approx); //3-x*y*y
                    inv_dist = _mm512_mul_pd(inv_dist, half);//y*0.5
                    inv_dist = _mm512_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)
                    
                    //Second iterative refinement:
                    tmp_approx = _mm512_mul_pd(inv_dist,inv_dist); // y*y
                    tmp_approx = _mm512_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                    tmp_approx = _mm512_sub_pd(three, tmp_approx); //3-x*y*y
                    inv_dist = _mm512_mul_pd(inv_dist, half);//y*0.5
                    inv_dist = _mm512_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)
                    //inv_dist = y_2

                    
                    //inv_dist^3 = inv_dist * inv_dist * inv_dist
                    __m512d inv_dist3  = _mm512_mul_pd(inv_dist,inv_dist);
                    inv_dist3 = _mm512_mul_pd(inv_dist, inv_dist3);

                    __m512d force_q_x = _mm512_load_pd(&(thread_local_recv_force_x[q]));
                    __m512d force_q_y = _mm512_load_pd(&(thread_local_recv_force_y[q]));
                    __m512d force_q_z = _mm512_load_pd(&(thread_local_recv_force_z[q]));

                    //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                    __m512d scalar_factor = _mm512_load_pd(&(nb_sys.mass[mass_q_offset+q]));
                    scalar_factor = _mm512_mul_pd(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm512_mul_pd(scalar_factor, inv_dist3);

                    __m512d force_x = _mm512_mul_pd(scalar_factor,diff_x);
                    __m512d force_y = _mm512_mul_pd(scalar_factor,diff_y);
                    __m512d force_z = _mm512_mul_pd(scalar_factor,diff_z);

                    //force_k += force_kq
                    force_k_x = _mm512_add_pd(force_k_x, force_x);
                    force_k_y = _mm512_add_pd(force_k_y, force_y);
                    force_k_z = _mm512_add_pd(force_k_z, force_z);
                    
                    //force[q] -= force_kq
                    force_q_x = _mm512_sub_pd(force_q_x, force_x);
                    force_q_y = _mm512_sub_pd(force_q_y, force_y);
                    force_q_z = _mm512_sub_pd(force_q_z, force_z);
                    
                    
                    _mm512_store_pd(&(thread_local_recv_force_x[q]), force_q_x);
                    _mm512_store_pd(&(thread_local_recv_force_y[q]), force_q_y);
                    _mm512_store_pd(&(thread_local_recv_force_z[q]), force_q_z);

                }
                //horizontal add across force_k before storing the result back to memory
                //force[k] += h_add(force_k)
                thread_local_force_x[k] += _mm512_reduce_add_pd(force_k_x);
                thread_local_force_y[k] += _mm512_reduce_add_pd(force_k_y);
                thread_local_force_z[k] += _mm512_reduce_add_pd(force_k_z);

                //Loop remainder
                for(;q < k_bound;q++)
                {
                    
                    double diff[DIM];
                    diff[X] = pos_x[k] - recv_pos_x[q];
                    diff[Y] = pos_y[k] - recv_pos_y[q];
                    diff[Z] = pos_z[k] - recv_pos_z[q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                    thread_local_force_x[k] += force_ij[X];
                    thread_local_force_y[k] += force_ij[Y];
                    thread_local_force_z[k] += force_ij[Z];
                    thread_local_recv_force_x[q] -= force_ij[X];
                    thread_local_recv_force_y[q] -= force_ij[Y];
                    thread_local_recv_force_z[q] -= force_ij[Z];
                }
            }
        }
        //The accumulation of force[q] was split into a seperate array
        //The two arrays containing the results of force[k] and force[q] have to be accumulated
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads; thread++)
            {
                nb_sys.force[X][i] += local_force[thread][X][i];
                nb_sys.force[Y][i] += local_force[thread][Y][i];
                nb_sys.force[Z][i] += local_force[thread][Z][i];
                recv_force[X][i] += local_recv_force[thread][X][i];
                recv_force[Y][i] += local_recv_force[thread][Y][i];
                recv_force[Z][i] += local_recv_force[thread][Z][i];
            }
        }
    }
}

void compute_forces_avx512_rsqrt_4i_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        double* thread_local_force_x = local_force[thread_rank][X];
        double* thread_local_force_y = local_force[thread_rank][Y];
        double* thread_local_force_z = local_force[thread_rank][Z];
        double* thread_local_recv_force_x = local_recv_force[thread_rank][X];
        double* thread_local_recv_force_y = local_recv_force[thread_rank][Y];
        double* thread_local_recv_force_z = local_recv_force[thread_rank][Z];
        double* pos_x = nb_sys.pos[X];
        double* pos_y = nb_sys.pos[Y];
        double* pos_z = nb_sys.pos[Z];
        double* recv_pos_x = recv_pos[X];
        double* recv_pos_y = recv_pos[Y];
        double* recv_pos_z = recv_pos[Z];

        //Reset all forces before each timestep
        //TODO: Might be inefficient access pattern
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0;
                local_force[thread][Y][i] = 0.0;
                local_force[thread][Z][i] = 0.0;
                local_recv_force[thread][X][i] = 0.0;
                local_recv_force[thread][Y][i] = 0.0;
                local_recv_force[thread][Z][i] = 0.0;
            }
        }



        //The inner loop iteration is chunked into blocks to improve cache usage
        //If each inner loop only iterates over a maximum of 2048 elements, then these elements remain in cache for all outer loop iterations
        //2048 elements/particles use 112KiB of data
        //The Xeon Gold 6148F has a L1 Cache size of 640 KiB
        //This blocksize leaves enough space for stack variables and for preloading outer loop particles
        //For a CPU with a smaller L1 Cache this value has to be adjusted
        const size_t block_size = 1024;
        size_t num_blocks = local_N / block_size;
        if(num_blocks * block_size != local_N)num_blocks++;
        
        for(size_t b = 0;b < num_blocks;b++)
        {
            //Choose the index interval of the current block
            size_t curr_block = b * block_size;
            size_t next_block = (b+1) * block_size;

            //Limit the intervall by local_N
            size_t k_bound = std::min(next_block, local_N);

            //Only iterate over all indices smaller than the largest index in the current block interval
#pragma omp for schedule(static, 1)
            for(size_t k = 0;k < k_bound;k++)
            {
                // G-mass product can be precalculated as the mass does not change between timesteps
                double pre_calc = -G*nb_sys.mass[rank*local_N+k];

                //If k is in the interval of all previous block indices, then calculate all forcepairs
                //Otherwise only calculate if k < q
                size_t q = (rank < (rank+recv_round)%comm_sz ? k : k + 1);
                q = std::max(q, curr_block);

                //Fix alignment to the next 32-bit aligned address
                //All arrays are allocated as 64-bit aligned
                size_t align_offset = (q & 0b111);
                
                size_t mass_q_offset = ((rank + recv_round)%comm_sz)*local_N;
                switch(align_offset)
                {
                    case 0:
                        break;
                    default:
                    for(size_t peel = 0; peel < 8 - align_offset && q < k_bound;peel++,q++)
                    {
                        double diff[DIM];
                        diff[X] = pos_x[k] - recv_pos_x[q];
                        diff[Y] = pos_y[k] - recv_pos_y[q];
                        diff[Z] = pos_z[k] - recv_pos_z[q];
                        double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        double force_ij[DIM];
                        force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                        force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                        force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                        thread_local_force_x[k] += force_ij[X];
                        thread_local_force_y[k] += force_ij[Y];
                        thread_local_force_z[k] += force_ij[Z];
                        thread_local_recv_force_x[q] -= force_ij[X];
                        thread_local_recv_force_y[q] -= force_ij[Y];
                        thread_local_recv_force_z[q] -= force_ij[Z];
                    }
                    break;
                }
                //force[k] is calculated simultaneously across 8 registers
                //preload innerloop constants to registers
                __m512d pos_k_x = _mm512_set1_pd(pos_x[k]);
                __m512d pos_k_y = _mm512_set1_pd(pos_y[k]);
                __m512d pos_k_z = _mm512_set1_pd(pos_z[k]);
                __m512d pre_calc_avx = _mm512_set1_pd(pre_calc);
                __m512d three = _mm512_set1_pd(3.0);
                __m512d half = _mm512_set1_pd(0.5);

                constexpr size_t ii = 4;
                constexpr size_t loop_inc = 8*ii;
                constexpr size_t loop_bound_offset = loop_inc - 1;
                __m512d reg1[ii];
                __m512d reg2[ii];
                __m512d reg3[ii];
                
                
                __m512d force_k_x[ii];
                __m512d force_k_y[ii];
                __m512d force_k_z[ii];
                for(size_t i = 0;i < ii;i++)
                {
                    force_k_x[i] = _mm512_set1_pd(0.0);
                    force_k_y[i] = _mm512_set1_pd(0.0);
                    force_k_z[i] = _mm512_set1_pd(0.0);
                }
            

                for(;q+loop_bound_offset < k_bound;q+=loop_inc)
                {
                    //diff = pos[k] - pos[q]
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_load_pd(&(recv_pos_x[q+8*i]));
                        reg1[i] = _mm512_sub_pd(pos_k_x, reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_load_pd(&(recv_pos_y[q+8*i]));
                        reg2[i] = _mm512_sub_pd(pos_k_y, reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_load_pd(&(recv_pos_z[q+8*i]));
                        reg3[i] = _mm512_sub_pd(pos_k_z, reg3[i]);
                    }

                    //dist^2 = <diff,diff>
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_mul_pd(reg1[i],reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_mul_pd(reg2[i],reg2[i]);
                        reg1[i] = _mm512_add_pd(reg1[i],reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_mul_pd(reg3[i],reg3[i]);
                        reg1[i] = _mm512_add_pd(reg1[i],reg3[i]);
                    }
                    asm volatile("": : :"memory");


                    //Calculate invdist = 1/dist by using the rsqrt instruction and Refinement by Newton's Method:
                    //guess: y_0 = rsqrt(dist^2)
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_rsqrt14_pd(reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_mul_pd(reg2[i],reg2[i]); // y*y
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_fnmadd_pd(reg3[i], reg1[i], three); //3-x*y*y
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_mul_pd(reg2[i], half);//y*0.5
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_mul_pd(reg2[i], reg3[i]);//y*0.5 *(3-x*y*y)
                    }
                    asm volatile("": : :"memory");
                    
                    //Second iterative refinement:
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_mul_pd(reg2[i],reg2[i]); // y*y
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_fnmadd_pd(reg3[i], reg1[i], three); //3-x*y*y
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_mul_pd(reg2[i], half);//y*0.5
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_mul_pd(reg2[i], reg3[i]);//y*0.5 *(3-x*y*y)
                    }
                    asm volatile("": : :"memory");
                    //inv_dist = y_2
                    
                    //inv_dist^3 = inv_dist * inv_dist * inv_dist
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i]  = _mm512_mul_pd(reg2[i],reg2[i]);
                        reg1[i] = _mm512_mul_pd(reg1[i], reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    
                    //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_load_pd(&nb_sys.mass[mass_q_offset+q+8*i]);
                        reg3[i] = _mm512_mul_pd(pre_calc_avx, reg3[i]);
                    }
                    asm volatile("": : :"memory");

                    for(size_t i = 0;i < ii;i++)
                    {
                        reg3[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_load_pd(&(recv_pos_x[q+8*i]));
                        reg1[i] = _mm512_sub_pd(pos_k_x, reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                        force_k_x[i] = _mm512_add_pd(force_k_x[i], reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_load_pd(&(thread_local_recv_force_x[q+8*i]));
                        reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                        _mm512_store_pd(&(thread_local_recv_force_x[q+8*i]), reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_load_pd(&(recv_pos_y[q+8*i]));
                        reg1[i] = _mm512_sub_pd(pos_k_y, reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                        force_k_y[i] = _mm512_add_pd(force_k_y[i], reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_load_pd(&(thread_local_recv_force_y[q+8*i]));
                        reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                        _mm512_store_pd(&(thread_local_recv_force_y[q+8*i]), reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_load_pd(&(recv_pos_z[q+8*i]));
                        reg1[i] = _mm512_sub_pd(pos_k_z, reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                        force_k_z[i] = _mm512_add_pd(force_k_z[i], reg1[i]);
                    }
                    asm volatile("": : :"memory");
                    for(size_t i = 0;i < ii;i++)
                    {
                        reg2[i] = _mm512_load_pd(&(thread_local_recv_force_z[q+8*i]));
                        reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                        _mm512_store_pd(&(thread_local_recv_force_z[q+8*i]), reg2[i]);
                    }
                    asm volatile("": : :"memory");
                    
                }
                for(size_t i = 1;i < ii;i++)
                {
                    force_k_x[0] = _mm512_add_pd(force_k_x[0], force_k_x[i]);
                    force_k_y[0] = _mm512_add_pd(force_k_y[0], force_k_y[i]);
                    force_k_z[0] = _mm512_add_pd(force_k_z[0], force_k_z[i]);
                }
                for(;q+7 < k_bound;q+=8)
                {
                    //diff = pos[k] - pos[q]
                    __m512d diff_x = pos_k_x;
                    __m512d diff_y = pos_k_y;
                    __m512d diff_z = pos_k_z;
                    __m512d pos_q_x = _mm512_load_pd(&(recv_pos_x[q]));
                    __m512d pos_q_y = _mm512_load_pd(&(recv_pos_y[q]));
                    __m512d pos_q_z = _mm512_load_pd(&(recv_pos_z[q]));
                    diff_x = _mm512_sub_pd(diff_x, pos_q_x);
                    diff_y = _mm512_sub_pd(diff_y, pos_q_y);
                    diff_z = _mm512_sub_pd(diff_z, pos_q_z);

                    //dist^2 = <diff,diff>
                    __m512d inv_dist_sq = _mm512_mul_pd(diff_x,diff_x);
                    __m512d inv_dist = _mm512_mul_pd(diff_y,diff_y);
                    inv_dist_sq = _mm512_add_pd(inv_dist_sq, inv_dist);
                    inv_dist = _mm512_mul_pd(diff_z,diff_z);
                    inv_dist_sq = _mm512_add_pd(inv_dist_sq, inv_dist);


                    //Calculate invdist = 1/dist by using the rsqrt instruction and Refinement by Newton's Method:
                    //guess: y_0 = rsqrt(dist^2)
                    inv_dist = _mm512_rsqrt14_pd(inv_dist_sq);
                   
                    //First iterative refinement:
                    //y_n+1 = 0.5 * y_n * (3 - x * y_n * y_n)
                    __m512d tmp_approx = _mm512_mul_pd(inv_dist,inv_dist); // y*y
                    tmp_approx = _mm512_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                    tmp_approx = _mm512_sub_pd(three, tmp_approx); //3-x*y*y
                    inv_dist = _mm512_mul_pd(inv_dist, half);//y*0.5
                    inv_dist = _mm512_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)
                    
                    //Second iterative refinement:
                    tmp_approx = _mm512_mul_pd(inv_dist,inv_dist); // y*y
                    tmp_approx = _mm512_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                    tmp_approx = _mm512_sub_pd(three, tmp_approx); //3-x*y*y
                    inv_dist = _mm512_mul_pd(inv_dist, half);//y*0.5
                    inv_dist = _mm512_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)
                    //inv_dist = y_2

                    
                    //inv_dist^3 = inv_dist * inv_dist * inv_dist
                    __m512d inv_dist3  = _mm512_mul_pd(inv_dist,inv_dist);
                    inv_dist3 = _mm512_mul_pd(inv_dist, inv_dist3);

                    __m512d force_q_x = _mm512_load_pd(&(thread_local_recv_force_x[q]));
                    __m512d force_q_y = _mm512_load_pd(&(thread_local_recv_force_y[q]));
                    __m512d force_q_z = _mm512_load_pd(&(thread_local_recv_force_z[q]));

                    //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                    __m512d scalar_factor = _mm512_load_pd(&(nb_sys.mass[mass_q_offset+q]));
                    scalar_factor = _mm512_mul_pd(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm512_mul_pd(scalar_factor, inv_dist3);

                    __m512d force_x = _mm512_mul_pd(scalar_factor,diff_x);
                    __m512d force_y = _mm512_mul_pd(scalar_factor,diff_y);
                    __m512d force_z = _mm512_mul_pd(scalar_factor,diff_z);

                    //force_k += force_kq
                    force_k_x[0] = _mm512_add_pd(force_k_x[0], force_x);
                    force_k_y[0] = _mm512_add_pd(force_k_y[0], force_y);
                    force_k_z[0] = _mm512_add_pd(force_k_z[0], force_z);
                    
                    //force[q] -= force_kq
                    force_q_x = _mm512_sub_pd(force_q_x, force_x);
                    force_q_y = _mm512_sub_pd(force_q_y, force_y);
                    force_q_z = _mm512_sub_pd(force_q_z, force_z);
                    
                    
                    _mm512_store_pd(&(thread_local_recv_force_x[q]), force_q_x);
                    _mm512_store_pd(&(thread_local_recv_force_y[q]), force_q_y);
                    _mm512_store_pd(&(thread_local_recv_force_z[q]), force_q_z);

                }
                thread_local_force_x[k] += _mm512_reduce_add_pd(force_k_x[0]);
                thread_local_force_y[k] += _mm512_reduce_add_pd(force_k_y[0]);
                thread_local_force_z[k] += _mm512_reduce_add_pd(force_k_z[0]);

                //Loop remainder
                for(;q < k_bound;q++)
                {
                    
                    double diff[DIM];
                    diff[X] = pos_x[k] - recv_pos_x[q];
                    diff[Y] = pos_y[k] - recv_pos_y[q];
                    diff[Z] = pos_z[k] - recv_pos_z[q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
                    thread_local_force_x[k] += force_ij[X];
                    thread_local_force_y[k] += force_ij[Y];
                    thread_local_force_z[k] += force_ij[Z];
                    thread_local_recv_force_x[q] -= force_ij[X];
                    thread_local_recv_force_y[q] -= force_ij[Y];
                    thread_local_recv_force_z[q] -= force_ij[Z];
                }
            }
        }
        //The accumulation of force[q] was split into a seperate array
        //The two arrays containing the results of force[k] and force[q] have to be accumulated
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads; thread++)
            {
                nb_sys.force[X][i] += local_force[thread][X][i];
                nb_sys.force[Y][i] += local_force[thread][Y][i];
                nb_sys.force[Z][i] += local_force[thread][Z][i];
                recv_force[X][i] += local_recv_force[thread][X][i];
                recv_force[Y][i] += local_recv_force[thread][Y][i];
                recv_force[Z][i] += local_recv_force[thread][Z][i];
            }
        }
    }
}


void compute_forces_full_avx2(NBody_system& nb_sys, double*** local_force, double** local_pos, double* local_mass, __mmask8** sqrt_mask, size_t local_N, size_t rank, size_t comm_sz, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();

        //Each thread requires its own force array in order to prevent data races.
        double* thread_local_force_x = local_force[thread_rank][X];
        double* thread_local_force_y = local_force[thread_rank][Y];
        double* thread_local_force_z = local_force[thread_rank][Z];
        double* pos_x = nb_sys.pos[X];
        double* pos_y = nb_sys.pos[Y];
        double* pos_z = nb_sys.pos[Z];
        double* local_pos_x = local_pos[X];
        double* local_pos_y = local_pos[Y];
        double* local_pos_z = local_pos[Z];


        __mmask8* thread_local_mask = sqrt_mask[thread_rank];

        //Reset all forces before each timestep
        //TODO: Might be inefficient access pattern
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0;
                local_force[thread][Y][i] = 0.0;
                local_force[thread][Z][i] = 0.0;
            }
        }



        //The inner loop iteration is chunked into blocks to improve cache usage
        //If each inner loop only iterates over a maximum of 2048 elements, then these elements remain in cache for all outer loop iterations
        //2048 elements/particles use 112KiB of data
        //The Xeon Gold 6148F has a L1 Cache size of 640 KiB
        //This blocksize leaves enough space for stack variables and for preloading outer loop particles
        //For a CPU with a smaller L1 Cache this value has to be adjusted
        const size_t block_size = 256;
        size_t num_blocks = local_N / block_size;
        if(num_blocks * block_size != local_N)num_blocks++;
        
        for(size_t b = 0;b < num_blocks;b++)
        {
            //Choose the index interval of the current block
            size_t curr_block = b * block_size;
            size_t next_block = (b+1) * block_size;

            //Only iterate over all indices smaller than the largest index in the current block interval
#pragma omp for schedule(static)
            for(size_t k = 0;k < nb_sys.N;k++)
            {
                size_t curr_mask_index = (k-rank*local_N)/4;
                size_t curr_mask_bit = 1 << ((k-rank*local_N) & 3);
                bool iter_overlap = (k >= rank*local_N && k < (rank+1)*local_N);
                if(iter_overlap)
                {
                    thread_local_mask[curr_mask_index] ^= curr_mask_bit;
                }
                // G-mass product can be precalculated as the mass does not change between timesteps
                double pre_calc = -G*nb_sys.mass[k];

                //If k is in the interval of all previous block indices, then calculate all forcepairs
                //Otherwise only calculate if k < q
                size_t q = curr_block;
                size_t q_bound = std::min(local_N,next_block);
                
                //preload innerloop constants to registers
                __m256d pos_k_x = _mm256_set1_pd(pos_x[k]);
                __m256d pos_k_y = _mm256_set1_pd(pos_y[k]);
                __m256d pos_k_z = _mm256_set1_pd(pos_z[k]);
                __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);

                for(;q+3 < q_bound;q+=4)
                {
                    //diff = pos[k] - pos[q]
                    __m256d diff_x = pos_k_x;
                    __m256d diff_y = pos_k_y;
                    __m256d diff_z = pos_k_z;
                    __m256d pos_q_x = _mm256_load_pd(&(local_pos_x[q]));
                    __m256d pos_q_y = _mm256_load_pd(&(local_pos_y[q]));
                    __m256d pos_q_z = _mm256_load_pd(&(local_pos_z[q]));
                    diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                    diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                    diff_z = _mm256_sub_pd(diff_z, pos_q_z);

                    //dist = sqrt(<diff,diff>)
                    __m256d dist = _mm256_mul_pd(diff_x,diff_x);
                    __m256d tmp = _mm256_mul_pd(diff_y,diff_y);
                    dist = _mm256_add_pd(dist,tmp);
                    tmp = _mm256_mul_pd(diff_z,diff_z);
                    dist = _mm256_add_pd(dist,tmp);
                    dist = _mm256_maskz_sqrt_pd(thread_local_mask[q >> 2],dist);

                    //dist^3 = dist * dist * dist
                    __m256d dist3  = _mm256_mul_pd(dist,dist);
                    dist3 = _mm256_mul_pd(dist, dist3);

                    
                    __m256d force_q_x = _mm256_load_pd(&(thread_local_force_x[q]));
                    __m256d force_q_y = _mm256_load_pd(&(thread_local_force_y[q]));
                    __m256d force_q_z = _mm256_load_pd(&(thread_local_force_z[q]));

                    //force_kq = (-G * mass[k] * mass[q]/dist^3) * diff
                    __m256d scalar_factor = _mm256_load_pd(&local_mass[q]);
                    scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm256_maskz_div_pd(thread_local_mask[q >> 2], scalar_factor, dist3);
                    __m256d force_kq_x = _mm256_mul_pd(scalar_factor,diff_x);
                    __m256d force_kq_y = _mm256_mul_pd(scalar_factor,diff_y);
                    __m256d force_kq_z = _mm256_mul_pd(scalar_factor,diff_z);

                    //force[q] -= force_kq
                    force_q_x = _mm256_sub_pd(force_q_x, force_kq_x);
                    force_q_y = _mm256_sub_pd(force_q_y, force_kq_y);
                    force_q_z = _mm256_sub_pd(force_q_z, force_kq_z);
                    
                    _mm256_store_pd(&(thread_local_force_x[q]), force_q_x);
                    _mm256_store_pd(&(thread_local_force_y[q]), force_q_y);
                    _mm256_store_pd(&(thread_local_force_z[q]), force_q_z);
                }

                //Calculate non vectorized remainder
                for(;q < q_bound;q++)
                {
                    if(k != rank*local_N + q)
                    {
                        double diff[DIM];
                        diff[X] = pos_x[k] - local_pos_x[q];
                        diff[Y] = pos_y[k] - local_pos_y[q];
                        diff[Z] = pos_z[k] - local_pos_z[q];
                        double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        double force_ij[DIM];
                        force_ij[X] = pre_calc*local_mass[q]*diff[X]/(dist*dist*dist);
                        force_ij[Y] = pre_calc*local_mass[q]*diff[Y]/(dist*dist*dist);
                        force_ij[Z] = pre_calc*local_mass[q]*diff[Z]/(dist*dist*dist);
                        thread_local_force_x[q] -= force_ij[X];
                        thread_local_force_y[q] -= force_ij[Y];
                        thread_local_force_z[q] -= force_ij[Z];
                        //printf("%zu: k = %zu, q = %zu, pos[%zu] = {%f,%f,%f}, local_pos[%zu] = {%f,%f,%f}, force[%zu] = {%f,%f,%f}\n", rank, k, q, k, pos_x[k], pos_y[k], pos_z[k], q, local_pos_x[q], local_pos_y[q], local_pos_z[q], q, thread_local_force_x[q], thread_local_force_y[q], thread_local_force_z[q]);
                    }
                }
                if(iter_overlap)
                    thread_local_mask[curr_mask_index] ^= curr_mask_bit;
            }
        }
        //The accumulation of force[q] was split into a seperate array
        //The two arrays containing the results of force[k] and force[q] have to be accumulated
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads; thread++)
            {
                nb_sys.force[X][i] += local_force[thread][X][i];
                nb_sys.force[Y][i] += local_force[thread][Y][i];
                nb_sys.force[Z][i] += local_force[thread][Z][i];
            }
        }
    }

}

void reduced_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, bool blocked, Vectorization_type vect_type)
{
    size_t num_threads = omp_get_max_threads();
    printf("Threads available: %zu\n", num_threads);
   
    //preallocate all needed arrays:
    // - a seperate force array for each thread
    // - each vector coordinate has its seperate array (Struct of arrays) 
    // - recv_pos/recv_force is only necessary for the hybrid solver
    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    double*** local_recv_force = (double***)malloc(num_threads*sizeof(double**));
    double* recv_pos[DIM];
    double* recv_force[DIM];
    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        recv_force[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        }
    }

    for(size_t t = 0;t < time_steps;t++)
    {
        //recv_pos and local pos are the same for the omp solver, as there is no ring communication scheme
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            recv_pos[X][i] = nb_sys.pos[X][i];
            recv_pos[Y][i] = nb_sys.pos[Y][i];
            recv_pos[Z][i] = nb_sys.pos[Z][i];
            recv_force[X][i] = 0.0;
            recv_force[Y][i] = 0.0;
            recv_force[Z][i] = 0.0;
            nb_sys.force[X][i] = 0.0;
            nb_sys.force[Y][i] = 0.0;
            nb_sys.force[Z][i] = 0.0;
        }

        //Decision between cache aware implementation and "default" implementation
        if(vect_type == Vectorization_type::AVX2)
        {
            if(blocked)compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            else compute_forces_avx2(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
        }
        else if(vect_type == Vectorization_type::AVX512RSQRT)
        {
            compute_forces_avx512_rsqrt_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
        }
        else if(vect_type == Vectorization_type::AVX512RSQRT4I)
        {
            compute_forces_avx512_rsqrt_4i_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
        }
        //Integration step: Euler integration
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            nb_sys.pos[X][i] += nb_sys.vel[X][i]*delta_t;
            nb_sys.pos[Y][i] += nb_sys.vel[Y][i]*delta_t;
            nb_sys.pos[Z][i] += nb_sys.vel[Z][i]*delta_t;
            nb_sys.vel[X][i] += ((recv_force[X][i] + nb_sys.force[X][i])*delta_t)/nb_sys.mass[i];
            nb_sys.vel[Y][i] += ((recv_force[Y][i] + nb_sys.force[Y][i])*delta_t)/nb_sys.mass[i];
            nb_sys.vel[Z][i] += ((recv_force[Z][i] + nb_sys.force[Z][i])*delta_t)/nb_sys.mass[i];
        }
    }

    //Free all previously allocated arrays
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]); 
            free(local_recv_force[thread][d]); 
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        free(recv_force[d]);
        free(recv_pos[d]);
    }
    free(local_force);
    free(local_recv_force);
}

void full_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, Vectorization_type vect_type)
{
    size_t num_threads = omp_get_max_threads();
    printf("Threads available: %zu\n", num_threads);
   
    //preallocate all needed arrays:
    // - a seperate force array for each thread
    // - each vector coordinate has its seperate array (Struct of arrays) 
    // - recv_pos/recv_force is only necessary for the hybrid solver
    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    size_t num_masks = nb_sys.N/4;
    if(num_masks*4 != nb_sys.N)num_masks++;
    __mmask8** sqrt_mask = (__mmask8**)malloc(num_threads*sizeof(__mmask8*));

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        sqrt_mask[thread] = (__mmask8*)malloc(num_masks*sizeof(__mmask8));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        }
        for(size_t k = 0;k < num_masks;k++)
        {
            sqrt_mask[thread][k] = 0xFF;
        }
    }

    for(size_t t = 0;t < time_steps;t++)
    {
        //recv_pos and local pos are the same for the omp solver, as there is no ring communication scheme
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            nb_sys.force[X][i] = 0.0;
            nb_sys.force[Y][i] = 0.0;
            nb_sys.force[Z][i] = 0.0;
        }

        //Decision between cache aware implementation and "default" implementation
        if(vect_type == Vectorization_type::AVX2)
        {
            compute_forces_full_avx2(nb_sys, local_force, nb_sys.pos, nb_sys.mass, sqrt_mask, nb_sys.N, 0, 1, num_threads);
        }
        /*
        else if(vect_type == Vectorization_type::AVX512RSQRT)
        {
            compute_forces_full_avx512_rsqrt(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
        }
        */
        //Integration step: Euler integration
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            nb_sys.pos[X][i] += nb_sys.vel[X][i]*delta_t;
            nb_sys.pos[Y][i] += nb_sys.vel[Y][i]*delta_t;
            nb_sys.pos[Z][i] += nb_sys.vel[Z][i]*delta_t;
            nb_sys.vel[X][i] += (nb_sys.force[X][i]*delta_t)/nb_sys.mass[i];
            nb_sys.vel[Y][i] += (nb_sys.force[Y][i]*delta_t)/nb_sys.mass[i];
            nb_sys.vel[Z][i] += (nb_sys.force[Z][i]*delta_t)/nb_sys.mass[i];
        }
    }

    //Free all previously allocated arrays
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]); 
        }
        free(local_force[thread]);
        free(sqrt_mask[thread]);
    }
    free(local_force);
    free(sqrt_mask);
}

void reduced_solver_omp_lf(NBody_system& nb_sys, size_t time_steps, double delta_t, double* c, double* d, size_t lf_steps, bool blocked)
{
    size_t num_threads = omp_get_max_threads();
    printf("Threads available: %zu\n", num_threads);
   
    //preallocate all needed arrays:
    // - a seperate force array for each thread
    // - each vector coordinate has its seperate array (Struct of arrays) 
    // - recv_pos is only necessary for the hybrid solver
    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    double*** local_recv_force = (double***)malloc(num_threads*sizeof(double**));
    double* recv_pos[DIM];
    double* recv_force[DIM];
    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        recv_force[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        }
    }

    double force_time = 0.0;
    double int_time = 0.0;

    for(size_t t = 0;t < time_steps;t++)
    {
        // Leap frog integration:
        // - pos_1 = pos_0 + vel_0 * c[0] * delta_t
        // - vel_1 = vel_0 + acc_0 * d[0] * delta_t
        // - ...
        // - pos_s-1 = pos_s-2 + vel_s-2 * c[s-1] * delta_t
        // - vel_s-1 = pos_s-1 + acc_s-2 * d[s-1] * delta_t
        // - pos_s = pos_s-1 + vel_s-1 * c[s] * delta_t
        // In total s-1(lf_steps-1) force evaluations are necessary 

        //Carry out the s-1 force evaluations
        for(size_t step = 0;step < lf_steps-1;step++)
        {
            double start = omp_get_wtime();
#pragma omp parallel for simd
            for(size_t i = 0;i < nb_sys.N;i++)
            {
                nb_sys.pos[X][i] += c[step]*nb_sys.vel[X][i]*delta_t;
                nb_sys.pos[Y][i] += c[step]*nb_sys.vel[Y][i]*delta_t;
                nb_sys.pos[Z][i] += c[step]*nb_sys.vel[Z][i]*delta_t;
                recv_pos[X][i] = nb_sys.pos[X][i];
                recv_pos[Y][i] = nb_sys.pos[Y][i];
                recv_pos[Z][i] = nb_sys.pos[Z][i];
                recv_force[X][i] = 0.0;
                recv_force[Y][i] = 0.0;
                recv_force[Z][i] = 0.0;
                nb_sys.force[X][i] = 0.0;
                nb_sys.force[Y][i] = 0.0;
                nb_sys.force[Z][i] = 0.0;
            }
            double end = omp_get_wtime();
            int_time += end - start;
            start = end;
            if(blocked)compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            else compute_forces_avx2(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            end = omp_get_wtime();
            force_time += end - start;
            start = end;
#pragma omp parallel for simd
            for(size_t i = 0;i < nb_sys.N;i++)
            {
                nb_sys.vel[X][i] += (d[step] * (nb_sys.force[X][i]+recv_force[X][i]) * delta_t) / nb_sys.mass[i];
                nb_sys.vel[Y][i] += (d[step] * (nb_sys.force[Y][i]+recv_force[Y][i]) * delta_t) / nb_sys.mass[i];
                nb_sys.vel[Z][i] += (d[step] * (nb_sys.force[Z][i]+recv_force[Z][i]) * delta_t) / nb_sys.mass[i];
            }
            end = omp_get_wtime();
            int_time += end - start;
        }
        double start = omp_get_wtime();

        //Carry out the additional position update
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            nb_sys.pos[X][i] += c[lf_steps-1]*nb_sys.vel[X][i]*delta_t;
            nb_sys.pos[Y][i] += c[lf_steps-1]*nb_sys.vel[Y][i]*delta_t;
            nb_sys.pos[Z][i] += c[lf_steps-1]*nb_sys.vel[Z][i]*delta_t;
        }
        double end = omp_get_wtime();
        int_time += end - start;
    }
    printf("force calculation took: %fs\nintegration took : %fs\n",force_time, int_time);
    
    //Free all previously allocated arrays
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]); 
            free(local_recv_force[thread][d]); 
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        free(recv_force[d]);
        free(recv_pos[d]);
    }
    free(local_force);
    free(local_recv_force);
}

void reduced_solver_omp_rk(NBody_system& nb_sys, size_t time_steps, double delta_t, double* a, double* b, size_t rk_steps, bool blocked)
{
    omp_set_num_threads(1);
    size_t num_threads = omp_get_max_threads();
    printf("Threads available: %zu\n", num_threads);
    
    //preallocate all needed arrays:
    // - a seperate force array for each thread
    // - each vector coordinate has its seperate array (Struct of arrays) 
    // - recv_pos is only necessary for the hybrid solver
    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    double*** local_recv_force = (double***)malloc(num_threads*sizeof(double**));
    double* recv_pos[DIM];
    double* recv_force[DIM];
    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        recv_force[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        }
    }


    //Runge-Kutta integration:
    //Evaluate the velocity and force at intermediate steps k_1,...,k_s:

    double *k_v[rk_steps][DIM];
    double *k_a[rk_steps][DIM];

    for(size_t step = 0;step < rk_steps;step++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            k_v[step][d] = new double[nb_sys.N];
            k_a[step][d] = new double[nb_sys.N];
        }
    }
    double *tmp_pos[DIM];
    double *tmp_vel[DIM];


    for(size_t d = 0;d < DIM;d++)
    {    
        tmp_pos[d] = new double[nb_sys.N];
        tmp_vel[d] = new double[nb_sys.N];
    }
    const size_t a_dim = rk_steps - 1;

    for(size_t t = 0;t < time_steps;t++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            memcpy(tmp_pos[d], nb_sys.pos[d], nb_sys.N * sizeof(double));
            memcpy(tmp_vel[d], nb_sys.vel[d], nb_sys.N * sizeof(double));
        }
        for(size_t step = 0;step < rk_steps;step++)
        {
            for(size_t d = 0;d < DIM;d++)
            {
                memcpy(recv_pos[d], nb_sys.pos[d], nb_sys.N * sizeof(double));
                memset(recv_force[d],0, nb_sys.N * sizeof(double));
                memset(nb_sys.force[d],0, nb_sys.N * sizeof(double));
            }
            if(blocked)compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            else compute_forces_avx2(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            for(size_t d = 0;d < DIM;d++)
            {
                for(size_t k = 0;k < nb_sys.N;k++)
                {
                    nb_sys.force[d][k] += recv_force[d][k];
                }
                memcpy(k_v[step][d], nb_sys.vel[d], nb_sys.N * sizeof(double));
                memcpy(k_a[step][d], nb_sys.force[d], nb_sys.N * sizeof(double));
                memset(nb_sys.pos[d], 0, nb_sys.N * sizeof(double));
                memset(nb_sys.vel[d], 0, nb_sys.N * sizeof(double));
            }
            if(step == a_dim)break;
            for(size_t i = 0;i < nb_sys.N;i++)
            {
                for(size_t step2 = 0;step2 <= step;step2++)
                {
                    nb_sys.pos[X][i] += (a[step * a_dim + step2] * k_v[step2][X][i]);
                    nb_sys.pos[Y][i] += (a[step * a_dim + step2] * k_v[step2][Y][i]);
                    nb_sys.pos[Z][i] += (a[step * a_dim + step2] * k_v[step2][Z][i]);
                    nb_sys.vel[X][i] += (a[step * a_dim + step2] * k_a[step2][X][i]);
                    nb_sys.vel[Y][i] += (a[step * a_dim + step2] * k_a[step2][Y][i]); 
                    nb_sys.vel[Z][i] += (a[step * a_dim + step2] * k_a[step2][Z][i]); 
                }
                nb_sys.pos[X][i] *= delta_t;
                nb_sys.pos[Y][i] *= delta_t;
                nb_sys.pos[Z][i] *= delta_t;
                nb_sys.vel[X][i] *= delta_t;
                nb_sys.vel[Y][i] *= delta_t;
                nb_sys.vel[Z][i] *= delta_t;
                nb_sys.vel[X][i] /= nb_sys.mass[i];
                nb_sys.vel[Y][i] /= nb_sys.mass[i];
                nb_sys.vel[Z][i] /= nb_sys.mass[i];
                nb_sys.pos[X][i] += tmp_pos[X][i];
                nb_sys.pos[Y][i] += tmp_pos[Y][i];
                nb_sys.pos[Z][i] += tmp_pos[Z][i];
                nb_sys.vel[X][i] += tmp_vel[X][i];
                nb_sys.vel[Y][i] += tmp_vel[Y][i];
                nb_sys.vel[Z][i] += tmp_vel[Z][i];
            }
        }

        for(size_t i = 0;i < nb_sys.N;i++)
        {
            for(size_t step = 0;step < rk_steps;step++)
            {
                nb_sys.pos[X][i] += k_v[step][X][i] * b[step];
                nb_sys.pos[Y][i] += k_v[step][Y][i] * b[step];
                nb_sys.pos[Z][i] += k_v[step][Z][i] * b[step];
                nb_sys.vel[X][i] += k_a[step][X][i] * b[step];
                nb_sys.vel[Y][i] += k_a[step][Y][i] * b[step];
                nb_sys.vel[Z][i] += k_a[step][Z][i] * b[step];
            }
            nb_sys.pos[X][i] *= delta_t;
            nb_sys.pos[Y][i] *= delta_t;
            nb_sys.pos[Z][i] *= delta_t;
            nb_sys.vel[X][i] *= delta_t;
            nb_sys.vel[Y][i] *= delta_t;
            nb_sys.vel[Z][i] *= delta_t;
            nb_sys.vel[X][i] /= nb_sys.mass[i];
            nb_sys.vel[Y][i] /= nb_sys.mass[i];
            nb_sys.vel[Z][i] /= nb_sys.mass[i];
            nb_sys.pos[X][i] += tmp_pos[X][i];
            nb_sys.pos[Y][i] += tmp_pos[Y][i];
            nb_sys.pos[Z][i] += tmp_pos[Z][i];
            nb_sys.vel[X][i] += tmp_vel[X][i];
            nb_sys.vel[Y][i] += tmp_vel[Y][i]; 
            nb_sys.vel[Z][i] += tmp_vel[Z][i]; 
        }
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]); 
            free(local_recv_force[thread][d]); 
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        free(recv_force[d]);
        free(recv_pos[d]);
    }
    free(local_force);
    free(local_recv_force);

    for(size_t step = 0;step < rk_steps;step++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            delete[] k_v[step][d];
            delete[] k_a[step][d]; 
        }
    }
    for(size_t d = 0;d < DIM;d++)
    {   
        delete[] tmp_pos[d];
        delete[] tmp_vel[d];
    }
}

int omp_main(size_t N, size_t time_steps, double T, double ratio, Integration_kind int_kind, size_t int_order, Vectorization_type vect_type, Solver_type solver_type, bool verbose)
{

    double R = 1.0;
    double omega = (2.0 * M_PI);
    double delta_t = T/time_steps;

    NBody_system sys;
    NBody_system ref;

    sys.init_stable_orbiting_particles(N, R, omega, ratio);
    //sys.init_orbiting_particles(N, R, omega);
    ref = sys;

    printf("N = %zu, s = %zu\n", N, time_steps);

    if(int_kind == Integration_kind::EULER)
    {
        double start = 0.0;
        double end = 1.0;
        if(solver_type == Solver_type::REDUCED)
        {
            start = omp_get_wtime();
            reduced_solver_omp(sys, time_steps, delta_t, true, vect_type);
            end = omp_get_wtime();
        }
        else if(solver_type == Solver_type::FULL)
        {
            start = omp_get_wtime();
            full_solver_omp(sys, time_steps, delta_t, vect_type);
            end = omp_get_wtime();
        }

        size_t num_pairs = N*N - N;
        double mpairs = double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        printf("Reduced Euler blocked solver took %fs\n", end - start);
        printf("Performance: %fMPairs/s\n\n", mpairs);
        print_deviation(sys.pos, ref.pos, "position", N, verbose);
        print_deviation(sys.vel, ref.vel, "velocity", N, verbose);
    }
    else if(int_kind == Integration_kind::LEAP_FROG)
    {
        //Values for constructing 2nd, 4th, 6th and 8th order leap frog integrators
        //Values are taken from the Construction of higher order symplectic integrators publication by Yoshida
        double w2[] = {1.0};
        double w4[] = {-std::cbrt(2.0)/(2.0-std::cbrt(2.0)),1.0/(2.0-std::cbrt(2.0))};
        double w6[] = {1.0, -1.17767998417887, 0.235573213359357, 0.78451361047756};
        for(size_t i = 1;i < 4;i++)
            w6[0] -= 2.0*w6[i];
        double w8[] = {1.0, -0.161582374150097e1, -0.244699182370524e1, -0.716989419708120e-2, 0.244002732616735e1,
                             0.157739928123617, 0.182020630970714e1, 0.104242620869991e1};
        for(size_t i = 1;i < 8;i++)
            w8[0] -= 2.0*w8[i];

        double* curr_w;
        size_t w_size = 0;
        switch(int_order)
        {
            case 2:
                curr_w = w2;
                w_size = 1;
                break;
            case 4:
                curr_w = w4;
                w_size = 2;
                break;
            case 6:
                curr_w = w6;
                w_size = 4;
                break;
            case 8:
                curr_w = w8;
                w_size = 8;
                break;
            default:
                printf("Order %zu not supported! Defaulting to 2nd order\n", int_order);
                curr_w = w2;
                w_size = 1;
        }


        double c[2*w_size];
        double d[2*w_size-1];

        for(size_t i = 0;i < w_size;i++)
        {
            if(i == 0)
                c[i] = c[2*w_size-1-i] = curr_w[w_size - 1]/2.0;
            else
                c[i] = c[2*w_size-1-i] = (curr_w[w_size - i] + curr_w[w_size - 1 - i])/2.0;
            d[i] = d[2*w_size-2-i] = curr_w[w_size - 1 - i];
        }
        
        double sum = 0.0;
        for(size_t i = 0;i < 2*w_size;i++)
        {
            printf("c[%zu] = %f\n", i, c[i]);
            sum += c[i];
        } 
        printf("sum(c) = %f\n", sum);
        sum = 0.0;
        for(size_t i = 0;i < 2*w_size-1;i++)
        {
            printf("d[%zu] = %f\n", i, d[i]);
            sum += d[i];
        } 
        printf("sum(d) = %f\n", sum);
        
        size_t lf_steps = 2*w_size;

        double start = omp_get_wtime();
        reduced_solver_omp_lf(sys, time_steps, delta_t, c, d, lf_steps, true);
        double end = omp_get_wtime();

        size_t num_pairs = N*N - N;
        double mpairs = double(lf_steps-1) * double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        printf("Reduced Symplectic Solver took %fs\n", end - start);
        printf("Performance: %fMPairs/s\n", mpairs);
        print_deviation(sys.pos, ref.pos, "position", N, verbose);
        print_deviation(sys.vel, ref.vel, "velocity", N, verbose);
    }
    else if(int_kind == Integration_kind::RUNGE_KUTTA)
    {
        printf("Runge Kutta solver is not parallelized!\n");
        const size_t rk_order = 4;
        double a4[(rk_order-1)*(rk_order-1)] = {
                                                0.5, 0.0, 0.0,
                                                0.0, 0.5, 0.0,
                                                0.0, 0.0, 1.0
                                              };
        double b4[rk_order] = { 1.0/6.0, 1.0/3.0, 1.0/3.0, 1.0/6.0 }; 
        
        double* a;
        double* b;
        size_t rk_steps;

        switch(int_order)
        {
            case 4:
                a = a4;
                b = b4;
                rk_steps = 4;
                break;
            default:
                printf("Order %zu not supported! Defaulting to 4th order\n", int_order);
                a = a4;
                b = b4;
                rk_steps = 4;
        }
        double start = omp_get_wtime();
        reduced_solver_omp_rk(sys, time_steps, delta_t, a, b, rk_steps, true);
        double end = omp_get_wtime();

        size_t num_pairs = N*N - N;
        double mpairs = double(rk_steps)*double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        printf("Reduced Runge-Kutta Solver took %fs\n", end - start);
        printf("Performance: %fMPairs/s\n", mpairs);
        print_deviation(sys.pos, ref.pos, "position", N, verbose);
        print_deviation(sys.vel, ref.vel, "velocity", N, verbose);

    }
    return 0;
}

int omp_cache_benchmark(size_t start_N, size_t step_N, size_t num_steps, size_t time_steps, double T, double ratio, std::string output_path, bool verbose)
{

    double R = 1.0;
    double omega = (2.0 * M_PI);
    double delta_t = T/time_steps;
    FILE* output_file = fopen(output_path.c_str(), "w");

    
    fprintf(output_file, "N, t_blocked[s], p_blocked[Mpairs/s], t_default[s], p_default[Mpairs/s]\n");

    for(size_t n = 0;n < num_steps;n++)
    {
        size_t N = start_N + n * step_N;
    
        NBody_system sys1;
        NBody_system sys2;

        sys1.init_stable_orbiting_particles(N, R, omega, ratio);
        sys2 = sys1; 
        
        printf("\nStarting iteration; N: %zu\n", N);

        double start = omp_get_wtime();
        reduced_solver_omp(sys1, time_steps, delta_t, true, Vectorization_type::AVX2);
        double end = omp_get_wtime();
        
        size_t num_pairs = N*N - N;
        double t_blocked = end - start;
        double mpairs_blocked = double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        printf("Blocked Performance: %fMPairs/s\n\n", mpairs_blocked);
        
        start = omp_get_wtime();
        reduced_solver_omp(sys2, time_steps, delta_t, false, Vectorization_type::AVX2);
        end = omp_get_wtime();
        
        double t_default = end - start;
        double mpairs_default = double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        printf("Default Performance: %fMPairs/s\n\n", mpairs_default);
        
        fprintf(output_file,"%zu,%f,%f,%f,%f\n", N, t_blocked, mpairs_blocked, t_default, mpairs_default);
    }
    fclose(output_file);
    return 0;
}

int omp_scaling_benchmark(size_t N, size_t time_steps, double T, double ratio, bool weak, std::string output_path, Vectorization_type vect_type, Solver_type solver_type, bool verbose)
{
    double R = 1.0;
    double omega = (2.0 * M_PI);
    double delta_t = T/time_steps;
    
    FILE* output_file = fopen(output_path.c_str(), "w");

    fprintf(output_file, "#Cores, N, t_total[s], performance[Mpairs/s], speedup\n");
    size_t cores_avail = omp_get_max_threads();
    printf("Maximum number of Cores available: %zu\n", cores_avail);
    
    double baseline = 0.0;
    for(size_t cores = 1;cores <= cores_avail;cores++)
    {
        omp_set_num_threads(cores);

        NBody_system sys;
        size_t scaled_N = N;
        if(weak)
            scaled_N = cores * N;

        sys.init_stable_orbiting_particles(scaled_N, R, omega, ratio);

        double start = omp_get_wtime();
        reduced_solver_omp(sys, time_steps, delta_t, true, vect_type);
        double end = omp_get_wtime();

        size_t num_pairs = scaled_N*scaled_N - scaled_N;
        double t_total = end - start;
        double mpairs = double(time_steps)*double(num_pairs)/(1e6 * (end-start));
        if(cores == 1)
        {
            if(weak)
                baseline = mpairs;
            else 
                baseline = t_total;
        }
        double speedup = 1.0;

        if(weak)
            speedup = mpairs/baseline;
        else
            speedup = baseline/t_total;

        printf("%zu core performance for N = %zu: %fMPairs/s\n\n", cores, scaled_N, mpairs);
        
        fprintf(output_file,"%zu,%zu,%f,%f,%f\n", cores, scaled_N, t_total, mpairs, speedup);

    }
    fclose(output_file);
    return 0;
}

