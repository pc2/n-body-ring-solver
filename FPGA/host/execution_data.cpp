#include "execution_data.h"
#include "error.h"

#include <algorithm>
#include <sstream>

Execution_data::Execution_data(int rank, 
                               int comm_sz, 
                               int CU, 
                               int local_PE_dim,
                               int remote_PE_dim,
                               const std::string& integration_kind, 
                               int order,
                               const std::string& solver_type, 
                               bool debug,
                               const std::string& suffix)
    :
    rank(static_cast<size_t>(rank)),
    comm_sz(static_cast<size_t>(comm_sz)),
    CU(static_cast<size_t>(CU)),
    local_PE_dim(static_cast<size_t>(local_PE_dim)),
    remote_PE_dim(static_cast<size_t>(remote_PE_dim)),
    integration_kind(integration_kind),
    order(static_cast<size_t>(order)),
    solver_type(solver_type),
    debug(debug),
    suffix(suffix)
{

    cl_int status; 
    const char* env_emulation = std::getenv("CL_CONFIG_CPU_EMULATE_DEVICES");
    if(env_emulation != nullptr)
    {
        platform_name =  "Intel(R) FPGA Emulation Platform for OpenCL(TM)";
        is_emulation = true;
    }
    else
    {
        platform_name = "Intel(R) FPGA SDK for OpenCL(TM)";
        is_emulation = false;
    }

    printf("solver_type: %s\n",solver_type.c_str());
    if(solver_type == "lrb")
        num_devices = 1;
    else if(solver_type == "lrbd" && is_emulation)
        num_devices = 4;
    else
        num_devices = 2;
    
    platform = NULL;
    context = NULL;
    for(int i = 0; i < num_devices;i++)
    {
        device.push_back(NULL);
        compute_queue.push_back(NULL);
        recv_queue.push_back(NULL);
        send_queue.push_back(NULL);
        cache_queue.push_back(NULL);

        local_part_buffer_queue.push_back(NULL);
        remote_part_buffer_queue.push_back(NULL);
        local_force_cache_queue.push_back(NULL);
        remote_force_cache_queue.push_back(NULL);
        remote_force_comm_queue.push_back(NULL);
        integrator_queue.push_back(NULL);

        program.push_back(NULL);

        compute_kernel.push_back(NULL);
        recv_kernel.push_back(NULL);
        send_kernel.push_back(NULL);
        cache_kernel.push_back(NULL);

        local_part_buffer_kernel.push_back(NULL);
        remote_part_buffer_kernel.push_back(NULL);
        local_force_cache_kernel.push_back(NULL);
        remote_force_cache_kernel.push_back(NULL);
        remote_force_comm_kernel.push_back(NULL);
        integrator_kernel.push_back(NULL);
    }

    switch(order)
    {
        default:
            printf("Order %d not supported! Using 2nd order!\n", order);
            order = 2;
        case 2:
            c = c_2;
            d = d_2;
            lf_steps = 2;
            break;
        case 4:
            c = c_4;
            d = d_4;
            lf_steps = 4;
            break;
        case 6:
            c = c_6;
            d = d_6;
            lf_steps = 8;
            break;
    }
}

Execution_data::~Execution_data()
{
    delete_execution_data();
}

void Execution_data::init()
{
    find_platform();
    find_devices();
    if(debug)print_device_info();
    create_context();
    create_command_queue();
    create_program();
}

