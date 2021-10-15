#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <map>
#include <string>

#include "mpi_solver.h"
#include "omp_solver.h"
#include "hybrid_solver.h"

void get_arguments(int argc, 
                   char** argv, 
                   size_t& N, 
                   size_t& start_N, 
                   size_t& step_N, 
                   size_t& num_steps, 
                   size_t& time_steps, 
                   double& T, 
                   double& ratio, 
                   double& ratio_start,
                   double& ratio_stop,
                   size_t& ratio_steps,
                   size_t& rev_steps,
                   double& max_error,
                   bool& verbose, 
                   std::string& output_file, 
                   Execution_type& exec_type, 
                   Integration_kind& int_kind,
                   size_t& int_order,
                   Vectorization_type& vect_type,
                   Solver_type& solver_type,
                   Data_type& data_type)
{
    N = 1000;
    start_N = 1000;
    step_N = 1000;
    num_steps = 1;
    time_steps = 1000;
    T = 1.0;
    ratio = 100000.0;

    ratio_start = 1e6;
    ratio_stop = 1e9;
    ratio_steps = 3;

    rev_steps = 1000;
    max_error = 1.0;

    verbose = false;
    output_file = std::string("output.csv"); 
    exec_type = Execution_type::OMP;
    int_kind = Integration_kind::EULER;
    vect_type = Vectorization_type::AVX2;
    solver_type = Solver_type::REDUCED;
    data_type = Data_type::DOUBLE_PRECISION;
    int_order = 1;

    std::map<std::string, Execution_type> convert_str_to_exec_type;
    convert_str_to_exec_type["omp"] = Execution_type::OMP;
    convert_str_to_exec_type["omp-cache"] = Execution_type::OMP_CACHE;
    convert_str_to_exec_type["omp-weak"] = Execution_type::OMP_WEAK;
    convert_str_to_exec_type["omp-strong"] = Execution_type::OMP_STRONG;
    convert_str_to_exec_type["omp-accuracy"] = Execution_type::OMP_ACCURACY;
    convert_str_to_exec_type["omp-ratio"] = Execution_type::OMP_RATIO;
    convert_str_to_exec_type["mpi-bandwidth"] = Execution_type::MPI_BANDWIDTH;
    convert_str_to_exec_type["hybrid"] = Execution_type::HYBRID;
    convert_str_to_exec_type["hybrid-weak"] = Execution_type::HYBRID_WEAK;
    convert_str_to_exec_type["hybrid-strong"] = Execution_type::HYBRID_STRONG;

    std::map<std::string, Integration_kind> convert_str_to_int_kind;
    convert_str_to_int_kind["euler"] = Integration_kind::EULER;
    convert_str_to_int_kind["lf"] = Integration_kind::LEAP_FROG;
    convert_str_to_int_kind["rk"] = Integration_kind::RUNGE_KUTTA;
    
    std::map<std::string, Vectorization_type> convert_str_to_vect_type;
    convert_str_to_vect_type["AVX2"] = Vectorization_type::AVX2;
    convert_str_to_vect_type["AVX512"] = Vectorization_type::AVX512;
    convert_str_to_vect_type["AVX2-RSQRT"] = Vectorization_type::AVX2RSQRT;
    convert_str_to_vect_type["AVX512-RSQRT"] = Vectorization_type::AVX512RSQRT;
    convert_str_to_vect_type["AVX512-RSQRT-4I"] = Vectorization_type::AVX512RSQRT4I;
    
    std::map<std::string, Solver_type> convert_str_to_solver_type;
    convert_str_to_solver_type["full"] = Solver_type::FULL;
    convert_str_to_solver_type["reduced"] = Solver_type::REDUCED;

    std::map<std::string, Data_type> convert_str_to_data_type;
    convert_str_to_data_type["dp"] = Data_type::DOUBLE_PRECISION;
    convert_str_to_data_type["sp"] = Data_type::SINGLE_PRECISION;
    
    for(int i = 1; i<argc; i++)
    {
        if(strcmp(argv[i], "-N") == 0)
        {
            if(i+1 < argc)
            {
                N = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-start") == 0)
        {
            if(i+1 < argc)
            {
                start_N = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-step") == 0)
        {
            if(i+1 < argc)
            {
                step_N = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-n") == 0)
        {
            if(i+1 < argc)
            {
                num_steps = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-ratio-start") == 0)
        {
            if(i+1 < argc)
            {
                ratio_start = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio-stop") == 0)
        {
            if(i+1 < argc)
            {
                ratio_stop = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-ratio-steps") == 0)
        {
            if(i+1 < argc)
            {
                ratio_steps = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-rev-steps") == 0)
        {
            if(i+1 < argc)
            {
                rev_steps = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-max-error") == 0)
        {
            if(i+1 < argc)
            {
                max_error = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-s") == 0)
        {
            if(i+1 < argc)
            {
                time_steps = strtoull(argv[++i], NULL, 10);
            }
        }
        else if(strcmp(argv[i], "-T") == 0)
        {
            if(i+1 < argc)
            {
                T = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-r") == 0)
        {
            if(i+1 < argc)
            {
                ratio = atof(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-v") == 0)
        {
            verbose = true;
        }
        else if(strcmp(argv[i], "-o") == 0)
        {
            if(i+1 < argc)
            {
                output_file = std::string(argv[++i]);
            }
        }
        else if(strcmp(argv[i], "-t") == 0)
        {
            if(i+1 < argc)
            {
                std::string str_type = std::string(argv[++i]);
                if(convert_str_to_exec_type.find(str_type) == convert_str_to_exec_type.end())
                {
                    printf("Unknown Execution type: %s\n Defaulting to omp\n", str_type.c_str());
                    exec_type = Execution_type::OMP;
                }
                else
                    exec_type = convert_str_to_exec_type[str_type];

            }
        }
        else if(strcmp(argv[i], "-i") == 0)
        {
            if(i+1 < argc)
            {
                std::string str_kind = std::string(argv[++i]);
                if(convert_str_to_int_kind.find(str_kind) == convert_str_to_int_kind.end())
                {
                    printf("Unknown Integration kind: %s\n Defaulting to euler\n", str_kind.c_str());
                    int_kind = Integration_kind::EULER;
                }
                else
                    int_kind = convert_str_to_int_kind[str_kind];

            }
        }
        else if(strcmp(argv[i], "-V") == 0)
        {
            if(i+1 < argc)
            {
                std::string str_kind = std::string(argv[++i]);
                if(convert_str_to_vect_type.find(str_kind) == convert_str_to_vect_type.end())
                {
                    printf("Unknown Vectorization type: %s\n Defaulting to AVX2\n", str_kind.c_str());
                    vect_type = Vectorization_type::AVX2;
                }
                else
                    vect_type = convert_str_to_vect_type[str_kind];

            }
        }
        else if(strcmp(argv[i], "-S") == 0)
        {
            if(i+1 < argc)
            {
                std::string str_kind = std::string(argv[++i]);
                if(convert_str_to_solver_type.find(str_kind) == convert_str_to_solver_type.end())
                {
                    printf("Unknown Solver type: %s\n Defaulting to Reduced Solver\n", str_kind.c_str());
                    solver_type = Solver_type::REDUCED;
                }
                else
                    solver_type = convert_str_to_solver_type[str_kind];

            }
        }
        else if(strcmp(argv[i], "-p") == 0) //precision
        {
            if(i+1 < argc)
            {
                std::string str_kind = std::string(argv[++i]);
                if(convert_str_to_data_type.find(str_kind) == convert_str_to_data_type.end())
                {
                    printf("Unknown Data type: %s\n Defaulting to double precision\n", str_kind.c_str());
                    data_type = Data_type::DOUBLE_PRECISION;
                }
                else
                    data_type = convert_str_to_data_type[str_kind];

            }
        }
        else if(strcmp(argv[i], "-order") == 0)
        {
            if(i+1 < argc)
            {
                int_order = strtoull(argv[++i], NULL, 10);
            }
        }
        
    }
    if(N >= 100000000 || start_N >= 100000000 || start_N + step_N * num_steps >= 100000000)
    {
        printf("Input problem size might be too large!\nMake sure to stay below 10^8 particles.\nResetting to defaults");
        N = 1000;
        start_N = 1000;
        step_N = 1000;
        num_steps = 1;
    }
    if(T <= 0.0)
    {
        printf("T has to be >= 0!\n Resetting to 1.0\n");
        T = 1.0;
    }
    if(ratio < 0.0)
    {
        printf("ratio has to be >= 0!\n Resetting to 1e6\n");
        ratio = 1e6;
    }
}

int main(int argc, char** argv)
{ 
    size_t N;
    size_t start_N;
    size_t step_N;
    size_t num_steps;
    size_t time_steps;
    double T;
    double ratio;
    double ratio_start;
    double ratio_stop;
    size_t ratio_steps;
    size_t rev_steps;
    double max_error;
    bool verbose;
    std::string output_file;
    
    Integration_kind int_kind;
    size_t int_order;
    
    Execution_type exec_type;

    Vectorization_type vect_type;
    
    Solver_type solver_type;

    Data_type data_type;

    get_arguments(argc, argv, N, start_N, step_N, num_steps, time_steps, T, ratio, ratio_start, ratio_stop, ratio_steps, rev_steps, max_error, verbose, output_file, exec_type, int_kind, int_order,vect_type,solver_type, data_type);
    switch(exec_type)
    {
        case Execution_type::OMP:
            omp_main(N, time_steps, T, ratio, int_kind, int_order, vect_type, solver_type, verbose);
            break;
        case Execution_type::OMP_CACHE:
            omp_cache_benchmark(start_N, step_N, num_steps, time_steps, T, ratio, output_file, verbose);
            break;
        case Execution_type::OMP_WEAK:
            omp_scaling_benchmark(N, time_steps, T, ratio, true, output_file, vect_type, solver_type, verbose);
            break; 
        case Execution_type::OMP_STRONG:
            omp_scaling_benchmark(N, time_steps, T, ratio, false, output_file, vect_type, solver_type, verbose);
            break;
        case Execution_type::OMP_ACCURACY:
            omp_accuracy(start_N, step_N, num_steps, T, ratio_start, ratio_stop, ratio_steps, output_file, vect_type, data_type, verbose);
            break;
        case Execution_type::OMP_RATIO:
            omp_ratio_accuracy(start_N, step_N, num_steps, time_steps, T, ratio_start, ratio_stop, ratio_steps, rev_steps, max_error, output_file, vect_type, data_type, verbose);
            break;
        case Execution_type::HYBRID:
            hybrid_main(argc, argv, N, time_steps, T, ratio, vect_type, solver_type, verbose);
            break;
        case Execution_type::HYBRID_WEAK:
            hybrid_scaling_benchmark(argc, argv, N, time_steps, T, ratio, true, output_file, vect_type, solver_type, verbose);
            break;
        case Execution_type::HYBRID_STRONG:
            hybrid_scaling_benchmark(argc, argv, N, time_steps, T, ratio, false, output_file, vect_type, solver_type, verbose);
            break;
        case Execution_type::MPI_BANDWIDTH:
            mpi_bandwidth_benchmark(argc, argv, N, time_steps, T, ratio, verbose);
            break;
        default:
            printf("Benchmark type not available!\n");
    }
    return 0;
}

