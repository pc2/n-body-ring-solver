#ifndef NBODY_SYSTEM_H
#define NBODY_SYSTEM_H

#include <fstream>
#define DIM 3
#define X 0
#define Y 1
#define Z 2

constexpr double G = 1;//6.6743e-11;

enum class Execution_type
{
    OMP, OMP_CACHE, OMP_WEAK, OMP_STRONG,
    MPI_BANDWIDTH,
    HYBRID, HYBRID_WEAK, HYBRID_STRONG
};

enum class Integration_kind
{
    EULER, LEAP_FROG, RUNGE_KUTTA
};

enum class Vectorization_type
{
    AVX2,AVX512,AVX2RSQRT,AVX512RSQRT,AVX512RSQRT4I
};

enum class Solver_type
{
    FULL,REDUCED
};


struct NBody_system
{
    size_t N = 0;
    size_t local_N = 0;
    double* mass = nullptr;
    double *pos[DIM] = {nullptr, nullptr, nullptr};
    double *vel[DIM] = {nullptr, nullptr, nullptr};
    double *force[DIM] = {nullptr, nullptr, nullptr};
    std::ofstream output_file;

    NBody_system();
    NBody_system(const NBody_system& rhs);
    NBody_system& operator=(const NBody_system& rhs);
    ~NBody_system();
    
    void alloc_particles(size_t N, size_t local_N);
    void delete_particles();

    void save_particles(size_t time_step, double delta_t); 
    void init_particles(size_t N);
    void init_orbiting_particles(size_t N, double R, double omega);
    void init_stable_orbiting_particles(size_t N, double R, double omega, double ratio);

    static constexpr double G = 1;//6.6743e-11;
};


void print_particles_vectorized(double* mass, double *pos[DIM], double *vel[DIM], double *force[DIM], size_t N, size_t rank, size_t comm_sz);
void print_particles_contiguous(double* mass, double *pos[DIM], double *vel[DIM], double *force[DIM], size_t N, size_t offset);
void print_particles_sync(double* mass, double *pos[DIM], double *vel[DIM], double *force[DIM], size_t N, bool contiguous);
    
void print_deviation(double *calc[DIM], double *ref[DIM], const char* data_kind, size_t N, bool verbose=false);
#endif