void Execution_data::delete_execution_data()
{
    for(int i = 0;i < this->num_devices;i++)
    {
        if(this->compute_kernel[i])clReleaseKernel(this->compute_kernel[i]);  
        if(this->recv_kernel[i])clReleaseKernel(this->recv_kernel[i]);  
        if(this->send_kernel[i])clReleaseKernel(this->send_kernel[i]);  
        if(this->cache_kernel[i])clReleaseKernel(this->cache_kernel[i]);  
        if(this->local_part_buffer_kernel[i])clReleaseKernel(this->local_part_buffer_kernel[i]);  
        if(this->remote_part_buffer_kernel[i])clReleaseKernel(this->remote_part_buffer_kernel[i]);  
        if(this->local_force_cache_kernel[i])clReleaseKernel(this->local_force_cache_kernel[i]);  
        if(this->remote_force_cache_kernel[i])clReleaseKernel(this->remote_force_cache_kernel[i]);  
        if(this->remote_force_comm_kernel[i])clReleaseKernel(this->remote_force_comm_kernel[i]); 
        if(this->integrator_kernel[i])clReleaseKernel(this->integrator_kernel[i]);  

        if(this->program[i])clReleaseProgram(this->program[i]);

        if(this->compute_queue[i])clReleaseCommandQueue(this->compute_queue[i]);
        if(this->recv_queue[i])clReleaseCommandQueue(this->recv_queue[i]);
        if(this->send_queue[i])clReleaseCommandQueue(this->send_queue[i]);
        if(this->cache_queue[i])clReleaseCommandQueue(this->cache_queue[i]);
        if(this->local_part_buffer_queue[i])clReleaseCommandQueue(this->local_part_buffer_queue[i]);
        if(this->remote_part_buffer_queue[i])clReleaseCommandQueue(this->remote_part_buffer_queue[i]);
        if(this->local_force_cache_queue[i])clReleaseCommandQueue(this->local_force_cache_queue[i]);
        if(this->remote_force_cache_queue[i])clReleaseCommandQueue(this->remote_force_cache_queue[i]);
        if(this->remote_force_comm_queue[i])clReleaseCommandQueue(this->remote_force_comm_queue[i]);
        if(this->integrator_queue[i])clReleaseCommandQueue(this->integrator_queue[i]);
    }
    if(this->context)clReleaseContext(this->context);
    if(this->is_emulation && this->rank == 0)
    {
        if(solver_type == "full")
        {
            remove("input_0_output_1");
            remove("input_1_output_0");
        }
        else if(solver_type == "reduced")
        {
            remove("input_0_output_1_pos");
            remove("input_1_output_0_pos");
            remove("input_0_output_1_force");
            remove("input_1_output_0_force");
        }
        else if(solver_type == "lrbd")
        {
            if(num_devices == 2)
            {
                remove("input_0_output_1_part");
                remove("input_1_output_0_part");
                remove("input_0_output_1_force");
                remove("input_1_output_0_force");
            }
            else if(num_devices == 4)
            {
                remove("input_0_output_3_part");
                remove("input_1_output_0_part");
                remove("input_2_output_1_part");
                remove("input_3_output_2_part");
                remove("input_0_output_3_force");
                remove("input_1_output_0_force");
                remove("input_2_output_1_force");
                remove("input_3_output_2_force");
            }
        }
    }
}

void Execution_data::find_platform()
{
    std::transform(platform_name.begin(), platform_name.end(), platform_name.begin(), tolower);

    // Get number of platforms.
    cl_uint num_platforms;
    cl_int status = clGetPlatformIDs(0, NULL, &num_platforms);
    checkError(status, this, "Query for number of platforms failed");

    // Get a list of all platform ids.
    aocl_utils::scoped_array<cl_platform_id> pids(num_platforms);
    status = clGetPlatformIDs(num_platforms, pids, NULL);
    checkError(status, this, "Query for all platform ids failed");

    // For each platform, get name and compare against the platform_name string.
    for(unsigned i = 0; i < num_platforms; ++i) 
    {
        size_t sz;
        status = clGetPlatformInfo(pids[i], CL_PLATFORM_NAME, 0, NULL, &sz);
        checkError(status, this, "Query for platform name size failed");

        aocl_utils::scoped_array<char> tmp_name(sz);
        status = clGetPlatformInfo(pids[i], CL_PLATFORM_NAME, sz, tmp_name, NULL);
        checkError(status, this, "Query for platform name failed");

        std::string name = tmp_name.get();
        // Convert to lower case.
        if(debug)printf("Platform: %s\n", name.c_str());
        std::transform(name.begin(), name.end(), name.begin(), tolower);

        if(name.find(platform_name) != std::string::npos)
        {
            this->platform = pids[i];
            break;
        }
    }
    checkError(this->platform == NULL ? CL_INVALID_PLATFORM : CL_SUCCESS, this, "ERROR: Unable to find Intel(R) FPGA OpenCL platform.\n");
}

