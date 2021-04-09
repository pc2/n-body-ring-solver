	.file	"micro_bench.cpp"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"basic_string::_M_construct null not valid"
	.text
	.align 2
	.p2align 4,,15
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67, @function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67:
.LFB8119:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	lea	r12, [rdi+16]
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 8
	.cfi_def_cfa_offset 48
	mov	QWORD PTR [rdi], r12
	test	rsi, rsi
	je	.L2
	mov	rbp, rdi
	mov	rdi, rsi
	mov	r13, rsi
	call	strlen
	mov	rbx, rax
	cmp	rax, 15
	ja	.L14
	cmp	rax, 1
	jne	.L6
	movzx	eax, BYTE PTR [r13+0]
	mov	BYTE PTR [rbp+16], al
.L7:
	mov	QWORD PTR [rbp+8], rbx
	mov	BYTE PTR [r12+rbx], 0
	add	rsp, 8
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore_state
	test	rax, rax
	je	.L7
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L14:
	lea	rdi, [rax+1]
	call	_Znwm
	mov	QWORD PTR [rbp+0], rax
	mov	QWORD PTR [rbp+16], rbx
	mov	r12, rax
.L5:
	mov	rdi, r12
	mov	rdx, rbx
	mov	rsi, r13
	call	memcpy
	mov	r12, QWORD PTR [rbp+0]
	jmp	.L7
.L2:
	mov	edi, OFFSET FLAT:.LC0
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE8119:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"-t"
.LC2:
	.string	"-w"
	.section	.rodata.str1.8
	.align 8
.LC3:
	.string	"Failed to read Arguments!\nResetting to defaults"
	.text
	.p2align 4,,15
	.globl	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm
	.type	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm, @function
_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm:
.LFB7317:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rsi
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14d, edi
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rcx
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdx
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	lea	rbx, [r12+16]
	sub	rsp, 72
	.cfi_def_cfa_offset 128
	mov	QWORD PTR [rcx], 512
	lea	rax, [rsp+48]
	mov	QWORD PTR [rsp+32], rax
	mov	rdx, QWORD PTR [rdx]
	mov	QWORD PTR [rsp+40], 4
	mov	DWORD PTR [rsp+48], 1701736270
	mov	BYTE PTR [rsp+52], 0
	mov	DWORD PTR [rdx], 1701736270
	mov	QWORD PTR [rsp+16], rbx
	mov	rdx, QWORD PTR [rsp+40]
	mov	rcx, QWORD PTR [r12]
	mov	QWORD PTR [r12+8], rdx
	mov	BYTE PTR [rcx+rdx], 0
	mov	QWORD PTR [rsp+40], 0
	mov	rdx, QWORD PTR [rsp+32]
	mov	BYTE PTR [rdx], 0
	mov	rdi, QWORD PTR [rsp+32]
	cmp	rdi, rax
	je	.L16
	call	_ZdlPv
.L16:
	mov	ebx, 1
	lea	rbp, [rsp+48]
	cmp	r14d, 1
	jle	.L21
	.p2align 4,,10
	.p2align 3
.L17:
	movsx	rax, ebx
	mov	rdx, QWORD PTR [r15+rax*8]
	mov	ecx, 3
	mov	rsi, rdx
	mov	edi, OFFSET FLAT:.LC1
	repz cmpsb
	lea	r10, [0+rax*8]
	lea	r11d, [rbx+1]
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L20
	cmp	r14d, r11d
	jg	.L50
.L21:
	mov	rax, QWORD PTR [r13+0]
	sub	rax, 256
	test	rax, -257
	jne	.L51
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L20:
	.cfi_restore_state
	mov	edi, OFFSET FLAT:.LC2
	mov	ecx, 3
	mov	rsi, rdx
	repz cmpsb
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L38
	cmp	r14d, r11d
	jle	.L21
	mov	rdi, QWORD PTR [r15+8+r10]
	mov	edx, 10
	xor	esi, esi
	call	strtoul
	mov	QWORD PTR [r13+0], rax
.L49:
	add	ebx, 2
.L35:
	cmp	r14d, ebx
	jg	.L17
	jmp	.L21
	.p2align 4,,10
	.p2align 3
.L38:
	mov	ebx, r11d
	jmp	.L35
	.p2align 4,,10
	.p2align 3
.L50:
	mov	rsi, QWORD PTR [r15+8+r10]
	mov	QWORD PTR [rsp+32], rbp
	test	rsi, rsi
	je	.L22
	mov	rdi, rsi
	mov	QWORD PTR [rsp+8], rsi
	call	strlen
	cmp	rax, 15
	mov	rcx, rax
	mov	rsi, QWORD PTR [rsp+8]
	ja	.L52
	cmp	rax, 1
	jne	.L26
	movzx	eax, BYTE PTR [rsi]
	mov	BYTE PTR [rsp+48], al
	mov	rax, rbp
.L27:
	mov	QWORD PTR [rsp+40], rcx
	mov	BYTE PTR [rax+rcx], 0
	mov	rax, QWORD PTR [rsp+32]
	mov	rdi, QWORD PTR [r12]
	cmp	rax, rbp
	je	.L53
	mov	rdx, QWORD PTR [rsp+48]
	mov	rcx, QWORD PTR [rsp+40]
	cmp	QWORD PTR [rsp+16], rdi
	je	.L54
	mov	rsi, QWORD PTR [r12+16]
	mov	QWORD PTR [r12], rax
	mov	QWORD PTR [r12+8], rcx
	mov	QWORD PTR [r12+16], rdx
	test	rdi, rdi
	je	.L33
	mov	QWORD PTR [rsp+32], rdi
	mov	QWORD PTR [rsp+48], rsi
.L31:
	mov	QWORD PTR [rsp+40], 0
	mov	BYTE PTR [rdi], 0
	mov	rdi, QWORD PTR [rsp+32]
	cmp	rdi, rbp
	je	.L49
	call	_ZdlPv
	jmp	.L49
	.p2align 4,,10
	.p2align 3
.L26:
	mov	rax, rbp
	test	rcx, rcx
	je	.L27
	jmp	.L25
	.p2align 4,,10
	.p2align 3
.L52:
	lea	rdi, [rax+1]
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+8], rax
	call	_Znwm
	mov	rcx, QWORD PTR [rsp+8]
	mov	QWORD PTR [rsp+32], rax
	mov	QWORD PTR [rsp+48], rcx
	mov	rsi, QWORD PTR [rsp+24]
.L25:
	mov	rdx, rcx
	mov	rdi, rax
	mov	QWORD PTR [rsp+8], rcx
	call	memcpy
	mov	rax, QWORD PTR [rsp+32]
	mov	rcx, QWORD PTR [rsp+8]
	jmp	.L27
	.p2align 4,,10
	.p2align 3
.L53:
	mov	rdx, QWORD PTR [rsp+40]
	test	rdx, rdx
	je	.L29
	cmp	rdx, 1
	je	.L55
	mov	rsi, rbp
	call	memcpy
	mov	rdx, QWORD PTR [rsp+40]
	mov	rdi, QWORD PTR [r12]
.L29:
	mov	QWORD PTR [r12+8], rdx
	mov	BYTE PTR [rdi+rdx], 0
	mov	rdi, QWORD PTR [rsp+32]
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L51:
	mov	edi, OFFSET FLAT:.LC3
	xor	eax, eax
	call	printf
	mov	QWORD PTR [r13+0], 512
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L54:
	.cfi_restore_state
	mov	QWORD PTR [r12], rax
	mov	QWORD PTR [r12+8], rcx
	mov	QWORD PTR [r12+16], rdx
.L33:
	mov	QWORD PTR [rsp+32], rbp
	mov	rdi, rbp
	jmp	.L31
.L55:
	movzx	eax, BYTE PTR [rsp+48]
	mov	BYTE PTR [rdi], al
	mov	rdx, QWORD PTR [rsp+40]
	mov	rdi, QWORD PTR [r12]
	jmp	.L29
.L22:
	mov	edi, OFFSET FLAT:.LC0
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE7317:
	.size	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm, .-_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm
	.section	.rodata.str1.1
.LC5:
	.string	"sqrt"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench11sqrt_avx256EPDv4_d
	.type	_ZN11micro_bench11sqrt_avx256EPDv4_d, @function
_ZN11micro_bench11sqrt_avx256EPDv4_d:
.LFB7335:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	YMMWORD PTR [rdi], ymm0
	and	rsp, -32
	mov	edi, OFFSET FLAT:.LC5
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L57:
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	dec	rax
	jne	.L57
	mov	edi, OFFSET FLAT:.LC5
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7335:
	.size	_ZN11micro_bench11sqrt_avx256EPDv4_d, .-_ZN11micro_bench11sqrt_avx256EPDv4_d
	.section	.rodata.str1.1
.LC7:
	.string	"sqrt+fma"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench15sqrt_fma_avx256EPDv4_d
	.type	_ZN11micro_bench15sqrt_fma_avx256EPDv4_d, @function
