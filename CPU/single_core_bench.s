	.file	"single_core_bench.cpp"
	.intel_syntax noprefix
	.text
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"Mismatch:"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"force[%d]          = [%f,%f,%f]\n"
	.align 8
.LC4:
	.string	"force_ref[%d]      = [%f,%f,%f]\n"
	.align 8
.LC5:
	.string	"recv_force[%d]     = [%f,%f,%f]\n"
	.align 8
.LC6:
	.string	"recv_force_ref[%d] = [%f,%f,%f]\n\n"
	.text
	.p2align 4,,15
	.type	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41, @function
_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41:
.LFB9328:
	.cfi_startproc
	test	r8d, r8d
	jle	.L6
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rcx
	lea	ecx, [r8-1]
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rdx
	xor	edx, edx
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rsi
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	rbp, rdi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xor	ebx, ebx
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	vmovq	xmm4, QWORD PTR .LC0[rip]
	vmovsd	xmm3, QWORD PTR .LC1[rip]
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L3:
	lea	rax, [rbx+1]
	cmp	rcx, rbx
	je	.L15
.L7:
	mov	rbx, rax
.L5:
	mov	rsi, QWORD PTR [rbp+0]
	mov	rax, QWORD PTR [rbp+8]
	vmovsd	xmm0, QWORD PTR [rsi+rbx*8]
	lea	r15, [0+rbx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp+16]
	vaddsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+0]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+8]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+16]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12]
	vaddsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12+8]
	vaddsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12+16]
	vaddsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+8]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+16]
	vsubsd	xmm0, xmm0, QWORD PTR [rax+rbx*8]
	vandpd	xmm0, xmm0, xmm4
	vcomisd	xmm0, xmm3
	jbe	.L3
	inc	edx
	cmp	edx, 9
	jg	.L3
	mov	edi, OFFSET FLAT:.LC2
	mov	DWORD PTR [rsp+12], edx
	mov	QWORD PTR [rsp], rcx
	call	puts
	mov	rsi, QWORD PTR [rbp+16]
	mov	rax, QWORD PTR [rbp+8]
	mov	rdi, QWORD PTR [rbp+0]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC3
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r13+16]
	mov	rax, QWORD PTR [r13+8]
	mov	rdi, QWORD PTR [r13+0]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC4
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r12+16]
	mov	rax, QWORD PTR [r12+8]
	mov	rdi, QWORD PTR [r12]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC5
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r14+16]
	mov	rax, QWORD PTR [r14+8]
	mov	rdi, QWORD PTR [r14]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC6
	mov	eax, 3
	call	printf
	mov	rax, QWORD PTR .LC1[rip]
	mov	rcx, QWORD PTR [rsp]
	vmovq	xmm3, rax
	vmovq	xmm4, QWORD PTR .LC0[rip]
	mov	edx, DWORD PTR [rsp+12]
	lea	rax, [rbx+1]
	cmp	rcx, rbx
	jne	.L7
.L15:
	add	rsp, 24
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
	mov	eax, edx
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L6:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	xor	edx, edx
	mov	eax, edx
	ret
	.cfi_endproc
.LFE9328:
	.size	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41, .-_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	.p2align 4,,15
	.type	_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48, @function
_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48:
.LFB9321:
	.cfi_startproc
	lea	rax, [rdx-1]
	mov	r10, rax
	shr	r10, 63
	add	r10, rax
	mov	r11, rdx
	sar	r10
	and	r11d, 1
	cmp	rsi, r10
	jge	.L17
	mov	r9, rsi
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L36:
	dec	rcx
	lea	r8, [rdi+rcx*8]
	vmovsd	xmm1, QWORD PTR [r8]
	vmovsd	QWORD PTR [rdi+r9*8], xmm1
	cmp	r10, rcx
	jle	.L21
.L22:
	mov	r9, rcx
.L18:
	lea	rax, [r9+1]
	lea	rcx, [rax+rax]
	sal	rax, 4
	lea	r8, [rdi+rax]
	vmovsd	xmm1, QWORD PTR [r8]
	vmovsd	xmm2, QWORD PTR [rdi-8+rax]
	vcomisd	xmm2, xmm1
	ja	.L36
	vmovsd	QWORD PTR [rdi+r9*8], xmm1
	cmp	r10, rcx
	jg	.L22
.L21:
	test	r11, r11
	je	.L28
.L23:
	lea	rax, [rcx-1]
	mov	rdx, rax
	shr	rdx, 63
	add	rdx, rax
	sar	rdx
	cmp	rcx, rsi
	jle	.L24
	vmovsd	xmm1, QWORD PTR [rdi+rdx*8]
	vcomisd	xmm0, xmm1
	ja	.L25
	jmp	.L24
	.p2align 4,,10
	.p2align 3
.L27:
	vmovsd	xmm1, QWORD PTR [rdi+rax*8]
	mov	rcx, rdx
	vcomisd	xmm0, xmm1
	mov	rdx, rax
	jbe	.L24
.L25:
	vmovsd	QWORD PTR [rdi+rcx*8], xmm1
	lea	rcx, [rdx-1]
	mov	rax, rcx
	shr	rax, 63
	add	rax, rcx
	sar	rax
	lea	r8, [rdi+rdx*8]
	cmp	rsi, rdx
	jl	.L27
.L24:
	vmovsd	QWORD PTR [r8], xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L17:
	lea	r8, [rdi+rsi*8]
	mov	rcx, rsi
	test	r11, r11
	jne	.L24
	.p2align 4,,10
	.p2align 3
.L28:
	sub	rdx, 2
	mov	rax, rdx
	shr	rax, 63
	add	rdx, rax
	sar	rdx
	cmp	rcx, rdx
	jne	.L23
	lea	rcx, [rcx+2+rcx]
	vmovsd	xmm1, QWORD PTR [rdi-8+rcx*8]
	dec	rcx
	vmovsd	QWORD PTR [r8], xmm1
	lea	r8, [rdi+rcx*8]
	jmp	.L23
	.cfi_endproc
.LFE9321:
	.size	_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48, .-_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48
	.p2align 4,,15
	.type	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39, @function
_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39:
.LFB9319:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	mov	r14, rdx
	mov	rdx, rsi
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	sub	rdx, rdi
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	cmp	rdx, 128
	jle	.L79
	mov	rbx, rdi
	lea	r13, [rdi+8]
	test	r14, r14
	je	.L83
.L41:
	sar	rdx, 4
	lea	rax, [rbx+rdx*8]
	vmovsd	xmm1, QWORD PTR [rbx+8]
	vmovsd	xmm2, QWORD PTR [rax]
	dec	r14
	vcomisd	xmm2, xmm1
	vmovsd	xmm3, QWORD PTR [rsi-8]
	vmovsd	xmm0, QWORD PTR [rbx]
	jbe	.L73
	vcomisd	xmm3, xmm2
	ja	.L77
	vcomisd	xmm3, xmm1
	ja	.L81
.L82:
	vmovsd	QWORD PTR [rbx], xmm1
	vmovsd	QWORD PTR [rbx+8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi-8]
.L48:
	mov	rbp, r13
	mov	rax, rsi
	.p2align 4,,10
	.p2align 3
.L53:
	vmovsd	xmm2, QWORD PTR [rbp+0]
	mov	r12, rbp
	vcomisd	xmm1, xmm2
	ja	.L56
	sub	rax, 8
	vcomisd	xmm0, xmm1
	jbe	.L57
	.p2align 4,,10
	.p2align 3
.L59:
	sub	rax, 8
	vmovsd	xmm0, QWORD PTR [rax]
	vcomisd	xmm0, xmm1
	ja	.L59
.L57:
	cmp	rax, rbp
	jbe	.L84
	vmovsd	QWORD PTR [rbp+0], xmm0
	vmovsd	QWORD PTR [rax], xmm2
	vmovsd	xmm1, QWORD PTR [rbx]
	vmovsd	xmm0, QWORD PTR [rax-8]
.L56:
	add	rbp, 8
	jmp	.L53
	.p2align 4,,10
	.p2align 3
.L73:
	vcomisd	xmm3, xmm1
	ja	.L82
	vcomisd	xmm3, xmm2
	jbe	.L77
.L81:
	vmovsd	QWORD PTR [rbx], xmm3
	vmovsd	QWORD PTR [rsi-8], xmm0
	vmovsd	xmm1, QWORD PTR [rbx]
	jmp	.L48
	.p2align 4,,10
	.p2align 3
.L84:
	mov	rdx, r14
	mov	rdi, rbp
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	mov	rdx, rbp
	sub	rdx, rbx
	cmp	rdx, 128
	jle	.L79
	mov	rsi, rbp
	test	r14, r14
	jne	.L41
.L39:
	sar	rdx, 3
	lea	r13, [rdx-2]
	sar	r13
	vmovsd	xmm0, QWORD PTR [rbx+r13*8]
	mov	rsi, r13
	mov	rdi, rbx
	mov	rbp, rdx
	call	_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48
.L42:
	dec	r13
	vmovsd	xmm0, QWORD PTR [rbx+r13*8]
	mov	rdx, rbp
	mov	rsi, r13
	mov	rdi, rbx
	call	_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48
	test	r13, r13
	jne	.L42
	.p2align 4,,10
	.p2align 3
.L43:
	sub	r12, 8
	mov	rbp, r12
	sub	rbp, rbx
	vmovsd	xmm1, QWORD PTR [rbx]
	vmovsd	xmm0, QWORD PTR [r12]
	mov	rdx, rbp
	sar	rdx, 3
	xor	esi, esi
	vmovsd	QWORD PTR [r12], xmm1
	mov	rdi, rbx
	call	_ZSt13__adjust_heapIPdldN9__gnu_cxx5__ops15_Iter_less_iterEEvT_T0_S5_T1_T2_.constprop.48
	cmp	rbp, 8
	jg	.L43
.L79:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L77:
	.cfi_restore_state
	vmovsd	QWORD PTR [rbx], xmm2
	vmovsd	QWORD PTR [rax], xmm0
	vmovsd	xmm1, QWORD PTR [rbx]
	vmovsd	xmm0, QWORD PTR [rsi-8]
	jmp	.L48
	.p2align 4,,10
	.p2align 3
.L83:
	mov	r12, rsi
	jmp	.L39
	.cfi_endproc
.LFE9319:
	.size	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39, .-_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	.section	.rodata.str1.1
.LC7:
	.string	"-n"
.LC8:
	.string	"-start"
.LC9:
	.string	"-step"
.LC10:
	.string	"-o"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"basic_string::_M_construct null not valid"
	.align 8
.LC12:
	.string	"Failed to read Arguments!\nUsing defaults!"
	.text
	.p2align 4,,15
	.globl	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_
	.type	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_, @function
_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_:
.LFB8590:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rsi
	mov	esi, 29539
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rdx
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, r9
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	ebp, edi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	lea	rbx, [rdx+16]
	sub	rsp, 88
	.cfi_def_cfa_offset 144
	mov	rdx, QWORD PTR [rdx]
	mov	QWORD PTR [rsp], rcx
	lea	rax, [rsp+64]
	movabs	rcx, 7160553448808540531
	mov	QWORD PTR [rsp+56], 15
	mov	QWORD PTR [rsp+48], rax
	mov	QWORD PTR [rsp+64], rcx
	mov	DWORD PTR [rsp+72], 778400367
	mov	WORD PTR [rsp+76], si
	mov	BYTE PTR [rsp+78], 118
	mov	BYTE PTR [rsp+79], 0
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR [rsp+8], r8
	mov	QWORD PTR [rsp+24], rbx
	mov	ecx, DWORD PTR [rsp+72]
	mov	DWORD PTR [rdx+8], ecx
	movzx	ecx, WORD PTR [rsp+76]
	mov	WORD PTR [rdx+12], cx
	movzx	ecx, BYTE PTR [rsp+78]
	mov	BYTE PTR [rdx+14], cl
	mov	rdx, QWORD PTR [rsp+56]
	mov	rcx, QWORD PTR [r14]
	mov	QWORD PTR [r14+8], rdx
	mov	BYTE PTR [rcx+rdx], 0
	mov	QWORD PTR [rsp+56], 0
	mov	rdx, QWORD PTR [rsp+48]
	mov	BYTE PTR [rdx], 0
	mov	rdi, QWORD PTR [rsp+48]
	cmp	rdi, rax
	je	.L86
	call	_ZdlPv
.L86:
	mov	rax, QWORD PTR [rsp]
	mov	ebx, 1
	mov	QWORD PTR [rax], 1000
	mov	rax, QWORD PTR [rsp+8]
	mov	r13d, OFFSET FLAT:.LC7
	mov	QWORD PTR [rax], 1000
	lea	rax, [rsp+64]
	mov	QWORD PTR [r12], 1
	mov	QWORD PTR [rsp+16], rax
	cmp	ebp, 1
	jle	.L91
	.p2align 4,,10
	.p2align 3
.L87:
	movsx	rax, ebx
	mov	rdx, QWORD PTR [r15+rax*8]
	mov	ecx, 3
	mov	rsi, rdx
	mov	rdi, r13
	repz cmpsb
	lea	r8, [0+rax*8]
	lea	r9d, [rbx+1]
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L90
	cmp	ebp, r9d
	jg	.L130
.L91:
	lea	rax, [rsp+64]
	cmp	QWORD PTR [r14+8], 0
	mov	QWORD PTR [rsp+48], rax
	mov	QWORD PTR [rsp+56], 0
	mov	BYTE PTR [rsp+64], 0
	je	.L88
	mov	rax, QWORD PTR [rsp]
	cmp	QWORD PTR [rax], 0
	jne	.L131
	.p2align 4,,10
	.p2align 3
.L88:
	mov	edi, OFFSET FLAT:.LC12
	call	puts
	mov	edx, 29539
	mov	WORD PTR [rsp+76], dx
	mov	rdx, QWORD PTR [r14]
	movabs	rcx, 7160553448808540531
	lea	rax, [rsp+64]
	mov	QWORD PTR [rsp+48], rax
	mov	QWORD PTR [rsp+56], 15
	mov	QWORD PTR [rsp+64], rcx
	mov	DWORD PTR [rsp+72], 778400367
	mov	BYTE PTR [rsp+78], 118
	mov	BYTE PTR [rsp+79], 0
	mov	QWORD PTR [rdx], rcx
	mov	ecx, DWORD PTR [rsp+72]
	mov	DWORD PTR [rdx+8], ecx
	movzx	ecx, WORD PTR [rsp+76]
	mov	WORD PTR [rdx+12], cx
	movzx	ecx, BYTE PTR [rsp+78]
	mov	BYTE PTR [rdx+14], cl
	mov	rdx, QWORD PTR [rsp+56]
	mov	rcx, QWORD PTR [r14]
	mov	QWORD PTR [r14+8], rdx
	mov	BYTE PTR [rcx+rdx], 0
	mov	QWORD PTR [rsp+56], 0
	mov	rdx, QWORD PTR [rsp+48]
	mov	BYTE PTR [rdx], 0
	mov	rdi, QWORD PTR [rsp+48]
	cmp	rdi, rax
	je	.L109
	call	_ZdlPv
.L109:
	mov	rax, QWORD PTR [rsp]
	mov	QWORD PTR [rax], 1000
	mov	rax, QWORD PTR [rsp+8]
	mov	QWORD PTR [rax], 1000
	mov	QWORD PTR [r12], 1
	add	rsp, 88
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
.L90:
	.cfi_restore_state
	mov	edi, OFFSET FLAT:.LC8
	mov	ecx, 7
	mov	rsi, rdx
	repz cmpsb
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L93
	cmp	ebp, r9d
	jle	.L91
	mov	rdi, QWORD PTR [r15+8+r8]
	xor	esi, esi
	mov	edx, 10
	call	strtoull
	mov	rsi, QWORD PTR [rsp]
	add	ebx, 2
	mov	QWORD PTR [rsi], rax
.L92:
	cmp	ebp, ebx
	jg	.L87
	jmp	.L91
	.p2align 4,,10
	.p2align 3
.L93:
	mov	edi, OFFSET FLAT:.LC9
	mov	ecx, 6
	mov	rsi, rdx
	repz cmpsb
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L94
	cmp	ebp, r9d
	jle	.L91
	mov	rdi, QWORD PTR [r15+8+r8]
	xor	esi, esi
	mov	edx, 10
	call	strtoull
	mov	rsi, QWORD PTR [rsp+8]
	add	ebx, 2
	mov	QWORD PTR [rsi], rax
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L130:
	mov	rdi, QWORD PTR [r15+8+r8]
	mov	edx, 10
	xor	esi, esi
	call	strtoull
	mov	QWORD PTR [r12], rax
	add	ebx, 2
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L94:
	mov	edi, OFFSET FLAT:.LC10
	mov	ecx, 3
	mov	rsi, rdx
	repz cmpsb
	seta	al
	sbb	al, 0
	test	al, al
	jne	.L112
	cmp	ebp, r9d
	jle	.L91
	mov	rax, QWORD PTR [rsp+16]
	mov	rsi, QWORD PTR [r15+8+r8]
	mov	QWORD PTR [rsp+48], rax
	test	rsi, rsi
	je	.L95
	mov	rdi, rsi
	mov	QWORD PTR [rsp+32], rsi
	call	strlen
	cmp	rax, 15
	mov	rcx, rax
	mov	rsi, QWORD PTR [rsp+32]
	ja	.L132
	cmp	rax, 1
	jne	.L99
	movzx	eax, BYTE PTR [rsi]
	mov	BYTE PTR [rsp+64], al
	mov	rax, QWORD PTR [rsp+16]
.L100:
	mov	QWORD PTR [rsp+56], rcx
	mov	BYTE PTR [rax+rcx], 0
	mov	rax, QWORD PTR [rsp+48]
	mov	rdi, QWORD PTR [r14]
	cmp	rax, QWORD PTR [rsp+16]
	je	.L133
	mov	rdx, QWORD PTR [rsp+64]
	mov	rcx, QWORD PTR [rsp+56]
	cmp	QWORD PTR [rsp+24], rdi
	je	.L134
	mov	rsi, QWORD PTR [r14+16]
	mov	QWORD PTR [r14], rax
	mov	QWORD PTR [r14+8], rcx
	mov	QWORD PTR [r14+16], rdx
	test	rdi, rdi
	je	.L106
	mov	QWORD PTR [rsp+48], rdi
	mov	QWORD PTR [rsp+64], rsi
.L104:
	mov	QWORD PTR [rsp+56], 0
	mov	BYTE PTR [rdi], 0
	mov	rdi, QWORD PTR [rsp+48]
	cmp	rdi, QWORD PTR [rsp+16]
	je	.L107
	call	_ZdlPv
.L107:
	add	ebx, 2
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L112:
	mov	ebx, r9d
	jmp	.L92
	.p2align 4,,10
	.p2align 3
.L131:
	mov	rax, QWORD PTR [rsp+8]
	cmp	QWORD PTR [rax], 0
	je	.L88
	cmp	QWORD PTR [r12], 0
	je	.L88
	add	rsp, 88
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
.L99:
	.cfi_restore_state
	mov	rax, QWORD PTR [rsp+16]
	test	rcx, rcx
	je	.L100
	jmp	.L98
	.p2align 4,,10
	.p2align 3
.L132:
	lea	rdi, [rax+1]
	mov	QWORD PTR [rsp+40], rsi
	mov	QWORD PTR [rsp+32], rax
	call	_Znwm
	mov	rcx, QWORD PTR [rsp+32]
	mov	QWORD PTR [rsp+48], rax
	mov	QWORD PTR [rsp+64], rcx
	mov	rsi, QWORD PTR [rsp+40]
.L98:
	mov	rdx, rcx
	mov	rdi, rax
	mov	QWORD PTR [rsp+32], rcx
	call	memcpy
	mov	rax, QWORD PTR [rsp+48]
	mov	rcx, QWORD PTR [rsp+32]
	jmp	.L100
.L133:
	mov	rdx, QWORD PTR [rsp+56]
	test	rdx, rdx
	je	.L102
	cmp	rdx, 1
	je	.L135
	mov	rsi, QWORD PTR [rsp+16]
	call	memcpy
	mov	rdx, QWORD PTR [rsp+56]
	mov	rdi, QWORD PTR [r14]
.L102:
	mov	QWORD PTR [r14+8], rdx
	mov	BYTE PTR [rdi+rdx], 0
	mov	rdi, QWORD PTR [rsp+48]
	jmp	.L104
.L134:
	mov	QWORD PTR [r14], rax
	mov	QWORD PTR [r14+8], rcx
	mov	QWORD PTR [r14+16], rdx
.L106:
	mov	rax, QWORD PTR [rsp+16]
	mov	QWORD PTR [rsp+48], rax
	mov	rdi, rax
	jmp	.L104
.L135:
	movzx	eax, BYTE PTR [rsp+64]
	mov	BYTE PTR [rdi], al
	mov	rdx, QWORD PTR [rsp+56]
	mov	rdi, QWORD PTR [r14]
	jmp	.L102
.L95:
	mov	edi, OFFSET FLAT:.LC11
	call	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE8590:
	.size	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_, .-_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_
	.p2align 4,,15
	.globl	_Z14compare_forcesPPdS0_S0_S0_idPKc
	.type	_Z14compare_forcesPPdS0_S0_S0_idPKc, @function
_Z14compare_forcesPPdS0_S0_S0_idPKc:
.LFB8595:
	.cfi_startproc
	test	r8d, r8d
	jle	.L141
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	vmovapd	xmm3, xmm0
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rcx
	lea	ecx, [r8-1]
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13, rdx
	xor	edx, edx
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rsi
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	rbp, rdi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xor	ebx, ebx
	sub	rsp, 40
	.cfi_def_cfa_offset 96
	vmovq	xmm4, QWORD PTR .LC0[rip]
	jmp	.L140
	.p2align 4,,10
	.p2align 3
.L138:
	lea	rax, [rbx+1]
	cmp	rcx, rbx
	je	.L149
.L142:
	mov	rbx, rax
.L140:
	mov	rsi, QWORD PTR [rbp+0]
	mov	rax, QWORD PTR [rbp+8]
	vmovsd	xmm1, QWORD PTR [rsi+rbx*8]
	lea	r15, [0+rbx*8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp+16]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+0]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+8]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r13+16]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12+8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r12+16]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+8]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+16]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	vandpd	xmm1, xmm1, xmm4
	vcomisd	xmm1, xmm3
	jbe	.L138
	inc	edx
	cmp	edx, 9
	jg	.L138
	mov	edi, OFFSET FLAT:.LC2
	vmovsd	QWORD PTR [rsp+24], xmm3
	mov	DWORD PTR [rsp+20], edx
	mov	QWORD PTR [rsp+8], rcx
	call	puts
	mov	rsi, QWORD PTR [rbp+16]
	mov	rax, QWORD PTR [rbp+8]
	mov	rdi, QWORD PTR [rbp+0]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC3
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r13+16]
	mov	rax, QWORD PTR [r13+8]
	mov	rdi, QWORD PTR [r13+0]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC4
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r12+16]
	mov	rax, QWORD PTR [r12+8]
	mov	rdi, QWORD PTR [r12]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC5
	mov	eax, 3
	call	printf
	mov	rsi, QWORD PTR [r14+16]
	mov	rax, QWORD PTR [r14+8]
	mov	rdi, QWORD PTR [r14]
	vmovsd	xmm2, QWORD PTR [rsi+r15]
	vmovsd	xmm0, QWORD PTR [rdi+r15]
	vmovsd	xmm1, QWORD PTR [rax+r15]
	mov	esi, ebx
	mov	edi, OFFSET FLAT:.LC6
	mov	eax, 3
	call	printf
	mov	rcx, QWORD PTR [rsp+8]
	vmovsd	xmm3, QWORD PTR [rsp+24]
	vmovq	xmm4, QWORD PTR .LC0[rip]
	mov	edx, DWORD PTR [rsp+20]
	lea	rax, [rbx+1]
	cmp	rcx, rbx
	jne	.L142
.L149:
	add	rsp, 40
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
	mov	eax, edx
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L141:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	xor	edx, edx
	mov	eax, edx
	ret
	.cfi_endproc
.LFE8595:
	.size	_Z14compare_forcesPPdS0_S0_S0_idPKc, .-_Z14compare_forcesPPdS0_S0_S0_idPKc
	.section	.rodata.str1.1
.LC13:
	.string	"Default["
.LC14:
	.string	"default-reduced"
	.section	.rodata.str1.8
	.align 8
.LC18:
	.string	"x]     : Performance: %fMpairs/s\n"
	.text
	.p2align 4,,15
	.globl	_Z9nbody_refmPdPS_S0_S0_
	.type	_Z9nbody_refmPdPS_S0_S0_, @function