void Execution_data::find_devices()
{
    cl_device_id* devices;
    cl_uint num_devices_avail;
    cl_int status;

    status = clGetDeviceIDs(this->platform, CL_DEVICE_TYPE_ALL, 0, NULL, &num_devices_avail);
    checkError(status, this, "Query for number of devices failed");

    //printf("Expected number of devices: %u, got: %u\n", this->num_devices, num_devices_avail);
    checkError(num_devices_avail < this->num_devices ? CL_INVALID_DEVICE : CL_SUCCESS, this, "Number of Devices too low");

    devices = new cl_device_id[num_devices_avail];
    status = clGetDeviceIDs(this->platform, CL_DEVICE_TYPE_ALL, num_devices_avail, devices, NULL);
    checkError(status, this, "Query for device ids");
    
    for(size_t i = 0;i < this->num_devices;i++)
    {
        this->device[i] = devices[i];
    }
    delete[] devices;
}

void Execution_data::print_device_info()
{
    // User-visible output - Platform information
    constexpr int STRING_BUFFER_LEN=1024;
    char char_buffer[STRING_BUFFER_LEN]; 
    printf("Querying platform for info:\n");
    printf("==========================\n");
    clGetPlatformInfo(this->platform, CL_PLATFORM_NAME, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_NAME", char_buffer);
    clGetPlatformInfo(this->platform, CL_PLATFORM_VENDOR, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n", "CL_PLATFORM_VENDOR ", char_buffer);
    clGetPlatformInfo(this->platform, CL_PLATFORM_VERSION, STRING_BUFFER_LEN, char_buffer, NULL);
    printf("%-40s = %s\n\n", "CL_PLATFORM_VERSION ", char_buffer);
    for(size_t i = 0;i < this->num_devices;i++)
    {
        aocl_utils::display_device_info(this->device[i]);
    }
    fflush(stdout);
}

void Execution_data::create_context()
{
    // Create the context.
    cl_int status;
    this->context = clCreateContext(NULL, this->num_devices, &this->device[0], &aocl_utils::oclContextCallback, NULL, &status);
    checkError(status, this, "Failed to create context");
}

void Execution_data::create_command_queue()
{
    cl_int status;
    // Create the command queue
    if(solver_type.find("lrb") != std::string::npos && (suffix.find("_no_sync") != std::string::npos || suffix.find("_sp") != std::string::npos || suffix.find("_hybrid") != std::string::npos))
    { 
        for(size_t i = 0;i < this->num_devices;i++)
        {
            this->compute_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for compute kernel");
            this->local_part_buffer_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for local part buffer kernel");
            this->remote_part_buffer_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for remote part buffer kernel");
            this->local_force_cache_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for local force cache kernel");
            this->remote_force_cache_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for remote force cache kernel");
            this->remote_force_comm_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for remote force comm kernel");
            this->integrator_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for integrator kernel");
        }
    }
    else if(this->solver_type == "lrb")
    {
        for(size_t i = 0;i < this->num_devices;i++)
        {
            this->compute_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for compute kernel");
            this->cache_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for cache kernel");
            this->recv_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for remote recv kernel");
            this->send_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for remote send kernel");
        }
    }
    else
    {
        for(size_t i = 0;i < this->num_devices;i++)
        {
            this->compute_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for compute kernel");
            this->recv_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for recv kernel");
            this->send_queue[i] = clCreateCommandQueue(this->context, this->device[i], CL_QUEUE_PROFILING_ENABLE, &status);
            checkError(status, this, "Failed to create command queue for send kernel");
        }
    }
}

void Execution_data::create_program()
{
    // Create the program.
    std::string binary_file[this->num_devices];
    std::string compute_kernel_name[this->num_devices];
    std::string recv_kernel_name[this->num_devices];
    std::string send_kernel_name[this->num_devices];
    std::string cache_kernel_name[this->num_devices];
    std::string remote_kernel_name[this->num_devices];

    std::string local_part_buffer_kernel_name[this->num_devices];
    std::string remote_part_buffer_kernel_name[this->num_devices];
    std::string local_force_cache_kernel_name[this->num_devices];
    std::string remote_force_cache_kernel_name[this->num_devices];
    std::string remote_force_comm_kernel_name[this->num_devices];
    std::string integrator_kernel_name[this->num_devices];


    std::string solver_type_extension = std::string("");
    std::string integration_kind_extension = std::string("");


    if(solver_type == "reduced")
        solver_type_extension = std::string("red");
    else
        solver_type_extension = std::string(solver_type);

    if(integration_kind != std::string(""))integration_kind_extension = std::string("_") + integration_kind;
    
    for(size_t i = 0;i < this->num_devices;i++)
    {
        if(is_emulation)
            binary_file[i] = std::string("ring_") + solver_type_extension + integration_kind_extension + suffix +std::to_string(i) + std::string(".aocx");
        else
        {
            if(solver_type.find("lrb") != std::string::npos)
            {
                std::stringstream ss;
                ss << "bin/ring_" << solver_type_extension << "_" << local_PE_dim << "x" << remote_PE_dim << "PE" << integration_kind_extension << suffix << ".aocx"; 
                binary_file[i] = ss.str();
                //binary_file[i] = std::string("bin/ring_") + 
                //                 solver_type_extension + 
                //                 std::string("_") + 
                //                 std::to_string(local_PE_dim) +
                //                 std::string("x") + 
                //                 std::to_string(remote_PE_dim) +
                //                 std::string("PE") + 
                //                 integration_kind_extension + 
                //                 suffix + 
                //                 std::string(".aocx");
            }
            else
                binary_file[i] = std::string("bin/ring_") + solver_type_extension + std::string("_") + std::to_string(CU) + std::string("CU") + integration_kind_extension + suffix + std::string(".aocx");
        }
        
        if(solver_type.find("lrb") != std::string::npos && (suffix.find("_no_sync") != std::string::npos || suffix.find("_sp") != std::string::npos || suffix.find("_hybrid") != std::string::npos))
        { 
            compute_kernel_name[i] = std::string("compute_forces");
            local_part_buffer_kernel_name[i] = std::string("local_particle_buffer");
            remote_part_buffer_kernel_name[i] = std::string("remote_particle_buffer");
            local_force_cache_kernel_name[i] = std::string("local_force_cache");
            remote_force_cache_kernel_name[i] = std::string("remote_force_cache");
            remote_force_comm_kernel_name[i] = std::string("remote_force_comm");
            integrator_kernel_name[i] = std::string("integrator");
        }
        else if(solver_type == "lrb")
        { 
            compute_kernel_name[i] = std::string("compute_forces");
            cache_kernel_name[i] = std::string("force_cache_accumulator");
            recv_kernel_name[i] = std::string("remote_recv");
            send_kernel_name[i] = std::string("remote_send");
        }
        else
        {
            compute_kernel_name[i] = std::string("ring_stream");
            recv_kernel_name[i] = std::string("recv_kernel");
            send_kernel_name[i] = std::string("send_kernel");
        }
    }
    // Load the binary.
    cl_int status;
    cl_int binary_status;
    for(int i = 0;i < this->num_devices;i++)
    {
        if(debug)printf("Using AOCX: %s\n", binary_file[i].c_str());
        if(!aocl_utils::fileExists(binary_file[i].c_str())) 
        {
            printf("AOCX file '%s' does not exist.\n", binary_file[i].c_str());
            checkError(CL_INVALID_PROGRAM, this, "Failed to load binary file");
        }
        size_t binary_size;
        aocl_utils::scoped_array<unsigned char> binary(aocl_utils::loadBinaryFile(binary_file[i].c_str(), &binary_size));
        if(binary == NULL) 
            checkError(CL_INVALID_PROGRAM, this, "Failed to load binary file");

        if(debug)printf("Successfully read binary file\n");
        unsigned char* bin_ptr;
        bin_ptr = binary.get();

        size_t bin_sizes;
        bin_sizes = binary_size;

        this->program[i] = clCreateProgramWithBinary(this->context, 1, &this->device[i], &bin_sizes,
          (const unsigned char**)&bin_ptr, &binary_status, &status);
        checkError(status, this, "Failed to create program with binary");
        checkError(binary_status, this,  "Failed to load binary for device");
        if(debug)printf("Successfully loaded Program %d\n",i);    
        // Build the program that was just created.
        status = clBuildProgram(this->program[i], 0, NULL, "", NULL, NULL);
        checkError(status, this, "Failed to build program %d\n", i);
        if(debug)printf("Successfully build Program %d\n",i);
        // Create the kernel - name passed in here must match kernel name in the
        // original CL file, that was compiled into an AOCX file using the AOC tool
       
        //Use to check what kernel names exist in aocx program 
        /*
        cl_kernel kernels[4];
        cl_uint num_kernels;
        status = clCreateKernelsInProgram(this->program[i], 4, kernels, &num_kernels);
        checkError(status, this, "Failed to create kernels\n");
        for(cl_uint i = 0;i < num_kernels;i++)
        {
            char name_buffer[1024];
            size_t name_length;
            status = clGetKernelInfo(kernels[i], CL_KERNEL_FUNCTION_NAME, 1024, name_buffer, &name_length);
            checkError(status, this, "Failed to query kernel name %d\n", i);
            printf("Kernel name length : %u, name: %s\n", name_length, name_buffer);
        }
        */ 


        if(solver_type.find("lrb") != std::string::npos && (suffix.find("_no_sync") != std::string::npos || suffix.find("_sp") != std::string::npos || suffix.find("_hybrid") != std::string::npos))
        { 
            this->compute_kernel[i] = clCreateKernel(this->program[i], compute_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create ring kernel %d\n", i);
            if(debug)printf("Successfully created compute ring kernel %d\n", i);
            this->local_part_buffer_kernel[i] = clCreateKernel(this->program[i], local_part_buffer_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create local particle buffer kernel %d\n", i);
            if(debug)printf("Successfully created local particle buffer kernel %d\n", i);
            this->remote_part_buffer_kernel[i] = clCreateKernel(this->program[i], remote_part_buffer_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create remote particle buffer kernel %d\n", i);
            if(debug)printf("Successfully created remote particle buffer kernel %d\n", i);
            this->local_force_cache_kernel[i] = clCreateKernel(this->program[i], local_force_cache_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create local force cache kernel %d\n", i);
            if(debug)printf("Successfully created local force cache kernel %d\n", i);
            this->remote_force_cache_kernel[i] = clCreateKernel(this->program[i], remote_force_cache_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create remote force cache kernel %d\n", i);
            if(debug)printf("Successfully created remote force cache kernel %d\n", i);
            if(solver_type == "lrbd")
            {
                this->remote_force_comm_kernel[i] = clCreateKernel(this->program[i], remote_force_comm_kernel_name[i].c_str(), &status);
                checkError(status, this, "Failed to create remote force comm kernel %d\n", i);
                if(debug)printf("Successfully created remote force comm kernel %d\n", i);
            }
            this->integrator_kernel[i] = clCreateKernel(this->program[i], integrator_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create integrator kernel %d\n", i);
            if(debug)printf("Successfully created integrator kernel %d\n", i);
        }
        else if(solver_type == "lrb")
        { 
            this->compute_kernel[i] = clCreateKernel(this->program[i], compute_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create ring kernel %d\n", i);
            if(debug)printf("Successfully created compute ring kernel %d\n", i);
            this->cache_kernel[i] = clCreateKernel(this->program[i], cache_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create cache kernel %d\n", i);
            if(debug)printf("Successfully created cache kernel %d\n", i);
            this->recv_kernel[i] = clCreateKernel(this->program[i], recv_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create remote recv kernel %d\n", i);
            if(debug)printf("Successfully created remote recv kernel %d\n", i);
            this->send_kernel[i] = clCreateKernel(this->program[i], send_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create remote send kernel %d\n", i);
            if(debug)printf("Successfully created remote send kernel %d\n", i);
        }
        else
        { 
            this->compute_kernel[i] = clCreateKernel(this->program[i], compute_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create ring kernel %d\n", i);
            if(debug)printf("Successfully created compute ring kernel %d\n", i);
            this->recv_kernel[i] = clCreateKernel(this->program[i], recv_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create recv kernel %d\n", i);
            if(debug)printf("Successfully created recv kernel %d\n", i);
            this->send_kernel[i] = clCreateKernel(this->program[i], send_kernel_name[i].c_str(), &status);
            checkError(status, this, "Failed to create send kernel %d\n", i);
            if(debug)printf("Successfully created send kernel %d\n", i);
        }

    }
}
