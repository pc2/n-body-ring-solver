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

void print_deviation(cl_double3* calc, cl_double3* ref, const char* data_kind, size_t N, bool absolute, bool verbose)
{
    double largest_dev = 0.0;
    size_t largest_dev_index = 0; 
    cl_double diff_mean = 0.0;
    for(size_t i = 0; i < N; i++)
    {
        cl_double3 diff;
        diff.x = calc[i].x - ref[i].x;
        diff.y = calc[i].y - ref[i].y;
        diff.z = calc[i].z - ref[i].z;
        cl_double dist = 0.0;
        if(absolute)
            dist = std::sqrt(diff.x*diff.x + diff.y*diff.y + diff.z*diff.z);
        else
            dist= std::sqrt(diff.x*diff.x + diff.y*diff.y + diff.z*diff.z)/std::sqrt(ref[i].x*ref[i].x + ref[i].y*ref[i].y + ref[i].z*ref[i].z);
        diff_mean += dist;
        if(largest_dev < dist)
        {
            largest_dev = dist;
            largest_dev_index = i;
            if(verbose)printf("Found new dev at %zu: %f\n", i, dist);
        }

        if(verbose)
        {   
            printf("calc_%s[%zu]=[%f,%f,%f]\n", data_kind, i, calc[i].x, calc[i].y, calc[i].z);
            printf("ref_%s[%zu] =[%f,%f,%f]\n", data_kind, i, ref[i].x, ref[i].y, ref[i].z);
            printf("%s_diff[%zu] =[%f,%f,%f]\n\n", data_kind, i, diff.x, diff.y, diff.z);
        }
    }
    diff_mean/=N;

    if(verbose)
    {
        size_t i = largest_dev_index;
        printf("Largest deviation:\n");
        printf("calc_%s[%zu]=[%f,%f,%f]\n", data_kind, i, calc[i].x, calc[i].y, calc[i].z);
        printf("ref_%s[%zu] =[%f,%f,%f]\n", data_kind, i, ref[i].x, ref[i].y, ref[i].z);
        printf("%s_diff[%zu] =[%f,%f,%f]\n\n", data_kind, i, calc[i].x - ref[i].x, calc[i].y - ref[i].y, calc[i].z - ref[i].z);
    }

    if(absolute)
        printf("Average %s deviation from reference: %.13f\n", data_kind, diff_mean);
    else
        printf("Average %s relative error from reference: %e\n", data_kind, diff_mean);
}

void init_orbiting_particles(cl_double K, cl_double** mass,cl_double3** pos, cl_double3** vel, cl_double3** force,  int N, double R, double omega, double ratio=1e6)
{   
    *mass = new cl_double[N];
    *pos = new cl_double3[N];
    *vel = new cl_double3[N];
    *force = new cl_double3[N];

    N -= 1;

    for(int i = 0;i < N; i++)
    {
        (*pos)[i].x =  R * std::cos( i * 2 * M_PI / N);
        (*pos)[i].y =  R * std::sin( i * 2 * M_PI / N);
        (*pos)[i].z =  0.0;
        (*vel)[i].x = -R * omega * std::sin( i * 2 * M_PI / N);
        (*vel)[i].y =  R * omega * std::cos( i * 2 * M_PI / N);
        (*vel)[i].z =  0.0;
        (*force)[i].x = 0.0;
        (*force)[i].y = 0.0;
        (*force)[i].z = 0.0;
    }

    double total_mass = R*R*R * omega * omega / K;
    double sum = 0.0;
    for(int i = 1;i <= (N-1)/2;i++)
    {
        sum += (2.0 + 2.0 * std::cos(( M_PI * (N - 2*i))/N)) / std::pow(2.0 - 2.0 * std::cos(i * 2 * M_PI / N), 3.0/2.0);
    }
    if(N % 2 == 0)
        sum += 1.0/4.0;

    printf("sum = %f\n", sum);
    ratio = 99*sum;
    sum += ratio;
    total_mass /= sum;
    for(int i = 0; i < N; i++)
        (*mass)[i] = total_mass;
    (*mass)[N] = total_mass * ratio;
    (*pos)[N].x = 0.0;
    (*pos)[N].y = 0.0;
    (*pos)[N].z = 0.0;
    (*vel)[N].x = 0.0; 
    (*vel)[N].y = 0.0; 
    (*vel)[N].z = 0.0;
    (*force)[N].x = 0.0;
    (*force)[N].y = 0.0;
    (*force)[N].z = 0.0;
}

