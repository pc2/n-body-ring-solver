#include "force_calculation.h"
#include<stdio.h>
#include<stdint.h>

#include <omp.h>

#include <string.h>
#include <cmath>
#include <algorithm>

// Taken from https://stackoverflow.com/questions/13219146/how-to-sum-m256-horizontally
float hsum8(__m256 x) {
    // hiQuad = ( x7, x6, x5, x4 )
    const __m128 hiQuad = _mm256_extractf128_ps(x, 1);
    // loQuad = ( x3, x2, x1, x0 )
    const __m128 loQuad = _mm256_castps256_ps128(x);
    // sumQuad = ( x3 + x7, x2 + x6, x1 + x5, x0 + x4 )
    const __m128 sumQuad = _mm_add_ps(loQuad, hiQuad);
    // loDual = ( -, -, x1 + x5, x0 + x4 )
    const __m128 loDual = sumQuad;
    // hiDual = ( -, -, x3 + x7, x2 + x6 )
    const __m128 hiDual = _mm_movehl_ps(sumQuad, sumQuad);
    // sumDual = ( -, -, x1 + x3 + x5 + x7, x0 + x2 + x4 + x6 )
    const __m128 sumDual = _mm_add_ps(loDual, hiDual);
    // lo = ( -, -, -, x0 + x2 + x4 + x6 )
    const __m128 lo = sumDual;
    // hi = ( -, -, -, x1 + x3 + x5 + x7 )
    const __m128 hi = _mm_shuffle_ps(sumDual, sumDual, 0x1);
    // sum = ( -, -, -, x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 )
    const __m128 sum = _mm_add_ss(lo, hi);
    return _mm_cvtss_f32(sum);
}

