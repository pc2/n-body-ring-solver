#include <algorithm>
#include <stdio.h>
#include <cmath>
#include <stdlib.h>
#include <cstring>
#include <immintrin.h>
#include <stdint.h>
#include <omp.h>
#include <map>
#include <string>

#include "nbody_system.h"

#ifdef LIKWID_PERFMON
#include <likwid.h>
#else
#define LIKWID_MARKER_INIT
#define LIKWID_MARKER_THREADINIT
#define LIKWID_MARKER_SWITCH
#define LIKWID_MARKER_REGISTER(regionTag)
#define LIKWID_MARKER_START(regionTag)
#define LIKWID_MARKER_STOP(regionTag)
#define LIKWID_MARKER_CLOSE
#define LIKWID_MARKER_GET(regionTag, nevents, events, time, count)
#endif

//Used for better caching
//Executing the algorithm blockwise prevents complete cache replacement
constexpr size_t BLOCK_SIZE = 256;


void nbody_bench(size_t start_size, size_t step_size, size_t num_samples,const std::string& output_path);


//Non vectorized version to compare the results of the vectorized versions
double nbody_ref(size_t N, 
               double* mass, 
               double* pos[DIM], 
               double* force[DIM], 
               double* recv_force[DIM]);

//For vectorization 4 aproaches have been made:
//1. Using both AVX2 and AVX512 for vectorization
//2. Using a faster invsqrt with the rsqrt instruction and iterative refinement
double nbody_vectorized_avx2(size_t N, 
                           double* mass, 
                           double* pos[DIM], 
                           double* force_ref[DIM],
                           double* recv_force_ref[DIM]);
double nbody_vectorized_avx2_rsqrt(size_t N, 
                                   double* mass, 
                                   double* pos[DIM], 
                                   double* force_ref[DIM],
                                   double* recv_force_ref[DIM]);
double nbody_vectorized_avx512(size_t N, 
                             double* mass, 
                             double* pos[DIM], 
                             double* force_ref[DIM],
                             double* recv_force_ref[DIM]);
double nbody_vectorized_avx512_rsqrt(size_t N, 
                                   double* mass, 
                                   double* pos[DIM], 
                                   double* force_ref[DIM],
                                   double* recv_force_ref[DIM]);
double nbody_full_vectorized(size_t N, 
                             double* mass, 
                             double* pos[DIM], 
                             double* force_ref[DIM],
                             double* recv_force_ref[DIM]);
double nbody_full_vectorized_avx512_rsqrt(size_t N, 
                                          double* mass, 
                                          double* pos[DIM], 
                                          double* force_ref[DIM],
                                          double* recv_force_ref[DIM]);
double nbody_reduced_vectorized_avx512_rsqrt(size_t N, 
                                          double* mass, 
                                          double* pos[DIM], 
                                          double* force_ref[DIM],
                                          double* recv_force_ref[DIM]);




