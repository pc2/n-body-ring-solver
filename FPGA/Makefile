HOST_COMPILE_CONFIG=-O3
#HOST_COMPILE_CONFIG=-O0 -g
AOCL_COMPILE_CONFIG=$(shell aocl compile-config)
AOCL_LINK_CONFIG=$(shell aocl link-config)
AOCL_LINK_CONFIG_EMU=-L/cm/shared/opt/intelFPGA_pro/19.4.0/hld/host/linux64/lib -lOpenCL
COMMON_DIR=common/src/AOCLUtils
AOCL_UTILS_INC=common/inc
HOST_INC=host/inc

all: main.out main.emu

#all: main.out main.emu ring_full ring_full_rsqrt ring_full_lf ring_red ring_red_lower_tri ring_full_lf_pipelined_blocks ring_full_ivdep_safelen
#Executables

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
ring_full: main.emu ring_full0.aocx ring_full1.aocx
ring_full0.aocx: device/ring_full0.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full0.cl -o ring_full0.aocx -ffp-reassoc -ffp-contract=fast

ring_full1.aocx: device/ring_full1.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full1.cl -o ring_full1.aocx -ffp-reassoc -ffp-contract=fast

ring_full_rsqrt: main.emu ring_full_rsqrt0.aocx ring_full_rsqrt1.aocx
ring_full_rsqrt0.aocx: device/ring_full_rsqrt0.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_rsqrt0.cl -o ring_full_rsqrt0.aocx -ffp-reassoc -ffp-contract=fast

ring_full_rsqrt1.aocx: device/ring_full_rsqrt1.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_rsqrt1.cl -o ring_full_rsqrt1.aocx -ffp-reassoc -ffp-contract=fast

ring_red: main.emu ring_red0.aocx ring_red1.aocx
ring_red0.aocx: device/ring_red0.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_red0.cl -o ring_red0.aocx -ffp-reassoc -ffp-contract=fast

ring_red1.aocx: device/ring_red1.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_red1.cl -o ring_red1.aocx -ffp-reassoc -ffp-contract=fast

ring_red_lower_tri: main.emu ring_red_lower_tri0.aocx ring_red_lower_tri1.aocx
ring_red_lower_tri0.aocx: device/ring_red_lower_tri0.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_red_lower_tri0.cl -o ring_red_lower_tri0.aocx -ffp-reassoc -ffp-contract=fast

ring_red_lower_tri1.aocx: device/ring_red_lower_tri1.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_red_lower_tri1.cl -o ring_red_lower_tri1.aocx -ffp-reassoc -ffp-contract=fast

ring_full_lf: main.emu ring_full_lf0.aocx ring_full_lf1.aocx
ring_full_lf0.aocx: device/ring_full_lf0.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf0.cl -o ring_full_lf0.aocx -ffp-reassoc -ffp-contract=fast

ring_full_lf1.aocx: device/ring_full_lf1.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf1.cl -o ring_full_lf1.aocx -ffp-reassoc -ffp-contract=fast

ring_full_lf_pipelined_blocks: main.emu ring_full_lf_pipelined_blocks0.aocx ring_full_lf_pipelined_blocks1.aocx
ring_full_lf_pipelined_blocks0.aocx: device/ring_full_lf_pipelined_blocks.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf_pipelined_blocks.cl -o ring_full_lf_pipelined_blocks0.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION0

ring_full_lf_pipelined_blocks1.aocx: device/ring_full_lf_pipelined_blocks.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf_pipelined_blocks.cl -o ring_full_lf_pipelined_blocks1.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION1

ring_full_ivdep_safelen: main.emu ring_full_ivdep_safelen0.aocx ring_full_ivdep_safelen1.aocx
ring_full_ivdep_safelen0.aocx: device/ring_full_ivdep_safelen.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_ivdep_safelen.cl -o ring_full_ivdep_safelen0.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION0

ring_full_ivdep_safelen1.aocx: device/ring_full_ivdep_safelen.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_ivdep_safelen.cl -o ring_full_ivdep_safelen1.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION1

ring_full_lf_deep_cu: main.emu ring_full_lf_deep_cu0.aocx ring_full_lf_deep_cu1.aocx
ring_full_lf_deep_cu0.aocx: device/ring_full_lf_deep_cu.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf_deep_cu.cl -o ring_full_lf_deep_cu0.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION0

ring_full_lf_deep_cu1.aocx: device/ring_full_lf_deep_cu.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_full_lf_deep_cu.cl -o ring_full_lf_deep_cu1.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION1

ring_lrb: main.emu ring_lrb0.aocx
ring_lrb0.aocx: device/ring_lrb.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_lrb.cl -o ring_lrb0.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT
ring_lrb_nd: main.emu ring_lrb_nd.aocx
ring_lrb_nd.aocx: device/ring_lrb.cl
		aoc -march=emulator -v -g -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_lrb.cl -o ring_lrb0.aocx -ffp-reassoc -ffp-contract=fast
		
