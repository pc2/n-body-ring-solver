#include "mpi_solver.h"

#include <stdio.h>
#include <string.h>
#include <cmath>
#include <mpi.h>
#include <vector>

void ring_solver(NBody_system& nb_sys, size_t rank, size_t comm_sz, size_t time_steps, double delta_t)
{
    size_t local_N = nb_sys.N / comm_sz;
    if(rank == 0)
    {
        MPI_Bcast(nb_sys.mass,  nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        for(size_t d = 0;d < DIM;d++)
        {
            MPI_Scatter(nb_sys.pos[d], local_N, MPI_DOUBLE, MPI_IN_PLACE, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            MPI_Scatter(nb_sys.vel[d], local_N, MPI_DOUBLE, MPI_IN_PLACE, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        }
        
        //Message contains nb_sys.position and nb_sys.force vectors
        double *send_msg, *recv_msg;
        send_msg = new double[2*DIM*local_N];
        recv_msg = new double[2*DIM*local_N];

        for(size_t i = 0;i < time_steps;i++)
        {
            double start = MPI_Wtime();
            compute_positions_ring(nb_sys, send_msg, recv_msg, local_N, rank, comm_sz, delta_t); 
            double end = MPI_Wtime();
            printf("Single transfer took %fs\n", end - start);
        }
        
        for(size_t d = 0;d < DIM;d++)
        {
            MPI_Gather(MPI_IN_PLACE, local_N, MPI_DOUBLE, nb_sys.pos[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
            MPI_Gather(MPI_IN_PLACE, local_N, MPI_DOUBLE, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD); 
        }
        
        
        delete[] send_msg;
        delete[] recv_msg;
    }
    else
    { 
        MPI_Bcast(nb_sys.mass, nb_sys.N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        for(size_t d = 0; d < DIM;d++)
        {
            MPI_Scatter(NULL, 0, MPI_DATATYPE_NULL, nb_sys.pos[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
            MPI_Scatter(NULL, 0, MPI_DATATYPE_NULL, nb_sys.vel[d], local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        }
        
        double *send_msg, *recv_msg;
        send_msg = new double[2*DIM*local_N];
        recv_msg = new double[2*DIM*local_N];

        for(size_t i = 0;i < time_steps;i++)
        {
            compute_positions_ring(nb_sys, send_msg, recv_msg, local_N, rank, comm_sz, delta_t); 
            double* swap_msg = send_msg;
            send_msg = recv_msg;
            recv_msg = swap_msg;
        }
        
        for(size_t d = 0; d < DIM;d++)
        {
            MPI_Gather(nb_sys.pos[d], local_N, MPI_DOUBLE, NULL, 0, MPI_DATATYPE_NULL, 0, MPI_COMM_WORLD); 
            MPI_Gather(nb_sys.vel[d], local_N, MPI_DOUBLE, NULL, 0, MPI_DATATYPE_NULL, 0, MPI_COMM_WORLD);
        }
        delete[] send_msg;
        delete[] recv_msg;
    }
}

void compute_positions_ring(NBody_system& nb_sys, double* send_msg, double* recv_msg, size_t local_N, size_t rank, size_t comm_sz, double delta_t)
{
    //Unpack message: Message consists of local_N nb_sys.positions and the corresponding implicit nb_sys.forces
    
    double* recv_pos[DIM];
    double* recv_force[DIM];
    for(size_t d = 0;d < DIM;d++)
    {
        recv_pos[d] = &recv_msg[d*local_N];
        recv_force[d] = &recv_msg[(DIM+d)*local_N];
    }

    //After comm_sz message passes, the original message returns to the owner
    if(comm_sz == 1)return;
    for(size_t recv_round = 0;recv_round < comm_sz;recv_round++)
    {
        size_t prev_rank = (rank + comm_sz - 1)%comm_sz;
        size_t next_rank = (rank + 1)%comm_sz;
        MPI_Status stat;

        if(rank%2 == 0)
        {
            MPI_Send(send_msg, 2*DIM*local_N, MPI_DOUBLE, next_rank, 0, MPI_COMM_WORLD);
            MPI_Recv(recv_msg, 2*DIM*local_N, MPI_DOUBLE, prev_rank, 0, MPI_COMM_WORLD, &stat);
        }
        else
        {
            MPI_Recv(recv_msg, 2*DIM*local_N, MPI_DOUBLE, prev_rank, 0, MPI_COMM_WORLD, &stat);
            MPI_Send(send_msg, 2*DIM*local_N, MPI_DOUBLE, next_rank, 0, MPI_COMM_WORLD);
        }

        //MPI_Sendrecv_replace(msg, 2*DIM*local_N, MPI_DOUBLE, (rank - 1 + comm_sz)%comm_sz, 0, (rank + 1)%comm_sz, 0, MPI_COMM_WORLD, &stat);
            //printf("Recv_round: %d\n", recv_round);
    }
}


int mpi_bandwidth_benchmark(int argc, char** argv, size_t N, size_t time_steps, double T, double ratio, bool verbose)
{
    size_t comm_sz;
    size_t rank;
    int mpi_ret;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_ret);
    comm_sz = static_cast<size_t>(mpi_ret);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_ret);
    rank = static_cast<size_t>(mpi_ret);
    if(N % comm_sz != 0)
    {
        if(rank == 0)printf("N not evenly divisible by comm_sz; currently not supported; exiting!\n");
        MPI_Finalize();
        return 1;
    }
    
    //omega: Used for initializing orbiting particles
    //delta_t: time_step
    double R = 1.0;
    double omega = (2.0 * M_PI)/T;
    double delta_t = T/time_steps;
    
    if(rank == 0)
    {
        NBody_system sys1;
        NBody_system ref;

        printf("Starting Program with %zu ranks.\n", comm_sz);
        //sys1.init_stable_orbiting_particles(N, R, omega, 100000);
        sys1.init_stable_orbiting_particles(N, R, omega, ratio);
        ref = sys1;
       
        double start = MPI_Wtime();
        ring_solver(sys1, rank, comm_sz, time_steps, delta_t);
        double end = MPI_Wtime();
        MPI_Barrier(MPI_COMM_WORLD);
        printf("Ring communication took %fs\n", end - start);
        printf("Bandwidth: %fGB/s\n", 48.0*double(N)*double(time_steps)/(1e9*(end-start)));
    }
    else
    {
        NBody_system sys;
        sys.alloc_particles(N, N/comm_sz);
        //basic_solver(sys, rank, comm_sz, time_steps, delta_t);
        ring_solver(sys, rank, comm_sz, time_steps, delta_t);
        MPI_Barrier(MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}
