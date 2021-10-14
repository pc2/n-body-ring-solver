#include "hybrid_solver.h"
#include "omp_solver.h"
#include "force_calculation.h"

#include <stdio.h>
#include <string.h>
#include <cmath>
#include <mpi.h>
#include <omp.h>
#include <immintrin.h>
#include <algorithm>
#include <unistd.h>

void hybrid_ring_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t num_threads, size_t time_steps, double delta_t, Vectorization_type vect_type)
{
    size_t local_N = nb_sys.N / comm_sz;

    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    double*** local_recv_force = (double***)malloc(num_threads*sizeof(double**));
    
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        local_recv_force[thread] = (double**)malloc(DIM*sizeof(double*));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64,sizeof(double) * local_N);
            local_recv_force[thread][d] = (double*)aligned_alloc(64,sizeof(double) * local_N);
        }
    }

    if(rank == 0)
    {
        //Conceptually,
        //Every Process owns all nb_sys.masses,
        //Every Process owns nb_sys.positions  [i * comm_sz + rank], 0 <= i < local_N,
        //Every Process owns nb_sys.velocities [i * comm_sz + rank], 0 <= i < local_N,
        //Since the particles have no order the subsets of particles can be distributed blockwise
        //and from there on each particle is treated as if it was distributed in a round robin fashion


        MPI_Bcast(nb_sys.mass,  nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        for(size_t d = 0;d < DIM;d++)
        {
            MPI_Scatter(nb_sys.pos[d], local_N, MPI_DOUBLE, MPI_IN_PLACE, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            MPI_Scatter(nb_sys.vel[d], local_N, MPI_DOUBLE, MPI_IN_PLACE, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        }
        
        //Use larger message for MPI communication
        //Message contains nb_sys.position and nb_sys.force vectors
        //The each array inside the message has to be 512-bit aligned
        size_t local_N_aligned = (local_N/8) * 8;
        if(local_N_aligned != local_N)
            local_N_aligned += 8;
        double *msg;
        msg = (double*)aligned_alloc(64, 2*DIM*local_N_aligned*sizeof(double));
        //Unpack message: Message consists of local_N positions and the corresponding implicit forces
        double* recv_pos[DIM];
        double* recv_force[DIM];
        for(size_t d = 0;d < DIM;d++)
        {
            recv_pos[d] = &msg[d*local_N_aligned];
            memcpy(recv_pos[d], nb_sys.pos[d], local_N*sizeof(double));
            recv_force[d] = &msg[(DIM+d)*local_N_aligned];
        }

        for(size_t i = 0;i < time_steps;i++)
        {
            //Reset all Forces
            for(size_t k = 0;k < local_N;k++)
            {      
                recv_force[X][k] = 0.0;
                recv_force[Y][k] = 0.0;
                recv_force[Z][k] = 0.0;
                nb_sys.force[X][k] = 0.0;
                nb_sys.force[Y][k] = 0.0;
                nb_sys.force[Z][k] = 0.0;
            }
            //Distribute particles in a ring scheme
            //After comm_sz message passes, the original message returns to the owner
            for(size_t recv_round = 0;recv_round < comm_sz;recv_round++)
            { 
                //compute pairwise force interaction for the received subset and the rank-local subset of particles
                if(vect_type == Vectorization_type::AVX2)
                {
                    compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N, rank, comm_sz, recv_round, num_threads); 
                }
                else if(vect_type == Vectorization_type::AVX512RSQRT)
                {
                    compute_forces_avx512_rsqrt_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N,rank,comm_sz,recv_round,num_threads);
                }
                else if(vect_type == Vectorization_type::AVX512RSQRT4I)
                {
                    compute_forces_avx512_rsqrt_4i_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N,rank,comm_sz,recv_round,num_threads);
                }
                //Only the main thread is allowed to communicate over MPI
                int flag;
                MPI_Is_thread_main(&flag);
                if(!flag)
                {
                    printf("Not main thread trying to call MPI communication function\n");
                    exit(1);
                }
                //Send message to the next lower rank in the ring; Recv the message of the next higher rank
                MPI_Status stat;
                MPI_Sendrecv_replace(msg, 2*DIM*local_N_aligned, MPI_DOUBLE, (rank - 1 + comm_sz)%comm_sz, 0, (rank + 1)%comm_sz, 0, MPI_COMM_WORLD, &stat);
            }
            //Update the positions and velocities
            #pragma omp parallel for simd
            for(size_t k = 0;k < local_N;k++)
            {
                nb_sys.force[X][k] += recv_force[X][k];
                nb_sys.force[Y][k] += recv_force[Y][k];
                nb_sys.force[Z][k] += recv_force[Z][k];
                nb_sys.pos[X][k] += nb_sys.vel[X][k] * delta_t;
                nb_sys.pos[Y][k] += nb_sys.vel[Y][k] * delta_t;
                nb_sys.pos[Z][k] += nb_sys.vel[Z][k] * delta_t;
                nb_sys.vel[X][k] += nb_sys.force[X][k] * delta_t / nb_sys.mass[rank * local_N + k];
                nb_sys.vel[Y][k] += nb_sys.force[Y][k] * delta_t / nb_sys.mass[rank * local_N + k];
                nb_sys.vel[Z][k] += nb_sys.force[Z][k] * delta_t / nb_sys.mass[rank * local_N + k];
            }
        }
    
        //Collect all subsets back to the main rank
        for(size_t d = 0;d < DIM;d++)
        {
            MPI_Gather(MPI_IN_PLACE, local_N, MPI_DOUBLE, nb_sys.pos[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
            MPI_Gather(MPI_IN_PLACE, local_N, MPI_DOUBLE, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
        }
        free(msg);
    }
    else
    { 
        MPI_Bcast(nb_sys.mass, nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        for(size_t d = 0; d < DIM;d++)
        {
            MPI_Scatter(NULL, 0, MPI_DATATYPE_NULL, nb_sys.pos[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            MPI_Scatter(NULL, 0, MPI_DATATYPE_NULL, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        }
        
        size_t local_N_aligned = (local_N/8) * 8;
        if(local_N_aligned != local_N)
            local_N_aligned += 8;
        double *msg;
        msg = (double*)aligned_alloc(64, 2*DIM*local_N_aligned*sizeof(double));
        double* recv_pos[DIM];
        double* recv_force[DIM];
        for(size_t d = 0;d < DIM;d++)
        {
            recv_pos[d] = &msg[d*local_N_aligned];
            memcpy(recv_pos[d], nb_sys.pos[d], local_N*sizeof(double));
            recv_force[d] = &msg[(DIM+d)*local_N_aligned];
        }
        for(size_t i = 0;i < time_steps;i++)
        {
            for(size_t k = 0;k < local_N;k++)
            {      
                recv_force[X][k] = 0.0;
                recv_force[Y][k] = 0.0;
                recv_force[Z][k] = 0.0;
                nb_sys.force[X][k] = 0.0;
                nb_sys.force[Y][k] = 0.0;
                nb_sys.force[Z][k] = 0.0;
            }
            for(size_t recv_round = 0;recv_round < comm_sz;recv_round++)
            { 
                if(vect_type == Vectorization_type::AVX2)
                {
                    compute_forces_avx2_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N, rank, comm_sz, recv_round, num_threads); 
                }
                else if(vect_type == Vectorization_type::AVX512RSQRT)
                {
                    compute_forces_avx512_rsqrt_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N,rank,comm_sz,recv_round,num_threads);
                }
                else if(vect_type == Vectorization_type::AVX512RSQRT4I)
                {
                    compute_forces_avx512_rsqrt_4i_blocked(nb_sys, recv_pos, recv_force, local_force, local_recv_force, local_N,rank,comm_sz,recv_round,num_threads);
                }
        
                int flag;
                MPI_Is_thread_main(&flag);
                if(!flag)
                {
                    printf("Not main thread trying to call MPI communication function\n");
                    exit(1);
                }
                MPI_Status stat;
                MPI_Sendrecv_replace(msg, 2*DIM*local_N_aligned, MPI_DOUBLE, (rank - 1 + comm_sz)%comm_sz, 0, (rank + 1)%comm_sz, 0, MPI_COMM_WORLD, &stat);
            }
            #pragma omp parallel for simd
            for(size_t k = 0;k < local_N;k++)
            {
                nb_sys.force[X][k] += recv_force[X][k];
                nb_sys.force[Y][k] += recv_force[Y][k];
                nb_sys.force[Z][k] += recv_force[Z][k];
                nb_sys.pos[X][k] += nb_sys.vel[X][k] * delta_t;
                nb_sys.pos[Y][k] += nb_sys.vel[Y][k] * delta_t;
                nb_sys.pos[Z][k] += nb_sys.vel[Z][k] * delta_t;
                nb_sys.vel[X][k] += nb_sys.force[X][k] * delta_t / nb_sys.mass[rank * local_N + k];
                nb_sys.vel[Y][k] += nb_sys.force[Y][k] * delta_t / nb_sys.mass[rank * local_N + k];
                nb_sys.vel[Z][k] += nb_sys.force[Z][k] * delta_t / nb_sys.mass[rank * local_N + k];
            }
        } 
        
        for(size_t d = 0; d < DIM;d++)
        {
            MPI_Gather(nb_sys.pos[d], local_N, MPI_DOUBLE, NULL, 0, MPI_DATATYPE_NULL, 0, MPI_COMM_WORLD); 
            MPI_Gather(nb_sys.vel[d], local_N, MPI_DOUBLE, NULL, 0, MPI_DATATYPE_NULL, 0, MPI_COMM_WORLD);
        }
        free(msg);
    }
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]);    
            free(local_recv_force[thread][d]);    
        }
        free(local_force[thread]);
        free(local_recv_force[thread]);
    }
    free(local_force);
    free(local_recv_force);
}