void get_arguments(int argc, char** argv, std::string& output_path, size_t& start_size, size_t& step_size, size_t& num_samples)
{
    output_path = std::string("single_core.csv");
    start_size = 1000;
    step_size = 1000;
    num_samples = 1;

    for(int i = 1; i<argc; i++)
    {
        if(strcmp(argv[i], "-n") == 0)
        {
            if(i+1 < argc)
            {
                num_samples = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-start") == 0)
        {
            if(i+1 < argc)
            {
                start_size = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-step") == 0)
        {
            if(i+1 < argc)
            {
                step_size = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-o") == 0)
        {
            if(i+1 < argc)
            {
                output_path = std::string(argv[++i]);
            }
        }
    }
    if(output_path == std::string("") || start_size == 0 || step_size == 0 || num_samples == 0)
    {
        printf("Failed to read Arguments!\nUsing defaults!\n");
        output_path = std::string("single_core.csv");
        start_size = 1000;
        step_size = 1000;
        num_samples = 1;
    }
}

int main(int argc, char** argv)
{ 

    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;

    size_t start_size;
    size_t step_size;
    size_t num_samples;
    std::string output_file;
    get_arguments(argc, argv, output_file, start_size, step_size, num_samples);
    printf("Running Benchmark over %zu sample, starting at %zu, linearly increasing the size by %zu\n", num_samples, start_size, step_size);
    printf("Saving the results to %s\n", output_file.c_str());

    LIKWID_MARKER_REGISTER("default-reduced");
    LIKWID_MARKER_REGISTER("vectorized-AVX2");
    LIKWID_MARKER_REGISTER("vectorized-AVX2-rsqrt");
    LIKWID_MARKER_REGISTER("vectorized-AVX512");
    LIKWID_MARKER_REGISTER("vectorized-AVX512-rsqrt");
    nbody_bench(start_size, step_size, num_samples, output_file);
        
    LIKWID_MARKER_CLOSE;
    return 0;
}

//Function to check the solution of a given implementation against a reference solution
int compare_forces(double *force[DIM], double *recv_force[DIM], double *force_ref[DIM], double *recv_force_ref[DIM], int N, double epsilon, const char* method)
{
    int num_mismatch = 0;
    for(int i = 0; i < N;i++)
    {
        double res = force[X][i] + force[Y][i] + force[Z][i] - force_ref[X][i] - force_ref[Y][i] - force_ref[Z][i]
                   + recv_force[X][i] + recv_force[Y][i] + recv_force[Z][i] - recv_force_ref[X][i] - recv_force_ref[Y][i] - recv_force_ref[Z][i];
        if(abs(res) > epsilon)
        {
            num_mismatch++;
            if(num_mismatch < 10)
            {
                printf("Mismatch:\n");
                printf("force[%d]          = [%f,%f,%f]\n", i, force[X][i], force[Y][i], force[Z][i]); 
                printf("force_ref[%d]      = [%f,%f,%f]\n", i, force_ref[X][i], force_ref[Y][i], force_ref[Z][i]); 
                printf("recv_force[%d]     = [%f,%f,%f]\n", i, recv_force[X][i], recv_force[Y][i], recv_force[Z][i]); 
                printf("recv_force_ref[%d] = [%f,%f,%f]\n\n", i, recv_force_ref[X][i], recv_force_ref[Y][i], recv_force_ref[Z][i]);  
            }
        }
    }
    return num_mismatch;
}

void nbody_bench(size_t start_size, size_t step_size, size_t num_samples, const std::string& output_path)
{

    FILE* output_file = fopen(output_path.c_str(), "w");
    fprintf(output_file, "N, t_def, p_def, t_avx2, p_avx2, t_avx2rsqrt, p_avx2rsqrt, t_avx512, p_avx512, t_avx512rsqrt, p_avx512rsqrt, t_avx512rsqrt4i, p_avx512rsqrt4i,t_full,p_full,t_full_rsqrt,p_full_rsqrt\n");

    for(size_t n = 0;n < num_samples;n++)
    {
        size_t N = start_size + n * step_size;
        constexpr size_t avg_steps = 5;
        std::array<double, avg_steps> t_default;
        std::array<double, avg_steps> t_avx2;
        std::array<double, avg_steps> t_avx2rsqrt;
        std::array<double, avg_steps> t_avx512;
        std::array<double, avg_steps> t_avx512rsqrt;    
        std::array<double, avg_steps> t_avx512rsqrt4i;
        std::array<double, avg_steps> t_fullavx2;
        std::array<double, avg_steps> t_fullavx512rsqrt;
        for(size_t avg_step = 0;avg_step < avg_steps;avg_step++)
        { 
            NBody_system sys1;
            NBody_system ref;

            sys1.init_orbiting_particles(N, 1.0, 6.28);
            ref = sys1; 
            double* recv_force_ref[DIM];
            recv_force_ref[X] = (double*)aligned_alloc(64, N*sizeof(double));
            recv_force_ref[Y] = (double*)aligned_alloc(64, N*sizeof(double));
            recv_force_ref[Z] = (double*)aligned_alloc(64, N*sizeof(double));

            for(size_t k = 0;k < N;k++)
            {
                recv_force_ref[X][k] = 0.0;
                recv_force_ref[Y][k] = 0.0;
                recv_force_ref[Z][k] = 0.0;
            }


            printf("\nStarting iteration; N: %zu\n", N);

            //Calculate a reference solution
            t_default[avg_step] = nbody_ref(N,
                                            sys1.mass,
                                            sys1.pos,
                                            ref.force,
                                            recv_force_ref);

            //Run all vectorized solutions and compare the results to the reference soultion
            t_avx2[avg_step] = nbody_vectorized_avx2(N, 
                                                    sys1.mass, 
                                                    sys1.pos, 
                                                    ref.force,
                                                    recv_force_ref);

            t_avx2rsqrt[avg_step] = nbody_vectorized_avx2_rsqrt(N, 
                                                                sys1.mass, 
                                                                sys1.pos, 
                                                                ref.force,
                                                                recv_force_ref);

            t_avx512[avg_step] = nbody_vectorized_avx512(N, 
                                                         sys1.mass, 
                                                         sys1.pos, 
                                                         ref.force,
                                                         recv_force_ref);
        
            t_avx512rsqrt[avg_step] = nbody_vectorized_avx512_rsqrt(N, 
                                                                    sys1.mass, 
                                                                    sys1.pos, 
                                                                    ref.force,
                                                                    recv_force_ref);

        

            t_avx512rsqrt4i[avg_step] = nbody_reduced_vectorized_avx512_rsqrt(N, 
                                                                              sys1.mass, 
                                                                              sys1.pos, 
                                                                              ref.force,
                                                                              recv_force_ref);

            t_fullavx2[avg_step] = nbody_full_vectorized(N,
                                                        sys1.mass,
                                                        sys1.pos,
                                                        ref.force,
                                                        recv_force_ref);
        
            t_fullavx512rsqrt[avg_step] = nbody_full_vectorized_avx512_rsqrt(N,
                                                                             sys1.mass,
                                                                             sys1.pos,
                                                                             ref.force,
                                                                             recv_force_ref);

            free(recv_force_ref[X]);
            free(recv_force_ref[Y]);
            free(recv_force_ref[Z]);

        }
        double num_mpairs = (double(N)*double(N)-double(N))/1e6;

        std::sort(t_default.begin(), t_default.end());
        std::sort(t_avx2.begin(), t_avx2.end());
        std::sort(t_avx2rsqrt.begin(), t_avx2rsqrt.end());
        std::sort(t_avx512.begin(), t_avx512.end());
        std::sort(t_avx512rsqrt.begin(), t_avx512rsqrt.end());
        std::sort(t_avx512rsqrt4i.begin(), t_avx512rsqrt4i.end());
        std::sort(t_fullavx2.begin(), t_fullavx2.end());
        std::sort(t_fullavx512rsqrt.begin(), t_fullavx512rsqrt.end());


        fprintf(output_file,"%zu,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n", N, 
                t_default[avg_steps/2], num_mpairs/t_default[avg_steps/2], 
                t_avx2[avg_steps/2], num_mpairs/t_avx2[avg_steps/2], 
                t_avx2rsqrt[avg_steps/2], num_mpairs/t_avx2rsqrt[avg_steps/2], 
                t_avx512[avg_steps/2], num_mpairs/t_avx512[avg_steps/2], 
                t_avx512rsqrt[avg_steps/2], num_mpairs/t_avx512rsqrt[avg_steps/2],
                t_avx512rsqrt4i[avg_steps/2],num_mpairs/t_avx512rsqrt4i[avg_steps/2],
                t_fullavx2[avg_steps/2],num_mpairs/t_fullavx2[avg_steps/2],
                t_fullavx512rsqrt[avg_steps/2], num_mpairs/t_fullavx512rsqrt[avg_steps/2]);
    }
    fclose(output_file);
}

double nbody_ref(size_t N, 
               double* mass, 
               double* pos[DIM], 
               double* force[DIM], 
               double* recv_force[DIM])
{  
    printf("Default[");
    size_t num_force_pairs = N*N-N; 
    double t_start=omp_get_wtime();
    LIKWID_MARKER_START("default-reduced");
    #pragma omp simd
    for(size_t k=0;k<N;k++)
    {
        for(size_t q=k+1;q<N;q++)
        {
            double diff[DIM];
            diff[X]=pos[X][k]-pos[X][q];
            diff[Y]=pos[Y][k]-pos[Y][q];
            diff[Z]=pos[Z][k]-pos[Z][q];
            double dist=std::sqrt(diff[X]*diff[X]+diff[Y]*diff[Y]+diff[Z]*diff[Z]);
            double force_ij[DIM];
            force_ij[X]=-G*mass[k]*mass[q]*diff[X]/(dist*dist*dist);
            force_ij[Y]=-G*mass[k]*mass[q]*diff[Y]/(dist*dist*dist);
            force_ij[Z]=-G*mass[k]*mass[q]*diff[Z]/(dist*dist*dist);
            force[X][k]+=force_ij[X];
            force[Y][k]+=force_ij[Y];
            force[Z][k]+=force_ij[Z];
            recv_force[X][q]-=force_ij[X];
            recv_force[Y][q]-=force_ij[Y];
            recv_force[Z][q]-=force_ij[Z];
        }
    }
    LIKWID_MARKER_STOP("default-reduced");
    double t_end=omp_get_wtime();
     
    printf("x]     : Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    return t_end - t_start;

}

double nbody_vectorized_avx2(size_t N, 
                           double* mass, 
                           double* pos[DIM], 
                           double* force_ref[DIM],
                           double* recv_force_ref[DIM])
{
    printf("AVX2[");
    double *force[DIM], *recv_force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
        recv_force[X][k] = 0.0;
        recv_force[Y][k] = 0.0;
        recv_force[Z][k] = 0.0;
    }
    
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    size_t num_force_pairs = N*N-N; 
    double t_start = omp_get_wtime(); 
    LIKWID_MARKER_START("vectorized-AVX2");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        size_t k_bound = std::min(next_block, N);
        for(size_t k = 0;k < k_bound;k++)
        {
            double pre_calc = -G*mass[k];
            size_t q = curr_block > k+1 ? curr_block : k+1;
            size_t align_offset = (q & 0b11);
            //Fix alignment by assuming that the 0th element of each array is 4-byte aligned
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 4 - align_offset && q < k_bound ;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
                }
                break;
            }

            //force[k] is calculated simultaneously across 4 registers
            __m256d force_k_x = _mm256_set1_pd(0.0);
            __m256d force_k_y = _mm256_set1_pd(0.0);
            __m256d force_k_z = _mm256_set1_pd(0.0);
            
            //preload innerloop constants to registers
            __m256d pos_k_x = _mm256_set1_pd(pos[X][k]);
            __m256d pos_k_y = _mm256_set1_pd(pos[Y][k]);
            __m256d pos_k_z = _mm256_set1_pd(pos[Z][k]);
            __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);

            for(;q+3 < k_bound;q+=4)
            {
                //diff = pos[k] - pos[q]
                __m256d diff_x = pos_k_x;
                __m256d diff_y = pos_k_y;
                __m256d diff_z = pos_k_z;
                __m256d pos_q_x = _mm256_load_pd(&(pos[X][q]));
                __m256d pos_q_y = _mm256_load_pd(&(pos[Y][q]));
                __m256d pos_q_z = _mm256_load_pd(&(pos[Z][q]));
                diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                diff_z = _mm256_sub_pd(diff_z, pos_q_z);

                //dist = sqrt(<diff,diff>)
                __m256d dist = _mm256_mul_pd(diff_x,diff_x);
                __m256d tmp = _mm256_mul_pd(diff_y,diff_y);
                dist = _mm256_add_pd(dist,tmp);
                tmp = _mm256_mul_pd(diff_z,diff_z);
                dist = _mm256_add_pd(dist,tmp);
                dist = _mm256_sqrt_pd(dist);

                //dist^3 = dist * dist * dist
                __m256d dist3  = _mm256_mul_pd(dist,dist);
                dist3 = _mm256_mul_pd(dist, dist3);

                
                __m256d force_q_x = _mm256_load_pd(&(recv_force[X][q]));
                __m256d force_q_y = _mm256_load_pd(&(recv_force[Y][q]));
                __m256d force_q_z = _mm256_load_pd(&(recv_force[Z][q]));

                //force_kq = (-G * mass[k] * mass[q]/dist^3) * diff
                __m256d scalar_factor = _mm256_load_pd(&mass[q]);
                scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm256_div_pd(scalar_factor, dist3);
                __m256d force_x = _mm256_mul_pd(scalar_factor,diff_x);
                __m256d force_y = _mm256_mul_pd(scalar_factor,diff_y);
                __m256d force_z = _mm256_mul_pd(scalar_factor,diff_z);

                //force[q] -= force_kq
                force_q_x = _mm256_sub_pd(force_q_x, force_x);
                force_q_y = _mm256_sub_pd(force_q_y, force_y);
                force_q_z = _mm256_sub_pd(force_q_z, force_z);
                
                
                _mm256_store_pd(&(recv_force[X][q]), force_q_x);
                _mm256_store_pd(&(recv_force[Y][q]), force_q_y);
                _mm256_store_pd(&(recv_force[Z][q]), force_q_z);

                //force_k += force_kq
                force_k_x = _mm256_add_pd(force_k_x, force_x);
                force_k_y = _mm256_add_pd(force_k_y, force_y);
                force_k_z = _mm256_add_pd(force_k_z, force_z);
            }
            //horizontal add across force_k before storing the result back to memory
            //force[k] += h_add(force_k)
            //
            //reduce_add intrinsic not available for _mm256
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
            force[X][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_x_low, force_k_x_high64));
            force[Y][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_y_low, force_k_y_high64));
            force[Z][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_z_low, force_k_z_high64));

            //Calculate non vectorized remainder
            for(;q < k_bound;q++)
            {
                double diff[DIM];
                diff[X] = pos[X][k] - pos[X][q];
                diff[Y] = pos[Y][k] - pos[Y][q];
                diff[Z] = pos[Z][k] - pos[Z][q];
                double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                double force_ij[DIM];
                force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                force[X][k] += force_ij[X];
                force[Y][k] += force_ij[Y];
                force[Z][k] += force_ij[Z];
                recv_force[X][q] -= force_ij[X];
                recv_force[Y][q] -= force_ij[Y];
                recv_force[Z][q] -= force_ij[Z];
            }
        }
    }
    LIKWID_MARKER_STOP("vectorized-AVX2");
    double t_end = omp_get_wtime();
    
    int mismatches = compare_forces(force, recv_force, force_ref, recv_force_ref, N, 0.0001, "AVX2");
    //printf("Vectorized reordered version took: %fs\n", t_end - t_start);
    if(mismatches == 0)
        printf("x]        : Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]        : Force mismatches; %d\n", mismatches);

    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    return t_end - t_start;
}

