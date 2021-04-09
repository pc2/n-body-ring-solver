#include "micro_bench.h"
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <string>
#include <map>

enum class Benchmark_type
{
    ACCURACY_SQRT,
    MICRO_SQRT, MICRO_SQRT_FMA, MICRO_DIV, MICRO_INVSQRT, MICRO_RSQRT, MICRO_RSQRT_FMA, MICRO_RSQRT_ITER, MICRO_FMA, MICRO_INT
};

void get_arguments(int argc, char** argv, std::string& bench_type, size_t* bit_width)
{
    *bit_width = 512;
    bench_type = std::string("None");
    for(int i = 1; i<argc; i++)
    {
        if(strcmp(argv[i], "-t") == 0)
        {
            if(i+1 < argc)
                bench_type = std::string(argv[++i]);
        }
        else if(strcmp(argv[i], "-w") == 0)
        {
            if(i+1 < argc)
                *bit_width = strtoul(argv[++i],NULL,10);
        }
    }
    if(*bit_width != 512 && *bit_width != 256)
    {
        printf("Failed to read Arguments!\nResetting to defaults");
        *bit_width = 512;
    }


}

int main(int argc, char** argv)
{
    LIKWID_MARKER_INIT;
    LIKWID_MARKER_THREADINIT;
    

    //convert string to token for easier use in switch-case
    std::map<std::string, Benchmark_type> convert_str_to_bench_type;
    convert_str_to_bench_type["sqrt"] = Benchmark_type::MICRO_SQRT;
    convert_str_to_bench_type["sqrt+fma"] = Benchmark_type::MICRO_SQRT_FMA;
    convert_str_to_bench_type["div"] = Benchmark_type::MICRO_DIV;
    convert_str_to_bench_type["invsqrt"] = Benchmark_type::MICRO_INVSQRT;
    convert_str_to_bench_type["rsqrt"] = Benchmark_type::MICRO_RSQRT;
    convert_str_to_bench_type["rsqrt+fma"] = Benchmark_type::MICRO_RSQRT_FMA;
    convert_str_to_bench_type["rsqrt+iter"] = Benchmark_type::MICRO_RSQRT_ITER;
    convert_str_to_bench_type["fma"] = Benchmark_type::MICRO_FMA;
    convert_str_to_bench_type["int"] = Benchmark_type::MICRO_INT;
    convert_str_to_bench_type["accuracy-sqrt"] = Benchmark_type::ACCURACY_SQRT;
    
    size_t bit_width;
    std::string bench_type_str;
    get_arguments(argc, argv, bench_type_str, &bit_width);
 
    Benchmark_type bench_type;
    if(convert_str_to_bench_type.find(bench_type_str) == convert_str_to_bench_type.end())
    {
        printf("Unknown benchmark: %s\n", bench_type_str.c_str());
        return 0;
    }
    else
    {
        bench_type = convert_str_to_bench_type[bench_type_str];
        LIKWID_MARKER_REGISTER(bench_type_str.c_str());
    }


    printf("Using %zu threads\n", NUM_CORES);
    //A seperate buffer for each core
    __m512d buffer512[NUM_CORES][instr_rep];
    __m256d buffer256[NUM_CORES][instr_rep];
    uint64_t ibuffer[NUM_CORES][instr_rep];

    #pragma omp parallel for num_threads(NUM_CORES) 
    for(size_t core = 0;core < NUM_CORES;core++)
    {
        switch(bench_type)
        {
            case Benchmark_type::MICRO_SQRT:
                if(bit_width == 512)micro_bench::sqrt_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::sqrt_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_SQRT_FMA:
                if(bit_width == 512)micro_bench::sqrt_fma_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::sqrt_fma_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_DIV:
                if(bit_width == 512)micro_bench::div_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::div_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_INVSQRT:
                if(bit_width == 512)micro_bench::invsqrt_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::invsqrt_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_RSQRT:
                if(bit_width == 512)micro_bench::rsqrt_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::rsqrt_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_RSQRT_FMA:
                if(bit_width == 512)micro_bench::rsqrt_fma_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::rsqrt_fma_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_RSQRT_ITER:
                if(bit_width == 512)micro_bench::rsqrt_iter_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::rsqrt_iter_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_FMA:
                if(bit_width == 512)micro_bench::fma_avx512(buffer512[NUM_CORES]);
                else if(bit_width == 256)micro_bench::fma_avx256(buffer256[NUM_CORES]);
            break;
            case Benchmark_type::MICRO_INT:
                micro_bench::int_avx512(ibuffer[NUM_CORES]);
            break;
            case Benchmark_type::ACCURACY_SQRT:
                if(core == 0)sqrt_accuracy(1e-20,1e20,10000000);
            break;

        }
    }
    
    LIKWID_MARKER_CLOSE;
    return 0;
}