_Z9nbody_refmPdPS_S0_S0_:
.LFB8603:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	xor	eax, eax
	mov	r15, rcx
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rdx
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
	sub	rsp, 88
	.cfi_def_cfa_offset 144
	mov	QWORD PTR [rsp], rdi
	mov	edi, OFFSET FLAT:.LC13
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+16], r8
	call	printf
	mov	r9, QWORD PTR [rsp]
	lea	r13, [r9-1]
	imul	r13, r9
	mov	QWORD PTR [rsp+8], r9
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC14
	vmovsd	QWORD PTR [rsp], xmm0
	call	likwid_markerStartRegion
	mov	r9, QWORD PTR [rsp+8]
	test	r9, r9
	je	.L151
	cmp	r9, 1
	jbe	.L151
	vmovq	xmm6, QWORD PTR .LC16[rip]
	mov	r8, QWORD PTR [rsp+16]
	mov	rsi, QWORD PTR [rsp+24]
	xor	r12d, r12d
	mov	edx, 1
	vxorpd	xmm7, xmm7, xmm7
	.p2align 4,,10
	.p2align 3
.L152:
	sal	r12, 3
	lea	rcx, [rsi+r12]
	mov	rbx, rdx
	.p2align 4,,10
	.p2align 3
.L155:
	mov	rax, QWORD PTR [r14]
	lea	rbp, [0+rbx*8]
	vmovsd	xmm3, QWORD PTR [rax+r12]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+8]
	vmovsd	xmm2, QWORD PTR [rax+r12]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r14+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rax+r12]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm7, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L162
.L153:
	vmovsd	xmm0, QWORD PTR [rcx]
	vmulsd	xmm4, xmm5, xmm5
	vxorpd	xmm0, xmm0, xmm6
	vmulsd	xmm0, xmm0, QWORD PTR [rsi+rbx*8]
	mov	rax, QWORD PTR [r15]
	inc	rbx
	vmulsd	xmm4, xmm4, xmm5
	add	rax, r12
	vmulsd	xmm3, xmm3, xmm0
	vmulsd	xmm2, xmm2, xmm0
	vmulsd	xmm1, xmm1, xmm0
	vdivsd	xmm3, xmm3, xmm4
	vdivsd	xmm2, xmm2, xmm4
	vaddsd	xmm0, xmm3, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	mov	rax, QWORD PTR [r15+8]
	add	rax, r12
	vdivsd	xmm1, xmm1, xmm4
	vaddsd	xmm0, xmm2, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	mov	rax, QWORD PTR [r15+16]
	add	rax, r12
	vaddsd	xmm0, xmm1, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	mov	rax, QWORD PTR [r8]
	add	rax, rbp
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	mov	rax, QWORD PTR [r8+8]
	add	rax, rbp
	vmovsd	xmm0, QWORD PTR [rax]
	add	rbp, QWORD PTR [r8+16]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	vmovsd	xmm0, QWORD PTR [rbp+0]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rbp+0], xmm1
	cmp	r9, rbx
	ja	.L155
	lea	rax, [rdx+1]
	mov	r12, rdx
	cmp	r9, rax
	je	.L151
	mov	rdx, rax
	jmp	.L152
	.p2align 4,,10
	.p2align 3
.L151:
	mov	edi, OFFSET FLAT:.LC14
	call	likwid_markerStopRegion
	call	omp_get_wtime
	vsubsd	xmm1, xmm0, QWORD PTR [rsp]
	test	r13, r13
	js	.L156
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, r13
.L157:
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	mov	edi, OFFSET FLAT:.LC18
	mov	eax, 1
	vmovsd	QWORD PTR [rsp], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rsp]
	add	rsp, 88
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
	vmovapd	xmm0, xmm1
	pop	r15
	.cfi_def_cfa_offset 8
	ret
.L156:
	.cfi_restore_state
	mov	rax, r13
	shr	rax
	and	r13d, 1
	or	rax, r13
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L157
.L162:
	mov	QWORD PTR [rsp+72], r8
	mov	QWORD PTR [rsp+64], rsi
	mov	QWORD PTR [rsp+56], r9
	mov	QWORD PTR [rsp+48], rdx
	vmovsd	QWORD PTR [rsp+40], xmm5
	mov	QWORD PTR [rsp+32], rcx
	vmovsd	QWORD PTR [rsp+24], xmm1
	vmovsd	QWORD PTR [rsp+16], xmm2
	vmovsd	QWORD PTR [rsp+8], xmm3
	call	sqrt
	vmovq	xmm6, QWORD PTR .LC16[rip]
	vxorpd	xmm7, xmm7, xmm7
	mov	r8, QWORD PTR [rsp+72]
	mov	rsi, QWORD PTR [rsp+64]
	mov	r9, QWORD PTR [rsp+56]
	mov	rdx, QWORD PTR [rsp+48]
	vmovsd	xmm5, QWORD PTR [rsp+40]
	mov	rcx, QWORD PTR [rsp+32]
	vmovsd	xmm1, QWORD PTR [rsp+24]
	vmovsd	xmm2, QWORD PTR [rsp+16]
	vmovsd	xmm3, QWORD PTR [rsp+8]
	jmp	.L153
	.cfi_endproc
.LFE8603:
	.size	_Z9nbody_refmPdPS_S0_S0_, .-_Z9nbody_refmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC19:
	.string	"AVX2["
.LC20:
	.string	"vectorized-AVX2"
	.section	.rodata.str1.8
	.align 8
.LC21:
	.string	"x]        : Performance: %fMpairs/s\n"
	.align 8
.LC22:
	.string	"!]        : Force mismatches; %d\n"
	.text
	.p2align 4,,15
	.globl	_Z21nbody_vectorized_avx2mPdPS_S0_S0_
	.type	_Z21nbody_vectorized_avx2mPdPS_S0_S0_, @function
_Z21nbody_vectorized_avx2mPdPS_S0_S0_:
.LFB8604:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -32
	push	QWORD PTR [r10-8]
	xor	eax, eax
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rsi
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rbx, rdi
	mov	edi, OFFSET FLAT:.LC19
	sub	rsp, 224
	mov	QWORD PTR [rbp-144], rdx
	mov	QWORD PTR [rbp-184], rcx
	mov	QWORD PTR [rbp-192], r8
	call	printf
	mov	QWORD PTR [rbp-160], rbx
	sal	rbx, 3
	mov	rsi, rbx
	mov	edi, 64
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	mov	QWORD PTR [rbp-136], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-120], rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-160]
	mov	rsi, rax
	shr	rsi, 8
	mov	QWORD PTR [rbp-168], rsi
	test	rax, rax
	je	.L164
	mov	r8, QWORD PTR [rbp-136]
	xor	esi, esi
	mov	rdi, r8
	mov	rdx, rbx
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r12
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r14
	call	memset
	mov	rdi, QWORD PTR [rbp-120]
	xor	esi, esi
	mov	rdx, rbx
	call	memset
	mov	rcx, QWORD PTR [rbp-128]
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, rcx
	call	memset
	mov	r9, QWORD PTR [rbp-144]
	cmp	BYTE PTR [rbp-160], 0
	mov	QWORD PTR [rbp-120], r9
	je	.L165
	inc	QWORD PTR [rbp-168]
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC20
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	mov	r9, QWORD PTR [rbp-120]
.L166:
	vmovq	xmm6, QWORD PTR .LC16[rip]
	xor	eax, eax
	mov	r12, r9
	.p2align 4,,10
	.p2align 3
.L180:
	mov	rsi, rax
	sal	rsi, 8
	inc	rax
	mov	QWORD PTR [rbp-120], rsi
	mov	rsi, QWORD PTR [rbp-160]
	mov	QWORD PTR [rbp-152], rax
	sal	rax, 8
	cmp	rax, rsi
	cmova	rax, rsi
	xor	r11d, r11d
	mov	r8, rax
	lea	rax, [0+rax*8]
	mov	QWORD PTR [rbp-128], rax
	mov	r9, r11
	.p2align 4,,10
	.p2align 3
.L176:
	mov	rax, QWORD PTR [rbp-120]
	lea	r13, [0+r9*8]
	vmovsd	xmm5, QWORD PTR [r15+r9*8]
	inc	r9
	cmp	rax, r9
	mov	rbx, rax
	cmovb	rbx, r9
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rdi, rbx
	vxorpd	xmm5, xmm5, xmm6
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	and	edi, 3
	jne	.L201
.L168:
	vbroadcastsd	ymm14, QWORD PTR [rsi]
	lea	rsi, [rbx+3]
	vbroadcastsd	ymm12, QWORD PTR [r11]
	vbroadcastsd	ymm13, QWORD PTR [r10]
	vbroadcastsd	ymm15, xmm5
	cmp	r8, rsi
	jbe	.L185
	vxorpd	xmm8, xmm8, xmm8
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L173
	.p2align 4,,10
	.p2align 3
.L202:
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rbx, rsi
.L173:
	vsubpd	ymm3, ymm13, YMMWORD PTR [rdx+rbx*8]
	vsubpd	ymm4, ymm12, YMMWORD PTR [rax+rbx*8]
	vsubpd	ymm2, ymm14, YMMWORD PTR [rcx+rbx*8]
	vmulpd	ymm0, ymm3, ymm3
	vmulpd	ymm1, ymm15, YMMWORD PTR [r15+rbx*8]
	mov	rax, QWORD PTR [rbp-80]
	mov	rdx, QWORD PTR [rbp-72]
	lea	rax, [rax+rbx*8]
	vfmadd231pd	ymm0, ymm4, ymm4
	lea	rsi, [rbx+4]
	vfmadd231pd	ymm0, ymm2, ymm2
	vsqrtpd	ymm0, ymm0
	vmulpd	ymm7, ymm0, ymm0
	vmulpd	ymm0, ymm7, ymm0
	vdivpd	ymm0, ymm1, ymm0
	vmovapd	ymm11, ymm0
	vfnmadd213pd	ymm11, ymm4, YMMWORD PTR [rax]
	vmovapd	ymm7, ymm0
	vfnmadd213pd	ymm7, ymm3, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [rbp-64]
	vmovapd	ymm1, ymm0
	vfnmadd213pd	ymm1, ymm2, YMMWORD PTR [rdx+rbx*8]
	vmovapd	YMMWORD PTR [rax], ymm11
	mov	rax, QWORD PTR [rbp-72]
	vfmadd231pd	ymm10, ymm0, ymm4
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm7
	mov	rax, QWORD PTR [rbp-64]
	vfmadd231pd	ymm9, ymm0, ymm3
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm1
	add	rbx, 7
	vfmadd231pd	ymm8, ymm0, ymm2
	cmp	r8, rbx
	ja	.L202
.L172:
	vmovapd	xmm2, xmm10
	vextractf64x2	xmm10, ymm10, 0x1
	vaddpd	xmm10, xmm10, xmm2
	vmovapd	xmm1, xmm9
	vextractf64x2	xmm9, ymm9, 0x1
	vunpckhpd	xmm2, xmm10, xmm10
	mov	rdi, QWORD PTR [rbp-112]
	vaddpd	xmm9, xmm9, xmm1
	vaddsd	xmm10, xmm10, xmm2
	add	rdi, r13
	vmovapd	xmm0, xmm8
	vaddsd	xmm10, xmm10, QWORD PTR [rdi]
	vextractf64x2	xmm8, ymm8, 0x1
	vunpckhpd	xmm1, xmm9, xmm9
	mov	rcx, QWORD PTR [rbp-104]
	vaddpd	xmm8, xmm8, xmm0
	vaddsd	xmm9, xmm9, xmm1
	vmovsd	QWORD PTR [rdi], xmm10
	add	rcx, r13
	vaddsd	xmm9, xmm9, QWORD PTR [rcx]
	vunpckhpd	xmm0, xmm8, xmm8
	mov	rdx, QWORD PTR [rbp-96]
	vaddsd	xmm8, xmm8, xmm0
	vmovsd	QWORD PTR [rcx], xmm9
	add	rdx, r13
	vaddsd	xmm8, xmm8, QWORD PTR [rdx]
	lea	rbx, [0+rsi*8]
	mov	r14, QWORD PTR [rbp-128]
	vmovsd	QWORD PTR [rdx], xmm8
	vxorpd	xmm8, xmm8, xmm8
	cmp	r8, rsi
	jbe	.L178
	.p2align 4,,10
	.p2align 3
.L179:
	mov	rax, QWORD PTR [r12]
	vmovsd	xmm3, QWORD PTR [rax+r13]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+8]
	vmovsd	xmm2, QWORD PTR [rax+r13]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rax+r13]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm7, xmm7, xmm0
	ja	.L203
.L177:
	vmulsd	xmm4, xmm5, QWORD PTR [r15+rbx]
	vmulsd	xmm0, xmm7, xmm7
	mov	rax, QWORD PTR [rbp-80]
	add	rax, rbx
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm7
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	mov	rax, QWORD PTR [rbp-72]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	mov	rax, QWORD PTR [rbp-64]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	add	rbx, 8
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	r14, rbx
	jne	.L179
.L178:
	cmp	r8, r9
	jne	.L176
	mov	rax, QWORD PTR [rbp-152]
	cmp	rax, QWORD PTR [rbp-168]
	jb	.L180
	vzeroupper
.L167:
	mov	edi, OFFSET FLAT:.LC20
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-160]
	mov	rcx, QWORD PTR [rbp-192]
	mov	rdx, QWORD PTR [rbp-184]
	mov	r8d, ebx
	lea	rsi, [rbp-80]
	lea	rdi, [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm0
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L181
	lea	rdx, [rbx-1]
	imul	rdx, rbx
	test	rdx, rdx
	js	.L182
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L183:
	vmovsd	xmm16, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC21
	vsubsd	xmm1, xmm16, QWORD PTR [rbp-176]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-120], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-120]
	jmp	.L184
	.p2align 4,,10
	.p2align 3
.L201:
	mov	r14d, 4
	sub	r14, rdi
	mov	rdi, r14
	cmp	r8, rbx
	jbe	.L168
	mov	QWORD PTR [rbp-144], r9
	xor	r14d, r14d
	vxorpd	xmm8, xmm8, xmm8
	mov	r9, rdi
	mov	QWORD PTR [rbp-136], r12
	jmp	.L170
	.p2align 4,,10
	.p2align 3
.L205:
	cmp	r14, r9
	jnb	.L197
.L170:
	vmovsd	xmm2, QWORD PTR [r10]
	vmovsd	xmm3, QWORD PTR [r11]
	vsubsd	xmm2, xmm2, QWORD PTR [rdx+rbx*8]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx*8]
	vmovsd	xmm1, QWORD PTR [rsi]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	lea	r12, [0+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm7, xmm7, xmm0
	ja	.L204
.L169:
	vmulsd	xmm4, xmm5, QWORD PTR [r15+rbx*8]
	vmulsd	xmm0, xmm7, xmm7
	mov	rdi, QWORD PTR [rbp-112]
	inc	rbx
	add	rdi, r13
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm7
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	inc	r14
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-104]
	add	rdi, r13
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-96]
	add	rdi, r13
	vaddsd	xmm0, xmm1, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-80]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-72]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	add	r12, QWORD PTR [rbp-64]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	vmovsd	xmm0, QWORD PTR [r12]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12], xmm1
	cmp	r8, rbx
	ja	.L205
.L197:
	mov	r9, QWORD PTR [rbp-144]
	mov	r12, QWORD PTR [rbp-136]
	jmp	.L168
	.p2align 4,,10
	.p2align 3
.L185:
	vxorpd	xmm8, xmm8, xmm8
	mov	rsi, rbx
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L172
.L181:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC22
	xor	eax, eax
	call	printf
	vmovsd	xmm18, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm18, QWORD PTR [rbp-176]
.L184:
	mov	rdi, QWORD PTR [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-120]
	add	rsp, 224
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L182:
	.cfi_restore_state
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L183
.L203:
	mov	QWORD PTR [rbp-240], r9
	mov	QWORD PTR [rbp-232], r8
	vmovsd	QWORD PTR [rbp-224], xmm8
	vmovsd	QWORD PTR [rbp-216], xmm7
	vmovsd	QWORD PTR [rbp-208], xmm5
	vmovsd	QWORD PTR [rbp-200], xmm1
	vmovsd	QWORD PTR [rbp-144], xmm2
	vmovsd	QWORD PTR [rbp-136], xmm3
	vzeroupper
	call	sqrt
	mov	rdi, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	mov	rdx, QWORD PTR [rbp-96]
	add	rdi, r13
	add	rcx, r13
	add	rdx, r13
	mov	r9, QWORD PTR [rbp-240]
	mov	r8, QWORD PTR [rbp-232]
	vmovq	xmm6, QWORD PTR .LC16[rip]
	vmovsd	xmm8, QWORD PTR [rbp-224]
	vmovsd	xmm7, QWORD PTR [rbp-216]
	vmovsd	xmm5, QWORD PTR [rbp-208]
	vmovsd	xmm1, QWORD PTR [rbp-200]
	vmovsd	xmm2, QWORD PTR [rbp-144]
	vmovsd	xmm3, QWORD PTR [rbp-136]
	jmp	.L177
.L165:
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC20
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-168], 0
	mov	r9, QWORD PTR [rbp-120]
	jne	.L166
	jmp	.L167
	.p2align 4,,10
	.p2align 3
.L164:
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC20
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	jmp	.L167
.L204:
	mov	QWORD PTR [rbp-256], r9
	mov	QWORD PTR [rbp-248], r8
	vmovsd	QWORD PTR [rbp-240], xmm8
	vmovsd	QWORD PTR [rbp-232], xmm7
	vmovsd	QWORD PTR [rbp-224], xmm5
	vmovsd	QWORD PTR [rbp-216], xmm1
	vmovsd	QWORD PTR [rbp-208], xmm2
	vmovsd	QWORD PTR [rbp-200], xmm3
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-136]
	mov	r9, QWORD PTR [rbp-256]
	mov	rax, QWORD PTR [rsi]
	mov	rdx, QWORD PTR [rsi+8]
	mov	rcx, QWORD PTR [rsi+16]
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	mov	r8, QWORD PTR [rbp-248]
	vmovq	xmm6, QWORD PTR .LC16[rip]
	vmovsd	xmm8, QWORD PTR [rbp-240]
	vmovsd	xmm7, QWORD PTR [rbp-232]
	vmovsd	xmm5, QWORD PTR [rbp-224]
	vmovsd	xmm1, QWORD PTR [rbp-216]
	vmovsd	xmm2, QWORD PTR [rbp-208]
	vmovsd	xmm3, QWORD PTR [rbp-200]
	jmp	.L169
	.cfi_endproc
.LFE8604:
	.size	_Z21nbody_vectorized_avx2mPdPS_S0_S0_, .-_Z21nbody_vectorized_avx2mPdPS_S0_S0_
	.section	.rodata.str1.1
.LC23:
	.string	"AVX2-rsqrt["
.LC24:
	.string	"vectorized-AVX2-rsqrt"
	.section	.rodata.str1.8
	.align 8
.LC27:
	.string	"x]  : Performance: %fMpairs/s\n"
	.section	.rodata.str1.1
.LC28:
	.string	"!]  : Force mismatches; %d\n"
	.text
	.p2align 4,,15
	.globl	_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_
	.type	_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_, @function
_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_:
.LFB8606:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -32
	push	QWORD PTR [r10-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rsi
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	lea	rbx, [0+rdi*8]
	mov	rsi, rbx
	sub	rsp, 224
	mov	QWORD PTR [rbp-160], rdi
	mov	edi, 64
	mov	QWORD PTR [rbp-144], rdx
	mov	QWORD PTR [rbp-184], rcx
	mov	QWORD PTR [rbp-192], r8
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	mov	QWORD PTR [rbp-136], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-120], rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-160]
	mov	rsi, rax
	shr	rsi, 8
	mov	QWORD PTR [rbp-168], rsi
	test	rax, rax
	je	.L207
	mov	r8, QWORD PTR [rbp-136]
	xor	esi, esi
	mov	rdi, r8
	mov	rdx, rbx
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r12
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r14
	call	memset
	mov	rdi, QWORD PTR [rbp-120]
	xor	esi, esi
	mov	rdx, rbx
	call	memset
	mov	rcx, QWORD PTR [rbp-128]
	xor	esi, esi
	mov	rdi, rcx
	mov	rdx, rbx
	call	memset
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC23
	call	printf
	mov	r9, QWORD PTR [rbp-144]
	cmp	BYTE PTR [rbp-160], 0
	mov	QWORD PTR [rbp-120], r9
	je	.L208
	inc	QWORD PTR [rbp-168]
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC24
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	mov	r9, QWORD PTR [rbp-120]
.L209:
	vmovq	xmm8, QWORD PTR .LC16[rip]
	vmovapd	ymm5, YMMWORD PTR .LC25[rip]
	vmovapd	ymm4, YMMWORD PTR .LC26[rip]
	xor	eax, eax
	mov	r12, r9
	.p2align 4,,10
	.p2align 3
.L223:
	mov	rsi, rax
	sal	rsi, 8
	inc	rax
	mov	QWORD PTR [rbp-120], rsi
	mov	rsi, QWORD PTR [rbp-160]
	mov	QWORD PTR [rbp-152], rax
	sal	rax, 8
	cmp	rax, rsi
	cmova	rax, rsi
	xor	r11d, r11d
	mov	r8, rax
	lea	rax, [0+rax*8]
	mov	QWORD PTR [rbp-128], rax
	vxorpd	xmm7, xmm7, xmm7
	mov	r9, r11
	.p2align 4,,10
	.p2align 3
.L219:
	mov	rax, QWORD PTR [rbp-120]
	lea	r13, [0+r9*8]
	vmovsd	xmm6, QWORD PTR [r15+r9*8]
	inc	r9
	cmp	rax, r9
	mov	rbx, rax
	cmovb	rbx, r9
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rdi, rbx
	vxorpd	xmm6, xmm6, xmm8
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	and	edi, 3
	jne	.L244
.L211:
	vbroadcastsd	ymm16, QWORD PTR [rsi]
	lea	rsi, [rbx+3]
	vbroadcastsd	ymm14, QWORD PTR [r11]
	vbroadcastsd	ymm15, QWORD PTR [r10]
	vbroadcastsd	ymm17, xmm6
	cmp	r8, rsi
	jbe	.L228
	vxorpd	xmm11, xmm11, xmm11
	vmovapd	ymm12, ymm11
	vmovapd	ymm13, ymm11
	jmp	.L216
	.p2align 4,,10
	.p2align 3
.L245:
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rbx, rsi
.L216:
	vsubpd	ymm9, ymm15, YMMWORD PTR [rdx+rbx*8]
	vsubpd	ymm10, ymm14, YMMWORD PTR [rax+rbx*8]
	vsubpd	ymm3, ymm16, YMMWORD PTR [rcx+rbx*8]
	vmulpd	ymm0, ymm9, ymm9
	mov	rax, QWORD PTR [rbp-80]
	mov	rdx, QWORD PTR [rbp-72]
	lea	rax, [rax+rbx*8]
	lea	rsi, [rbx+4]
	vfmadd231pd	ymm0, ymm10, ymm10
	vmovapd	ymm2, ymm0
	vfmadd231pd	ymm2, ymm3, ymm3
	vrsqrt14pd	ymm0, ymm2
	vmulpd	ymm1, ymm0, ymm0
	vmulpd	ymm0, ymm0, ymm4
	vfnmadd132pd	ymm1, ymm5, ymm2
	vmulpd	ymm1, ymm1, ymm0
	vmulpd	ymm0, ymm1, ymm1
	vmulpd	ymm1, ymm1, ymm4
	vfnmadd132pd	ymm0, ymm5, ymm2
	vmulpd	ymm1, ymm0, ymm1
	vmulpd	ymm0, ymm1, ymm1
	vmulpd	ymm0, ymm0, ymm1
	vmulpd	ymm1, ymm17, YMMWORD PTR [r15+rbx*8]
	vmulpd	ymm0, ymm0, ymm1
	vmovapd	ymm18, ymm0
	vfnmadd213pd	ymm18, ymm10, YMMWORD PTR [rax]
	vmovapd	ymm2, ymm0
	vfnmadd213pd	ymm2, ymm9, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [rbp-64]
	vmovapd	ymm1, ymm0
	vfnmadd213pd	ymm1, ymm3, YMMWORD PTR [rdx+rbx*8]
	vmovapd	YMMWORD PTR [rax], ymm18
	mov	rax, QWORD PTR [rbp-72]
	vfmadd231pd	ymm13, ymm0, ymm10
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm2
	mov	rax, QWORD PTR [rbp-64]
	vfmadd231pd	ymm12, ymm0, ymm9
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm1
	add	rbx, 7
	vfmadd231pd	ymm11, ymm0, ymm3
	cmp	r8, rbx
	ja	.L245