double nbody_vectorized_avx2_rsqrt(size_t N, 
                           double* mass, 
                           double* pos[DIM], 
                           double* force_ref[DIM],
                           double* recv_force_ref[DIM])
{
    double *force[DIM], *recv_force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
        recv_force[X][k] = 0.0;
        recv_force[Y][k] = 0.0;
        recv_force[Z][k] = 0.0;
    }
    
    printf("AVX2-rsqrt[");

    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime(); 
    LIKWID_MARKER_START("vectorized-AVX2-rsqrt");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        size_t k_bound = std::min(next_block, N);
        for(size_t k = 0;k < k_bound;k++)
        {
            double pre_calc = -G*mass[k];
            size_t q = curr_block > k+1 ? curr_block : k+1;
            size_t align_offset = (q & 0b11);
            //Fix alignment by assuming that the 0th element of each array is 4-byte aligned
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 4 - align_offset && q < k_bound;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
                }
                break;
            }
            
            //force[k] is calculated simultaneously across 4 registers
            __m256d force_k_x = _mm256_set1_pd(0.0);
            __m256d force_k_y = _mm256_set1_pd(0.0);
            __m256d force_k_z = _mm256_set1_pd(0.0);
            
            //preload innerloop constants to registers
            __m256d pos_k_x = _mm256_set1_pd(pos[X][k]);
            __m256d pos_k_y = _mm256_set1_pd(pos[Y][k]);
            __m256d pos_k_z = _mm256_set1_pd(pos[Z][k]);
            __m256d pre_calc_avx = _mm256_set1_pd(pre_calc);
            __m256d three = _mm256_set1_pd(3.0);
            __m256d half = _mm256_set1_pd(0.5);

            for(;q+3 < k_bound;q+=4)
            {
                //diff = pos[k] - pos[q]
                __m256d diff_x = pos_k_x;
                __m256d diff_y = pos_k_y;
                __m256d diff_z = pos_k_z;
                __m256d pos_q_x = _mm256_load_pd(&(pos[X][q]));
                __m256d pos_q_y = _mm256_load_pd(&(pos[Y][q]));
                __m256d pos_q_z = _mm256_load_pd(&(pos[Z][q]));
                diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                diff_z = _mm256_sub_pd(diff_z, pos_q_z);
     
                //dist^2 = <diff,diff>
                __m256d inv_dist_sq = _mm256_mul_pd(diff_x,diff_x);
                __m256d inv_dist = _mm256_mul_pd(diff_y,diff_y);
                inv_dist_sq = _mm256_add_pd(inv_dist_sq, inv_dist);
                inv_dist = _mm256_mul_pd(diff_z,diff_z);
                inv_dist_sq = _mm256_add_pd(inv_dist_sq, inv_dist);

                //Calculate invdist = 1/dist by using the rsqrt instruction and Refinement by Newton's Method:
                //guess: y_0 = rsqrt(dist^2)
                inv_dist = _mm256_rsqrt14_pd(inv_dist_sq);
                //First iterative refinement:
                //y_n+1 = 0.5 * y_n * (3 - x * y_n * y_n)
                __m256d tmp_approx = _mm256_mul_pd(inv_dist,inv_dist); // y*y
                tmp_approx = _mm256_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                tmp_approx = _mm256_sub_pd(three, tmp_approx); //3-x*y*y
                inv_dist = _mm256_mul_pd(inv_dist, half);//y*0.5
                inv_dist = _mm256_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)

                //Second iterative refinement:
                tmp_approx = _mm256_mul_pd(inv_dist,inv_dist); // y*y
                tmp_approx = _mm256_mul_pd(tmp_approx,inv_dist_sq); //x*y*y
                tmp_approx = _mm256_sub_pd(three, tmp_approx); //3-x*y*y
                inv_dist = _mm256_mul_pd(inv_dist, half);//y*0.5
                inv_dist = _mm256_mul_pd(inv_dist, tmp_approx);//y*0.5 *(3-x*y*y)
                //inv_dist = y_2

                //inv_dist^3 = inv_dist * inv_dist * inv_dist
                __m256d inv_dist3  = _mm256_mul_pd(inv_dist,inv_dist);
                inv_dist3 = _mm256_mul_pd(inv_dist, inv_dist3);
     
                __m256d force_q_x = _mm256_load_pd(&(recv_force[X][q]));
                __m256d force_q_y = _mm256_load_pd(&(recv_force[Y][q]));
                __m256d force_q_z = _mm256_load_pd(&(recv_force[Z][q]));

                //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                __m256d scalar_factor = _mm256_load_pd(&mass[q]);
                scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm256_mul_pd(scalar_factor, inv_dist3);
                
                __m256d force_x = _mm256_mul_pd(scalar_factor,diff_x);
                __m256d force_y = _mm256_mul_pd(scalar_factor,diff_y);
                __m256d force_z = _mm256_mul_pd(scalar_factor,diff_z);

                
                //force[q] -= force_kq
                force_q_x = _mm256_sub_pd(force_q_x, force_x);
                force_q_y = _mm256_sub_pd(force_q_y, force_y);
                force_q_z = _mm256_sub_pd(force_q_z, force_z);
                
                
                _mm256_store_pd(&(recv_force[X][q]), force_q_x);
                _mm256_store_pd(&(recv_force[Y][q]), force_q_y);
                _mm256_store_pd(&(recv_force[Z][q]), force_q_z);

                //force_k += force_kq
                force_k_x = _mm256_add_pd(force_k_x, force_x);
                force_k_y = _mm256_add_pd(force_k_y, force_y);
                force_k_z = _mm256_add_pd(force_k_z, force_z);
            }
            //horizontal add across force_k before storing the result back to memory
            //force[k] += h_add(force_k)
            //
            //reduce_add intrinsic not available for _mm256
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
            force[X][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_x_low, force_k_x_high64));
            force[Y][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_y_low, force_k_y_high64));
            force[Z][k] += _mm_cvtsd_f64(_mm_add_sd(force_k_z_low, force_k_z_high64));

            //Calculate non vectorized remainder
            for(;q < k_bound;q++)
            {
                
                double diff[DIM];
                diff[X] = pos[X][k] - pos[X][q];
                diff[Y] = pos[Y][k] - pos[Y][q];
                diff[Z] = pos[Z][k] - pos[Z][q];
                double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                double force_ij[DIM];
                force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                force[X][k] += force_ij[X];
                force[Y][k] += force_ij[Y];
                force[Z][k] += force_ij[Z];
                recv_force[X][q] -= force_ij[X];
                recv_force[Y][q] -= force_ij[Y];
                recv_force[Z][q] -= force_ij[Z];
            }
        }
    }
    LIKWID_MARKER_STOP("vectorized-AVX2-rsqrt");
    double t_end = omp_get_wtime();
     
    int mismatches = compare_forces(force, recv_force, force_ref, recv_force_ref, N, 0.0001, "AVX2-rsqrt");
    //printf("Vectorized reordered version took: %fs\n", t_end - t_start);
    if(mismatches == 0)
        printf("x]  : Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]  : Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    return t_end - t_start;
}

