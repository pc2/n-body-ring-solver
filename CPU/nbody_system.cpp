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
    force{nullptr, nullptr, nullptr},
    mass_sp(nullptr),
    pos_sp{nullptr, nullptr, nullptr},
    vel_sp{nullptr, nullptr, nullptr},
    force_sp{nullptr, nullptr, nullptr}
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

        memcpy(mass_sp, rhs.mass_sp, N*sizeof(float));
        memcpy(pos_sp[X], rhs.pos_sp[X], N*sizeof(float));
        memcpy(pos_sp[Y], rhs.pos_sp[Y], N*sizeof(float));
        memcpy(pos_sp[Z], rhs.pos_sp[Z], N*sizeof(float));
        memcpy(vel_sp[X], rhs.vel_sp[X], N*sizeof(float));
        memcpy(vel_sp[Y], rhs.vel_sp[Y], N*sizeof(float));
        memcpy(vel_sp[Z], rhs.vel_sp[Z], N*sizeof(float));
        memcpy(force_sp[X], rhs.force_sp[X], N*sizeof(float));
        memcpy(force_sp[Y], rhs.force_sp[Y], N*sizeof(float));
        memcpy(force_sp[Z], rhs.force_sp[Z], N*sizeof(float));
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

            memcpy(mass_sp, rhs.mass, N*sizeof(float));
            memcpy(vel_sp[X], rhs.vel_sp[X], N*sizeof(float));
            memcpy(vel_sp[Y], rhs.vel_sp[Y], N*sizeof(float));
            memcpy(vel_sp[Z], rhs.vel_sp[Z], N*sizeof(float));
            memcpy(vel_sp[X], rhs.vel_sp[X], N*sizeof(float));
            memcpy(vel_sp[Y], rhs.vel_sp[Y], N*sizeof(float));
            memcpy(vel_sp[Z], rhs.vel_sp[Z], N*sizeof(float));
            memcpy(force_sp[X], rhs.force_sp[X], N*sizeof(float));
            memcpy(force_sp[Y], rhs.force_sp[Y], N*sizeof(float));
            memcpy(force_sp[Z], rhs.force_sp[Z], N*sizeof(float));
        }
    }
    return *this;
}

void NBody_system::alloc_particles(size_t N, size_t local_N)
{
    this->N = N;
    this->local_N = local_N;
    mass = (double*)aligned_alloc(64, N*sizeof(double));
    mass_sp = (float*)aligned_alloc(64, N*sizeof(float));
    for(size_t d = 0;d < DIM;d++)
    {
        pos[d] = (double*)aligned_alloc(64, N*sizeof(double));
        vel[d] = (double*)aligned_alloc(64, local_N*sizeof(double));
        force[d] = (double*)aligned_alloc(64, local_N*sizeof(double));

        pos_sp[d] = (float*)aligned_alloc(64, N*sizeof(float));
        vel_sp[d] = (float*)aligned_alloc(64, local_N*sizeof(float));
        force_sp[d] = (float*)aligned_alloc(64, local_N*sizeof(float));
    }
}