ring_lrb_lf_no_sync: main.emu ring_lrb_lf_no_sync0.aocx
ring_lrb_lf_no_sync0.aocx: device/ring_lrb_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrb_lf_no_sync.cl -o ring_lrb_lf_no_sync0.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT
ring_lrb_lf_no_sync_nd: main.emu ring_lrb_lf_no_sync_nd0.aocx
ring_lrb_lf_no_sync_nd0.aocx: device/ring_lrb_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrb_lf_no_sync.cl -o ring_lrb_lf_no_sync0.aocx -ffp-reassoc -ffp-contract=fast

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

ring_lrbd_lf_sp: main.emu ring_lrbd_lf_sp0.aocx ring_lrbd_lf_sp1_nd.aocx ring_lrbd_lf_sp2_nd.aocx ring_lrbd_lf_sp3_nd.aocx
ring_lrbd_lf_sp0.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp0.aocx -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_sp1.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp1.aocx -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_sp2.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp2.aocx -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_sp3.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp3.aocx -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION3
ring_lrbd_lf_sp0_nd.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp0.aocx -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_sp1_nd.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp1.aocx -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_sp2_nd.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp2.aocx -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_sp3_nd.aocx: device/ring_lrbd_lf_sp.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_sp.cl -o ring_lrbd_lf_sp3.aocx -DCOMPILE_EMULATION -DEMULATION3

ring_lrbd_lf_no_sync: main.emu ring_lrbd_lf_no_sync0.aocx ring_lrbd_lf_no_sync1_nd.aocx ring_lrbd_lf_no_sync2_nd.aocx ring_lrbd_lf_no_sync3_nd.aocx
ring_lrbd_lf_no_sync0.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync0.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_no_sync1.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync1.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_no_sync2.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync2.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_no_sync3.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync3.aocx -ffp-reassoc -ffp-contract=fast -DDBG_PRINT -DCOMPILE_EMULATION -DEMULATION3
ring_lrbd_lf_no_sync0_nd.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync0.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION0
ring_lrbd_lf_no_sync1_nd.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync1.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION1
ring_lrbd_lf_no_sync2_nd.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync2.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION2
ring_lrbd_lf_no_sync3_nd.aocx: device/ring_lrbd_lf_no_sync.cl
		aoc -march=emulator -v -g device/ring_lrbd_lf_no_sync.cl -o ring_lrbd_lf_no_sync3.aocx -ffp-reassoc -ffp-contract=fast -DCOMPILE_EMULATION -DEMULATION3


#OpenCL reports
report_g3:
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_g3_7.cl

report_g4:
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_g4_1.cl

report_g5:
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_g5.cl

report_g6:
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_g6_1.cl

report_lrb:
	cp device/ring_lrb.cl device/report_ring_lrb.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/report_ring_lrb.cl

report_lrb_lf_no_sync:
	cp device/ring_lrb_lf_no_sync.cl device/report_ring_lrb_lf_no_sync.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/report_ring_lrb_lf_no_sync.cl

report_lrb_lf_no_sync_local:
	cp device/ring_lrb_lf_no_sync_local.cl device/report_ring_lrb_lf_no_sync_local.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/report_ring_lrb_lf_no_sync_local.cl

report_lrbd_lf_no_sync_local:
	cp device/ring_lrbd_lf_no_sync_local.cl device/report_ring_lrbd_lf_no_sync_local.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/report_ring_lrbd_lf_no_sync_local.cl

report_lrbd_lf_no_sync: device/ring_lrbd_lf_no_sync.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/ring_lrbd_lf_no_sync.cl -o report_lrbd_lf_no_sync.aocr

report_lrbd_lf_sp: device/ring_lrbd_lf_sp.cl
	aoc -rtl device/ring_lrbd_lf_sp.cl -o report_lrbd_lf_sp_L16.aocr -DPE_LOCAL_CNT=8 -DPE_LOCAL_CNT_ALLOC=8 -DPE_REMOTE_CNT=8 -DPE_REMOTE_CNT_ALLOC=8 -DLATENCY_FACTOR=16
	aoc -rtl device/ring_lrbd_lf_sp.cl -o report_lrbd_lf_sp_L32.aocr -DPE_LOCAL_CNT=8 -DPE_LOCAL_CNT_ALLOC=8 -DPE_REMOTE_CNT=8 -DPE_REMOTE_CNT_ALLOC=8 -DLATENCY_FACTOR=32

report_deep_cu:
	cp device/ring_full_lf_deep_cu.cl device/report_ring_full_lf_deep_cu.cl
	aoc -rtl -ffp-reassoc -ffp-contract=fast -I ${INTELFPGAOCLSDKROOT}/include/kernel_headers device/report_ring_full_lf_deep_cu.cl

clean:
	rm -rf *.o
	rm -rf *.aoc*
	rm -rf nbody/
	rm -rf ring*/
	rm -rf main.out
	rm -rf main.emu
	rm -rf *.mon
	rm -rf *.temp