double nbody_vectorized_avx512(size_t N, 
                             double* mass, 
                             double* pos[DIM], 
                             double* force_ref[DIM],
                             double* recv_force_ref[DIM])
{
    double *force[DIM], *recv_force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
        recv_force[X][k] = 0.0;
        recv_force[Y][k] = 0.0;
        recv_force[Z][k] = 0.0;
    }
    printf("AVX512[");
    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime(); 
    LIKWID_MARKER_START("vectorized-AVX512");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        size_t k_bound = std::min(next_block, N);
        for(size_t k = 0;k < k_bound;k++)
        {
            double pre_calc = -G*mass[k];
            size_t q = curr_block > k+1 ? curr_block : k+1;
            
            size_t align_offset = (q & 0b111);
            //Fix alignment by assuming that the 0th element of each array is 8-byte aligned
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 8 - align_offset && q < k_bound;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
                }
                break;
            }
            
            //force[k] is calculated simultaneously across 8 registers
            __m512d force_k_x = _mm512_set1_pd(0.0);
            __m512d force_k_y = _mm512_set1_pd(0.0);
            __m512d force_k_z = _mm512_set1_pd(0.0);
            
            //preload innerloop constants to registers
            __m512d pos_k_x = _mm512_set1_pd(pos[X][k]);
            __m512d pos_k_y = _mm512_set1_pd(pos[Y][k]);
            __m512d pos_k_z = _mm512_set1_pd(pos[Z][k]);
            __m512d pre_calc_avx = _mm512_set1_pd(pre_calc);

            for(;q+7 < k_bound;q+=8)
            {
                //diff = pos[k] - pos[q]
                __m512d diff_x = pos_k_x;
                __m512d diff_y = pos_k_y;
                __m512d diff_z = pos_k_z;
                __m512d pos_q_x = _mm512_load_pd(&(pos[X][q]));
                __m512d pos_q_y = _mm512_load_pd(&(pos[Y][q]));
                __m512d pos_q_z = _mm512_load_pd(&(pos[Z][q]));
                diff_x = _mm512_sub_pd(diff_x, pos_q_x);
                diff_y = _mm512_sub_pd(diff_y, pos_q_y);
                diff_z = _mm512_sub_pd(diff_z, pos_q_z);

                //dist = sqrt(<diff,diff>)
                __m512d dist = _mm512_mul_pd(diff_x,diff_x);
                __m512d tmp = _mm512_mul_pd(diff_y,diff_y);
                dist = _mm512_add_pd(dist,tmp);
                tmp = _mm512_mul_pd(diff_z,diff_z);
                dist = _mm512_add_pd(dist,tmp);
                dist = _mm512_sqrt_pd(dist);

                //dist^3 = dist * dist * dist
                __m512d dist3 = _mm512_mul_pd(dist,dist);
                dist3 = _mm512_mul_pd(dist3,dist);
               
 
                __m512d force_q_x = _mm512_load_pd(&(recv_force[X][q]));
                __m512d force_q_y = _mm512_load_pd(&(recv_force[Y][q]));
                __m512d force_q_z = _mm512_load_pd(&(recv_force[Z][q]));

                //force_kq = (-G * mass[k] * mass[q]/dist^3) * diff
                __m512d scalar_factor = _mm512_load_pd(&mass[q]);
                scalar_factor = _mm512_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm512_div_pd(scalar_factor, dist3);
                __m512d force_x = _mm512_mul_pd(scalar_factor,diff_x);
                __m512d force_y = _mm512_mul_pd(scalar_factor,diff_y);
                __m512d force_z = _mm512_mul_pd(scalar_factor,diff_z);

                
                //force[q] -= force_kq
                force_q_x = _mm512_sub_pd(force_q_x, force_x);
                force_q_y = _mm512_sub_pd(force_q_y, force_y);
                force_q_z = _mm512_sub_pd(force_q_z, force_z);
                
                
                _mm512_store_pd(&(recv_force[X][q]), force_q_x);
                _mm512_store_pd(&(recv_force[Y][q]), force_q_y);
                _mm512_store_pd(&(recv_force[Z][q]), force_q_z);

                //force_k += force_kq
                force_k_x = _mm512_add_pd(force_k_x, force_x);
                force_k_y = _mm512_add_pd(force_k_y, force_y);
                force_k_z = _mm512_add_pd(force_k_z, force_z);
            }
            //horizontal add across force_k before storing the result back to memory
            //force[k] += h_add(force_k)
            force[X][k] += _mm512_reduce_add_pd(force_k_x);
            force[Y][k] += _mm512_reduce_add_pd(force_k_y);
            force[Z][k] += _mm512_reduce_add_pd(force_k_z);

            //Calculate non vectorized remainder
            for(;q < k_bound;q++)
            {
                double diff[DIM];
                diff[X] = pos[X][k] - pos[X][q];
                diff[Y] = pos[Y][k] - pos[Y][q];
                diff[Z] = pos[Z][k] - pos[Z][q];
                double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                double force_ij[DIM];
                force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                force[X][k] += force_ij[X];
                force[Y][k] += force_ij[Y];
                force[Z][k] += force_ij[Z];
                recv_force[X][q] -= force_ij[X];
                recv_force[Y][q] -= force_ij[Y];
                recv_force[Z][q] -= force_ij[Z];
            }
        }
    }
    LIKWID_MARKER_STOP("vectorized-AVX512");
    double t_end = omp_get_wtime();
    
    int mismatches = compare_forces(force, recv_force, force_ref, recv_force_ref, N, 0.0001,"AVX512");
    if(mismatches == 0)
        printf("x]      : Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]      : Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    return t_end - t_start;
}