void NBody_system::delete_particles()
{
    if(mass){std::free(mass);mass = nullptr;}
    if(mass_sp){std::free(mass_sp);mass_sp = nullptr;}
    for(size_t d = 0;d < DIM;d++)
    {
        if(pos[d]){std::free(pos[d]);pos[d] = nullptr;}
        if(vel[d]){std::free(vel[d]);vel[d] = nullptr;}
        if(force[d]){std::free(force[d]);force[d] = nullptr;}

        if(pos_sp[d]){std::free(pos_sp[d]);pos_sp[d] = nullptr;}
        if(vel_sp[d]){std::free(vel_sp[d]);vel_sp[d] = nullptr;}
        if(force_sp[d]){std::free(force_sp[d]);force_sp[d] = nullptr;}
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
        mass_sp[i] = float(mass[i]);

        pos[X][i] = pos_dist(gen);
        pos[Y][i] = pos_dist(gen);
        pos[Z][i] = pos_dist(gen);
        pos_sp[X][i] = float(pos[X][i]);
        pos_sp[Y][i] = float(pos[Y][i]);
        pos_sp[Z][i] = float(pos[Z][i]);

        vel[X][i] = vel_dist(gen);
        vel[Y][i] = vel_dist(gen);
        vel[Z][i] = vel_dist(gen);
        vel_sp[X][i] = float(vel[X][i]);
        vel_sp[Y][i] = float(vel[Y][i]);
        vel_sp[Z][i] = float(vel[Z][i]);

        force[X][i] = 0.0;
        force[Y][i] = 0.0;
        force[Z][i] = 0.0;
        force_sp[X][i] = float(force[X][i]);
        force_sp[Y][i] = float(force[Y][i]);
        force_sp[Z][i] = float(force[Z][i]);
        
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
        force[X][i] = 0.0;//-R * omega * omega * std::cos( i * 2 * M_PI / N);
        force[Y][i] = 0.0;//-R * omega * omega * std::sin( i * 2 * M_PI / N);
        force[Z][i] = 0.0;

        pos_sp[X][i] = float(pos[X][i]);
        pos_sp[Y][i] = float(pos[Y][i]);
        pos_sp[Z][i] = float(pos[Z][i]);
        vel_sp[X][i] = float(vel[X][i]);
        vel_sp[Y][i] = float(vel[Y][i]);
        vel_sp[Z][i] = float(vel[Z][i]);
        force_sp[X][i] = float(force[X][i]);
        force_sp[Y][i] = float(force[Y][i]);
        force_sp[Z][i] = float(force[Z][i]);
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
    {
        mass[i] = total_mass;
        mass_sp[i] = float(total_mass);
    }
}

void NBody_system::init_stable_orbiting_particles(size_t N, double R, double omega, double ratio)
{   
    alloc_particles(N, N);
    N -= 1; //The last planet is in the center

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

    for(size_t i = 0;i < N; i++)
    {
        mass[i] = total_mass;
        mass_sp[i] = float(total_mass);

        pos[X][i] =  R * std::cos( i * 2 * M_PI / N);
        pos[Y][i] =  R * std::sin( i * 2 * M_PI / N);
        pos[Z][i] =  0.0;
        vel[X][i] = -R * omega * std::sin( i * 2 * M_PI / N);
        vel[Y][i] =  R * omega * std::cos( i * 2 * M_PI / N);
        vel[Z][i] =  0.0;
        force[X][i] = -G * mass[i] * R * omega * omega * std::cos( i * 2 * M_PI / N);
        force[Y][i] = -G * mass[i] * R * omega * omega * std::sin( i * 2 * M_PI / N);
        force[Z][i] = 0.0;

        pos_sp[X][i] = float(pos[X][i]);
        pos_sp[Y][i] = float(pos[Y][i]);
        pos_sp[Z][i] = float(pos[Z][i]);
        vel_sp[X][i] = float(vel[X][i]);
        vel_sp[Y][i] = float(vel[Y][i]);
        vel_sp[Z][i] = float(vel[Z][i]);
        force_sp[X][i] = float(force[X][i]);
        force_sp[Y][i] = float(force[Y][i]);
        force_sp[Z][i] = float(force[Z][i]);
    }

    mass[N] = ratio * total_mass;
    mass_sp[N] = float(ratio * total_mass);


    pos[X][N] =  0.0;
    pos[Y][N] =  0.0;
    pos[Z][N] =  0.0;
    vel[X][N] =  0.0;
    vel[Y][N] =  0.0;
    vel[Z][N] =  0.0;
    force[X][N] = 0.0;
    force[Y][N] = 0.0;
    force[Z][N] = 0.0;

    pos_sp[X][N] = float(pos[X][N]);
    pos_sp[Y][N] = float(pos[Y][N]);
    pos_sp[Z][N] = float(pos[Z][N]);
    vel_sp[X][N] = float(vel[X][N]);
    vel_sp[Y][N] = float(vel[Y][N]);
    vel_sp[Z][N] = float(vel[Z][N]);
    force_sp[X][N] = float(force[X][N]);
    force_sp[Y][N] = float(force[Y][N]);
    force_sp[Z][N] = float(force[Z][N]);
}

void NBody_system::predict_stable_orbiting_particles(double R, double omega, size_t curr_time_step, size_t total_time_steps)
{
    size_t N = this->N-1;

    double time_offset = (double(curr_time_step)/double(total_time_steps));
    for(int i = 0;i < N; i++)
    {
        double theta = (double(i)/double(N) + time_offset) * 2 * M_PI;
        pos[X][i] =  R * std::cos(theta);
        pos[Y][i] =  R * std::sin(theta);
        pos[Z][i] =  0.0;
        vel[X][i] = -R * omega * std::sin(theta);
        vel[Y][i] =  R * omega * std::cos(theta);
        vel[Z][i] =  0.0;
    }

    pos[X][N] = 0.0;
    pos[Y][N] = 0.0;
    pos[Z][N] = 0.0;
    vel[X][N] = 0.0; 
    vel[Y][N] = 0.0; 
    vel[Z][N] = 0.0;
}

template<typename T>
void apply_permutation_to_array(T* arr, size_t* p, size_t N)
{
    T* cpy = new T[N];
    for(size_t i = 0;i < N;i++)
    {
        cpy[i] = arr[p[i]];
    }
    std::copy(&cpy[0], &cpy[N], arr);
}

void NBody_system::apply_permutation(size_t* permutation)
{
    apply_permutation_to_array<double>(pos[X],permutation, this->N);
    apply_permutation_to_array<double>(pos[Y],permutation, this->N);
    apply_permutation_to_array<double>(pos[Z],permutation, this->N);

    apply_permutation_to_array<double>(vel[X],permutation, this->N);
    apply_permutation_to_array<double>(vel[Y],permutation, this->N);
    apply_permutation_to_array<double>(vel[Z],permutation, this->N);

    apply_permutation_to_array<double>(force[X],permutation, this->N);
    apply_permutation_to_array<double>(force[Y],permutation, this->N);
    apply_permutation_to_array<double>(force[Z],permutation, this->N);

    apply_permutation_to_array<double>(mass,permutation, this->N);

    apply_permutation_to_array<float>(pos_sp[X],permutation, this->N);
    apply_permutation_to_array<float>(pos_sp[Y],permutation, this->N);
    apply_permutation_to_array<float>(pos_sp[Z],permutation, this->N);

    apply_permutation_to_array<float>(vel_sp[X],permutation, this->N);
    apply_permutation_to_array<float>(vel_sp[Y],permutation, this->N);
    apply_permutation_to_array<float>(vel_sp[Z],permutation, this->N);

    apply_permutation_to_array<float>(force_sp[X],permutation, this->N);
    apply_permutation_to_array<float>(force_sp[Y],permutation, this->N);
    apply_permutation_to_array<float>(force_sp[Z],permutation, this->N);

    apply_permutation_to_array<float>(mass_sp,permutation, this->N);
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

double calculate_deviation(double *calc[DIM], double *ref[DIM], size_t N)
{
    double diff_mean = 0.0;
    for(size_t i = 0; i < N; i++)
    {
        double diff[DIM];
        diff[X] = calc[X][i] - ref[X][i];
        diff[Y] = calc[Y][i] - ref[Y][i];
        diff[Z] = calc[Z][i] - ref[Z][i];
        diff_mean += std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
    }
    diff_mean/=N;
    return diff_mean;
}

std::array<double, 6> calculate_force_error(const NBody_system& sys, const NBody_system& ref, Data_type data_type, bool verbose)
{
    double error = 0.0;
    double length_error = 0.0;
    double max_length_error = 0.0;
    double angle_error = 0.0;
    double max_angle_error = 0.0;
    double largest_diff_length = 0.0;
    bool print_cond = false;
    for(size_t i = 0;i < sys.N;i++)
    {
        double diff[DIM];
        if(data_type == Data_type::DOUBLE_PRECISION)
        {
            diff[X] = sys.force[X][i] - ref.force[X][i];
            diff[Y] = sys.force[Y][i] - ref.force[Y][i];
            diff[Z] = sys.force[Z][i] - ref.force[Z][i];
            double diff_length = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
            double sys_length = std::sqrt(sys.force[X][i]*sys.force[X][i] + sys.force[Y][i]*sys.force[Y][i] + sys.force[Z][i]*sys.force[Z][i]);
            double ref_length = std::sqrt(ref.force[X][i]*ref.force[X][i] + ref.force[Y][i]*ref.force[Y][i] + ref.force[Z][i]*ref.force[Z][i]);
            double dot_prod = sys.force[X][i]*ref.force[X][i] + sys.force[Y][i]*ref.force[Y][i];
            double det_prod = sys.force[X][i]*ref.force[Y][i] - sys.force[Y][i]*ref.force[X][i];
            double length_diff = abs(sys_length-ref_length);
            double angle = abs(std::atan2(det_prod,dot_prod));
            if(diff_length > largest_diff_length)
            {
                largest_diff_length = diff_length;
                print_cond = true;
            }
            if(length_diff > max_length_error)
            {
                max_length_error = length_diff;
                print_cond = true;
            }
            if(angle > max_angle_error && ref.force[X][i] != 0.0 && ref.force[Y][i] != 0.0)
            {
                max_angle_error = angle;
                print_cond = true;
            }
            error += diff_length;
            if(ref.force[X][i] != 0.0 && ref.force[Y][i] != 0.0)
                angle_error += angle;
            length_error += length_diff;

            if(verbose && print_cond)
            {    
                printf("sys_force[%zu]=[%.4e,%.4e,%.4e]\n", i, sys.force[X][i], sys.force[Y][i], sys.force[Z][i]);
                printf("ref_force[%zu]=[%.4e,%.4e,%.4e]\n", i, ref.force[X][i], ref.force[Y][i], ref.force[Z][i]);
                printf("diff[%zu]     =[%.4e,%.4e,%.4e]\n", i, diff[X], diff[Y], diff[Z]);
                printf("|diff[%zu]|   = %.4e\n", i, std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]));
                printf("sys_length[%zu] = %.4e\n",i , sys_length);
                printf("ref_length[%zu] = %.4e\n",i , ref_length);
                printf("max|diff|   = %.4e\n", largest_diff_length);
                printf("angle: %.6e\n", angle);
                printf("dot_prod: %.6e\n", dot_prod);
                printf("det_prods = %.6e\n\n",det_prod);
                print_cond = false;
            }
        }
        else
        {
            diff[X] = double(sys.force_sp[X][i] - ref.force_sp[X][i]);
            diff[Y] = double(sys.force_sp[Y][i] - ref.force_sp[Y][i]);
            diff[Z] = double(sys.force_sp[Z][i] - ref.force_sp[Z][i]);
            double diff_length = std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
            double sys_length = std::sqrt(sys.force_sp[X][i]*sys.force_sp[X][i] + sys.force_sp[Y][i]*sys.force_sp[Y][i] + sys.force_sp[Z][i]*sys.force_sp[Z][i]);
            double ref_length = std::sqrt(ref.force_sp[X][i]*ref.force_sp[X][i] + ref.force_sp[Y][i]*ref.force_sp[Y][i] + ref.force_sp[Z][i]*ref.force_sp[Z][i]);
            double dot_prod = sys.force_sp[X][i]*ref.force_sp[X][i] + sys.force_sp[Y][i]*ref.force_sp[Y][i];
            double det_prod = double(sys.force_sp[X][i])*double(ref.force_sp[Y][i]) - double(sys.force_sp[Y][i])*double(ref.force_sp[X][i]);
            double length_diff = abs(sys_length-ref_length);
            double angle = abs(std::atan2(det_prod,dot_prod));
            if(diff_length > largest_diff_length)
            {
                largest_diff_length = diff_length;
                print_cond = true;
            }
            if(length_diff > max_length_error)
            {
                max_length_error = length_diff;
                print_cond = true;
            }
            if(angle > max_angle_error && ref.force_sp[X][i] != 0.0f && ref.force_sp[Y][i] != 0.0f)
            {
                max_angle_error = angle;
                print_cond = true;
            }
            error += std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]);
            if(ref.force_sp[X][i] != 0.0f && ref.force_sp[Y][i] != 0.0f)
                angle_error += angle;
            length_error += abs(sys_length-ref_length);

            if(verbose && print_cond)
            {    
                printf("sys_force_sp[%zu]=[%.4e,%.4e,%.4e]\n", i, sys.force_sp[X][i], sys.force_sp[Y][i], sys.force_sp[Z][i]);
                printf("ref_force_sp[%zu]=[%.4e,%.4e,%.4e]\n", i, ref.force_sp[X][i], ref.force_sp[Y][i], ref.force_sp[Z][i]);
                printf("diff[%zu]     =[%.4e,%.4e,%.4e]\n", i, diff[X], diff[Y], diff[Z]);
                printf("|diff[%zu]|   = %.4e\n", i, std::sqrt(diff[X]*diff[X] + diff[Y]*diff[Y] + diff[Z]*diff[Z]));
                printf("sys_length[%zu] = %.4e\n",i , sys_length);
                printf("ref_length[%zu] = %.4e\n",i , ref_length);
                printf("max|diff|   = %.4e\n", largest_diff_length);
                printf("angle: %.6e\n", angle);
                printf("dot_prod: %.6e\n", dot_prod);
                printf("det_prods = %.6e\n\n",det_prod);
                print_cond = false;
            }
        }

    }
    double ref_length = std::sqrt(ref.force_sp[X][0]*ref.force_sp[X][0] + ref.force_sp[Y][0]*ref.force_sp[Y][0] + ref.force_sp[Z][0]*ref.force_sp[Z][0]);
    printf("ref_length = %f\n", ref_length);
    return {error/sys.N, largest_diff_length, angle_error/(2*M_PI*sys.N), length_error/(ref_length*sys.N), max_angle_error/(2*M_PI), max_length_error/ref_length};
}
