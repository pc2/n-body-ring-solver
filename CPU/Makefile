
LIKWID_PATH=/cm/shared/apps/pc2/CHEM_PHYS_SW/tools/likwid_4.3.4/prefix
CXX=g++
#CXX=mpic++
CFLAGS= -mavx -O3 -fopenmp -march=native -std=c++17 -Wall
CBENCH_FLAGS = -mavx -O3 -xHost -std=c++17 -qopenmp -qopt-report=1 -qopt-report-phase=vec -qopt-report-file=stdout -qopt-zmm-usage=high

target: main.o nbody_system.o mpi_solver.o omp_solver.o hybrid_solver.o force_calculation.o
	$(CXX) main.o nbody_system.o mpi_solver.o omp_solver.o hybrid_solver.o force_calculation.o -o main.out $(CFLAGS) -lmpi
single_core_bench: single_core_bench.o nbody_system.o
	$(CXX) single_core_bench.o nbody_system.o -o single_core_bench.out $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid
micro_bench: micro_bench.o
	$(CXX) micro_bench.o -o micro_bench.out $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid

main.o: main.cpp mpi_solver.h omp_solver.h hybrid_solver.h force_calculation.h
	$(CXX) -c main.cpp $(CFLAGS) 
nbody_system.o: nbody_system.cpp nbody_system.h
	$(CXX) -c nbody_system.cpp $(CFLAGS) 
mpi_solver.o: mpi_solver.cpp mpi_solver.h nbody_system.h
	$(CXX) -c mpi_solver.cpp $(CFLAGS) 
omp_solver.o: omp_solver.cpp omp_solver.h nbody_system.h
	$(CXX) -c omp_solver.cpp $(CFLAGS) 
hybrid_solver.o: hybrid_solver.cpp hybrid_solver.h nbody_system.h
	$(CXX) -c hybrid_solver.cpp $(CFLAGS) 
force_calculation.o: force_calculation.cpp force_calculation.h nbody_system.h
	$(CXX) -c force_calculation.cpp $(CFLAGS) 
	$(CXX) -c -S -masm=intel force_calculation.cpp $(CFLAGS)
single_core_bench.o: single_core_bench.cpp nbody_system.h
	$(CXX) -c -S -masm=intel single_core_bench.cpp $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid
	$(CXX) -c single_core_bench.cpp $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid
micro_bench.o: micro_bench.cpp micro_bench.h
	$(CXX) -c micro_bench.cpp -S -masm=intel $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid
	$(CXX) -c micro_bench.cpp $(CFLAGS) -I ${LIKWID_PATH}/include -L ${LIKWID_PATH}/lib -DLIKWID_PERFMON -lm -pthread -llikwid

clean:
	rm -rf *.o
	rm -rf *.out*
