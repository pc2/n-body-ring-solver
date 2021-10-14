#ifndef ACCURACY_EVALUATION_H_
#define ACCURACY_EVALUATION_H_

#include "CL/opencl.h"

double calculate_kinetic_energy(cl_double* mass, cl_double3* vel, size_t N);
double calculate_potential_energy(cl_double G, cl_double* mass, cl_double3* pos, size_t N);
double calculate_inertia(cl_double* mass, cl_double3* pos, size_t N);
double calculate_deviation(cl_double3* calc, cl_double3* ref, const char* data_kind, size_t N, bool absolute, bool verbose);
void init_orbiting_particles(cl_double K, cl_double** mass,cl_double3** pos, cl_double3** vel, cl_double3** force,  int N, double R, double omega, double ratio=1e6);
void predict_orbiting_particles(cl_double3* pos, cl_double3* vel, int N, double R, double omega, size_t curr_time_step, size_t total_time_steps, double num_revolutions);
void init_unstable_orbiting_particles(cl_double K, cl_double** mass,cl_double3** pos, cl_double3** vel, cl_double3** force,  int N, double R, double omega);
void delete_particles(double* mass, cl_double3* pos, cl_double3* vel, cl_double3* force);

#endif