.L215:
	vmovapd	xmm2, xmm13
	vextractf64x2	xmm13, ymm13, 0x1
	vaddpd	xmm13, xmm13, xmm2
	vmovapd	xmm1, xmm12
	vextractf64x2	xmm12, ymm12, 0x1
	vunpckhpd	xmm2, xmm13, xmm13
	mov	rdi, QWORD PTR [rbp-112]
	vaddpd	xmm12, xmm12, xmm1
	vaddsd	xmm13, xmm13, xmm2
	add	rdi, r13
	vmovapd	xmm0, xmm11
	vaddsd	xmm13, xmm13, QWORD PTR [rdi]
	vextractf64x2	xmm11, ymm11, 0x1
	vunpckhpd	xmm1, xmm12, xmm12
	mov	rcx, QWORD PTR [rbp-104]
	vaddpd	xmm11, xmm11, xmm0
	vaddsd	xmm12, xmm12, xmm1
	vmovsd	QWORD PTR [rdi], xmm13
	add	rcx, r13
	vaddsd	xmm12, xmm12, QWORD PTR [rcx]
	vunpckhpd	xmm0, xmm11, xmm11
	mov	rdx, QWORD PTR [rbp-96]
	vaddsd	xmm11, xmm11, xmm0
	vmovsd	QWORD PTR [rcx], xmm12
	add	rdx, r13
	vaddsd	xmm11, xmm11, QWORD PTR [rdx]
	lea	rbx, [0+rsi*8]
	mov	r14, QWORD PTR [rbp-128]
	vmovsd	QWORD PTR [rdx], xmm11
	vxorpd	xmm11, xmm11, xmm11
	cmp	r8, rsi
	jbe	.L221
	.p2align 4,,10
	.p2align 3
.L222:
	mov	rax, QWORD PTR [r12]
	vmovsd	xmm3, QWORD PTR [rax+r13]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+8]
	vmovsd	xmm2, QWORD PTR [rax+r13]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rax+r13]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm11, xmm0
	vsqrtsd	xmm10, xmm10, xmm0
	ja	.L246
.L220:
	vmulsd	xmm9, xmm6, QWORD PTR [r15+rbx]
	vmulsd	xmm0, xmm10, xmm10
	mov	rax, QWORD PTR [rbp-80]
	add	rax, rbx
	vmulsd	xmm3, xmm3, xmm9
	vmulsd	xmm0, xmm0, xmm10
	vmulsd	xmm2, xmm2, xmm9
	vmulsd	xmm1, xmm1, xmm9
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	mov	rax, QWORD PTR [rbp-72]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	mov	rax, QWORD PTR [rbp-64]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	add	rbx, 8
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	r14, rbx
	jne	.L222
.L221:
	cmp	r8, r9
	jne	.L219
	mov	rax, QWORD PTR [rbp-152]
	cmp	rax, QWORD PTR [rbp-168]
	jb	.L223
	vzeroupper
.L210:
	mov	edi, OFFSET FLAT:.LC24
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-160]
	mov	rcx, QWORD PTR [rbp-192]
	mov	rdx, QWORD PTR [rbp-184]
	mov	r8d, ebx
	lea	rsi, [rbp-80]
	lea	rdi, [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm0
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L224
	lea	rdx, [rbx-1]
	imul	rdx, rbx
	test	rdx, rdx
	js	.L225
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L226:
	vmovsd	xmm19, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC27
	vsubsd	xmm1, xmm19, QWORD PTR [rbp-176]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-120], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-120]
	jmp	.L227
	.p2align 4,,10
	.p2align 3
.L244:
	mov	r14d, 4
	sub	r14, rdi
	mov	rdi, r14
	cmp	r8, rbx
	jbe	.L211
	mov	QWORD PTR [rbp-144], r9
	xor	r14d, r14d
	mov	r9, rdi
	mov	QWORD PTR [rbp-136], r12
	jmp	.L213
	.p2align 4,,10
	.p2align 3
.L248:
	cmp	r14, r9
	jnb	.L240
.L213:
	vmovsd	xmm2, QWORD PTR [r10]
	vmovsd	xmm3, QWORD PTR [r11]
	vsubsd	xmm2, xmm2, QWORD PTR [rdx+rbx*8]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx*8]
	vmovsd	xmm1, QWORD PTR [rsi]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	lea	r12, [0+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm7, xmm0
	vsqrtsd	xmm10, xmm10, xmm0
	ja	.L247
.L212:
	vmulsd	xmm9, xmm6, QWORD PTR [r15+rbx*8]
	vmulsd	xmm0, xmm10, xmm10
	mov	rdi, QWORD PTR [rbp-112]
	inc	rbx
	add	rdi, r13
	vmulsd	xmm3, xmm3, xmm9
	vmulsd	xmm0, xmm0, xmm10
	vmulsd	xmm2, xmm2, xmm9
	vmulsd	xmm1, xmm1, xmm9
	inc	r14
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-104]
	add	rdi, r13
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-96]
	add	rdi, r13
	vaddsd	xmm0, xmm1, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-80]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-72]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	add	r12, QWORD PTR [rbp-64]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	vmovsd	xmm0, QWORD PTR [r12]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12], xmm1
	cmp	r8, rbx
	ja	.L248
.L240:
	mov	r9, QWORD PTR [rbp-144]
	mov	r12, QWORD PTR [rbp-136]
	jmp	.L211
	.p2align 4,,10
	.p2align 3
.L228:
	vxorpd	xmm11, xmm11, xmm11
	mov	rsi, rbx
	vmovapd	ymm12, ymm11
	vmovapd	ymm13, ymm11
	jmp	.L215
.L224:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC28
	xor	eax, eax
	call	printf
	vmovsd	xmm21, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm21, QWORD PTR [rbp-176]
.L227:
	mov	rdi, QWORD PTR [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-120]
	add	rsp, 224
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L225:
	.cfi_restore_state
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L226
.L246:
	mov	QWORD PTR [rbp-232], r9
	mov	QWORD PTR [rbp-224], r8
	vmovsd	QWORD PTR [rbp-216], xmm10
	vmovsd	QWORD PTR [rbp-208], xmm6
	vmovsd	QWORD PTR [rbp-200], xmm1
	vmovsd	QWORD PTR [rbp-144], xmm2
	vmovsd	QWORD PTR [rbp-136], xmm3
	vzeroupper
	call	sqrt
	mov	rdi, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	mov	rdx, QWORD PTR [rbp-96]
	vxorpd	xmm7, xmm7, xmm7
	add	rdi, r13
	add	rcx, r13
	add	rdx, r13
	mov	r9, QWORD PTR [rbp-232]
	mov	r8, QWORD PTR [rbp-224]
	vmovapd	ymm4, YMMWORD PTR .LC26[rip]
	vmovapd	ymm5, YMMWORD PTR .LC25[rip]
	vmovq	xmm8, QWORD PTR .LC16[rip]
	vmovapd	xmm11, xmm7
	vmovsd	xmm10, QWORD PTR [rbp-216]
	vmovsd	xmm6, QWORD PTR [rbp-208]
	vmovsd	xmm1, QWORD PTR [rbp-200]
	vmovsd	xmm2, QWORD PTR [rbp-144]
	vmovsd	xmm3, QWORD PTR [rbp-136]
	jmp	.L220
.L208:
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC24
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-168], 0
	mov	r9, QWORD PTR [rbp-120]
	jne	.L209
	jmp	.L210
	.p2align 4,,10
	.p2align 3
.L207:
	mov	edi, OFFSET FLAT:.LC23
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC24
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	jmp	.L210
.L247:
	mov	QWORD PTR [rbp-248], r9
	mov	QWORD PTR [rbp-240], r8
	vmovsd	QWORD PTR [rbp-232], xmm10
	vmovsd	QWORD PTR [rbp-224], xmm6
	vmovsd	QWORD PTR [rbp-216], xmm1
	vmovsd	QWORD PTR [rbp-208], xmm2
	vmovsd	QWORD PTR [rbp-200], xmm3
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-136]
	mov	r9, QWORD PTR [rbp-248]
	mov	rax, QWORD PTR [rsi]
	mov	rdx, QWORD PTR [rsi+8]
	mov	rcx, QWORD PTR [rsi+16]
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	mov	r8, QWORD PTR [rbp-240]
	vmovapd	ymm4, YMMWORD PTR .LC26[rip]
	vmovapd	ymm5, YMMWORD PTR .LC25[rip]
	vxorpd	xmm7, xmm7, xmm7
	vmovq	xmm8, QWORD PTR .LC16[rip]
	vmovsd	xmm10, QWORD PTR [rbp-232]
	vmovsd	xmm6, QWORD PTR [rbp-224]
	vmovsd	xmm1, QWORD PTR [rbp-216]
	vmovsd	xmm2, QWORD PTR [rbp-208]
	vmovsd	xmm3, QWORD PTR [rbp-200]
	jmp	.L212
	.cfi_endproc
.LFE8606:
	.size	_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_, .-_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC29:
	.string	"AVX512["
.LC30:
	.string	"vectorized-AVX512"
	.section	.rodata.str1.8
	.align 8
.LC31:
	.string	"x]      : Performance: %fMpairs/s\n"
	.align 8
.LC32:
	.string	"!]      : Force mismatches; %d\n"
	.text
	.p2align 4,,15
	.globl	_Z23nbody_vectorized_avx512mPdPS_S0_S0_
	.type	_Z23nbody_vectorized_avx512mPdPS_S0_S0_, @function
_Z23nbody_vectorized_avx512mPdPS_S0_S0_:
.LFB8607:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -64
	push	QWORD PTR [r10-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rsi
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	lea	rbx, [0+rdi*8]
	mov	rsi, rbx
	sub	rsp, 256
	mov	QWORD PTR [rbp-160], rdi
	mov	edi, 64
	mov	QWORD PTR [rbp-144], rdx
	mov	QWORD PTR [rbp-184], rcx
	mov	QWORD PTR [rbp-192], r8
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	mov	QWORD PTR [rbp-136], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-120], rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-160]
	mov	rsi, rax
	shr	rsi, 8
	mov	QWORD PTR [rbp-168], rsi
	test	rax, rax
	je	.L250
	mov	r8, QWORD PTR [rbp-136]
	xor	esi, esi
	mov	rdi, r8
	mov	rdx, rbx
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r12
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r14
	call	memset
	mov	rdi, QWORD PTR [rbp-120]
	xor	esi, esi
	mov	rdx, rbx
	call	memset
	mov	rcx, QWORD PTR [rbp-128]
	xor	esi, esi
	mov	rdi, rcx
	mov	rdx, rbx
	call	memset
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC29
	call	printf
	mov	r9, QWORD PTR [rbp-144]
	cmp	BYTE PTR [rbp-160], 0
	mov	QWORD PTR [rbp-120], r9
	je	.L251
	inc	QWORD PTR [rbp-168]
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC30
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	mov	r9, QWORD PTR [rbp-120]
.L252:
	vmovq	xmm6, QWORD PTR .LC16[rip]
	xor	eax, eax
	mov	r12, r9
	.p2align 4,,10
	.p2align 3
.L266:
	mov	rsi, rax
	sal	rsi, 8
	inc	rax
	mov	QWORD PTR [rbp-120], rsi
	mov	rsi, QWORD PTR [rbp-160]
	mov	QWORD PTR [rbp-152], rax
	sal	rax, 8
	cmp	rax, rsi
	cmova	rax, rsi
	xor	r11d, r11d
	mov	r8, rax
	lea	rax, [0+rax*8]
	mov	QWORD PTR [rbp-128], rax
	mov	r9, r11
	.p2align 4,,10
	.p2align 3
.L262:
	mov	rax, QWORD PTR [rbp-120]
	lea	r13, [0+r9*8]
	vmovsd	xmm5, QWORD PTR [r15+r9*8]
	inc	r9
	cmp	rax, r9
	mov	rbx, rax
	cmovb	rbx, r9
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rdi, rbx
	vxorpd	xmm5, xmm5, xmm6
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	and	edi, 7
	jne	.L287
.L254:
	vxorpd	xmm10, xmm10, xmm10
	vbroadcastsd	zmm13, QWORD PTR [rsi]
	lea	rsi, [rbx+7]
	vmovapd	zmm9, zmm10
	vmovapd	zmm8, zmm10
	vbroadcastsd	zmm15, QWORD PTR [r11]
	vbroadcastsd	zmm14, QWORD PTR [r10]
	vbroadcastsd	zmm12, xmm5
	cmp	r8, rsi
	ja	.L259
	jmp	.L271
	.p2align 4,,10
	.p2align 3
.L288:
	mov	rax, QWORD PTR [r12]
	mov	rdx, QWORD PTR [r12+8]
	mov	rcx, QWORD PTR [r12+16]
	mov	rbx, rsi
.L259:
	vsubpd	zmm3, zmm14, ZMMWORD PTR [rdx+rbx*8]
	vsubpd	zmm4, zmm15, ZMMWORD PTR [rax+rbx*8]
	vsubpd	zmm2, zmm13, ZMMWORD PTR [rcx+rbx*8]
	vmulpd	zmm0, zmm3, zmm3
	vmulpd	zmm1, zmm12, ZMMWORD PTR [r15+rbx*8]
	mov	rax, QWORD PTR [rbp-80]
	vmovapd	zmm11, zmm4
	lea	rax, [rax+rbx*8]
	vfmadd231pd	zmm0, zmm4, zmm4
	mov	rdx, QWORD PTR [rbp-72]
	lea	rsi, [rbx+8]
	vfmadd231pd	zmm0, zmm2, zmm2
	vsqrtpd	zmm0, zmm0
	vmulpd	zmm7, zmm0, zmm0
	vmulpd	zmm0, zmm7, zmm0
	vmovapd	zmm7, zmm3
	vdivpd	zmm0, zmm1, zmm0
	vfnmadd213pd	zmm11, zmm0, ZMMWORD PTR [rax]
	vfnmadd213pd	zmm7, zmm0, ZMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [rbp-64]
	vmovapd	zmm1, zmm2
	vfnmadd213pd	zmm1, zmm0, ZMMWORD PTR [rdx+rbx*8]
	vmovapd	ZMMWORD PTR [rax], zmm11
	mov	rax, QWORD PTR [rbp-72]
	vfmadd231pd	zmm10, zmm4, zmm0
	vmovapd	ZMMWORD PTR [rax+rbx*8], zmm7
	mov	rax, QWORD PTR [rbp-64]
	vfmadd231pd	zmm9, zmm3, zmm0
	vmovapd	ZMMWORD PTR [rax+rbx*8], zmm1
	add	rbx, 15
	vfmadd231pd	zmm8, zmm2, zmm0
	cmp	r8, rbx
	ja	.L288
.L258:
	vextractf64x4	ymm0, zmm10, 0x1
	vaddpd	ymm10, ymm0, ymm10
	mov	rdi, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	vextractf64x2	xmm0, ymm10, 0x1
	vaddpd	xmm10, xmm0, xmm10
	vextractf64x4	ymm0, zmm9, 0x1
	vaddpd	ymm9, ymm0, ymm9
	vhaddpd	xmm10, xmm10, xmm10
	add	rdi, r13
	vextractf64x2	xmm0, ymm9, 0x1
	vaddpd	xmm9, xmm0, xmm9
	vextractf64x4	ymm0, zmm8, 0x1
	vaddpd	ymm8, ymm0, ymm8
	vaddsd	xmm10, xmm10, QWORD PTR [rdi]
	vhaddpd	xmm9, xmm9, xmm9
	vextractf64x2	xmm0, ymm8, 0x1
	vaddpd	xmm8, xmm0, xmm8
	vmovsd	QWORD PTR [rdi], xmm10
	add	rcx, r13
	vaddsd	xmm9, xmm9, QWORD PTR [rcx]
	mov	rdx, QWORD PTR [rbp-96]
	vhaddpd	xmm8, xmm8, xmm8
	vmovsd	QWORD PTR [rcx], xmm9
	add	rdx, r13
	vaddsd	xmm8, xmm8, QWORD PTR [rdx]
	lea	rbx, [0+rsi*8]
	mov	r14, QWORD PTR [rbp-128]
	vmovsd	QWORD PTR [rdx], xmm8
	vxorpd	xmm8, xmm8, xmm8
	cmp	r8, rsi
	jbe	.L264
	.p2align 4,,10
	.p2align 3
.L265:
	mov	rax, QWORD PTR [r12]
	vmovsd	xmm3, QWORD PTR [rax+r13]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+8]
	vmovsd	xmm2, QWORD PTR [rax+r13]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r12+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rax+r13]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm7, xmm7, xmm0
	ja	.L289
.L263:
	vmulsd	xmm4, xmm5, QWORD PTR [r15+rbx]
	vmulsd	xmm0, xmm7, xmm7
	mov	rax, QWORD PTR [rbp-80]
	add	rax, rbx
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm7
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	mov	rax, QWORD PTR [rbp-72]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	mov	rax, QWORD PTR [rbp-64]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	add	rbx, 8
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	r14, rbx
	jne	.L265
.L264:
	cmp	r8, r9
	jne	.L262
	mov	rax, QWORD PTR [rbp-152]
	cmp	rax, QWORD PTR [rbp-168]
	jb	.L266
	vzeroupper
.L253:
	mov	edi, OFFSET FLAT:.LC30
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-160]
	mov	rcx, QWORD PTR [rbp-192]
	mov	rdx, QWORD PTR [rbp-184]
	mov	r8d, ebx
	lea	rsi, [rbp-80]
	lea	rdi, [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm0
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L267
	lea	rdx, [rbx-1]
	imul	rdx, rbx
	test	rdx, rdx
	js	.L268
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L269:
	vmovsd	xmm16, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC31
	vsubsd	xmm1, xmm16, QWORD PTR [rbp-176]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-120], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-120]
	jmp	.L270
	.p2align 4,,10
	.p2align 3
.L287:
	mov	r14d, 8
	sub	r14, rdi
	mov	rdi, r14
	cmp	r8, rbx
	jbe	.L254
	mov	QWORD PTR [rbp-144], r9
	xor	r14d, r14d
	vxorpd	xmm8, xmm8, xmm8
	mov	r9, rdi
	mov	QWORD PTR [rbp-136], r12
	jmp	.L256
	.p2align 4,,10
	.p2align 3
.L291:
	cmp	r14, r9
	jnb	.L283
.L256:
	vmovsd	xmm2, QWORD PTR [r10]
	vmovsd	xmm3, QWORD PTR [r11]
	vsubsd	xmm2, xmm2, QWORD PTR [rdx+rbx*8]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx*8]
	vmovsd	xmm1, QWORD PTR [rsi]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	lea	r12, [0+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm7, xmm7, xmm0
	ja	.L290
.L255:
	vmulsd	xmm4, xmm5, QWORD PTR [r15+rbx*8]
	vmulsd	xmm0, xmm7, xmm7
	mov	rdi, QWORD PTR [rbp-112]
	inc	rbx
	add	rdi, r13
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm7
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	inc	r14
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-104]
	add	rdi, r13
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-96]
	add	rdi, r13
	vaddsd	xmm0, xmm1, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rbp-80]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-72]
	add	rdi, r12
	vmovsd	xmm0, QWORD PTR [rdi]
	add	r12, QWORD PTR [rbp-64]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	vmovsd	xmm0, QWORD PTR [r12]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12], xmm1
	cmp	r8, rbx
	ja	.L291
.L283:
	mov	r9, QWORD PTR [rbp-144]
	mov	r12, QWORD PTR [rbp-136]
	jmp	.L254
	.p2align 4,,10
	.p2align 3
.L271:
	mov	rsi, rbx
	jmp	.L258
.L267:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC32
	xor	eax, eax
	call	printf
	vmovsd	xmm18, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm18, QWORD PTR [rbp-176]
.L270:
	mov	rdi, QWORD PTR [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-120]
	add	rsp, 256
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L268:
	.cfi_restore_state
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L269
.L289:
	mov	QWORD PTR [rbp-240], r9
	mov	QWORD PTR [rbp-232], r8
	vmovsd	QWORD PTR [rbp-224], xmm8
	vmovsd	QWORD PTR [rbp-216], xmm7
	vmovsd	QWORD PTR [rbp-208], xmm5
	vmovsd	QWORD PTR [rbp-200], xmm1
	vmovsd	QWORD PTR [rbp-144], xmm2
	vmovsd	QWORD PTR [rbp-136], xmm3
	vzeroupper
	call	sqrt
	mov	rdi, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	mov	rdx, QWORD PTR [rbp-96]
	add	rdi, r13
	add	rcx, r13
	add	rdx, r13
	mov	r9, QWORD PTR [rbp-240]
	mov	r8, QWORD PTR [rbp-232]
	vmovq	xmm6, QWORD PTR .LC16[rip]
	vmovsd	xmm8, QWORD PTR [rbp-224]
	vmovsd	xmm7, QWORD PTR [rbp-216]
	vmovsd	xmm5, QWORD PTR [rbp-208]
	vmovsd	xmm1, QWORD PTR [rbp-200]
	vmovsd	xmm2, QWORD PTR [rbp-144]
	vmovsd	xmm3, QWORD PTR [rbp-136]
	jmp	.L263
.L251:
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC30
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-168], 0
	mov	r9, QWORD PTR [rbp-120]
	jne	.L252
	jmp	.L253
	.p2align 4,,10
	.p2align 3
.L250:
	mov	edi, OFFSET FLAT:.LC29
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC30
	vmovsd	QWORD PTR [rbp-176], xmm0
	call	likwid_markerStartRegion
	jmp	.L253
.L290:
	mov	QWORD PTR [rbp-256], r9
	mov	QWORD PTR [rbp-248], r8
	vmovsd	QWORD PTR [rbp-240], xmm8
	vmovsd	QWORD PTR [rbp-232], xmm7
	vmovsd	QWORD PTR [rbp-224], xmm5
	vmovsd	QWORD PTR [rbp-216], xmm1
	vmovsd	QWORD PTR [rbp-208], xmm2
	vmovsd	QWORD PTR [rbp-200], xmm3
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-136]
	mov	r9, QWORD PTR [rbp-256]
	mov	rax, QWORD PTR [rsi]
	mov	rdx, QWORD PTR [rsi+8]
	mov	rcx, QWORD PTR [rsi+16]
	lea	r11, [rax+r13]
	lea	r10, [rdx+r13]
	lea	rsi, [rcx+r13]
	mov	r8, QWORD PTR [rbp-248]
	vmovq	xmm6, QWORD PTR .LC16[rip]
	vmovsd	xmm8, QWORD PTR [rbp-240]
	vmovsd	xmm7, QWORD PTR [rbp-232]
	vmovsd	xmm5, QWORD PTR [rbp-224]
	vmovsd	xmm1, QWORD PTR [rbp-216]
	vmovsd	xmm2, QWORD PTR [rbp-208]
	vmovsd	xmm3, QWORD PTR [rbp-200]
	jmp	.L255
	.cfi_endproc
.LFE8607:
	.size	_Z23nbody_vectorized_avx512mPdPS_S0_S0_, .-_Z23nbody_vectorized_avx512mPdPS_S0_S0_
	.section	.rodata.str1.1
.LC33:
	.string	"AVX512-rsqrt["
.LC34:
	.string	"vectorized-AVX512-rsqrt"
.LC37:
	.string	"x]: Performance: %fMpairs/s\n"
.LC38:
	.string	"!]; Force mismatches; %d\n"
	.text
	.p2align 4,,15
	.globl	_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.type	_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_, @function
_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_:
.LFB8608:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -64
	push	QWORD PTR [r10-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	push	r14
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	mov	r14, rsi
	push	r13
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	mov	r13, rdx
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	lea	rbx, [0+rdi*8]
	mov	rsi, rbx
	sub	rsp, 256
	mov	QWORD PTR [rbp-168], rdi
	mov	edi, 64
	mov	QWORD PTR [rbp-192], rcx
	mov	QWORD PTR [rbp-200], r8
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	mov	QWORD PTR [rbp-144], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r15, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-120], rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-128], rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	mov	QWORD PTR [rbp-136], rax
	mov	rax, QWORD PTR [rbp-168]
	mov	rsi, rax
	shr	rsi, 8
	mov	QWORD PTR [rbp-176], rsi
	test	rax, rax
	je	.L293
	mov	r8, QWORD PTR [rbp-144]
	xor	esi, esi
	mov	rdi, r8
	mov	rdx, rbx
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r15
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r12
	call	memset
	mov	rdi, QWORD PTR [rbp-120]
	xor	esi, esi
	mov	rdx, rbx
	call	memset
	mov	rdi, QWORD PTR [rbp-128]
	xor	esi, esi
	mov	rdx, rbx
	call	memset
	mov	rcx, QWORD PTR [rbp-136]
	xor	esi, esi
	mov	rdi, rcx
	mov	rdx, rbx
	call	memset
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC33
	call	printf
	cmp	BYTE PTR [rbp-168], 0
	je	.L294
	inc	QWORD PTR [rbp-176]
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC34
	vmovsd	QWORD PTR [rbp-184], xmm0
	call	likwid_markerStartRegion
