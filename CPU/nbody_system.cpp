#include "nbody_system.h"
#include <mpi.h>
#include <string.h>
#include <stdlib.h>
#include <cmath>
#include <random>
#include <stdlib.h>
#include <string>

NBody_system::NBody_system()
    :
    N(0),
    local_N(0),
    mass(nullptr),
    pos{nullptr, nullptr, nullptr},
    vel{nullptr, nullptr, nullptr},
    force{nullptr, nullptr, nullptr}
{
}

NBody_system::NBody_system(const NBody_system& rhs)
{

    if(rhs.N != 0)
    {
        alloc_particles(rhs.N, rhs.N);
        memcpy(mass, rhs.mass, N*sizeof(double));
        memcpy(pos[X], rhs.pos[X], N*sizeof(double));
        memcpy(pos[Y], rhs.pos[Y], N*sizeof(double));
        memcpy(pos[Z], rhs.pos[Z], N*sizeof(double));
        memcpy(vel[X], rhs.vel[X], N*sizeof(double));
        memcpy(vel[Y], rhs.vel[Y], N*sizeof(double));
        memcpy(vel[Z], rhs.vel[Z], N*sizeof(double));
        memcpy(force[X], rhs.force[X], N*sizeof(double));
        memcpy(force[Y], rhs.force[Y], N*sizeof(double));
        memcpy(force[Z], rhs.force[Z], N*sizeof(double));
    }
}

NBody_system& NBody_system::operator=(const NBody_system& rhs)
{
    if(this != &rhs)
    {
        if(rhs.N != 0)
        {
            if(this->N != rhs.N)
            {
                delete_particles();
                N = 0;
                alloc_particles(rhs.N, rhs.N);
            }
            memcpy(mass, rhs.mass, N*sizeof(double));
            memcpy(pos[X], rhs.pos[X], N*sizeof(double));
            memcpy(pos[Y], rhs.pos[Y], N*sizeof(double));
            memcpy(pos[Z], rhs.pos[Z], N*sizeof(double));
            memcpy(vel[X], rhs.vel[X], N*sizeof(double));
            memcpy(vel[Y], rhs.vel[Y], N*sizeof(double));
            memcpy(vel[Z], rhs.vel[Z], N*sizeof(double));
            memcpy(force[X], rhs.force[X], N*sizeof(double));
            memcpy(force[Y], rhs.force[Y], N*sizeof(double));
            memcpy(force[Z], rhs.force[Z], N*sizeof(double));
        }
    }
    return *this;
}

void NBody_system::alloc_particles(size_t N, size_t local_N)
{
    this->N = N;
    this->local_N = local_N;
    mass = (double*)aligned_alloc(64, N*sizeof(double));
    for(size_t d = 0;d < DIM;d++)
    {
        pos[d] = (double*)aligned_alloc(64, N*sizeof(double));
        vel[d] = (double*)aligned_alloc(64, local_N*sizeof(double));
        force[d] = (double*)aligned_alloc(64, local_N*sizeof(double));
    }
}


void NBody_system::delete_particles()
{
    if(mass){std::free(mass);mass = nullptr;}
    for(size_t d = 0;d < DIM;d++)
    {
        if(pos[d]){std::free(pos[d]);pos[d] = nullptr;}
        if(vel[d]){std::free(vel[d]);vel[d] = nullptr;}
        if(force[d]){std::free(force[d]);force[d] = nullptr;}
    }
}

NBody_system::~NBody_system()
{
    delete_particles();
}

void NBody_system::save_particles(size_t time_step, double delta_t)
{
    if(time_step == 0)
    {
        std::string path = std::string("NBody_") + std::to_string(this->N) + std::string(".dat");
        output_file.open(path, std::ofstream::binary | std::ofstream::trunc);
    }
    double curr_time = time_step * delta_t;
    output_file.write(reinterpret_cast<char*>(&curr_time), sizeof(curr_time));
    output_file.write(reinterpret_cast<char*>(mass), sizeof(*mass)*N);
    output_file.write(reinterpret_cast<char*>(pos[X]), sizeof(*pos[X])*N);
    output_file.write(reinterpret_cast<char*>(pos[Y]), sizeof(*pos[Y])*N);
    output_file.write(reinterpret_cast<char*>(pos[Z]), sizeof(*pos[Z])*N);
    output_file.write(reinterpret_cast<char*>(vel[X]), sizeof(*vel[X])*N);
    output_file.write(reinterpret_cast<char*>(vel[Y]), sizeof(*vel[Y])*N);
    output_file.write(reinterpret_cast<char*>(vel[Z]), sizeof(*vel[Z])*N);
    output_file.write(reinterpret_cast<char*>(force[X]), sizeof(*force[X])*N);
    output_file.write(reinterpret_cast<char*>(force[Y]), sizeof(*force[Y])*N);
    output_file.write(reinterpret_cast<char*>(force[Z]), sizeof(*force[Z])*N);
}

void NBody_system::init_particles(size_t N)
{
    alloc_particles(N, N);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<double> mass_dist(0.0,1000000.0);
    std::uniform_real_distribution<double> pos_dist(-1.0,1.0);
    std::uniform_real_distribution<double> vel_dist(-0.01,0.01);
    for(size_t i = 0;i < N; i++)
    {
        mass[i] = mass_dist(gen);
        pos[X][i] = pos_dist(gen);
        pos[Y][i] = pos_dist(gen);
        pos[Z][i] = pos_dist(gen);
        vel[X][i] = vel_dist(gen);
        vel[Y][i] = vel_dist(gen);
        vel[Z][i] = vel_dist(gen);
        force[X][i] = 0.0;
        force[Y][i] = 0.0;
        force[Z][i] = 0.0;
    }
}