//The micro-benchmarks are all of a similar form:
//function name includes used register width
//function has a buffer argument for which the compiler can not make any assumptions
void micro_bench::sqrt_avx256(__m256d buffer[ind_instr])
{
 
    //preload data into the used registers   
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }

    LIKWID_MARKER_START("sqrt");
    //Repeat the benchmark long enough, so that likwid-perfctr can collect data
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        //Make sure to unroll the independent instruction repetitions
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            //This loop is automatically unrolled by the compiler
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm256_sqrt_pd(buffer[i]);
            } 
        }
    }

    LIKWID_MARKER_STOP("sqrt");
}

void micro_bench::sqrt_fma_avx256(__m256d buffer[ind_instr])
{  
    __m256d sqrt_val;
    sqrt_val = _mm256_set_pd(8.0+1.0,8.0*2.0,8.0*3.0,8.0*4.0);
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("sqrt+fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            sqrt_val = _mm256_sqrt_pd(sqrt_val); 
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm256_fmadd_pd(buffer[i], buffer[i], buffer[i]);
                /*asm volatile ("vsqrtpd %0, %0\n\t"
                              "vfmadd132pd %3, %4, %5\n\t"
                              : "=v" (buffer_sqrt[i]), "=v" (buffer_fma1[i])
                              : "v" (buffer_sqrt[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i])
                              );*/

            }
            
        }
    }
    LIKWID_MARKER_STOP("sqrt+fma");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_add_pd(sqrt_val, buffer[i]);
    }
}

void micro_bench::div_avx256(__m256d buffer[ind_instr])
{
    __m256d numerator[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
        numerator[i] = _mm256_set1_pd(1.0);
    }
    LIKWID_MARKER_START("div");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm256_div_pd(numerator[i],buffer[i]); 
                /*asm volatile ("vdivpd %1, %2, %0\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i]), "v" (numerator[i])
                              );*/
            }
            
        }
    }
    LIKWID_MARKER_STOP("div");
}

void micro_bench::invsqrt_avx256(__m256d buffer[ind_instr])
{
    
    __m256d buffer_invsqrt[ind_instr];
    __m256d numerator[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer_invsqrt[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
        numerator[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("invsqrt");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer_invsqrt[i] = _mm256_sqrt_pd(buffer_invsqrt[i]); 
                /*asm volatile ("vsqrtpd %0, %1\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i])
                              );*/
            } 
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer_invsqrt[i] = _mm256_div_pd(numerator[i],buffer_invsqrt[i]); 
                /*asm volatile ("vdivpd %1, %2, %0\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i]), "v" (numerator[i])
                              );*/
            } 
        }
    }    
    LIKWID_MARKER_STOP("invsqrt");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_add_pd(buffer_invsqrt[i], buffer[i]);
    }
}

void micro_bench::rsqrt_avx256(__m256d buffer[ind_instr])
{
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("rsqrt"); 
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
                buffer[i] = _mm256_rsqrt14_pd(buffer[i]);
        }
    }
    LIKWID_MARKER_STOP("rsqrt"); 
}