.L330:
	mov	rax, QWORD PTR [r13+8]
	mov	r15, QWORD PTR [rbp-80]
	mov	QWORD PTR [rbp-144], rax
	mov	r9, QWORD PTR [rbp-64]
	mov	rax, QWORD PTR [r13+16]
	mov	r10, QWORD PTR [r13+0]
	mov	r8, QWORD PTR [rbp-72]
	vmovq	xmm7, QWORD PTR .LC16[rip]
	vmovq	xmm6, QWORD PTR .LC35[rip]
	vmovq	xmm5, QWORD PTR .LC36[rip]
	mov	QWORD PTR [rbp-136], rax
	mov	rsi, r15
	xor	eax, eax
	mov	r15, r9
	.p2align 4,,10
	.p2align 3
.L309:
	mov	rdi, rax
	sal	rdi, 8
	inc	rax
	mov	QWORD PTR [rbp-128], rdi
	mov	QWORD PTR [rbp-160], rax
	mov	rdi, rax
	mov	rax, QWORD PTR [rbp-168]
	sal	rdi, 8
	cmp	rdi, rax
	cmova	rdi, rax
	xor	r9d, r9d
	lea	rax, [0+rdi*8]
	mov	QWORD PTR [rbp-152], rax
	.p2align 4,,10
	.p2align 3
.L305:
	mov	rax, QWORD PTR [rbp-128]
	vmovsd	xmm4, QWORD PTR [r14+r9*8]
	lea	r12, [0+r9*8]
	inc	r9
	cmp	r9, rax
	mov	rbx, rax
	cmovnb	rbx, r9
	vxorpd	xmm4, xmm4, xmm7
	mov	rax, rbx
	and	eax, 7
	jne	.L331
.L297:
	mov	r11, QWORD PTR [rbp-144]
	mov	rcx, QWORD PTR [rbp-136]
	vxorpd	xmm13, xmm13, xmm13
	lea	rax, [rbx+7]
	vmovapd	zmm12, zmm13
	vmovapd	zmm11, zmm13
	vbroadcastsd	zmm19, QWORD PTR [r10-8+r9*8]
	vbroadcastsd	zmm18, QWORD PTR [r11-8+r9*8]
	vbroadcastsd	zmm17, QWORD PTR [rcx-8+r9*8]
	vbroadcastsd	zmm16, xmm4
	vbroadcastsd	zmm15, xmm6
	vbroadcastsd	zmm14, xmm5
	cmp	rdi, rax
	jbe	.L314
	.p2align 4,,10
	.p2align 3
.L302:
	vsubpd	zmm8, zmm18, ZMMWORD PTR [r11+rbx*8]
	vsubpd	zmm10, zmm19, ZMMWORD PTR [r10+rbx*8]
	vsubpd	zmm3, zmm17, ZMMWORD PTR [rcx+rbx*8]
	vmulpd	zmm1, zmm8, zmm8
	lea	rax, [rbx+8]
	lea	rdx, [rbx+15]
	vfmadd231pd	zmm1, zmm10, zmm10
	vfmadd231pd	zmm1, zmm3, zmm3
	vrsqrt14pd	zmm9, zmm1
	vmulpd	zmm2, zmm9, zmm9
	vmulpd	zmm9, zmm9, zmm14
	vfnmadd132pd	zmm2, zmm15, zmm1
	vmulpd	zmm2, zmm2, zmm9
	vmulpd	zmm0, zmm2, zmm2
	vmulpd	zmm2, zmm14, zmm2
	vfnmadd132pd	zmm1, zmm15, zmm0
	vmulpd	zmm0, zmm1, zmm2
	vmulpd	zmm1, zmm16, ZMMWORD PTR [r14+rbx*8]
	vmulpd	zmm2, zmm0, zmm0
	vmulpd	zmm0, zmm2, zmm0
	vmulpd	zmm0, zmm1, zmm0
	vfmadd231pd	zmm12, zmm0, zmm8
	vfmadd231pd	zmm11, zmm0, zmm3
	vfnmadd213pd	zmm8, zmm0, ZMMWORD PTR [r8+rbx*8]
	vfnmadd213pd	zmm3, zmm0, ZMMWORD PTR [r15+rbx*8]
	vfmadd231pd	zmm13, zmm0, zmm10
	vfnmadd213pd	zmm0, zmm10, ZMMWORD PTR [rsi+rbx*8]
	vmovapd	ZMMWORD PTR [rsi+rbx*8], zmm0
	vmovapd	ZMMWORD PTR [r8+rbx*8], zmm8
	vmovapd	ZMMWORD PTR [r15+rbx*8], zmm3
	mov	rbx, rax
	cmp	rdi, rdx
	ja	.L302
.L301:
	vextractf64x4	ymm0, zmm13, 0x1
	vaddpd	ymm13, ymm0, ymm13
	mov	r11, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	vextractf64x2	xmm0, ymm13, 0x1
	vaddpd	xmm13, xmm0, xmm13
	vextractf64x4	ymm0, zmm12, 0x1
	vaddpd	ymm12, ymm0, ymm12
	vhaddpd	xmm13, xmm13, xmm13
	add	r11, r12
	vextractf64x2	xmm0, ymm12, 0x1
	vaddpd	xmm12, xmm0, xmm12
	vextractf64x4	ymm0, zmm11, 0x1
	vaddpd	ymm11, ymm0, ymm11
	vaddsd	xmm13, xmm13, QWORD PTR [r11]
	vhaddpd	xmm12, xmm12, xmm12
	vextractf64x2	xmm0, ymm11, 0x1
	vaddpd	xmm11, xmm0, xmm11
	vmovsd	QWORD PTR [r11], xmm13
	add	rcx, r12
	vaddsd	xmm12, xmm12, QWORD PTR [rcx]
	mov	rdx, QWORD PTR [rbp-96]
	vhaddpd	xmm11, xmm11, xmm11
	vmovsd	QWORD PTR [rcx], xmm12
	add	rdx, r12
	vaddsd	xmm11, xmm11, QWORD PTR [rdx]
	lea	rbx, [0+rax*8]
	vxorpd	xmm10, xmm10, xmm10
	vmovsd	QWORD PTR [rdx], xmm11
	cmp	rdi, rax
	jbe	.L307
	mov	QWORD PTR [rbp-120], rsi
	mov	rsi, QWORD PTR [rbp-152]
	.p2align 4,,10
	.p2align 3
.L308:
	mov	rax, QWORD PTR [r13+0]
	vmovsd	xmm3, QWORD PTR [rax+r12]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r13+8]
	vmovsd	xmm2, QWORD PTR [rax+r12]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx]
	mov	rax, QWORD PTR [r13+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rax+r12]
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm10, xmm0
	vsqrtsd	xmm9, xmm9, xmm0
	ja	.L332
.L306:
	vmulsd	xmm8, xmm4, QWORD PTR [r14+rbx]
	vmulsd	xmm0, xmm9, xmm9
	mov	rax, QWORD PTR [rbp-80]
	add	rax, rbx
	vmulsd	xmm3, xmm3, xmm8
	vmulsd	xmm0, xmm0, xmm9
	vmulsd	xmm2, xmm2, xmm8
	vmulsd	xmm1, xmm1, xmm8
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [r11]
	vmovsd	QWORD PTR [r11], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	mov	rax, QWORD PTR [rbp-72]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	mov	rax, QWORD PTR [rbp-64]
	add	rax, rbx
	vmovsd	xmm0, QWORD PTR [rax]
	add	rbx, 8
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	rsi, rbx
	jne	.L308
	mov	rsi, QWORD PTR [rbp-120]
.L307:
	cmp	rdi, r9
	jne	.L305
	mov	rax, QWORD PTR [rbp-160]
	cmp	rax, QWORD PTR [rbp-176]
	jb	.L309
	vzeroupper
.L296:
	mov	edi, OFFSET FLAT:.LC34
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-168]
	mov	rcx, QWORD PTR [rbp-200]
	mov	rdx, QWORD PTR [rbp-192]
	mov	r8d, ebx
	lea	rsi, [rbp-80]
	lea	rdi, [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm0
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L310
	lea	rdx, [rbx-1]
	imul	rdx, rbx
	test	rdx, rdx
	js	.L311
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L312:
	vmovsd	xmm20, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC37
	vsubsd	xmm1, xmm20, QWORD PTR [rbp-184]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-120], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-120]
	jmp	.L313
	.p2align 4,,10
	.p2align 3
.L331:
	mov	r11d, 8
	sub	r11, rax
	cmp	rdi, rbx
	jbe	.L297
	xor	edx, edx
	vxorpd	xmm10, xmm10, xmm10
	jmp	.L299
	.p2align 4,,10
	.p2align 3
.L298:
	vmulsd	xmm8, xmm4, QWORD PTR [r14+rbx*8]
	vmulsd	xmm0, xmm9, xmm9
	mov	rcx, QWORD PTR [rbp-112]
	inc	rbx
	add	rcx, r12
	vmulsd	xmm3, xmm3, xmm8
	vmulsd	xmm0, xmm0, xmm9
	vmulsd	xmm2, xmm2, xmm8
	vmulsd	xmm1, xmm1, xmm8
	inc	rdx
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-104]
	add	rcx, r12
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-96]
	add	rcx, r12
	vaddsd	xmm0, xmm1, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-80]
	add	rcx, rax
	vmovsd	xmm0, QWORD PTR [rcx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rcx], xmm3
	mov	rcx, QWORD PTR [rbp-72]
	add	rcx, rax
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rax, QWORD PTR [rbp-64]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	rdi, rbx
	jbe	.L297
	cmp	rdx, r11
	jnb	.L297
.L299:
	mov	rcx, QWORD PTR [r13+0]
	lea	rax, [0+rbx*8]
	vmovsd	xmm3, QWORD PTR [rcx+r12]
	vsubsd	xmm3, xmm3, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r13+8]
	vmovsd	xmm2, QWORD PTR [rcx+r12]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r13+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rcx+r12]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm10, xmm0
	vsqrtsd	xmm9, xmm9, xmm0
	jbe	.L298
	mov	QWORD PTR [rbp-304], r11
	mov	QWORD PTR [rbp-296], rdx
	mov	QWORD PTR [rbp-288], r9
	mov	QWORD PTR [rbp-280], rsi
	mov	QWORD PTR [rbp-272], r8
	mov	QWORD PTR [rbp-264], r10
	mov	QWORD PTR [rbp-256], rdi
	vmovsd	QWORD PTR [rbp-248], xmm10
	vmovsd	QWORD PTR [rbp-240], xmm9
	vmovsd	QWORD PTR [rbp-232], xmm4
	vmovsd	QWORD PTR [rbp-224], xmm1
	vmovsd	QWORD PTR [rbp-216], xmm2
	vmovsd	QWORD PTR [rbp-208], xmm3
	mov	QWORD PTR [rbp-120], rax
	vzeroupper
	call	sqrt
	mov	r11, QWORD PTR [rbp-304]
	mov	rdx, QWORD PTR [rbp-296]
	mov	r9, QWORD PTR [rbp-288]
	mov	rsi, QWORD PTR [rbp-280]
	mov	r8, QWORD PTR [rbp-272]
	mov	r10, QWORD PTR [rbp-264]
	mov	rdi, QWORD PTR [rbp-256]
	vmovq	xmm6, QWORD PTR .LC35[rip]
	vmovq	xmm7, QWORD PTR .LC16[rip]
	vmovsd	xmm10, QWORD PTR [rbp-248]
	vmovq	xmm5, QWORD PTR .LC36[rip]
	vmovsd	xmm9, QWORD PTR [rbp-240]
	vmovsd	xmm4, QWORD PTR [rbp-232]
	vmovsd	xmm1, QWORD PTR [rbp-224]
	vmovsd	xmm2, QWORD PTR [rbp-216]
	vmovsd	xmm3, QWORD PTR [rbp-208]
	mov	rax, QWORD PTR [rbp-120]
	jmp	.L298
	.p2align 4,,10
	.p2align 3
.L314:
	mov	rax, rbx
	jmp	.L301
.L310:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC38
	xor	eax, eax
	call	printf
	vmovsd	xmm22, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm22, QWORD PTR [rbp-184]
.L313:
	mov	rdi, QWORD PTR [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-120]
	add	rsp, 256
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L311:
	.cfi_restore_state
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L312
.L332:
	mov	QWORD PTR [rbp-288], r9
	mov	QWORD PTR [rbp-280], r8
	mov	QWORD PTR [rbp-272], r10
	mov	QWORD PTR [rbp-264], rsi
	mov	QWORD PTR [rbp-256], rdi
	vmovsd	QWORD PTR [rbp-248], xmm10
	vmovsd	QWORD PTR [rbp-240], xmm9
	vmovsd	QWORD PTR [rbp-232], xmm4
	vmovsd	QWORD PTR [rbp-224], xmm1
	vmovsd	QWORD PTR [rbp-216], xmm2
	vmovsd	QWORD PTR [rbp-208], xmm3
	vzeroupper
	call	sqrt
	mov	r11, QWORD PTR [rbp-112]
	mov	rcx, QWORD PTR [rbp-104]
	mov	rdx, QWORD PTR [rbp-96]
	add	r11, r12
	add	rcx, r12
	add	rdx, r12
	mov	r9, QWORD PTR [rbp-288]
	mov	r8, QWORD PTR [rbp-280]
	mov	r10, QWORD PTR [rbp-272]
	mov	rsi, QWORD PTR [rbp-264]
	mov	rdi, QWORD PTR [rbp-256]
	vmovq	xmm6, QWORD PTR .LC35[rip]
	vmovq	xmm7, QWORD PTR .LC16[rip]
	vmovsd	xmm10, QWORD PTR [rbp-248]
	vmovq	xmm5, QWORD PTR .LC36[rip]
	vmovsd	xmm9, QWORD PTR [rbp-240]
	vmovsd	xmm4, QWORD PTR [rbp-232]
	vmovsd	xmm1, QWORD PTR [rbp-224]
	vmovsd	xmm2, QWORD PTR [rbp-216]
	vmovsd	xmm3, QWORD PTR [rbp-208]
	jmp	.L306
.L294:
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC34
	vmovsd	QWORD PTR [rbp-184], xmm0
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-176], 0
	jne	.L330
	jmp	.L296
	.p2align 4,,10
	.p2align 3
.L293:
	mov	edi, OFFSET FLAT:.LC33
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC34
	vmovsd	QWORD PTR [rbp-184], xmm0
	call	likwid_markerStartRegion
	jmp	.L296
	.cfi_endproc
.LFE8608:
	.size	_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_, .-_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC41:
	.string	"AVX512-full["
.LC42:
	.string	"full-vectorized"
	.text
	.p2align 4,,15
	.globl	_Z21nbody_full_vectorizedmPdPS_S0_S0_
	.type	_Z21nbody_full_vectorizedmPdPS_S0_S0_, @function
_Z21nbody_full_vectorizedmPdPS_S0_S0_:
.LFB8609:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -32
	push	QWORD PTR [r10-8]
	lea	rax, [0+rdi*8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rax
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rbx, rdi
	sub	rsp, 320
	mov	QWORD PTR [rbp-192], rdi
	mov	QWORD PTR [rbp-152], rsi
	mov	edi, 64
	mov	rsi, rax
	mov	QWORD PTR [rbp-176], rdx
	mov	QWORD PTR [rbp-256], rcx
	mov	QWORD PTR [rbp-264], r8
	mov	QWORD PTR [rbp-232], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-144], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r15, rbx
	mov	r13, rax
	mov	QWORD PTR [rbp-136], rax
	shr	rbx, 2
	call	aligned_alloc
	test	r15b, 3
	mov	r12, rax
	mov	QWORD PTR [rbp-128], rax
	mov	r9, QWORD PTR [rbp-152]
	je	.L334
	inc	rbx
	mov	rdi, rbx
	call	malloc
	mov	QWORD PTR [rbp-240], rax
	mov	rax, r15
	shr	r15, 8
	test	rax, rax
	mov	QWORD PTR [rbp-224], r15
	mov	r9, QWORD PTR [rbp-152]
	je	.L335
	mov	r15, QWORD PTR [rbp-232]
	xor	esi, esi
	mov	rdx, r15
	mov	rdi, r14
	mov	QWORD PTR [rbp-152], r9
	call	memset
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, r13
	call	memset
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, r12
	call	memset
	mov	r9, QWORD PTR [rbp-152]
.L335:
	test	rbx, rbx
	mov	edx, 1
	cmovne	rdx, rbx
	mov	rdi, QWORD PTR [rbp-240]
	mov	esi, 255
	mov	QWORD PTR [rbp-152], r9
	call	memset
	mov	r9, QWORD PTR [rbp-152]
.L339:
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC41
	mov	QWORD PTR [rbp-152], r9
	call	printf
	cmp	BYTE PTR [rbp-192], 0
	mov	r9, QWORD PTR [rbp-152]
	je	.L396
	mov	QWORD PTR [rbp-184], r9
	inc	QWORD PTR [rbp-224]
	call	omp_get_wtime
	mov	rax, QWORD PTR [rbp-176]
	mov	edi, OFFSET FLAT:.LC42
	mov	r11, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rax+8]
	mov	r10, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-168], r11
	mov	QWORD PTR [rbp-160], rdx
	mov	QWORD PTR [rbp-152], r10
	vmovsd	QWORD PTR [rbp-248], xmm0
	mov	r14, QWORD PTR [rbp-144]
	mov	r13, QWORD PTR [rbp-136]
	mov	r12, QWORD PTR [rbp-128]
	call	likwid_markerStartRegion
	mov	r10, QWORD PTR [rbp-152]
	mov	rdx, QWORD PTR [rbp-160]
	mov	r11, QWORD PTR [rbp-168]
	mov	r9, QWORD PTR [rbp-184]
.L340:
	cmp	QWORD PTR [rbp-192], 0
	je	.L342
	mov	QWORD PTR [rbp-200], 3
	vmovq	xmm11, QWORD PTR .LC16[rip]
	mov	r8, QWORD PTR [rbp-240]
	xor	eax, eax
	mov	rsi, rdx
	.p2align 4,,10
	.p2align 3
.L347:
	mov	rdx, rax
	sal	rdx, 8
	inc	rax
	mov	QWORD PTR [rbp-184], rdx
	mov	rdx, QWORD PTR [rbp-192]
	mov	QWORD PTR [rbp-216], rax
	mov	QWORD PTR [rbp-168], r12
	sal	rax, 8
	cmp	rax, rdx
	cmova	rax, rdx
	xor	r15d, r15d
	.p2align 4,,10
	.p2align 3
.L345:
	mov	rdx, r15
	shr	rdx, 2
	lea	rbx, [r8+rdx]
	movzx	edi, BYTE PTR [rbx]
	mov	edx, r15d
	vmovsd	xmm10, QWORD PTR [r9+r15*8]
	mov	ecx, 1
	and	edx, 3
	shlx	edx, ecx, edx
	vxorpd	xmm10, xmm10, xmm11
	xor	edx, edi
	mov	BYTE PTR [rbx], dl
	mov	QWORD PTR [rbp-152], rbx
	mov	BYTE PTR [rbp-160], dil
	lea	rdx, [0+r15*8]
	vbroadcastsd	ymm9, QWORD PTR [r11+r15*8]
	vbroadcastsd	ymm8, QWORD PTR [rsi+r15*8]
	vbroadcastsd	ymm7, QWORD PTR [r10+r15*8]
	vbroadcastsd	ymm6, xmm10
	mov	rcx, QWORD PTR [rbp-184]
	mov	r12, QWORD PTR [rbp-168]
	cmp	rax, QWORD PTR [rbp-200]
	jbe	.L397
	.p2align 4,,10
	.p2align 3
.L343:
	vsubpd	ymm3, ymm8, YMMWORD PTR [rsi+rcx*8]
	vsubpd	ymm4, ymm9, YMMWORD PTR [r11+rcx*8]
	vsubpd	ymm2, ymm7, YMMWORD PTR [r10+rcx*8]
	vmulpd	ymm0, ymm3, ymm3
	mov	rdi, rcx
	shr	rdi, 2
	movzx	ebx, BYTE PTR [r8+rdi]
	vmulpd	ymm1, ymm6, YMMWORD PTR [r9+rcx*8]
	vfmadd231pd	ymm0, ymm4, ymm4
	kmovd	k1, ebx
	lea	rdi, [rcx+7]
	lea	rbx, [rcx+4]
	vfmadd231pd	ymm0, ymm2, ymm2
	vsqrtpd	ymm0{k1}{z}, ymm0
	vmulpd	ymm5, ymm0, ymm0
	vmulpd	ymm0, ymm5, ymm0
	vdivpd	ymm0{k1}{z}, ymm1, ymm0
	vfnmadd213pd	ymm3, ymm0, YMMWORD PTR [r13+0+rcx*8]
	vfnmadd213pd	ymm2, ymm0, YMMWORD PTR [r12+rcx*8]
	vfnmadd213pd	ymm0, ymm4, YMMWORD PTR [r14+rcx*8]
	vmovapd	YMMWORD PTR [r14+rcx*8], ymm0
	vmovapd	YMMWORD PTR [r13+0+rcx*8], ymm3
	vmovapd	YMMWORD PTR [r12+rcx*8], ymm2
	mov	rcx, rbx
	cmp	rax, rdi
	ja	.L343
	mov	QWORD PTR [rbp-168], r12
.L348:
	cmp	rax, rbx
	jbe	.L353
	cmp	r15, rbx
	je	.L349
	mov	r12, QWORD PTR [rbp-176]
	vxorpd	xmm4, xmm4, xmm4
	mov	rdi, QWORD PTR [r12]
	lea	rcx, [0+rbx*8]
	vmovsd	xmm2, QWORD PTR [rdi+rdx]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rbx*8]
	mov	rdi, QWORD PTR [r12+8]
	vmovsd	xmm1, QWORD PTR [rdi+rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rbx*8]
	mov	rdi, QWORD PTR [r12+16]
	vmovsd	xmm0, QWORD PTR [rdi+rdx]
	vsubsd	xmm3, xmm0, QWORD PTR [rdi+rbx*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L388
.L352:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rcx]
	vmulsd	xmm4, xmm5, xmm5
	mov	rdi, QWORD PTR [rbp-144]
	add	rdi, rcx
	vmulsd	xmm2, xmm2, xmm0
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm1, xmm0
	vmulsd	xmm0, xmm0, xmm3
	vmovsd	xmm5, QWORD PTR [rdi]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	mov	rdi, QWORD PTR [rbp-136]
	add	rdi, rcx
	vmovsd	xmm2, QWORD PTR [rdi]
	add	rcx, QWORD PTR [rbp-128]
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rdi], xmm1
	vmovsd	xmm1, QWORD PTR [rcx]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rcx], xmm0
.L349:
	lea	rcx, [rbx+1]
	cmp	rax, rcx
	jbe	.L353
	cmp	r15, rcx
	je	.L354
	mov	rdi, QWORD PTR [rbp-176]
	lea	r12, [0+rcx*8]
	mov	rdi, QWORD PTR [rdi]
	mov	QWORD PTR [rbp-208], r12
	vmovsd	xmm2, QWORD PTR [rdi+rdx]
	mov	r12, QWORD PTR [rbp-176]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rcx*8]
	mov	rdi, QWORD PTR [r12+8]
	vxorpd	xmm4, xmm4, xmm4
	vmovsd	xmm1, QWORD PTR [rdi+rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rcx*8]
	mov	rdi, QWORD PTR [r12+16]
	vmovsd	xmm0, QWORD PTR [rdi+rdx]
	vsubsd	xmm3, xmm0, QWORD PTR [rdi+rcx*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L389
.L357:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rcx*8]
	vmulsd	xmm4, xmm5, xmm5
	mov	rcx, QWORD PTR [rbp-144]
	mov	rdi, QWORD PTR [rbp-208]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm3
	add	rcx, rdi
	vmovsd	xmm5, QWORD PTR [rcx]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	mov	rcx, QWORD PTR [rbp-136]
	add	rcx, rdi
	vmovsd	xmm2, QWORD PTR [rcx]
	add	rdi, QWORD PTR [rbp-128]
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rcx], xmm1
	vmovsd	xmm1, QWORD PTR [rdi]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rdi], xmm0
