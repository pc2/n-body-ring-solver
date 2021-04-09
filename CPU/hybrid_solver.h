#ifndef HYBRID_SOLVER_H_
#define HYBRID_SOLVER_H_

#include "nbody_system.h"

void hybrid_ring_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t num_threads, size_t time_steps, double delta_t, Vectorization_type vect_type);
void hybrid_full_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t num_threads, size_t time_steps, double delta_t, Vectorization_type vect_type);
int hybrid_main(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, Vectorization_type vect_type, Solver_type solver_type, bool verbose);
int hybrid_scaling_benchmark(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, bool weak, std::string output_path, Vectorization_type vect_type, Solver_type solver_type, bool verbose);

#endif
