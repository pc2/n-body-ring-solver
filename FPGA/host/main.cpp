#include <stdio.h>
#include <random>
#include <cmath>
#include <stdlib.h>
#include <cstring>
#include <string>
#include <chrono>
#include <stdarg.h>
#include <algorithm>
#include <vector>
#include <unistd.h>
//#include "write_particles.h"
#include <mpi.h>
#include "CL/opencl.h"
#include "CL/cl_ext_intelfpga.h"
#include "AOCLUtils/aocl_utils.h"
#include "/opt/intelFPGA_pro/19.2.0/hld/board/custom_platform_toolkit/mmd/aocl_mmd.h"

#include "error.h"
#include "execution_data.h"
#include "solver.h"
#include "accuracy_evaluation.h"

void print_particles_contiguous(cl_double* mass, cl_double3* pos, cl_double3* vel, cl_double3* force, int N)
{
    printf("Particles in the System:\n");
    for(int i = 0;i < N;i++)
    {
        printf("Particle%d:\n",i);
        printf("Mass     = %f\n", mass[i]);
        printf("Position = [%.12f,%.12f]\n",pos[i].x,pos[i].y,pos[i].z);
        printf("Velocity = [%.12f,%.12f]\n",vel[i].x,vel[i].y,vel[i].z);
        printf("Force    = [%.12f,%.12f]\n\n",force[i].x,force[i].y,force[i].z);
    }
    fflush(stdout);
}

struct program_args
{
    size_t N;
    size_t start;
    size_t step;
    size_t num_steps;
    size_t warm_up;
    size_t time_steps;
    size_t eval_every;
    double num_revolutions;
    double T; 
    double f_max; 
    int CU; 
    int local_PE_dim;
    int remote_PE_dim;
    double ratio;
    double ratio_start;
    double ratio_stop;
    size_t ratio_steps;
    bool verbose; 
    bool debug; 
    std::string integration_kind;
    std::string solver_type; 
    int order;
    std::string suffix;
    std::string topology;
    std::string output_path;
    std::string mode;
};