.L354:
	lea	rcx, [rbx+2]
	cmp	rax, rcx
	jbe	.L353
	cmp	r15, rcx
	je	.L358
	mov	rdi, QWORD PTR [rbp-176]
	lea	r12, [0+rcx*8]
	mov	rdi, QWORD PTR [rdi]
	mov	QWORD PTR [rbp-208], r12
	vmovsd	xmm2, QWORD PTR [rdi+rdx]
	mov	r12, QWORD PTR [rbp-176]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rcx*8]
	mov	rdi, QWORD PTR [r12+8]
	vxorpd	xmm4, xmm4, xmm4
	vmovsd	xmm1, QWORD PTR [rdi+rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rcx*8]
	mov	rdi, QWORD PTR [r12+16]
	vmovsd	xmm0, QWORD PTR [rdi+rdx]
	vsubsd	xmm3, xmm0, QWORD PTR [rdi+rcx*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L390
.L361:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rcx*8]
	vmulsd	xmm4, xmm5, xmm5
	mov	rcx, QWORD PTR [rbp-144]
	mov	rdi, QWORD PTR [rbp-208]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm3
	add	rcx, rdi
	vmovsd	xmm5, QWORD PTR [rcx]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	mov	rcx, QWORD PTR [rbp-136]
	add	rcx, rdi
	vmovsd	xmm2, QWORD PTR [rcx]
	add	rdi, QWORD PTR [rbp-128]
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rcx], xmm1
	vmovsd	xmm1, QWORD PTR [rdi]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rdi], xmm0
.L358:
	add	rbx, 3
	cmp	rax, rbx
	jbe	.L353
	cmp	r15, rbx
	je	.L353
	mov	r12, QWORD PTR [rbp-176]
	vxorpd	xmm5, xmm5, xmm5
	mov	rcx, QWORD PTR [r12]
	lea	rdi, [0+rbx*8]
	vmovsd	xmm3, QWORD PTR [rcx+rdx]
	vsubsd	xmm3, xmm3, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r12+8]
	vmovsd	xmm2, QWORD PTR [rcx+rdx]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r12+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rcx+rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm5, xmm0
	vsqrtsd	xmm4, xmm4, xmm0
	ja	.L398
.L363:
	vmulsd	xmm10, xmm10, QWORD PTR [r9+rbx*8]
	vmulsd	xmm0, xmm4, xmm4
	mov	rdx, QWORD PTR [rbp-144]
	add	rdx, rdi
	vmulsd	xmm3, xmm3, xmm10
	vmulsd	xmm0, xmm0, xmm4
	vmulsd	xmm2, xmm2, xmm10
	vmulsd	xmm10, xmm1, xmm10
	vmovsd	xmm4, QWORD PTR [rdx]
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vsubsd	xmm3, xmm4, xmm3
	vmovsd	QWORD PTR [rdx], xmm3
	mov	rdx, QWORD PTR [rbp-136]
	add	rdx, rdi
	vmovsd	xmm3, QWORD PTR [rdx]
	add	rdi, QWORD PTR [rbp-128]
	vdivsd	xmm10, xmm10, xmm0
	vsubsd	xmm2, xmm3, xmm2
	vmovsd	QWORD PTR [rdx], xmm2
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm10, xmm0, xmm10
	vmovsd	QWORD PTR [rdi], xmm10
	.p2align 4,,10
	.p2align 3
.L353:
	mov	rdx, QWORD PTR [rbp-152]
	movzx	ebx, BYTE PTR [rbp-160]
	inc	r15
	mov	BYTE PTR [rdx], bl
	cmp	QWORD PTR [rbp-192], r15
	jne	.L345
	mov	rax, QWORD PTR [rbp-216]
	mov	r12, QWORD PTR [rbp-168]
	add	QWORD PTR [rbp-200], 256
	cmp	rax, QWORD PTR [rbp-224]
	jb	.L347
	mov	edi, OFFSET FLAT:.LC42
	vzeroupper
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-232]
	mov	edi, 64
	mov	rsi, rbx
	vmovsd	QWORD PTR [rbp-152], xmm0
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r15, rax
	mov	QWORD PTR [rbp-112], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-232], rbx
	mov	r12, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, QWORD PTR [rbp-232]
	mov	edi, 64
	mov	rbx, rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
.L364:
	mov	rsi, QWORD PTR [rbp-256]
	mov	rdx, QWORD PTR [rbp-264]
	mov	r10, QWORD PTR [rsi]
	mov	r8, QWORD PTR [rsi+8]
	mov	r11, QWORD PTR [rbp-192]
	mov	rsi, QWORD PTR [rsi+16]
	mov	r9, QWORD PTR [rdx]
	mov	rdi, QWORD PTR [rdx+8]
	mov	rcx, QWORD PTR [rdx+16]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L368:
	vmovsd	xmm0, QWORD PTR [r10+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [r9+rdx*8]
	mov	QWORD PTR [r15+rdx*8], 0x000000000
	vmovsd	QWORD PTR [r12+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [r8+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	mov	QWORD PTR [r14+rdx*8], 0x000000000
	vmovsd	QWORD PTR [rbx+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rdx*8]
	mov	QWORD PTR [r13+0+rdx*8], 0x000000000
	vmovsd	QWORD PTR [rax+rdx*8], xmm0
	inc	rdx
	cmp	r11, rdx
	jne	.L368
.L367:
	lea	rcx, [rbp-112]
	mov	r8d, DWORD PTR [rbp-192]
	lea	rdx, [rbp-80]
	mov	rsi, rcx
	lea	rdi, [rbp-144]
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L399
	mov	rax, QWORD PTR [rbp-192]
	lea	rdx, [rax-1]
	imul	rdx, rax
	test	rdx, rdx
	js	.L369
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L370:
	vmovsd	xmm16, QWORD PTR [rbp-152]
	mov	edi, OFFSET FLAT:.LC37
	vsubsd	xmm1, xmm16, QWORD PTR [rbp-248]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-152], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-152]
	jmp	.L371
	.p2align 4,,10
	.p2align 3
.L397:
	mov	rbx, rcx
	jmp	.L348
.L399:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC38
	xor	eax, eax
	call	printf
	vmovsd	xmm18, QWORD PTR [rbp-152]
	vsubsd	xmm1, xmm18, QWORD PTR [rbp-248]
.L371:
	mov	rdi, QWORD PTR [rbp-144]
	vmovsd	QWORD PTR [rbp-152], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-136]
	call	free
	mov	rdi, QWORD PTR [rbp-128]
	call	free
	mov	rdi, QWORD PTR [rbp-112]
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	mov	rdi, QWORD PTR [rbp-240]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-152]
	add	rsp, 320
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L369:
	.cfi_restore_state
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L370
.L396:
	mov	QWORD PTR [rbp-184], r9
	call	omp_get_wtime
	mov	rax, QWORD PTR [rbp-176]
	mov	edi, OFFSET FLAT:.LC42
	mov	r11, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rax+8]
	mov	r10, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-168], r11
	mov	QWORD PTR [rbp-160], rdx
	mov	QWORD PTR [rbp-152], r10
	vmovsd	QWORD PTR [rbp-248], xmm0
	mov	r14, QWORD PTR [rbp-144]
	mov	r13, QWORD PTR [rbp-136]
	mov	r12, QWORD PTR [rbp-128]
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-224], 0
	mov	r10, QWORD PTR [rbp-152]
	mov	rdx, QWORD PTR [rbp-160]
	mov	r11, QWORD PTR [rbp-168]
	mov	r9, QWORD PTR [rbp-184]
	jne	.L340
.L341:
	mov	edi, OFFSET FLAT:.LC42
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-232]
	mov	edi, 64
	mov	rsi, rbx
	vmovsd	QWORD PTR [rbp-152], xmm0
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r15, rax
	mov	QWORD PTR [rbp-112], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-232], rbx
	mov	r12, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, QWORD PTR [rbp-232]
	mov	edi, 64
	mov	rbx, rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	cmp	QWORD PTR [rbp-192], 0
	mov	QWORD PTR [rbp-64], rax
	jne	.L364
	jmp	.L367
	.p2align 4,,10
	.p2align 3
.L334:
	mov	rdi, rbx
	mov	QWORD PTR [rbp-152], r9
	call	malloc
	mov	QWORD PTR [rbp-240], rax
	mov	rax, QWORD PTR [rbp-192]
	mov	r9, QWORD PTR [rbp-152]
	mov	rsi, rax
	shr	rsi, 8
	test	rax, rax
	mov	QWORD PTR [rbp-224], rsi
	je	.L400
	mov	r15, QWORD PTR [rbp-232]
	xor	esi, esi
	mov	rdx, r15
	mov	rdi, r14
	mov	QWORD PTR [rbp-152], r9
	call	memset
	xor	esi, esi
	mov	rdx, r15
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, r15
	mov	rdi, r12
	call	memset
	test	rbx, rbx
	mov	r9, QWORD PTR [rbp-152]
	jne	.L335
	jmp	.L339
.L342:
	mov	edi, OFFSET FLAT:.LC42
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-232]
	mov	edi, 64
	mov	rsi, rbx
	vmovsd	QWORD PTR [rbp-152], xmm0
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	jmp	.L367
.L400:
	mov	edi, OFFSET FLAT:.LC41
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC42
	vmovsd	QWORD PTR [rbp-248], xmm0
	call	likwid_markerStartRegion
	jmp	.L341
.L398:
	mov	QWORD PTR [rbp-352], r9
	mov	QWORD PTR [rbp-344], r10
	mov	QWORD PTR [rbp-336], rax
	mov	QWORD PTR [rbp-328], r11
	mov	QWORD PTR [rbp-320], rsi
	mov	QWORD PTR [rbp-312], r8
	vmovsd	QWORD PTR [rbp-304], xmm4
	vmovsd	QWORD PTR [rbp-296], xmm10
	vmovsd	QWORD PTR [rbp-288], xmm1
	vmovsd	QWORD PTR [rbp-280], xmm2
	vmovsd	QWORD PTR [rbp-272], xmm3
	mov	QWORD PTR [rbp-208], rdi
	vzeroupper
	call	sqrt
	mov	r9, QWORD PTR [rbp-352]
	mov	r10, QWORD PTR [rbp-344]
	mov	rax, QWORD PTR [rbp-336]
	mov	r11, QWORD PTR [rbp-328]
	mov	rsi, QWORD PTR [rbp-320]
	mov	r8, QWORD PTR [rbp-312]
	vmovq	xmm11, QWORD PTR .LC16[rip]
	vmovsd	xmm4, QWORD PTR [rbp-304]
	vmovsd	xmm10, QWORD PTR [rbp-296]
	vmovsd	xmm1, QWORD PTR [rbp-288]
	vmovsd	xmm2, QWORD PTR [rbp-280]
	vmovsd	xmm3, QWORD PTR [rbp-272]
	mov	rdi, QWORD PTR [rbp-208]
	jmp	.L363
.L388:
	mov	QWORD PTR [rbp-360], r9
	mov	QWORD PTR [rbp-352], r10
	mov	QWORD PTR [rbp-344], rax
	mov	QWORD PTR [rbp-336], r11
	mov	QWORD PTR [rbp-328], rsi
	mov	QWORD PTR [rbp-320], r8
	vmovsd	QWORD PTR [rbp-312], xmm3
	vmovsd	QWORD PTR [rbp-304], xmm5
	mov	QWORD PTR [rbp-296], rdx
	mov	QWORD PTR [rbp-288], rcx
	vmovsd	QWORD PTR [rbp-280], xmm10
	vmovsd	QWORD PTR [rbp-272], xmm1
	vmovsd	QWORD PTR [rbp-208], xmm2
	vzeroupper
	call	sqrt
	vmovsd	xmm2, QWORD PTR [rbp-208]
	vmovsd	xmm1, QWORD PTR [rbp-272]
	vmovsd	xmm10, QWORD PTR [rbp-280]
	mov	rcx, QWORD PTR [rbp-288]
	mov	rdx, QWORD PTR [rbp-296]
	vmovsd	xmm5, QWORD PTR [rbp-304]
	vmovsd	xmm3, QWORD PTR [rbp-312]
	vmovq	xmm11, QWORD PTR .LC16[rip]
	mov	r8, QWORD PTR [rbp-320]
	mov	rsi, QWORD PTR [rbp-328]
	mov	r11, QWORD PTR [rbp-336]
	mov	rax, QWORD PTR [rbp-344]
	mov	r10, QWORD PTR [rbp-352]
	mov	r9, QWORD PTR [rbp-360]
	jmp	.L352
.L390:
	mov	QWORD PTR [rbp-368], r9
	mov	QWORD PTR [rbp-360], r10
	mov	QWORD PTR [rbp-352], rax
	mov	QWORD PTR [rbp-344], r11
	mov	QWORD PTR [rbp-336], rsi
	mov	QWORD PTR [rbp-328], r8
	mov	QWORD PTR [rbp-320], rcx
	vmovsd	QWORD PTR [rbp-312], xmm2
	vmovsd	QWORD PTR [rbp-304], xmm1
	vmovsd	QWORD PTR [rbp-296], xmm3
	vmovsd	QWORD PTR [rbp-288], xmm5
	mov	QWORD PTR [rbp-280], rdx
	vmovsd	QWORD PTR [rbp-272], xmm10
	vzeroupper
	call	sqrt
	vmovsd	xmm10, QWORD PTR [rbp-272]
	mov	rdx, QWORD PTR [rbp-280]
	vmovsd	xmm5, QWORD PTR [rbp-288]
	vmovsd	xmm3, QWORD PTR [rbp-296]
	vmovsd	xmm1, QWORD PTR [rbp-304]
	vmovsd	xmm2, QWORD PTR [rbp-312]
	mov	rcx, QWORD PTR [rbp-320]
	vmovq	xmm11, QWORD PTR .LC16[rip]
	mov	r8, QWORD PTR [rbp-328]
	mov	rsi, QWORD PTR [rbp-336]
	mov	r11, QWORD PTR [rbp-344]
	mov	rax, QWORD PTR [rbp-352]
	mov	r10, QWORD PTR [rbp-360]
	mov	r9, QWORD PTR [rbp-368]
	jmp	.L361
.L389:
	mov	QWORD PTR [rbp-368], r9
	mov	QWORD PTR [rbp-360], r10
	mov	QWORD PTR [rbp-352], rax
	mov	QWORD PTR [rbp-344], r11
	mov	QWORD PTR [rbp-336], rsi
	mov	QWORD PTR [rbp-328], r8
	mov	QWORD PTR [rbp-320], rcx
	vmovsd	QWORD PTR [rbp-312], xmm2
	vmovsd	QWORD PTR [rbp-304], xmm1
	vmovsd	QWORD PTR [rbp-296], xmm3
	vmovsd	QWORD PTR [rbp-288], xmm5
	mov	QWORD PTR [rbp-280], rdx
	vmovsd	QWORD PTR [rbp-272], xmm10
	vzeroupper
	call	sqrt
	vmovsd	xmm10, QWORD PTR [rbp-272]
	mov	rdx, QWORD PTR [rbp-280]
	vmovsd	xmm5, QWORD PTR [rbp-288]
	vmovsd	xmm3, QWORD PTR [rbp-296]
	vmovsd	xmm1, QWORD PTR [rbp-304]
	vmovsd	xmm2, QWORD PTR [rbp-312]
	mov	rcx, QWORD PTR [rbp-320]
	vmovq	xmm11, QWORD PTR .LC16[rip]
	mov	r8, QWORD PTR [rbp-328]
	mov	rsi, QWORD PTR [rbp-336]
	mov	r11, QWORD PTR [rbp-344]
	mov	rax, QWORD PTR [rbp-352]
	mov	r10, QWORD PTR [rbp-360]
	mov	r9, QWORD PTR [rbp-368]
	jmp	.L357
	.cfi_endproc
.LFE8609:
	.size	_Z21nbody_full_vectorizedmPdPS_S0_S0_, .-_Z21nbody_full_vectorizedmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC43:
	.string	"AVX512-full-rsqrt-8i["
.LC44:
	.string	"full-vectorized-AVX512-rsqrt"
	.text
	.p2align 4,,15
	.globl	_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.type	_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_, @function
_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_:
.LFB8610:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -64
	push	QWORD PTR [r10-8]
	lea	rax, [0+rdi*8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	mov	r15, rdx
	push	r14
	push	r13
	push	r12
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	mov	r12, rax
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rbx, rdi
	mov	edi, 64
	sub	rsp, 384
	mov	QWORD PTR [rbp-160], rsi
	mov	rsi, rax
	mov	QWORD PTR [rbp-320], rcx
	mov	QWORD PTR [rbp-328], r8
	mov	QWORD PTR [rbp-288], rax
	call	aligned_alloc
	mov	rsi, r12
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-144], rax
	call	aligned_alloc
	mov	rsi, r12
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-136], rax
	call	aligned_alloc
	mov	r12, rax
	mov	QWORD PTR [rbp-128], rax
	mov	rax, rbx
	mov	QWORD PTR [rbp-176], rax
	shr	rbx, 3
	test	al, 7
	je	.L402
	inc	rbx
	mov	rdi, rbx
	call	malloc
	mov	QWORD PTR [rbp-184], rax
	mov	rax, QWORD PTR [rbp-176]
	mov	rdi, rax
	shr	rdi, 8
	mov	QWORD PTR [rbp-296], rdi
	test	rax, rax
	je	.L403
	mov	rdx, QWORD PTR [rbp-288]
	mov	rdi, r14
	xor	esi, esi
	call	memset
	mov	r14, QWORD PTR [rbp-288]
	xor	esi, esi
	mov	rdx, r14
	mov	rdi, r13
	call	memset
	mov	rdx, r14
	xor	esi, esi
	mov	rdi, r12
	call	memset
.L403:
	test	rbx, rbx
	mov	edx, 1
	cmovne	rdx, rbx
	mov	rdi, QWORD PTR [rbp-184]
	mov	esi, 255
	call	memset
.L407:
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC43
	call	printf
	cmp	BYTE PTR [rbp-176], 0
	je	.L461
	inc	QWORD PTR [rbp-296]
	call	omp_get_wtime
	mov	rax, QWORD PTR [r15]
	mov	edi, OFFSET FLAT:.LC44
	mov	QWORD PTR [rbp-192], rax
	mov	rax, QWORD PTR [r15+8]
	vmovsd	QWORD PTR [rbp-304], xmm0
	mov	QWORD PTR [rbp-200], rax
	mov	rax, QWORD PTR [r15+16]
	mov	r12, QWORD PTR [rbp-144]
	mov	QWORD PTR [rbp-208], rax
	mov	rbx, QWORD PTR [rbp-136]
	mov	r13, QWORD PTR [rbp-128]
	call	likwid_markerStartRegion
.L408:
	mov	rax, QWORD PTR [rbp-192]
	mov	QWORD PTR [rbp-248], r12
	mov	QWORD PTR [rbp-280], rax
	mov	rax, QWORD PTR [rbp-200]
	mov	QWORD PTR [rbp-240], rbx
	mov	QWORD PTR [rbp-272], rax
	mov	rax, QWORD PTR [rbp-208]
	mov	QWORD PTR [rbp-232], r13
	mov	QWORD PTR [rbp-264], rax
	mov	QWORD PTR [rbp-216], 63
	mov	rax, QWORD PTR [rbp-160]
	vmovdqa64	ymm30, YMMWORD PTR .LC47[rip]
	mov	QWORD PTR [rbp-256], rax
	xor	eax, eax
.L411:
	mov	rbx, rax
	inc	rax
	sal	rbx, 8
	mov	QWORD PTR [rbp-312], rax
	sal	rax, 8
	cmp	QWORD PTR [rbp-176], 0
	mov	QWORD PTR [rbp-224], rbx
	je	.L417
	mov	rbx, QWORD PTR [rbp-176]
	cmp	rax, rbx
	cmova	rax, rbx
	xor	ebx, ebx
	mov	r13, rax
	.p2align 4,,10
	.p2align 3
.L418:
	mov	rax, rbx
	shr	rax, 3
	add	rax, QWORD PTR [rbp-184]
	movzx	edx, BYTE PTR [rax]
	mov	rdi, rax
	mov	QWORD PTR [rbp-152], rax
	mov	eax, ebx
	and	eax, 7
	mov	ecx, 1
	shlx	eax, ecx, eax
	mov	DWORD PTR [rbp-168], eax
	xor	eax, edx
	mov	BYTE PTR [rdi], al
	mov	rax, QWORD PTR [rbp-160]
	lea	r14, [0+rbx*8]
	vmovsd	xmm21, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp-192]
	vxorpd	xmm21, xmm21, XMMWORD PTR .LC16[rip]
	vbroadcastsd	zmm4, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp-200]
	vbroadcastsd	zmm22, xmm21
	vbroadcastsd	zmm3, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp-208]
	vbroadcastsd	zmm1, QWORD PTR .LC35[rip]
	vbroadcastsd	zmm2, QWORD PTR [rax+rbx*8]
	vbroadcastsd	zmm0, QWORD PTR .LC36[rip]
	cmp	QWORD PTR [rbp-216], r13
	jnb	.L462
	mov	r8, QWORD PTR [rbp-232]
	mov	rdi, QWORD PTR [rbp-240]
	mov	rsi, QWORD PTR [rbp-248]
	mov	r9, QWORD PTR [rbp-256]
	mov	rcx, QWORD PTR [rbp-264]
	mov	rdx, QWORD PTR [rbp-272]
	mov	rax, QWORD PTR [rbp-280]
	mov	r10, QWORD PTR [rbp-224]
	.p2align 4,,10
	.p2align 3
