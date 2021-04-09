#ifndef ERROR_H_
#define ERROR_H_

#include<stdio.h>
#include<stdlib.h>
#include <stdarg.h>

#include "execution_data.h"
#include "AOCLUtils/aocl_utils.h"
#include "CL/opencl.h"
// Print line, file name, and error code if there is an error. Exits the
// application upon error.
void _checkError(int line,
                 const char *file,
                 cl_int error,
                 Execution_data* exec_data,
                 const char *msg,
                 ...);
#define checkError(status, exec_data, ...) _checkError(__LINE__, __FILE__, status, exec_data, __VA_ARGS__)
#endif
