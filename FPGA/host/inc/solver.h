#ifndef SOLVER_H_
#define SOLVER_H_

#include "execution_data.h"

double solver(Execution_data* exec_data, 
            cl_double K, 
            cl_double* mass, 
            cl_double* coeff, 
            cl_double3* pos, 
            cl_double3* vel, 
            cl_double3* force, 
            size_t N, 
            size_t time_steps, 
            cl_double delta_t, 
            cl_double predicted_time); 
double lrb_solver(Execution_data* exec_data, 
            cl_double K, 
            cl_double* mass, 
            cl_double* coeff, 
            cl_double3* pos, 
            cl_double3* vel, 
            cl_double3* force, 
            size_t N, 
            size_t time_steps, 
            cl_double delta_t, 
            cl_double predicted_time); 
double lrb_solver_no_sync(Execution_data* exec_data, 
            cl_double K, 
            cl_double* mass, 
            cl_double* coeff, 
            cl_double3* pos, 
            cl_double3* vel, 
            cl_double3* force, 
            size_t N, 
            size_t time_steps, 
            cl_double delta_t, 
            cl_double predicted_time); 
double lrbd_solver_no_sync(Execution_data* exec_data, 
            cl_double K, 
            cl_double* mass, 
            cl_double* coeff, 
            cl_double3* pos, 
            cl_double3* vel, 
            cl_double3* force, 
            size_t N, 
            size_t time_steps, 
            cl_double delta_t, 
            cl_double predicted_time,
            std::string topology,
            cl_double* power_consumption); 
#endif