.L412:
	vsubpd	zmm17, zmm4, ZMMWORD PTR [rax]
	vsubpd	zmm13, zmm4, ZMMWORD PTR [rax+64]
	vsubpd	zmm9, zmm4, ZMMWORD PTR [rax+128]
	vsubpd	zmm5, zmm4, ZMMWORD PTR [rax+192]
	vsubpd	zmm18, zmm4, ZMMWORD PTR [rax+256]
	vsubpd	zmm14, zmm4, ZMMWORD PTR [rax+320]
	vsubpd	zmm10, zmm4, ZMMWORD PTR [rax+384]
	vsubpd	zmm6, zmm4, ZMMWORD PTR [rax+448]
	vsubpd	zmm19, zmm3, ZMMWORD PTR [rdx]
	vsubpd	zmm15, zmm3, ZMMWORD PTR [rdx+64]
	vsubpd	zmm11, zmm3, ZMMWORD PTR [rdx+128]
	vsubpd	zmm7, zmm3, ZMMWORD PTR [rdx+192]
	vsubpd	zmm20, zmm3, ZMMWORD PTR [rdx+256]
	vsubpd	zmm16, zmm3, ZMMWORD PTR [rdx+320]
	vsubpd	zmm12, zmm3, ZMMWORD PTR [rdx+384]
	vsubpd	zmm8, zmm3, ZMMWORD PTR [rdx+448]
	vsubpd	zmm31, zmm2, ZMMWORD PTR [rcx]
	vsubpd	zmm29, zmm2, ZMMWORD PTR [rcx+64]
	vsubpd	zmm28, zmm2, ZMMWORD PTR [rcx+128]
	vsubpd	zmm27, zmm2, ZMMWORD PTR [rcx+192]
	vsubpd	zmm26, zmm2, ZMMWORD PTR [rcx+256]
	vsubpd	zmm25, zmm2, ZMMWORD PTR [rcx+320]
	vsubpd	zmm24, zmm2, ZMMWORD PTR [rcx+384]
	vsubpd	zmm23, zmm2, ZMMWORD PTR [rcx+448]
	vmulpd	zmm19, zmm19, zmm19
	vmulpd	zmm15, zmm15, zmm15
	vmulpd	zmm11, zmm11, zmm11
	vmulpd	zmm7, zmm7, zmm7
	vmulpd	zmm20, zmm20, zmm20
	vmulpd	zmm16, zmm16, zmm16
	vmulpd	zmm12, zmm12, zmm12
	vmulpd	zmm8, zmm8, zmm8
	vfmadd132pd	zmm17, zmm19, zmm17
	vfmadd132pd	zmm13, zmm15, zmm13
	vfmadd132pd	zmm9, zmm11, zmm9
	vfmadd132pd	zmm5, zmm7, zmm5
	vfmadd132pd	zmm18, zmm20, zmm18
	vfmadd132pd	zmm14, zmm16, zmm14
	vfmadd132pd	zmm10, zmm12, zmm10
	vfmadd132pd	zmm6, zmm8, zmm6
	vfmadd132pd	zmm31, zmm17, zmm31
	vfmadd132pd	zmm29, zmm13, zmm29
	vfmadd132pd	zmm28, zmm9, zmm28
	vfmadd132pd	zmm27, zmm5, zmm27
	vfmadd132pd	zmm26, zmm18, zmm26
	vfmadd132pd	zmm25, zmm14, zmm25
	vfmadd132pd	zmm24, zmm10, zmm24
	vfmadd132pd	zmm23, zmm6, zmm23
	vrsqrt14pd	zmm19, zmm31
	vrsqrt14pd	zmm17, zmm29
	vrsqrt14pd	zmm15, zmm28
	vrsqrt14pd	zmm13, zmm27
	vrsqrt14pd	zmm11, zmm26
	vrsqrt14pd	zmm9, zmm25
	vrsqrt14pd	zmm7, zmm24
	vrsqrt14pd	zmm5, zmm23
	vmulpd	zmm20, zmm19, zmm19
	vmulpd	zmm18, zmm17, zmm17
	vmulpd	zmm16, zmm15, zmm15
	vmulpd	zmm14, zmm13, zmm13
	vmulpd	zmm12, zmm11, zmm11
	vmulpd	zmm10, zmm9, zmm9
	vmulpd	zmm8, zmm7, zmm7
	vmulpd	zmm6, zmm5, zmm5
	vfnmadd132pd	zmm20, zmm1, zmm31
	vfnmadd132pd	zmm18, zmm1, zmm29
	vfnmadd132pd	zmm16, zmm1, zmm28
	vfnmadd132pd	zmm14, zmm1, zmm27
	vfnmadd132pd	zmm12, zmm1, zmm26
	vfnmadd132pd	zmm10, zmm1, zmm25
	vfnmadd132pd	zmm8, zmm1, zmm24
	vfnmadd132pd	zmm6, zmm1, zmm23
	vmulpd	zmm19, zmm0, zmm19
	vmulpd	zmm17, zmm0, zmm17
	vmulpd	zmm15, zmm0, zmm15
	vmulpd	zmm13, zmm0, zmm13
	vmulpd	zmm11, zmm0, zmm11
	vmulpd	zmm9, zmm0, zmm9
	vmulpd	zmm7, zmm0, zmm7
	vmulpd	zmm5, zmm0, zmm5
	vmulpd	zmm20, zmm19, zmm20
	vmulpd	zmm18, zmm17, zmm18
	vmulpd	zmm16, zmm15, zmm16
	vmulpd	zmm14, zmm13, zmm14
	vmulpd	zmm12, zmm11, zmm12
	vmulpd	zmm10, zmm9, zmm10
	vmulpd	zmm8, zmm7, zmm8
	vmulpd	zmm6, zmm5, zmm6
	vmulpd	zmm19, zmm20, zmm20
	vmulpd	zmm17, zmm18, zmm18
	vmulpd	zmm15, zmm16, zmm16
	vmulpd	zmm13, zmm14, zmm14
	vmulpd	zmm11, zmm12, zmm12
	vmulpd	zmm9, zmm10, zmm10
	vmulpd	zmm7, zmm8, zmm8
	vmulpd	zmm5, zmm6, zmm6
	vfnmadd132pd	zmm31, zmm1, zmm19
	vfnmadd132pd	zmm29, zmm1, zmm17
	vfnmadd132pd	zmm28, zmm1, zmm15
	vfnmadd132pd	zmm27, zmm1, zmm13
	vfnmadd132pd	zmm26, zmm1, zmm11
	vfnmadd132pd	zmm25, zmm1, zmm9
	vfnmadd132pd	zmm24, zmm1, zmm7
	vfnmadd132pd	zmm23, zmm1, zmm5
	vmulpd	zmm19, zmm0, zmm20
	vmulpd	zmm17, zmm0, zmm18
	vmulpd	zmm15, zmm0, zmm16
	vmulpd	zmm13, zmm0, zmm14
	vmulpd	zmm11, zmm0, zmm12
	vmulpd	zmm9, zmm0, zmm10
	vmulpd	zmm7, zmm0, zmm8
	vmulpd	zmm5, zmm0, zmm6
	vmulpd	zmm19, zmm19, zmm31
	vmulpd	zmm17, zmm17, zmm29
	vmulpd	zmm15, zmm15, zmm28
	vmulpd	zmm13, zmm13, zmm27
	vmulpd	zmm11, zmm11, zmm26
	vmulpd	zmm9, zmm9, zmm25
	vmulpd	zmm7, zmm7, zmm24
	vmulpd	zmm5, zmm5, zmm23
	vmulpd	zmm23, zmm22, ZMMWORD PTR [r9]
	vmulpd	zmm20, zmm22, ZMMWORD PTR [r9+64]
	vmulpd	zmm18, zmm22, ZMMWORD PTR [r9+128]
	vmulpd	zmm16, zmm22, ZMMWORD PTR [r9+192]
	vmulpd	zmm14, zmm22, ZMMWORD PTR [r9+256]
	vmulpd	zmm12, zmm22, ZMMWORD PTR [r9+320]
	vmulpd	zmm10, zmm22, ZMMWORD PTR [r9+384]
	vmulpd	zmm8, zmm22, ZMMWORD PTR [r9+448]
	vmulpd	zmm6, zmm19, zmm19
	vmulpd	zmm19, zmm6, zmm19
	vmulpd	zmm6, zmm17, zmm17
	vmulpd	zmm19, zmm19, zmm23
	vmulpd	zmm17, zmm6, zmm17
	vmulpd	zmm6, zmm15, zmm15
	vmulpd	zmm17, zmm17, zmm20
	vmulpd	zmm15, zmm6, zmm15
	vmulpd	zmm6, zmm13, zmm13
	vmulpd	zmm15, zmm15, zmm18
	vmulpd	zmm13, zmm6, zmm13
	vmulpd	zmm6, zmm11, zmm11
	vmulpd	zmm13, zmm13, zmm16
	vmulpd	zmm11, zmm6, zmm11
	vmulpd	zmm6, zmm9, zmm9
	vmulpd	zmm11, zmm11, zmm14
	vmulpd	zmm9, zmm6, zmm9
	vmulpd	zmm6, zmm7, zmm7
	vmulpd	zmm9, zmm9, zmm12
	vmulpd	zmm7, zmm6, zmm7
	vmulpd	zmm6, zmm5, zmm5
	vmulpd	zmm7, zmm7, zmm10
	vmulpd	zmm5, zmm6, zmm5
	vmulpd	zmm5, zmm5, zmm8
	vsubpd	zmm20, zmm4, ZMMWORD PTR [rax]
	vsubpd	zmm18, zmm4, ZMMWORD PTR [rax+64]
	vsubpd	zmm16, zmm4, ZMMWORD PTR [rax+128]
	vsubpd	zmm14, zmm4, ZMMWORD PTR [rax+192]
	vsubpd	zmm12, zmm4, ZMMWORD PTR [rax+256]
	vsubpd	zmm10, zmm4, ZMMWORD PTR [rax+320]
	vsubpd	zmm8, zmm4, ZMMWORD PTR [rax+384]
	vsubpd	zmm6, zmm4, ZMMWORD PTR [rax+448]
	vfnmadd213pd	zmm20, zmm19, ZMMWORD PTR [rsi]
	vfnmadd213pd	zmm18, zmm17, ZMMWORD PTR [rsi+64]
	vfnmadd213pd	zmm16, zmm15, ZMMWORD PTR [rsi+128]
	vfnmadd213pd	zmm14, zmm13, ZMMWORD PTR [rsi+192]
	vfnmadd213pd	zmm12, zmm11, ZMMWORD PTR [rsi+256]
	vfnmadd213pd	zmm10, zmm9, ZMMWORD PTR [rsi+320]
	vfnmadd213pd	zmm8, zmm7, ZMMWORD PTR [rsi+384]
	vfnmadd213pd	zmm6, zmm5, ZMMWORD PTR [rsi+448]
	vmovapd	ZMMWORD PTR [rsi], zmm20
	vmovapd	ZMMWORD PTR [rsi+64], zmm18
	vmovapd	ZMMWORD PTR [rsi+128], zmm16
	vmovapd	ZMMWORD PTR [rsi+192], zmm14
	vmovapd	ZMMWORD PTR [rsi+256], zmm12
	vmovapd	ZMMWORD PTR [rsi+320], zmm10
	vmovapd	ZMMWORD PTR [rsi+384], zmm8
	vmovapd	ZMMWORD PTR [rsi+448], zmm6
	vsubpd	zmm20, zmm3, ZMMWORD PTR [rdx]
	vsubpd	zmm18, zmm3, ZMMWORD PTR [rdx+64]
	vsubpd	zmm16, zmm3, ZMMWORD PTR [rdx+128]
	vsubpd	zmm14, zmm3, ZMMWORD PTR [rdx+192]
	vsubpd	zmm12, zmm3, ZMMWORD PTR [rdx+256]
	vsubpd	zmm10, zmm3, ZMMWORD PTR [rdx+320]
	vsubpd	zmm8, zmm3, ZMMWORD PTR [rdx+384]
	vsubpd	zmm6, zmm3, ZMMWORD PTR [rdx+448]
	vfnmadd213pd	zmm20, zmm19, ZMMWORD PTR [rdi]
	vfnmadd213pd	zmm18, zmm17, ZMMWORD PTR [rdi+64]
	vfnmadd213pd	zmm16, zmm15, ZMMWORD PTR [rdi+128]
	vfnmadd213pd	zmm14, zmm13, ZMMWORD PTR [rdi+192]
	vfnmadd213pd	zmm12, zmm11, ZMMWORD PTR [rdi+256]
	vfnmadd213pd	zmm10, zmm9, ZMMWORD PTR [rdi+320]
	vfnmadd213pd	zmm8, zmm7, ZMMWORD PTR [rdi+384]
	vfnmadd213pd	zmm6, zmm5, ZMMWORD PTR [rdi+448]
	vmovapd	ZMMWORD PTR [rdi], zmm20
	vmovapd	ZMMWORD PTR [rdi+64], zmm18
	vmovapd	ZMMWORD PTR [rdi+128], zmm16
	vmovapd	ZMMWORD PTR [rdi+192], zmm14
	vmovapd	ZMMWORD PTR [rdi+256], zmm12
	vmovapd	ZMMWORD PTR [rdi+320], zmm10
	vmovapd	ZMMWORD PTR [rdi+384], zmm8
	vmovapd	ZMMWORD PTR [rdi+448], zmm6
	vsubpd	zmm20, zmm2, ZMMWORD PTR [rcx]
	vsubpd	zmm18, zmm2, ZMMWORD PTR [rcx+64]
	vsubpd	zmm16, zmm2, ZMMWORD PTR [rcx+128]
	vsubpd	zmm14, zmm2, ZMMWORD PTR [rcx+192]
	vsubpd	zmm12, zmm2, ZMMWORD PTR [rcx+256]
	vsubpd	zmm10, zmm2, ZMMWORD PTR [rcx+320]
	vsubpd	zmm8, zmm2, ZMMWORD PTR [rcx+384]
	vsubpd	zmm6, zmm2, ZMMWORD PTR [rcx+448]
	vfnmadd213pd	zmm19, zmm20, ZMMWORD PTR [r8]
	vfnmadd213pd	zmm17, zmm18, ZMMWORD PTR [r8+64]
	vfnmadd213pd	zmm15, zmm16, ZMMWORD PTR [r8+128]
	vfnmadd213pd	zmm13, zmm14, ZMMWORD PTR [r8+192]
	vfnmadd213pd	zmm11, zmm12, ZMMWORD PTR [r8+256]
	vfnmadd213pd	zmm9, zmm10, ZMMWORD PTR [r8+320]
	vfnmadd213pd	zmm7, zmm8, ZMMWORD PTR [r8+384]
	vfnmadd213pd	zmm5, zmm6, ZMMWORD PTR [r8+448]
	vmovapd	ZMMWORD PTR [r8], zmm19
	vmovapd	ZMMWORD PTR [r8+64], zmm17
	vmovapd	ZMMWORD PTR [r8+128], zmm15
	vmovapd	ZMMWORD PTR [r8+192], zmm13
	vmovapd	ZMMWORD PTR [r8+256], zmm11
	vmovapd	ZMMWORD PTR [r8+320], zmm9
	vmovapd	ZMMWORD PTR [r8+384], zmm7
	vmovapd	ZMMWORD PTR [r8+448], zmm5
	lea	r11, [r10+64]
	lea	r12, [r10+127]
	add	rax, 512
	add	rdx, 512
	add	rcx, 512
	add	r9, 512
	add	rsi, 512
	add	rdi, 512
	add	r8, 512
	mov	r10, r11
	cmp	r12, r13
	jb	.L412
	mov	rax, QWORD PTR [rbp-152]
	movzx	edx, BYTE PTR [rbp-168]
	xor	dl, BYTE PTR [rax]
.L415:
	lea	rax, [r11+7]
	cmp	r13, rax
	jbe	.L463
	lea	rax, [r13-8]
	sub	rax, r11
	cmp	rax, 207
	jbe	.L419
	shr	rax, 3
	lea	rcx, [rax+1]
	vpbroadcastq	ymm0, r11
	mov	rsi, rcx
	vpaddq	ymm0, ymm0, YMMWORD PTR .LC46[rip]
	shr	rsi, 2
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L421:
	inc	rax
	vpaddq	ymm1, ymm0, YMMWORD PTR .LC48[rip]
	vpaddq	ymm0, ymm0, ymm30
	cmp	rax, rsi
	jb	.L421
	mov	rax, rcx
	vextracti64x2	xmm1, ymm1, 0x1
	and	rax, -4
	vpextrq	r12, xmm1, 1
	lea	rsi, [r11+rax*8]
	cmp	rcx, rax
	je	.L413
	lea	rax, [rsi+15]
	lea	r12, [rsi+8]
	cmp	rax, r13
	jnb	.L413
	lea	rax, [rsi+23]
	lea	r12, [rsi+24]
	add	rsi, 16
	cmp	r13, rax
	cmovbe	r12, rsi
.L413:
	vxorpd	xmm6, xmm6, xmm6
	mov	rsi, QWORD PTR [rbp-160]
	cmp	r12, r13
	jnb	.L426
	.p2align 4,,10
	.p2align 3
.L416:
	cmp	rbx, r12
	je	.L424
	mov	rcx, QWORD PTR [r15]
	lea	rax, [0+r12*8]
	vmovsd	xmm3, QWORD PTR [rcx+r14]
	vsubsd	xmm3, xmm3, QWORD PTR [rcx+r12*8]
	mov	rcx, QWORD PTR [r15+8]
	vmovsd	xmm2, QWORD PTR [rcx+r14]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+r12*8]
	mov	rcx, QWORD PTR [r15+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rcx+r14]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+r12*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm6, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L464
.L425:
	vmulsd	xmm4, xmm21, QWORD PTR [rsi+r12*8]
	vmulsd	xmm0, xmm5, xmm5
	mov	rcx, QWORD PTR [rbp-144]
	add	rcx, rax
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vmovsd	xmm5, QWORD PTR [rcx]
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vsubsd	xmm3, xmm5, xmm3
	vmovsd	QWORD PTR [rcx], xmm3
	mov	rcx, QWORD PTR [rbp-136]
	add	rcx, rax
	vmovsd	xmm3, QWORD PTR [rcx]
	add	rax, QWORD PTR [rbp-128]
	vdivsd	xmm1, xmm1, xmm0
	vsubsd	xmm2, xmm3, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
.L424:
	inc	r12
	cmp	r12, r13
	jne	.L416
.L426:
	mov	rax, QWORD PTR [rbp-152]
	inc	rbx
	mov	BYTE PTR [rax], dl
	cmp	rbx, QWORD PTR [rbp-176]
	jne	.L418
.L417:
	mov	rax, QWORD PTR [rbp-312]
	add	QWORD PTR [rbp-216], 256
	add	QWORD PTR [rbp-280], 2048
	add	QWORD PTR [rbp-272], 2048
	add	QWORD PTR [rbp-264], 2048
	add	QWORD PTR [rbp-256], 2048
	add	QWORD PTR [rbp-248], 2048
	add	QWORD PTR [rbp-240], 2048
	add	QWORD PTR [rbp-232], 2048
	cmp	rax, QWORD PTR [rbp-296]
	jb	.L411
	vzeroupper
.L409:
	mov	edi, OFFSET FLAT:.LC44
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	r15, QWORD PTR [rbp-288]
	mov	edi, 64
	mov	rsi, r15
	vmovsd	QWORD PTR [rbp-152], xmm0
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	rbx, rax
	mov	QWORD PTR [rbp-112], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	QWORD PTR [rbp-288], r15
	mov	r14, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	rsi, QWORD PTR [rbp-288]
	mov	edi, 64
	mov	r15, rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	cmp	QWORD PTR [rbp-176], 0
	mov	QWORD PTR [rbp-64], rax
	je	.L430
	mov	rcx, QWORD PTR [rbp-328]
	mov	rdx, QWORD PTR [rbp-320]
	mov	r9, QWORD PTR [rcx]
	mov	rdi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	r10, QWORD PTR [rdx]
	mov	r8, QWORD PTR [rdx+8]
	mov	rsi, QWORD PTR [rdx+16]
	xor	edx, edx
.L431:
	vmovsd	xmm0, QWORD PTR [r10+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [r9+rdx*8]
	mov	QWORD PTR [rbx+rdx*8], 0x000000000
	vmovsd	QWORD PTR [r14+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [r8+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	mov	QWORD PTR [r12+rdx*8], 0x000000000
	vmovsd	QWORD PTR [r15+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rdx*8]
	mov	QWORD PTR [r13+0+rdx*8], 0x000000000
	vmovsd	QWORD PTR [rax+rdx*8], xmm0
	inc	rdx
	cmp	rdx, QWORD PTR [rbp-176]
	jne	.L431
.L430:
	lea	rcx, [rbp-112]
	mov	r8d, DWORD PTR [rbp-176]
	lea	rdx, [rbp-80]
	mov	rsi, rcx
	lea	rdi, [rbp-144]
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L465
	mov	rax, QWORD PTR [rbp-176]
	lea	rdx, [rax-1]
	imul	rdx, rax
	test	rdx, rdx
	js	.L432
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L433:
	vmovsd	xmm30, QWORD PTR [rbp-152]
	mov	edi, OFFSET FLAT:.LC37
	vsubsd	xmm1, xmm30, QWORD PTR [rbp-304]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-152], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-152]
	jmp	.L434
	.p2align 4,,10
	.p2align 3
.L419:
	lea	r12, [r11+8]
	lea	rax, [r11+15]
	mov	r11, r12
	cmp	r13, rax
	jbe	.L413
	lea	r12, [r11+8]
	lea	rax, [r11+15]
	mov	r11, r12
	cmp	r13, rax
	ja	.L419
	jmp	.L413
.L463:
	mov	r12, r11
	jmp	.L413
.L462:
	mov	r11, QWORD PTR [rbp-224]
	jmp	.L415
.L465:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC38
	xor	eax, eax
	call	printf
	vmovsd	xmm30, QWORD PTR [rbp-152]
	vsubsd	xmm1, xmm30, QWORD PTR [rbp-304]
.L434:
	mov	rdi, QWORD PTR [rbp-144]
	vmovsd	QWORD PTR [rbp-152], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-136]
	call	free
	mov	rdi, QWORD PTR [rbp-128]
	call	free
	mov	rdi, QWORD PTR [rbp-112]
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	mov	rdi, QWORD PTR [rbp-184]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-152]
	add	rsp, 384
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L461:
	.cfi_restore_state
	call	omp_get_wtime
	mov	rax, QWORD PTR [r15]
	mov	edi, OFFSET FLAT:.LC44
	mov	QWORD PTR [rbp-192], rax
	mov	rax, QWORD PTR [r15+8]
	vmovsd	QWORD PTR [rbp-304], xmm0
	mov	QWORD PTR [rbp-200], rax
	mov	rax, QWORD PTR [r15+16]
	mov	r12, QWORD PTR [rbp-144]
	mov	QWORD PTR [rbp-208], rax
	mov	rbx, QWORD PTR [rbp-136]
	mov	r13, QWORD PTR [rbp-128]
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-296], 0
	jne	.L408
	jmp	.L409
.L402:
	mov	rdi, rbx
	call	malloc
	mov	QWORD PTR [rbp-184], rax
	mov	rax, QWORD PTR [rbp-176]
	mov	rdi, rax
	shr	rdi, 8
	mov	QWORD PTR [rbp-296], rdi
	test	rax, rax
	je	.L466
	mov	rdx, QWORD PTR [rbp-288]
	xor	esi, esi
	mov	rdi, r14
	call	memset
	mov	r14, QWORD PTR [rbp-288]
	xor	esi, esi
	mov	rdx, r14
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, r14
	mov	rdi, r12
	call	memset
	test	rbx, rbx
	jne	.L403
	jmp	.L407
.L432:
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L433
.L464:
	mov	QWORD PTR [rbp-384], rsi
	mov	BYTE PTR [rbp-369], dl
	vmovsd	QWORD PTR [rbp-368], xmm21
	mov	QWORD PTR [rbp-360], rax
	vmovsd	QWORD PTR [rbp-352], xmm5
	vmovsd	QWORD PTR [rbp-344], xmm1
	vmovsd	QWORD PTR [rbp-336], xmm2
	vmovsd	QWORD PTR [rbp-168], xmm3
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-384]
	movzx	edx, BYTE PTR [rbp-369]
	vmovsd	xmm21, QWORD PTR [rbp-368]
	vmovdqa64	ymm30, YMMWORD PTR .LC47[rip]
	vxorpd	xmm6, xmm6, xmm6
	mov	rax, QWORD PTR [rbp-360]
	vmovsd	xmm5, QWORD PTR [rbp-352]
	vmovsd	xmm1, QWORD PTR [rbp-344]
	vmovsd	xmm2, QWORD PTR [rbp-336]
	vmovsd	xmm3, QWORD PTR [rbp-168]
	jmp	.L425
.L466:
	mov	edi, OFFSET FLAT:.LC43
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC44
	vmovsd	QWORD PTR [rbp-304], xmm0
	call	likwid_markerStartRegion
	jmp	.L409
	.cfi_endproc
.LFE8610:
	.size	_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_, .-_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC49:
	.string	"AVX512-rsqrt-4i["
	.section	.rodata.str1.8
	.align 8
.LC50:
	.string	"reduced-vectorized-AVX512-rsqrt"
	.text
	.p2align 4,,15
	.globl	_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.type	_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_, @function
_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_:
.LFB8611:
	.cfi_startproc
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -64
	push	QWORD PTR [r10-8]
	push	rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	mov	rbp, rsp
	push	r15
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	lea	rbx, [0+rdi*8]
	sub	rsp, 256
	mov	QWORD PTR [rbp-144], rsi
	mov	QWORD PTR [rbp-184], rdi
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-136], rdx
	mov	QWORD PTR [rbp-216], rcx
	mov	QWORD PTR [rbp-224], r8
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rbp-112], rax
	mov	QWORD PTR [rbp-128], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r15, rax
	mov	QWORD PTR [rbp-104], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rbp-96], rax
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	r13, rax
	mov	QWORD PTR [rbp-80], rax
	call	aligned_alloc
	mov	edi, 64
	mov	rsi, rbx
	mov	r12, rax
	mov	QWORD PTR [rbp-72], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-64], rax
	mov	QWORD PTR [rbp-120], rax
	mov	rax, QWORD PTR [rbp-184]
	mov	rdi, rax
	shr	rdi, 8
	mov	QWORD PTR [rbp-200], rdi
	test	rax, rax
	je	.L468
	mov	r8, QWORD PTR [rbp-128]
	xor	esi, esi
	mov	rdi, r8
	mov	rdx, rbx
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r15
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r14
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r13
	call	memset
	xor	esi, esi
	mov	rdx, rbx
	mov	rdi, r12
	call	memset
	mov	rcx, QWORD PTR [rbp-120]
	xor	esi, esi
	mov	rdi, rcx
	mov	rdx, rbx
	call	memset
	xor	eax, eax
	mov	edi, OFFSET FLAT:.LC49
	call	printf
	mov	r11, QWORD PTR [rbp-136]
	mov	r10, QWORD PTR [rbp-144]
	cmp	BYTE PTR [rbp-184], 0
	mov	QWORD PTR [rbp-120], r11
	mov	QWORD PTR [rbp-160], r10
	je	.L469
	inc	QWORD PTR [rbp-200]
	call	omp_get_wtime
	mov	r11, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC50
	mov	rax, QWORD PTR [r11]
	vmovsd	QWORD PTR [rbp-208], xmm0
	mov	QWORD PTR [rbp-144], rax
	mov	rax, QWORD PTR [r11+8]
	mov	r14, QWORD PTR [rbp-80]
	mov	QWORD PTR [rbp-136], rax
	mov	rax, QWORD PTR [r11+16]
	mov	r15, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-64]
	mov	QWORD PTR [rbp-152], rax
	call	likwid_markerStartRegion
	mov	r11, QWORD PTR [rbp-120]
	mov	r10, QWORD PTR [rbp-160]
.L470:
	vmovq	xmm30, QWORD PTR .LC16[rip]
	mov	r12, r10
	xor	eax, eax
	mov	r10, r14
	mov	r14, r11
.L473:
	mov	rdi, rax
	sal	rdi, 8
	inc	rax
	mov	QWORD PTR [rbp-168], rdi
	mov	rdi, QWORD PTR [rbp-184]
	mov	QWORD PTR [rbp-192], rax
	sal	rax, 8
	cmp	rax, rdi
	cmova	rax, rdi
	mov	QWORD PTR [rbp-120], 0
	mov	r11, rax
	lea	rax, [0+rax*8]
	mov	QWORD PTR [rbp-176], rax
	.p2align 4,,10
	.p2align 3
