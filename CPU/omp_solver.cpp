#include "omp_solver.h"
#include "force_calculation.h"
#include<stdio.h>
#include<stdint.h>

#include <omp.h>
#include <immintrin.h>

#include <string.h>
#include <cmath>
#include <algorithm>
#include <random>
#include <unistd.h>


void reduced_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, bool blocked, Vectorization_type vect_type, Data_type data_type)
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

    float*** local_force_sp = (float***)malloc(num_threads*sizeof(float**));
    float*** local_recv_force_sp = (float***)malloc(num_threads*sizeof(float**));
    float* recv_pos_sp[DIM];
    float* recv_force_sp[DIM];

    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        recv_force[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);

        recv_pos_sp[d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
        recv_force_sp[d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));

        local_force_sp[thread] = (float**)malloc(DIM*sizeof(float*));
        local_recv_force_sp[thread] = (float**)malloc(DIM*sizeof(float*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);

            local_force_sp[thread][d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
            local_recv_force_sp[thread][d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
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
            recv_pos_sp[X][i] = nb_sys.pos_sp[X][i];
            recv_pos_sp[Y][i] = nb_sys.pos_sp[Y][i];
            recv_pos_sp[Z][i] = nb_sys.pos_sp[Z][i];

            recv_force[X][i] = 0.0;
            recv_force[Y][i] = 0.0;
            recv_force[Z][i] = 0.0;
            recv_force_sp[X][i] = 0.0f;
            recv_force_sp[Y][i] = 0.0f;
            recv_force_sp[Z][i] = 0.0f;

            nb_sys.force[X][i] = 0.0;
            nb_sys.force[Y][i] = 0.0;
            nb_sys.force[Z][i] = 0.0;
            nb_sys.force_sp[X][i] = 0.0f;
            nb_sys.force_sp[Y][i] = 0.0f;
            nb_sys.force_sp[Z][i] = 0.0f;
        }

        //Decision between cache aware implementation and "default" implementation
        if(data_type == Data_type::DOUBLE_PRECISION)
        {
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
        }
        else
        {
            printf("Before force calculation\n");
            fflush(stdout);
            if(vect_type == Vectorization_type::AVX2)
            {
                if(blocked)compute_forces_avx2_blocked_sp(nb_sys, recv_pos_sp, recv_force_sp, local_force_sp, local_recv_force_sp, nb_sys.N,0,1,0,num_threads);
                else compute_forces_avx2_sp(nb_sys, recv_pos_sp, recv_force_sp, local_force_sp, local_recv_force_sp, nb_sys.N,0,1,0,num_threads);
            }
            else 
            {
                printf("Only AVX2 supported for single precision!\n");
            }
            printf("After force calculation\n");
            fflush(stdout);
        }
        //Integration step: Euler integration
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            if(data_type == Data_type::DOUBLE_PRECISION)
            {
                nb_sys.force[X][i] += recv_force[X][i]; 
                nb_sys.force[Y][i] += recv_force[Y][i];
                nb_sys.force[Z][i] += recv_force[Z][i];

                nb_sys.pos[X][i] += nb_sys.vel[X][i]*delta_t;
                nb_sys.pos[Y][i] += nb_sys.vel[Y][i]*delta_t;
                nb_sys.pos[Z][i] += nb_sys.vel[Z][i]*delta_t;
                nb_sys.vel[X][i] += (nb_sys.force[X][i]*delta_t)/nb_sys.mass[i];
                nb_sys.vel[Y][i] += (nb_sys.force[Y][i]*delta_t)/nb_sys.mass[i];
                nb_sys.vel[Z][i] += (nb_sys.force[Z][i]*delta_t)/nb_sys.mass[i];
            }
            else
            {
                nb_sys.force_sp[X][i] += recv_force_sp[X][i]; 
                nb_sys.force_sp[Y][i] += recv_force_sp[Y][i];
                nb_sys.force_sp[Z][i] += recv_force_sp[Z][i];

                nb_sys.pos_sp[X][i] += nb_sys.vel_sp[X][i]*float(delta_t);
                nb_sys.pos_sp[Y][i] += nb_sys.vel_sp[Y][i]*float(delta_t);
                nb_sys.pos_sp[Z][i] += nb_sys.vel_sp[Z][i]*float(delta_t);
                nb_sys.vel_sp[X][i] += (nb_sys.force_sp[X][i]*float(delta_t))/nb_sys.mass_sp[i];
                nb_sys.vel_sp[Y][i] += (nb_sys.force_sp[Y][i]*float(delta_t))/nb_sys.mass_sp[i];
                nb_sys.vel_sp[Z][i] += (nb_sys.force_sp[Z][i]*float(delta_t))/nb_sys.mass_sp[i];
            }
        }
    }
    //Free all previously allocated arrays
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]); 
            free(local_recv_force[thread][d]); 
            free(local_force_sp[thread][d]); 
            free(local_recv_force_sp[thread][d]); 
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);
        free(local_force_sp[thread]);
        free(local_recv_force_sp[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        free(recv_force[d]);
        free(recv_pos[d]);
        free(recv_force_sp[d]);
        free(recv_pos_sp[d]);
    }
    free(local_force_sp);
    free(local_recv_force_sp);
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

void reduced_solver_omp_lf(NBody_system& nb_sys, size_t time_steps, double delta_t, double* c, double* d, size_t lf_steps, bool blocked, Data_type data_type)
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

    float*** local_force_sp = (float***)malloc(num_threads*sizeof(float**));
    float*** local_recv_force_sp = (float***)malloc(num_threads*sizeof(float**));
    float* recv_pos_sp[DIM];
    float* recv_force_sp[DIM];

    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
        recv_force[d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);

        recv_pos_sp[d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
        recv_force_sp[d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
    }

    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));

        local_force_sp[thread] = (float**)malloc(DIM*sizeof(float*));
        local_recv_force_sp[thread] = (float**)malloc(DIM*sizeof(float*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64, sizeof(double) * nb_sys.N);

            local_force_sp[thread][d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
            local_recv_force_sp[thread][d] = (float*)aligned_alloc(64, sizeof(float) * nb_sys.N);
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
                if(data_type == Data_type::DOUBLE_PRECISION)
                {
                    nb_sys.pos[X][i] += c[step]*nb_sys.vel[X][i]*delta_t;
                    nb_sys.pos[Y][i] += c[step]*nb_sys.vel[Y][i]*delta_t;
                    nb_sys.pos[Z][i] += c[step]*nb_sys.vel[Z][i]*delta_t;
                }
                else
                {
                    nb_sys.pos_sp[X][i] += float(c[step])*nb_sys.vel_sp[X][i]*float(delta_t);
                    nb_sys.pos_sp[Y][i] += float(c[step])*nb_sys.vel_sp[Y][i]*float(delta_t);
                    nb_sys.pos_sp[Z][i] += float(c[step])*nb_sys.vel_sp[Z][i]*float(delta_t);
                }

                recv_pos[X][i] = nb_sys.pos[X][i];
                recv_pos[Y][i] = nb_sys.pos[Y][i];
                recv_pos[Z][i] = nb_sys.pos[Z][i];
                recv_pos_sp[X][i] = nb_sys.pos_sp[X][i];
                recv_pos_sp[Y][i] = nb_sys.pos_sp[Y][i];
                recv_pos_sp[Z][i] = nb_sys.pos_sp[Z][i];

                recv_force[X][i] = 0.0;
                recv_force[Y][i] = 0.0;
                recv_force[Z][i] = 0.0;
                recv_force_sp[X][i] = 0.0f;
                recv_force_sp[Y][i] = 0.0f;
                recv_force_sp[Z][i] = 0.0f;

                nb_sys.force[X][i] = 0.0;
                nb_sys.force[Y][i] = 0.0;
                nb_sys.force[Z][i] = 0.0;
                nb_sys.force_sp[X][i] = 0.0f;
                nb_sys.force_sp[Y][i] = 0.0f;
                nb_sys.force_sp[Z][i] = 0.0f;
            }
            double end = omp_get_wtime();
            int_time += end - start;
            start = end;
            //if(blocked)compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            //else compute_forces_avx2(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            if(data_type == Data_type::DOUBLE_PRECISION)
            {
                if(blocked)compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
                else compute_forces_avx2(nb_sys, recv_pos, recv_force, local_force, local_recv_force, nb_sys.N,0,1,0,num_threads);
            }
            else
            {
                if(blocked)compute_forces_avx2_blocked_sp(nb_sys, recv_pos_sp, recv_force_sp, local_force_sp, local_recv_force_sp, nb_sys.N,0,1,0,num_threads);
                else compute_forces_avx2_sp(nb_sys, recv_pos_sp, recv_force_sp, local_force_sp, local_recv_force_sp, nb_sys.N,0,1,0,num_threads);
            }
            end = omp_get_wtime();
            force_time += end - start;
            start = end;
#pragma omp parallel for simd
            for(size_t i = 0;i < nb_sys.N;i++)
            {
                
                if(data_type == Data_type::DOUBLE_PRECISION)
                {
                    nb_sys.force[X][i] += recv_force[X][i]; 
                    nb_sys.force[Y][i] += recv_force[Y][i];
                    nb_sys.force[Z][i] += recv_force[Z][i];

                    nb_sys.vel[X][i] += (d[step] * nb_sys.force[X][i] * delta_t) / nb_sys.mass[i];
                    nb_sys.vel[Y][i] += (d[step] * nb_sys.force[Y][i] * delta_t) / nb_sys.mass[i];
                    nb_sys.vel[Z][i] += (d[step] * nb_sys.force[Z][i] * delta_t) / nb_sys.mass[i];
                }
                else
                {
                    nb_sys.force_sp[X][i] += recv_force_sp[X][i]; 
                    nb_sys.force_sp[Y][i] += recv_force_sp[Y][i];
                    nb_sys.force_sp[Z][i] += recv_force_sp[Z][i];
                    nb_sys.vel_sp[X][i] += (float(d[step]) * (nb_sys.force_sp[X][i]) * float(delta_t)) / nb_sys.mass_sp[i];
                    nb_sys.vel_sp[Y][i] += (float(d[step]) * (nb_sys.force_sp[Y][i]) * float(delta_t)) / nb_sys.mass_sp[i];
                    nb_sys.vel_sp[Z][i] += (float(d[step]) * (nb_sys.force_sp[Z][i]) * float(delta_t)) / nb_sys.mass_sp[i];
                }
            }
            end = omp_get_wtime();
            int_time += end - start;
        }
        double start = omp_get_wtime();

        //Carry out the additional position update