double nbody_vectorized_avx512_rsqrt(size_t N, 
                             double* mass, 
                             double* pos[DIM], 
                             double* force_ref[DIM],
                             double* recv_force_ref[DIM])
{
    double *force[DIM], *recv_force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
        recv_force[X][k] = 0.0;
        recv_force[Y][k] = 0.0;
        recv_force[Z][k] = 0.0;
    }
    printf("AVX512-rsqrt[");
    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime(); 
    LIKWID_MARKER_START("vectorized-AVX512-rsqrt");
    
    double* pos_x = pos[X];
    double* pos_y = pos[Y];
    double* pos_z = pos[Z];

    double* recv_force_x = recv_force[X];
    double* recv_force_y = recv_force[Y];
    double* recv_force_z = recv_force[Z];
    
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        size_t k_bound = std::min(next_block, N);
        for(size_t k = 0;k < k_bound;k++)
        {
            double pre_calc = -G*mass[k];
            size_t q = curr_block > k+1 ? curr_block : k+1;
            
            size_t align_offset = (q & 0b111);
            //Fix alignment by assuming that the 0th element of each array is 8-byte aligned
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 8 - align_offset && q < k_bound;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
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

            for(;q+7 < k_bound;q+=8)
            {
                //diff = pos[k] - pos[q]
                __m512d diff_x = pos_k_x;
                __m512d diff_y = pos_k_y;
                __m512d diff_z = pos_k_z;
                __m512d pos_q_x = _mm512_load_pd(&(pos_x[q]));
                __m512d pos_q_y = _mm512_load_pd(&(pos_y[q]));
                __m512d pos_q_z = _mm512_load_pd(&(pos_z[q]));
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

                __m512d force_q_x = _mm512_load_pd(&(recv_force_x[q]));
                __m512d force_q_y = _mm512_load_pd(&(recv_force_y[q]));
                __m512d force_q_z = _mm512_load_pd(&(recv_force_z[q]));

                //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                __m512d scalar_factor = _mm512_load_pd(&mass[q]);
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
                
                
                _mm512_store_pd(&(recv_force_x[q]), force_q_x);
                _mm512_store_pd(&(recv_force_y[q]), force_q_y);
                _mm512_store_pd(&(recv_force_z[q]), force_q_z);

            }
            //horizontal add across force_k before storing the result back to memory
            //force[k] += h_add(force_k)
            force[X][k] += _mm512_reduce_add_pd(force_k_x);
            force[Y][k] += _mm512_reduce_add_pd(force_k_y);
            force[Z][k] += _mm512_reduce_add_pd(force_k_z);

            //Calculate non vectorized remainder
            for(;q < k_bound;q++)
            {
                double diff[DIM];
                diff[X] = pos[X][k] - pos[X][q];
                diff[Y] = pos[Y][k] - pos[Y][q];
                diff[Z] = pos[Z][k] - pos[Z][q];
                double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                double force_ij[DIM];
                force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                force[X][k] += force_ij[X];
                force[Y][k] += force_ij[Y];
                force[Z][k] += force_ij[Z];
                recv_force[X][q] -= force_ij[X];
                recv_force[Y][q] -= force_ij[Y];
                recv_force[Z][q] -= force_ij[Z];
            }
        }
    }
    LIKWID_MARKER_STOP("vectorized-AVX512-rsqrt");
    double t_end = omp_get_wtime();
    int mismatches = compare_forces(force, recv_force, force_ref, recv_force_ref, N, 0.0001,"AVX512-rsqrt");
    if(mismatches == 0)
        printf("x]: Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]; Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    return t_end - t_start;
}