.L472:
	mov	rax, QWORD PTR [rbp-120]
	mov	rbx, QWORD PTR [rbp-168]
	vmovsd	xmm8, QWORD PTR [r12+rax*8]
	lea	r13, [0+rax*8]
	inc	rax
	cmp	rax, rbx
	cmovnb	rbx, rax
	mov	QWORD PTR [rbp-120], rax
	mov	rax, rbx
	vxorpd	xmm8, xmm8, xmm30
	and	eax, 7
	jne	.L508
.L474:
	mov	rax, QWORD PTR [rbp-120]
	mov	rdi, QWORD PTR [rbp-144]
	mov	rsi, QWORD PTR [rbp-136]
	mov	rcx, QWORD PTR [rbp-128]
	vxorpd	xmm21, xmm21, xmm21
	vbroadcastsd	zmm17, QWORD PTR [rdi-8+rax*8]
	vbroadcastsd	zmm16, QWORD PTR [rsi-8+rax*8]
	vbroadcastsd	zmm15, QWORD PTR [rcx-8+rax*8]
	lea	rax, [rbx+31]
	vbroadcastsd	zmm18, xmm8
	vbroadcastsd	zmm14, QWORD PTR .LC35[rip]
	vbroadcastsd	zmm13, QWORD PTR .LC36[rip]
	vmovapd	zmm27, zmm21
	vmovapd	zmm19, zmm21
	cmp	r11, rax
	jbe	.L491
	mov	QWORD PTR [rbp-160], r15
	lea	rdx, [0+rbx*8]
	lea	r9, [rdi+rdx]
	lea	r8, [rsi+rdx]
	lea	rdi, [rcx+rdx]
	lea	rsi, [r10+rdx]
	lea	rcx, [r15+rdx]
	vmovapd	zmm22, zmm21
	add	rdx, QWORD PTR [rbp-152]
	vmovapd	zmm23, zmm21
	vmovapd	zmm24, zmm21
	vmovapd	zmm25, zmm21
	vmovapd	zmm26, zmm21
	vmovapd	zmm20, zmm21
	vmovapd	zmm28, zmm21
	vmovapd	zmm29, zmm21
	vmovapd	zmm31, zmm21
	.p2align 4,,10
	.p2align 3
.L479:
	vsubpd	zmm9, zmm17, ZMMWORD PTR [r9]
	vsubpd	zmm4, zmm17, ZMMWORD PTR [r9+64]
	vsubpd	zmm10, zmm17, ZMMWORD PTR [r9+128]
	vsubpd	zmm5, zmm17, ZMMWORD PTR [r9+192]
	vsubpd	zmm11, zmm16, ZMMWORD PTR [r8]
	vsubpd	zmm6, zmm16, ZMMWORD PTR [r8+64]
	vsubpd	zmm12, zmm16, ZMMWORD PTR [r8+128]
	vsubpd	zmm7, zmm16, ZMMWORD PTR [r8+192]
	vsubpd	zmm3, zmm15, ZMMWORD PTR [rdi]
	vsubpd	zmm2, zmm15, ZMMWORD PTR [rdi+64]
	vsubpd	zmm1, zmm15, ZMMWORD PTR [rdi+128]
	vsubpd	zmm0, zmm15, ZMMWORD PTR [rdi+192]
	vmulpd	zmm11, zmm11, zmm11
	vmulpd	zmm6, zmm6, zmm6
	vmulpd	zmm12, zmm12, zmm12
	vmulpd	zmm7, zmm7, zmm7
	vfmadd132pd	zmm9, zmm11, zmm9
	vfmadd132pd	zmm4, zmm6, zmm4
	vfmadd132pd	zmm10, zmm12, zmm10
	vfmadd132pd	zmm5, zmm7, zmm5
	vfmadd132pd	zmm3, zmm9, zmm3
	vfmadd132pd	zmm2, zmm4, zmm2
	vfmadd132pd	zmm1, zmm10, zmm1
	vfmadd132pd	zmm0, zmm5, zmm0
	vrsqrt14pd	zmm11, zmm3
	vrsqrt14pd	zmm9, zmm2
	vrsqrt14pd	zmm6, zmm1
	vrsqrt14pd	zmm4, zmm0
	vmulpd	zmm12, zmm11, zmm11
	vmulpd	zmm10, zmm9, zmm9
	vmulpd	zmm7, zmm6, zmm6
	vmulpd	zmm5, zmm4, zmm4
	vfnmadd132pd	zmm12, zmm14, zmm3
	vfnmadd132pd	zmm10, zmm14, zmm2
	vfnmadd132pd	zmm7, zmm14, zmm1
	vfnmadd132pd	zmm5, zmm14, zmm0
	vmulpd	zmm11, zmm13, zmm11
	vmulpd	zmm9, zmm13, zmm9
	vmulpd	zmm6, zmm13, zmm6
	vmulpd	zmm4, zmm13, zmm4
	vmulpd	zmm12, zmm11, zmm12
	vmulpd	zmm10, zmm9, zmm10
	vmulpd	zmm7, zmm6, zmm7
	vmulpd	zmm5, zmm4, zmm5
	vmulpd	zmm11, zmm12, zmm12
	vmulpd	zmm9, zmm10, zmm10
	vmulpd	zmm6, zmm7, zmm7
	vmulpd	zmm4, zmm5, zmm5
	vfnmadd132pd	zmm3, zmm14, zmm11
	vfnmadd132pd	zmm2, zmm14, zmm9
	vfnmadd132pd	zmm1, zmm14, zmm6
	vfnmadd132pd	zmm0, zmm14, zmm4
	vmulpd	zmm11, zmm13, zmm12
	vmulpd	zmm9, zmm13, zmm10
	vmulpd	zmm6, zmm13, zmm7
	vmulpd	zmm4, zmm13, zmm5
	vmulpd	zmm11, zmm11, zmm3
	vmulpd	zmm9, zmm9, zmm2
	vmulpd	zmm6, zmm6, zmm1
	vmulpd	zmm4, zmm4, zmm0
	vmulpd	zmm2, zmm18, ZMMWORD PTR [r12+rbx*8]
	vmulpd	zmm1, zmm18, ZMMWORD PTR [r12+64+rbx*8]
	vmulpd	zmm0, zmm18, ZMMWORD PTR [r12+128+rbx*8]
	vmulpd	zmm5, zmm18, ZMMWORD PTR [r12+192+rbx*8]
	vmulpd	zmm3, zmm11, zmm11
	vmulpd	zmm3, zmm3, zmm11
	vmulpd	zmm3, zmm3, zmm2
	vmulpd	zmm2, zmm9, zmm9
	vmulpd	zmm2, zmm2, zmm9
	vmulpd	zmm2, zmm2, zmm1
	vmulpd	zmm1, zmm6, zmm6
	vmulpd	zmm1, zmm1, zmm6
	vmulpd	zmm1, zmm1, zmm0
	vmulpd	zmm0, zmm4, zmm4
	vmulpd	zmm0, zmm0, zmm4
	vmulpd	zmm0, zmm0, zmm5
	vsubpd	zmm7, zmm17, ZMMWORD PTR [r9]
	vsubpd	zmm6, zmm17, ZMMWORD PTR [r9+64]
	vsubpd	zmm5, zmm17, ZMMWORD PTR [r9+128]
	vsubpd	zmm4, zmm17, ZMMWORD PTR [r9+192]
	vfmadd231pd	zmm21, zmm7, zmm3
	vfmadd231pd	zmm31, zmm6, zmm2
	vfmadd231pd	zmm29, zmm5, zmm1
	vfmadd231pd	zmm28, zmm4, zmm0
	vfnmadd213pd	zmm7, zmm3, ZMMWORD PTR [rsi]
	vfnmadd213pd	zmm6, zmm2, ZMMWORD PTR [rsi+64]
	vfnmadd213pd	zmm5, zmm1, ZMMWORD PTR [rsi+128]
	vfnmadd213pd	zmm4, zmm0, ZMMWORD PTR [rsi+192]
	vmovapd	ZMMWORD PTR [rsi], zmm7
	vmovapd	ZMMWORD PTR [rsi+64], zmm6
	vmovapd	ZMMWORD PTR [rsi+128], zmm5
	vmovapd	ZMMWORD PTR [rsi+192], zmm4
	vsubpd	zmm7, zmm16, ZMMWORD PTR [r8]
	vsubpd	zmm6, zmm16, ZMMWORD PTR [r8+64]
	vsubpd	zmm5, zmm16, ZMMWORD PTR [r8+128]
	vsubpd	zmm4, zmm16, ZMMWORD PTR [r8+192]
	vfmadd231pd	zmm27, zmm7, zmm3
	vfmadd231pd	zmm20, zmm6, zmm2
	vfmadd231pd	zmm26, zmm5, zmm1
	vfmadd231pd	zmm25, zmm4, zmm0
	vfnmadd213pd	zmm7, zmm3, ZMMWORD PTR [rcx]
	vfnmadd213pd	zmm6, zmm2, ZMMWORD PTR [rcx+64]
	vfnmadd213pd	zmm5, zmm1, ZMMWORD PTR [rcx+128]
	vfnmadd213pd	zmm4, zmm0, ZMMWORD PTR [rcx+192]
	vmovapd	ZMMWORD PTR [rcx], zmm7
	vmovapd	ZMMWORD PTR [rcx+64], zmm6
	vmovapd	ZMMWORD PTR [rcx+128], zmm5
	vmovapd	ZMMWORD PTR [rcx+192], zmm4
	vsubpd	zmm7, zmm15, ZMMWORD PTR [rdi]
	vsubpd	zmm6, zmm15, ZMMWORD PTR [rdi+64]
	vsubpd	zmm5, zmm15, ZMMWORD PTR [rdi+128]
	vsubpd	zmm4, zmm15, ZMMWORD PTR [rdi+192]
	vfmadd231pd	zmm19, zmm7, zmm3
	vfmadd231pd	zmm24, zmm6, zmm2
	vfmadd231pd	zmm23, zmm5, zmm1
	vfmadd231pd	zmm22, zmm4, zmm0
	vfnmadd213pd	zmm3, zmm7, ZMMWORD PTR [rdx]
	vfnmadd213pd	zmm2, zmm6, ZMMWORD PTR [rdx+64]
	vfnmadd213pd	zmm1, zmm5, ZMMWORD PTR [rdx+128]
	vfnmadd213pd	zmm0, zmm4, ZMMWORD PTR [rdx+192]
	vmovapd	ZMMWORD PTR [rdx], zmm3
	vmovapd	ZMMWORD PTR [rdx+64], zmm2
	vmovapd	ZMMWORD PTR [rdx+128], zmm1
	vmovapd	ZMMWORD PTR [rdx+192], zmm0
	lea	rax, [rbx+32]
	lea	r15, [rbx+63]
	add	r9, 256
	add	r8, 256
	add	rdi, 256
	add	rsi, 256
	add	rcx, 256
	add	rdx, 256
	mov	rbx, rax
	cmp	r11, r15
	ja	.L479
	mov	r15, QWORD PTR [rbp-160]
.L478:
	vaddpd	zmm7, zmm21, zmm31
	vaddpd	zmm6, zmm20, zmm27
	vaddpd	zmm19, zmm19, zmm24
	vaddpd	zmm7, zmm7, zmm29
	vaddpd	zmm6, zmm6, zmm26
	vaddpd	zmm23, zmm19, zmm23
	lea	rdx, [rax+7]
	vaddpd	zmm7, zmm7, zmm28
	vaddpd	zmm6, zmm6, zmm25
	vaddpd	zmm22, zmm23, zmm22
	cmp	r11, rdx
	jbe	.L492
	mov	rdx, QWORD PTR [rbp-152]
	mov	rdi, QWORD PTR [rbp-128]
	mov	r8, QWORD PTR [rbp-136]
	mov	r9, QWORD PTR [rbp-144]
	.p2align 4,,10
	.p2align 3
.L481:
	vsubpd	zmm4, zmm16, ZMMWORD PTR [r8+rax*8]
	vsubpd	zmm5, zmm17, ZMMWORD PTR [r9+rax*8]
	vsubpd	zmm3, zmm15, ZMMWORD PTR [rdi+rax*8]
	vmulpd	zmm1, zmm4, zmm4
	lea	rcx, [rax+8]
	lea	rsi, [rax+15]
	vfmadd231pd	zmm1, zmm5, zmm5
	vfmadd231pd	zmm1, zmm3, zmm3
	vrsqrt14pd	zmm0, zmm1
	vmulpd	zmm2, zmm0, zmm0
	vmulpd	zmm0, zmm0, zmm13
	vfnmadd132pd	zmm2, zmm14, zmm1
	vmulpd	zmm2, zmm2, zmm0
	vmulpd	zmm0, zmm2, zmm2
	vfnmadd132pd	zmm1, zmm14, zmm0
	vmulpd	zmm0, zmm13, zmm2
	vmulpd	zmm0, zmm1, zmm0
	vmulpd	zmm1, zmm18, ZMMWORD PTR [r12+rax*8]
	vmulpd	zmm2, zmm0, zmm0
	vmulpd	zmm0, zmm2, zmm0
	vmulpd	zmm0, zmm1, zmm0
	vfmadd231pd	zmm6, zmm4, zmm0
	vfmadd231pd	zmm22, zmm3, zmm0
	vfnmadd213pd	zmm4, zmm0, ZMMWORD PTR [r15+rax*8]
	vfnmadd213pd	zmm3, zmm0, ZMMWORD PTR [rdx+rax*8]
	vfmadd231pd	zmm7, zmm5, zmm0
	vfnmadd213pd	zmm0, zmm5, ZMMWORD PTR [r10+rax*8]
	vmovapd	ZMMWORD PTR [r10+rax*8], zmm0
	vmovapd	ZMMWORD PTR [r15+rax*8], zmm4
	vmovapd	ZMMWORD PTR [rdx+rax*8], zmm3
	mov	rax, rcx
	cmp	rsi, r11
	jb	.L481
.L480:
	vextractf64x4	ymm0, zmm7, 0x1
	vaddpd	ymm7, ymm0, ymm7
	mov	rsi, QWORD PTR [rbp-112]
	mov	rdx, QWORD PTR [rbp-104]
	vextractf64x2	xmm0, ymm7, 0x1
	vaddpd	xmm0, xmm0, xmm7
	add	rsi, r13
	add	rdx, r13
	vhaddpd	xmm0, xmm0, xmm0
	mov	rax, QWORD PTR [rbp-96]
	lea	rbx, [0+rcx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	add	rax, r13
	mov	rdi, QWORD PTR [rbp-176]
	vmovsd	QWORD PTR [rsi], xmm0
	vextractf64x4	ymm0, zmm6, 0x1
	vaddpd	ymm6, ymm0, ymm6
	vextractf64x2	xmm0, ymm6, 0x1
	vaddpd	xmm0, xmm0, xmm6
	vxorpd	xmm6, xmm6, xmm6
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vextractf64x4	ymm0, zmm22, 0x1
	vaddpd	ymm22, ymm0, ymm22
	vextractf64x2	xmm0, ymm22, 0x1
	vaddpd	xmm0, xmm0, xmm22
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	cmp	r11, rcx
	jbe	.L485
	.p2align 4,,10
	.p2align 3
.L486:
	mov	rcx, QWORD PTR [r14]
	vmovsd	xmm3, QWORD PTR [rcx+r13]
	vsubsd	xmm3, xmm3, QWORD PTR [rcx+rbx]
	mov	rcx, QWORD PTR [r14+8]
	vmovsd	xmm2, QWORD PTR [rcx+r13]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+rbx]
	mov	rcx, QWORD PTR [r14+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rcx+r13]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm6, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L509
.L484:
	vmulsd	xmm4, xmm8, QWORD PTR [r12+rbx]
	vmulsd	xmm0, xmm5, xmm5
	mov	rcx, QWORD PTR [rbp-80]
	add	rcx, rbx
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	vmovsd	xmm0, QWORD PTR [rcx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rcx], xmm3
	mov	rcx, QWORD PTR [rbp-72]
	add	rcx, rbx
	vmovsd	xmm0, QWORD PTR [rcx]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	mov	rcx, QWORD PTR [rbp-64]
	add	rcx, rbx
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rbx, 8
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rcx], xmm1
	cmp	rdi, rbx
	jne	.L486
.L485:
	cmp	QWORD PTR [rbp-120], r11
	jne	.L472
	mov	rax, QWORD PTR [rbp-192]
	cmp	rax, QWORD PTR [rbp-200]
	jb	.L473
	vzeroupper
.L471:
	mov	edi, OFFSET FLAT:.LC50
	call	likwid_markerStopRegion
	call	omp_get_wtime
	mov	rbx, QWORD PTR [rbp-184]
	mov	rcx, QWORD PTR [rbp-224]
	mov	rdx, QWORD PTR [rbp-216]
	mov	r8d, ebx
	lea	rsi, [rbp-80]
	lea	rdi, [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm0
	call	_Z14compare_forcesPPdS0_S0_S0_idPKc.constprop.41
	test	eax, eax
	jne	.L487
	lea	rdx, [rbx-1]
	imul	rdx, rbx
	test	rdx, rdx
	js	.L488
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
.L489:
	vmovsd	xmm30, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC37
	vsubsd	xmm1, xmm30, QWORD PTR [rbp-208]
	mov	eax, 1
	vmulsd	xmm2, xmm1, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rbp-120], xmm1
	vdivsd	xmm0, xmm0, xmm2
	call	printf
	vmovsd	xmm1, QWORD PTR [rbp-120]
	jmp	.L490
	.p2align 4,,10
	.p2align 3
.L508:
	mov	esi, 8
	sub	rsi, rax
	cmp	rbx, r11
	jnb	.L474
	xor	edx, edx
	vxorpd	xmm6, xmm6, xmm6
	jmp	.L476
	.p2align 4,,10
	.p2align 3
.L475:
	vmulsd	xmm4, xmm8, QWORD PTR [r12+rbx*8]
	vmulsd	xmm0, xmm5, xmm5
	mov	rcx, QWORD PTR [rbp-112]
	inc	rdx
	add	rcx, r13
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	inc	rbx
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-104]
	add	rcx, r13
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-96]
	add	rcx, r13
	vaddsd	xmm0, xmm1, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rbp-80]
	add	rcx, rax
	vmovsd	xmm0, QWORD PTR [rcx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rcx], xmm3
	mov	rcx, QWORD PTR [rbp-72]
	add	rcx, rax
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rax, QWORD PTR [rbp-64]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rcx], xmm2
	vmovsd	xmm0, QWORD PTR [rax]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	cmp	rdx, rsi
	jnb	.L474
	cmp	rbx, r11
	jnb	.L474
.L476:
	mov	rcx, QWORD PTR [r14]
	lea	rax, [0+rbx*8]
	vmovsd	xmm3, QWORD PTR [rcx+r13]
	vsubsd	xmm3, xmm3, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r14+8]
	vmovsd	xmm2, QWORD PTR [rcx+r13]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+rbx*8]
	mov	rcx, QWORD PTR [r14+16]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [rcx+r13]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm6, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	jbe	.L475
	vmovsd	QWORD PTR [rbp-304], xmm6
	mov	QWORD PTR [rbp-296], rsi
	mov	QWORD PTR [rbp-288], r10
	mov	QWORD PTR [rbp-280], r11
	mov	QWORD PTR [rbp-272], rdx
	vmovsd	QWORD PTR [rbp-264], xmm8
	mov	QWORD PTR [rbp-256], rax
	vmovsd	QWORD PTR [rbp-248], xmm5
	vmovsd	QWORD PTR [rbp-240], xmm1
	vmovsd	QWORD PTR [rbp-232], xmm2
	vmovsd	QWORD PTR [rbp-160], xmm3
	vzeroupper
	call	sqrt
	vmovsd	xmm6, QWORD PTR [rbp-304]
	mov	rsi, QWORD PTR [rbp-296]
	mov	r10, QWORD PTR [rbp-288]
	mov	r11, QWORD PTR [rbp-280]
	mov	rdx, QWORD PTR [rbp-272]
	vmovsd	xmm8, QWORD PTR [rbp-264]
	vmovq	xmm30, QWORD PTR .LC16[rip]
	mov	rax, QWORD PTR [rbp-256]
	vmovsd	xmm5, QWORD PTR [rbp-248]
	vmovsd	xmm1, QWORD PTR [rbp-240]
	vmovsd	xmm2, QWORD PTR [rbp-232]
	vmovsd	xmm3, QWORD PTR [rbp-160]
	jmp	.L475
	.p2align 4,,10
	.p2align 3
.L492:
	mov	rcx, rax
	jmp	.L480
.L491:
	vxorpd	xmm22, xmm22, xmm22
	vmovapd	zmm23, zmm22
	vmovapd	zmm24, zmm22
	vmovapd	zmm25, zmm22
	vmovapd	zmm26, zmm22
	vmovapd	zmm20, zmm22
	vmovapd	zmm28, zmm22
	vmovapd	zmm29, zmm22
	vmovapd	zmm31, zmm22
	mov	rax, rbx
	jmp	.L478
.L487:
	mov	esi, eax
	mov	edi, OFFSET FLAT:.LC38
	xor	eax, eax
	call	printf
	vmovsd	xmm30, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm30, QWORD PTR [rbp-208]
.L490:
	mov	rdi, QWORD PTR [rbp-112]
	vmovsd	QWORD PTR [rbp-120], xmm1
	call	free
	mov	rdi, QWORD PTR [rbp-104]
	call	free
	mov	rdi, QWORD PTR [rbp-96]
	call	free
	mov	rdi, QWORD PTR [rbp-80]
	call	free
	mov	rdi, QWORD PTR [rbp-72]
	call	free
	mov	rdi, QWORD PTR [rbp-64]
	call	free
	vmovsd	xmm1, QWORD PTR [rbp-120]
	add	rsp, 256
	pop	rbx
	pop	r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	vmovapd	xmm0, xmm1
	pop	rbp
	lea	rsp, [r10-8]
	.cfi_def_cfa 7, 8
	ret
.L509:
	.cfi_restore_state
	vmovsd	QWORD PTR [rbp-288], xmm6
	mov	QWORD PTR [rbp-280], r10
	mov	QWORD PTR [rbp-272], r11
	vmovsd	QWORD PTR [rbp-264], xmm8
	mov	QWORD PTR [rbp-256], rdi
	vmovsd	QWORD PTR [rbp-248], xmm5
	vmovsd	QWORD PTR [rbp-240], xmm1
	vmovsd	QWORD PTR [rbp-232], xmm2
	vmovsd	QWORD PTR [rbp-160], xmm3
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-112]
	mov	rdx, QWORD PTR [rbp-104]
	mov	rax, QWORD PTR [rbp-96]
	add	rsi, r13
	add	rdx, r13
	add	rax, r13
	vmovsd	xmm6, QWORD PTR [rbp-288]
	mov	r10, QWORD PTR [rbp-280]
	mov	r11, QWORD PTR [rbp-272]
	vmovsd	xmm8, QWORD PTR [rbp-264]
	mov	rdi, QWORD PTR [rbp-256]
	vmovq	xmm30, QWORD PTR .LC16[rip]
	vmovsd	xmm5, QWORD PTR [rbp-248]
	vmovsd	xmm1, QWORD PTR [rbp-240]
	vmovsd	xmm2, QWORD PTR [rbp-232]
	vmovsd	xmm3, QWORD PTR [rbp-160]
	jmp	.L484
.L469:
	call	omp_get_wtime
	mov	r11, QWORD PTR [rbp-120]
	mov	edi, OFFSET FLAT:.LC50
	mov	rax, QWORD PTR [r11]
	vmovsd	QWORD PTR [rbp-208], xmm0
	mov	QWORD PTR [rbp-144], rax
	mov	rax, QWORD PTR [r11+8]
	mov	r14, QWORD PTR [rbp-80]
	mov	QWORD PTR [rbp-136], rax
	mov	rax, QWORD PTR [r11+16]
	mov	r15, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-64]
	mov	QWORD PTR [rbp-152], rax
	call	likwid_markerStartRegion
	cmp	QWORD PTR [rbp-200], 0
	mov	r11, QWORD PTR [rbp-120]
	mov	r10, QWORD PTR [rbp-160]
	jne	.L470
	jmp	.L471
	.p2align 4,,10
	.p2align 3
.L488:
	mov	rax, rdx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L489
.L468:
	mov	edi, OFFSET FLAT:.LC49
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	mov	edi, OFFSET FLAT:.LC50
	vmovsd	QWORD PTR [rbp-208], xmm0
	call	likwid_markerStartRegion
	jmp	.L471
	.cfi_endproc
.LFE8611:
	.size	_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_, .-_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_
	.section	.rodata.str1.1
.LC51:
	.string	"w"
	.section	.rodata.str1.8
	.align 8