void micro_bench::rsqrt_fma_avx256(__m256d buffer[ind_instr])
{  
    __m256d rsqrt_val[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]    = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
        rsqrt_val[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("rsqrt+fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                rsqrt_val[i] = _mm256_rsqrt14_pd(rsqrt_val[i]); 
            }
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm256_fmadd_pd(buffer[i], buffer[i], buffer[i]);
                /*asm volatile ("vsqrtpd %0, %0\n\t"
                              "vfmadd132pd %3, %4, %5\n\t"
                              : "=v" (buffer_sqrt[i]), "=v" (buffer_fma1[i])
                              : "v" (buffer_sqrt[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i])
                              );*/

            }
            
        }
    }
    LIKWID_MARKER_STOP("rsqrt+fma");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_add_pd(rsqrt_val[i], buffer[i]);
    }
}

void micro_bench::rsqrt_iter_avx256(__m256d buffer[ind_instr])
{
    __m256d buffer_approx[ind_instr];
    __m256d three = _mm256_set1_pd(3.0);
    __m256d half = _mm256_set1_pd(0.5);
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
        buffer_approx[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("rsqrt+iter"); 
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm256_rsqrt14_pd(buffer[i]);
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_mul_pd(buffer[i],buffer[i]); // y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_mul_pd(buffer_approx[i],buffer[i]); //x*y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_sub_pd(three, buffer_approx[i]); //3-x*y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm256_mul_pd(buffer[i], half);//y*0.5
        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm256_mul_pd(buffer[i],buffer_approx[i]);//y*0.5 *(3-x*y*y)
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_mul_pd(buffer[i],buffer[i]); // y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_mul_pd(buffer_approx[i],buffer[i]); //x*y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer_approx[i] = _mm256_sub_pd(three, buffer_approx[i]); //3-x*y*y
        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm256_mul_pd(buffer[i], half);//y*0.5
        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm256_mul_pd(buffer[i],buffer_approx[i]);//y*0.5 *(3-x*y*y)
    }
    LIKWID_MARKER_STOP("rsqrt+iter"); 
}

void micro_bench::fma_avx256(__m256d buffer[ind_instr])
{
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm256_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0);
    }
    LIKWID_MARKER_START("fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
                buffer[i] = _mm256_fmadd_pd(buffer[i],buffer[i],buffer[i]);
        }
    }
    LIKWID_MARKER_STOP("fma");
}

void micro_bench::sqrt_avx512(__m512d buffer[ind_instr])
{
    
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }

    LIKWID_MARKER_START("sqrt");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm512_sqrt_pd(buffer[i]);
            } 
        }
    }

    LIKWID_MARKER_STOP("sqrt");
}

void micro_bench::sqrt_fma_avx512(__m512d buffer[ind_instr])
{  
    __m512d sqrt_val;
    sqrt_val = _mm512_set_pd(8.0+1.0,8.0*2.0,8.0*3.0,8.0*4.0,8.0*5.0,8.0*6.0,8.0*7.0,8.0*8.0);
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    LIKWID_MARKER_START("sqrt+fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            sqrt_val = _mm512_sqrt_pd(sqrt_val); 
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm512_fmadd_pd(buffer[i], buffer[i], buffer[i]);
                /*asm volatile ("vsqrtpd %0, %0\n\t"
                              "vfmadd132pd %3, %4, %5\n\t"
                              : "=v" (buffer_sqrt[i]), "=v" (buffer_fma1[i])
                              : "v" (buffer_sqrt[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i])
                              );*/

            }
            
        }
    }
    LIKWID_MARKER_STOP("sqrt+fma");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm512_add_pd(sqrt_val, buffer[i]);
    }
}

void micro_bench::div_avx512(__m512d buffer[ind_instr])
{
    __m512d numerator[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
        numerator[i] = _mm512_set1_pd(1.0);
    }
    LIKWID_MARKER_START("div");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm512_div_pd(numerator[i],buffer[i]); 
                /*asm volatile ("vdivpd %1, %2, %0\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i]), "v" (numerator[i])
                              );*/
            }
            
        }
    }
    LIKWID_MARKER_STOP("div");
}

