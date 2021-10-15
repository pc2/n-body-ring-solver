#ifndef OMP_SOLVER_H
#define OMP_SOLVER_H

#include "nbody_system.h"
#include <string>
#include <immintrin.h>


void reduced_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, bool blocked, Vectorization_type vect_type, Data_type data_type=Data_type::DOUBLE_PRECISION);
void full_solver_omp(NBody_system& nb_sys, size_t time_steps, double delta_t, Vectorization_type vect_type);
void reduced_solver_omp_lf(NBody_system& nb_sys, size_t time_steps, double delta_t, double* c, double* d, size_t lf_steps, bool blocked);
void reduced_solver_omp_rk(NBody_system& nb_sys, size_t time_steps, double delta_t, double* a, double* b, size_t rk_steps, bool blocked);
int omp_main(size_t N, size_t time_steps, double T, double ratio, Integration_kind size_t_kind,size_t size_t_order, Vectorization_type vect_type, Solver_type solver_type, bool verbose);
int omp_cache_benchmark(size_t start_N, size_t step_N, size_t num_steps, size_t time_steps, double T, double ratio, std::string output_file, bool verbose);
int omp_scaling_benchmark(size_t N, size_t time_steps, double T, double ratio, bool weak, std::string output_file, Vectorization_type vect_type, Solver_type solver_type, bool verbose);
int omp_accuracy(size_t start_N, size_t step_N, size_t num_steps, double T, double ratio_start, double ratio_stop, size_t ratio_steps, std::string output_path, Vectorization_type vect_type, Data_type data_type, bool verbose);
int omp_ratio_accuracy(size_t start_N, size_t step_N, size_t num_steps, size_t time_steps, double T, double ratio_start, double ratio_stop, size_t ratio_steps, size_t rev_steps, double max_error, std::string output_path, Vectorization_type vect_type, Data_type data_type, bool verbose);

#endif