_ZN11micro_bench15sqrt_fma_avx256EPDv4_d:
.LFB7336:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	and	rsp, -32
	sub	rsp, 32
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	vmovapd	YMMWORD PTR [rdi], ymm0
	mov	edi, OFFSET FLAT:.LC7
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	vmovapd	ymm1, YMMWORD PTR .LC6[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L61:
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	dec	rax
	jne	.L61
	mov	edi, OFFSET FLAT:.LC7
	vmovapd	YMMWORD PTR [rsp], ymm1
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	ymm1, YMMWORD PTR [rsp]
	vaddpd	ymm1, ymm1, YMMWORD PTR [rbx]
	vmovapd	YMMWORD PTR [rbx], ymm1
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7336:
	.size	_ZN11micro_bench15sqrt_fma_avx256EPDv4_d, .-_ZN11micro_bench15sqrt_fma_avx256EPDv4_d
	.section	.rodata.str1.1
.LC8:
	.string	"div"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench10div_avx256EPDv4_d
	.type	_ZN11micro_bench10div_avx256EPDv4_d, @function
_ZN11micro_bench10div_avx256EPDv4_d:
.LFB7337:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	YMMWORD PTR [rdi], ymm0
	and	rsp, -32
	mov	edi, OFFSET FLAT:.LC8
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	vmovapd	ymm1, YMMWORD PTR .LC9[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L65:
	vdivpd	ymm0, ymm1, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vdivpd	ymm0, ymm1, ymm0
	dec	rax
	jne	.L65
	mov	edi, OFFSET FLAT:.LC8
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7337:
	.size	_ZN11micro_bench10div_avx256EPDv4_d, .-_ZN11micro_bench10div_avx256EPDv4_d
	.section	.rodata.str1.1
.LC10:
	.string	"invsqrt"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench14invsqrt_avx256EPDv4_d
	.type	_ZN11micro_bench14invsqrt_avx256EPDv4_d, @function
_ZN11micro_bench14invsqrt_avx256EPDv4_d:
.LFB7338:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	mov	edi, OFFSET FLAT:.LC10
	and	rsp, -32
	sub	rsp, 32
	call	likwid_markerStartRegion
	vmovapd	ymm1, YMMWORD PTR .LC4[rip]
	mov	eax, 1000000
	vmovapd	ymm0, ymm1
	.p2align 4,,10
	.p2align 3
.L69:
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm1, ymm0
	dec	rax
	jne	.L69
	mov	edi, OFFSET FLAT:.LC10
	vmovapd	YMMWORD PTR [rsp], ymm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	ymm0, YMMWORD PTR [rsp]
	vaddpd	ymm0, ymm0, YMMWORD PTR [rbx]
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7338:
	.size	_ZN11micro_bench14invsqrt_avx256EPDv4_d, .-_ZN11micro_bench14invsqrt_avx256EPDv4_d
	.section	.rodata.str1.1
.LC11:
	.string	"rsqrt"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench12rsqrt_avx256EPDv4_d
	.type	_ZN11micro_bench12rsqrt_avx256EPDv4_d, @function
_ZN11micro_bench12rsqrt_avx256EPDv4_d:
.LFB7339:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	YMMWORD PTR [rdi], ymm0
	and	rsp, -32
	mov	edi, OFFSET FLAT:.LC11
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L73:
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	dec	rax
	jne	.L73
	mov	edi, OFFSET FLAT:.LC11
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7339:
	.size	_ZN11micro_bench12rsqrt_avx256EPDv4_d, .-_ZN11micro_bench12rsqrt_avx256EPDv4_d
	.section	.rodata.str1.1
.LC12:
	.string	"rsqrt+fma"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench16rsqrt_fma_avx256EPDv4_d
	.type	_ZN11micro_bench16rsqrt_fma_avx256EPDv4_d, @function
_ZN11micro_bench16rsqrt_fma_avx256EPDv4_d:
.LFB7340:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	and	rsp, -32
	sub	rsp, 32
	vmovapd	ymm1, YMMWORD PTR .LC4[rip]
	vmovapd	YMMWORD PTR [rdi], ymm1
	mov	edi, OFFSET FLAT:.LC12
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	vmovapd	ymm1, YMMWORD PTR .LC4[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L77:
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	dec	rax
	jne	.L77
	mov	edi, OFFSET FLAT:.LC12
	vmovapd	YMMWORD PTR [rsp], ymm1
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	ymm1, YMMWORD PTR [rsp]
	vaddpd	ymm1, ymm1, YMMWORD PTR [rbx]
	vmovapd	YMMWORD PTR [rbx], ymm1
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7340:
	.size	_ZN11micro_bench16rsqrt_fma_avx256EPDv4_d, .-_ZN11micro_bench16rsqrt_fma_avx256EPDv4_d
	.section	.rodata.str1.1
.LC13:
	.string	"rsqrt+iter"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d
	.type	_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d, @function
_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d:
.LFB7341:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	YMMWORD PTR [rdi], ymm0
	and	rsp, -32
	mov	edi, OFFSET FLAT:.LC13
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	vmovapd	ymm3, YMMWORD PTR .LC14[rip]
	vmovapd	ymm2, YMMWORD PTR .LC15[rip]
	mov	eax, 1000000
.L81:
	vrsqrt14pd	ymm0, ymm0
	vmulpd	ymm1, ymm0, ymm0
	vfnmadd132pd	ymm1, ymm3, ymm0
	vmulpd	ymm0, ymm0, ymm2
	vmulpd	ymm1, ymm1, ymm0
	vmulpd	ymm0, ymm1, ymm1
	vfnmadd132pd	ymm0, ymm3, ymm1
	vmulpd	ymm1, ymm1, ymm2
	vmulpd	ymm0, ymm0, ymm1
	dec	rax
	jne	.L81
	mov	edi, OFFSET FLAT:.LC13
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7341:
	.size	_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d, .-_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d
	.section	.rodata.str1.1
.LC16:
	.string	"fma"
	.text
	.p2align 4,,15
	.globl	_ZN11micro_bench10fma_avx256EPDv4_d
	.type	_ZN11micro_bench10fma_avx256EPDv4_d, @function
_ZN11micro_bench10fma_avx256EPDv4_d:
.LFB7342:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	ymm0, YMMWORD PTR .LC4[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	YMMWORD PTR [rdi], ymm0
	and	rsp, -32
	mov	edi, OFFSET FLAT:.LC16
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L85:
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	dec	rax
	jne	.L85
	mov	edi, OFFSET FLAT:.LC16
	vmovapd	YMMWORD PTR [rbx], ymm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7342:
	.size	_ZN11micro_bench10fma_avx256EPDv4_d, .-_ZN11micro_bench10fma_avx256EPDv4_d
	.p2align 4,,15
	.globl	_ZN11micro_bench11sqrt_avx512EPDv8_d
	.type	_ZN11micro_bench11sqrt_avx512EPDv8_d, @function
_ZN11micro_bench11sqrt_avx512EPDv8_d:
.LFB7343:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	ZMMWORD PTR [rdi], zmm0
	and	rsp, -64
	mov	edi, OFFSET FLAT:.LC5
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L89:
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	dec	rax
	jne	.L89
	mov	edi, OFFSET FLAT:.LC5
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7343:
	.size	_ZN11micro_bench11sqrt_avx512EPDv8_d, .-_ZN11micro_bench11sqrt_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench15sqrt_fma_avx512EPDv8_d
	.type	_ZN11micro_bench15sqrt_fma_avx512EPDv8_d, @function
_ZN11micro_bench15sqrt_fma_avx512EPDv8_d:
.LFB7344:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	and	rsp, -64
	sub	rsp, 64
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	vmovapd	ZMMWORD PTR [rdi], zmm0
	mov	edi, OFFSET FLAT:.LC7
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	vmovapd	zmm1, ZMMWORD PTR .LC18[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L93:
	vfmadd132pd	zmm0, zmm0, zmm0
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L93
	mov	edi, OFFSET FLAT:.LC7
	vmovapd	ZMMWORD PTR [rsp], zmm1
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	zmm1, ZMMWORD PTR [rsp]
	vaddpd	zmm1, zmm1, ZMMWORD PTR [rbx]
	vmovapd	ZMMWORD PTR [rbx], zmm1
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7344:
	.size	_ZN11micro_bench15sqrt_fma_avx512EPDv8_d, .-_ZN11micro_bench15sqrt_fma_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench10div_avx512EPDv8_d
	.type	_ZN11micro_bench10div_avx512EPDv8_d, @function
_ZN11micro_bench10div_avx512EPDv8_d:
.LFB7345:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	ZMMWORD PTR [rdi], zmm0
	and	rsp, -64
	mov	edi, OFFSET FLAT:.LC8
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	vmovapd	zmm1, ZMMWORD PTR .LC20[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L97:
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	dec	rax
	jne	.L97
	mov	edi, OFFSET FLAT:.LC8
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7345:
	.size	_ZN11micro_bench10div_avx512EPDv8_d, .-_ZN11micro_bench10div_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench14invsqrt_avx512EPDv8_d
	.type	_ZN11micro_bench14invsqrt_avx512EPDv8_d, @function
_ZN11micro_bench14invsqrt_avx512EPDv8_d:
.LFB7346:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	mov	edi, OFFSET FLAT:.LC10
	and	rsp, -64
	sub	rsp, 64
	call	likwid_markerStartRegion
	vmovapd	zmm1, ZMMWORD PTR .LC17[rip]
	mov	eax, 1000000
	vmovapd	zmm0, zmm1
	.p2align 4,,10
	.p2align 3
.L101:
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm1, zmm0
	dec	rax
	jne	.L101
	mov	edi, OFFSET FLAT:.LC10
	vmovapd	ZMMWORD PTR [rsp], zmm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	zmm0, ZMMWORD PTR [rsp]
	vaddpd	zmm0, zmm0, ZMMWORD PTR [rbx]
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7346:
	.size	_ZN11micro_bench14invsqrt_avx512EPDv8_d, .-_ZN11micro_bench14invsqrt_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench12rsqrt_avx512EPDv8_d
	.type	_ZN11micro_bench12rsqrt_avx512EPDv8_d, @function
_ZN11micro_bench12rsqrt_avx512EPDv8_d:
.LFB7347:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	ZMMWORD PTR [rdi], zmm0
	and	rsp, -64
	mov	edi, OFFSET FLAT:.LC11
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L105:
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	dec	rax
	jne	.L105
	mov	edi, OFFSET FLAT:.LC11
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7347:
	.size	_ZN11micro_bench12rsqrt_avx512EPDv8_d, .-_ZN11micro_bench12rsqrt_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench16rsqrt_fma_avx512EPDv8_d
	.type	_ZN11micro_bench16rsqrt_fma_avx512EPDv8_d, @function
_ZN11micro_bench16rsqrt_fma_avx512EPDv8_d:
.LFB7348:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	and	rsp, -64
	sub	rsp, 64
	vmovapd	zmm1, ZMMWORD PTR .LC17[rip]
	vmovapd	ZMMWORD PTR [rdi], zmm1
	mov	edi, OFFSET FLAT:.LC12
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	vmovapd	zmm1, ZMMWORD PTR .LC17[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L109:
	vfmadd132pd	zmm0, zmm0, zmm0
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L109
	mov	edi, OFFSET FLAT:.LC12
	vmovapd	ZMMWORD PTR [rsp], zmm1
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	zmm1, ZMMWORD PTR [rsp]
	vaddpd	zmm1, zmm1, ZMMWORD PTR [rbx]
	vmovapd	ZMMWORD PTR [rbx], zmm1
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7348:
	.size	_ZN11micro_bench16rsqrt_fma_avx512EPDv8_d, .-_ZN11micro_bench16rsqrt_fma_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d
	.type	_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d, @function
_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d:
.LFB7349:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	ZMMWORD PTR [rdi], zmm0
	and	rsp, -64
	mov	edi, OFFSET FLAT:.LC13
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm4, ZMMWORD PTR .LC25[rip]
	vmovapd	zmm3, ZMMWORD PTR .LC24[rip]
	mov	eax, 1000000
.L113:
	vrsqrt14pd	zmm1, ZMMWORD PTR [rbx]
	vmulpd	zmm0, zmm1, zmm1
	vmovapd	zmm2, zmm0
	vfnmadd132pd	zmm2, zmm4, ZMMWORD PTR [rbx]
	vmulpd	zmm0, zmm1, zmm3
	vmulpd	zmm0, zmm0, zmm2
	vmulpd	zmm1, zmm0, zmm0
	vfnmadd132pd	zmm1, zmm4, ZMMWORD PTR [rbx]
	vmulpd	zmm0, zmm3, zmm0
	vmulpd	zmm0, zmm0, zmm1
	vmovapd	ZMMWORD PTR [rbx], zmm0
	dec	rax
	jne	.L113
	mov	edi, OFFSET FLAT:.LC13
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7349:
	.size	_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d, .-_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d
	.section	.rodata.str1.8
	.align 8
.LC34:
	.string	"Invsqrt           : Largest error: %.10e at %.10e; mean error: %.10e\n"
	.align 8
.LC35:
	.string	"rsqrt 0 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n"
	.align 8
.LC36:
	.string	"rsqrt 1 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n"
	.align 8
.LC37:
	.string	"rsqrt 2 iterations: Largest error: %.10e at %.10e; mean error: %.10e\n"
	.section	.rodata.str1.1
.LC38:
	.string	"int"
	.text
	.p2align 4,,15
	.type	main._omp_fn.0, @function
main._omp_fn.0:
.LFB8052:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA8052
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -64
	push	QWORD PTR [r10-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rdi
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	add	rsp, -128
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	call	omp_get_num_threads
	movsx	r13, eax
	call	omp_get_thread_num
	movsx	rbx, eax
	xor	edx, edx
	mov	eax, 1
	div	r13
	cmp	rbx, rdx
	jb	.L117
	imul	rbx, rax
	add	rbx, rdx
	lea	r12, [rax+rbx]
	cmp	rbx, r12
	jb	.L166
.L190:
	sub	rsp, -128
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L117:
	.cfi_restore_state
	lea	r12, [rax+1]
	xor	ebx, ebx
.L166:
	mov	r14d, DWORD PTR [r15+32]
	.p2align 4,,10
	.p2align 3
.L131:
	cmp	r14d, 9
	ja	.L119
	mov	eax, r14d
	jmp	[QWORD PTR .L121[0+rax*8]]
	.section	.rodata
	.align 8
	.align 4
.L121:
	.quad	.L130
	.quad	.L129
	.quad	.L128
	.quad	.L127
	.quad	.L126
	.quad	.L125
	.quad	.L124
	.quad	.L123
	.quad	.L122
	.quad	.L120
	.text
	.p2align 4,,10
	.p2align 3
.L129:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L163
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm28, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC5
	vmovapd	YMMWORD PTR [r13+128], ymm28
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L164:
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	vsqrtpd	ymm0, ymm0
	dec	rax
	jne	.L164
	vmovapd	YMMWORD PTR [r13+128], ymm0
.L193:
	mov	edi, OFFSET FLAT:.LC5
.L192:
	vzeroupper
	call	likwid_markerStopRegion
	.p2align 4,,10
	.p2align 3
.L119:
	inc	rbx
	cmp	rbx, r12
	jb	.L131
.L196:
	vzeroupper
	jmp	.L190
	.p2align 4,,10
	.p2align 3
.L122:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L144
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm23, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC16
	vmovapd	YMMWORD PTR [r13+128], ymm23
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L145:
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	vfmadd132pd	ymm0, ymm0, ymm0
	dec	rax
	jne	.L145
	vmovapd	YMMWORD PTR [r13+128], ymm0
	mov	edi, OFFSET FLAT:.LC16
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L123:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L147
	cmp	rax, 256
	jne	.L119
	mov	rax, QWORD PTR [r15+16]
	lea	rdi, [rax+128]
	vzeroupper
	call	_ZN11micro_bench17rsqrt_iter_avx256EPDv4_d
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L124:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L148
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm24, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC12
	vmovapd	YMMWORD PTR [r13+128], ymm24
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	vmovapd	ymm1, YMMWORD PTR .LC4[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L149:
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vrsqrt14pd	ymm1, ymm1
	dec	rax
	jne	.L149
	vmovapd	YMMWORD PTR [rbp-112], ymm1
	vmovapd	YMMWORD PTR [r13+128], ymm0
	mov	edi, OFFSET FLAT:.LC12
	jmp	.L195
	.p2align 4,,10
	.p2align 3
.L125:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L151
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm25, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC11
	vmovapd	YMMWORD PTR [r13+128], ymm25
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L152:
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	vrsqrt14pd	ymm0, ymm0
	dec	rax
	jne	.L152
	vmovapd	YMMWORD PTR [r13+128], ymm0
	mov	edi, OFFSET FLAT:.LC11
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L126:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L154
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	mov	edi, OFFSET FLAT:.LC10
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm4, YMMWORD PTR .LC4[rip]
	mov	eax, 1000000
	vmovapd	ymm0, ymm4
	.p2align 4,,10
	.p2align 3
.L155:
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm4, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm4, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm4, ymm0
	vsqrtpd	ymm0, ymm0
	vdivpd	ymm0, ymm4, ymm0
	dec	rax
	jne	.L155
	mov	edi, OFFSET FLAT:.LC10
	vmovapd	YMMWORD PTR [rbp-112], ymm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	ymm0, YMMWORD PTR [rbp-112]
	vaddpd	ymm0, ymm0, YMMWORD PTR [r13+128]
	vmovapd	YMMWORD PTR [r13+128], ymm0
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L127:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L157
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm26, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC8
	vmovapd	YMMWORD PTR [r13+128], ymm26
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	vmovapd	ymm5, YMMWORD PTR .LC9[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L158:
	vdivpd	ymm0, ymm5, ymm0
	vdivpd	ymm0, ymm5, ymm0
	vdivpd	ymm0, ymm5, ymm0
	vdivpd	ymm0, ymm5, ymm0
	dec	rax
	jne	.L158
	vmovapd	YMMWORD PTR [r13+128], ymm0
	mov	edi, OFFSET FLAT:.LC8
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L128:
	mov	rax, QWORD PTR [r15]
	mov	rax, QWORD PTR [rax]
	cmp	rax, 512
	je	.L160
	cmp	rax, 256
	jne	.L119
	mov	r13, QWORD PTR [r15+16]
	vmovapd	ymm27, YMMWORD PTR .LC4[rip]
	mov	edi, OFFSET FLAT:.LC7
	vmovapd	YMMWORD PTR [r13+128], ymm27
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	ymm0, YMMWORD PTR [r13+128]
	vmovapd	ymm1, YMMWORD PTR .LC6[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L161:
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	vfmadd132pd	ymm0, ymm0, ymm0
	vsqrtpd	ymm1, ymm1
	dec	rax
	jne	.L161
	vmovapd	YMMWORD PTR [rbp-112], ymm1
	vmovapd	YMMWORD PTR [r13+128], ymm0
	mov	edi, OFFSET FLAT:.LC7
.L195:
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	ymm1, YMMWORD PTR [rbp-112]
	inc	rbx
	vaddpd	ymm1, ymm1, YMMWORD PTR [r13+128]
	vmovapd	YMMWORD PTR [r13+128], ymm1
	cmp	rbx, r12
	jb	.L131
	jmp	.L196
	.p2align 4,,10
	.p2align 3
.L130:
	test	rbx, rbx
	jne	.L119
	mov	esi, 80000000
	mov	edi, 64
	vzeroupper
	call	aligned_alloc
	mov	esi, 80000000
	mov	edi, 64
	mov	r13, rax
	call	aligned_alloc
	mov	esi, 80000000
	mov	edi, 64
	mov	QWORD PTR [rbp-128], rax
	call	aligned_alloc
	mov	esi, 80000000
	mov	edi, 64
	mov	QWORD PTR [rbp-120], rax
	call	aligned_alloc
	mov	esi, 80000000
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	call	aligned_alloc
	vbroadcastsd	zmm8, QWORD PTR .LC19[rip]
	vbroadcastsd	zmm6, QWORD PTR .LC21[rip]
	vbroadcastsd	zmm7, QWORD PTR .LC22[rip]
	vmovdqa64	ymm1, YMMWORD PTR .LC26[rip]
	mov	r8, QWORD PTR [rbp-128]
	mov	r9, QWORD PTR [rbp-120]
	mov	r10, QWORD PTR [rbp-112]
	mov	rdx, r13
	lea	rcx, [r13+80000000]
	.p2align 4,,10
	.p2align 3
.L132:
	vmovapd	ymm16, YMMWORD PTR .LC30[rip]
	vcvtqq2pd	ymm0, ymm1
	vfmadd132pd	ymm0, ymm16, YMMWORD PTR .LC29[rip]
	add	rdx, 32
	vpaddq	ymm1, ymm1, YMMWORD PTR .LC28[rip]
	vmovapd	YMMWORD PTR [rdx-32], ymm0
	cmp	rcx, rdx
	jne	.L132
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L133:
	vmovapd	zmm1, ZMMWORD PTR [r13+0+rdx*8]
	vrsqrt14pd	zmm2, zmm1
	vsqrtpd	zmm0, zmm1
	vdivpd	zmm0, zmm8, zmm0
	vmovapd	ZMMWORD PTR [r8+rdx*8], zmm0
	vmulpd	zmm0, zmm2, zmm2
	vmovapd	ZMMWORD PTR [r9+rdx*8], zmm2
	vmulpd	zmm2, zmm7, zmm2
	vfnmadd132pd	zmm0, zmm6, zmm1
	vmulpd	zmm0, zmm0, zmm2
	vmulpd	zmm2, zmm0, zmm0
	vmovapd	ZMMWORD PTR [r10+rdx*8], zmm0
	vmulpd	zmm0, zmm7, zmm0
	vfnmadd132pd	zmm1, zmm6, zmm2
	vmulpd	zmm0, zmm1, zmm0
	vmovapd	ZMMWORD PTR [rax+rdx*8], zmm0
	add	rdx, 8
	cmp	rdx, 10000000
	jne	.L133
	vmovsd	xmm15, QWORD PTR .LC31[rip]
	vmovq	xmm8, QWORD PTR .LC32[rip]
	xor	ecx, ecx
	xor	esi, esi
	xor	r11d, r11d
	xor	edi, edi
	xor	edx, edx
	vxorpd	xmm12, xmm12, xmm12
	vxorpd	xmm9, xmm9, xmm9
	vxorpd	xmm13, xmm13, xmm13
	vxorpd	xmm10, xmm10, xmm10
	vxorpd	xmm14, xmm14, xmm14
	vxorpd	xmm11, xmm11, xmm11
	vxorpd	xmm2, xmm2, xmm2
	vxorpd	xmm0, xmm0, xmm0
	.p2align 4,,10
	.p2align 3
.L142:
	vmovsd	xmm6, QWORD PTR [r8+rdx*8]
	vdivsd	xmm7, xmm15, QWORD PTR [r13+0+rdx*8]
	vfmsub132sd	xmm6, xmm7, xmm6
	vandpd	xmm6, xmm6, xmm8
	vdivsd	xmm6, xmm6, xmm7
	vcomisd	xmm6, xmm0
	vaddsd	xmm2, xmm2, xmm6
	vmaxsd	xmm0, xmm6, xmm0
	vmovsd	xmm6, QWORD PTR [r9+rdx*8]
	cmova	rdi, rdx
	vfmsub132sd	xmm6, xmm7, xmm6
	vandpd	xmm6, xmm6, xmm8
	vdivsd	xmm6, xmm6, xmm7
	vcomisd	xmm6, xmm11
	vaddsd	xmm14, xmm14, xmm6
	vmaxsd	xmm11, xmm6, xmm11
	vmovsd	xmm6, QWORD PTR [r10+rdx*8]
	cmova	r11, rdx
	vfmsub132sd	xmm6, xmm7, xmm6
	vandpd	xmm6, xmm6, xmm8
	vdivsd	xmm6, xmm6, xmm7
	vcomisd	xmm6, xmm10
	vaddsd	xmm13, xmm13, xmm6
	vmaxsd	xmm10, xmm6, xmm10
	vmovsd	xmm6, QWORD PTR [rax+rdx*8]
	cmova	rsi, rdx
	vfmsub132sd	xmm6, xmm7, xmm6
	vandpd	xmm6, xmm6, xmm8
	vdivsd	xmm1, xmm6, xmm7
	vcomisd	xmm1, xmm9
	vaddsd	xmm12, xmm12, xmm1
	vmaxsd	xmm9, xmm1, xmm9
	cmova	rcx, rdx
	inc	rdx
	cmp	rdx, 10000000
	jne	.L142
	vmovsd	xmm1, QWORD PTR [r13+0+rdi*8]
	mov	eax, 3
	mov	edi, OFFSET FLAT:.LC34
	mov	QWORD PTR [rbp-176], r11
	mov	QWORD PTR [rbp-168], rsi
	mov	QWORD PTR [rbp-160], rcx
	vmovsd	QWORD PTR [rbp-152], xmm12
	vmovsd	QWORD PTR [rbp-144], xmm9
	vmovsd	QWORD PTR [rbp-136], xmm13
	vmovsd	QWORD PTR [rbp-128], xmm10
	vmovsd	QWORD PTR [rbp-120], xmm14
	vmovsd	QWORD PTR [rbp-112], xmm11
	vdivsd	xmm2, xmm2, QWORD PTR .LC33[rip]
	vzeroupper
	call	printf
	mov	r11, QWORD PTR [rbp-176]
	vmovsd	xmm11, QWORD PTR [rbp-112]
	vmovsd	xmm14, QWORD PTR [rbp-120]
	vmovsd	xmm1, QWORD PTR [r13+0+r11*8]
	vmovapd	xmm0, xmm11
	mov	edi, OFFSET FLAT:.LC35
	mov	eax, 3
	vdivsd	xmm2, xmm14, QWORD PTR .LC33[rip]
	call	printf
	mov	rsi, QWORD PTR [rbp-168]
	vmovsd	xmm10, QWORD PTR [rbp-128]
	vmovsd	xmm13, QWORD PTR [rbp-136]
	vmovsd	xmm1, QWORD PTR [r13+0+rsi*8]
	vmovapd	xmm0, xmm10
	mov	edi, OFFSET FLAT:.LC36
	mov	eax, 3
	vdivsd	xmm2, xmm13, QWORD PTR .LC33[rip]
	call	printf
	mov	rcx, QWORD PTR [rbp-160]
	vmovsd	xmm9, QWORD PTR [rbp-144]
	vmovsd	xmm12, QWORD PTR [rbp-152]
	vmovsd	xmm1, QWORD PTR [r13+0+rcx*8]
	vmovapd	xmm0, xmm9
	mov	edi, OFFSET FLAT:.LC37
	mov	eax, 3
	vdivsd	xmm2, xmm12, QWORD PTR .LC33[rip]
	call	printf
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L120:
	mov	r13, QWORD PTR [r15+24]
	mov	edi, OFFSET FLAT:.LC38
	vzeroupper
	call	likwid_markerStartRegion
	mov	edx, 1000000
	mov	ecx, 1
	.p2align 4,,10
	.p2align 3
.L143:
#APP
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rax
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rcx, rsi
	
# 0 "" 2
#NO_APP
	dec	rdx
	jne	.L143
	mov	edi, OFFSET FLAT:.LC38
	mov	QWORD PTR [rbp-112], rsi
	vzeroupper
	call	likwid_markerStopRegion
	mov	rsi, QWORD PTR [rbp-112]
	inc	rbx
	add	QWORD PTR [r13+32], rsi
	cmp	rbx, r12
	jb	.L131
	jmp	.L196
	.p2align 4,,10
	.p2align 3
.L147:
	mov	rax, QWORD PTR [r15+8]
	lea	rdi, [rax+256]
	vzeroupper
	call	_ZN11micro_bench17rsqrt_iter_avx512EPDv8_d
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L144:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm17, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC16
	vmovapd	ZMMWORD PTR [r13+256], zmm17
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L146:
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L146
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	mov	edi, OFFSET FLAT:.LC16
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L151:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm19, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC11
	vmovapd	ZMMWORD PTR [r13+256], zmm19
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L153:
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	vrsqrt14pd	zmm0, zmm0
	dec	rax
	jne	.L153
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	mov	edi, OFFSET FLAT:.LC11
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L148:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm18, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC12
	vmovapd	ZMMWORD PTR [r13+256], zmm18
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	vmovapd	zmm1, ZMMWORD PTR .LC17[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L150:
	vfmadd132pd	zmm0, zmm0, zmm0
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vrsqrt14pd	zmm1, zmm1
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L150
	vmovapd	ZMMWORD PTR [rbp-112], zmm1
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	mov	edi, OFFSET FLAT:.LC12
.L194:
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	zmm1, ZMMWORD PTR [rbp-112]
	inc	rbx
	vaddpd	zmm1, zmm1, ZMMWORD PTR [r13+256]
	vmovapd	ZMMWORD PTR [r13+256], zmm1
	cmp	rbx, r12
	jb	.L131
	jmp	.L196
	.p2align 4,,10
	.p2align 3
.L157:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm20, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC8
	vmovapd	ZMMWORD PTR [r13+256], zmm20
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	vmovapd	zmm1, ZMMWORD PTR .LC20[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L159:
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	vdivpd	zmm0, zmm1, zmm0
	dec	rax
	jne	.L159
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	mov	edi, OFFSET FLAT:.LC8
	jmp	.L192
	.p2align 4,,10
	.p2align 3
.L154:
	mov	r13, QWORD PTR [r15+8]
	mov	edi, OFFSET FLAT:.LC10
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm3, ZMMWORD PTR .LC17[rip]
	mov	eax, 1000000
	vmovapd	zmm0, zmm3
	.p2align 4,,10
	.p2align 3
.L156:
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm3, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm3, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm3, zmm0
	vsqrtpd	zmm0, zmm0
	vdivpd	zmm0, zmm3, zmm0
	dec	rax
	jne	.L156
	mov	edi, OFFSET FLAT:.LC10
	vmovapd	ZMMWORD PTR [rbp-112], zmm0
	vzeroupper
	call	likwid_markerStopRegion
	vmovapd	zmm0, ZMMWORD PTR [rbp-112]
	vaddpd	zmm0, zmm0, ZMMWORD PTR [r13+256]
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	jmp	.L119
	.p2align 4,,10
	.p2align 3
.L163:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm22, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC5
	vmovapd	ZMMWORD PTR [r13+256], zmm22
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	mov	edx, 1000000
	.p2align 4,,10
	.p2align 3
.L165:
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	vsqrtpd	zmm0, zmm0
	dec	rdx
	jne	.L165
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	jmp	.L193
	.p2align 4,,10
	.p2align 3
.L160:
	mov	r13, QWORD PTR [r15+8]
	vmovapd	zmm21, ZMMWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC7
	vmovapd	ZMMWORD PTR [r13+256], zmm21
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [r13+256]
	vmovapd	zmm1, ZMMWORD PTR .LC18[rip]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L162:
	vfmadd132pd	zmm0, zmm0, zmm0
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vsqrtpd	zmm1, zmm1
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L162
	vmovapd	ZMMWORD PTR [rbp-112], zmm1
	vmovapd	ZMMWORD PTR [r13+256], zmm0
	mov	edi, OFFSET FLAT:.LC7
	jmp	.L194
	.cfi_endproc
.LFE8052:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA8052:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8052-.LLSDACSB8052
.LLSDACSB8052:
.LLSDACSE8052:
	.text
	.size	main._omp_fn.0, .-main._omp_fn.0
	.p2align 4,,15
	.globl	_ZN11micro_bench10fma_avx512EPDv8_d
	.type	_ZN11micro_bench10fma_avx512EPDv8_d, @function
_ZN11micro_bench10fma_avx512EPDv8_d:
.LFB7350:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovapd	zmm0, ZMMWORD PTR .LC17[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	.cfi_offset 3, -24
	mov	rbx, rdi
	vmovapd	ZMMWORD PTR [rdi], zmm0
	and	rsp, -64
	mov	edi, OFFSET FLAT:.LC16
	vzeroupper
	call	likwid_markerStartRegion
	vmovapd	zmm0, ZMMWORD PTR [rbx]
	mov	eax, 1000000
	.p2align 4,,10
	.p2align 3
.L198:
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	vfmadd132pd	zmm0, zmm0, zmm0
	dec	rax
	jne	.L198
	mov	edi, OFFSET FLAT:.LC16
	vmovapd	ZMMWORD PTR [rbx], zmm0
	vzeroupper
	mov	rbx, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	jmp	likwid_markerStopRegion
	.cfi_endproc
.LFE7350:
	.size	_ZN11micro_bench10fma_avx512EPDv8_d, .-_ZN11micro_bench10fma_avx512EPDv8_d
	.p2align 4,,15
	.globl	_ZN11micro_bench10int_avx512EPm
	.type	_ZN11micro_bench10int_avx512EPm, @function
_ZN11micro_bench10int_avx512EPm:
.LFB7351:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rdi
	mov	edi, OFFSET FLAT:.LC38
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 8
	.cfi_def_cfa_offset 32
	call	likwid_markerStartRegion
	mov	edx, 1000000
	mov	eax, 1
	.p2align 4,,10
	.p2align 3
.L202:
#APP
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rcx
	
# 0 "" 2
# 669 "micro_bench.cpp" 1
	addq rax, rbx
	
# 0 "" 2
#NO_APP
	dec	rdx
	jne	.L202
	mov	edi, OFFSET FLAT:.LC38
	call	likwid_markerStopRegion
	add	QWORD PTR [rbp+0], rbx
	add	rsp, 8
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7351:
	.size	_ZN11micro_bench10int_avx512EPm, .-_ZN11micro_bench10int_avx512EPm
	.section	.rodata.str1.8
	.align 8
.LC39:
	.string	"Testsize must be divisible by 8!"
	.text
	.p2align 4,,15
	.globl	_Z13sqrt_accuracyddm
	.type	_Z13sqrt_accuracyddm, @function
_Z13sqrt_accuracyddm:
.LFB7352:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	lea	r13, [rsp+16]
	.cfi_def_cfa 13, 0
	and	rsp, -64
	push	QWORD PTR [r13-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	.cfi_escape 0xf,0x3,0x76,0x68,0x6
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	mov	r13, rdi
	push	r12
	push	rbx
	sub	rsp, 72
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	.cfi_escape 0x10,0x3,0x2,0x76,0x58
	and	r13d, 7
	jne	.L233
	lea	r15, [0+rdi*8]
	mov	rbx, rdi
	mov	rsi, r15
	mov	edi, 64
	vmovsd	QWORD PTR [rbp-80], xmm0
	vmovsd	QWORD PTR [rbp-56], xmm1
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r12, rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r14, rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	QWORD PTR [rbp-64], rax
	call	aligned_alloc
	vmovsd	xmm0, QWORD PTR [rbp-80]
	mov	rcx, rbx
	dec	rcx
	vbroadcastsd	zmm5, QWORD PTR .LC19[rip]
	vbroadcastsd	zmm3, QWORD PTR .LC21[rip]
	vbroadcastsd	zmm4, QWORD PTR .LC22[rip]
	vaddsd	xmm6, xmm0, QWORD PTR [rbp-56]
	mov	r9, QWORD PTR [rbp-64]
	mov	r8, QWORD PTR [rbp-72]
	js	.L207
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rcx
.L208:
	vdivsd	xmm6, xmm6, xmm1
	test	rbx, rbx
	je	.L223
	cmp	rcx, 2
	jbe	.L224
	mov	rcx, rbx
	shr	rcx, 2
	sal	rcx, 5
	vmovdqa64	ymm2, YMMWORD PTR .LC26[rip]
	vmovdqa64	ymm7, YMMWORD PTR .LC28[rip]
	vbroadcastsd	ymm9, xmm6
	vbroadcastsd	ymm8, xmm0
	mov	rdx, r12
	add	rcx, r12
	.p2align 4,,10
	.p2align 3
.L211:
	vcvtqq2pd	ymm1, ymm2
	vfmadd132pd	ymm1, ymm8, ymm9
	add	rdx, 32
	vpaddq	ymm2, ymm2, ymm7
	vmovapd	YMMWORD PTR [rdx-32], ymm1
	cmp	rdx, rcx
	jne	.L211
	mov	rdx, rbx
	and	rdx, -4
	cmp	rbx, rdx
	je	.L212
.L210:
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	lea	rcx, [rdx+1]
	vfmadd132sd	xmm1, xmm0, xmm6
	vmovsd	QWORD PTR [r12+rdx*8], xmm1
	cmp	rbx, rcx
	jbe	.L212
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rcx
	add	rdx, 2
	vfmadd132sd	xmm1, xmm0, xmm6
	vmovsd	QWORD PTR [r12+rcx*8], xmm1
	cmp	rbx, rdx
	jbe	.L212
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	vfmadd231sd	xmm0, xmm1, xmm6
	vmovsd	QWORD PTR [r12+rdx*8], xmm0
.L212:
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L213:
	vmovapd	zmm2, ZMMWORD PTR [r12+rdx*8]
	vrsqrt14pd	zmm1, zmm2
	vsqrtpd	zmm0, zmm2
	vdivpd	zmm0, zmm5, zmm0
	vmovapd	ZMMWORD PTR [r14+rdx*8], zmm0
	vmulpd	zmm0, zmm1, zmm1
	vmovapd	ZMMWORD PTR [r8+rdx*8], zmm1
	vmulpd	zmm1, zmm1, zmm4
	vfnmadd132pd	zmm0, zmm3, zmm2
	vmulpd	zmm0, zmm0, zmm1
	vmulpd	zmm1, zmm0, zmm0
	vmovapd	ZMMWORD PTR [r9+rdx*8], zmm0
	vmulpd	zmm0, zmm0, zmm4
	vfnmadd132pd	zmm1, zmm3, zmm2
	vmulpd	zmm0, zmm1, zmm0
	vmovapd	ZMMWORD PTR [rax+rdx*8], zmm0
	add	rdx, 8
	cmp	rbx, rdx
	ja	.L213
	vmovsd	xmm12, QWORD PTR .LC31[rip]
	vmovq	xmm5, QWORD PTR .LC32[rip]
	xor	edx, edx
	xor	ecx, ecx
	xor	esi, esi
	xor	edi, edi
	vxorpd	xmm9, xmm9, xmm9
	vxorpd	xmm6, xmm6, xmm6
	vxorpd	xmm10, xmm10, xmm10
	vxorpd	xmm7, xmm7, xmm7
	vxorpd	xmm11, xmm11, xmm11
	vxorpd	xmm8, xmm8, xmm8
	vxorpd	xmm2, xmm2, xmm2
	vxorpd	xmm0, xmm0, xmm0
	.p2align 4,,10
	.p2align 3
.L222:
	vmovsd	xmm3, QWORD PTR [r14+rdx*8]
	vdivsd	xmm4, xmm12, QWORD PTR [r12+rdx*8]
	vfmsub132sd	xmm3, xmm4, xmm3
	vandpd	xmm3, xmm3, xmm5
	vdivsd	xmm3, xmm3, xmm4
	vcomisd	xmm3, xmm0
	vaddsd	xmm2, xmm2, xmm3
	vmaxsd	xmm0, xmm3, xmm0
	vmovsd	xmm3, QWORD PTR [r8+rdx*8]
	cmova	r13, rdx
	vfmsub132sd	xmm3, xmm4, xmm3
	vandpd	xmm3, xmm3, xmm5
	vdivsd	xmm3, xmm3, xmm4
	vcomisd	xmm3, xmm8
	vaddsd	xmm11, xmm11, xmm3
	vmaxsd	xmm8, xmm3, xmm8
	vmovsd	xmm3, QWORD PTR [r9+rdx*8]
	cmova	rdi, rdx
	vfmsub132sd	xmm3, xmm4, xmm3
	vandpd	xmm3, xmm3, xmm5
	vdivsd	xmm3, xmm3, xmm4
	vcomisd	xmm3, xmm7
	vaddsd	xmm10, xmm10, xmm3
	vmaxsd	xmm7, xmm3, xmm7
	vmovsd	xmm3, QWORD PTR [rax+rdx*8]
	cmova	rsi, rdx
	vfmsub132sd	xmm3, xmm4, xmm3
	vmovapd	xmm1, xmm3
	vandpd	xmm1, xmm1, xmm5
	vdivsd	xmm1, xmm1, xmm4
	vcomisd	xmm1, xmm6
	vaddsd	xmm9, xmm9, xmm1
	vmaxsd	xmm6, xmm1, xmm6
	cmova	rcx, rdx
	inc	rdx
	cmp	rdx, rbx
	jne	.L222
	lea	rax, [r12+r13*8]
	lea	r14, [r12+rsi*8]
	lea	r13, [r12+rdi*8]
	lea	r12, [r12+rcx*8]
.L209:
	vxorpd	xmm16, xmm16, xmm16
	vcvtsi2sdq	xmm16, xmm16, rbx
	vmovsd	xmm1, QWORD PTR [rax]
	mov	edi, OFFSET FLAT:.LC34
	mov	eax, 3
	vdivsd	xmm2, xmm2, xmm16
	vmovsd	QWORD PTR [rbp-104], xmm8
	vmovsd	QWORD PTR [rbp-96], xmm11
	vmovsd	QWORD PTR [rbp-88], xmm7
	vmovsd	QWORD PTR [rbp-80], xmm10
	vmovsd	QWORD PTR [rbp-72], xmm6
	vmovsd	QWORD PTR [rbp-64], xmm9
	vmovsd	QWORD PTR [rbp-56], xmm16
	vzeroupper
	call	printf
	vmovsd	xmm8, QWORD PTR [rbp-104]
	vmovsd	xmm11, QWORD PTR [rbp-96]
	vmovsd	xmm1, QWORD PTR [r13+0]
	vmovapd	xmm0, xmm8
	mov	edi, OFFSET FLAT:.LC35
	mov	eax, 3
	vdivsd	xmm2, xmm11, QWORD PTR [rbp-56]
	call	printf
	vmovsd	xmm7, QWORD PTR [rbp-88]
	vmovsd	xmm10, QWORD PTR [rbp-80]
	vmovsd	xmm1, QWORD PTR [r14]
	vmovapd	xmm0, xmm7
	mov	edi, OFFSET FLAT:.LC36
	mov	eax, 3
	vdivsd	xmm2, xmm10, QWORD PTR [rbp-56]
	call	printf
	vmovsd	xmm9, QWORD PTR [rbp-64]
	vmovsd	xmm6, QWORD PTR [rbp-72]
	vdivsd	xmm2, xmm9, QWORD PTR [rbp-56]
	vmovsd	xmm1, QWORD PTR [r12]
	add	rsp, 72
	pop	rbx
	pop	r12
	pop	r13
	.cfi_remember_state
	.cfi_def_cfa 13, 0
	pop	r14
	pop	r15
	pop	rbp
	lea	rsp, [r13-16]
	.cfi_def_cfa 7, 16
	vmovapd	xmm0, xmm6
	mov	edi, OFFSET FLAT:.LC37
	mov	eax, 3
	pop	r13
	.cfi_def_cfa_offset 8
	jmp	printf
	.p2align 4,,10
	.p2align 3
.L207:
	.cfi_restore_state
	mov	rdx, rcx
	mov	rsi, rcx
	shr	rdx
	and	esi, 1
	or	rdx, rsi
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	vaddsd	xmm1, xmm1, xmm1
	jmp	.L208
	.p2align 4,,10
	.p2align 3
.L233:
	add	rsp, 72
	pop	rbx
	pop	r12
	pop	r13
	.cfi_remember_state
	.cfi_def_cfa 13, 0
	pop	r14
	pop	r15
	pop	rbp
	lea	rsp, [r13-16]
	.cfi_def_cfa 7, 16
	mov	edi, OFFSET FLAT:.LC39
	pop	r13
	.cfi_def_cfa_offset 8
	jmp	puts
	.p2align 4,,10
	.p2align 3
.L223:
	.cfi_restore_state
	mov	r14, r12
	mov	r13, r12
	mov	rax, r12
	vxorpd	xmm9, xmm9, xmm9
	vxorpd	xmm6, xmm6, xmm6
	vxorpd	xmm10, xmm10, xmm10
	vxorpd	xmm7, xmm7, xmm7
	vxorpd	xmm11, xmm11, xmm11
	vxorpd	xmm8, xmm8, xmm8
	vxorpd	xmm2, xmm2, xmm2
	vxorpd	xmm0, xmm0, xmm0
	jmp	.L209
.L224:
	xor	edx, edx
	jmp	.L210
	.cfi_endproc
.LFE7352:
	.size	_Z13sqrt_accuracyddm, .-_Z13sqrt_accuracyddm
	.section	.text._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E,"axG",@progbits,_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E
	.type	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E, @function
_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E:
.LFB7714:
	.cfi_startproc
	test	rsi, rsi
	je	.L250
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	rbx, rsi
.L236:
	mov	rsi, QWORD PTR [rbx+24]
	mov	rdi, r12
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E
	mov	rdi, QWORD PTR [rbx+32]
	lea	rax, [rbx+48]
	mov	rbp, QWORD PTR [rbx+16]
	cmp	rdi, rax
	je	.L237
	call	_ZdlPv
	mov	rdi, rbx
	call	_ZdlPv
	test	rbp, rbp
	je	.L245
.L238:
	mov	rbx, rbp
	jmp	.L236
	.p2align 4,,10
	.p2align 3
.L237:
	mov	rdi, rbx
	call	_ZdlPv
	test	rbp, rbp
	jne	.L238
.L245:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L250:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	ret
	.cfi_endproc
.LFE7714:
	.size	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E, .-_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E
	.section	.text._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_,"axG",@progbits,_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_
	.type	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_, @function
_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_:
.LFB7871:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	rbx, QWORD PTR [rdi+16]
	mov	QWORD PTR [rsp+8], rdi
	mov	QWORD PTR [rsp], rsi
	test	rbx, rbx
	je	.L278
	mov	r13, QWORD PTR [rsi+8]
	mov	rbp, QWORD PTR [rsi]
	jmp	.L254
	.p2align 4,,10
	.p2align 3
.L258:
	mov	rax, QWORD PTR [rbx+24]
	xor	esi, esi
	test	rax, rax
	je	.L255
.L279:
	mov	rbx, rax
.L254:
	mov	r14, QWORD PTR [rbx+40]
	mov	r12, QWORD PTR [rbx+32]
	cmp	r13, r14
	mov	r15, r14
	cmovbe	r15, r13
	test	r15, r15
	je	.L256
	mov	rdx, r15
	mov	rsi, r12
	mov	rdi, rbp
	call	memcmp
	test	eax, eax
	je	.L256
.L257:
	test	eax, eax
	jns	.L258
.L259:
	mov	rax, QWORD PTR [rbx+16]
	mov	esi, 1
	test	rax, rax
	jne	.L279
.L255:
	mov	r9, rbx
	test	sil, sil
	jne	.L253
.L261:
	test	r15, r15
	je	.L264
	mov	rdx, r15
	mov	rsi, rbp
	mov	rdi, r12
	mov	QWORD PTR [rsp], r9
	call	memcmp
	test	eax, eax
	mov	r9, QWORD PTR [rsp]
	jne	.L265
.L264:
	sub	r14, r13
	cmp	r14, 2147483647
	jg	.L266
	cmp	r14, -2147483648
	jl	.L267
	mov	eax, r14d
.L265:
	test	eax, eax
	jns	.L266
.L267:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	xor	eax, eax
	mov	rdx, r9
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L256:
	.cfi_restore_state
	mov	rax, r13
	sub	rax, r14
	cmp	rax, 2147483647
	jg	.L258
	cmp	rax, -2147483648
	jge	.L257
	jmp	.L259
	.p2align 4,,10
	.p2align 3
.L266:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	rax, rbx
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	xor	edx, edx
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L278:
	.cfi_restore_state
	lea	rbx, [rdi+8]
.L253:
	mov	rax, QWORD PTR [rsp+8]
	cmp	QWORD PTR [rax+24], rbx
	je	.L280
	mov	rdi, rbx
	call	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base
	mov	rcx, QWORD PTR [rsp]
	mov	r14, QWORD PTR [rax+40]
	mov	r13, QWORD PTR [rcx+8]
	mov	r15, r14
	cmp	r13, r14
	mov	r9, rbx
	mov	rbp, QWORD PTR [rcx]
	mov	r12, QWORD PTR [rax+32]
	cmovbe	r15, r13
	mov	rbx, rax
	jmp	.L261
	.p2align 4,,10
	.p2align 3
.L280:
	add	rsp, 24
	.cfi_def_cfa_offset 56
	mov	rdx, rbx
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	xor	eax, eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7871:
	.size	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_, .-_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_
	.section	.text._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_,"axG",@progbits,_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_
	.type	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_, @function
_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_:
.LFB7786:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	lea	rax, [rdi+8]
	mov	r15, rdx
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rdi
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	cmp	rsi, rax
	je	.L325
	mov	rbp, QWORD PTR [rdx+8]
	mov	r12, QWORD PTR [rsi+40]
	mov	rbx, rsi
	cmp	rbp, r12
	mov	rcx, r12
	cmovbe	rcx, rbp
	mov	r8, QWORD PTR [rsi+32]
	mov	r14, QWORD PTR [rdx]
	test	rcx, rcx
	je	.L288
	mov	rdx, rcx
	mov	rsi, r8
	mov	rdi, r14
	mov	QWORD PTR [rsp+8], rcx
	mov	QWORD PTR [rsp], r8
	call	memcmp
	test	eax, eax
	mov	r8, QWORD PTR [rsp]
	mov	rcx, QWORD PTR [rsp+8]
	jne	.L326
	mov	rax, rbp
	sub	rax, r12
	cmp	rax, 2147483647
	jg	.L307
.L308:
	cmp	rax, -2147483648
	jl	.L291
	test	eax, eax
	jns	.L292
.L291:
	mov	rax, rbx
	mov	rdx, rbx
	cmp	QWORD PTR [r13+24], rbx
	je	.L317
	mov	rdi, rbx
	call	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base
	mov	r12, QWORD PTR [rax+40]
	mov	rcx, rax
	cmp	rbp, r12
	mov	rdx, r12
	cmovbe	rdx, rbp
	test	rdx, rdx
	je	.L294
	mov	rdi, QWORD PTR [rax+32]
	mov	rsi, r14
	mov	QWORD PTR [rsp], rax
	call	memcmp
	test	eax, eax
	mov	rcx, QWORD PTR [rsp]
	jne	.L295
.L294:
	sub	r12, rbp
	cmp	r12, 2147483647
	jg	.L283
	cmp	r12, -2147483648
	jl	.L296
	mov	eax, r12d
.L295:
	test	eax, eax
	jns	.L283
.L296:
	cmp	QWORD PTR [rcx+24], 0
	mov	eax, 0
	cmovne	rax, rbx
	cmove	rbx, rcx
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	rdx, rbx
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L326:
	.cfi_restore_state
	js	.L291
	jmp	.L307
	.p2align 4,,10
	.p2align 3
.L292:
	test	rcx, rcx
	je	.L298
.L307:
	mov	rdx, rcx
	mov	rsi, r14
	mov	rdi, r8
	call	memcmp
	test	eax, eax
	jne	.L299
.L298:
	sub	r12, rbp
	cmp	r12, 2147483647
	jg	.L300
	cmp	r12, -2147483648
	jl	.L301
	mov	eax, r12d
.L299:
	test	eax, eax
	jns	.L300
.L301:
	cmp	QWORD PTR [r13+32], rbx
	je	.L324
	mov	rdi, rbx
	call	_ZSt18_Rb_tree_incrementPSt18_Rb_tree_node_base
	mov	rcx, QWORD PTR [rax+40]
	mov	r12, rax
	cmp	rbp, rcx
	mov	rdx, rcx
	cmovbe	rdx, rbp
	test	rdx, rdx
	je	.L303
	mov	rsi, QWORD PTR [rax+32]
	mov	rdi, r14
	mov	QWORD PTR [rsp], rcx
	call	memcmp
	test	eax, eax
	mov	rcx, QWORD PTR [rsp]
	jne	.L304
.L303:
	sub	rbp, rcx
	cmp	rbp, 2147483647
	jg	.L283
	cmp	rbp, -2147483648
	jl	.L305
	mov	eax, ebp
.L304:
	test	eax, eax
	jns	.L283
.L305:
	cmp	QWORD PTR [rbx+24], 0
	cmovne	rbx, r12
	mov	eax, 0
	cmovne	rax, r12
	mov	rdx, rbx
	jmp	.L317
	.p2align 4,,10
	.p2align 3
.L300:
	mov	rax, rbx
	xor	edx, edx
.L317:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L325:
	.cfi_restore_state
	cmp	QWORD PTR [rdi+40], 0
	je	.L283
	mov	rbx, QWORD PTR [rdi+32]
	mov	r12, QWORD PTR [rdx+8]
	mov	rbp, QWORD PTR [rbx+40]
	mov	rdx, r12
	cmp	rbp, r12
	cmovbe	rdx, rbp
	test	rdx, rdx
	je	.L284
	mov	rdi, QWORD PTR [rbx+32]
	mov	rsi, QWORD PTR [r15]
	call	memcmp
	test	eax, eax
	je	.L284
.L285:
	test	eax, eax
	jns	.L283
.L324:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	rdx, rbx
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	xor	eax, eax
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L283:
	.cfi_restore_state
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	mov	rdi, r13
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	mov	rsi, r15
	pop	r15
	.cfi_def_cfa_offset 8
	jmp	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE24_M_get_insert_unique_posERS7_
	.p2align 4,,10
	.p2align 3
.L284:
	.cfi_restore_state
	sub	rbp, r12
	cmp	rbp, 2147483647
	jg	.L283
	cmp	rbp, -2147483648
	jl	.L324
	mov	eax, ebp
	jmp	.L285
	.p2align 4,,10
	.p2align 3
.L288:
	mov	rax, rbp
	sub	rax, r12
	cmp	rax, 2147483647
	jle	.L308
	jmp	.L298
	.cfi_endproc
.LFE7786:
	.size	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_, .-_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_
	.section	.text._ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_,"axG",@progbits,_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
	.type	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_, @function
_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_:
.LFB7596:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rsi
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	lea	r13, [rdi+8]
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	rbp, QWORD PTR [rdi+16]
	test	rbp, rbp
	je	.L347
	mov	r14, QWORD PTR [rsi+8]
	mov	r8, QWORD PTR [rsi]
	mov	rbx, r13
	jmp	.L329
	.p2align 4,,10
	.p2align 3
.L333:
	mov	rbx, rbp
	mov	rbp, QWORD PTR [rbp+16]
	test	rbp, rbp
	je	.L330
.L329:
	mov	rcx, QWORD PTR [rbp+40]
	mov	rdx, r14
	cmp	rcx, r14
	cmovbe	rdx, rcx
	test	rdx, rdx
	je	.L331
	mov	rdi, QWORD PTR [rbp+32]
	mov	rsi, r8
	mov	QWORD PTR [rsp+8], rcx
	mov	QWORD PTR [rsp], r8
	call	memcmp
	test	eax, eax
	mov	r8, QWORD PTR [rsp]
	mov	rcx, QWORD PTR [rsp+8]
	je	.L331
.L332:
	test	eax, eax
	jns	.L333
.L334:
	mov	rbp, QWORD PTR [rbp+24]
	test	rbp, rbp
	jne	.L329
.L330:
	cmp	r13, rbx
	je	.L328
	mov	rbp, QWORD PTR [rbx+40]
	cmp	r14, rbp
	mov	rdx, rbp
	cmovbe	rdx, r14
	test	rdx, rdx
	je	.L336
	mov	rsi, QWORD PTR [rbx+32]
	mov	rdi, r8
	call	memcmp
	test	eax, eax
	jne	.L337
.L336:
	sub	r14, rbp
	cmp	r14, 2147483647
	jg	.L338
	cmp	r14, -2147483648
	jl	.L328
	mov	eax, r14d
.L337:
	test	eax, eax
	jns	.L338
.L328:
	mov	edi, 72
	call	_Znwm
	lea	r14, [rax+48]
	mov	rdx, QWORD PTR [r15]
	mov	rbp, rbx
	mov	QWORD PTR [rax+32], r14
	mov	rbx, rax
	lea	rax, [r15+16]
	cmp	rdx, rax
	je	.L361
	mov	QWORD PTR [rbx+32], rdx
	mov	rdx, QWORD PTR [r15+16]
	mov	QWORD PTR [rbx+48], rdx
.L340:
	mov	rdx, QWORD PTR [r15+8]
	mov	QWORD PTR [r15], rax
	mov	QWORD PTR [rbx+40], rdx
	mov	QWORD PTR [r15+8], 0
	mov	BYTE PTR [r15+16], 0
	mov	DWORD PTR [rbx+64], 0
	mov	rsi, rbp
	lea	rdx, [rbx+32]
	mov	rdi, r12
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_
	mov	r15, rax
	mov	rbp, rdx
	test	rdx, rdx
	je	.L341
	test	rax, rax
	jne	.L350
	cmp	r13, rdx
	jne	.L362
.L350:
	mov	edi, 1
.L342:
	mov	rcx, r13
	mov	rdx, rbp
	mov	rsi, rbx
	call	_ZSt29_Rb_tree_insert_and_rebalancebPSt18_Rb_tree_node_baseS0_RS_
	inc	QWORD PTR [r12+40]
.L338:
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	lea	rax, [rbx+64]
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L331:
	.cfi_restore_state
	mov	rax, rcx
	sub	rax, r14
	cmp	rax, 2147483647
	jg	.L333
	cmp	rax, -2147483648
	jge	.L332
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L361:
	vmovdqu64	xmm0, XMMWORD PTR [r15+16]
	vmovups	XMMWORD PTR [rbx+48], xmm0
	jmp	.L340
	.p2align 4,,10
	.p2align 3
.L362:
	mov	r14, QWORD PTR [rbx+40]
	mov	r15, QWORD PTR [rdx+40]
	cmp	r14, r15
	mov	rdx, r15
	cmovbe	rdx, r14
	test	rdx, rdx
	je	.L343
	mov	rsi, QWORD PTR [rbp+32]
	mov	rdi, QWORD PTR [rbx+32]
	call	memcmp
	test	eax, eax
	jne	.L344
.L343:
	mov	rax, r14
	sub	rax, r15
	xor	edi, edi
	cmp	rax, 2147483647
	jg	.L342
	cmp	rax, -2147483648
	jl	.L350
.L344:
	shr	eax, 31
	mov	edi, eax
	jmp	.L342
	.p2align 4,,10
	.p2align 3
.L341:
	mov	rdi, QWORD PTR [rbx+32]
	cmp	r14, rdi
	je	.L346
	call	_ZdlPv
.L346:
	mov	rdi, rbx
	call	_ZdlPv
	mov	rbx, r15
	jmp	.L338
	.p2align 4,,10
	.p2align 3
.L347:
	mov	rbx, r13
	jmp	.L328
	.cfi_endproc
.LFE7596:
	.size	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_, .-_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
	.section	.rodata._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_.str1.1,"aMS",@progbits,1
.LC40:
	.string	"basic_string::_M_create"
	.section	.text._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_,"axG",@progbits,_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_
	.type	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_, @function
_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_:
.LFB7733:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7733
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdi
	mov	edi, 72
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	rbp, rcx
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	mov	QWORD PTR [rsp+8], rsi
.LEHB0:
	call	_Znwm
.LEHE0:
	mov	rbx, rax
	lea	r14, [rbx+48]
	mov	QWORD PTR [rbx+32], r14
	mov	rax, QWORD PTR [rbp+0]
	lea	r15, [rbx+32]
	mov	r13, QWORD PTR [rax]
	mov	rbp, QWORD PTR [rax+8]
	mov	rax, r13
	add	rax, rbp
	je	.L364
	test	r13, r13
	je	.L398
.L364:
	cmp	rbp, 15
	ja	.L399
	cmp	rbp, 1
	jne	.L368
	movzx	eax, BYTE PTR [r13+0]
	mov	BYTE PTR [rbx+48], al
	mov	rax, r14
.L369:
	mov	QWORD PTR [rbx+40], rbp
	mov	BYTE PTR [rax+rbp], 0
	mov	DWORD PTR [rbx+64], 0
	mov	rsi, QWORD PTR [rsp+8]
	mov	rdx, r15
	mov	rdi, r12
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE29_M_get_insert_hint_unique_posESt23_Rb_tree_const_iteratorIS9_ERS7_
	mov	rbp, rdx
	test	rdx, rdx
	je	.L400
	lea	rcx, [r12+8]
	mov	edi, 1
	test	rax, rax
	je	.L401
.L374:
	mov	rdx, rbp
	mov	rsi, rbx
	call	_ZSt29_Rb_tree_insert_and_rebalancebPSt18_Rb_tree_node_baseS0_RS_
	inc	QWORD PTR [r12+40]
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	mov	rax, rbx
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L368:
	.cfi_restore_state
	mov	rax, r14
	test	rbp, rbp
	je	.L369
	jmp	.L367
	.p2align 4,,10
	.p2align 3
.L399:
	test	rbp, rbp
	js	.L402
	lea	rdi, [rbp+1]
.LEHB1:
	call	_Znwm
	mov	QWORD PTR [rbx+32], rax
	mov	QWORD PTR [rbx+48], rbp
.L367:
	mov	rdx, rbp
	mov	rsi, r13
	mov	rdi, rax
	call	memcpy
	mov	rax, QWORD PTR [rbx+32]
	jmp	.L369
	.p2align 4,,10
	.p2align 3
.L400:
	mov	rdi, QWORD PTR [rbx+32]
	cmp	r14, rdi
	je	.L378
	mov	QWORD PTR [rsp+8], rax
	call	_ZdlPv
	mov	rax, QWORD PTR [rsp+8]
.L378:
	mov	rdi, rbx
	mov	QWORD PTR [rsp+8], rax
	call	_ZdlPv
	mov	rax, QWORD PTR [rsp+8]
	add	rsp, 24
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L401:
	.cfi_restore_state
	cmp	rdx, rcx
	je	.L374
	mov	r13, QWORD PTR [rbx+40]
	mov	r14, QWORD PTR [rdx+40]
	cmp	r13, r14
	mov	rdx, r14
	cmovbe	rdx, r13
	test	rdx, rdx
	je	.L375
	mov	rsi, QWORD PTR [rbp+32]
	mov	rdi, QWORD PTR [rbx+32]
	mov	QWORD PTR [rsp+8], rcx
	call	memcmp
	test	eax, eax
	mov	rcx, QWORD PTR [rsp+8]
	je	.L375
.L376:
	shr	eax, 31
	mov	edi, eax
	jmp	.L374
	.p2align 4,,10
	.p2align 3
.L375:
	mov	rax, r13
	sub	rax, r14
	xor	edi, edi
	cmp	rax, 2147483647
	jg	.L374
	cmp	rax, -2147483648
	jge	.L376
	mov	edi, 1
	jmp	.L374
.L398:
	mov	edi, OFFSET FLAT:.LC0
	call	_ZSt19__throw_logic_errorPKc
.L402:
	mov	edi, OFFSET FLAT:.LC40
	call	_ZSt20__throw_length_errorPKc
.LEHE1:
.L384:
.L372:
	mov	rdi, rax
	vzeroupper
	call	__cxa_begin_catch
	mov	rdi, rbx
	call	_ZdlPv
.LEHB2:
	call	__cxa_rethrow
.LEHE2:
.L385:
	mov	rbx, rax
.L373:
	vzeroupper
	call	__cxa_end_catch
	mov	rdi, rbx
.LEHB3:
	call	_Unwind_Resume
.LEHE3:
	.cfi_endproc
.LFE7733:
	.section	.gcc_except_table
	.align 4
.LLSDA7733:
	.byte	0xff
	.byte	0x3
	.uleb128 .LLSDATT7733-.LLSDATTD7733
.LLSDATTD7733:
	.byte	0x1
	.uleb128 .LLSDACSE7733-.LLSDACSB7733
.LLSDACSB7733:
	.uleb128 .LEHB0-.LFB7733
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB7733
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L384-.LFB7733
	.uleb128 0x1
	.uleb128 .LEHB2-.LFB7733
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L385-.LFB7733
	.uleb128 0
	.uleb128 .LEHB3-.LFB7733
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSE7733:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT7733:
	.section	.text._ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_,"axG",@progbits,_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_,comdat
	.size	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_, .-_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_
	.section	.rodata.str1.1
.LC41:
	.string	"accuracy-sqrt"
.LC42:
	.string	"Using %zu threads\n"
.LC43:
	.string	"Unknown benchmark: %s\n"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB44:
	.section	.text.startup,"ax",@progbits
.LHOTB44:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB7321:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7321
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	mov	r12, rsi
	push	rbx
	.cfi_offset 3, -56
	mov	ebx, edi
	and	rsp, -64
	sub	rsp, 576
.LEHB4:
	call	likwid_markerInit
	call	likwid_markerThreadInit
.LEHE4:
	lea	rax, [rsp+152]
	mov	esi, OFFSET FLAT:.LC5
	lea	rdi, [rsp+320]
	mov	DWORD PTR [rsp+152], 0
	mov	QWORD PTR [rsp+160], 0
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+176], rax
	mov	QWORD PTR [rsp+184], 0
.LEHB5:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE5:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB6:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE6:
	mov	DWORD PTR [rax], 1
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L404
	call	_ZdlPv
.L404:
	mov	esi, OFFSET FLAT:.LC7
	lea	rdi, [rsp+320]
.LEHB7:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE7:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB8:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE8:
	mov	DWORD PTR [rax], 2
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L405
	call	_ZdlPv
.L405:
	mov	esi, OFFSET FLAT:.LC8
	lea	rdi, [rsp+320]
.LEHB9:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE9:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB10:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE10:
	mov	DWORD PTR [rax], 3
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L406
	call	_ZdlPv
.L406:
	mov	esi, OFFSET FLAT:.LC10
	lea	rdi, [rsp+320]
.LEHB11:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE11:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB12:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE12:
	mov	DWORD PTR [rax], 4
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L407
	call	_ZdlPv
.L407:
	mov	esi, OFFSET FLAT:.LC11
	lea	rdi, [rsp+320]
.LEHB13:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE13:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB14:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE14:
	mov	DWORD PTR [rax], 5
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L408
	call	_ZdlPv
.L408:
	mov	esi, OFFSET FLAT:.LC12
	lea	rdi, [rsp+320]
.LEHB15:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE15:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB16:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE16:
	mov	DWORD PTR [rax], 6
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L409
	call	_ZdlPv
.L409:
	mov	esi, OFFSET FLAT:.LC13
	lea	rdi, [rsp+320]
.LEHB17:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE17:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB18:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE18:
	mov	DWORD PTR [rax], 7
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L410
	call	_ZdlPv
.L410:
	mov	esi, OFFSET FLAT:.LC16
	lea	rdi, [rsp+320]
.LEHB19:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE19:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB20:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE20:
	mov	DWORD PTR [rax], 8
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L411
	call	_ZdlPv
.L411:
	mov	esi, OFFSET FLAT:.LC38
	lea	rdi, [rsp+320]
.LEHB21:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE21:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB22:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE22:
	mov	DWORD PTR [rax], 9
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L412
	call	_ZdlPv
.L412:
	mov	esi, OFFSET FLAT:.LC41
	lea	rdi, [rsp+320]
.LEHB23:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC2IS3_EEPKcRKS3_.constprop.67
.LEHE23:
	lea	rsi, [rsp+320]
	lea	rdi, [rsp+144]
.LEHB24:
	call	_ZNSt3mapINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE14Benchmark_typeSt4lessIS5_ESaISt4pairIKS5_S6_EEEixEOS5_
.LEHE24:
	mov	DWORD PTR [rax], 0
	lea	rax, [rsp+336]
	mov	rdi, QWORD PTR [rsp+320]
	cmp	rdi, rax
	je	.L413
	call	_ZdlPv
.L413:
	lea	rax, [rsp+48]
	lea	rcx, [rsp+24]
	lea	rdx, [rsp+32]
	mov	rsi, r12
	mov	edi, ebx
	mov	QWORD PTR [rsp+32], rax
	mov	QWORD PTR [rsp+40], 0
	mov	BYTE PTR [rsp+48], 0
.LEHB25:
	call	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPm
	mov	r12, QWORD PTR [rsp+160]
	mov	r14, QWORD PTR [rsp+32]
	test	r12, r12
	je	.L414
	mov	rbx, QWORD PTR [rsp+40]
	mov	r13, r12
	lea	rcx, [rsp+152]
	jmp	.L415
	.p2align 4,,10
	.p2align 3
.L419:
	mov	rcx, r13
	mov	r13, QWORD PTR [r13+16]
	test	r13, r13
	je	.L416
.L415:
	mov	r15, QWORD PTR [r13+40]
	mov	rdx, rbx
	cmp	r15, rbx
	cmovbe	rdx, r15
	test	rdx, rdx
	je	.L417
	mov	rdi, QWORD PTR [r13+32]
	mov	rsi, r14
	mov	QWORD PTR [rsp+8], rcx
	call	memcmp
	test	eax, eax
	mov	rcx, QWORD PTR [rsp+8]
	je	.L417
.L418:
	test	eax, eax
	jns	.L419
.L420:
	mov	r13, QWORD PTR [r13+24]
	test	r13, r13
	jne	.L415
.L416:
	lea	rax, [rsp+152]
	cmp	rcx, rax
	je	.L414
	mov	r13, QWORD PTR [rcx+40]
	cmp	rbx, r13
	mov	rdx, r13
	cmovbe	rdx, rbx
	test	rdx, rdx
	je	.L422
	mov	rsi, QWORD PTR [rcx+32]
	mov	rdi, r14
	call	memcmp
	test	eax, eax
	jne	.L423
.L422:
	mov	rax, rbx
	sub	rax, r13
	cmp	rax, 2147483647
	jg	.L461
	cmp	rax, -2147483648
	jl	.L414
.L423:
	test	eax, eax
	jns	.L461
.L414:
	mov	rsi, r14
	mov	edi, OFFSET FLAT:.LC43
	xor	eax, eax
	call	printf
.L460:
	mov	rdi, QWORD PTR [rsp+32]
	lea	rax, [rsp+48]
	cmp	rdi, rax
	je	.L436
	call	_ZdlPv
.L436:
	mov	rsi, QWORD PTR [rsp+160]
	lea	rdi, [rsp+144]
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	xor	eax, eax
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L417:
	.cfi_restore_state
	mov	rax, r15
	sub	rax, rbx
	cmp	rax, 2147483647
	jg	.L419
	cmp	rax, -2147483648
	jge	.L418
	jmp	.L420
.L461:
	lea	r13, [rsp+152]
	jmp	.L426
	.p2align 4,,10
	.p2align 3
.L430:
	mov	r12, QWORD PTR [r12+24]
	test	r12, r12
	je	.L513
.L426:
	mov	r15, QWORD PTR [r12+40]
	cmp	rbx, r15
	mov	rdx, r15
	cmovbe	rdx, rbx
	test	rdx, rdx
	je	.L427
	mov	rdi, QWORD PTR [r12+32]
	mov	rsi, r14
	call	memcmp
	test	eax, eax
	jne	.L428
.L427:
	mov	rax, r15
	sub	rax, rbx
	cmp	rax, 2147483647
	jg	.L429
	cmp	rax, -2147483648
	jl	.L430
.L428:
	test	eax, eax
	js	.L430
.L429:
	mov	r13, r12
	mov	r12, QWORD PTR [r12+16]
	test	r12, r12
	jne	.L426
.L513:
	lea	rax, [rsp+152]
	cmp	r13, rax
	je	.L432
	mov	r12, QWORD PTR [r13+40]
	cmp	rbx, r12
	mov	rdx, r12
	cmovbe	rdx, rbx
	test	rdx, rdx
	je	.L433
	mov	rsi, QWORD PTR [r13+32]
	mov	rdi, r14
	call	memcmp
	test	eax, eax
	jne	.L434
.L433:
	sub	rbx, r12
	cmp	rbx, 2147483647
	jg	.L435
	cmp	rbx, -2147483648
	jl	.L432
	mov	eax, ebx
.L434:
	test	eax, eax
	jns	.L435
.L432:
	lea	rax, [rsp+32]
	lea	r8, [rsp+23]
	lea	rcx, [rsp+96]
	mov	edx, OFFSET FLAT:_ZSt19piecewise_construct
	mov	rsi, r13
	lea	rdi, [rsp+144]
	mov	QWORD PTR [rsp+96], rax
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE22_M_emplace_hint_uniqueIJRKSt21piecewise_construct_tSt5tupleIJRS7_EESK_IJEEEEESt17_Rb_tree_iteratorIS9_ESt23_Rb_tree_const_iteratorIS9_EDpOT_
	mov	r14, QWORD PTR [rsp+32]
	mov	r13, rax
.L435:
	mov	rdi, r14
	mov	ebx, DWORD PTR [r13+64]
	call	likwid_markerRegisterRegion
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC42
	xor	eax, eax
	call	printf
	lea	rax, [rsp+24]
	mov	QWORD PTR [rsp+96], rax
	lea	rax, [rsp+320]
	mov	QWORD PTR [rsp+104], rax
	lea	rax, [rsp+192]
	mov	QWORD PTR [rsp+112], rax
	xor	ecx, ecx
	lea	rax, [rsp+64]
	mov	edx, 1
	lea	rsi, [rsp+96]
	mov	edi, OFFSET FLAT:main._omp_fn.0
	mov	DWORD PTR [rsp+128], ebx
	mov	QWORD PTR [rsp+120], rax
	call	GOMP_parallel
	call	likwid_markerClose
.LEHE25:
	jmp	.L460
.L472:
	mov	rbx, rax
	jmp	.L456
.L471:
	mov	rbx, rax
	jmp	.L454
.L470:
	mov	rbx, rax
	jmp	.L454
.L469:
	mov	rbx, rax
	jmp	.L454
.L473:
	mov	rbx, rax
	jmp	.L458
.L463:
	mov	rbx, rax
	vzeroupper
	jmp	.L439
.L464:
	mov	rbx, rax
	jmp	.L454
.L462:
	mov	rbx, rax
	jmp	.L454
.L468:
	mov	rbx, rax
	jmp	.L454
.L467:
	mov	rbx, rax
	jmp	.L454
.L466:
	mov	rbx, rax
	jmp	.L454
.L465:
	mov	rbx, rax
	jmp	.L454
	.section	.gcc_except_table
.LLSDA7321:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7321-.LLSDACSB7321
.LLSDACSB7321:
	.uleb128 .LEHB4-.LFB7321
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB5-.LFB7321
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB6-.LFB7321
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L462-.LFB7321
	.uleb128 0
	.uleb128 .LEHB7-.LFB7321
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB8-.LFB7321
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L464-.LFB7321
	.uleb128 0
	.uleb128 .LEHB9-.LFB7321
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB10-.LFB7321
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L465-.LFB7321
	.uleb128 0
	.uleb128 .LEHB11-.LFB7321
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB12-.LFB7321
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L466-.LFB7321
	.uleb128 0
	.uleb128 .LEHB13-.LFB7321
	.uleb128 .LEHE13-.LEHB13
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB14-.LFB7321
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L467-.LFB7321
	.uleb128 0
	.uleb128 .LEHB15-.LFB7321
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB16-.LFB7321
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L468-.LFB7321
	.uleb128 0
	.uleb128 .LEHB17-.LFB7321
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB18-.LFB7321
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L469-.LFB7321
	.uleb128 0
	.uleb128 .LEHB19-.LFB7321
	.uleb128 .LEHE19-.LEHB19
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB20-.LFB7321
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L470-.LFB7321
	.uleb128 0
	.uleb128 .LEHB21-.LFB7321
	.uleb128 .LEHE21-.LEHB21
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB22-.LFB7321
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L471-.LFB7321
	.uleb128 0
	.uleb128 .LEHB23-.LFB7321
	.uleb128 .LEHE23-.LEHB23
	.uleb128 .L463-.LFB7321
	.uleb128 0
	.uleb128 .LEHB24-.LFB7321
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L472-.LFB7321
	.uleb128 0
	.uleb128 .LEHB25-.LFB7321
	.uleb128 .LEHE25-.LEHB25
	.uleb128 .L473-.LFB7321
	.uleb128 0
.LLSDACSE7321:
	.section	.text.startup
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC7321
	.type	main.cold.70, @function
main.cold.70:
.LFSB7321:
.L456:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	mov	rdi, QWORD PTR [rsp+320]
	lea	rdx, [rsp+336]
	cmp	rdi, rdx
	je	.L500
.L504:
	vzeroupper
	call	_ZdlPv
.L439:
	mov	rsi, QWORD PTR [rsp+160]
	lea	rdi, [rsp+144]
	call	_ZNSt8_Rb_treeINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_14Benchmark_typeESt10_Select1stIS9_ESt4lessIS5_ESaIS9_EE8_M_eraseEPSt13_Rb_tree_nodeIS9_E
	mov	rdi, rbx
.LEHB26:
	call	_Unwind_Resume
.LEHE26:
.L454:
	mov	rdi, QWORD PTR [rsp+320]
	lea	rax, [rsp+336]
	cmp	rdi, rax
	jne	.L504
.L500:
	vzeroupper
	jmp	.L439
.L458:
	mov	rdi, QWORD PTR [rsp+32]
	lea	rax, [rsp+48]
	cmp	rdi, rax
	jne	.L504
	jmp	.L500
	.cfi_endproc
.LFE7321:
	.section	.gcc_except_table
.LLSDAC7321:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC7321-.LLSDACSBC7321
.LLSDACSBC7321:
	.uleb128 .LEHB26-.LCOLDB44
	.uleb128 .LEHE26-.LEHB26
	.uleb128 0
	.uleb128 0
.LLSDACSEC7321:
	.section	.text.unlikely
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold.70, .-main.cold.70
.LCOLDE44:
	.section	.text.startup
.LHOTE44:
	.weak	_ZSt19piecewise_construct
	.section	.rodata._ZSt19piecewise_construct,"aG",@progbits,_ZSt19piecewise_construct,comdat
	.type	_ZSt19piecewise_construct, @gnu_unique_object
	.size	_ZSt19piecewise_construct, 1
_ZSt19piecewise_construct:
	.zero	1
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC4:
	.long	0
	.long	1074790400
	.long	0
	.long	1074266112
	.long	0
	.long	1073741824
	.long	0
	.long	1072693248
	.align 32
.LC6:
	.long	0
	.long	1077936128
	.long	0
	.long	1077411840
	.long	0
	.long	1076887552
	.long	0
	.long	1075970048
	.align 32
.LC9:
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.align 32
.LC14:
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.align 32
.LC15:
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.section	.rodata
	.align 64
.LC17:
	.long	0
	.long	1075838976
	.long	0
	.long	1075576832
	.long	0
	.long	1075314688
	.long	0
	.long	1075052544
	.long	0
	.long	1074790400
	.long	0
	.long	1074266112
	.long	0
	.long	1073741824
	.long	0
	.long	1072693248
	.align 64
.LC18:
	.long	0
	.long	1078984704
	.long	0
	.long	1078722560
	.long	0
	.long	1078460416
	.long	0
	.long	1078198272
	.long	0
	.long	1077936128
	.long	0
	.long	1077411840
	.long	0
	.long	1076887552
	.long	0
	.long	1075970048
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC19:
	.long	0
	.long	1072693248
	.long	0
	.long	0
	.section	.rodata
	.align 64
.LC20:
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.long	0
	.long	1072693248
	.section	.rodata.cst16
	.align 16
.LC21:
	.long	0
	.long	1074266112
	.long	0
	.long	0
	.align 16
.LC22:
	.long	0
	.long	1071644672
	.long	0
	.long	0
	.section	.rodata
	.align 64
.LC24:
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.align 64
.LC25:
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.section	.rodata.cst32
	.align 32
.LC26:
	.quad	0
	.quad	1
	.quad	2
	.quad	3
	.align 32
.LC28:
	.quad	4
	.quad	4
	.quad	4
	.quad	4
	.align 32
.LC29:
	.long	63209523
	.long	1117925533
	.long	63209523
	.long	1117925533
	.long	63209523
	.long	1117925533
	.long	63209523
	.long	1117925533
	.align 32
.LC30:
	.long	210911779
	.long	1002937505
	.long	210911779
	.long	1002937505
	.long	210911779
	.long	1002937505
	.long	210911779
	.long	1002937505
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC31:
	.long	0
	.long	1072693248
	.section	.rodata.cst16
	.align 16
.LC32:
	.long	4294967295
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC33:
	.long	0
	.long	1097011920
	.ident	"GCC: (GNU) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
