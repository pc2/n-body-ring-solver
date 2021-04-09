#ifndef MPI_SOLVER_H
#define MPI_SOLVER_H

#include "nbody_system.h"

void ring_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t time_steps, double delta_t);
void compute_positions_ring(NBody_system& nb_sys, double* send_msg, double* recv_msg, size_t local_N, size_t rank, size_t comm_sz, double delta_t);

int mpi_bandwidth_benchmark(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, bool verbose);
#endif