void compute_forces_simple(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
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
            size_t mass_q_offset = ((rank + recv_round)%comm_sz)*local_N;
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

void compute_forces_avx2_sp(NBody_system& nb_sys, float* recv_pos[DIM], float* recv_force[DIM], float*** local_force, float*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        float** thread_local_force = local_force[thread_rank];
        float** thread_local_recv_force = local_recv_force[thread_rank];

        //Reset all forces before each timestep
#pragma omp for simd
        for(size_t i = 0;i < local_N;i++)
        {
            for(size_t thread = 0; thread < num_threads;thread++)
            {
                local_force[thread][X][i] = 0.0f;
                local_force[thread][Y][i] = 0.0f;
                local_force[thread][Z][i] = 0.0f;
                local_recv_force[thread][X][i] = 0.0f;
                local_recv_force[thread][Y][i] = 0.0f;
                local_recv_force[thread][Z][i] = 0.0f;
            }
        }
        
        //Main loop: vectorized calculation of all force pairs f_kq
#pragma omp for schedule(static, 1)
        for(size_t k = 0;k < local_N;k++)
        {
            // G-mass product can be precalculated as the mass does not change between timesteps
            float pre_calc = -G*nb_sys.mass_sp[rank*local_N + k];
            
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
                    float diff[DIM];
                    diff[X] = nb_sys.pos_sp[X][k] - recv_pos[X][q];
                    diff[Y] = nb_sys.pos_sp[Y][k] - recv_pos[Y][q];
                    diff[Z] = nb_sys.pos_sp[Z][k] - recv_pos[Z][q];
                    float dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    float force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
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
            //e.g. pos_sp[k].x -> AVX2_reg{pos_sp[k].x, pos_sp[k].x, pos_sp[k].x, pos_sp[k].x}
            __m256 force_k_x = _mm256_set1_ps(0.0);
            __m256 force_k_y = _mm256_set1_ps(0.0);
            __m256 force_k_z = _mm256_set1_ps(0.0);
            __m256 pos_k_x = _mm256_set1_ps(nb_sys.pos_sp[X][k]);
            __m256 pos_k_y = _mm256_set1_ps(nb_sys.pos_sp[Y][k]);
            __m256 pos_k_z = _mm256_set1_ps(nb_sys.pos_sp[Z][k]);
            __m256 pre_calc_avx = _mm256_set1_ps(pre_calc);

            //Vectorized loop body
            for(;q+3 < local_N;q+=4)
            {
                //diff = pos[k] - pos[q]
                __m256 diff_x = pos_k_x;
                __m256 diff_y = pos_k_y;
                __m256 diff_z = pos_k_z;
                __m256 pos_q_x = _mm256_load_ps(&(recv_pos[X][q]));
                __m256 pos_q_y = _mm256_load_ps(&(recv_pos[Y][q]));
                __m256 pos_q_z = _mm256_load_ps(&(recv_pos[Z][q]));
                diff_x = _mm256_sub_ps(diff_x, pos_q_x);
                diff_y = _mm256_sub_ps(diff_y, pos_q_y);
                diff_z = _mm256_sub_ps(diff_z, pos_q_z);

                //dist^2 = dot_prod(diff,diff);
                __m256 dist = _mm256_mul_ps(diff_x,diff_x);
                __m256 tmp = _mm256_mul_ps(diff_y,diff_y);
                dist = _mm256_add_ps(dist,tmp);
                tmp = _mm256_mul_ps(diff_z,diff_z);
                dist = _mm256_add_ps(dist,tmp);

                //dist = sqrt(dist^2)
                dist = _mm256_sqrt_ps(dist);

                //dist^3 = dist * dist * dist
                __m256 dist3  = _mm256_mul_ps(dist,dist);
                dist3 = _mm256_mul_ps(dist, dist3);

                
                __m256 force_q_x = _mm256_load_ps(&(thread_local_recv_force[X][q]));
                __m256 force_q_y = _mm256_load_ps(&(thread_local_recv_force[Y][q]));
                __m256 force_q_z = _mm256_load_ps(&(thread_local_recv_force[Z][q]));

                //force_kq = ((-G * mass[k] * mass[q])/dist^3)*diff 
                __m256 scalar_factor = _mm256_load_ps(&nb_sys.mass_sp[mass_q_offset + q]);
                scalar_factor = _mm256_mul_ps(pre_calc_avx, scalar_factor);
                scalar_factor = _mm256_div_ps(scalar_factor, dist3);
                __m256 force_x = _mm256_mul_ps(scalar_factor,diff_x);
                __m256 force_y = _mm256_mul_ps(scalar_factor,diff_y);
                __m256 force_z = _mm256_mul_ps(scalar_factor,diff_z);

                
                //force_q -= force_kq
                force_q_x = _mm256_sub_ps(force_q_x, force_x);
                force_q_y = _mm256_sub_ps(force_q_y, force_y);
                force_q_z = _mm256_sub_ps(force_q_z, force_z);
                
                
                _mm256_store_ps(&(thread_local_recv_force[X][q]), force_q_x);
                _mm256_store_ps(&(thread_local_recv_force[Y][q]), force_q_y);
                _mm256_store_ps(&(thread_local_recv_force[Z][q]), force_q_z);

                //force_k += force_kq
                force_k_x = _mm256_add_ps(force_k_x, force_x);
                force_k_y = _mm256_add_ps(force_k_y, force_y);
                force_k_z = _mm256_add_ps(force_k_z, force_z);
            }
            //force_k has been partially calculated over the 4 entries of the AVX2 register
            //perform horizontal add across AVX2 register to get the resulting force[k]
            //{force_k0, force_k1, force_k2, force_k3} -> {force_k0 + force_k2, force_k1 + force_k3}
            //-> force_k0 + force_k1 + force_k2 + force_k3
            thread_local_force[X][k] += hsum8(force_k_x);
            thread_local_force[Y][k] += hsum8(force_k_y);
            thread_local_force[Z][k] += hsum8(force_k_z);

            //Loop remainder
            for(;q < local_N;q++)
            {
                
                float diff[DIM];
                diff[X] = nb_sys.pos_sp[X][k] - recv_pos[X][q];
                diff[Y] = nb_sys.pos_sp[Y][k] - recv_pos[Y][q];
                diff[Z] = nb_sys.pos_sp[Z][k] - recv_pos[Z][q];
                float dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                float force_ij[DIM];
                force_ij[X] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
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
                nb_sys.force_sp[X][i] += local_force[thread][X][i];
                nb_sys.force_sp[Y][i] += local_force[thread][Y][i];
                nb_sys.force_sp[Z][i] += local_force[thread][Z][i];
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

void compute_forces_avx2_blocked_sp(NBody_system& nb_sys, float* recv_pos[DIM], float* recv_force[DIM], float*** local_force, float*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads)
{
#pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        
        //Each thread requires its own force array in order to prevent data races.
        float** thread_local_force = local_force[thread_rank];
        float** thread_local_recv_force = local_recv_force[thread_rank];

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
                float pre_calc = -G*nb_sys.mass[rank*local_N+k];

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
                        float diff[DIM];
                        diff[X] = nb_sys.pos_sp[X][k] - recv_pos[X][q];
                        diff[Y] = nb_sys.pos_sp[Y][k] - recv_pos[Y][q];
                        diff[Z] = nb_sys.pos_sp[Z][k] - recv_pos[Z][q];
                        float dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        float force_ij[DIM];
                        force_ij[X] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                        force_ij[Y] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                        force_ij[Z] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
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
                __m256 force_k_x = _mm256_set1_ps(0.0);
                __m256 force_k_y = _mm256_set1_ps(0.0);
                __m256 force_k_z = _mm256_set1_ps(0.0);
                __m256 pos_k_x = _mm256_set1_ps(nb_sys.pos_sp[X][k]);
                __m256 pos_k_y = _mm256_set1_ps(nb_sys.pos_sp[Y][k]);
                __m256 pos_k_z = _mm256_set1_ps(nb_sys.pos_sp[Z][k]);
                __m256 pre_calc_avx = _mm256_set1_ps(pre_calc);

                //Vectorized loop body
                for(;q+7 < k_bound;q+=8)
                {
                    //diff = pos[k] - pos[q]
                    __m256 diff_x = pos_k_x;
                    __m256 diff_y = pos_k_y;
                    __m256 diff_z = pos_k_z;
                    __m256 pos_q_x = _mm256_load_ps(&(recv_pos[X][q]));
                    __m256 pos_q_y = _mm256_load_ps(&(recv_pos[Y][q]));
                    __m256 pos_q_z = _mm256_load_ps(&(recv_pos[Z][q]));
                    diff_x = _mm256_sub_ps(diff_x, pos_q_x);
                    diff_y = _mm256_sub_ps(diff_y, pos_q_y);
                    diff_z = _mm256_sub_ps(diff_z, pos_q_z);

                    //dist^2 = dot_prod(diff,diff);
                    __m256 dist = _mm256_mul_ps(diff_x,diff_x);
                    __m256 tmp = _mm256_mul_ps(diff_y,diff_y);
                    dist = _mm256_add_ps(dist,tmp);
                    tmp = _mm256_mul_ps(diff_z,diff_z);
                    dist = _mm256_add_ps(dist,tmp);
                   
                    //dist = sqrt(dist^2)
                    dist = _mm256_sqrt_ps(dist);

                    //dist^3 = dist * dist * dist
                    __m256 dist3  = _mm256_mul_ps(dist,dist);
                    dist3 = _mm256_mul_ps(dist, dist3);

                    
                    __m256 force_q_x = _mm256_load_ps(&(thread_local_recv_force[X][q]));
                    __m256 force_q_y = _mm256_load_ps(&(thread_local_recv_force[Y][q]));
                    __m256 force_q_z = _mm256_load_ps(&(thread_local_recv_force[Z][q]));

                    //force_kq = ((-G * mass[k] * mass[q])/dist^3)*diff 
                    __m256 scalar_factor = _mm256_load_ps(&nb_sys.mass_sp[mass_q_offset+q]);
                    scalar_factor = _mm256_mul_ps(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm256_div_ps(scalar_factor, dist3);
                    __m256 force_x = _mm256_mul_ps(scalar_factor,diff_x);
                    __m256 force_y = _mm256_mul_ps(scalar_factor,diff_y);
                    __m256 force_z = _mm256_mul_ps(scalar_factor,diff_z);

                    
                    //force_q -= force_kq
                    force_q_x = _mm256_sub_ps(force_q_x, force_x);
                    force_q_y = _mm256_sub_ps(force_q_y, force_y);
                    force_q_z = _mm256_sub_ps(force_q_z, force_z);
                    
                    
                    _mm256_store_ps(&(thread_local_recv_force[X][q]), force_q_x);
                    _mm256_store_ps(&(thread_local_recv_force[Y][q]), force_q_y);
                    _mm256_store_ps(&(thread_local_recv_force[Z][q]), force_q_z);

                    //force_k += force_kq
                    force_k_x = _mm256_add_ps(force_k_x, force_x);
                    force_k_y = _mm256_add_ps(force_k_y, force_y);
                    force_k_z = _mm256_add_ps(force_k_z, force_z);
                }
                //force_k has been partially calculated over the 4 entries of the AVX2 register
                //perform horizontal add across AVX2 register to get the resulting force[k]
                thread_local_force[X][k] += hsum8(force_k_x);
                thread_local_force[Y][k] += hsum8(force_k_y);
                thread_local_force[Z][k] += hsum8(force_k_z);

                //Loop remainder
                for(;q < k_bound;q++)
                {
                    
                    float diff[DIM];
                    diff[X] = nb_sys.pos_sp[X][k] - recv_pos[X][q];
                    diff[Y] = nb_sys.pos_sp[Y][k] - recv_pos[Y][q];
                    diff[Z] = nb_sys.pos_sp[Z][k] - recv_pos[Z][q];
                    float dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    float force_ij[DIM];
                    force_ij[X] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*nb_sys.mass_sp[mass_q_offset+q]*diff[Z]/(dist*dist*dist);
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
                nb_sys.force_sp[X][i] += local_force[thread][X][i];
                nb_sys.force_sp[Y][i] += local_force[thread][Y][i];
                nb_sys.force_sp[Z][i] += local_force[thread][Z][i];
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

double compute_kinetic_energy(NBody_system& nb_sys)
{
    double T = 0.0;
    for(size_t i = 0;i < nb_sys.N;i++)
    {
        T += nb_sys.mass[i] * (nb_sys.vel[X][i]*nb_sys.vel[X][i]+nb_sys.vel[Y][i]*nb_sys.vel[Y][i]+nb_sys.vel[Z][i]*nb_sys.vel[Z][i]);
    }
    return T/2.0;
}
double compute_potential_energy_avx2(NBody_system& nb_sys)
{
    double total_U = 0.0;
    #pragma omp parallel
    {
        size_t thread_rank = omp_get_thread_num();
        size_t num_threads = omp_get_num_threads();
        double U[num_threads];
        //The inner loop iteration is chunked into blocks to improve cache usage
        //If each inner loop only iterates over a maximum of 2048 elements, then these elements remain in cache for all outer loop iterations
        //2048 elements/particles use 112KiB of data
        //The Xeon Gold 6148F has a L1 Cache size of 640 KiB
        //This blocksize leaves enough space for stack variables and for preloading outer loop particles
        //For a CPU with a smaller L1 Cache this value has to be adjusted
        const size_t block_size = 256;
        size_t num_blocks = nb_sys.N / block_size;
        if(num_blocks * block_size != nb_sys.N)num_blocks++;
        
        for(size_t b = 0;b < num_blocks;b++)
        {
            //Choose the index interval of the current block
            size_t curr_block = b * block_size;
            size_t next_block = (b+1) * block_size;

            //Limit the intervall by local_N
            size_t k_bound = std::min(next_block, nb_sys.N);

            //Only iterate over all indices smaller than the largest index in the current block interval
            #pragma omp for schedule(static, 1)
            for(size_t k = 0;k < k_bound;k++)
            {
                
                // G-mass product can be precalculated as the mass does not change between timesteps
                double pre_calc = nb_sys.mass[k];

                //If k is in the interval of all previous block indices, then calculate all forcepairs
                //Otherwise only calculate if k < q
                size_t q = k + 1;
                q = std::max(q, curr_block);

                //Fix alignment to the next 32-bit aligned address
                //All arrays are allocated as 64-bit aligned
                size_t align_offset = (q & 0b11);
    

                switch(align_offset)
                {
                    case 0:
                        break;
                    default:
                    for(size_t peel = 0; peel < 4 - align_offset && q < k_bound ;peel++,q++)
                    {
                        double diff[DIM];
                        diff[X] = nb_sys.pos[X][k] - nb_sys.pos[X][q];
                        diff[Y] = nb_sys.pos[Y][k] - nb_sys.pos[Y][q];
                        diff[Z] = nb_sys.pos[Z][k] - nb_sys.pos[Z][q];
                        double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                        U[thread_rank] += pre_calc*nb_sys.mass[q]/(dist);
                    }
                    break;
                }
                
                //preload values of the kth particle to registers
                //The values are spread among an entire AVX2 register
                //e.g. pos[k].x -> AVX2_reg{pos[k].x, pos[k].x, pos[k].x, pos[k].x}
                __m256d pos_k_x = _mm256_set1_pd(nb_sys.pos[X][k]);
                __m256d pos_k_y = _mm256_set1_pd(nb_sys.pos[Y][k]);
                __m256d pos_k_z = _mm256_set1_pd(nb_sys.pos[Z][k]);
                __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);
                __m256d vec_U = _mm256_set1_pd(0.0);

                //Vectorized loop body
                for(;q+3 < k_bound;q+=4)
                {
                    //diff = pos[k] - pos[q]
                    __m256d diff_x = pos_k_x;
                    __m256d diff_y = pos_k_y;
                    __m256d diff_z = pos_k_z;
                    __m256d pos_q_x = _mm256_load_pd(&(nb_sys.pos[X][q]));
                    __m256d pos_q_y = _mm256_load_pd(&(nb_sys.pos[Y][q]));
                    __m256d pos_q_z = _mm256_load_pd(&(nb_sys.pos[Z][q]));
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

                    //force_kq = ((-G * mass[k] * mass[q])/dist^3)*diff 
                    __m256d scalar_factor = _mm256_load_pd(&nb_sys.mass[q]);
                    scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                    scalar_factor = _mm256_div_pd(scalar_factor, dist);

                    //force_k += force_kq
                    vec_U = _mm256_add_pd(vec_U, scalar_factor);
                }
                //force_k has been partially calculated over the 4 entries of the AVX2 register
                //perform horizontal add across AVX2 register to get the resulting force[k]
                //{force_k0, force_k1, force_k2, force_k3} -> {force_k0 + force_k2, force_k1 + force_k3}
                //-> force_k0 + force_k1 + force_k2 + force_k3
                __m128d vec_U_low = _mm256_castpd256_pd128(vec_U);
                __m128d vec_U_high = _mm256_extractf128_pd(vec_U,1);
                vec_U_low = _mm_add_pd(vec_U_low, vec_U_high);
                __m128d vec_U_high64 = _mm_unpackhi_pd(vec_U_low, vec_U_low);
                U[thread_rank] += _mm_cvtsd_f64(_mm_add_sd(vec_U_low, vec_U_high64));

                //Loop remainder
                for(;q < k_bound;q++)
                {
                    
                    double diff[DIM];
                    diff[X] = nb_sys.pos[X][k] - nb_sys.pos[X][q];
                    diff[Y] = nb_sys.pos[Y][k] - nb_sys.pos[Y][q];
                    diff[Z] = nb_sys.pos[Z][k] - nb_sys.pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    U[thread_rank] += pre_calc*nb_sys.mass[q]/(dist);
                }
            }
        }
        #pragma omp barrier
        if(thread_rank == 0)
        {
            for(size_t i = 0;i < num_threads;i++)
                total_U += U[i];
        }
    }
    return -total_U;
}
double compute_potential_energy_avx2_sp(NBody_system& nb_sys)
{
    return 0.0;
}
double compute_inertia(NBody_system& nb_sys)
{
    double I = 0.0;
    for(size_t i = 0;i < nb_sys.N;i++)
    {
        I += nb_sys.mass[i] * (nb_sys.pos[X][i]*nb_sys.pos[X][i]+nb_sys.pos[Y][i]*nb_sys.pos[Y][i]+nb_sys.pos[Z][i]*nb_sys.pos[Z][i]);;
    }
    return I;
}