void hybrid_full_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t num_threads, size_t time_steps, double delta_t, Vectorization_type vect_type)
{
    size_t local_N = nb_sys.N / comm_sz;

    double*** local_force = (double***)malloc(num_threads*sizeof(double**));
    size_t num_masks = local_N/4;
    if(num_masks*4 != local_N)num_masks++;
    __mmask8** sqrt_mask = (__mmask8**)malloc(num_threads*sizeof(__mmask8*));
    
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        local_force[thread] = (double**)malloc(DIM*sizeof(double*));
        sqrt_mask[thread] = (__mmask8*)malloc(num_masks*sizeof(__mmask8));
        for(size_t d = 0;d < DIM;d++)
        {
            local_force[thread][d] = (double*)aligned_alloc(64,sizeof(double) * local_N);
        }
        for(size_t k = 0;k < num_masks;k++)
        {
            sqrt_mask[thread][k] = 0xFF;
        }
    }

    MPI_Bcast(nb_sys.mass, nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    for(size_t d = 0;d < DIM;d++)
    {
        MPI_Bcast(nb_sys.pos[d], nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    }
    for(size_t d = 0;d < DIM;d++)
    {
        if(rank == 0)   
            MPI_Scatter(nb_sys.vel[d], local_N, MPI_DOUBLE, MPI_IN_PLACE, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        else
            MPI_Scatter(NULL, 0, MPI_DATATYPE_NULL, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

    }
    /*
    for(size_t k = 0;k < nb_sys.N;k++)
        printf("%zu:mass[%zu] = %f, pos[%zu] = {%f,%f,%f}\n", rank, k, nb_sys.mass[k], k, nb_sys.pos[X][k], nb_sys.pos[Y][k], nb_sys.pos[Z][k]);
    for(size_t k = 0;k < local_N;k++)
        printf("%zu:vel[%zu] = {%f,%f,%f}\n", rank, k, nb_sys.vel[X][k], nb_sys.vel[Y][k], nb_sys.vel[Z][k]);
    */

    //Allocate buffer for local particles as they have to be aligned
    double* local_mass = (double*)aligned_alloc(64,sizeof(double) * local_N);
    memcpy(local_mass, &nb_sys.mass[rank*local_N], sizeof(double) * local_N);
    double* local_pos[DIM];
    for(size_t d = 0;d < DIM;d++)
    {
        local_pos[d] = (double*)aligned_alloc(64, sizeof(double) * local_N);
        memcpy(local_pos[d], &nb_sys.pos[d][rank*local_N], sizeof(double)*local_N);
    }

    for(size_t i = 0;i < time_steps;i++)
    {
        //Reset all Forces
        for(size_t k = 0;k < local_N;k++)
        {      
            nb_sys.force[X][k] = 0.0;
            nb_sys.force[Y][k] = 0.0;
            nb_sys.force[Z][k] = 0.0;
        }
        compute_forces_full_avx2(nb_sys, local_force, local_pos, local_mass, sqrt_mask, local_N, rank, comm_sz, num_threads); 
        //Update the positions and velocities
        #pragma omp parallel for simd
        for(size_t k = 0;k < local_N;k++)
        {
            local_pos[X][k] += nb_sys.vel[X][k] * delta_t;
            local_pos[Y][k] += nb_sys.vel[Y][k] * delta_t;
            local_pos[Z][k] += nb_sys.vel[Z][k] * delta_t;
            nb_sys.vel[X][k] += nb_sys.force[X][k] * delta_t / local_mass[k];
            nb_sys.vel[Y][k] += nb_sys.force[Y][k] * delta_t / local_mass[k];
            nb_sys.vel[Z][k] += nb_sys.force[Z][k] * delta_t / local_mass[k];
        }
        
        //Only the main thread is allowed to communicate over MPI
        int flag;
        MPI_Is_thread_main(&flag);
        if(!flag)
        {
            printf("Not main thread trying to call MPI communication function\n");
            exit(1);
        }
        for(size_t d = 0;d < DIM;d++)
            MPI_Allgather(local_pos[d], local_N, MPI_DOUBLE, nb_sys.pos[d], local_N, MPI_DOUBLE, MPI_COMM_WORLD);
    }

    //Collect all subsets back to the main rank
    for(size_t d = 0;d < DIM;d++)
    {
        if(rank == 0)
            MPI_Gather(MPI_IN_PLACE, local_N, MPI_DOUBLE, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
        else
            MPI_Gather(nb_sys.vel[d], local_N, MPI_DOUBLE, NULL, 0, MPI_DATATYPE_NULL, 0, MPI_COMM_WORLD); 
    }
    
    for(size_t thread = 0; thread < num_threads;thread++)
    {
        for(size_t d = 0;d < DIM;d++)
        {
            free(local_force[thread][d]);    
        }
        free(local_force[thread]);
        free(sqrt_mask[thread]);
    }
    for(size_t d = 0;d < DIM;d++)
        free(local_pos[d]);
    free(local_mass);
    free(local_force);
    free(sqrt_mask);
}

int hybrid_main(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, Vectorization_type vect_type, Solver_type solver_type, bool verbose)
{

    //Initialize MPI for hybrid OpenMP usage
    int provided, flag, claimed;

    MPI_Init_thread(NULL, NULL, MPI_THREAD_FUNNELED, &provided);
    if(provided != MPI_THREAD_FUNNELED)
    {
        printf("MPI_THREAD_FUNNELED not available.\n");
        exit(1);
    }
    MPI_Query_thread(&claimed);
    if(provided != claimed)
    {
        printf("Query thread gave %d but init gave%d\n", claimed, provided);
        exit(1);
    }
    MPI_Is_thread_main(&flag);
    if(!flag)
    {
        printf("This thread called init, but claims not to be main.");
        exit(1);
    }

    size_t comm_sz;
    size_t rank;
    int mpi_ret;
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_ret);
    comm_sz = static_cast<size_t>(mpi_ret);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_ret);
    rank = static_cast<size_t>(mpi_ret);
        
    size_t num_threads = omp_get_max_threads();

    //could be improved using gatherv and scatterv
    if(N % comm_sz != 0)
    {
        if(rank == 0)printf("N not evenly divisible by comm_sz; currently not supported; exiting!\n");
        MPI_Finalize();
        return 1;
    }
    
    double R = 1.0; //Distance to center particle
    double omega = (2.0 * M_PI)/T; //Number of orbits per unit time
    double delta_t = T/time_steps;
   
    if(rank == 0)
    {
        printf("Number of MPI ranks: %zu\n", comm_sz);
        printf("Threads per rank: %zu\n", num_threads);

        //Let the simulation run for one orbit
        //Compare the result with the original positions
        //Ideally, there is no deviation
        NBody_system sys1;
        NBody_system ref;
        sys1.init_stable_orbiting_particles(N, R, omega, ratio);
        ref = sys1;

        if(solver_type == Solver_type::REDUCED)
        {
            double start = MPI_Wtime();
            hybrid_ring_solver(sys1, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
            double end = MPI_Wtime();

            double num_pairs = double(time_steps) * double(N)*double(N-1);
            double mpairs = num_pairs/(1e6 * (end-start));
     
            printf("Ring Solver took %fs\n", end - start);
            printf("MPairs/s: %f\n", mpairs);
        }
        else if(solver_type == Solver_type::FULL)
        {
            double start = MPI_Wtime();
            hybrid_full_solver(sys1, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
            double end = MPI_Wtime();

            double num_pairs = double(time_steps) * double(N)*double(N-1);
            double mpairs = num_pairs/(1e6 * (end-start));
            printf("%zu:Ring Solver took %fs\n", rank, end - start);
            printf("MPairs/s: %f\n", mpairs);
        }
        //Compare solution to reference
        print_deviation(sys1.pos, ref.pos, "position", N, verbose);
        print_deviation(sys1.vel, ref.vel, "velocity", N, verbose);
        printf("\n\n"); 
        MPI_Barrier(MPI_COMM_WORLD);    
    }
    else
    {
        NBody_system sys;
        //Only allocate the needed buffers
        //The corresponding data will be send from the main rank
        if(solver_type == Solver_type::REDUCED)
        {
            sys.alloc_particles(N, N/comm_sz);
            hybrid_ring_solver(sys, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
        }
        else
        {
            sys.alloc_particles(N, N);
            hybrid_full_solver(sys, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}

int hybrid_scaling_benchmark(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, bool weak, std::string output_path, Vectorization_type vect_type, Solver_type solver_type, bool verbose)
{

    //Initialize MPI for hybrid OpenMP usage
    int provided, flag, claimed;

    MPI_Init_thread(NULL, NULL, MPI_THREAD_FUNNELED, &provided);
    if(provided != MPI_THREAD_FUNNELED)
    {
        printf("MPI_THREAD_FUNNELED not available.\n");
        MPI_Finalize();
        return EXIT_FAILURE;
    }
    MPI_Query_thread(&claimed);
    if(provided != claimed)
    {
        printf("Query thread gave %d but init gave%d\n", claimed, provided);
        MPI_Finalize();
        return EXIT_FAILURE;
    }
    MPI_Is_thread_main(&flag);
    if(!flag)
    {
        printf("This thread called init, but claims not to be main.");
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    size_t comm_sz;
    size_t rank;
    int mpi_ret;
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_ret);
    comm_sz = static_cast<size_t>(mpi_ret);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_ret);
    rank = static_cast<size_t>(mpi_ret);
    
    size_t num_threads = omp_get_max_threads();
    
    double R = 1.0; //Distance to center particle
    double omega = (2.0 * M_PI)/T; //Number of orbits per unit time
    double delta_t = T/time_steps;
  
    size_t scaled_N = N;
    //weak scaling scales the number of particles in relation to the number of cores used
    if(weak)
       scaled_N = comm_sz*num_threads*N; 
    
    if(scaled_N % comm_sz != 0)
    {
        if(rank == 0)printf("N not evenly divisible by comm_sz; currently not supported; exiting!\n");
        MPI_Finalize();
        return EXIT_FAILURE;
    }

    constexpr size_t avg_steps = 3;

    if(rank == 0)
    {
        printf("\n\n-------- Ring Solver --------\n");
        printf("N = %zu, time_steps = %zu\n", scaled_N, time_steps);
        printf("Number of MPI ranks: %zu\n", comm_sz);
        printf("Threads per rank: %zu\n", num_threads);
        double avg_timing[avg_steps];
        //Repeat the simulation several times for the given problem size
        //to average out fluctuations in the performance
        for(size_t avg = 0; avg < avg_steps;avg++)
        {
            NBody_system sys1;
            sys1.init_stable_orbiting_particles(scaled_N, R, omega, ratio);

            if(solver_type == Solver_type::REDUCED)
            {
                double start = MPI_Wtime();
                hybrid_ring_solver(sys1, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
                double end = MPI_Wtime();
                avg_timing[avg] = end - start;
            }
            else if(solver_type == Solver_type::FULL)
            {
                double start = MPI_Wtime();
                hybrid_full_solver(sys1, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
                double end = MPI_Wtime();
                avg_timing[avg] = end - start;
            }
            MPI_Barrier(MPI_COMM_WORLD);
        }

        //take the median execution time as the averaged result
        std::nth_element(avg_timing, avg_timing+avg_steps/2, avg_timing+avg_steps);
        double t_total = avg_timing[avg_steps/2];
        double num_pairs = double(time_steps) * double(scaled_N)*double(scaled_N-1);
        double mpairs = num_pairs/(1e6 * t_total);

        for(size_t i = 0;i < avg_steps;i++)
        {
            printf("Ring Solver execution %lu took %fs\n", i, avg_timing[i]);
            printf("Execution %lu MPairs/s: %f\n", i, num_pairs/(1e6 * avg_timing[i]));
        }

        printf("Median Ring Solver Execution took %fs\n", t_total);
        printf("Median MPairs/s: %f\n", mpairs);

        //The hybrid solver can not change the number of ranks dynamically from within the program
        //Therefore, the program is called multiple times from a job script
        //To only initialize the resulting .csv once, check whether the file exists
        bool file_exists = (access(output_path.c_str(), F_OK) != -1);
        if(file_exists)
        {
            /*FILE* output_file = fopen(output_path.c_str(), "r");
            if(output_file == NULL)
            {
                perror("Failed to open output file for reading: ");
                MPI_Finalize();
                return EXIT_FAILURE;
            }

            char* header_line = nullptr;
            size_t header_len;
            int ret = getline(&header_line, &header_len, output_file);
            if(ret == -1)
            {
                if(ferror(output_file))
                {
                    perror("Failed to read in header line: ");
                    MPI_Finalize();
                    return EXIT_FAILURE;
                }
                else if(feof(output_file))
                {
                    printf("Reached EOF\n");
                }
            }
            if(header_line)free(header_line);

            
            size_t baseline_cores, baseline_N;
            double baseline_t_total, baseline_mpairs, baseline_speedup;
            ret = fscanf(output_file, "%zu, %zu, %lf, %lf ,%lf\n", &baseline_cores, &baseline_N, &baseline_t_total, &baseline_mpairs, &baseline_speedup);
            if(ret != 5) 
            {
                printf("ret: %d\n", ret);
                if(ferror(output_file))
                {
                    perror("Failed to read in baseline: ");
                    MPI_Finalize();
                    return EXIT_FAILURE;
                }
                else if(feof(output_file))
                {
                    printf("Reached EOF\n");
                }
            }
            fclose(output_file);
          
            //if(baseline_N != N)
            //{
            //    printf("N = %zu does not match the baseline N = %zu! Results would not be meaningful.\n", N, baseline_N);
            //    MPI_Finalize();
            //    return EXIT_FAILURE;
            //}
            

            double speedup = 1.0;
            if(weak)
            {
                printf("Using %fMpairs/s as the baseline performance\n", baseline_mpairs);
                speedup = mpairs/baseline_mpairs;
            }
            else
            {
                printf("Using %fs as the baseline execution time\n", baseline_t_total);
                speedup = baseline_t_total/t_total;
            }
            */
            
            FILE* output_file = fopen(output_path.c_str(), "a");
            if(output_file == NULL)
            {
                perror("Failed to open output file for appending: ");
                MPI_Finalize();
                return EXIT_FAILURE;
            }
            fprintf(output_file, "%zu,%zu,%zu,%f,%f,%f,%f\n", comm_sz/2, comm_sz*num_threads, scaled_N, t_total, mpairs, time_steps/t_total, t_total*1000.0/time_steps);
            fclose(output_file);
        }
        else
        {
            FILE* output_file = fopen(output_path.c_str(), "w");
            if(output_file == NULL)
            {
                perror("Failed to open output file for writing: ");
                MPI_Finalize();
                return EXIT_FAILURE;
            }
            fprintf(output_file, "#Nodes, Cores, N, t_total[s], performance[Mpairs/s], time_steps/s, ms/time_step\n");       
            fprintf(output_file, "%zu,%zu,%zu,%f,%f,%f,%f\n", comm_sz/2, comm_sz*num_threads, scaled_N, t_total, mpairs, time_steps/t_total, t_total*1000.0/time_steps);
            fclose(output_file);
        }
    }
    else
    {
        for(size_t avg = 0; avg < avg_steps;avg++)
        {
            NBody_system sys;
            if(solver_type == Solver_type::REDUCED)
            {
                sys.alloc_particles(scaled_N, scaled_N/comm_sz);
                hybrid_ring_solver(sys, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
            }
            else
            {
                sys.alloc_particles(scaled_N, scaled_N);
                hybrid_full_solver(sys, rank, comm_sz, num_threads, time_steps, delta_t, vect_type);
            }
            MPI_Barrier(MPI_COMM_WORLD);
        }
    }
    MPI_Finalize();
    return 0;
}