void NBody_system::init_orbiting_particles(size_t N, double R, double omega)
{  
    alloc_particles(N, N);

    for(size_t i = 0;i < N; i++)
    {
        pos[X][i] =  R * std::cos( i * 2 * M_PI / N);
        pos[Y][i] =  R * std::sin( i * 2 * M_PI / N);
        pos[Z][i] =  0.0;
        vel[X][i] = -R * omega * std::sin( i * 2 * M_PI / N);
        vel[Y][i] =  R * omega * std::cos( i * 2 * M_PI / N);
        vel[Z][i] =  0.0;
        force[X][i] = 0.0;
        force[Y][i] = 0.0;
        force[Z][i] = 0.0;
    }

    double total_mass = R*R*R * omega * omega / G;
    double sum = 0.0;
    for(size_t i = 1;i <= (N-1)/2;i++)
    {
        sum += (2.0 + 2.0 * std::cos(( M_PI * (N - 2*i))/N)) / std::pow(2.0 - 2.0 * std::cos(i * 2 * M_PI / N), 3.0/2.0);
    }
    if(N % 2 == 0)
        sum += 1.0/4.0;
    total_mass /= sum;
    for(size_t i = 0; i < N; i++)
        mass[i] = total_mass;
}

void NBody_system::init_stable_orbiting_particles(size_t N, double R, double omega, double ratio)
{   
    alloc_particles(N, N);
    N -= 1; //The last planet is in the center
    for(size_t i = 0;i < N; i++)
    {
        pos[X][i] =  R * std::cos( i * 2 * M_PI / N);
        pos[Y][i] =  R * std::sin( i * 2 * M_PI / N);
        pos[Z][i] =  0.0;
        vel[X][i] = -R * omega * std::sin( i * 2 * M_PI / N);
        vel[Y][i] =  R * omega * std::cos( i * 2 * M_PI / N);
        vel[Z][i] =  0.0;
        force[X][i] = 0.0;
        force[Y][i] = 0.0;
        force[Z][i] = 0.0;
    }

    double total_mass = R*R*R * omega * omega / G;
    double sum = 0.0;
    for(size_t i = 1;i <= (N-1)/2;i++)
    {
        sum += (2.0 + 2.0 * std::cos(( M_PI * (N - 2*i))/N)) / std::pow(2.0 - 2.0 * std::cos(i * 2 * M_PI / N), 3.0/2.0);
    }
    if(N % 2 == 0)
        sum += 1.0/4.0;
    sum += ratio;
    total_mass /= sum;
    for(size_t i = 0; i < N; i++)
        mass[i] = total_mass;
    mass[N] = ratio * total_mass;
    pos[X][N] =  0.0;
    pos[Y][N] =  0.0;
    pos[Z][N] =  0.0;
    vel[X][N] =  0.0;
    vel[Y][N] =  0.0;
    vel[Z][N] =  0.0;
    force[X][N] = 0.0;
    force[Y][N] = 0.0;
    force[Z][N] = 0.0;
}



void print_particles_vectorized(double* mass, double *pos[DIM], double *vel[DIM], double *force[DIM], size_t N, size_t rank, size_t comm_sz)
{
    if(rank == 0)
        printf("Particles in the System:\n");
    for(size_t i = 0;i < N;i++)
    {
        printf("Particle%zu:\n",i*comm_sz+rank);
        printf("Mass = %f\n", mass[i*comm_sz+rank]);
        printf("Position = [%f,%f,%f]\n",pos[X][i],pos[Y][i],pos[Z][i]); 
        printf("Velocity = [%.12f,%.12f,%.12f]\n",vel[X][i],vel[Y][i],vel[Y][i]);
        printf("Force = [%f,%f,%f]\n\n",force[X][i],force[Y][i],force[Z][i]);
    }
    fflush(stdout);
}

void print_particles_contiguous(double* mass, double *pos[DIM], double *vel[DIM], double *force[DIM], size_t N, size_t offset)
{
    if(offset == 0)
        printf("Particles in the System:\n");
    for(size_t i = 0;i < N;i++)
    {
        printf("Particle%zu:\n",i + offset);
        printf("Mass = %f\n", mass[i + offset]);
        printf("Position = [%f,%f,%f]\n",pos[X][i],pos[Y][i],pos[Z][i]); 
        printf("Velocity = [%.12f,%.12f,%.12f]\n",vel[X][i],vel[Y][i],vel[Z][i]);
        printf("Force = [%f,%f,%f]\n\n",force[X][i],force[Y][i],force[Z][i]);
    }
    fflush(stdout);
}

void print_deviation(double *calc[DIM], double *ref[DIM], const char* data_kind, size_t N, bool verbose)
{
        double diff_mean = 0.0;
        for(size_t i = 0; i < N; i++)
        {
            double diff[DIM];
            diff[X] = calc[X][i] - ref[X][i];
            diff[Y] = calc[Y][i] - ref[Y][i];
            diff[Z] = calc[Z][i] - ref[Z][i];
            diff_mean += std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
            if(verbose)
            {    
                printf("calc_%s[%zu]=[%f,%f,%f]\n", data_kind, i, calc[X][i], calc[Y][i], calc[Z][i]);
                printf("ref_%s[%zu] =[%f,%f,%f]\n", data_kind, i, ref[X][i], ref[Y][i], ref[Z][i]);
                printf("%s_diff[%zu] =[%f,%f,%f]\n\n", data_kind, i, diff[X], diff[Y], diff[Z]);
            }
        }
        diff_mean/=N;
        printf("Average %s deviation from reference: %.13f\n", data_kind, diff_mean);
}


