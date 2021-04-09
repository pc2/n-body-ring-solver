#include "error.h"

void _checkError(int line,
                 const char *file,
                 cl_int error,
                 Execution_data* exec_data,
                 const char *msg,
                 ...) {
  // If not successful
  if(error != CL_SUCCESS) {
    // Print line and file
    printf("ERROR: ");
    aocl_utils::printError(error);
    printf("\nLocation: %s:%d\n", file, line);

    // Print custom message.
    va_list vl;
    va_start(vl, msg);
    vprintf(msg, vl);
    printf("\n");
    va_end(vl);

    // Cleanup and bail.
    exec_data->delete_execution_data();
    exit(error);
  }
}