.LC52:
	.string	"N, t_def, p_def, t_avx2, p_avx2, t_avx2rsqrt, p_avx2rsqrt, t_avx512, p_avx512, t_avx512rsqrt, p_avx512rsqrt, t_avx512rsqrt4i, p_avx512rsqrt4i,t_full,p_full,t_full_rsqrt,p_full_rsqrt\n"
	.section	.rodata.str1.1
.LC55:
	.string	"\nStarting iteration; N: %zu\n"
	.section	.rodata.str1.8
	.align 8
.LC56:
	.string	"%zu,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n"
	.section	.text.unlikely,"ax",@progbits
.LCOLDB57:
	.text
.LHOTB57:
	.p2align 4,,15
	.globl	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.type	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, @function
_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE:
.LFB8596:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA8596
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rsi
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rdx
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
	mov	rbx, rdi
	sub	rsp, 1720
	.cfi_def_cfa_offset 1776
	mov	rdi, QWORD PTR [rcx]
	mov	QWORD PTR [rsp+64], rsi
	mov	esi, OFFSET FLAT:.LC51
	mov	QWORD PTR [rsp+72], rdx
.LEHB0:
	call	fopen
	mov	rcx, rax
	mov	edx, 182
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC52
	mov	QWORD PTR [rsp+48], rax
	call	fwrite
	test	r14, r14
	je	.L511
	lea	rax, [0+r15*8]
	mov	QWORD PTR [rsp+56], rax
	lea	rax, [0+rbx*8]
	mov	QWORD PTR [rsp], rax
	lea	rax, [rsp+152]
	mov	QWORD PTR [rsp+16], 0
	mov	QWORD PTR [rsp+24], rax
	.p2align 4,,10
	.p2align 3
.L572:
	xor	ebp, ebp
.L513:
	lea	rdi, [rsp+496]
	call	_ZN12NBody_systemC1Ev
.LEHE0:
	lea	rdi, [rsp+1104]
.LEHB1:
	call	_ZN12NBody_systemC1Ev
.LEHE1:
	vmovsd	xmm1, QWORD PTR .LC53[rip]
	vmovsd	xmm0, QWORD PTR .LC54[rip]
	mov	rsi, rbx
	lea	rdi, [rsp+496]
.LEHB2:
	call	_ZN12NBody_system23init_orbiting_particlesEmdd
	lea	rsi, [rsp+496]
	lea	rdi, [rsp+1104]
	call	_ZN12NBody_systemaSERKS_
	mov	r15, QWORD PTR [rsp]
	mov	edi, 64
	mov	rsi, r15
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r14, rax
	mov	QWORD PTR [rsp+80], rax
	call	aligned_alloc
	mov	rsi, r15
	mov	edi, 64
	mov	r12, rax
	mov	QWORD PTR [rsp+88], rax
	call	aligned_alloc
	mov	r13, rax
	mov	QWORD PTR [rsp+96], rax
	test	rbx, rbx
	je	.L512
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, r14
	call	memset
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, r12
	call	memset
	mov	rdx, r15
	xor	esi, esi
	mov	rdi, r13
	call	memset
.L512:
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:.LC55
	xor	eax, eax
	call	printf
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	call	_Z9nbody_refmPdPS_S0_S0_
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	vmovsd	QWORD PTR [rsp+112+rbp*8], xmm0
	call	_Z21nbody_vectorized_avx2mPdPS_S0_S0_
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	vmovsd	QWORD PTR [rsp+160+rbp*8], xmm0
	call	_Z27nbody_vectorized_avx2_rsqrtmPdPS_S0_S0_
	lea	r15, [rsp+208]
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	vmovsd	QWORD PTR [r15+rbp*8], xmm0
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	call	_Z23nbody_vectorized_avx512mPdPS_S0_S0_
	lea	r14, [rsp+256]
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	vmovsd	QWORD PTR [r14+rbp*8], xmm0
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	call	_Z29nbody_vectorized_avx512_rsqrtmPdPS_S0_S0_
	lea	r13, [rsp+304]
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	vmovsd	QWORD PTR [r13+0+rbp*8], xmm0
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	call	_Z37nbody_reduced_vectorized_avx512_rsqrtmPdPS_S0_S0_
	lea	r12, [rsp+352]
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	vmovsd	QWORD PTR [r12+rbp*8], xmm0
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	call	_Z21nbody_full_vectorizedmPdPS_S0_S0_
	lea	rax, [rsp+496]
	mov	rsi, QWORD PTR [rsp+512]
	lea	rcx, [rsp+1176]
	lea	rdx, [rax+24]
	lea	r8, [rsp+80]
	mov	rdi, rbx
	vmovsd	QWORD PTR [rsp+400+rbp*8], xmm0
	call	_Z34nbody_full_vectorized_avx512_rsqrtmPdPS_S0_S0_
.LEHE2:
	mov	rdi, QWORD PTR [rsp+80]
	vmovsd	QWORD PTR [rsp+448+rbp*8], xmm0
	call	free
	mov	rdi, QWORD PTR [rsp+88]
	inc	rbp
	call	free
	mov	rdi, QWORD PTR [rsp+96]
	call	free
	lea	rdi, [rsp+1104]
	call	_ZN12NBody_systemD1Ev
	lea	rdi, [rsp+496]
	call	_ZN12NBody_systemD1Ev
	cmp	rbp, 5
	jne	.L513
	test	rbx, rbx
	js	.L514
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rbx
.L515:
	vfmsub132sd	xmm0, xmm0, xmm0
	mov	rsi, QWORD PTR [rsp+24]
	lea	rbp, [rsp+120]
	mov	edx, 4
	lea	rdi, [rsp+112]
	vdivsd	xmm17, xmm0, QWORD PTR .LC17[rip]
	vmovsd	QWORD PTR [rsp+32], xmm17
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	mov	QWORD PTR [rsp+40], rbx
	mov	rbx, rbp
	mov	rbp, QWORD PTR [rsp+24]
	jmp	.L522
	.p2align 4,,10
	.p2align 3
.L661:
	mov	rdx, rbx
	lea	rax, [rsp+112]
	sub	rdx, rax
	mov	eax, 8
	lea	rdi, [rsp+112+rax]
	lea	rsi, [rsp+112]
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	add	rbx, 8
	vmovsd	QWORD PTR [rsp+112], xmm1
	cmp	rbx, rbp
	je	.L660
.L522:
	vmovsd	xmm1, QWORD PTR [rbx]
	vmovsd	xmm0, QWORD PTR [rsp+112]
	vcomisd	xmm0, xmm1
	ja	.L661
	vmovsd	xmm0, QWORD PTR [rbx-8]
	lea	rax, [rbx-8]
	vcomisd	xmm0, xmm1
	ja	.L521
	jmp	.L662
	.p2align 4,,10
	.p2align 3
.L576:
	mov	rax, rdx
.L521:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L576
	vmovsd	QWORD PTR [rax], xmm1
.L684:
	add	rbx, 8
	cmp	rbx, rbp
	jne	.L522
.L660:
	lea	rax, [rsp+160]
	lea	rsi, [rsp+200]
	mov	edx, 4
	mov	rdi, rax
	mov	rbx, QWORD PTR [rsp+40]
	lea	rbp, [rsp+168]
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	jmp	.L529
	.p2align 4,,10
	.p2align 3
.L664:
	lea	rax, [rsp+160]
	mov	rdx, rbp
	sub	rdx, rax
	mov	eax, 8
	lea	rdi, [rsp+160+rax]
	lea	rsi, [rsp+160]
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	vmovsd	QWORD PTR [rsp+160], xmm1
.L525:
	add	rbp, 8
	lea	rax, [rsp+200]
	cmp	rbp, rax
	je	.L663
.L529:
	vmovsd	xmm1, QWORD PTR [rbp+0]
	vmovsd	xmm0, QWORD PTR [rsp+160]
	vcomisd	xmm0, xmm1
	ja	.L664
	vmovsd	xmm0, QWORD PTR [rbp-8]
	lea	rax, [rbp-8]
	vcomisd	xmm0, xmm1
	ja	.L528
	jmp	.L665
	.p2align 4,,10
	.p2align 3
.L578:
	mov	rax, rdx
.L528:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L578
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L525
	.p2align 4,,10
	.p2align 3
.L663:
	lea	rsi, [r15+40]
	mov	edx, 4
	mov	rdi, r15
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	rbp, [r15+8]
	jmp	.L536
	.p2align 4,,10
	.p2align 3
.L667:
	mov	rdx, rbp
	mov	eax, 8
	sub	rdx, r15
	lea	rdi, [r15+rax]
	mov	rsi, r15
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	add	rbp, 8
	lea	rax, [r15+40]
	vmovsd	QWORD PTR [rsp+208], xmm1
	cmp	rbp, rax
	je	.L666
.L536:
	vmovsd	xmm1, QWORD PTR [rbp+0]
	vmovsd	xmm0, QWORD PTR [rsp+208]
	vcomisd	xmm0, xmm1
	ja	.L667
	vmovsd	xmm0, QWORD PTR [rbp-8]
	lea	rax, [rbp-8]
	vcomisd	xmm0, xmm1
	ja	.L535
	jmp	.L668
	.p2align 4,,10
	.p2align 3
.L580:
	mov	rax, rdx
.L535:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L580
	vmovsd	QWORD PTR [rax], xmm1
.L688:
	add	rbp, 8
	lea	rax, [r15+40]
	cmp	rbp, rax
	jne	.L536
.L666:
	lea	rsi, [r14+40]
	mov	edx, 4
	mov	rdi, r14
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	r15, [r14+8]
	mov	ebp, 8
	jmp	.L543
	.p2align 4,,10
	.p2align 3
.L670:
	mov	rdx, r15
	sub	rdx, r14
	lea	rdi, [r14+rbp]
	mov	rsi, r14
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	add	r15, 8
	lea	rax, [r14+40]
	vmovsd	QWORD PTR [rsp+256], xmm1
	cmp	r15, rax
	je	.L669
.L543:
	vmovsd	xmm1, QWORD PTR [r15]
	vmovsd	xmm0, QWORD PTR [rsp+256]
	vcomisd	xmm0, xmm1
	ja	.L670
	vmovsd	xmm0, QWORD PTR [r15-8]
	lea	rax, [r15-8]
	vcomisd	xmm0, xmm1
	ja	.L542
	jmp	.L671
	.p2align 4,,10
	.p2align 3
.L582:
	mov	rax, rdx
.L542:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L582
	vmovsd	QWORD PTR [rax], xmm1
.L687:
	add	r15, 8
	lea	rax, [r14+40]
	cmp	r15, rax
	jne	.L543
.L669:
	lea	rsi, [r13+40]
	mov	edx, 4
	mov	rdi, r13
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	r14, [r13+8]
	mov	ebp, 8
	jmp	.L550
	.p2align 4,,10
	.p2align 3
.L673:
	mov	rdx, r14
	sub	rdx, r13
	lea	rdi, [r13+0+rbp]
	mov	rsi, r13
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	add	r14, 8
	lea	rax, [r13+40]
	vmovsd	QWORD PTR [rsp+304], xmm1
	cmp	r14, rax
	je	.L672
.L550:
	vmovsd	xmm1, QWORD PTR [r14]
	vmovsd	xmm0, QWORD PTR [rsp+304]
	vcomisd	xmm0, xmm1
	ja	.L673
	vmovsd	xmm0, QWORD PTR [r14-8]
	lea	rax, [r14-8]
	vcomisd	xmm0, xmm1
	ja	.L549
	jmp	.L674
	.p2align 4,,10
	.p2align 3
.L584:
	mov	rax, rdx
.L549:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L584
	vmovsd	QWORD PTR [rax], xmm1
.L686:
	add	r14, 8
	lea	rax, [r13+40]
	cmp	r14, rax
	jne	.L550
.L672:
	lea	rsi, [r12+40]
	mov	edx, 4
	mov	rdi, r12
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	r13, [r12+8]
	mov	ebp, 8
	jmp	.L557
	.p2align 4,,10
	.p2align 3
.L676:
	mov	rdx, r13
	sub	rdx, r12
	lea	rdi, [r12+rbp]
	mov	rsi, r12
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	add	r13, 8
	lea	rax, [r12+40]
	vmovsd	QWORD PTR [rsp+352], xmm1
	cmp	r13, rax
	je	.L675
.L557:
	vmovsd	xmm1, QWORD PTR [r13+0]
	vmovsd	xmm0, QWORD PTR [rsp+352]
	vcomisd	xmm0, xmm1
	ja	.L676
	vmovsd	xmm0, QWORD PTR [r13-8]
	lea	rax, [r13-8]
	vcomisd	xmm0, xmm1
	ja	.L556
	jmp	.L677
	.p2align 4,,10
	.p2align 3
.L586:
	mov	rax, rdx
.L556:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L586
	vmovsd	QWORD PTR [rax], xmm1
.L685:
	add	r13, 8
	lea	rax, [r12+40]
	cmp	r13, rax
	jne	.L557
.L675:
	lea	rax, [rsp+400]
	lea	rsi, [rsp+440]
	mov	edx, 4
	mov	rdi, rax
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	r12, [rsp+408]
	mov	ebp, 8
	jmp	.L564
	.p2align 4,,10
	.p2align 3
.L679:
	lea	rax, [rsp+400]
	mov	rdx, r12
	sub	rdx, rax
	lea	rdi, [rsp+400+rbp]
	mov	rsi, rax
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	vmovsd	QWORD PTR [rsp+400], xmm1
.L560:
	add	r12, 8
	lea	rax, [rsp+440]
	cmp	r12, rax
	je	.L678
.L564:
	vmovsd	xmm1, QWORD PTR [r12]
	vmovsd	xmm0, QWORD PTR [rsp+400]
	vcomisd	xmm0, xmm1
	ja	.L679
	vmovsd	xmm0, QWORD PTR [r12-8]
	lea	rax, [r12-8]
	vcomisd	xmm0, xmm1
	ja	.L563
	jmp	.L680
	.p2align 4,,10
	.p2align 3
.L588:
	mov	rax, rdx
.L563:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L588
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L560
	.p2align 4,,10
	.p2align 3
.L678:
	lea	rax, [rsp+448]
	lea	rsi, [rsp+488]
	mov	edx, 4
	mov	rdi, rax
	call	_ZSt16__introsort_loopIPdlN9__gnu_cxx5__ops15_Iter_less_iterEEvT_S4_T0_T1_.isra.39
	lea	r12, [rsp+456]
	mov	ebp, 8
	jmp	.L571
	.p2align 4,,10
	.p2align 3
.L682:
	lea	rax, [rsp+448]
	mov	rdx, r12
	sub	rdx, rax
	lea	rdi, [rsp+448+rbp]
	mov	rsi, rax
	vmovsd	QWORD PTR [rsp+8], xmm1
	call	memmove
	vmovsd	xmm1, QWORD PTR [rsp+8]
	vmovsd	QWORD PTR [rsp+448], xmm1
.L567:
	add	r12, 8
	lea	rax, [rsp+488]
	cmp	r12, rax
	je	.L681
.L571:
	vmovsd	xmm1, QWORD PTR [r12]
	vmovsd	xmm0, QWORD PTR [rsp+448]
	vcomisd	xmm0, xmm1
	ja	.L682
	vmovsd	xmm0, QWORD PTR [r12-8]
	lea	rax, [r12-8]
	vcomisd	xmm0, xmm1
	ja	.L570
	jmp	.L683
	.p2align 4,,10
	.p2align 3
.L590:
	mov	rax, rdx
.L570:
	vmovsd	QWORD PTR [rax+8], xmm0
	vmovsd	xmm0, QWORD PTR [rax-8]
	lea	rdx, [rax-8]
	vcomisd	xmm0, xmm1
	ja	.L590
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L567
	.p2align 4,,10
	.p2align 3
.L681:
	vmovsd	xmm16, QWORD PTR [rsp+32]
	vmovsd	xmm7, QWORD PTR [rsp+464]
	vmovsd	xmm5, QWORD PTR [rsp+416]
	vmovsd	xmm3, QWORD PTR [rsp+368]
	vmovsd	xmm1, QWORD PTR [rsp+320]
	vmovsd	xmm6, QWORD PTR [rsp+272]
	vmovsd	xmm4, QWORD PTR [rsp+224]
	vmovsd	xmm2, QWORD PTR [rsp+176]
	vmovsd	xmm0, QWORD PTR [rsp+128]
	sub	rsp, 64
	.cfi_def_cfa_offset 1840
	vdivsd	xmm8, xmm16, xmm7
	vmovsd	QWORD PTR [rsp+48], xmm7
	vmovsd	QWORD PTR [rsp+32], xmm5
	vmovsd	QWORD PTR [rsp+16], xmm3
	vmovsd	QWORD PTR [rsp], xmm1
	mov	rdi, QWORD PTR [rsp+112]
	mov	rdx, rbx
	mov	esi, OFFSET FLAT:.LC56
	mov	eax, 8
	vdivsd	xmm7, xmm16, xmm5
	vmovsd	QWORD PTR [rsp+56], xmm8
	vdivsd	xmm5, xmm16, xmm3
	vmovsd	QWORD PTR [rsp+40], xmm7
	vdivsd	xmm3, xmm16, xmm1
	vmovsd	QWORD PTR [rsp+24], xmm5
	vdivsd	xmm7, xmm16, xmm6
	vmovsd	QWORD PTR [rsp+8], xmm3
	vdivsd	xmm5, xmm16, xmm4
	vdivsd	xmm3, xmm16, xmm2
	vdivsd	xmm1, xmm16, xmm0
.LEHB3:
	call	fprintf
	inc	QWORD PTR [rsp+80]
	mov	rsi, QWORD PTR [rsp+120]
	add	rbx, QWORD PTR [rsp+128]
	add	QWORD PTR [rsp+64], rsi
	mov	rax, QWORD PTR [rsp+80]
	add	rsp, 64
	.cfi_def_cfa_offset 1776
	cmp	QWORD PTR [rsp+72], rax
	jne	.L572
.L511:
	mov	rdi, QWORD PTR [rsp+48]
	call	fclose
.LEHE3:
	add	rsp, 1720
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
.L514:
	.cfi_restore_state
	mov	rax, rbx
	mov	rdx, rbx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L515
.L683:
	mov	rax, r12
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L567
.L680:
	mov	rax, r12
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L560
.L665:
	mov	rax, rbp
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L525
.L662:
	mov	rax, rbx
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L684
.L677:
	mov	rax, r13
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L685
.L674:
	mov	rax, r14
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L686
.L671:
	mov	rax, r15
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L687
.L668:
	mov	rax, rbp
	vmovsd	QWORD PTR [rax], xmm1
	jmp	.L688
.L591:
	mov	rbx, rax
	vzeroupper
	jmp	.L574
.L592:
	mov	rbx, rax
	jmp	.L573
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA8596:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8596-.LLSDACSB8596
.LLSDACSB8596:
	.uleb128 .LEHB0-.LFB8596
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB8596
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L591-.LFB8596
	.uleb128 0
	.uleb128 .LEHB2-.LFB8596
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L592-.LFB8596
	.uleb128 0
	.uleb128 .LEHB3-.LFB8596
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSE8596:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC8596
	.type	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.cold.49, @function
_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.cold.49:
.LFSB8596:
.L573:
	.cfi_def_cfa_offset 1776
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	lea	rdi, [rsp+1104]
	vzeroupper
	call	_ZN12NBody_systemD1Ev
.L574:
	lea	rdi, [rsp+496]
	call	_ZN12NBody_systemD1Ev
	mov	rdi, rbx
.LEHB4:
	call	_Unwind_Resume
.LEHE4:
	.cfi_endproc
.LFE8596:
	.section	.gcc_except_table
.LLSDAC8596:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8596-.LLSDACSBC8596
.LLSDACSBC8596:
	.uleb128 .LEHB4-.LCOLDB57
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
.LLSDACSEC8596:
	.section	.text.unlikely
	.text
	.size	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .-_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.section	.text.unlikely
	.size	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.cold.49, .-_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.cold.49
.LCOLDE57:
	.text
.LHOTE57:
	.section	.rodata.str1.8
	.align 8
.LC58:
	.string	"Running Benchmark over %zu sample, starting at %zu, linearly increasing the size by %zu\n"
	.section	.rodata.str1.1
.LC59:
	.string	"Saving the results to %s\n"
	.section	.text.unlikely
.LCOLDB60:
	.section	.text.startup,"ax",@progbits
.LHOTB60:
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB8594:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA8594
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsi
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	ebx, edi
	sub	rsp, 72
	.cfi_def_cfa_offset 96
.LEHB5:
	call	likwid_markerInit
	call	likwid_markerThreadInit
.LEHE5:
	lea	rax, [rsp+48]
	lea	r9, [rsp+24]
	lea	r8, [rsp+16]
	lea	rcx, [rsp+8]
	lea	rdx, [rsp+32]
	mov	rsi, rbp
	mov	edi, ebx
	mov	QWORD PTR [rsp+32], rax
	mov	QWORD PTR [rsp+40], 0
	mov	BYTE PTR [rsp+48], 0
.LEHB6:
	call	_Z13get_argumentsiPPcRNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_S8_
	mov	rcx, QWORD PTR [rsp+16]
	mov	rdx, QWORD PTR [rsp+8]
	mov	rsi, QWORD PTR [rsp+24]
	mov	edi, OFFSET FLAT:.LC58
	xor	eax, eax
	call	printf
	mov	rsi, QWORD PTR [rsp+32]
	mov	edi, OFFSET FLAT:.LC59
	xor	eax, eax
	call	printf
	mov	edi, OFFSET FLAT:.LC14
	call	likwid_markerRegisterRegion
	mov	edi, OFFSET FLAT:.LC20
	call	likwid_markerRegisterRegion
	mov	edi, OFFSET FLAT:.LC24
	call	likwid_markerRegisterRegion
	mov	edi, OFFSET FLAT:.LC30
	call	likwid_markerRegisterRegion
	mov	edi, OFFSET FLAT:.LC34
	call	likwid_markerRegisterRegion
	mov	rdx, QWORD PTR [rsp+24]
	mov	rsi, QWORD PTR [rsp+16]
	mov	rdi, QWORD PTR [rsp+8]
	lea	rcx, [rsp+32]
	call	_Z11nbody_benchmmmRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	call	likwid_markerClose
.LEHE6:
	mov	rdi, QWORD PTR [rsp+32]
	lea	rax, [rsp+48]
	cmp	rdi, rax
	je	.L696
	call	_ZdlPv
.L696:
	add	rsp, 72
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	xor	eax, eax
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.L693:
	.cfi_restore_state
	mov	rbx, rax
	jmp	.L691
	.section	.gcc_except_table
.LLSDA8594:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8594-.LLSDACSB8594
.LLSDACSB8594:
	.uleb128 .LEHB5-.LFB8594
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB8594
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L693-.LFB8594
	.uleb128 0
.LLSDACSE8594:
	.section	.text.startup
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC8594
	.type	main.cold.50, @function
main.cold.50:
.LFSB8594:
.L691:
	.cfi_def_cfa_offset 96
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	mov	rdi, QWORD PTR [rsp+32]
	lea	rdx, [rsp+48]
	cmp	rdi, rdx
	je	.L695
	vzeroupper
	call	_ZdlPv
.L692:
	mov	rdi, rbx
.LEHB7:
	call	_Unwind_Resume
.LEHE7:
.L695:
	vzeroupper
	jmp	.L692
	.cfi_endproc
.LFE8594:
	.section	.gcc_except_table
.LLSDAC8594:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC8594-.LLSDACSBC8594
.LLSDACSBC8594:
	.uleb128 .LEHB7-.LCOLDB60
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSEC8594:
	.section	.text.unlikely
	.section	.text.startup
	.size	main, .-main
	.section	.text.unlikely
	.size	main.cold.50, .-main.cold.50
.LCOLDE60:
	.section	.text.startup
.LHOTE60:
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	4294967295
	.long	2147483647
	.long	0
	.long	0
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC1:
	.long	3944497965
	.long	1058682594
	.section	.rodata.cst16
	.align 16
.LC16:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.section	.rodata.cst8
	.align 8
.LC17:
	.long	0
	.long	1093567616
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC25:
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.long	0
	.long	1074266112
	.align 32
.LC26:
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.long	0
	.long	1071644672
	.section	.rodata.cst16
	.align 16
.LC35:
	.long	0
	.long	1074266112
	.long	0
	.long	0
	.align 16
.LC36:
	.long	0
	.long	1071644672
	.long	0
	.long	0
	.section	.rodata.cst32
	.align 32
.LC46:
	.quad	0
	.quad	8
	.quad	16
	.quad	24
	.align 32
.LC47:
	.quad	32
	.quad	32
	.quad	32
	.quad	32
	.align 32
.LC48:
	.quad	8
	.quad	8
	.quad	8
	.quad	8
	.section	.rodata.cst8
	.align 8
.LC53:
	.long	1374389535
	.long	1075388088
	.align 8
.LC54:
	.long	0
	.long	1072693248
	.ident	"GCC: (GNU) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