#pragma omp parallel for simd
        for(size_t i = 0;i < nb_sys.N;i++)
        {
            if(data_type == Data_type::DOUBLE_PRECISION)
            {
                nb_sys.pos[X][i] += c[lf_steps-1]*nb_sys.vel[X][i]*delta_t;
                nb_sys.pos[Y][i] += c[lf_steps-1]*nb_sys.vel[Y][i]*delta_t;
                nb_sys.pos[Z][i] += c[lf_steps-1]*nb_sys.vel[Z][i]*delta_t;
            }
            else
            {
                nb_sys.pos_sp[X][i] += float(c[lf_steps-1])*nb_sys.vel_sp[X][i]*float(delta_t);
                nb_sys.pos_sp[Y][i] += float(c[lf_steps-1])*nb_sys.vel_sp[Y][i]*float(delta_t);
                nb_sys.pos_sp[Z][i] += float(c[lf_steps-1])*nb_sys.vel_sp[Z][i]*float(delta_t);
            }
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

            free(local_force_sp[thread][d]); 
            free(local_recv_force_sp[thread][d]); 
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);

        free(local_force_sp[thread]);
        free(local_recv_force_sp[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        free(recv_force[d]);
        free(recv_pos[d]);

        free(recv_force_sp[d]);
        free(recv_pos_sp[d]);
    }
    free(local_force);
    free(local_recv_force);

    free(local_force_sp);
    free(local_recv_force_sp);
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
        reduced_solver_omp_lf(sys, time_steps, delta_t, c, d, lf_steps, true, Data_type::DOUBLE_PRECISION);
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

int omp_accuracy(size_t start_N, size_t step_N, size_t num_steps, double T, double ratio_start, double ratio_stop, size_t ratio_steps, std::string output_path, Vectorization_type vect_type, Data_type data_type, bool verbose)
{
    double R = 1.0;
    double omega = (2.0 * M_PI);

    FILE* output_file;
    bool file_exists = (access(output_path.c_str(), F_OK) != -1);
    if(file_exists)
    {
        output_file = fopen(output_path.c_str(), "a");
    }
    else
    {
        output_file = fopen(output_path.c_str(), "w");
        fprintf(output_file, "N, precision, ratio, average_force_length_error[%%], average_force_angle_error[%%]\n");
    }
    

    double ratio_root = std::pow(ratio_stop/ratio_start, 1.0/double(ratio_steps));
    printf("ratio_root: %f, ratio_start: %f\n", ratio_root, ratio_start);
    for(size_t ratio_step = 0;ratio_step <= ratio_steps;ratio_step++)
    {
        double curr_ratio = ratio_start * std::pow(ratio_root, ratio_step);
        for(size_t i = 0;i < num_steps;i++)
        {
            size_t curr_N = start_N * size_t(std::round(std::pow(double(step_N), i)));
            NBody_system sys;
            NBody_system ref;

            sys.init_stable_orbiting_particles(curr_N, R, omega, curr_ratio);
            //sys.init_orbiting_particles(N, R, omega);
            ref = sys;

            size_t* perm = new size_t[curr_N];
            for(size_t i = 0;i < curr_N;i++)
                perm[i] = i;

            std::random_device rd;
            std::mt19937 g(rd());

            std::shuffle(&perm[0], &perm[curr_N], g);

            sys.apply_permutation(perm);
            ref.apply_permutation(perm);

            printf("################### N = %zu, s = %zu ###################\n", curr_N, size_t(1));
            printf("curr_ratio = %.3e\n", curr_ratio);
            /*printf("m = %.10e\n", sys.mass[perm[0]]);
            printf("M = %.10e\n", sys.mass[perm[curr_N-1]]);
            double min_m = 0.0;
            double max_m = 0.0;
            size_t min_idx = 0;
            size_t max_idx = 0;
            for(size_t i = 0;i < curr_N;i++)
            {
                if(max_m < sys.mass[i])
                {
                    max_idx = i;
                    max_m = sys.mass[i];
                }
                else
                {
                    min_idx = i;
                    min_m = sys.mass[i];
                }
            }

            printf("min_m = %.10e at index %zu\n", min_m, min_idx);
            printf("max_m = %.10e at index %zu\n", max_m, max_idx);
            printf("perm[curr_N-1] = %zu\n", perm[curr_N-1]);
            */
            


            double start = omp_get_wtime();
            reduced_solver_omp(sys, 1, 1.0, true, vect_type, data_type);
            double end = omp_get_wtime();
            printf("Solver took: %fs\n",end-start);

            std::array<double, 6> errors = calculate_force_error(sys, ref, data_type, verbose);
            printf("Average force error: %.10e\n", errors[0]);
            printf("Largest force error: %.10e\n", errors[1]);
            printf("Largest to Average ratio: %.10e\n", errors[1]/errors[0]);
            printf("Average normalized angle error: %.10e\n", errors[2]);
            printf("Average normalized length error: %.10e\n", errors[3]);
            printf("Largest normalized angle error: %.10e\n", errors[4]);
            printf("Largest normalized length error: %.10e\n\n", errors[5]);

            fprintf(output_file, "%zu, %s, %.5e, %.5e, %.6e\n", curr_N, data_type == Data_type::DOUBLE_PRECISION ? "dp" : "sp", curr_ratio, errors[3]*100.0, errors[2]*100.0);
        }
    }
    fclose(output_file);

    return 0;
}

int omp_ratio_accuracy(size_t start_N, size_t step_N, size_t num_steps, size_t time_steps, double T, double ratio_start, double ratio_stop, size_t ratio_steps, size_t rev_steps, double max_error, std::string output_path, Vectorization_type vect_type, Data_type data_type, bool verbose)
{
    FILE* output_file = NULL;
    bool file_exists = (access(output_path.c_str(), F_OK) != -1);
    if(file_exists)
    {
        output_file = fopen(output_path.c_str(), "a");
    }
    else
    {
        output_file = fopen(output_path.c_str(),"w");
        fprintf(output_file, "N, precision, s, s_collapse, ratio, max_error, last_E_dev, last_avg_pos_dev, last_avg_vel_dev, max_pos_dev, max_vel_dev\n");
    }

    //Values for constructing 2nd, 4th, 6th and 8th order leap frog integrators
    //Values are taken from the Construction of higher order symplectic integrators publication by Yoshida
    double w2[] = {1.0};
    const size_t w_size = 1;

    double c[2*w_size];
    double d[2*w_size-1];

    for(size_t i = 0;i < w_size;i++)
    {
        if(i == 0)
            c[i] = c[2*w_size-1-i] = w2[w_size - 1]/2.0;
        else
            c[i] = c[2*w_size-1-i] = (w2[w_size - i] + w2[w_size - 1 - i])/2.0;
        d[i] = d[2*w_size-2-i] = w2[w_size - 1 - i];
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


    for(size_t n = 0;n < num_steps;n++)
    {
        size_t curr_N = start_N + n * step_N;

        

        
        //sys.init_orbiting_particles(N, R, omega);
        //omega: Used for initializing orbiting particles
        //delta_t: time_step
        double R = 1.0;
        double omega = (2.0 * M_PI);
        double delta_t = 1.0/rev_steps;

        double ratio_root = std::pow(ratio_stop/ratio_start, 1.0/double(ratio_steps));
        printf("ratio_root: %f, ratio_start: %f\n", ratio_root, ratio_start);
        for(size_t ratio_step = 0;ratio_step <= ratio_steps;ratio_step++)
        {
            double curr_ratio = ratio_start * std::pow(ratio_root, ratio_step);
            
            NBody_system init_sys;
            init_sys.init_stable_orbiting_particles(curr_N, R, omega, curr_ratio);
            double T0 = compute_kinetic_energy(init_sys);
            //double U0 = calculate_potential_energy(init_sys);
            double U0 = compute_potential_energy_avx2(init_sys);
            double I0 = compute_inertia(init_sys);
            double E0 = T0 + U0;
            printf("########Initial system condition########\n");
            printf("System size N = %zu\n",curr_N);
            printf("Mass ratio: %f\n", curr_ratio);
            printf("T0 = %f\n", T0);
            printf("U0 = %f\n", U0);
            printf("E0 = %f\n", E0);
            printf("I0 = %f\n", I0);
            printf("I0'' = %f\n", 4*T0 + 2*U0);
            printf("Number of system revolutions to simulate: %f\n", 1.0);

            double E_dev_sol = 0.0;
            double avg_pos_dev_sol = 0.0;
            double avg_vel_dev_sol = 0.0;
            double max_pos_dev_sol = 0.0;
            double max_vel_dev_sol = 0.0;
            /*size_t lower_time_steps = 0;
            size_t upper_time_steps = time_steps;
            size_t curr_time_steps = upper_time_steps/2;
            while(upper_time_steps - lower_time_steps > 1)
            {
                printf("curr: %zu\n", curr_time_steps);
                

                double avg_pos_dev = 0.0;
                double avg_vel_dev = 0.0;
                double T = 0.0;
                double U = 0.0;
                double I = 0.0;
                double E = 0.0;    
                NBody_system sys;
                NBody_system ref;
                sys.init_stable_orbiting_particles(curr_N, R, omega, curr_ratio);
                ref = sys;

                reduced_solver_omp_lf(sys, curr_time_steps, delta_t, c, d, lf_steps, true, data_type);
                if(data_type == Data_type::SINGLE_PRECISION)
                    sys.copy_to_double_precision();
                ref.predict_stable_orbiting_particles(R, omega, curr_time_steps, time_steps);
                //print_particles_contiguous(mass, pos_ref, vel_ref, force, curr_N);



                T = compute_kinetic_energy(sys);
                //U = calculate_potential_energy(sys);
                U = compute_potential_energy_avx2(sys);
                I = compute_inertia(sys);
                E = T + U;

                printf("\n########System condition after %zu timesteps########\n", curr_time_steps);


                avg_pos_dev = calculate_deviation(sys.pos, ref.pos, curr_N);
                avg_vel_dev = calculate_deviation(sys.vel, ref.vel, curr_N);

                printf("T = %f\n", T);
                printf("U = %f\n", U);
                printf("I = %f\n", I);
                printf("I'' = %f\n", 4*T + 2*U);
                printf("E = %f\n", E);
                
                double E_dev = abs((E0 - E)/E0);
                printf("E_dev = %f\n", E_dev);
                
                if(E_dev < 1.0)
                {
                    lower_time_steps = curr_time_steps;
                    curr_time_steps = (upper_time_steps + lower_time_steps)/2 + 1;
                    avg_pos_dev_sol = avg_pos_dev;
                    avg_vel_dev_sol = avg_vel_dev;
                    E_dev_sol = E_dev;
                }
                else
                {
                    upper_time_steps = curr_time_steps;
                    curr_time_steps = (upper_time_steps + lower_time_steps)/2;
                }
            }*/
            NBody_system sys;
            NBody_system ref;
            sys.init_stable_orbiting_particles(curr_N, R, omega, curr_ratio);
            ref = sys;
            size_t* perm = new size_t[curr_N];
            for(size_t i = 0;i < curr_N;i++)
                perm[i] = i;

            std::random_device rd;
            std::mt19937 g(rd());

            std::shuffle(&perm[0], &perm[curr_N], g);

            sys.apply_permutation(perm);
            ref.apply_permutation(perm);
            size_t s_collapse = time_steps;
            for(size_t t = 1;t <= time_steps;t++)
            {
                printf("curr: %zu\n", t);
                    

                double T = 0.0;
                double U = 0.0;
                double I = 0.0;
                double E = 0.0;    
                
                
                reduced_solver_omp_lf(sys, 1, delta_t, c, d, lf_steps, true, data_type);
                if(data_type == Data_type::SINGLE_PRECISION)
                    sys.copy_to_double_precision();
                ref.predict_stable_orbiting_particles(R, omega, t, rev_steps);
                ref.apply_permutation(perm);
                //print_particles_contiguous(mass, pos_ref, vel_ref, force, curr_N);



                T = compute_kinetic_energy(sys);
                //U = calculate_potential_energy(sys);
                U = compute_potential_energy_avx2(sys);
                I = compute_inertia(sys);
                E = T + U;
                if(verbose)
                    printf("\n########System condition after %zu timesteps########\n", t);


                std::array<double,2> pos_devs = calculate_deviation(sys.pos, ref.pos, curr_N);
                std::array<double,2> vel_devs = calculate_deviation(sys.vel, ref.vel, curr_N);

                if(verbose)
                {
                    printf("T = %f\n", T);
                    printf("U = %f\n", U);
                    printf("I = %f\n", I);
                    printf("I'' = %f\n", 4*T + 2*U);
                    printf("E = %f\n", E);
                }
                
                double E_dev = abs((E0 - E)/E0);
                if(verbose)
                {
                    printf("E_dev = %f\n", E_dev);
                    printf("Average pos deviation from reference: %.13f\n", pos_devs[0]);
                    printf("Average vel deviation from reference: %.13f\n", vel_devs[0]);
                    printf("Maximum pos length deviation from reference: %.13f\n", pos_devs[1]);
                    printf("Maximum vel length deviation from reference: %.13f\n", vel_devs[1]);
                }
                
                if(E_dev >= 1.0 || pos_devs[1] >= max_error || vel_devs[1] >= max_error) 
                {
                    s_collapse = t;
                    break;
                }
                else
                {
                    E_dev_sol = E_dev;
                    avg_pos_dev_sol = pos_devs[0];
                    avg_vel_dev_sol = vel_devs[0];
                    max_pos_dev_sol = pos_devs[1];
                    max_vel_dev_sol = vel_devs[1];
                }
            }
            delete[] perm;

            printf("true solution = %zu\n", s_collapse);
            if(output_file != NULL)
            {
                fprintf(output_file, "%zu, %s, %zu, %zu, %f, %f, %f, %f, %f, %f, %f\n", curr_N, data_type == Data_type::DOUBLE_PRECISION ? "dp" : "sp", time_steps, s_collapse, curr_ratio, max_error, E_dev_sol, avg_pos_dev_sol, avg_vel_dev_sol, max_pos_dev_sol, max_vel_dev_sol);
            }
        }

        printf("\n\n--------------------------------------------\n--------------------------------------------\n\n\n");
    }
    if(output_file != NULL)
        fclose(output_file);
    return 0;
}