// Copyright (C) 2013-2018 Altera Corporation, San Jose, California, USA. All rights reserved.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
// whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// 
// This agreement shall be governed in all respects by the laws of the State of California and
// by the laws of the United States of America.

// OpenCL utility functions.

#ifndef AOCL_UTILS_OPENCL_H
#define AOCL_UTILS_OPENCL_H

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>

#include "CL/opencl.h"


namespace aocl_utils {

// Host allocation functions
void *alignedMalloc(size_t size);
void alignedFree(void *ptr);

// Error functions
void printError(cl_int error);

// Sets the current working directory to the same directory that contains
// this executable. Returns true on success.
bool setCwdToExeDir();

// Load binary file.
// Return value must be freed with delete[].
unsigned char *loadBinaryFile(const char *file_name, size_t *size);

// Checks if a file exists.
bool fileExists(const char *file_name);

// Returns the path to the AOCX file to use for the given device.
// This is special handling for examples for the Intel(R) FPGA SDK for OpenCL(TM).
// It uses the device name to get the board name and then looks for a
// corresponding AOCX file. Specifically, it gets the device name and
// extracts the board name assuming the device name has the following format:
//  <board> : ...
//
// Then the AOCX file is <prefix>_<version>_<board>.aocx. If this
// file does not exist, then the file name defaults to <prefix>.aocx.
std::string getBoardBinaryFile(const char *prefix, cl_device_id device);

// Returns the time from a high-resolution timer in seconds. This value
// can be used with a value returned previously to measure a high-resolution
// time difference.
double getCurrentTimestamp();

// Returns the difference between the CL_PROFILING_COMMAND_END and
// CL_PROFILING_COMMAND_START values of a cl_event object.
// This requires that the command queue associated with the event be created
// with the CL_QUEUE_PROFILING_ENABLE property.
//
// The return value is in nanoseconds.
cl_ulong getStartEndTime(cl_event event);

// Returns the maximum time span for the given set of events.
// The time span starts at the earliest event start time.
// The time span ends at the latest event end time.
cl_ulong getStartEndTime(cl_event *events, unsigned num_events);

// Wait for the specified number of milliseconds.
void waitMilliseconds(unsigned ms);

// OpenCL context callback function that simply prints the error information
// to stdout (via printf).
void oclContextCallback(const char *errinfo, const void *, size_t, void *);

void device_info_ulong( cl_device_id device, cl_device_info param, const char* name);
void device_info_uint( cl_device_id device, cl_device_info param, const char* name);
void device_info_bool( cl_device_id device, cl_device_info param, const char* name);
void device_info_string( cl_device_id device, cl_device_info param, const char* name);
void display_device_info( cl_device_id device );
} // ns aocl_utils

#endif