double nbody_full_vectorized(size_t N, 
                             double* mass, 
                             double* pos[DIM], 
                             double* force_ref[DIM],
                             double* recv_force_ref[DIM])
{
    double *force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));

    size_t num_masks = N/4;
    if(num_masks*4 != N)num_masks++;
    __mmask8* sqrt_mask = (__mmask8*)malloc(num_masks*sizeof(__mmask8));

    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
    }
    for(size_t k = 0;k < num_masks;k++)
    {
        sqrt_mask[k] = 0xFF;
    }
    printf("AVX512-full[");
    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime();

    double* pos_x = pos[X];
    double* pos_y = pos[Y];
    double* pos_z = pos[Z];

    double* force_x = force[X];
    double* force_y = force[Y];
    double* force_z = force[Z];

    LIKWID_MARKER_START("full-vectorized");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        for(size_t k = 0;k < N;k++)
        {
            size_t curr_mask_index = k/4;
            size_t curr_mask_bit = 1 << (k & 3);
            sqrt_mask[curr_mask_index] ^= curr_mask_bit;
            double pre_calc = -G*mass[k];
            size_t q = curr_block;
            size_t q_bound = std::min(N,next_block);
            
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
                __m256d pos_q_x = _mm256_load_pd(&(pos_x[q]));
                __m256d pos_q_y = _mm256_load_pd(&(pos_y[q]));
                __m256d pos_q_z = _mm256_load_pd(&(pos_z[q]));
                diff_x = _mm256_sub_pd(diff_x, pos_q_x);
                diff_y = _mm256_sub_pd(diff_y, pos_q_y);
                diff_z = _mm256_sub_pd(diff_z, pos_q_z);

                //dist = sqrt(<diff,diff>)
                __m256d dist = _mm256_mul_pd(diff_x,diff_x);
                __m256d tmp = _mm256_mul_pd(diff_y,diff_y);
                dist = _mm256_add_pd(dist,tmp);
                tmp = _mm256_mul_pd(diff_z,diff_z);
                dist = _mm256_add_pd(dist,tmp);
                dist = _mm256_maskz_sqrt_pd(sqrt_mask[q >> 2],dist);

                //dist^3 = dist * dist * dist
                __m256d dist3  = _mm256_mul_pd(dist,dist);
                dist3 = _mm256_mul_pd(dist, dist3);

                
                __m256d force_q_x = _mm256_load_pd(&(force_x[q]));
                __m256d force_q_y = _mm256_load_pd(&(force_y[q]));
                __m256d force_q_z = _mm256_load_pd(&(force_z[q]));

                //force_kq = (-G * mass[k] * mass[q]/dist^3) * diff
                __m256d scalar_factor = _mm256_load_pd(&mass[q]);
                scalar_factor = _mm256_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm256_maskz_div_pd(sqrt_mask[q >> 2], scalar_factor, dist3);
                __m256d force_kq_x = _mm256_mul_pd(scalar_factor,diff_x);
                __m256d force_kq_y = _mm256_mul_pd(scalar_factor,diff_y);
                __m256d force_kq_z = _mm256_mul_pd(scalar_factor,diff_z);

                //force[q] -= force_kq
                force_q_x = _mm256_sub_pd(force_q_x, force_kq_x);
                force_q_y = _mm256_sub_pd(force_q_y, force_kq_y);
                force_q_z = _mm256_sub_pd(force_q_z, force_kq_z);
                
                _mm256_store_pd(&(force_x[q]), force_q_x);
                _mm256_store_pd(&(force_y[q]), force_q_y);
                _mm256_store_pd(&(force_z[q]), force_q_z);
            }

            //Calculate non vectorized remainder
            for(;q < q_bound;q++)
            {
                if(k != q)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][q] -= force_ij[X];
                    force[Y][q] -= force_ij[Y];
                    force[Z][q] -= force_ij[Z];
                }
            }
            sqrt_mask[curr_mask_index] ^= curr_mask_bit;
        }
    }
    LIKWID_MARKER_STOP("full-vectorized");
    double t_end = omp_get_wtime();

    double* recv_force[DIM];
    double* full_force_ref[DIM];
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[X] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            full_force_ref[d][k] = force_ref[d][k] + recv_force_ref[d][k];
            recv_force[d][k] = 0.0;
        } 
    }

    int mismatches = compare_forces(force, recv_force, full_force_ref, recv_force, N, 0.0001,"AVX512-rsqrt");
    if(mismatches == 0)
        printf("x]: Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]; Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    free(full_force_ref[X]);
    free(full_force_ref[Y]);
    free(full_force_ref[Z]);
    free(sqrt_mask);
    return t_end - t_start;
}
double nbody_full_vectorized_avx512_rsqrt(size_t N, 
                                          double* mass, 
                                          double* pos[DIM], 
                                          double* force_ref[DIM],
                                          double* recv_force_ref[DIM])
{
    double *force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));

    size_t num_masks = N/8;
    if(num_masks*8 != N)num_masks++;
    __mmask8* rsqrt_mask = (__mmask8*)malloc(num_masks*sizeof(__mmask8));

    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
    }
    for(size_t k = 0;k < num_masks;k++)
    {
        rsqrt_mask[k] = 0xFF;
    }
    printf("AVX512-full-rsqrt-8i[");
    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime();

    double* pos_x = pos[X];
    double* pos_y = pos[Y];
    double* pos_z = pos[Z];

    double* force_x = force[X];
    double* force_y = force[Y];
    double* force_z = force[Z];

    LIKWID_MARKER_START("full-vectorized-AVX512-rsqrt");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        for(size_t k = 0;k < N;k++)
        {
            size_t curr_mask_index = k/8;
            size_t curr_mask_bit = 1 << (k & 7);
            rsqrt_mask[curr_mask_index] ^= curr_mask_bit;
            double pre_calc = -G*mass[k];
            size_t q = curr_block;
            size_t q_bound = std::min(N,next_block);
            
            //preload innerloop constants to registers
            __m512d pos_k_x = _mm512_set1_pd(pos_x[k]);
            __m512d pos_k_y = _mm512_set1_pd(pos_y[k]);
            __m512d pos_k_z = _mm512_set1_pd(pos_z[k]);
            __m512d pre_calc_avx = _mm512_set1_pd(pre_calc);
            __m512d three = _mm512_set1_pd(3.0);
            __m512d half = _mm512_set1_pd(0.5);

            constexpr size_t ii = 8;
            __m512d reg1[ii];
            __m512d reg2[ii];
            __m512d reg3[ii];
           

            for(;q+63 < q_bound;q+=64)
            {
                //diff = pos[k] - pos[q]
                for(size_t i = 0;i < ii;i++)
                {
                    reg1[i] = _mm512_load_pd(&(pos_x[q+8*i]));
                    reg1[i] = _mm512_sub_pd(pos_k_x, reg1[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg2[i] = _mm512_load_pd(&(pos_y[q+8*i]));
                    reg2[i] = _mm512_sub_pd(pos_k_y, reg2[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg3[i] = _mm512_load_pd(&(pos_z[q+8*i]));
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
                    reg3[i] = _mm512_load_pd(&mass[q+8*i]);
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
                    reg1[i] = _mm512_load_pd(&(pos_x[q+8*i]));
                    reg1[i] = _mm512_sub_pd(pos_k_x, reg1[i]);
                }
                asm volatile("": : :"memory");

                for(size_t i = 0;i < ii;i++)
                {
                    reg2[i] = _mm512_load_pd(&(force_x[q+8*i]));
                    reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(force_x[q+8*i]), reg2[i]);
                }
                asm volatile("": : :"memory");
                
                for(size_t i = 0;i < ii;i++)
                {
                    reg1[i] = _mm512_load_pd(&(pos_y[q+8*i]));
                    reg1[i] = _mm512_sub_pd(pos_k_y, reg1[i]);
                }
                asm volatile("": : :"memory");

                for(size_t i = 0;i < ii;i++)
                {
                    reg2[i] = _mm512_load_pd(&(force_y[q+8*i]));
                    reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(force_y[q+8*i]), reg2[i]);
                }
                asm volatile("": : :"memory");
                
                for(size_t i = 0;i < ii;i++)
                {
                    reg1[i] = _mm512_load_pd(&(pos_z[q+8*i]));
                    reg1[i] = _mm512_sub_pd(pos_k_z, reg1[i]);
                }
                asm volatile("": : :"memory");

                for(size_t i = 0;i < ii;i++)
                {
                    reg2[i] = _mm512_load_pd(&(force_z[q+8*i]));
                    reg1[i] = _mm512_mul_pd(reg3[i], reg1[i]);
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(force_z[q+8*i]), reg2[i]);
                }
                asm volatile("": : :"memory");
            }
            for(;q+7 < q_bound;q+=8)
            {
                //diff = pos[k] - pos[q]
                __m512d diff_x = pos_k_x;
                __m512d diff_y = pos_k_y;
                __m512d diff_z = pos_k_z;
                __m512d pos_q_x = _mm512_load_pd(&(pos_x[q]));
                __m512d pos_q_y = _mm512_load_pd(&(pos_y[q]));
                __m512d pos_q_z = _mm512_load_pd(&(pos_z[q]));
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

                __m512d force_q_x = _mm512_load_pd(&(force_x[q]));
                __m512d force_q_y = _mm512_load_pd(&(force_y[q]));
                __m512d force_q_z = _mm512_load_pd(&(force_z[q]));

                //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                __m512d scalar_factor = _mm512_load_pd(&mass[q]);
                scalar_factor = _mm512_mul_pd(pre_calc_avx, scalar_factor);
                scalar_factor = _mm512_mul_pd(scalar_factor, inv_dist3);

                __m512d force_x = _mm512_mul_pd(scalar_factor,diff_x);
                __m512d force_y = _mm512_mul_pd(scalar_factor,diff_y);
                __m512d force_z = _mm512_mul_pd(scalar_factor,diff_z);
   
                //force[q] -= force_kq
                force_q_x = _mm512_sub_pd(force_q_x, force_x);
                force_q_y = _mm512_sub_pd(force_q_y, force_y);
                force_q_z = _mm512_sub_pd(force_q_z, force_z);
                
                _mm512_store_pd(&(force_x[q]), force_q_x);
                _mm512_store_pd(&(force_y[q]), force_q_y);
                _mm512_store_pd(&(force_z[q]), force_q_z);
            }

            //Calculate non vectorized remainder
            for(;q < q_bound;q++)
            {
                if(k != q)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][q] -= force_ij[X];
                    force[Y][q] -= force_ij[Y];
                    force[Z][q] -= force_ij[Z];
                }
            }
            rsqrt_mask[curr_mask_index] ^= curr_mask_bit;
        }
    }
    LIKWID_MARKER_STOP("full-vectorized-AVX512-rsqrt");
    double t_end = omp_get_wtime();

    double* recv_force[DIM];
    double* full_force_ref[DIM];
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[X] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    full_force_ref[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t k = 0;k < N;k++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            full_force_ref[d][k] = force_ref[d][k] + recv_force_ref[d][k];
            recv_force[d][k] = 0.0;
        } 
    }

    int mismatches = compare_forces(force, recv_force, full_force_ref, recv_force, N, 0.0001,"AVX512-rsqrt");
    if(mismatches == 0)
        printf("x]: Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]; Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    free(full_force_ref[X]);
    free(full_force_ref[Y]);
    free(full_force_ref[Z]);
    free(rsqrt_mask);
    return t_end - t_start;
}

