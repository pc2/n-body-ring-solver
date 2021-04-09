#!/bin/bash

aoc -v -board=p520_max_sg280l device/ring_lrbd_lf_no_sync_local.cl -global-ring -duplicate-ring -ffp-reassoc -ffp-contract=fast -high-effort -o bin/ring_lrbd_4x4PE_lf_no_sync_local.aocx -DPE_LOCAL_CNT=4 -DPE_LOCAL_CNT_ALLOC=4 -DPE_REMOTE_CNT=4 -DPE_REMOTE_CNT_ALLOC=4
