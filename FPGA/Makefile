HOST_COMPILE_CONFIG=-O3
#HOST_COMPILE_CONFIG=-O0 -g
AOCL_COMPILE_CONFIG=$(shell aocl compile-config)
AOCL_LINK_CONFIG=$(shell aocl link-config)
AOCL_LINK_CONFIG_EMU=-L/cm/shared/opt/intelFPGA_pro/19.4.0/hld/host/linux64/lib -lOpenCL
COMMON_DIR=common/src/AOCLUtils
AOCL_UTILS_INC=common/inc
HOST_INC=host/inc

all: main.out main.emu

main.out: main.o opencl.o options.o solver.o execution_data.o error.o 
		g++ -o main.out main.o opencl.o options.o solver.o execution_data.o error.o $(AOCL_LINK_CONFIG) -lmpi

main.emu: main.o opencl.o options.o solver.o execution_data.o error.o
		g++ -o main.emu main.o opencl.o options.o solver.o execution_data.o error.o $(AOCL_LINK_CONFIG_EMU) -lmpi

#Object files
main.o : host/main.cpp 
		g++ -c host/main.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC) -I $(HOST_INC)

solver.o: host/solver.cpp host/inc/solver.h host/inc/error.h
		g++ -c host/solver.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC) -I $(HOST_INC)

error.o: host/error.cpp host/inc/error.h
		g++ -c host/error.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC) -I $(HOST_INC)

execution_data.o: host/execution_data.cpp host/inc/execution_data.h
		g++ -c host/execution_data.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC) -I $(HOST_INC)

opencl.o: $(COMMON_DIR)/opencl.cpp
		g++ -c $(COMMON_DIR)/opencl.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC)

options.o: $(COMMON_DIR)/options.cpp
		g++ -c $(COMMON_DIR)/options.cpp $(HOST_COMPILE_CONFIG) $(AOCL_COMPILE_CONFIG) -I $(AOCL_UTILS_INC)

#OpenCL kernels for Emulation
ring_lrb_lf_no_sync_local: main.emu ring_lrb_lf_no_sync_local0.aocx
ring_lrb_lf_no_sync_local0.aocx: device/ring_lrb_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrb_lf_no_sync_local.cl -o ring_lrb_lf_no_sync_local0.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT
ring_lrb_lf_no_sync_local_nd: main.emu ring_lrb_lf_no_sync_local_nd0.aocx
ring_lrb_lf_no_sync_local_nd0.aocx: device/ring_lrb_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrb_lf_no_sync_local.cl -o ring_lrb_lf_no_sync_local0.aocx -ffp-reassoc -ffp-contract=fast

ring_lrbd_lf_no_sync_local: main.emu ring_lrbd_lf_no_sync_local0.aocx ring_lrbd_lf_no_sync_local1_nd.aocx ring_lrbd_lf_no_sync_local2_nd.aocx ring_lrbd_lf_no_sync_local3_nd.aocx
ring_lrbd_lf_no_sync_local0.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local0.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_no_sync_local1.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local1.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_no_sync_local2.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local2.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_no_sync_local3.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local3.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION3
ring_lrbd_lf_no_sync_local0_nd.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local0.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_no_sync_local1_nd.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local1.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_no_sync_local2_nd.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local2.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_no_sync_local3_nd.aocx: device/ring_lrbd_lf_no_sync_local.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync_local.cl -o ring_lrbd_lf_no_sync_local3.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION3

#OpenCL reports
report_lrb_lf_no_sync_local:
	aoc -rtl -ffp-reassoc -ffp-contract=fast device/ring_lrb_lf_no_sync_local.cl -o report_lrb_lf_no_sync_local.aocr

report_lrbd_lf_no_sync_local:
	aoc -rtl -ffp-reassoc -ffp-contract=fast device/ring_lrbd_lf_no_sync_local.cl -o report_lrbd_lf_no_sync_local.aocr

clean:
	rm -rf *.o
	rm -rf *.aoc*
	rm -rf nbody/
	rm -rf ring*/
	rm -rf main.out
	rm -rf main.emu
	rm -rf *.mon
	rm -rf *.temp