void micro_bench::invsqrt_avx512(__m512d buffer[ind_instr])
{
    
    __m512d buffer_invsqrt[ind_instr];
    __m512d numerator[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer_invsqrt[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
        numerator[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    LIKWID_MARKER_START("invsqrt");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer_invsqrt[i] = _mm512_sqrt_pd(buffer_invsqrt[i]); 
                /*asm volatile ("vsqrtpd %0, %1\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i])
                              );*/
            } 
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer_invsqrt[i] = _mm512_div_pd(numerator[i],buffer_invsqrt[i]); 
                /*asm volatile ("vdivpd %1, %2, %0\n\t"
                              : "=v" (buffer_invsqrt[i])
                              : "v" (buffer_invsqrt[i]), "v" (numerator[i])
                              );*/
            } 
        }
    }    
    LIKWID_MARKER_STOP("invsqrt");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm512_add_pd(buffer_invsqrt[i], buffer[i]);
    }
}

void micro_bench::rsqrt_avx512(__m512d buffer[ind_instr])
{
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    LIKWID_MARKER_START("rsqrt"); 
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
                buffer[i] = _mm512_rsqrt14_pd(buffer[i]);
        }
    }
    LIKWID_MARKER_STOP("rsqrt"); 
}

void micro_bench::rsqrt_fma_avx512(__m512d buffer[ind_instr])
{  
    __m512d rsqrt_val[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
        rsqrt_val[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    LIKWID_MARKER_START("rsqrt+fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                rsqrt_val[i] = _mm512_rsqrt14_pd(rsqrt_val[i]); 
            }
            for(size_t i = 0;i < ind_instr;i++)
            {
                buffer[i] = _mm512_fmadd_pd(buffer[i], buffer[i], buffer[i]);
                /*asm volatile ("vsqrtpd %0, %0\n\t"
                              "vfmadd132pd %3, %4, %5\n\t"
                              : "=v" (buffer_sqrt[i]), "=v" (buffer_fma1[i])
                              : "v" (buffer_sqrt[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i]), "v" (buffer_fma1[i])
                              );*/

            }
            
        }
    }
    LIKWID_MARKER_STOP("rsqrt+fma");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] = _mm512_add_pd(rsqrt_val[i], buffer[i]);
    }
}

void micro_bench::rsqrt_iter_avx512(__m512d buffer[ind_instr])
{
    __m512d buffer_tmp[ind_instr];
    __m512d buffer_out[ind_instr];
    __m512d three = _mm512_set1_pd(3.0);
    __m512d half = _mm512_set1_pd(0.5);
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
        buffer_tmp[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
        buffer_out[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    asm volatile("": : :"memory");
    LIKWID_MARKER_START("rsqrt+iter"); 
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        for(size_t i = 0;i < ind_instr;i++)
            buffer_out[i] = _mm512_rsqrt14_pd(buffer[i]); // y = rsqrt(x)
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer_tmp[i] = _mm512_mul_pd(buffer_out[i],buffer_out[i]); // y*y
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer_out[i] = _mm512_mul_pd(buffer_out[i], half);// y*0.5
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
        {
            buffer_tmp[i] = _mm512_fnmadd_pd(buffer[i], buffer_tmp[i],three); //3-x*y*y
        } 
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer_out[i] = _mm512_mul_pd(buffer_out[i],buffer_tmp[i]);//y*0.5 *(3-x*y*y)
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer_tmp[i] = _mm512_mul_pd(buffer_out[i],buffer_out[i]); // y*y
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer_out[i] = _mm512_mul_pd(buffer_out[i], half);// y*0.5
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
        {
            buffer_tmp[i] = _mm512_fnmadd_pd(buffer[i], buffer_tmp[i],three); //3-x*y*y
        } 
        asm volatile("": : :"memory");

        for(size_t i = 0;i < ind_instr;i++)
            buffer[i] = _mm512_mul_pd(buffer_out[i],buffer_tmp[i]);//y*0.5 *(3-x*y*y)
        asm volatile("": : :"memory");
    }
    LIKWID_MARKER_STOP("rsqrt+iter"); 
}

void micro_bench::fma_avx512(__m512d buffer[ind_instr])
{
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i]   = _mm512_set_pd(8.0*i+1.0,8.0*i+2.0,8.0*i+3.0,8.0*i+4.0,8.0*i+5.0,8.0*i+6.0,8.0*i+7.0,8.0*i+8.0);
    }
    LIKWID_MARKER_START("fma");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
                buffer[i] = _mm512_fmadd_pd(buffer[i],buffer[i],buffer[i]);
        }
    }
    LIKWID_MARKER_STOP("fma");
}

