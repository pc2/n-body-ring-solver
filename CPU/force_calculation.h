#ifndef FORCE_CALCULATION_H
#define FORCE_CALCULATION_H

#include "nbody_system.h"
#include <immintrin.h>

void compute_forces_simple(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx2(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx2_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx2_sp(NBody_system& nb_sys, float* recv_pos[DIM], float* recv_force[DIM], float*** local_force, float*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx2_blocked_sp(NBody_system& nb_sys, float* recv_pos[DIM], float* recv_force[DIM], float*** local_force, float*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx512_rsqrt_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_avx512_rsqrt_4i_blocked(NBody_system& nb_sys, double* recv_pos[DIM], double* recv_force[DIM], double*** local_force, double*** local_recv_force, size_t local_N, size_t rank, size_t comm_sz, size_t recv_round, size_t num_threads);
void compute_forces_full_avx2(NBody_system& nb_sys, double*** local_force, double** local_pos, double* local_mass, __mmask8** sqrt_mask, size_t local_N, size_t rank, size_t comm_sz, size_t num_threads);

double compute_kinetic_energy(NBody_system& nb_sys);
double compute_potential_energy_avx2(NBody_system& nb_sys);
double compute_potential_energy_avx2_sp(NBody_system& nb_sys);
double compute_inertia(NBody_system& nb_sys);


#endif