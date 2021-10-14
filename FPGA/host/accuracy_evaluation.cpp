#include "accuracy_evaluation.h"
#include <cmath>
#include <stdio.h>
#include <chrono>
#include <omp.h>
#define EPS2 0.0//1e-6

double calculate_kinetic_energy(cl_double* mass, cl_double3* vel, size_t N)
{
    double T = 0.0;
    for(size_t i = 0;i < N;i++)
    {
        T += mass[i] * (vel[i].x*vel[i].x+vel[i].y*vel[i].y+vel[i].z*vel[i].z);
    }
    return T/2.0;
}

double calculate_potential_energy(cl_double G, cl_double* mass, cl_double3* pos, size_t N)
{
    
    double total_U = 0.0;
    auto start = std::chrono::high_resolution_clock::now();
    #pragma omp parallel
    {
        double U = 0.0;
        #pragma omp for schedule(static,1)
        for(size_t i = 0;i < N;i++)
        {
            for(size_t j = i+1;j < N;j++)
            {
                    cl_double3 diff;
                    diff.x = pos[i].x - pos[j].x;
                    diff.y = pos[i].y - pos[j].y;
                    diff.z = pos[i].z - pos[j].z;
                    cl_double dist = std::sqrt(diff.x*diff.x+diff.y*diff.y+diff.z*diff.z+EPS2);
                    U += mass[i] * mass[j] / dist;
            }
        }
        #pragma omp critical
        total_U += U;
    }
    auto end = std::chrono::high_resolution_clock::now();
    printf("time for potential energy: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    return -G*total_U;
}

double calculate_inertia(cl_double* mass, cl_double3* pos, size_t N)
{
    double I = 0.0;
    for(size_t i = 0;i < N;i++)
    {
        I += mass[i] * (pos[i].x*pos[i].x+pos[i].y*pos[i].y+pos[i].z*pos[i].z);
    }
    return I;
}

double calculate_deviation(cl_double3* calc, cl_double3* ref, const char* data_kind, size_t N, bool absolute, bool verbose)
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
    return diff_mean;
}

void init_orbiting_particles(cl_double K, cl_double** mass,cl_double3** pos, cl_double3** vel, cl_double3** force,  int N, double R, double omega, double ratio)
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
        sum += (2.0 + 2.0 * std::cos(( M_PI * (N - 2*i))/N)) / std::pow(2.0 - 2.0 * std::cos(i * 2 * M_PI / N) + EPS2, 3.0/2.0);
    }
    if(N % 2 == 0)
        sum += 1.0/4.0;

    printf("sum = %f\n", sum);
    //ratio = 99*sum;
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

void predict_orbiting_particles(cl_double3* pos, cl_double3* vel, int N, double R, double omega, size_t curr_time_step, size_t total_time_steps, double num_revolutions)
{
    N -= 1;

    double time_offset = num_revolutions * (double(curr_time_step)/double(total_time_steps));
    for(int i = 0;i < N; i++)
    {
        double theta = (double(i)/double(N) + time_offset) * 2 * M_PI;
        pos[i].x =  R * std::cos(theta);
        pos[i].y =  R * std::sin(theta);
        pos[i].z =  0.0;
        vel[i].x = -R * omega * std::sin(theta);
        vel[i].y =  R * omega * std::cos(theta);
        vel[i].z =  0.0;
    }

    pos[N].x = 0.0;
    pos[N].y = 0.0;
    pos[N].z = 0.0;
    vel[N].x = 0.0; 
    vel[N].y = 0.0; 
    vel[N].z = 0.0;
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