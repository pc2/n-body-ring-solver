#include "solver.h"
#include "error.h"
#include <stdio.h>
#include <chrono>
#include "mpi.h"
#include "CL/cl_ext_intelfpga.h"
#include "/opt/intelFPGA_pro/19.2.0/hld/board/custom_platform_toolkit/mmd/aocl_mmd.h"
#include <cmath>

double solver(Execution_data* exec_data, cl_double K, cl_double* mass, cl_double* coeff, cl_double3* pos, cl_double3* vel, cl_double3* force, size_t N, size_t time_steps, cl_double delta_t, cl_double predicted_time)
{

    double exec_time = 0.0;

    cl_int status;
    cl_mem mass_mem[exec_data->num_devices];
    cl_mem coeff_mem[exec_data->num_devices];
    cl_mem recv_coeff_mem[exec_data->num_devices];
    cl_mem pos_mem[exec_data->num_devices];
    cl_mem recv_pos_mem[exec_data->num_devices];
    cl_mem vel_mem[exec_data->num_devices];
    cl_mem force_mem[exec_data->num_devices];
    cl_mem recv_force_mem[exec_data->num_devices];
    
    //Coefficients for LF integration
    cl_mem c_mem[exec_data->num_devices];
    cl_mem d_mem[exec_data->num_devices];

    size_t local_N = N/(exec_data->comm_sz*exec_data->num_devices);

    cl_double* local_mass = new cl_double[local_N];
    cl_double* local_coeff = new cl_double[local_N];
    cl_double3* local_pos = new cl_double3[local_N];
    cl_double3* local_vel = new cl_double3[local_N];
    cl_double3* local_force = new cl_double3[local_N];
    cl_double3* recv_pos = new cl_double3[local_N];
    cl_double3* recv_force = new cl_double3[local_N];

    cl_double* recv_coeff = new cl_double[N];
    if(exec_data->rank == 0)
    {
        for(int i = 0;i < N;i++)
        {
            recv_coeff[i] = K * coeff[i];
        }
    }


    typedef void* (*aocl_mmd_card_info_fn_t)(const char*, aocl_mmd_info_t, size_t, void*, size_t*);
    aocl_mmd_card_info_fn_t aocl_mmd_card_info_fn = NULL;
    clGetBoardExtensionFunctionAddressIntelFPGA_fn clGetBoardExtensionFunctionAddressIntelFPGA = NULL;
    void *tempPointer = NULL;

    if(!exec_data->is_emulation)
        clGetBoardExtensionFunctionAddressIntelFPGA = (clGetBoardExtensionFunctionAddressIntelFPGA_fn)clGetExtensionFunctionAddressForPlatform(exec_data->platform, "clGetBoardExtensionFunctionAddressIntelFPGA");
    if (clGetBoardExtensionFunctionAddressIntelFPGA == NULL)
    {
        printf ("Failed to get clGetBoardExtensionFunctionAddressIntelFPGA\n");
    }

    tempPointer = NULL;
    if(!exec_data->is_emulation)
    {
        tempPointer = clGetBoardExtensionFunctionAddressIntelFPGA("aocl_mmd_card_info",exec_data->device[0]);
        aocl_mmd_card_info_fn =   (aocl_mmd_card_info_fn_t)tempPointer;
    }
    if (aocl_mmd_card_info_fn == NULL )
    {
        printf ("Failed to get aocl_mmd_card_info_fn address\n");
    }

    int fpga_comm_sz = exec_data->comm_sz * exec_data->num_devices;
    MPI_Bcast(recv_coeff, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    for(int dev = 0;dev < exec_data->num_devices; dev++)
    {
        int fpga_rank = dev*exec_data->comm_sz + exec_data->rank;
        MPI_Scatter(&pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&mass[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_mass, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&coeff[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_coeff, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        for(int i = 0;i < local_N;i++)
        {
            recv_pos[i] = local_pos[i];
            recv_force[i] = {0.0,0.0,0.0};
            local_force[i] = {0.0,0.0,0.0};
        }
        if(exec_data->debug)printf("Creating mem buffers for device %d\n", dev);
        mass_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, local_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        coeff_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, local_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        recv_coeff_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for recv_mass");
        pos_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, local_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for position");
        recv_pos_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for recv_position");
        vel_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, local_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for velocity");
        force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, local_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for force");
        recv_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for recv_force");
        if(exec_data->integration_kind == "lf")
        {
            c_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, exec_data->lf_steps*sizeof(cl_double), NULL, &status); 
            checkError(status, exec_data, "Failed to create Memory Buffer for recv_force");
            d_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, (exec_data->lf_steps-1)*sizeof(cl_double), NULL, &status); 
            checkError(status, exec_data, "Failed to create Memory Buffer for recv_force");
        }

        if(exec_data->debug)printf("Writing data to device %d\n", dev);
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], mass_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_mass, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], coeff_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_coeff, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->recv_queue[dev], recv_coeff_mem[dev], CL_TRUE, 0, N*sizeof(cl_double), recv_coeff, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to recv_mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], pos_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to position Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], vel_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to velocity Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to force Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->recv_queue[dev], recv_pos_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), recv_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to recv_pos Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->recv_queue[dev], recv_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), recv_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to recv_force Memory Buffer");
        if(exec_data->integration_kind == "lf")
        {
            status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], c_mem[dev], CL_TRUE, 0, exec_data->lf_steps*sizeof(cl_double), exec_data->c, 0, NULL, NULL);
            checkError(status, exec_data, "Failed to write to c coefficients Memory Buffer");
            status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], d_mem[dev], CL_TRUE, 0, (exec_data->lf_steps-1)*sizeof(cl_double), exec_data->d, 0, NULL, NULL);
            checkError(status, exec_data, "Failed to write to d coefficients Memory Buffer");
        }       
        
        //Compute Kernel Arguments
        cl_uint arg_index = 0;
        if(exec_data->debug)printf("Setting compute Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&mass_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&coeff_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&pos_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&vel_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&force_mem[dev]);
        checkError(status, exec_data, "Failed to set force Argument");
        if(exec_data->solver_type == "reduced")
        {
            status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_force_mem[dev]);
            checkError(status, exec_data, "Failed to set force Argument");
        }
        if(exec_data->integration_kind == "lf")
        {
            status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&c_mem[dev]);
            checkError(status, exec_data, "Failed to set force Argument");
            status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&d_mem[dev]);
            checkError(status, exec_data, "Failed to set force Argument");
            status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
            checkError(status, exec_data, "Failed to set rank Argument");
        }
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set rank Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set comm_sz Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_double), &delta_t);
        checkError(status, exec_data, "Failed to set delta_t Argument"); 
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
        fflush(stdout);
       

        //Recv Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting recv Kernel Arguments for device %d\n", dev);
        if(exec_data->solver_type == "full")
        {
            status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_coeff_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
            status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_pos_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
        }
        else if(exec_data->solver_type == "reduced")
        {
            status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_pos_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
            status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_force_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
        }
        if(exec_data->integration_kind == "lf")
        {
            status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
            checkError(status, exec_data, "Failed to set rank Argument");
        }
        printf("argindex = %zu\n",arg_index);
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set rank Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set comm_sz Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &N);
        checkError(status, exec_data, "Failed to set N Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
        
        //Send Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting send Kernel Arguments for device %d\n", dev);
        if(exec_data->solver_type == "full")
        {
            status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_pos_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
        }
        else if(exec_data->solver_type == "reduced")
        {
            status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_coeff_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
            status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_pos_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
            status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&recv_force_mem[dev]);
            checkError(status, exec_data, "Failed to set position Argument");
        }
        if(exec_data->integration_kind == "lf")
        {
            status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
            checkError(status, exec_data, "Failed to set rank Argument");
        }
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set rank Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set comm_sz Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &N);
        checkError(status, exec_data, "Failed to set N Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
        
        if(exec_data->debug)
        {
            printf("fpga_rank: %d\n", fpga_rank);
            printf("fpga_comm_sz: %d\n", fpga_comm_sz);
            printf("local_N: %d\n", local_N);
            printf("N: %d\n", N);
            printf("time_steps: %d\n", time_steps);
            fflush(stdout);
        }
    }
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for Compute kernel");
        status = clFinish(exec_data->recv_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for stream kernel");
    }

    if(exec_data->debug)
    {
        printf("Sucessfully set Arguments\n");
        fflush(stdout);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    if(exec_data->rank == 0)printf("-------- Ring Solver --------\n");
    if(exec_data->rank == 0)printf("N = %d, time_steps = %d\n", N, time_steps);
    if(exec_data->rank == 0)fflush(stdout);
    MPI_Barrier(MPI_COMM_WORLD);
    auto start = std::chrono::high_resolution_clock::now();
    cl_event timing_event[exec_data->num_devices];
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clEnqueueTask(exec_data->compute_queue[i], exec_data->compute_kernel[i], 0, NULL, &timing_event[i]);
        checkError(status, exec_data, "Failed to run compute kernel");
        status = clEnqueueTask(exec_data->recv_queue[i], exec_data->recv_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run recv kernel");
        status = clEnqueueTask(exec_data->send_queue[i], exec_data->send_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run send kernel");
    }
    if(exec_data->debug)
    {
        printf("Started all kernels\n");
        fflush(stdout);
    }

    float average_power = 0.0f;
    size_t num_power_evaluations = 0;
    auto end = std::chrono::high_resolution_clock::now();
    if(!exec_data->is_emulation)
    {
        while(std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count() < predicted_time - 5.0)
        {
            float curr_power0;
            float curr_power1;
            size_t returned_size;
            aocl_mmd_card_info_fn("aclbitt_s10_pcie0", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power0, &returned_size);
            aocl_mmd_card_info_fn("aclbitt_s10_pcie1", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power1, &returned_size);
            end = std::chrono::high_resolution_clock::now();
            average_power += curr_power0 + curr_power1;
            num_power_evaluations++;
            if(exec_data->rank == 0)printf("power: %f\n", average_power/num_power_evaluations);
            if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
            if(exec_data->rank == 0)fflush(stdout);
        }

        if(num_power_evaluations > 0)
            average_power /= num_power_evaluations;
        else
            average_power = -1.0;
    }

    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        clWaitForEvents(1, &timing_event[i]);
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to finish compute kernel");
        status = clFinish(exec_data->recv_queue[i]);
        checkError(status, exec_data, "Failed to finish recv kernel");
        status = clFinish(exec_data->send_queue[i]);
        checkError(status, exec_data, "Failed to finish send kernel");
    }
    
    float gather_power[exec_data->comm_sz];
    MPI_Gather(&average_power,1,MPI_FLOAT, gather_power, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    if(exec_data->rank == 0)
    {
        average_power = 0.0f;
        for(int i = 0;i < exec_data->comm_sz;i++)
            average_power += gather_power[i];

        cl_ulong t_start;
        cl_ulong t_end;
        clGetEventProfilingInfo(timing_event[1], CL_PROFILING_COMMAND_START, sizeof(t_start), &t_start, NULL);
        clGetEventProfilingInfo(timing_event[1], CL_PROFILING_COMMAND_END, sizeof(t_end), &t_end, NULL);
        double elapsed_time = double(t_end - t_start)*1e-9;
        exec_time = elapsed_time;       
        //FILE* pFile = fopen("single_performance.csv","a");
        //double speed_up = 75.54355/elapsed_time;
        //fprintf(pFile, "%d, %f, %f\n",N, mpairs, mpairs_pred);
        //fclose(pFile);
        printf("Power consumption for %d devices: %fs\n", fpga_comm_sz, average_power);

    }
    
    if(exec_data->debug)printf("Sucessfully completed Tasks\n");
    fflush(stdout);

    for(int dev = 0; dev < exec_data->num_devices;dev++)
    {
        if(exec_data->debug)printf("Reading memory back from device %d\n", dev);
        status = clEnqueueReadBuffer(exec_data->compute_queue[dev], pos_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read position Memory Object");
        if(exec_data->debug)printf("Succesfully read positions\n");
        fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->compute_queue[dev], vel_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read velocity Memory Object");
        if(exec_data->debug)printf("Succesfully read velocities\n");
        fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->compute_queue[dev], force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read Force Memory Object");
        if(exec_data->debug)printf("Succesfully read forces\n");
        fflush(stdout);

        clFinish(exec_data->compute_queue[dev]);
        MPI_Gather(local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered positions\n");
        fflush(stdout);
        MPI_Gather(local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered velocities\n");
        fflush(stdout);
        MPI_Gather(local_force, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered forces\n");
        fflush(stdout);
        
        
        clReleaseMemObject(mass_mem[dev]);
        clReleaseMemObject(coeff_mem[dev]);
        clReleaseMemObject(recv_coeff_mem[dev]);
        clReleaseMemObject(pos_mem[dev]);
        clReleaseMemObject(recv_pos_mem[dev]);
        clReleaseMemObject(vel_mem[dev]);
        clReleaseMemObject(force_mem[dev]);
        clReleaseMemObject(recv_force_mem[dev]);
        fflush(stdout);
    }

    delete[] local_coeff;
    delete[] local_mass;
    delete[] local_pos;
    delete[] local_vel;
    delete[] recv_coeff;
    delete[] recv_pos;
    delete[] recv_force;
    return exec_time;
}

double lrb_solver(Execution_data* exec_data, cl_double K, cl_double* mass, cl_double* coeff, cl_double3* pos, cl_double3* vel, cl_double3* force, size_t N, size_t time_steps, cl_double delta_t, cl_double predicted_time)
{
    size_t LATENCY_FACTOR = 16;
    size_t PE_LOCAL_SIZE = 2;
    size_t PE_LOCAL_CNT = 2;

    size_t padding_factor = LATENCY_FACTOR * PE_LOCAL_SIZE * PE_LOCAL_CNT;
    size_t num_blocks = 1 + ((N-1)/padding_factor);
    size_t padded_N = num_blocks * padding_factor;
    double exec_time = 0.0;

    cl_int status;
    cl_mem local_mass_mem[exec_data->num_devices];
    cl_mem local_coeff_mem[exec_data->num_devices];
    cl_mem remote_coeff_mem[exec_data->num_devices];
    cl_mem local_pos_mem[exec_data->num_devices];
    cl_mem remote_pos_mem[exec_data->num_devices];
    cl_mem local_force_mem[exec_data->num_devices];
    cl_mem remote_force_mem[exec_data->num_devices];
    
    cl_mem local_vel_mem[exec_data->num_devices];
    
    //Coefficients for LF integration
    //cl_mem c_mem[exec_data->num_devices];
    //cl_mem d_mem[exec_data->num_devices];

    //size_t local_N = N/(exec_data->comm_sz*exec_data->num_devices);
    size_t local_N = N;
    size_t remote_N = N;


    cl_double* local_mass = new cl_double[local_N];
    cl_double* local_coeff = new cl_double[local_N];
    cl_double* remote_coeff = new cl_double[remote_N];
    
    cl_double3* local_vel = new cl_double3[local_N];
    cl_double3* local_pos = new cl_double3[local_N];
    cl_double3* local_force = new cl_double3[local_N];
    cl_double3* remote_pos = new cl_double3[remote_N];
    cl_double3* remote_force = new cl_double3[remote_N];

    cl_double* recv_coeff = new cl_double[N];
    if(exec_data->rank == 0)
    {
        for(int i = 0;i < N;i++)
        {
            local_coeff[i] = K * coeff[i];
            remote_coeff[i] = coeff[i];
        }
    }

    int fpga_comm_sz = exec_data->comm_sz * exec_data->num_devices;
    //MPI_Bcast(local_coeff, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    for(int dev = 0;dev < exec_data->num_devices; dev++)
    {
        int fpga_rank = dev*exec_data->comm_sz + exec_data->rank;
        MPI_Scatter(&pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&mass[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_mass, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&coeff[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_coeff, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        for(int i = 0;i < remote_N;i++)
        {
            remote_pos[i] = local_pos[i];
            remote_force[i] = {0.0,0.0,0.0};
            if(i < local_N)local_force[i] = {0.0,0.0,0.0};
        }

        if(exec_data->debug)printf("Creating mem buffers for device %d\n", dev);
        local_mass_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        local_coeff_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        remote_coeff_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote_mass");
        local_pos_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for position");
        remote_pos_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote_position");
        local_vel_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for velocity");
        local_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for force");
        remote_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote_force");
        //if(exec_data->integration_kind == "lf")
        //{
        //    c_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, exec_data->lf_steps*sizeof(cl_double), NULL, &status); 
        //    checkError(status, exec_data, "Failed to create Memory Buffer for recv_force");
        //    d_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, (exec_data->lf_steps-1)*sizeof(cl_double), NULL, &status); 
        //    checkError(status, exec_data, "Failed to create Memory Buffer for recv_force");
        //}

        if(exec_data->debug)printf("Writing data to device %d\n", dev);
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_mass_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_mass, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_coeff_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_coeff, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to local coeff Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], remote_coeff_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double), remote_coeff, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to remote coeff Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_pos_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to position Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_vel_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to velocity Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to force Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], remote_pos_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double3), remote_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to recv_pos Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], remote_force_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double3), remote_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to recv_force Memory Buffer");
        //if(exec_data->integration_kind == "lf")
        //{
        //    status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], c_mem[dev], CL_TRUE, 0, exec_data->lf_steps*sizeof(cl_double), exec_data->c, 0, NULL, NULL);
        //    checkError(status, exec_data, "Failed to write to c coefficients Memory Buffer");
        //    status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], d_mem[dev], CL_TRUE, 0, (exec_data->lf_steps-1)*sizeof(cl_double), exec_data->d, 0, NULL, NULL);
        //    checkError(status, exec_data, "Failed to write to d coefficients Memory Buffer");
        //}       
        
        //Compute Kernel Arguments
        cl_uint arg_index = 0;
        if(exec_data->debug)printf("Setting compute Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_coeff_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_pos_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
       

        //Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting cache Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->cache_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_force_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set N Argument");
        status = clSetKernelArg(exec_data->cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
        
        //Remote Recv Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting remote recv Kernel Arguments for device %d\n", dev);;
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_coeff_mem[dev]);
        checkError(status, exec_data, "Failed to set remote position Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_pos_mem[dev]);
        checkError(status, exec_data, "Failed to set remote velocity Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->recv_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");

        arg_index = 0;
        if(exec_data->debug)printf("Setting send Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_pos_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_force_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_pos_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_force_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_vel_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_mass_mem[dev]);
        checkError(status, exec_data, "Failed to set position Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set N Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_step Argument");
        status = clSetKernelArg(exec_data->send_kernel[dev], arg_index++, sizeof(cl_double), &delta_t);
        checkError(status, exec_data, "Failed to set delta_t Argument"); 
        
        if(exec_data->debug)
        {
            printf("fpga_rank: %d\n", fpga_rank);
            printf("fpga_comm_sz: %d\n", fpga_comm_sz);
            printf("local_N: %d\n", local_N);
            printf("N: %d\n", N);
            printf("time_steps: %d\n", time_steps);
            fflush(stdout);
        }
    }
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for Compute kernel");
    }

    if(exec_data->debug)
    {
        printf("Sucessfully set Arguments\n");
        fflush(stdout);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    if(exec_data->rank == 0)printf("-------- Ring Solver --------\n");
    if(exec_data->rank == 0)printf("N = %d, time_steps = %d\n", N, time_steps);
    if(exec_data->rank == 0)fflush(stdout);
    MPI_Barrier(MPI_COMM_WORLD);
    auto start = std::chrono::high_resolution_clock::now();
    cl_event timing_event[exec_data->num_devices];
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clEnqueueTask(exec_data->compute_queue[i], exec_data->compute_kernel[i], 0, NULL, &timing_event[i]);
        checkError(status, exec_data, "Failed to run compute kernel");
        status = clEnqueueTask(exec_data->cache_queue[i], exec_data->cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run cache kernel");
        status = clEnqueueTask(exec_data->recv_queue[i], exec_data->recv_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote recv kernel");
        status = clEnqueueTask(exec_data->send_queue[i], exec_data->send_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote send kernel");
    }
    if(exec_data->debug)
    {
        printf("Started all kernels\n");
        fflush(stdout);
    }

    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        clWaitForEvents(1, &timing_event[i]);
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to finish compute kernel");
        status = clFinish(exec_data->cache_queue[i]);
        checkError(status, exec_data, "Failed to finish cache kernel");
        status = clFinish(exec_data->recv_queue[i]);
        checkError(status, exec_data, "Failed to finish remote recv kernel");
        status = clFinish(exec_data->send_queue[i]);
        checkError(status, exec_data, "Failed to finish remote recv kernel");
    }
    
    if(exec_data->debug)printf("Sucessfully completed Tasks\n");
    fflush(stdout);

    if(exec_data->rank == 0)
    {

        cl_ulong t_start;
        cl_ulong t_end;
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_START, sizeof(t_start), &t_start, NULL);
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_END, sizeof(t_end), &t_end, NULL);
        double elapsed_time = double(t_end - t_start)*1e-9;
        exec_time = elapsed_time;
    }

    for(int dev = 0; dev < exec_data->num_devices;dev++)
    {
        if(exec_data->debug)printf("Reading memory back from device %d\n", dev);
        status = clEnqueueReadBuffer(exec_data->recv_queue[dev], local_pos_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_pos, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read position Memory Object");
        if(exec_data->debug)printf("Succesfully read positions\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->recv_queue[dev], local_vel_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read velocity Memory Object");
        if(exec_data->debug)printf("Succesfully read velocities\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->recv_queue[dev], local_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read Force Memory Object");
        if(exec_data->debug)printf("Succesfully read forces\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->recv_queue[dev], remote_force_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double3), remote_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to Read Remote Force Memory Object");
        if(exec_data->debug)printf("Succesfully read remote forces\n");

        clFinish(exec_data->recv_queue[dev]);
        MPI_Gather(local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered positions\n");
        //fflush(stdout);
        MPI_Gather(local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered velocities\n");
        //fflush(stdout);
        MPI_Gather(local_force, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered forces\n");
        //fflush(stdout);
        cl_double3* temp_force = new cl_double3[N];
        MPI_Gather(remote_force, sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, &temp_force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered remote forces\n");
        for(size_t i = 0;i < N;i++)
        {
            force[i].x -= temp_force[i].x;
            force[i].y -= temp_force[i].y;
            force[i].z -= temp_force[i].z;
        }
        delete[] temp_force;
        
        
        clReleaseMemObject(local_mass_mem[dev]);
        clReleaseMemObject(local_coeff_mem[dev]);
        clReleaseMemObject(remote_coeff_mem[dev]);
        clReleaseMemObject(local_pos_mem[dev]);
        clReleaseMemObject(remote_pos_mem[dev]);
        clReleaseMemObject(local_vel_mem[dev]);
        clReleaseMemObject(local_force_mem[dev]);
        clReleaseMemObject(remote_force_mem[dev]);
        fflush(stdout);
    }

    delete[] local_coeff;
    delete[] local_mass;
    delete[] local_pos;
    delete[] local_force;
    delete[] local_vel;
    delete[] remote_coeff;
    delete[] remote_pos;
    delete[] remote_force;

    return exec_time;
}

typedef cl_double4 particle_t;
typedef cl_float4  particle_sp_t;

double lrb_solver_no_sync(Execution_data* exec_data, cl_double K, cl_double* mass, cl_double* coeff, cl_double3* pos, cl_double3* vel, cl_double3* force, size_t N, size_t time_steps, cl_double delta_t, cl_double predicted_time)
{
    size_t LATENCY_FACTOR = 16;
    size_t PE_LOCAL_SIZE = 2;
    size_t PE_LOCAL_CNT = 2;

    size_t padding_factor = LATENCY_FACTOR * PE_LOCAL_SIZE * PE_LOCAL_CNT;
    size_t num_blocks = 1 + ((N-1)/padding_factor);
    size_t padded_N = num_blocks * padding_factor;
    double exec_time = 0.0;

    cl_int status;
    
    //Local particle buffer memory
    cl_mem local_part_mem[exec_data->num_devices];

    //Remote particle buffer memory
    cl_mem remote_part_mem[exec_data->num_devices];

    //Local force cache memory
    cl_mem local_force_mem[exec_data->num_devices];

    //Remote force cache memory
    cl_mem remote_force_mem[exec_data->num_devices];

    //Integrator memory
    cl_mem local_mass_mem[exec_data->num_devices];
    cl_mem local_part_integrator_mem[exec_data->num_devices];  
    cl_mem local_vel_integrator_mem[exec_data->num_devices];
    cl_mem lf_c_mem[exec_data->num_devices];
    cl_mem lf_d_mem[exec_data->num_devices];

    
    //Coefficients for LF integration
    //cl_mem c_mem[exec_data->num_devices];
    //cl_mem d_mem[exec_data->num_devices];

    //size_t local_N = N/(exec_data->comm_sz*exec_data->num_devices);
    size_t local_N = N;
    size_t remote_N = N;


    cl_double* local_mass = new cl_double[local_N];
    
    cl_double3* local_vel = new cl_double3[local_N];
    cl_double3* local_pos = new cl_double3[local_N];
    cl_double*  local_coeff = new double[local_N];
    particle_t* local_part = new particle_t[local_N];
    particle_t* remote_part = new particle_t[remote_N];
    cl_double3* local_force = new cl_double3[local_N];
    cl_double3* remote_force = new cl_double3[remote_N];

    int fpga_comm_sz = exec_data->comm_sz * exec_data->num_devices;
    for(int dev = 0;dev < exec_data->num_devices; dev++)
    {
        int fpga_rank = dev*exec_data->comm_sz + exec_data->rank;
        MPI_Scatter(&pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&mass[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_mass, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&coeff[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_coeff, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        for(int i = 0;i < local_N;i++)
        {
            //Pack particles
            local_part[i].x = local_pos[i].x;
            local_part[i].y = local_pos[i].y;
            local_part[i].z = local_pos[i].z;
            remote_part[i].x = local_pos[i].x;
            remote_part[i].y = local_pos[i].y;
            remote_part[i].z = local_pos[i].z;
            
            //Premultiply with K to save one multiplication for each force calculation
            local_part[i].w = K * local_coeff[i];
            remote_part[i].w = local_coeff[i];

        
            remote_force[i] = {0.0,0.0,0.0};
            local_force[i] = {0.0,0.0,0.0};
        }

        if(exec_data->debug)printf("Creating mem buffers for device %d\n", dev);

        local_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particle buffer");
        remote_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote particle buffer");
        local_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local force cache");
        remote_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote force cache");
        
        local_mass_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        local_part_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particles in integrator");
        local_vel_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local velocity in integrator");
        lf_c_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, exec_data->lf_steps*sizeof(cl_double), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF c coefficients");
        lf_d_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, (exec_data->lf_steps-1)*sizeof(cl_double), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF d coefficients");
        
        if(exec_data->debug)printf("Writing data to device %d\n", dev);
        
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_mass_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_mass, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_t), local_part, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to local position Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to velocity Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_c_mem[dev], CL_TRUE, 0, exec_data->lf_steps*sizeof(cl_double), exec_data->c, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to c coefficients Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_d_mem[dev], CL_TRUE, 0, (exec_data->lf_steps-1)*sizeof(cl_double), exec_data->d, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to d coefficients Memory Buffer");
        
        //Compute Kernel Arguments
        cl_uint arg_index = 0;
        if(exec_data->debug)printf("Setting compute Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
       

        //Local Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Local Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Integrator Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Integrator Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_vel_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_mass_mem[dev]);
        checkError(status, exec_data, "Failed to set mass buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_c_mem[dev]);
        checkError(status, exec_data, "Failed to set c coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_d_mem[dev]);
        checkError(status, exec_data, "Failed to set d coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(double), &delta_t);
        checkError(status, exec_data, "Failed to set delta_t Argument");
        
        if(exec_data->debug)
        {
            printf("fpga_rank: %d\n", fpga_rank);
            printf("fpga_comm_sz: %d\n", fpga_comm_sz);
            printf("local_N: %d\n", local_N);
            printf("N: %d\n", N);
            printf("time_steps: %d\n", time_steps);
            fflush(stdout);
        }
    }
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for Compute kernel");
    }

    if(exec_data->debug)
    {
        printf("Sucessfully set Arguments\n");
        fflush(stdout);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    if(exec_data->rank == 0)printf("-------- Ring Solver --------\n");
    if(exec_data->rank == 0)printf("N = %d, time_steps = %d\n", N, time_steps);
    if(exec_data->rank == 0)fflush(stdout);
    MPI_Barrier(MPI_COMM_WORLD);
    auto start = std::chrono::high_resolution_clock::now();
    cl_event timing_event[exec_data->num_devices];
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clEnqueueTask(exec_data->integrator_queue[i], exec_data->integrator_kernel[i], 0, NULL, &timing_event[i]);
        checkError(status, exec_data, "Failed to run integrator kernel");
        status = clEnqueueTask(exec_data->remote_part_buffer_queue[i], exec_data->remote_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote particle buffer kernel");
        status = clEnqueueTask(exec_data->local_part_buffer_queue[i], exec_data->local_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local particle buffer kernel");
        status = clEnqueueTask(exec_data->compute_queue[i], exec_data->compute_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run compute kernel");
        status = clEnqueueTask(exec_data->local_force_cache_queue[i], exec_data->local_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local force cache kernel");
        status = clEnqueueTask(exec_data->remote_force_cache_queue[i], exec_data->remote_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote force cache kernel");
    }
    if(exec_data->debug)
    {
        printf("Started all kernels\n");
        printf("Host: sizeof(particle_t) = %u\n",sizeof(particle_t));
        fflush(stdout);
    }

    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        clWaitForEvents(1, &timing_event[i]);

        status = clFinish(exec_data->remote_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish remote force cache kernel");
        status = clFinish(exec_data->local_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish local force cache kernel");
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to finish compute kernel");
        status = clFinish(exec_data->local_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish local particle buffer kernel");
        status = clFinish(exec_data->remote_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish remote particle buffer kernel");
        status = clFinish(exec_data->integrator_queue[i]);
        checkError(status, exec_data, "Failed to finish integrator kernel");
    }
    
    if(exec_data->debug)printf("Sucessfully completed Tasks\n");
    fflush(stdout);

    if(exec_data->rank == 0)
    {

        cl_ulong t_start;
        cl_ulong t_end;
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_START, sizeof(t_start), &t_start, NULL);
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_END, sizeof(t_end), &t_end, NULL);
        double elapsed_time = double(t_end - t_start)*1e-9;
        exec_time = elapsed_time;
    }

    for(int dev = 0; dev < exec_data->num_devices;dev++)
    {
        if(exec_data->debug)printf("Reading memory back from device %d\n", dev);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_t), local_part, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read particle Memory Object");
        if(exec_data->debug)printf("Succesfully read particles\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read velocity Memory Object");
        if(exec_data->debug)printf("Succesfully read velocities\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read local force Memory Object");
        if(exec_data->debug)printf("Succesfully read local forces\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], remote_force_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double3), remote_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read remote Force Memory Object");
        if(exec_data->debug)printf("Succesfully read remote forces\n");

        clFinish(exec_data->integrator_queue[dev]);

        //Unpack particles
        for(size_t i = 0;i < local_N;i++)
        {
            local_pos[i].x = local_part[i].x;
            local_pos[i].y = local_part[i].y;
            local_pos[i].z = local_part[i].z;
        }

        MPI_Gather(local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered positions\n");
        //fflush(stdout);
        MPI_Gather(local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered velocities\n");
        //fflush(stdout);
        MPI_Gather(local_force, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered forces\n");
        //fflush(stdout);
        cl_double3* temp_force = new cl_double3[N];
        MPI_Gather(remote_force, sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, &temp_force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered remote forces\n");
        for(size_t i = 0;i < N;i++)
        {
            force[i].x -= temp_force[i].x;
            force[i].y -= temp_force[i].y;
            force[i].z -= temp_force[i].z;
        }
        delete[] temp_force;
        
        
        clReleaseMemObject(local_part_mem[dev]);
        clReleaseMemObject(remote_part_mem[dev]);
        clReleaseMemObject(local_force_mem[dev]);
        clReleaseMemObject(remote_force_mem[dev]);
        clReleaseMemObject(local_part_integrator_mem[dev]);
        clReleaseMemObject(local_vel_integrator_mem[dev]);
        clReleaseMemObject(local_mass_mem[dev]);
        clReleaseMemObject(lf_c_mem[dev]);
        clReleaseMemObject(lf_d_mem[dev]);
        fflush(stdout);
    }

    delete[] local_coeff;
    delete[] local_mass;
    delete[] local_pos;
    delete[] local_part;
    delete[] remote_part;
    delete[] local_force;
    delete[] remote_force;
    delete[] local_vel;
    return exec_time;
}

double lrbd_solver_no_sync(Execution_data* exec_data, cl_double K, cl_double* mass, cl_double* coeff, cl_double3* pos, cl_double3* vel, cl_double3* force, size_t N, size_t time_steps, cl_double delta_t, cl_double predicted_time, std::string topology, cl_double* power_consumption)
{
    double exec_time = 0.0;

    cl_int status;
    
    //Local particle buffer memory
    cl_mem local_part_mem[exec_data->num_devices];

    //Remote particle buffer memory
    cl_mem remote_part_mem[exec_data->num_devices];

    //Local force cache memory
    cl_mem local_force_mem[exec_data->num_devices];

    //Remote force cache memory
    cl_mem remote_force_mem[exec_data->num_devices];

    //Integrator memory
    cl_mem local_mass_mem[exec_data->num_devices];
    cl_mem local_part_integrator_mem[exec_data->num_devices];  
    cl_mem local_vel_integrator_mem[exec_data->num_devices];
    cl_mem lf_c_mem[exec_data->num_devices];
    cl_mem lf_d_mem[exec_data->num_devices];

    
    //Coefficients for LF integration
    //cl_mem c_mem[exec_data->num_devices];
    //cl_mem d_mem[exec_data->num_devices];

    size_t local_N = N/(exec_data->comm_sz*exec_data->num_devices);
    if(local_N * exec_data->comm_sz*exec_data->num_devices != N)
    {
        checkError(CL_INVALID_ARG_VALUE, exec_data, "N has to be divisible by the number of FPGAs!");
    }
    //size_t local_N = N;
    size_t remote_N = local_N;
    size_t LATENCY_FACTOR = 16;
    size_t PE_LOCAL_SIZE = 2;

    size_t local_block_size = LATENCY_FACTOR * exec_data->local_PE_dim * PE_LOCAL_SIZE;
    size_t remote_block_size = LATENCY_FACTOR * exec_data->remote_PE_dim * PE_LOCAL_SIZE;
    size_t num_local_blocks = 1 + ((local_N-1)/local_block_size);
    size_t num_remote_blocks = 1 + ((remote_N-1)/remote_block_size);
    size_t padded_local_N = num_local_blocks * local_block_size;
    size_t padded_remote_N = num_remote_blocks * remote_block_size;
    printf("padded_local_N = %lu, padded_remote_N = %lu\n", padded_local_N, padded_remote_N);


    cl_double* local_mass = new cl_double[local_N];
    cl_double3* local_vel = new cl_double3[local_N];
    cl_double3* local_pos = new cl_double3[local_N];
    cl_double*  local_coeff = new double[local_N];

    particle_t* local_part = new particle_t[local_N];
    particle_t* remote_part = new particle_t[remote_N];
    cl_double3* local_force = new cl_double3[local_N];
    cl_double3* remote_force = new cl_double3[remote_N];


    typedef void* (*aocl_mmd_card_info_fn_t)(const char*, aocl_mmd_info_t, size_t, void*, size_t*);
    aocl_mmd_card_info_fn_t aocl_mmd_card_info_fn = NULL;
    clGetBoardExtensionFunctionAddressIntelFPGA_fn clGetBoardExtensionFunctionAddressIntelFPGA = NULL;
    void *tempPointer = NULL;

    if(!exec_data->is_emulation)
        clGetBoardExtensionFunctionAddressIntelFPGA = (clGetBoardExtensionFunctionAddressIntelFPGA_fn)clGetExtensionFunctionAddressForPlatform(exec_data->platform, "clGetBoardExtensionFunctionAddressIntelFPGA");
    if (clGetBoardExtensionFunctionAddressIntelFPGA == NULL)
    {
        printf ("Failed to get clGetBoardExtensionFunctionAddressIntelFPGA\n");
    }

    tempPointer = NULL;
    if(!exec_data->is_emulation)
    {
        tempPointer = clGetBoardExtensionFunctionAddressIntelFPGA("aocl_mmd_card_info",exec_data->device[0]);
        aocl_mmd_card_info_fn =   (aocl_mmd_card_info_fn_t)tempPointer;
    }
    if (aocl_mmd_card_info_fn == NULL )
    {
        printf ("Failed to get aocl_mmd_card_info_fn address\n");
    }
    fflush(stdout);
    int fpga_comm_sz = exec_data->comm_sz * exec_data->num_devices;
    for(int dev = 0;dev < exec_data->num_devices; dev++)
    {
        int fpga_rank = -1;
        if(topology == "ringN")
            fpga_rank = dev*exec_data->comm_sz + exec_data->rank;
        else if(topology == "ringO") //Only meaningful if exec_data->num_devices == 2
        {
            fpga_rank = dev == 0 ? exec_data->rank : exec_data->num_devices*exec_data->comm_sz - (exec_data->rank + 1);
            printf("%lu: Using ringO, fpga_rank = %d\n",exec_data->rank, fpga_rank);
        }
        else if(topology == "ringZ")
            fpga_rank = exec_data->num_devices * exec_data->rank + dev;
        else
            checkError(CL_INVALID_VALUE,exec_data, "topology not recognised, use either ringN, ringO or ringZ");
        MPI_Scatter(&pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&mass[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_mass, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&coeff[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_coeff, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        for(int i = 0;i < local_N;i++)
        {
            //Pack particles
            local_part[i].x = local_pos[i].x;
            local_part[i].y = local_pos[i].y;
            local_part[i].z = local_pos[i].z;
            remote_part[i].x = local_pos[i].x;
            remote_part[i].y = local_pos[i].y;
            remote_part[i].z = local_pos[i].z;
            
            //Premultiply with K to save one multiplication for each force calculation
            local_part[i].w = K * local_coeff[i];
            remote_part[i].w = local_coeff[i];
            //printf("local_part[%d][%d] = [%f,%f,%f,%f], local_mass[%d][%d] = %f\n", fpga_rank, i, local_part[i].x,local_part[i].y,local_part[i].z,local_part[i].w, fpga_rank, i, local_mass[i]);

        
            remote_force[i] = {0.0,0.0,0.0};
            local_force[i] = {0.0,0.0,0.0};
        }

        if(exec_data->debug)printf("Creating mem buffers for device %d\n", dev);

        local_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particle buffer");
        remote_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_remote_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote particle buffer");
        local_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local force cache");
        remote_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_remote_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote force cache");
        
        local_mass_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_local_N*sizeof(cl_double), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        local_part_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(particle_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particles in integrator");
        local_vel_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(cl_double3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local velocity in integrator");
        lf_c_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, exec_data->lf_steps*sizeof(cl_double), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF c coefficients");
        lf_d_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, (exec_data->lf_steps-1)*sizeof(cl_double), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF d coefficients");
        
        if(exec_data->debug)printf("Writing data to device %d\n", dev);
        
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_mass_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double), local_mass, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_t), local_part, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to local position Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to velocity Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_c_mem[dev], CL_TRUE, 0, exec_data->lf_steps*sizeof(cl_double), exec_data->c, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to c coefficients Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_d_mem[dev], CL_TRUE, 0, (exec_data->lf_steps-1)*sizeof(cl_double), exec_data->d, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to d coefficients Memory Buffer");
        
        //Compute Kernel Arguments
        cl_uint arg_index = 0;
        if(exec_data->debug)printf("Setting compute Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
       

        //Local Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Local Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Remote Force Comm Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Force Comm Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Integrator Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Integrator Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_vel_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_mass_mem[dev]);
        checkError(status, exec_data, "Failed to set mass buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_c_mem[dev]);
        checkError(status, exec_data, "Failed to set c coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_d_mem[dev]);
        checkError(status, exec_data, "Failed to set d coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(double), &delta_t);
        checkError(status, exec_data, "Failed to set delta_t Argument");
        
        if(exec_data->debug)
        {
            printf("fpga_rank: %d\n", fpga_rank);
            printf("fpga_comm_sz: %d\n", fpga_comm_sz);
            printf("local_N: %d\n", local_N);
            printf("N: %d\n", N);
            printf("time_steps: %d\n", time_steps);
            fflush(stdout);
        }
    }
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for Compute kernel");
    }

    if(exec_data->debug)
    {
        printf("Sucessfully set Arguments\n");
        fflush(stdout);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    if(exec_data->rank == 0)printf("-------- Ring Solver --------\n");
    if(exec_data->rank == 0)printf("N = %d, time_steps = %d\n", N, time_steps);
    if(exec_data->rank == 0)fflush(stdout);
    MPI_Barrier(MPI_COMM_WORLD);
    auto start = std::chrono::high_resolution_clock::now();
    cl_event timing_event[exec_data->num_devices];
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clEnqueueTask(exec_data->integrator_queue[i], exec_data->integrator_kernel[i], 0, NULL, &timing_event[i]);
        checkError(status, exec_data, "Failed to run integrator kernel");
        status = clEnqueueTask(exec_data->remote_part_buffer_queue[i], exec_data->remote_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote particle buffer kernel");
        status = clEnqueueTask(exec_data->local_part_buffer_queue[i], exec_data->local_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local particle buffer kernel");
        status = clEnqueueTask(exec_data->compute_queue[i], exec_data->compute_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run compute kernel");
        status = clEnqueueTask(exec_data->local_force_cache_queue[i], exec_data->local_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local force cache kernel");
        status = clEnqueueTask(exec_data->remote_force_cache_queue[i], exec_data->remote_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote force cache kernel");
        status = clEnqueueTask(exec_data->remote_force_comm_queue[i], exec_data->remote_force_comm_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote force cache kernel");
    }
    if(exec_data->debug)
    {
        printf("Started all kernels\n");
        printf("Host: sizeof(particle_t) = %u\n",sizeof(particle_t));
        fflush(stdout);
    }

    float average_power = 0.0f;
    size_t num_power_evaluations = 0;
    auto end = std::chrono::high_resolution_clock::now();
    if(!exec_data->is_emulation)
    {
        while(std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count() < predicted_time - 2.0)
        {
            float curr_power0;
            float curr_power1;
            size_t returned_size;
            aocl_mmd_card_info_fn("aclbitt_s10_pcie0", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power0, &returned_size);
            aocl_mmd_card_info_fn("aclbitt_s10_pcie1", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power1, &returned_size);
            end = std::chrono::high_resolution_clock::now();
            average_power += curr_power0 + curr_power1;
            num_power_evaluations++;
            if(exec_data->rank == 0)printf("power: %f\n", average_power/num_power_evaluations);
            if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
            if(exec_data->rank == 0)fflush(stdout);
        }

        if(num_power_evaluations > 0)
            average_power /= num_power_evaluations;
        else
            average_power = -1.0;
    }

    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        clWaitForEvents(1, &timing_event[i]);

        status = clFinish(exec_data->remote_force_comm_queue[i]);
        checkError(status, exec_data, "Failed to finish remote force cache kernel");
        status = clFinish(exec_data->remote_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish remote force cache kernel");
        status = clFinish(exec_data->local_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish local force cache kernel");
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to finish compute kernel");
        status = clFinish(exec_data->local_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish local particle buffer kernel");
        status = clFinish(exec_data->remote_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish remote particle buffer kernel");
        status = clFinish(exec_data->integrator_queue[i]);
        checkError(status, exec_data, "Failed to finish integrator kernel");
    }
    

    if(exec_data->debug)printf("Sucessfully completed Tasks\n");
    fflush(stdout);
    float gather_power[exec_data->comm_sz];
    MPI_Gather(&average_power,1,MPI_FLOAT, gather_power, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    if(exec_data->rank == 0)
    {
        average_power = 0.0f;
        for(int i = 0;i < exec_data->comm_sz;i++)
            average_power += gather_power[i];
        
        cl_ulong t_start;
        cl_ulong t_end;
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_START, sizeof(t_start), &t_start, NULL);
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_END, sizeof(t_end), &t_end, NULL);
        double elapsed_time = double(t_end - t_start)*1e-9;
        exec_time = elapsed_time;
        if(power_consumption != nullptr)
            *power_consumption = average_power;
        printf("Power consumption for %d devices: %fs\n", fpga_comm_sz, average_power);
    }

    for(int dev = 0; dev < exec_data->num_devices;dev++)
    {
        if(exec_data->debug)printf("Reading memory back from device %d\n", dev);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_t), local_part, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read particle Memory Object");
        if(exec_data->debug)printf("Succesfully read particles\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_vel, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read velocity Memory Object");
        if(exec_data->debug)printf("Succesfully read velocities\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_double3), local_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read local force Memory Object");
        if(exec_data->debug)printf("Succesfully read local forces\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], remote_force_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_double3), remote_force, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read remote Force Memory Object");
        if(exec_data->debug)printf("Succesfully read remote forces\n");
        fflush(stdout);
        clFinish(exec_data->integrator_queue[dev]);

        //Unpack particles
        for(size_t i = 0;i < local_N;i++)
        {
            local_pos[i].x = local_part[i].x;
            local_pos[i].y = local_part[i].y;
            local_pos[i].z = local_part[i].z;
        }

        MPI_Gather(local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered positions\n");
        fflush(stdout);
        MPI_Gather(local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered velocities\n");
        fflush(stdout);
        MPI_Gather(local_force, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered forces\n");
        fflush(stdout);
        cl_double3* temp_force = new cl_double3[N];
        MPI_Gather(remote_force, sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, &temp_force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered remote forces\n");
        if(exec_data->rank == 0)
        {
            for(size_t i = 0;i < N;i++)
            {
                force[i].x -= temp_force[i].x;
                force[i].y -= temp_force[i].y;
                force[i].z -= temp_force[i].z;
            }
        }
        delete[] temp_force;
        
        
        clReleaseMemObject(local_part_mem[dev]);
        clReleaseMemObject(remote_part_mem[dev]);
        clReleaseMemObject(local_force_mem[dev]);
        clReleaseMemObject(remote_force_mem[dev]);
        clReleaseMemObject(local_part_integrator_mem[dev]);
        clReleaseMemObject(local_vel_integrator_mem[dev]);
        clReleaseMemObject(local_mass_mem[dev]);
        clReleaseMemObject(lf_c_mem[dev]);
        clReleaseMemObject(lf_d_mem[dev]);
        fflush(stdout);
    }

    delete[] local_coeff;
    delete[] local_mass;
    delete[] local_pos;
    delete[] local_part;
    delete[] remote_part;
    delete[] local_force;
    delete[] remote_force;
    delete[] local_vel;
    return exec_time;
}

double lrbd_solver_sp(Execution_data* exec_data, cl_double K, cl_double* mass, cl_double* coeff, cl_double3* pos, cl_double3* vel, cl_double3* force, size_t N, size_t time_steps, cl_double delta_t, cl_double predicted_time, std::string topology, cl_double* power_consumption)
{
    double exec_time = 0.0;

    cl_int status;
    
    //Local particle buffer memory
    cl_mem local_part_mem[exec_data->num_devices];

    //Remote particle buffer memory
    cl_mem remote_part_mem[exec_data->num_devices];

    //Local force cache memory
    cl_mem local_force_mem[exec_data->num_devices];

    //Remote force cache memory
    cl_mem remote_force_mem[exec_data->num_devices];

    //Integrator memory
    cl_mem local_mass_mem[exec_data->num_devices];
    cl_mem local_part_integrator_mem[exec_data->num_devices];  
    cl_mem local_vel_integrator_mem[exec_data->num_devices];
    cl_mem lf_c_mem[exec_data->num_devices];
    cl_mem lf_d_mem[exec_data->num_devices];

    
    //Coefficients for LF integration
    //cl_mem c_mem[exec_data->num_devices];
    //cl_mem d_mem[exec_data->num_devices];

    size_t local_N = N/(exec_data->comm_sz*exec_data->num_devices);
    if(local_N * exec_data->comm_sz*exec_data->num_devices != N)
    {
        checkError(CL_INVALID_ARG_VALUE, exec_data, "N has to be divisible by the number of FPGAs!");
    }
    //size_t local_N = N;
    size_t remote_N = local_N;
    size_t LATENCY_FACTOR = 16;
    size_t PE_LOCAL_SIZE = 2;

    size_t local_block_size = LATENCY_FACTOR * exec_data->local_PE_dim * PE_LOCAL_SIZE;
    size_t remote_block_size = LATENCY_FACTOR * exec_data->remote_PE_dim * PE_LOCAL_SIZE;
    size_t num_local_blocks = 1 + ((local_N-1)/local_block_size);
    size_t num_remote_blocks = 1 + ((remote_N-1)/remote_block_size);
    size_t padded_local_N = num_local_blocks * local_block_size;
    size_t padded_remote_N = num_remote_blocks * remote_block_size;
    printf("padded_local_N = %lu, padded_remote_N = %lu\n", padded_local_N, padded_remote_N);

    cl_double* local_mass = new cl_double[local_N];
    cl_double3* local_vel = new cl_double3[local_N];
    cl_double3* local_pos = new cl_double3[local_N];
    cl_double*  local_coeff = new double[local_N];
    cl_double3* local_force = new cl_double3[local_N];
    cl_double3* remote_force = new cl_double3[remote_N];

    cl_float* local_mass_sp = new cl_float[local_N];
    cl_float3* local_vel_sp = new cl_float3[local_N];
    particle_sp_t* local_part_sp = new particle_sp_t[local_N];
    particle_sp_t* remote_part_sp = new particle_sp_t[remote_N];
    cl_float3* local_force_sp = new cl_float3[local_N];
    cl_float3* remote_force_sp = new cl_float3[remote_N];
    cl_float* c_sp = new cl_float[exec_data->lf_steps];
    cl_float* d_sp = new cl_float[exec_data->lf_steps-1];

    typedef void* (*aocl_mmd_card_info_fn_t)(const char*, aocl_mmd_info_t, size_t, void*, size_t*);
    aocl_mmd_card_info_fn_t aocl_mmd_card_info_fn = NULL;
    clGetBoardExtensionFunctionAddressIntelFPGA_fn clGetBoardExtensionFunctionAddressIntelFPGA = NULL;
    void *tempPointer = NULL;
    auto start = std::chrono::high_resolution_clock::now();
    if(!exec_data->is_emulation && power_consumption != nullptr)
        clGetBoardExtensionFunctionAddressIntelFPGA = (clGetBoardExtensionFunctionAddressIntelFPGA_fn)clGetExtensionFunctionAddressForPlatform(exec_data->platform, "clGetBoardExtensionFunctionAddressIntelFPGA");
    if (clGetBoardExtensionFunctionAddressIntelFPGA == NULL)
    {
        printf ("Failed to get clGetBoardExtensionFunctionAddressIntelFPGA\n");
    }

    tempPointer = NULL;
    if(!exec_data->is_emulation && power_consumption != nullptr)
    {
        tempPointer = clGetBoardExtensionFunctionAddressIntelFPGA("aocl_mmd_card_info",exec_data->device[0]);
        aocl_mmd_card_info_fn =   (aocl_mmd_card_info_fn_t)tempPointer;
    }
    if (aocl_mmd_card_info_fn == NULL )
    {
        printf ("Failed to get aocl_mmd_card_info_fn address\n");
    }
    auto end = std::chrono::high_resolution_clock::now();
    if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    int fpga_comm_sz = exec_data->comm_sz * exec_data->num_devices;
    for(int dev = 0;dev < exec_data->num_devices; dev++)
    {
        int fpga_rank = -1;
        if(topology == "ringN")
            fpga_rank = dev*exec_data->comm_sz + exec_data->rank;
        else if(topology == "ringO") //Only meaningful if exec_data->num_devices == 2
        {
            fpga_rank = dev == 0 ? exec_data->rank : exec_data->num_devices*exec_data->comm_sz - (exec_data->rank + 1);
            printf("%lu: Using ringO, fpga_rank = %d\n",exec_data->rank, fpga_rank);
        }
        else if(topology == "ringZ")
            fpga_rank = exec_data->num_devices * exec_data->rank + dev;
        else
            checkError(CL_INVALID_VALUE,exec_data, "topology not recognised, use either ringN, ringO or ringZ");
        start = std::chrono::high_resolution_clock::now();
        MPI_Scatter(&pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&mass[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_mass, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        MPI_Scatter(&coeff[dev*local_N*exec_data->comm_sz], local_N, MPI_DOUBLE, local_coeff, local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);

        for(int i = 0;i < local_N;i++)
        {
            //Pack particles
            local_part_sp[i].x = float(local_pos[i].x);
            local_part_sp[i].y = float(local_pos[i].y);
            local_part_sp[i].z = float(local_pos[i].z);
            remote_part_sp[i].x = float(local_pos[i].x);
            remote_part_sp[i].y = float(local_pos[i].y);
            remote_part_sp[i].z = float(local_pos[i].z);
            
            //Premultiply with K to save one multiplication for each force calculation
            local_part_sp[i].w = float(K * local_coeff[i]);
            remote_part_sp[i].w = float(local_coeff[i]);
            //printf("local_part[%d][%d] = [%f,%f,%f,%f], local_mass[%d][%d] = %f\n", fpga_rank, i, local_part[i].x,local_part[i].y,local_part[i].z,local_part[i].w, fpga_rank, i, local_mass[i]);
            local_mass_sp[i] = float(local_mass[i]);
            local_vel_sp[i].x = float(local_vel[i].x);
            local_vel_sp[i].y = float(local_vel[i].y);
            local_vel_sp[i].z = float(local_vel[i].z);

            remote_force[i] = {0.0f,0.0f,0.0f};
            local_force[i] = {0.0f,0.0f,0.0f};
        }
        for(int i = 0;i < exec_data->lf_steps-1;i++)
        {
            c_sp[i] = float(exec_data->c[i]);
            d_sp[i] = float(exec_data->d[i]);
        }
        c_sp[exec_data->lf_steps-1] = float(exec_data->c[exec_data->lf_steps-1]);

        if(exec_data->debug)printf("Creating mem buffers for device %d\n", dev);

        local_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(particle_sp_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particle buffer");
        remote_part_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_remote_N*sizeof(particle_sp_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote particle buffer");
        local_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(cl_float3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local force cache");
        remote_force_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_remote_N*sizeof(cl_float3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for remote force cache");
        
        local_mass_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, padded_local_N*sizeof(cl_float), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for mass");
        local_part_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(particle_sp_t), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local particles in integrator");
        local_vel_integrator_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_WRITE, padded_local_N*sizeof(cl_float3), NULL, &status);
        checkError(status, exec_data, "Failed to create Memory Buffer for local velocity in integrator");
        lf_c_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, exec_data->lf_steps*sizeof(cl_float), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF c coefficients");
        lf_d_mem[dev] = clCreateBuffer(exec_data->context, CL_MEM_READ_ONLY, (exec_data->lf_steps-1)*sizeof(cl_float), NULL, &status); 
        checkError(status, exec_data, "Failed to create Memory Buffer for LF d coefficients");
        
        if(exec_data->debug)printf("Writing data to device %d\n", dev);
        
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_mass_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_float), local_mass_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to mass Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_sp_t), local_part_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to local position Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_float3), local_vel_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to velocity Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_c_mem[dev], CL_TRUE, 0, exec_data->lf_steps*sizeof(cl_float), c_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to c coefficients Memory Buffer");
        status = clEnqueueWriteBuffer(exec_data->compute_queue[dev], lf_d_mem[dev], CL_TRUE, 0, (exec_data->lf_steps-1)*sizeof(cl_float), d_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to write to d coefficients Memory Buffer");
        end = std::chrono::high_resolution_clock::now();
        if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
        start = std::chrono::high_resolution_clock::now();
        //Compute Kernel Arguments
        cl_uint arg_index = 0;
        if(exec_data->debug)printf("Setting compute Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->compute_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
       

        //Local Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Particle Buffer Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Particle Buffer Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_part_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_part_buffer_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Local Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Local Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->local_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        
        //Remote Force Cache Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Force Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_force_cache_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Remote Force Comm Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Remote Force Comm Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&remote_force_mem[dev]);
        checkError(status, exec_data, "Failed to set force buffer Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->remote_force_comm_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");

        //Integrator Kernel Arguments
        arg_index = 0;
        if(exec_data->debug)printf("Setting Integrator Kernel Arguments for device %d\n", dev);
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_part_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set particle buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_vel_integrator_mem[dev]);
        checkError(status, exec_data, "Failed to set velocity buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&local_mass_mem[dev]);
        checkError(status, exec_data, "Failed to set mass buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_c_mem[dev]);
        checkError(status, exec_data, "Failed to set c coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_mem), (void*)&lf_d_mem[dev]);
        checkError(status, exec_data, "Failed to set d coefficient buffer Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &local_N);
        checkError(status, exec_data, "Failed to set local_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &remote_N);
        checkError(status, exec_data, "Failed to set remote_N Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_rank);
        checkError(status, exec_data, "Failed to set fpga_rank Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &fpga_comm_sz);
        checkError(status, exec_data, "Failed to set fpga_comm_sz Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &time_steps);
        checkError(status, exec_data, "Failed to set time_steps Argument");
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(int), &exec_data->lf_steps);
        checkError(status, exec_data, "Failed to set lf_steps Argument");
        cl_float delta_t_sp = float(delta_t);
        status = clSetKernelArg(exec_data->integrator_kernel[dev], arg_index++, sizeof(cl_float), &delta_t_sp);
        checkError(status, exec_data, "Failed to set delta_t Argument");
        
        if(exec_data->debug)
        {
            printf("fpga_rank: %d\n", fpga_rank);
            printf("fpga_comm_sz: %d\n", fpga_comm_sz);
            printf("local_N: %d\n", local_N);
            printf("N: %d\n", N);
            printf("time_steps: %d\n", time_steps);
            fflush(stdout);
        }
        end = std::chrono::high_resolution_clock::now();
        if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    }
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to set Arguments for Compute kernel");
    }

    if(exec_data->debug)
    {
        printf("Sucessfully set Arguments\n");
        fflush(stdout);
    }
    start = std::chrono::high_resolution_clock::now();
    MPI_Barrier(MPI_COMM_WORLD);
    if(exec_data->rank == 0)printf("-------- Ring Solver --------\n");
    if(exec_data->rank == 0)printf("N = %d, time_steps = %d\n", N, time_steps);
    if(exec_data->rank == 0)fflush(stdout);
    MPI_Barrier(MPI_COMM_WORLD);
    cl_event timing_event[exec_data->num_devices];
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        status = clEnqueueTask(exec_data->integrator_queue[i], exec_data->integrator_kernel[i], 0, NULL, &timing_event[i]);
        checkError(status, exec_data, "Failed to run integrator kernel");
        status = clEnqueueTask(exec_data->remote_part_buffer_queue[i], exec_data->remote_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote particle buffer kernel");
        status = clEnqueueTask(exec_data->local_part_buffer_queue[i], exec_data->local_part_buffer_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local particle buffer kernel");
        status = clEnqueueTask(exec_data->compute_queue[i], exec_data->compute_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run compute kernel");
        status = clEnqueueTask(exec_data->local_force_cache_queue[i], exec_data->local_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run local force cache kernel");
        status = clEnqueueTask(exec_data->remote_force_cache_queue[i], exec_data->remote_force_cache_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote force cache kernel");
        status = clEnqueueTask(exec_data->remote_force_comm_queue[i], exec_data->remote_force_comm_kernel[i], 0, NULL, NULL);
        checkError(status, exec_data, "Failed to run remote force cache kernel");
    }
    if(exec_data->debug)
    {
        printf("Started all kernels\n");
        printf("Host: sizeof(particle_t) = %u\n",sizeof(particle_t));
        fflush(stdout);
    }

    float average_power = 0.0f;
    size_t num_power_evaluations = 0;
    end = std::chrono::high_resolution_clock::now();
    if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    if(!exec_data->is_emulation)
    {
        while(std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count() < predicted_time - 2.0)
        {
            float curr_power0;
            float curr_power1;
            size_t returned_size;
            aocl_mmd_card_info_fn("aclbitt_s10_pcie0", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power0, &returned_size);
            aocl_mmd_card_info_fn("aclbitt_s10_pcie1", AOCL_MMD_CONCURRENT_READS, sizeof(float), (void*)&curr_power1, &returned_size);
            end = std::chrono::high_resolution_clock::now();
            average_power += curr_power0 + curr_power1;
            num_power_evaluations++;
            if(exec_data->rank == 0)printf("power: %f\n", average_power/num_power_evaluations);
            if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
            if(exec_data->rank == 0)fflush(stdout);
        }

        if(num_power_evaluations > 0)
            average_power /= num_power_evaluations;
        else
            average_power = -1.0;
    }
    start = std::chrono::high_resolution_clock::now();
    for(size_t i = 0;i < exec_data->num_devices;i++)
    {
        clWaitForEvents(1, &timing_event[i]);

        status = clFinish(exec_data->remote_force_comm_queue[i]);
        checkError(status, exec_data, "Failed to finish remote force cache kernel");
        status = clFinish(exec_data->remote_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish remote force cache kernel");
        status = clFinish(exec_data->local_force_cache_queue[i]);
        checkError(status, exec_data, "Failed to finish local force cache kernel");
        status = clFinish(exec_data->compute_queue[i]);
        checkError(status, exec_data, "Failed to finish compute kernel");
        status = clFinish(exec_data->local_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish local particle buffer kernel");
        status = clFinish(exec_data->remote_part_buffer_queue[i]);
        checkError(status, exec_data, "Failed to finish remote particle buffer kernel");
        status = clFinish(exec_data->integrator_queue[i]);
        checkError(status, exec_data, "Failed to finish integrator kernel");
    }
    end = std::chrono::high_resolution_clock::now();
    if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    start = std::chrono::high_resolution_clock::now();
    if(exec_data->debug)printf("Sucessfully completed Tasks\n");
    fflush(stdout);
    float gather_power[exec_data->comm_sz];
    MPI_Gather(&average_power,1,MPI_FLOAT, gather_power, 1, MPI_FLOAT, 0, MPI_COMM_WORLD);
    if(exec_data->rank == 0)
    {
        average_power = 0.0f;
        for(int i = 0;i < exec_data->comm_sz;i++)
            average_power += gather_power[i];
        
        cl_ulong t_start;
        cl_ulong t_end;
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_START, sizeof(t_start), &t_start, NULL);
        clGetEventProfilingInfo(timing_event[0], CL_PROFILING_COMMAND_END, sizeof(t_end), &t_end, NULL);
        double elapsed_time = double(t_end - t_start)*1e-9;
        exec_time = elapsed_time;
        if(power_consumption != nullptr)
            *power_consumption = average_power;
        printf("Power consumption for %d devices: %fs\n", fpga_comm_sz, average_power);
    }
    end = std::chrono::high_resolution_clock::now();
    if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    start = std::chrono::high_resolution_clock::now();
    for(int dev = 0; dev < exec_data->num_devices;dev++)
    {
        if(exec_data->debug)printf("Reading memory back from device %d\n", dev);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_part_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(particle_sp_t), local_part_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read particle Memory Object");
        if(exec_data->debug)printf("Succesfully read particles\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_vel_integrator_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_float3), local_vel_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read velocity Memory Object");
        if(exec_data->debug)printf("Succesfully read velocities\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], local_force_mem[dev], CL_TRUE, 0, local_N*sizeof(cl_float3), local_force_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read local force Memory Object");
        if(exec_data->debug)printf("Succesfully read local forces\n");
        //fflush(stdout);
        status = clEnqueueReadBuffer(exec_data->integrator_queue[dev], remote_force_mem[dev], CL_TRUE, 0, remote_N*sizeof(cl_float3), remote_force_sp, 0, NULL, NULL);
        checkError(status, exec_data, "Failed to read remote Force Memory Object");
        if(exec_data->debug)printf("Succesfully read remote forces\n");
        fflush(stdout);
        clFinish(exec_data->integrator_queue[dev]);

        //Unpack particles
        for(size_t i = 0;i < local_N;i++)
        {
            local_pos[i].x = double(local_part_sp[i].x);
            local_pos[i].y = double(local_part_sp[i].y);
            local_pos[i].z = double(local_part_sp[i].z);

            local_vel[i].x = double(local_vel_sp[i].x);
            local_vel[i].y = double(local_vel_sp[i].y);
            local_vel[i].z = double(local_vel_sp[i].z);

            local_force[i].x = double(local_force_sp[i].x);
            local_force[i].y = double(local_force_sp[i].y);
            local_force[i].z = double(local_force_sp[i].z);

            remote_force[i].x = double(remote_force_sp[i].x);
            remote_force[i].y = double(remote_force_sp[i].y);
            remote_force[i].z = double(remote_force_sp[i].z);
        }

        MPI_Gather(local_pos, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &pos[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered positions\n");
        fflush(stdout);
        MPI_Gather(local_vel, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &vel[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered velocities\n");
        fflush(stdout);
        MPI_Gather(local_force, sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, &force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*local_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered forces\n");
        fflush(stdout);
        cl_double3* temp_force = new cl_double3[N];
        MPI_Gather(remote_force, sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, &temp_force[dev*local_N*exec_data->comm_sz], sizeof(cl_double3)/sizeof(double)*remote_N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
        if(exec_data->debug)printf("Gathered remote forces\n");
        if(exec_data->rank == 0)
        {
            for(size_t i = 0;i < N;i++)
            {
                force[i].x -= temp_force[i].x;
                force[i].y -= temp_force[i].y;
                force[i].z -= temp_force[i].z;
            }
        }
        delete[] temp_force;
        
        
        clReleaseMemObject(local_part_mem[dev]);
        clReleaseMemObject(remote_part_mem[dev]);
        clReleaseMemObject(local_force_mem[dev]);
        clReleaseMemObject(remote_force_mem[dev]);
        clReleaseMemObject(local_part_integrator_mem[dev]);
        clReleaseMemObject(local_vel_integrator_mem[dev]);
        clReleaseMemObject(local_mass_mem[dev]);
        clReleaseMemObject(lf_c_mem[dev]);
        clReleaseMemObject(lf_d_mem[dev]);
        fflush(stdout);
    }
    end = std::chrono::high_resolution_clock::now();
    if(exec_data->rank == 0)printf("time: %f\n", std::chrono::duration_cast<std::chrono::duration<double>>(end - start).count());
    delete[] local_coeff;
    delete[] local_mass;
    delete[] local_pos;
    delete[] local_force;
    delete[] remote_force;
    delete[] local_vel;

    delete[] local_mass_sp;
    delete[] local_part_sp;
    delete[] remote_part_sp;
    delete[] local_force_sp;
    delete[] remote_force_sp;
    delete[] local_vel_sp;

    return exec_time;
}