void init_unstable_orbiting_particles(cl_double K, cl_double** mass,cl_double3** pos, cl_double3** vel, cl_double3** force,  int N, double R, double omega)
{   
    *mass = new cl_double[N];
    *pos = new cl_double3[N];
    *vel = new cl_double3[N];
    *force = new cl_double3[N];

    for(int i = 0;i < N; i++)
    {
        (*pos)[i].x =  R * std::cos( i * 2 * M_PI / N);
        (*pos)[i].y =  R * std::sin( i * 2 * M_PI / N);
        (*pos)[i].z =  0.0;
        (*vel)[i].x = -R * omega * std::sin( i * 2 * M_PI / N);
        (*vel)[i].y =  R * omega * std::cos( i * 2 * M_PI / N);
        (*vel)[i].z =  0.0;
    }

    double total_mass = R*R*R * omega * omega / K;
    double sum = 0.0;
    for(int i = 1;i <= (N-1)/2;i++)
    {
        sum += (2.0 + 2.0 * std::cos(( M_PI * (N - 2*i))/N)) / std::pow(2.0 - 2.0 * std::cos(i * 2 * M_PI / N), 3.0/2.0);
    }
    if(N % 2 == 0)
        sum += 1.0/4.0;
    total_mass /= sum;
    for(int i = 0; i < N; i++)
    {
        (*mass)[i] = total_mass;
        (*force)[i].x = -( (*mass)[i] * omega * omega * (*pos)[i].x);
        (*force)[i].y = -( (*mass)[i] * omega * omega * (*pos)[i].y);
        (*force)[i].z = 0.0;
    }
}

void delete_particles(double* mass, cl_double3* pos, cl_double3* vel, cl_double3* force)
{
    if(mass)delete[] mass;
    if(pos)delete[] pos;
    if(vel)delete[] vel;
    if(force)delete[] force;
}

