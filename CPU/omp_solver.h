#ifndef OMP_SOLVER_H
#define OMP_SOLVER_H

#include "nbody_system.h"
#include <string>
#include <immintrin.h>

void compute_forces_avx2(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx2_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx512_rsqrt_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx512_rsqrt_4i_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_full_avx2(NBody_system& nb_sys, double*** local_force, double** local_pos, double* local_mass, __mmask8** sqrt_mask, size_t local_N, size_t rank, size_t comm_sz, size_t num_threads);
void reduced_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, bool blocked, Vectorization_type vect_type);
void full_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, Vectorization_type vect_type);
void reduced_solver_omp_lf(NBody_system& nb_sys, size_t time_steps, double delta_t, double* c, double* d, size_t lf_steps, bool blocked);
void reduced_solver_omp_rk(NBody_system& nb_sys, size_t time_steps, double delta_t, double* a, double* b, size_t rk_steps, bool blocked);
int omp_main(size_t N, size_t time_steps, double T, double ratio, Integration_kind size_t_kind,size_t size_t_order, Vectorization_type vect_type, Solver_type solver_type, bool verbose);
int omp_cache_benchmark(size_t start_N, size_t step_N, size_t num_steps, size_t time_steps, double T, double ratio, std::string output_file, bool verbose);
int omp_scaling_benchmark(size_t N, size_t time_steps, double T, double ratio, bool weak, std::string output_file, Vectorization_type vect_type, Solver_type solver_type, bool verbose);

#endif