double nbody_reduced_vectorized_avx512_rsqrt(size_t N, 
                                             double* mass, 
                                             double* pos[DIM], 
                                             double* force_ref[DIM],
                                             double* recv_force_ref[DIM])
{
    double *force[DIM], *recv_force[DIM];
    force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    force[Z] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[X] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Y] = (double*)aligned_alloc(64, N*sizeof(double));
    recv_force[Z] = (double*)aligned_alloc(64, N*sizeof(double));

    for(size_t k = 0;k < N;k++)
    {
        force[X][k] = 0.0;
        force[Y][k] = 0.0;
        force[Z][k] = 0.0;
        recv_force[X][k] = 0.0;
        recv_force[Y][k] = 0.0;
        recv_force[Z][k] = 0.0;
    }
    printf("AVX512-rsqrt-4i[");
    size_t num_force_pairs = N*N-N; 
    size_t num_blocks = N / BLOCK_SIZE;
    if(num_blocks * BLOCK_SIZE != N)num_blocks++;
    double t_start = omp_get_wtime();

    double* pos_x = pos[X];
    double* pos_y = pos[Y];
    double* pos_z = pos[Z];

    double* recv_force_x = recv_force[X];
    double* recv_force_y = recv_force[Y];
    double* recv_force_z = recv_force[Z];

    LIKWID_MARKER_START("reduced-vectorized-AVX512-rsqrt");
    for(size_t b = 0;b < num_blocks;b++)
    {
        size_t curr_block = b * BLOCK_SIZE;
        size_t next_block = (b+1) * BLOCK_SIZE;
        size_t k_bound = std::min(next_block, N);
        for(size_t k = 0;k < k_bound;k++)
        {
            double pre_calc = -G*mass[k];
            size_t q = curr_block > k+1 ? curr_block : k+1;
            
            size_t align_offset = (q & 0b111);
            //Fix alignment by assuming that the 0th element of each array is 8-byte aligned
            switch(align_offset)
            {
                case 0:
                    break;
                default:
                for(size_t peel = 0; peel < 8 - align_offset && q < k_bound;peel++,q++)
                {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
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
                    reg1[i] = _mm512_load_pd(&(pos_x[q+8*i]));
                    reg1[i] = _mm512_sub_pd(pos_k_x, reg1[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg2[i] = _mm512_load_pd(&(pos_y[q+8*i]));
                    reg2[i] = _mm512_sub_pd(pos_k_y, reg2[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg3[i] = _mm512_load_pd(&(pos_z[q+8*i]));
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
                    reg3[i] = _mm512_load_pd(&mass[q+8*i]);
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
                    reg1[i] = _mm512_load_pd(&(pos_x[q+8*i]));
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
                    reg2[i] = _mm512_load_pd(&(recv_force_x[q+8*i]));
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(recv_force_x[q+8*i]), reg2[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg1[i] = _mm512_load_pd(&(pos_y[q+8*i]));
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
                    reg2[i] = _mm512_load_pd(&(recv_force_y[q+8*i]));
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(recv_force_y[q+8*i]), reg2[i]);
                }
                asm volatile("": : :"memory");
                for(size_t i = 0;i < ii;i++)
                {
                    reg1[i] = _mm512_load_pd(&(pos_z[q+8*i]));
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
                    reg2[i] = _mm512_load_pd(&(recv_force_z[q+8*i]));
                    reg2[i] = _mm512_sub_pd(reg2[i], reg1[i]);
                    _mm512_store_pd(&(recv_force_z[q+8*i]), reg2[i]);
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
                __m512d pos_q_x = _mm512_load_pd(&(pos_x[q]));
                __m512d pos_q_y = _mm512_load_pd(&(pos_y[q]));
                __m512d pos_q_z = _mm512_load_pd(&(pos_z[q]));
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

                __m512d force_q_x = _mm512_load_pd(&(recv_force_x[q]));
                __m512d force_q_y = _mm512_load_pd(&(recv_force_y[q]));
                __m512d force_q_z = _mm512_load_pd(&(recv_force_z[q]));

                //force_kq = -G * mass[k] * mass[q] * inv_dist^3 * diff
                __m512d scalar_factor = _mm512_load_pd(&mass[q]);
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
                
                _mm512_store_pd(&(recv_force_x[q]), force_q_x);
                _mm512_store_pd(&(recv_force_y[q]), force_q_y);
                _mm512_store_pd(&(recv_force_z[q]), force_q_z);
            }


            force[X][k] += _mm512_reduce_add_pd(force_k_x[0]);
            force[Y][k] += _mm512_reduce_add_pd(force_k_y[0]);
            force[Z][k] += _mm512_reduce_add_pd(force_k_z[0]);

            //Calculate non vectorized remainder
            for(;q < k_bound;q++)
            {
                    double diff[DIM];
                    diff[X] = pos[X][k] - pos[X][q];
                    diff[Y] = pos[Y][k] - pos[Y][q];
                    diff[Z] = pos[Z][k] - pos[Z][q];
                    double dist = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
                    double force_ij[DIM];
                    force_ij[X] = pre_calc*mass[q]*diff[X]/(dist*dist*dist);
                    force_ij[Y] = pre_calc*mass[q]*diff[Y]/(dist*dist*dist);
                    force_ij[Z] = pre_calc*mass[q]*diff[Z]/(dist*dist*dist);
                    force[X][k] += force_ij[X];
                    force[Y][k] += force_ij[Y];
                    force[Z][k] += force_ij[Z];
                    recv_force[X][q] -= force_ij[X];
                    recv_force[Y][q] -= force_ij[Y];
                    recv_force[Z][q] -= force_ij[Z];
            }
        }
    }
    LIKWID_MARKER_STOP("reduced-vectorized-AVX512-rsqrt");
    double t_end = omp_get_wtime();

    int mismatches = compare_forces(force, recv_force, force_ref, recv_force_ref, N, 0.0001,"AVX512-rsqrt");
    if(mismatches == 0)
        printf("x]: Performance: %fMpairs/s\n", double(num_force_pairs)/(1e6 * (t_end - t_start)));
    else
        printf("!]; Force mismatches; %d\n", mismatches);
    free(force[X]);
    free(force[Y]);
    free(force[Z]);
    free(recv_force[X]);
    free(recv_force[Y]);
    free(recv_force[Z]);
    return t_end - t_start;
}