void get_arguments(int argc, 
                   char** argv, 
                   size_t* N, 
                   size_t* start_N,
                   size_t* step_N,
                   size_t* num_steps,
                   size_t* warm_up,
                   size_t* time_steps,
                   double* T, 
                   double* f_max, 
                   int* CU, 
                   int* local_PE_dim,
                   int* remote_PE_dim,
                   double* ratio,
                   bool* verbose, 
                   bool* debug, 
                   std::string& integration_kind,
                   std::string& solver_type, 
                   int* order,
                   std::string& suffix,
                   std::string& topology,
                   std::string& output_path)
{
    int tmp_N = 2;
    int tmp_time_steps = 0;


    int tmp_start_N = 0;
    int tmp_step_N = 0;
    int tmp_num_steps = 0;
    int tmp_warm_up = 0;

    *T = 1.0;
    *verbose = false;
    *debug = true;
    *CU = 1;
    *local_PE_dim = 1;
    *remote_PE_dim = 1;
    *f_max = 1.0;
    integration_kind.clear();
    topology = "ringN";
    solver_type = "full";
    output_path = "performance.csv";
    *order = 1;
    *ratio = 1e6;
    suffix = "";
    
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
        else if(strcmp(argv[i], "-start") == 0)
        {
            if(i+1 < argc)
            {
                tmp_start_N = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-step") == 0)
        {
            if(i+1 < argc)
            {
                tmp_step_N = atoi(argv[++i]);
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
                *T = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-CU") == 0)
        {
            if(i+1 < argc)
            {
                *CU = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-LPE") == 0)
        {
            if(i+1 < argc)
            {
                *local_PE_dim = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-RPE") == 0)
        {
            if(i+1 < argc)
            {
                *remote_PE_dim = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-f_max") == 0)
        {
            if(i+1 < argc)
            {
                *f_max = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio") == 0)
        {
            if(i+1 < argc)
            {
                *ratio = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-v") == 0)
        {
            *verbose = true;
        }
        else if(strcmp(argv[i], "-nd") == 0)
        {
            *debug = false;
        }
        else if(strcmp(argv[i], "-i") == 0)
        {
            if(i+1 < argc)
            {
                integration_kind.clear();
                integration_kind.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-order") == 0)
        {
            if(i+1 < argc)
            {
                *order = atoi(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-t") == 0)
        {
            if(i+1 < argc)
            {
                solver_type.clear();
                solver_type.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-suffix") == 0)
        {
            if(i+1 < argc)
            {
                suffix.clear();
                suffix.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-topology") == 0)
        {
            if(i+1 < argc)
            {
                topology.clear();
                topology.insert(0,argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-o") == 0)
        {
            if(i+1 < argc)
            {
                output_path.clear();
                output_path.insert(0,argv[++i]);
            }
        }
    }

    if(tmp_N <= 0 || 
       tmp_time_steps < 0 || 
       tmp_start_N < 0 ||
       tmp_step_N < 0 ||
       tmp_num_steps < 0 ||
       tmp_warm_up < 0 ||
       *T == 0.0 || 
       *CU < 1 || 
       *local_PE_dim < 1 ||
       *remote_PE_dim < 1 ||
       *f_max <= 0.0 || 
       *order <= 0 || 
       *ratio <= 0.0 ||
       (solver_type != "full" && solver_type != "reduced" && solver_type != "lrb" && solver_type != "lrbd") ||
       (integration_kind != "" && integration_kind != "lf") ||
       (topology != "ringN" && topology != "ringO" && topology != "ringZ"))
    {
        printf("Failed to read Arguments!\nResetting to defaults\n");
        tmp_N = 2;
        tmp_time_steps = 0;
        tmp_start_N = 0;
        tmp_step_N = 0;
        tmp_num_steps = 0;
        tmp_warm_up = 0;
        *T = 1.0;
        *CU = -1;
        *local_PE_dim = -1;
        *remote_PE_dim = -1;
        *f_max = -1.0;
        *ratio = 1e6;
        *verbose = false;
        *debug = true;
        *order = 1;
        solver_type = "full";
        integration_kind.clear();
        topology = "ringN";
    }
    
    *N = static_cast<size_t>(tmp_N);
    *time_steps = static_cast<size_t>(tmp_time_steps);
    *start_N = static_cast<size_t>(tmp_start_N);
    *step_N = static_cast<size_t>(tmp_step_N);
    *num_steps = static_cast<size_t>(tmp_num_steps);
    *warm_up = static_cast<size_t>(tmp_warm_up);
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
    size_t N;
    size_t start_N;
    size_t step_N;
    size_t num_steps;
    size_t warm_up;
    int CU;
    int local_PE_dim;
    int remote_PE_dim;
    size_t time_steps;
    double T;
    double f_max;
    double ratio;
    bool verbose;
    bool debug;
    std::string integration_kind;
    std::string solver_type;
    int order;
    std::string suffix;
    std::string topology;
    std::string output_path;
    get_arguments(argc, argv, &N, &start_N, &step_N, &num_steps, &warm_up, &time_steps, &T, &f_max, &CU, &local_PE_dim, &remote_PE_dim, &ratio, &verbose, &debug, integration_kind, solver_type, &order, suffix, topology, output_path);

    Execution_data exec_data(rank, comm_sz, CU, local_PE_dim, remote_PE_dim, integration_kind, order, solver_type, debug, suffix);
    exec_data.init(); 

    if(!exec_data.is_emulation && (CU == -1 || f_max == -1 || local_PE_dim == -1 || remote_PE_dim == -1))
    {
        printf("CU, local_PE_dim, remote_PE_dim or f_max not specified!\n");
        return -1;
    }

    cl_double* mass;
    cl_double* coeff;
    cl_double3* pos, *pos_ref;
    cl_double3* vel, *vel_ref;
    cl_double3* force, *force_ref;

    const cl_double scalar_factor = 1.0;//6.67384e-11;
    
    while(N % (comm_sz*exec_data.num_devices) != 0)N++;

    FILE* output_file = NULL;
    if(num_steps == 0 || step_N == 0 || start_N == 0)
    {
        
        start_N = N;
        step_N = 0;
        num_steps = 1;
        
    }

    if(rank == 0)
    {
        bool file_exists = (access(output_path.c_str(), F_OK) != -1);
        if(file_exists)
        {
            output_file = fopen(output_path.c_str(), "a");
        }
        else
        {
            output_file = fopen(output_path.c_str(),"w");
            fprintf(output_file, "Nodes, dim, f_max, N, s, t_exec[s], P[Mpairs/s], Efficiency, time_steps/s, ms/time_step, Power[W], Energy Efficiency[Mpairs/s/W]\n");
        }
    }

    for(size_t n = 0;n < num_steps;n++)
    {
        size_t curr_N = start_N + n * step_N;
        size_t curr_time_steps = 0;
        size_t K = exec_data.comm_sz * exec_data.num_devices;
        double T_pred;
        double mpairs_max;
        double mpairs_pred;
        printf("curr_N: %d\n", curr_N);
        printf("#Warmup rounds: %lu\n", warm_up);
        printf("K : %d\n", comm_sz * K);
        if(exec_data.solver_type.find("lrb") != std::string::npos)
        {
            mpairs_max = double(K * 4 * local_PE_dim * remote_PE_dim) * f_max;
            if(curr_N < 4 * K * local_PE_dim * 2 * 16)
            {
                mpairs_pred = (mpairs_max * curr_N)/(4 * K * local_PE_dim * 2 * 16);
            }
            else 
            {
                mpairs_pred = mpairs_max;
            }
            if(time_steps == 0)
            {
                int tmp = int(T * mpairs_pred *1e6 / (curr_N * curr_N));
                if(tmp <= 0)
                {
                    printf("Requested Execution time T = %f would result in <= 0 timesteps. Setting timesteps to 1000\n", T);
                    curr_time_steps = 1000;
                }
                else
                {
                    curr_time_steps = size_t(tmp);
                    
                }
                
                printf("Using timesteps = %d to achieve approx. T = %fs execution time\n", curr_time_steps, T);
            }
            else
            {
                curr_time_steps = time_steps;
            }

            T_pred = double(curr_time_steps)*double(curr_N)*double(curr_N)/(mpairs_pred*1e6); //TODO
            printf("local_PE_dim: %d\n", local_PE_dim);
            printf("remote_PE_dim: %d\n", remote_PE_dim);
        }
        else
        {
            T_pred = predict_time(N, time_steps, K, 512, CU, f_max);
            mpairs_pred = double(curr_N)*double(curr_N)*double(curr_time_steps)/(1e6*T_pred);
            curr_time_steps = time_steps;
            mpairs_max = double(K * CU) * f_max;
            printf("CU: %d\n", CU);
            printf("block_size: %d\n", 512);
        }
        
        
        printf("f_max: %f\n", f_max);
        printf("Predicted Time: %f\n", T_pred);
        printf("Predicted mpairs/s: %f\n", mpairs_pred);
        printf("Max. mpairs/s: %f\n", mpairs_max);
        fflush(stdout);
        
        
        

        //omega: Used for initializing orbiting particles
        //delta_t: time_step
        double R = 1.0;
        double omega = (2.0 * M_PI);
        double delta_t = 1.0/curr_time_steps;
        
        double exec_times[warm_up+1];
        double performances[warm_up+1];
        double power_consumption[warm_up+1];

        for(size_t w = 0;w < warm_up+1;w++)
        {
            
            if(rank == 0)
            {
                printf("\n\nWarm up round %lu\n",w);
                init_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega, ratio);
                //init_unstable_orbiting_particles(scalar_factor, &mass, &pos, &vel, &force, curr_N, R, omega);
                pos_ref = new cl_double3[curr_N];
                vel_ref = new cl_double3[curr_N];
                force_ref = new cl_double3[curr_N];
                coeff = new cl_double[curr_N];
                memcpy(pos_ref, pos, curr_N*sizeof(cl_double3));
                memcpy(vel_ref, vel, curr_N*sizeof(cl_double3));
                memcpy(force_ref, force, curr_N*sizeof(cl_double3));
                memcpy(coeff, mass, curr_N*sizeof(cl_double));

                printf("Using solver : %s\n",exec_data.solver_type.c_str());
                double exec_time = 0.0;
                if(exec_data.solver_type == "lrb" && exec_data.suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(&exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data.solver_type == "lrbd" && exec_data.suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(&exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, topology, &power_consumption[w]);
                else if(exec_data.solver_type == "lrbd" && exec_data.suffix.find("_sp") != std::string::npos)
                    exec_time = lrbd_solver_sp(&exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred, topology, &power_consumption[w]);
                else if(exec_data.solver_type == "lrb")
                    exec_time = lrb_solver(&exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(&exec_data, scalar_factor, mass, coeff, pos, vel, force, curr_N, curr_time_steps, delta_t, T_pred);

                double mpairs = double(exec_data.lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(exec_time * 1e6);
                double mpairs_pred = double(exec_data.lf_steps-1)*double(curr_time_steps)*double(curr_N)*double(curr_N)/(T_pred * 1e6);
                printf("Solver took %fs\n", exec_time);
                printf("Achieved mpairs/s: %f\n", mpairs);
                exec_times[w] = exec_time;
                performances[w] = mpairs;
                
                print_deviation(pos, pos_ref, "pos", curr_N, true, verbose);
                print_deviation(vel, vel_ref, "vel", curr_N, true, verbose);
                print_deviation(force,force_ref,"force",curr_N, false, verbose);
                delete_particles(mass, pos, vel, force);
                delete[] pos_ref;
                delete[] vel_ref;
                delete[] force_ref;
                delete[] coeff;
            }
            else
            {
                double exec_time;
                if(exec_data.solver_type == "lrb" && exec_data.suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrb_solver_no_sync(&exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else if(exec_data.solver_type == "lrbd" && exec_data.suffix.find("_no_sync") != std::string::npos)
                    exec_time = lrbd_solver_no_sync(&exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred, topology, nullptr);
                else if(exec_data.solver_type == "lrb")
                    exec_time = lrb_solver(&exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
                else
                    exec_time = solver(&exec_data, scalar_factor, nullptr, nullptr, nullptr, nullptr, nullptr, curr_N, curr_time_steps, delta_t, T_pred);
            }
        }
        if(output_file != NULL && rank == 0)
        {
            double last_exec_time = exec_times[warm_up];
            double last_mpairs = performances[warm_up];
            double last_power_consumption = power_consumption[warm_up];
            if(last_exec_time != 0.0)
            {
                fprintf(output_file, "%d, %dx%d, %f, %d, %d, %f, %f, %f, %f, %f, %f, %f\n", comm_sz, exec_data.local_PE_dim, exec_data.remote_PE_dim, f_max,curr_N, curr_time_steps, last_exec_time, last_mpairs, last_mpairs/mpairs_max, curr_time_steps/last_exec_time, last_exec_time*1000.0/curr_time_steps, last_power_consumption, last_mpairs/last_power_consumption);
            }
            else
            {
                printf("Execution time measurement failed!\n");
            }
        }
    }
    if(output_file != NULL)
        fclose(output_file);
    MPI_Finalize();
    return 0;
}

