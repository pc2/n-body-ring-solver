#ifndef EXECUTION_DATA_H_
#define EXECUTION_DATA_H_

#include <vector>
#include <string>  
#include <cmath>
#include "CL/opencl.h"

struct Execution_data
{
public:
    Execution_data() = delete;
    Execution_data(int rank, int comm_sz, int CU, int local_PE_dim, int remote_PE_dim, const std::string& integration_kind, int order, const std::string& solver_type, bool debug, const std::string& suffix);
    ~Execution_data();

    void init();
    void delete_execution_data();
private:
    void find_platform();
    void find_devices();
    void print_device_info();
    void create_context();
    void create_command_queue();
    void create_program();
public:
    
    size_t rank;
    size_t comm_sz;
    size_t CU;
    size_t local_PE_dim;
    size_t remote_PE_dim;

    size_t num_devices;
    cl_platform_id platform;
    std::vector<cl_device_id> device;
    cl_context context;
    std::vector<cl_program> program;
    
    std::vector<cl_command_queue> compute_queue;
    std::vector<cl_command_queue> recv_queue;
    std::vector<cl_command_queue> send_queue;
    std::vector<cl_command_queue> cache_queue;

    std::vector<cl_command_queue> local_part_buffer_queue;
    std::vector<cl_command_queue> remote_part_buffer_queue;
    std::vector<cl_command_queue> local_force_cache_queue;
    std::vector<cl_command_queue> remote_force_cache_queue;
    std::vector<cl_command_queue> remote_force_comm_queue;
    std::vector<cl_command_queue> integrator_queue;
    
    std::vector<cl_kernel> compute_kernel;
    std::vector<cl_kernel> recv_kernel;
    std::vector<cl_kernel> send_kernel;
    std::vector<cl_kernel> cache_kernel;

    //extra Kernels for lrb_no_sync
    std::vector<cl_kernel> local_part_buffer_kernel;
    std::vector<cl_kernel> remote_part_buffer_kernel;
    std::vector<cl_kernel> local_force_cache_kernel;
    std::vector<cl_kernel> remote_force_cache_kernel;
    std::vector<cl_kernel> remote_force_comm_kernel;
    std::vector<cl_kernel> integrator_kernel;

    bool is_emulation;
    std::string platform_name;
    
    bool debug;

    std::string integration_kind;
    size_t order;
    const double c_2[2] = {0.5,0.5};
    const double d_2[1] = {1.0};

    const double w0 = -std::cbrt(2.0)/(2.0-std::cbrt(2.0));
    const double w1 = 1.0/(2.0-std::cbrt(2.0));
        
    const double c_4[4] = {w1/2.0,(w0+w1)/2.0,(w0+w1)/2.0,w1/2.0};
    const double d_4[3] = {w1,w0,w1};
        
    const double w6_1 = -1.17767998417887;
    const double w6_2 = 0.235573213359357;
    const double w6_3 = 0.78451361047756;
    const double w6_0 = 1.0-2.0 * (w6_1 + w6_2 + w6_3);

    const double c_6[8] = {w6_3/2.0, (w6_3+w6_2)/2.0, (w6_2+w6_1)/2.0, (w6_1+w6_0)/2.0, (w6_1+w6_0)/2.0, (w6_2+w6_1)/2.0, (w6_3+w6_2)/2.0,  w6_3/2.0};
    const double d_6[7] = {w6_3,w6_2,w6_1,w6_0,w6_1,w6_2,w6_3};

    const double* c;
    const double* d;
    size_t lf_steps;

    std::string solver_type;
    std::string suffix;
};
#endif