void get_arguments(int argc, 
                   char** argv, 
                   program_args& args)
{
    int tmp_N = 2;
    int tmp_time_steps = 0;


    int tmp_start = 0;
    int tmp_step = 0;
    int tmp_num_steps = 0;
    int tmp_warm_up = 0;
    int tmp_eval_every = 0;
    int tmp_ratio_steps = 0;

    args.T = 1.0;
    args.num_revolutions = 1.0;
    args.verbose = false;
    args.debug = true;
    args.CU = 1;
    args.local_PE_dim = 1;
    args.remote_PE_dim = 1;
    args.f_max = 1.0;
    args.integration_kind.clear();
    args.topology = "ringN";
    args.solver_type = "full";
    args.output_path = "performance.csv";
    args.mode = "benchmark";
    args.order = 1;
    args.ratio_start = 1.0;
    args.ratio_stop = 1e6;
    args.ratio = 1e6;
    args.ratio_steps = 1;
    args.suffix = "";
    
    for(int i = 1; i<argc; i++)
    {
        if(strcmp(argv[i], "-N") == 0)
        {
            if(i+1 < argc)
            {
                tmp_N = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-s") == 0)
        {
            if(i+1 < argc)
            {
                tmp_time_steps = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-eval-every") == 0)
        {
            if(i+1 < argc)
            {
                tmp_eval_every = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-start") == 0)
        {
            if(i+1 < argc)
            {
                tmp_start = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-step") == 0)
        {
            if(i+1 < argc)
            {
                tmp_step = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-n") == 0)
        {
            if(i+1 < argc)
            {
                tmp_num_steps = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-warm-up") == 0)
        {
            if(i+1 < argc)
            {
                tmp_warm_up = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-T") == 0)
        {
            if(i+1 < argc)
            {
                args.T = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-CU") == 0)
        {
            if(i+1 < argc)
            {
                args.CU = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-LPE") == 0)
        {
            if(i+1 < argc)
            {
                args.local_PE_dim = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-RPE") == 0)
        {
            if(i+1 < argc)
            {
                args.remote_PE_dim = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-f_max") == 0)
        {
            if(i+1 < argc)
            {
                args.f_max = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio") == 0)
        {
            if(i+1 < argc)
            {
                args.ratio = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio-start") == 0)
        {
            if(i+1 < argc)
            {
                args.ratio_start = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio-stop") == 0)
        {
            if(i+1 < argc)
            {
                args.ratio_stop = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio-steps") == 0)
        {
            if(i+1 < argc)
            {
                tmp_ratio_steps = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-R") == 0)
        {
            if(i+1 < argc)
            {
                args.num_revolutions = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-v") == 0)
        {
            args.verbose = true;
        }
        else if(strcmp(argv[i], "-nd") == 0)
        {
            args.debug = false;
        }
        else if(strcmp(argv[i], "-i") == 0)
        {
            if(i+1 < argc)
            {
                args.integration_kind.clear();
                args.integration_kind.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-order") == 0)
        {
            if(i+1 < argc)
            {
                args.order = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-t") == 0)
        {
            if(i+1 < argc)
            {
                args.solver_type.clear();
                args.solver_type.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-suffix") == 0)
        {
            if(i+1 < argc)
            {
                args.suffix.clear();
                args.suffix.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-topology") == 0)
        {
            if(i+1 < argc)
            {
                args.topology.clear();
                args.topology.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-o") == 0)
        {
            if(i+1 < argc)
            {
                args.output_path.clear();
                args.output_path.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-m") == 0)
        {
            if(i+1 < argc)
            {
                args.mode.clear();
                args.mode.insert(0,argv[++i]);
            }
        }
    }

    if(tmp_N <= 0 || 
       tmp_time_steps < 0 || 
       tmp_start < 0 ||
       tmp_step < 0 ||
       tmp_num_steps < 0 ||
       tmp_warm_up < 0 ||
       tmp_eval_every < 0 ||
       args.T == 0.0 || 
       args.CU < 1 || 
       args.local_PE_dim < 1 ||
       args.remote_PE_dim < 1 ||
       args.f_max <= 0.0 || 
       args.order <= 0 || 
       args.ratio <= 0.0 ||
       tmp_ratio_steps < 0 ||
       args.ratio_start > args.ratio_stop || args.ratio_start <= 0.0 || args.ratio_stop <= 0.0 ||
       (args.solver_type != "full" && args.solver_type != "reduced" && args.solver_type != "lrb" && args.solver_type != "lrbd") ||
       (args.integration_kind != "" && args.integration_kind != "lf") ||
       (args.topology != "ringN" && args.topology != "ringO" && args.topology != "ringZ") ||
       (args.mode != "benchmark" && args.mode != "accuracy" && args.mode != "ratio-test") )
    {
        printf("Failed to read Arguments!\nResetting to defaults\n");
        tmp_N = 2;
        tmp_time_steps = 0;
        tmp_start = 0;
        tmp_step = 0;
        tmp_num_steps = 0;
        tmp_warm_up = 0;
        tmp_eval_every = 0;
        args.T = 1.0;
        args.CU = -1;
        args.local_PE_dim = -1;
        args.remote_PE_dim = -1;
        args.f_max = -1.0;
        args.ratio = 1e6;
        args.ratio_start = 1.0;
        args.ratio_stop = 1e6;
        tmp_ratio_steps = 0;
        args.verbose = false;
        args.debug = true;
        args.order = 1;
        args.solver_type = "full";
        args.integration_kind.clear();
        args.topology = "ringN";
        args.mode = "benchmark";
    }
    
    args.N = static_cast<size_t>(tmp_N);
    args.time_steps = static_cast<size_t>(tmp_time_steps);
    args.start = static_cast<size_t>(tmp_start);
    args.step = static_cast<size_t>(tmp_step);
    args.num_steps = static_cast<size_t>(tmp_num_steps);
    args.warm_up = static_cast<size_t>(tmp_warm_up);
    args.eval_every = static_cast<size_t>(tmp_eval_every);
    args.ratio_steps = static_cast<size_t>(tmp_ratio_steps);
}

double predict_time(size_t N, size_t time_steps, size_t K, size_t block_size, size_t CU, double f_max)
{
    size_t local_N = N/K;
    size_t num_blocks = std::ceil(double(N/K)/double(block_size*CU));
    size_t last_size = block_size;
    if(local_N - num_blocks * CU * block_size != 0)
        last_size = std::max((local_N - (num_blocks-1) * block_size * CU)/CU, size_t(40));
    size_t L_pl = CU * block_size;
    size_t L_wb = CU * block_size;
    size_t L_comp = 400;
    size_t L_int = local_N;
    double f_max_mega = f_max * 1e6;
    double T_pred = double((((block_size*N+L_comp)+L_pl+L_wb)*(num_blocks-1) + ((last_size*N+L_comp)+ L_pl + L_wb) +L_int)*time_steps)/f_max_mega;
    return T_pred;
}

void benchmark(program_args* args, Execution_data* exec_data, size_t rank, size_t comm_sz)
{
    while(args->N % (comm_sz*exec_data->num_devices) != 0)args->N++;
    if(args->num_steps == 0 || args->step == 0 || args->start == 0)
    {
        args->start = args->N;
        args->step = 0;
        args->num_steps = 1;
    }

    FILE* output_file = NULL;
    if(rank == 0)
    {
        bool file_exists = (access(args->output_path.c_str(), F_OK) != -1);
        if(file_exists)
        {
            output_file = fopen(args->output_path.c_str(), "a");
        }
        else
        {
            output_file = fopen(args->output_path.c_str(),"w");
            fprintf(output_file, "Nodes, dim, f_max, N, s, t_exec[s], P[Mpairs/s], Efficiency, time_steps/s, ms/time_step, Power[W], Energy Efficiency[Mpairs/s/W]\n");
        }
    }

    for(size_t n = 0;n < args->num_steps;n++)
    {
        size_t curr_N = args->start + n * args->step;
        size_t curr_time_steps = 0;
        size_t K = exec_data->comm_sz * exec_data->num_devices;
        double T_pred;
        double mpairs_max;
        double mpairs_pred;
        printf("curr_N: %d\n", curr_N);
        printf("#Warmup rounds: %lu\n", args->warm_up);
        printf("K : %d\n", comm_sz * K);
        if(exec_data->solver_type.find("lrb") != std::string::npos)
        {
            mpairs_max = double(K * 4 * args->local_PE_dim * args->remote_PE_dim) * args->f_max;
            if(curr_N < 4 * K * args->local_PE_dim * 2 * 16)
            {
                mpairs_pred = (mpairs_max * curr_N)/(4 * K * args->local_PE_dim * 2 * 16);
            }
            else 
            {
                mpairs_pred = mpairs_max;
            }
            if(args->time_steps == 0)
            {
                int tmp = int(args->T * mpairs_pred *1e6 / (curr_N * curr_N));
                if(tmp <= 0)
                {
                    printf("Requested Execution time T = %f would result in <= 0 timesteps. Setting timesteps to 1000\n", args->T);
                    curr_time_steps = 1000;
                }
                else
                {
                    curr_time_steps = size_t(tmp);
                    
                }
                
                printf("Using timesteps = %d to achieve approx. T = %fs execution time\n", curr_time_steps, args->T);
            }
            else
            {
                curr_time_steps = args->time_steps;
            }

            T_pred = double(curr_time_steps)*double(curr_N)*double(curr_N)/(mpairs_pred*1e6); //TODO
            printf("local_PE_dim: %d\n", args->local_PE_dim);
            printf("remote_PE_dim: %d\n", args->remote_PE_dim);
        }
        else
        {
            T_pred = predict_time(args->N, args->time_steps, K, 512, args->CU, args->f_max);
            mpairs_pred = double(curr_N)*double(curr_N)*double(curr_time_steps)/(1e6*T_pred);
            curr_time_steps = args->time_steps;
            mpairs_max = double(K * args->CU) * args->f_max;
            printf("CU: %d\n", args->CU);
            printf("block_size: %d\n", 512);
        }
        
        
        printf("f_max: %f\n", args->f_max);
        printf("Predicted Time: %f\n", T_pred);
        printf("Predicted mpairs/s: %f\n", mpairs_pred);
        printf("Max. mpairs/s: %f\n", mpairs_max);
        fflush(stdout);
        
        
        

        //omega: Used for initializing orbiting particles
        //delta_t: time_step
        double R = 1.0;
        double omega = (2.0 * M_PI) * args->num_revolutions;
        double delta_t = 1.0/curr_time_steps;
        
        double exec_times[args->warm_up+1];
        double performances[args->warm_up+1];
        double power_consumption[args->warm_up+1];

        cl_double* mass;
        cl_double* coeff;
        cl_double3* pos, *pos_ref;
        cl_double3* vel, *vel_ref;
        cl_double3* force, *force_ref;

        const cl_double scalar_factor = 1.0;//6.67384e-11;

        for(size_t w = 0;w < args->warm_up+1;w++)
        {
            
            if(rank == 0)
            {
                printf("\n\nWarm up round %lu\n",w);
                printf("Using ratio = %f\n",args->ratio);
                init_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega, args->ratio);
                //init_unstable_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega);
                pos_ref = new cl_double3[curr_N];
                vel_ref = new cl_double3[curr_N];
                force_ref = new cl_double3[curr_N];
                coeff = new cl_double[curr_N];
                memcpy(pos_ref, pos, curr_N*sizeof(cl_double3));
                memcpy(vel_ref, vel, curr_N*sizeof(cl_double3));
                memcpy(force_ref, force, curr_N*sizeof(cl_double3));
                memcpy(coeff, mass, curr_N*sizeof(cl_double));

                printf("Using solver : %s\n",exec_data->solver_type.c_str());
                double exec_time = 0.0;
                if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, &power_consumption[w]);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                    exec_time = lrbd_solver_sp(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, &power_consumption[w]);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, &power_consumption[w]);
                else if(exec_data->solver_type == "lrb")
                    exec_time = lrb_solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);

                double mpairs = double(exec_data->lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(exec_time * 1e6);
                double mpairs_pred = double(exec_data->lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(T_pred * 1e6);
                printf("Solver took %fs\n", exec_time);
                printf("Achieved mpairs/s: %f\n", mpairs);
                exec_times[w] = exec_time;
                performances[w] = mpairs;
                
                calculate_deviation(pos, pos_ref, "pos", curr_N, true, args->verbose);
                calculate_deviation(vel, vel_ref, "vel", curr_N, true, args->verbose);
                calculate_deviation(force,force_ref,"force",curr_N, false, args->verbose);
                delete_particles(mass, pos, vel, force);
                delete[] pos_ref;
                delete[] vel_ref;
                delete[] force_ref;
                delete[] coeff;
            }
            else
            {
                double exec_time;
                if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                    exec_time = lrbd_solver_sp(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrb")
                    exec_time = lrb_solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
            }
        }
        if(output_file != NULL && rank == 0)
        {
            double last_exec_time = exec_times[args->warm_up];
            double last_mpairs = performances[args->warm_up];
            double last_power_consumption = power_consumption[args->warm_up];
            if(last_exec_time != 0.0)
            {
                fprintf(output_file, "%d, %dx%d, %f, %d, %d, %f, %f, %f, %f, %f, %f, %f\n", comm_sz, exec_data->local_PE_dim, exec_data->remote_PE_dim, args->f_max,curr_N, curr_time_steps, last_exec_time, last_mpairs, last_mpairs/mpairs_max, curr_time_steps/last_exec_time, last_exec_time*1000.0/curr_time_steps, last_power_consumption, last_mpairs/last_power_consumption);
            }
            else
            {
                printf("Execution time measurement failed!\n");
            }
        }
    }
    if(output_file != NULL)
        fclose(output_file);
}

void accuracy(program_args* args, Execution_data* exec_data, size_t rank, size_t comm_sz)
{
    while(args->N % (comm_sz*exec_data->num_devices) != 0)args->N++;
    if(args->num_steps == 0 || args->step == 0 || args->start == 0)
    {
        args->start = args->N;
        args->step = 0;
        args->num_steps = 1;
    }

    while(args->eval_every != 0 && args->time_steps % args->eval_every != 0)args->time_steps++;
    if(args->eval_every == 0)args->eval_every = args->time_steps;
    size_t num_evals = args->time_steps / args->eval_every;

    FILE* output_file = NULL;
    if(rank == 0)
    {
        bool file_exists = (access(args->output_path.c_str(), F_OK) != -1);
        if(file_exists)
        {
            output_file = fopen(args->output_path.c_str(), "a");
        }
        else
        {
            output_file = fopen(args->output_path.c_str(),"w");
            fprintf(output_file, "Nodes, dim, f_max, N, s, revs, T, U, E, E_dev, I'', pos_dev, vel_dev\n");
        }
    }

    

    for(size_t n = 0;n < args->num_steps;n++)
    {
        size_t curr_N = args->start + n * args->step;

        cl_double* mass;
        cl_double* coeff;
        cl_double3* pos, *pos_ref, *pos_cpy;
        cl_double3* vel, *vel_ref, *vel_cpy;
        cl_double3* force, *force_ref;

        const cl_double scalar_factor = 1.0;//6.67384e-11;
        //omega: Used for initializing orbiting particles
        //delta_t: time_step
        double R = 1.0;
        double omega = (2.0 * M_PI) * args->num_revolutions;
        double delta_t = 1.0/args->time_steps;


        init_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega, args->ratio);

        pos_ref = new cl_double3[curr_N];
        vel_ref = new cl_double3[curr_N];
        force_ref = new cl_double3[curr_N];
        coeff = new cl_double[curr_N];
        memcpy(coeff, mass, curr_N*sizeof(cl_double));

        pos_cpy = new cl_double3[curr_N];
        vel_cpy = new cl_double3[curr_N];
        memcpy(pos_cpy, pos, curr_N*sizeof(cl_double3));
        memcpy(vel_cpy, vel, curr_N*sizeof(cl_double3));

        double T0 = calculate_kinetic_energy(mass, vel, curr_N);
        double U0 = calculate_potential_energy(scalar_factor, mass, pos, curr_N);
        double I0 = calculate_inertia(mass, pos, curr_N);
        double E0 = T0 + U0;
        printf("########Initial system condition########\n");
        printf("System size N = %d\n",curr_N);
        printf("T0 = %f\n", T0);
        printf("U0 = %f\n", U0);
        printf("E0 = %f\n", E0);
        printf("I0 = %f\n", I0);
        printf("I0'' = %f\n", 4*T0 + 2*U0);
        printf("Number of system revolutions to simulate: %f\n", args->num_revolutions);

        for(size_t eval = 0; eval < num_evals;eval++)
        {
            size_t curr_time_steps = (eval+1)*args->eval_every;
            size_t K = exec_data->comm_sz * exec_data->num_devices;
            printf("\n########Solver Info########\n");
            printf("K : %d\n", comm_sz * K);
            if(exec_data->solver_type.find("lrb") != std::string::npos)
            {
                printf("local_PE_dim: %d\n", args->local_PE_dim);
                printf("remote_PE_dim: %d\n", args->remote_PE_dim);
            }
            else
            {
                printf("CU: %d\n", args->CU);
                printf("block_size: %d\n", 512);
            }
            printf("f_max: %f\n", args->f_max);
            fflush(stdout);
            


            double T_pred = 1.0;

            double avg_pos_dev = 0.0;
            double avg_vel_dev = 0.0;
            double T = 0.0;
            double U = 0.0;
            double I = 0.0;
            double E = 0.0;    
            if(rank == 0)
            {

                memcpy(pos, pos_cpy, curr_N*sizeof(cl_double3));
                memcpy(vel, vel_cpy, curr_N*sizeof(cl_double3));

                printf("Using solver : %s\n",exec_data->solver_type.c_str());
                double exec_time = 0.0;
                if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                    exec_time = lrbd_solver_sp(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrb")
                    exec_time = lrb_solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);

                double mpairs = double(exec_data->lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(exec_time * 1e6);
                printf("Solver took %fs\n", exec_time);
                
                predict_orbiting_particles(pos_ref, vel_ref, curr_N, R, omega, curr_time_steps, args->time_steps, args->num_revolutions);
                //print_particles_contiguous(mass, pos_ref, vel_ref, force, curr_N);



                T = calculate_kinetic_energy(mass, vel, curr_N);
                U = calculate_potential_energy(scalar_factor, mass, pos, curr_N);
                E = T + U;
                I = calculate_inertia(mass, pos, curr_N);

                printf("\n########System condition after %d timesteps########\n", curr_time_steps);

                avg_pos_dev = calculate_deviation(pos, pos_ref, "pos", curr_N, true, args->verbose);
                avg_vel_dev = calculate_deviation(vel, vel_ref, "vel", curr_N, true, args->verbose);

                printf("T = %f\n", T);
                printf("U = %f\n", U);
                printf("E = %f\n", T+U);
                printf("I = %f\n", I);
                printf("I'' = %f\n", 4*T + 2*U);
                
            }
            else
            {
                double exec_time;
                if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                    exec_time = lrbd_solver_sp(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                else if(exec_data->solver_type == "lrb")
                    exec_time = lrb_solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
            }

            if(output_file != NULL && rank == 0)
            {
                fprintf(output_file, "%d, %dx%d, %f, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f\n", comm_sz, exec_data->local_PE_dim, exec_data->remote_PE_dim, args->f_max,curr_N, curr_time_steps, args->ratio, args->num_revolutions, T, U, E, abs(E-E0)/E0, 4*T+2*U, avg_pos_dev, avg_vel_dev);
            }
        }
        delete[] pos_ref;
        delete[] vel_ref;
        delete[] force_ref;
        delete[] coeff;
        delete[] pos_cpy;
        delete[] vel_cpy;
        delete_particles(mass, pos, vel, force);

        printf("\n\n--------------------------------------------\n--------------------------------------------\n\n\n");
    }
    if(output_file != NULL)
        fclose(output_file);
}

void ratio_test(program_args* args, Execution_data* exec_data, size_t rank, size_t comm_sz)
{
    while(args->N % (comm_sz*exec_data->num_devices) != 0)args->N++;
    if(args->num_steps == 0 || args->step == 0 || args->start == 0)
    {
        args->start = args->N;
        args->step = 0;
        args->num_steps = 1;
    }

    FILE* output_file = NULL;
    if(rank == 0)
    {
        bool file_exists = (access(args->output_path.c_str(), F_OK) != -1);
        if(file_exists)
        {
            output_file = fopen(args->output_path.c_str(), "a");
        }
        else
        {
            output_file = fopen(args->output_path.c_str(),"w");
            fprintf(output_file, "Nodes, dim, f_max, precision, N, s, ratio, s_collapse,revs, T, U, E, E_dev, I'', pos_dev, vel_dev\n");
        }
    }


    for(size_t n = 0;n < args->num_steps;n++)
    {
        size_t curr_N = args->start + n * args->step;

        cl_double* mass;
        cl_double* coeff;
        cl_double3* pos, *pos_ref, *pos_cpy;
        cl_double3* vel, *vel_ref, *vel_cpy;
        cl_double3* force, *force_ref;

        const cl_double scalar_factor = 1.0;//6.67384e-11;
        //omega: Used for initializing orbiting particles
        //delta_t: time_step
        double R = 1.0;
        double omega = (2.0 * M_PI) * args->num_revolutions;
        double delta_t = 1.0/args->time_steps;

        double ratio_root = std::pow(args->ratio_stop/args->ratio_start, 1.0/double(args->ratio_steps));
        printf("ratio_root: %f, ratio_start: %f\n", ratio_root, args->ratio_start);
        for(size_t ratio_step = 0;ratio_step <= args->ratio_steps;ratio_step++)
        {
            double curr_ratio = args->ratio_start * std::pow(ratio_root, ratio_step);
            init_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega, curr_ratio);

            pos_ref = new cl_double3[curr_N];
            vel_ref = new cl_double3[curr_N];
            force_ref = new cl_double3[curr_N];
            coeff = new cl_double[curr_N];
            memcpy(coeff, mass, curr_N*sizeof(cl_double));

            pos_cpy = new cl_double3[curr_N];
            vel_cpy = new cl_double3[curr_N];
            memcpy(pos_cpy, pos, curr_N*sizeof(cl_double3));
            memcpy(vel_cpy, vel, curr_N*sizeof(cl_double3));

            double T0 = calculate_kinetic_energy(mass, vel, curr_N);
            double U0 = calculate_potential_energy(scalar_factor, mass, pos, curr_N);
            double I0 = calculate_inertia(mass, pos, curr_N);
            double E0 = T0 + U0;
            printf("########Initial system condition########\n");
            printf("System size N = %d\n",curr_N);
            printf("Mass ratio: %f\n", curr_ratio);
            printf("T0 = %f\n", T0);
            printf("U0 = %f\n", U0);
            printf("E0 = %f\n", E0);
            printf("I0 = %f\n", I0);
            printf("I0'' = %f\n", 4*T0 + 2*U0);
            printf("Number of system revolutions to simulate: %f\n", args->num_revolutions);

            double E_dev_sol = 0.0;
            double avg_pos_dev_sol = 0.0;
            double avg_vel_dev_sol = 0.0;

            size_t lower_time_steps = 0;
            size_t upper_time_steps = args->time_steps;
            size_t curr_time_steps = upper_time_steps/2;
            while(upper_time_steps - lower_time_steps > 1)
            {
                printf("curr: %d\n", curr_time_steps);

                size_t K = exec_data->comm_sz * exec_data->num_devices;
                printf("\n########Solver Info########\n");
                printf("K : %d\n", comm_sz * K);
                if(exec_data->solver_type.find("lrb") != std::string::npos)
                {
                    printf("local_PE_dim: %d\n", args->local_PE_dim);
                    printf("remote_PE_dim: %d\n", args->remote_PE_dim);
                }
                else
                {
                    printf("CU: %d\n", args->CU);
                    printf("block_size: %d\n", 512);
                }
                printf("f_max: %f\n", args->f_max);
                fflush(stdout);
                


                double T_pred = 1.0;

                double avg_pos_dev = 0.0;
                double avg_vel_dev = 0.0;
                double T = 0.0;
                double U = 0.0;
                double I = 0.0;
                double E = 0.0;    
                if(rank == 0)
                {

                    memcpy(pos, pos_cpy, curr_N*sizeof(cl_double3));
                    memcpy(vel, vel_cpy, curr_N*sizeof(cl_double3));

                    printf("Using solver : %s\n",exec_data->solver_type.c_str());
                    double exec_time = 0.0;
                    if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                        exec_time = lrb_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                        exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                        exec_time = lrbd_solver_sp(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                        exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrb")
                        exec_time = lrb_solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                    else
                        exec_time = solver(exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);

                    double mpairs = double(exec_data->lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(exec_time * 1e6);
                    printf("Solver took %fs\n", exec_time);
                    
                    predict_orbiting_particles(pos_ref, vel_ref, curr_N, R, omega, curr_time_steps, args->time_steps, args->num_revolutions);
                    //print_particles_contiguous(mass, pos_ref, vel_ref, force, curr_N);



                    T = calculate_kinetic_energy(mass, vel, curr_N);
                    U = calculate_potential_energy(scalar_factor, mass, pos, curr_N);
                    E = T + U;
                    I = calculate_inertia(mass, pos, curr_N);

                    printf("\n########System condition after %d timesteps########\n", curr_time_steps);

                    avg_pos_dev = calculate_deviation(pos, pos_ref, "pos", curr_N, true, args->verbose);
                    avg_vel_dev = calculate_deviation(vel, vel_ref, "vel", curr_N, true, args->verbose);

                    printf("T = %f\n", T);
                    printf("U = %f\n", U);
                    printf("I = %f\n", I);
                    printf("I'' = %f\n", 4*T + 2*U);
                    printf("E = %f\n", T+U);
                    
                }
                else
                {
                    double exec_time;
                    if(exec_data->solver_type == "lrb" && exec_data->suffix.find("_no_sync") != std::string::npos)
                        exec_time = lrb_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_no_sync") != std::string::npos)
                        exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_sp") != std::string::npos)
                        exec_time = lrbd_solver_sp(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrbd" && exec_data->suffix.find("_hybrid") != std::string::npos)
                        exec_time = lrbd_solver_no_sync(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, args->topology, nullptr);
                    else if(exec_data->solver_type == "lrb")
                        exec_time = lrb_solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                    else
                        exec_time = solver(exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                }

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
            }
            curr_time_steps = lower_time_steps;
            printf("true solution = %d\n", curr_time_steps);
            double avg_pos_dev = calculate_deviation(pos, pos_ref, "pos", curr_N, true, args->verbose);
            double avg_vel_dev = calculate_deviation(vel, vel_ref, "vel", curr_N, true, args->verbose);
            double T = calculate_kinetic_energy(mass, vel, curr_N);
            double U = calculate_potential_energy(scalar_factor, mass, pos, curr_N);
            double E = T + U;
            double I = calculate_inertia(mass, pos, curr_N);
            if(output_file != NULL && rank == 0)
            {
                std::string precision;
                if(exec_data->suffix.find("_no_sync") != std::string::npos)
                    precision = "dp";
                else if(exec_data->suffix.find("_sp") != std::string::npos)
                    precision = "sp";
                else if(exec_data->suffix.find("_hybrid") != std::string::npos)
                    precision = "mp";
                fprintf(output_file, "%d, %dx%d, %f, %s, %d, %d, %d %f, %f, %f, %f, %f\n", comm_sz, exec_data->local_PE_dim, exec_data->remote_PE_dim, args->f_max,precision.c_str(),curr_N, args->time_steps, curr_time_steps, curr_ratio, args->num_revolutions, E_dev_sol, avg_pos_dev_sol, avg_vel_dev_sol);
            }
        }
        

        delete[] pos_ref;
        delete[] vel_ref;
        delete[] force_ref;
        delete[] coeff;
        delete[] pos_cpy;
        delete[] vel_cpy;
        delete_particles(mass, pos, vel, force);

        printf("\n\n--------------------------------------------\n--------------------------------------------\n\n\n");
    }
    if(output_file != NULL)
        fclose(output_file);
}


int main(int argc, char** argv)
{

    int comm_sz;
    int rank;
    int error;
    error = MPI_Init(NULL,NULL);
    if( error != MPI_SUCCESS)printf("Init failed\n");
    error = MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);
    if( error != MPI_SUCCESS)printf("comm size failed\n");
    error = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if( error != MPI_SUCCESS)printf("rank failed\n");
     
    //N: Number of Particles in the system
    //T: Total simulation Time
    //verbose: Enable Verbose Printing for Debug
    program_args args;
    get_arguments(argc, 
                  argv, 
                  args);

    Execution_data exec_data(rank, comm_sz, args.CU, args.local_PE_dim, args.remote_PE_dim, args.integration_kind, args.order, args.solver_type, args.debug, args.suffix);
    exec_data.init(); 

    if(!exec_data.is_emulation && (args.CU == -1 || args.f_max == -1 || args.local_PE_dim == -1 || args.remote_PE_dim == -1))
    {
        printf("CU, local_PE_dim, remote_PE_dim or f_max not specified!\n");
        return -1;
    }

    if(args.mode == "benchmark")
    {
        benchmark(&args, &exec_data, rank, comm_sz);
    }
    else if(args.mode == "accuracy")
    {
        accuracy(&args, &exec_data, rank, comm_sz);
    }
    else if(args.mode == "ratio-test")
    {
        ratio_test(&args, &exec_data, rank, comm_sz);
    }
            
    MPI_Finalize();
    return 0;
}