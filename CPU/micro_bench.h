#ifndef MICRO_BENCH_H_
#define MICRO_BENCH_H_

#include<immintrin.h>

#ifdef LIKWID_PERFMON
#include <likwid.h>
#else
#define LIKWID_MARKER_INIT
#define LIKWID_MARKER_THREADINIT
#define LIKWID_MARKER_SWITCH
#define LIKWID_MARKER_REGISTER(regionTag)
#define LIKWID_MARKER_START(regionTag)
#define LIKWID_MARKER_STOP(regionTag)
#define LIKWID_MARKER_CLOSE
#define LIKWID_MARKER_GET(regionTag, nevents, events, time, count)
#endif

//Number of independent instructions
//Useful values are:
//1 for Latency tests
//2 for sqrt and div throughput test
//4 for rsqrt throughput test
//8 for fma throughput test
constexpr size_t ind_instr = 1;

//Number of independent instruction repetitions
//Used for decreasing the loop overhead (counter increment, exit condition check)
constexpr size_t instr_rep = 4;

//Number of test samples to increase the runtime
//Used for minimizing "startup" effects
constexpr size_t num_iter = 1000000;

//Can be used to check whether the clock frequency is dependend on the number of cores used
//On noctua, frequency scaling for varying numbers of cores seems to be disabled
constexpr size_t NUM_CORES = 1;


//function to showcase the accuracy difference between inverse square root calculations
void sqrt_accuracy(double low_bound, double high_bound, size_t num_elements);

namespace micro_bench
{
    void sqrt_avx256(__m256d buffer[ind_instr]);
    void sqrt_fma_avx256(__m256d buffer_sqrt[ind_instr]);
    void div_avx256(__m256d buffer[ind_instr]);
    void invsqrt_avx256(__m256d buffer[ind_instr]);
    void rsqrt_avx256(__m256d buffer[ind_instr]);
    void rsqrt_fma_avx256(__m256d buffer[ind_instr]);
    void rsqrt_iter_avx256(__m256d buffer[ind_instr]);
    void fma_avx256(__m256d buffer[ind_instr]);
    
    void sqrt_avx512(__m512d buffer[ind_instr]);
    void sqrt_fma_avx512(__m512d buffer_sqrt[ind_instr]);
    void div_avx512(__m512d buffer[ind_instr]);
    void invsqrt_avx512(__m512d buffer[ind_instr]);
    void rsqrt_avx512(__m512d buffer[ind_instr]);
    void rsqrt_fma_avx512(__m512d buffer[ind_instr]);
    void rsqrt_iter_avx512(__m512d buffer[ind_instr]);
    void fma_avx512(__m512d buffer[ind_instr]);
   
    void int_avx512(uint64_t buffer[ind_instr]);
}

#endif