//This benchmark is for testing the maximum achievable clock frequency
void micro_bench::int_avx512(uint64_t buffer[ind_instr])
{
    uint64_t vals1[ind_instr];
    uint64_t vals2[ind_instr];
    for(size_t i = 0;i < ind_instr;i++)
    {
        vals1[i] = i;
        vals2[i] = ind_instr-i;
    }
    
    LIKWID_MARKER_START("int");
    for(size_t steps = 0;steps < num_iter;steps++)
    {
        #pragma GCC unroll 65534
        for(size_t j = 0;j < 10*instr_rep;j++)
        {
            for(size_t i = 0;i < ind_instr;i++)
            {
                asm volatile ("addq %1, %0\n\t"
                              : "=r" (vals1[i])
                              : "r" (vals2[i])
                              );
            }
        }
    }
    LIKWID_MARKER_STOP("int");
    for(size_t i = 0;i < ind_instr;i++)
    {
        buffer[i] += vals1[i];
    }
}

//Calculates the inverse square root for num_iter Elements, 
//which are chosen equidistant over the interval [low_bound,high_bound] 
//The inverse square root is calculated using:
//1. sqrt+div
//2. rsqrt
//3. rsqrt + 1 refinement step
//4. rsqrt + 2 refinement steps
//The results are evaluated using the relative error to the true solution (1/input_number)
void sqrt_accuracy(double low_bound, double high_bound, size_t num_elements)
{
    if(num_elements % 8 != 0)
    {
        printf("Testsize must be divisible by 8!\n");
        return;
    }  
        
    double* input = (double*)aligned_alloc(64, num_elements*sizeof(double));
    double* sqrt_out = (double*)aligned_alloc(64, num_elements*sizeof(double));
    double* rsqrt0_out = (double*)aligned_alloc(64, num_elements*sizeof(double));
    double* rsqrt1_out = (double*)aligned_alloc(64, num_elements*sizeof(double));
    double* rsqrt2_out = (double*)aligned_alloc(64, num_elements*sizeof(double));

    __m512d one = _mm512_set1_pd(1.0);
    __m512d three = _mm512_set1_pd(3.0);
    __m512d half = _mm512_set1_pd(0.5);
    
    double delta = (low_bound + high_bound)/(num_elements-1);

    for(size_t i = 0;i < num_elements;i++)
        input[i] = low_bound + i * delta;
        
    for(size_t i = 0;i < num_elements;i+=8)
    {
        __m512d inp = _mm512_load_pd(&(input[i]));
        inp = _mm512_sqrt_pd(inp);
        inp = _mm512_div_pd(one,inp);
        _mm512_store_pd(&(sqrt_out[i]), inp);
         
        inp = _mm512_load_pd(&(input[i]));
        __m512d inp_rsqrt = _mm512_rsqrt14_pd(inp);
        _mm512_store_pd(&(rsqrt0_out[i]), inp_rsqrt);
        __m512d inp_approx = _mm512_mul_pd(inp_rsqrt,inp_rsqrt); // y*y
        inp_approx = _mm512_mul_pd(inp_approx,inp); //x*y*y
        inp_approx = _mm512_sub_pd(three, inp_approx); //3-x*y*y
        __m512d inp_half = _mm512_mul_pd(inp_rsqrt, half);//y*0.5
        inp_rsqrt = _mm512_mul_pd(inp_half,inp_approx);//y*0.5 *(3-x*y*y)
        _mm512_store_pd(&(rsqrt1_out[i]), inp_rsqrt);
        inp_approx = _mm512_mul_pd(inp_rsqrt,inp_rsqrt); // y*y
        inp_approx = _mm512_mul_pd(inp_approx,inp); //x*y*y
        inp_approx = _mm512_sub_pd(three, inp_approx); //3-x*y*y
        inp_half = _mm512_mul_pd(inp_rsqrt, half);//y*0.5
        inp = _mm512_mul_pd(inp_half,inp_approx);//y*0.5 *(3-x*y*y)
        _mm512_store_pd(&(rsqrt2_out[i]), inp);
        for(size_t j = 0;j < 8;j++)
        {
            //printf("%d: Expected %f, Got %f\n", i+j, 1.0/input[i+j], rsqrt_out[i+j]*rsqrt_out[i+j]);
        }
    }

    double sqrt_max_error = 0.0;
    size_t sqrt_max_error_idx = 0;
    double sqrt_mean_error = 0.0;

    double rsqrt0_max_error = 0.0;
    size_t rsqrt0_max_error_idx = 0;
    double rsqrt0_mean_error = 0.0;
    
    double rsqrt1_max_error = 0.0;
    size_t rsqrt1_max_error_idx = 0;
    double rsqrt1_mean_error = 0.0;
    
    double rsqrt2_max_error = 0.0;
    size_t rsqrt2_max_error_idx = 0;
    double rsqrt2_mean_error = 0.0;
    for(size_t i = 0;i < num_elements;i++)
    {
        double new_error = std::abs((( sqrt_out[i]* sqrt_out[i]) - 1.0/input[i]))/(1.0/input[i]);
        if(new_error > sqrt_max_error)
        {
            sqrt_max_error = new_error;
            sqrt_max_error_idx = i;
        }
        sqrt_mean_error += new_error;
        
        new_error = std::abs((( rsqrt0_out[i]* rsqrt0_out[i]) - 1.0/input[i]))/(1.0/input[i]);
        if(new_error > rsqrt0_max_error)
        {
            rsqrt0_max_error = new_error;
            rsqrt0_max_error_idx = i;
        }
        rsqrt0_mean_error += new_error;
        
        new_error = std::abs((( rsqrt1_out[i]* rsqrt1_out[i]) - 1.0/input[i]))/(1.0/input[i]);
        if(new_error > rsqrt1_max_error)
        {
            rsqrt1_max_error = new_error;
            rsqrt1_max_error_idx = i;
        }
        rsqrt1_mean_error += new_error;
        
        new_error = std::abs((( rsqrt2_out[i]* rsqrt2_out[i]) - 1.0/input[i]))/(1.0/input[i]);
        if(new_error > rsqrt2_max_error)
        {
            rsqrt2_max_error = new_error;
            rsqrt2_max_error_idx = i;
        }
        rsqrt2_mean_error += new_error;
    }
    printf("Invsqrt           : Largest error: %.10e at %.10e; mean error: %.10e\n", sqrt_max_error, input[sqrt_max_error_idx], sqrt_mean_error/num_elements);
    printf("rsqrt 0 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n", rsqrt0_max_error, input[rsqrt0_max_error_idx], rsqrt0_mean_error/num_elements);
    printf("rsqrt 1 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n", rsqrt1_max_error, input[rsqrt1_max_error_idx], rsqrt1_mean_error/num_elements);
    printf("rsqrt 2 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n", rsqrt2_max_error, input[rsqrt2_max_error_idx], rsqrt2_mean_error/num_elements);
    

}
