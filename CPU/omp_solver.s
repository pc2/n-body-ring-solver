	.file	"omp_solver.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.type	_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0, @function
_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0:
.LFB8443:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	mov	rax, rdi
	lea	r13, [rsp+16]
	.cfi_def_cfa 13, 0
	and	rsp, -32
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
	push	r12
	push	rbx
	sub	rsp, 232
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	.cfi_escape 0x10,0x3,0x2,0x76,0x58
	mov	QWORD PTR [rbp-128], rdi
	mov	rdi, QWORD PTR [rdi+72]
	mov	r12, QWORD PTR [rax+24]
	mov	r11, QWORD PTR [rax+40]
	mov	r15, QWORD PTR [rax+32]
	mov	QWORD PTR [rbp-144], rdi
	mov	rcx, QWORD PTR [rax+48]
	mov	rdi, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-64], r11
	mov	QWORD PTR [rbp-160], r12
	mov	r14, QWORD PTR [rax+64]
	mov	rbx, QWORD PTR [rax+56]
	mov	QWORD PTR [rbp-80], rcx
	mov	QWORD PTR [rbp-152], r15
	mov	QWORD PTR [rbp-168], rdi
	mov	r13, QWORD PTR [rax+8]
	call	omp_get_thread_num
	mov	r11, QWORD PTR [rbp-64]
	cdqe
	mov	r9, QWORD PTR [r12+rax*8]
	mov	QWORD PTR [rbp-56], rax
	mov	r12, QWORD PTR [r15+rax*8]
	test	r11, r11
	je	.L55
	mov	QWORD PTR [rbp-72], r9
	mov	QWORD PTR [rbp-64], r11
	call	omp_get_num_threads
	mov	r11, QWORD PTR [rbp-64]
	movsx	rdx, eax
	mov	rcx, rdx
	mov	QWORD PTR [rbp-88], rdx
	mov	rax, r11
	xor	edx, edx
	div	rcx
	mov	r9, QWORD PTR [rbp-72]
	cmp	QWORD PTR [rbp-56], rdx
	jb	.L21
.L27:
	mov	rcx, QWORD PTR [rbp-56]
	imul	rcx, rax
	lea	rsi, [rcx+rdx]
	add	rax, rsi
	mov	QWORD PTR [rbp-136], rsi
	mov	QWORD PTR [rbp-112], rax
	mov	r15, rax
	cmp	rsi, rax
	jb	.L56
	mov	QWORD PTR [rbp-72], r9
	mov	QWORD PTR [rbp-64], r11
	call	GOMP_barrier
	mov	r11, QWORD PTR [rbp-64]
	mov	r9, QWORD PTR [rbp-72]
	cmp	r11, QWORD PTR [rbp-56]
	jbe	.L45
.L29:
	mov	rdi, QWORD PTR [rbp-80]
	xor	edx, edx
	lea	rax, [r14+rdi]
	div	rbx
	mov	rax, QWORD PTR [rbp-128]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rbp-104], rdx
	imul	rdx, r11
	mov	QWORD PTR [rbp-72], rdx
	mov	rdx, rdi
	imul	rdx, r11
	sal	rdx, 3
	mov	QWORD PTR [rbp-96], rdx
	.p2align 4,,10
	.p2align 3
.L13:
	mov	rdi, QWORD PTR [rbp-56]
	mov	rdx, QWORD PTR [rax+16]
	lea	r14, [0+rdi*8]
	mov	rsi, QWORD PTR [rbp-96]
	lea	rcx, [rdx+r14]
	vmovsd	xmm6, QWORD PTR [rcx+rsi]
	mov	rsi, QWORD PTR [rbp-104]
	lea	rbx, [rdi+1]
	cmp	QWORD PTR [rbp-80], rsi
	cmovb	rbx, rdi
	mov	rsi, QWORD PTR [rax+24]
	mov	r10, QWORD PTR [rax+32]
	mov	r8, QWORD PTR [rax+40]
	mov	rcx, rbx
	vxorpd	xmm6, xmm6, xmm7
	add	rsi, r14
	add	r10, r14
	add	r8, r14
	and	ecx, 3
	jne	.L9
.L18:
	lea	rcx, [rbx+3]
	vbroadcastsd	ymm14, QWORD PTR [rsi]
	vbroadcastsd	ymm15, QWORD PTR [r10]
	vbroadcastsd	ymm12, QWORD PTR [r8]
	vbroadcastsd	ymm13, xmm6
	cmp	r11, rcx
	jbe	.L32
	mov	rdi, QWORD PTR [rbp-72]
	vxorpd	xmm8, xmm8, xmm8
	lea	rcx, [rbx+rdi]
	sal	rcx, 3
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L11
	.p2align 4,,10
	.p2align 3
.L57:
	mov	rdx, QWORD PTR [rax+16]
	mov	rbx, r15
.L11:
	mov	rsi, QWORD PTR [r13+0]
	vmulpd	ymm1, ymm13, YMMWORD PTR [rdx+rcx]
	vsubpd	ymm4, ymm14, YMMWORD PTR [rsi+rbx*8]
	mov	rsi, QWORD PTR [r13+8]
	mov	rdx, QWORD PTR [r12+8]
	vsubpd	ymm3, ymm15, YMMWORD PTR [rsi+rbx*8]
	mov	rsi, QWORD PTR [r13+16]
	vmovapd	ymm11, ymm4
	vmulpd	ymm0, ymm3, ymm3
	vsubpd	ymm2, ymm12, YMMWORD PTR [rsi+rbx*8]
	mov	rsi, QWORD PTR [r12]
	lea	r15, [rbx+4]
	lea	rsi, [rsi+rbx*8]
	vfmadd231pd	ymm0, ymm4, ymm4
	add	rcx, 32
	vfmadd231pd	ymm0, ymm2, ymm2
	vsqrtpd	ymm0, ymm0
	vmulpd	ymm5, ymm0, ymm0
	vmulpd	ymm0, ymm5, ymm0
	vmovapd	ymm5, ymm3
	vdivpd	ymm0, ymm1, ymm0
	vmovapd	ymm1, ymm2
	vfnmadd213pd	ymm11, ymm0, YMMWORD PTR [rsi]
	vfnmadd213pd	ymm5, ymm0, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [r12+16]
	vfmadd231pd	ymm10, ymm4, ymm0
	vfnmadd213pd	ymm1, ymm0, YMMWORD PTR [rdx+rbx*8]
	vmovapd	YMMWORD PTR [rsi], ymm11
	mov	rdx, QWORD PTR [r12+8]
	vfmadd231pd	ymm9, ymm3, ymm0
	vmovapd	YMMWORD PTR [rdx+rbx*8], ymm5
	mov	rdx, QWORD PTR [r12+16]
	vfmadd231pd	ymm8, ymm2, ymm0
	vmovapd	YMMWORD PTR [rdx+rbx*8], ymm1
	add	rbx, 7
	cmp	r11, rbx
	ja	.L57
.L10:
	vmovapd	xmm2, xmm10
	vextractf64x2	xmm10, ymm10, 0x1
	vaddpd	xmm10, xmm2, xmm10
	vmovapd	xmm1, xmm9
	vextractf64x2	xmm9, ymm9, 0x1
	vunpckhpd	xmm2, xmm10, xmm10
	mov	rdi, QWORD PTR [r9]
	vaddpd	xmm9, xmm1, xmm9
	vaddsd	xmm10, xmm10, xmm2
	add	rdi, r14
	vmovapd	xmm0, xmm8
	vaddsd	xmm10, xmm10, QWORD PTR [rdi]
	vextractf64x2	xmm8, ymm8, 0x1
	vunpckhpd	xmm1, xmm9, xmm9
	mov	rsi, QWORD PTR [r9+8]
	vaddpd	xmm8, xmm0, xmm8
	vaddsd	xmm9, xmm9, xmm1
	vmovsd	QWORD PTR [rdi], xmm10
	add	rsi, r14
	vaddsd	xmm9, xmm9, QWORD PTR [rsi]
	vunpckhpd	xmm0, xmm8, xmm8
	mov	rcx, QWORD PTR [r9+16]
	vaddsd	xmm8, xmm8, xmm0
	vmovsd	QWORD PTR [rsi], xmm9
	add	rcx, r14
	vaddsd	xmm8, xmm8, QWORD PTR [rcx]
	mov	rdx, QWORD PTR [rbp-72]
	add	rdx, r15
	vmovsd	QWORD PTR [rcx], xmm8
	sal	rdx, 3
	vxorpd	xmm8, xmm8, xmm8
	cmp	r11, r15
	jbe	.L16
	.p2align 4,,10
	.p2align 3
.L17:
	mov	r10, QWORD PTR [rax+24]
	mov	r8, QWORD PTR [r13+0]
	vmovsd	xmm3, QWORD PTR [r10+r14]
	mov	r10, QWORD PTR [rax+32]
	vsubsd	xmm3, xmm3, QWORD PTR [r8+r15*8]
	vmovsd	xmm2, QWORD PTR [r10+r14]
	mov	r8, QWORD PTR [r13+8]
	mov	r10, QWORD PTR [rax+40]
	vsubsd	xmm2, xmm2, QWORD PTR [r8+r15*8]
	vmovsd	xmm1, QWORD PTR [r10+r14]
	mov	r8, QWORD PTR [r13+16]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [r8+r15*8]
	lea	rbx, [0+r15*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L58
.L15:
	mov	r8, QWORD PTR [rax+16]
	vmulsd	xmm0, xmm5, xmm5
	vmulsd	xmm4, xmm6, QWORD PTR [r8+rdx]
	mov	r8, QWORD PTR [r12]
	inc	r15
	add	r8, rbx
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	add	rdx, 8
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r8]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [r8], xmm3
	mov	r8, QWORD PTR [r12+8]
	add	r8, rbx
	vmovsd	xmm0, QWORD PTR [r8]
	add	rbx, QWORD PTR [r12+16]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [r8], xmm2
	vmovsd	xmm0, QWORD PTR [rbx]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rbx], xmm1
	cmp	r11, r15
	jne	.L17
.L16:
	mov	rdx, QWORD PTR [rbp-88]
	add	QWORD PTR [rbp-56], rdx
	mov	rdi, QWORD PTR [rbp-56]
	cmp	r11, rdi
	ja	.L13
	vzeroupper
	call	GOMP_barrier
	mov	rdx, QWORD PTR [rbp-112]
	cmp	QWORD PTR [rbp-136], rdx
	jnb	.L52
.L28:
	mov	rax, QWORD PTR [rbp-128]
	mov	rdi, QWORD PTR [rbp-144]
	mov	rax, QWORD PTR [rax]
	test	rdi, rdi
	je	.L52
	mov	rbx, QWORD PTR [rax+72]
	mov	r13, QWORD PTR [rax+80]
	mov	r14, QWORD PTR [rax+88]
	mov	rax, QWORD PTR [rbp-168]
	mov	QWORD PTR [rbp-72], r13
	mov	rcx, QWORD PTR [rax+8]
	mov	r12, QWORD PTR [rax+16]
	mov	r15, QWORD PTR [rax]
	mov	QWORD PTR [rbp-64], rcx
	mov	QWORD PTR [rbp-80], r14
	mov	QWORD PTR [rbp-96], r12
	mov	r13, QWORD PTR [rbp-160]
	mov	r14, QWORD PTR [rbp-136]
	mov	r12, QWORD PTR [rbp-152]
	mov	QWORD PTR [rbp-88], r15
	mov	r15, rbx
	mov	rbx, rdi
	.p2align 4,,10
	.p2align 3
.L6:
	mov	rdx, QWORD PTR [rbp-72]
	lea	rax, [0+r14*8]
	mov	rcx, QWORD PTR [rbp-88]
	lea	r10, [rdx+rax]
	mov	rdx, QWORD PTR [rbp-80]
	lea	r8, [rcx+rax]
	lea	r9, [rdx+rax]
	mov	rcx, QWORD PTR [rbp-96]
	mov	rdx, QWORD PTR [rbp-64]
	mov	QWORD PTR [rbp-56], r14
	lea	rdi, [rdx+rax]
	lea	r11, [r15+rax]
	lea	rsi, [rcx+rax]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L5:
	mov	rcx, QWORD PTR [r13+0+rdx*8]
	vmovsd	xmm0, QWORD PTR [r11]
	mov	r14, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [r14+rax]
	mov	r14, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [r11], xmm0
	vmovsd	xmm0, QWORD PTR [r10]
	vaddsd	xmm0, xmm0, QWORD PTR [r14+rax]
	vmovsd	QWORD PTR [r10], xmm0
	vmovsd	xmm0, QWORD PTR [r9]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	mov	rcx, QWORD PTR [r12+rdx*8]
	inc	rdx
	vmovsd	QWORD PTR [r9], xmm0
	mov	r14, QWORD PTR [rcx]
	vmovsd	xmm0, QWORD PTR [r8]
	vaddsd	xmm0, xmm0, QWORD PTR [r14+rax]
	mov	r14, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [r14+rax]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	rbx, rdx
	jne	.L5
	mov	r14, QWORD PTR [rbp-56]
	inc	r14
	cmp	r14, QWORD PTR [rbp-112]
	jne	.L6
.L52:
	add	rsp, 232
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
	pop	r13
	.cfi_def_cfa_offset 8
	ret
.L56:
	.cfi_restore_state
	mov	rdi, QWORD PTR [rbp-144]
	test	rdi, rdi
	je	.L23
	mov	r8, QWORD PTR [rbp-152]
	mov	r10, QWORD PTR [rbp-160]
	.p2align 4,,10
	.p2align 3
.L25:
	mov	QWORD PTR [rbp-64], rsi
	lea	rax, [0+rsi*8]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L24:
	mov	rcx, QWORD PTR [r10+rdx*8]
	mov	rsi, QWORD PTR [rcx]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	rsi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	mov	rcx, QWORD PTR [r8+rdx*8]
	inc	rdx
	mov	rsi, QWORD PTR [rcx]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	rsi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	cmp	rdi, rdx
	jne	.L24
	mov	rsi, QWORD PTR [rbp-64]
	inc	rsi
	cmp	r15, rsi
	jne	.L25
.L23:
	mov	QWORD PTR [rbp-72], r9
	mov	QWORD PTR [rbp-64], r11
	call	GOMP_barrier
	mov	r11, QWORD PTR [rbp-64]
	mov	r9, QWORD PTR [rbp-72]
	cmp	r11, QWORD PTR [rbp-56]
	ja	.L29
	call	GOMP_barrier
	jmp	.L28
	.p2align 4,,10
	.p2align 3
.L9:
	mov	edi, 4
	sub	rdi, rcx
	mov	QWORD PTR [rbp-64], rdi
	cmp	rbx, r11
	jnb	.L18
	mov	rdi, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-120], rax
	lea	rcx, [rbx+rdi]
	xor	edi, edi
	sal	rcx, 3
	vxorpd	xmm8, xmm8, xmm8
	mov	rax, rdi
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L60:
	cmp	r11, rbx
	jbe	.L49
.L20:
	mov	rdi, QWORD PTR [r13+0]
	vmovsd	xmm3, QWORD PTR [rsi]
	vmovsd	xmm2, QWORD PTR [r10]
	vsubsd	xmm3, xmm3, QWORD PTR [rdi+rbx*8]
	mov	rdi, QWORD PTR [r13+8]
	vmovsd	xmm1, QWORD PTR [r8]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rbx*8]
	mov	rdi, QWORD PTR [r13+16]
	lea	r15, [0+rbx*8]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L59
.L19:
	vmulsd	xmm4, xmm6, QWORD PTR [rdx+rcx]
	vmulsd	xmm0, xmm5, xmm5
	mov	rdi, QWORD PTR [r9]
	inc	rax
	add	rdi, r14
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	inc	rbx
	add	rcx, 8
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [r9+8]
	add	rdi, r14
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [r9+16]
	add	rdi, r14
	vaddsd	xmm0, xmm1, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [r12]
	add	rdi, r15
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [r12+8]
	add	rdi, r15
	vmovsd	xmm0, QWORD PTR [rdi]
	add	r15, QWORD PTR [r12+16]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	vmovsd	xmm0, QWORD PTR [r15]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r15], xmm1
	cmp	rax, QWORD PTR [rbp-64]
	jb	.L60
.L49:
	mov	rax, QWORD PTR [rbp-120]
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L32:
	vxorpd	xmm8, xmm8, xmm8
	mov	r15, rbx
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L10
.L21:
	inc	rax
	xor	edx, edx
	jmp	.L27
.L55:
	call	GOMP_barrier
.L45:
	add	rsp, 232
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
	pop	r13
	.cfi_def_cfa_offset 8
	jmp	GOMP_barrier
.L58:
	.cfi_restore_state
	mov	QWORD PTR [rbp-224], rdx
	mov	QWORD PTR [rbp-216], r9
	mov	QWORD PTR [rbp-208], r11
	vmovsd	QWORD PTR [rbp-200], xmm8
	vmovsd	QWORD PTR [rbp-192], xmm5
	vmovsd	QWORD PTR [rbp-184], xmm1
	vmovsd	QWORD PTR [rbp-176], xmm2
	vmovsd	QWORD PTR [rbp-120], xmm3
	vmovsd	QWORD PTR [rbp-64], xmm6
	vzeroupper
	call	sqrt
	mov	r9, QWORD PTR [rbp-216]
	mov	rax, QWORD PTR [rbp-128]
	mov	rsi, QWORD PTR [r9+8]
	mov	rcx, QWORD PTR [r9+16]
	mov	rdi, r14
	mov	rax, QWORD PTR [rax]
	add	rdi, QWORD PTR [r9]
	add	rsi, r14
	add	rcx, r14
	mov	rdx, QWORD PTR [rbp-224]
	mov	r11, QWORD PTR [rbp-208]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	vmovsd	xmm8, QWORD PTR [rbp-200]
	vmovsd	xmm5, QWORD PTR [rbp-192]
	vmovsd	xmm1, QWORD PTR [rbp-184]
	vmovsd	xmm2, QWORD PTR [rbp-176]
	vmovsd	xmm3, QWORD PTR [rbp-120]
	vmovsd	xmm6, QWORD PTR [rbp-64]
	jmp	.L15
.L59:
	mov	QWORD PTR [rbp-248], rcx
	mov	QWORD PTR [rbp-240], rax
	mov	QWORD PTR [rbp-232], r9
	mov	QWORD PTR [rbp-224], r11
	vmovsd	QWORD PTR [rbp-216], xmm8
	vmovsd	QWORD PTR [rbp-208], xmm5
	vmovsd	QWORD PTR [rbp-200], xmm1
	vmovsd	QWORD PTR [rbp-192], xmm2
	vmovsd	QWORD PTR [rbp-184], xmm3
	vmovsd	QWORD PTR [rbp-176], xmm6
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-128]
	mov	rcx, QWORD PTR [rbp-248]
	mov	rax, QWORD PTR [rax]
	mov	r9, QWORD PTR [rbp-232]
	mov	r8, QWORD PTR [rax+40]
	mov	rsi, QWORD PTR [rax+24]
	mov	r10, QWORD PTR [rax+32]
	mov	QWORD PTR [rbp-120], rax
	mov	rdx, QWORD PTR [rax+16]
	add	r8, r14
	add	rsi, r14
	add	r10, r14
	mov	rax, QWORD PTR [rbp-240]
	mov	r11, QWORD PTR [rbp-224]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	vmovsd	xmm8, QWORD PTR [rbp-216]
	vmovsd	xmm5, QWORD PTR [rbp-208]
	vmovsd	xmm1, QWORD PTR [rbp-200]
	vmovsd	xmm2, QWORD PTR [rbp-192]
	vmovsd	xmm3, QWORD PTR [rbp-184]
	vmovsd	xmm6, QWORD PTR [rbp-176]
	jmp	.L19
	.cfi_endproc
.LFE8443:
	.size	_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0, .-_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0
	.p2align 4,,15
	.type	_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1, @function
_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1:
.LFB8444:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -32
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
	mov	rbx, rdi
	sub	rsp, 320
	mov	rax, QWORD PTR [rdi+72]
	mov	r15, QWORD PTR [rdi+32]
	mov	QWORD PTR [rbp-264], rax
	mov	rax, QWORD PTR [rdi+56]
	mov	r14, QWORD PTR [rdi+24]
	mov	QWORD PTR [rbp-232], rax
	mov	rax, QWORD PTR [rdi+48]
	mov	r9, QWORD PTR [rdi+8]
	mov	QWORD PTR [rbp-136], rax
	mov	rax, QWORD PTR [rdi+16]
	mov	QWORD PTR [rbp-72], r9
	mov	QWORD PTR [rbp-104], rdi
	mov	r13, QWORD PTR [rdi+64]
	mov	QWORD PTR [rbp-272], r15
	mov	QWORD PTR [rbp-280], r14
	mov	QWORD PTR [rbp-288], rax
	call	omp_get_thread_num
	cdqe
	mov	rsi, QWORD PTR [r14+rax*8]
	mov	QWORD PTR [rbp-216], rax
	mov	r10, QWORD PTR [r15+rax*8]
	mov	rax, QWORD PTR [rbx+40]
	mov	QWORD PTR [rbp-96], rsi
	mov	rbx, QWORD PTR [rax]
	mov	r9, QWORD PTR [rbp-72]
	test	rbx, rbx
	je	.L91
	mov	QWORD PTR [rbp-80], r10
	mov	QWORD PTR [rbp-72], r9
	call	omp_get_num_threads
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, rbx
	div	rcx
	mov	r9, QWORD PTR [rbp-72]
	mov	r10, QWORD PTR [rbp-80]
	cmp	QWORD PTR [rbp-216], rdx
	jb	.L90
.L95:
	mov	rsi, QWORD PTR [rbp-216]
	imul	rsi, rax
	add	rsi, rdx
	lea	r8, [rax+rsi]
	cmp	rsi, r8
	jb	.L118
.L91:
	mov	QWORD PTR [rbp-80], r10
	mov	QWORD PTR [rbp-72], r9
	call	GOMP_barrier
	mov	rax, QWORD PTR [rbp-104]
	mov	r9, QWORD PTR [rbp-72]
	mov	rax, QWORD PTR [rax+40]
	mov	r10, QWORD PTR [rbp-80]
	mov	r12, QWORD PTR [rax]
	mov	rax, r12
	shr	rax, 8
	test	r12b, r12b
	mov	QWORD PTR [rbp-224], rax
	je	.L119
	inc	QWORD PTR [rbp-224]
.L64:
	add	r13, QWORD PTR [rbp-136]
	mov	QWORD PTR [rbp-208], 0
	mov	QWORD PTR [rbp-240], r13
	mov	QWORD PTR [rbp-248], r9
	mov	QWORD PTR [rbp-256], r10
	.p2align 4,,10
	.p2align 3
.L75:
	mov	rsi, QWORD PTR [rbp-208]
	mov	rax, rsi
	sal	rax, 8
	mov	QWORD PTR [rbp-120], rax
	add	rax, 256
	inc	rsi
	cmp	r12, rax
	mov	QWORD PTR [rbp-56], rax
	cmovbe	rax, r12
	mov	QWORD PTR [rbp-208], rsi
	test	rax, rax
	je	.L76
	mov	QWORD PTR [rbp-72], rax
	call	omp_get_num_threads
	mov	r9, QWORD PTR [rbp-216]
	mov	rdi, QWORD PTR [rbp-72]
	cdqe
	cmp	r9, rdi
	mov	QWORD PTR [rbp-112], rax
	vmovq	xmm7, QWORD PTR .LC0[rip]
	jnb	.L76
	mov	rax, QWORD PTR [rbp-240]
	xor	edx, edx
	div	QWORD PTR [rbp-232]
	mov	rax, QWORD PTR [rbp-104]
	mov	r11, QWORD PTR [rbp-248]
	mov	r10, QWORD PTR [rax]
	mov	r8, QWORD PTR [rbp-256]
	mov	r14, rdi
	mov	r15, r9
	mov	QWORD PTR [rbp-128], rdx
	.p2align 4,,10
	.p2align 3
.L82:
	mov	rsi, QWORD PTR [rbp-136]
	mov	rcx, QWORD PTR [rbp-128]
	mov	rdx, rsi
	imul	rdx, r12
	lea	rbx, [r15+1]
	mov	rax, QWORD PTR [r10+16]
	add	rdx, r15
	cmp	rsi, rcx
	cmovb	rbx, r15
	mov	rsi, QWORD PTR [rbp-120]
	vmovsd	xmm6, QWORD PTR [rax+rdx*8]
	cmp	rbx, rsi
	cmovb	rbx, rsi
	mov	rdx, QWORD PTR [r10+40]
	imul	r12, rcx
	mov	rsi, QWORD PTR [r10+24]
	mov	rcx, QWORD PTR [r10+32]
	lea	r13, [0+r15*8]
	add	rdx, r13
	add	rsi, r13
	add	rcx, r13
	mov	rdi, rbx
	vxorpd	xmm6, xmm6, xmm7
	mov	QWORD PTR [rbp-88], rdx
	mov	QWORD PTR [rbp-72], rsi
	mov	QWORD PTR [rbp-80], rcx
	and	edi, 3
	jne	.L120
.L86:
	mov	rsi, QWORD PTR [rbp-72]
	lea	rdx, [rbx+3]
	vbroadcastsd	ymm14, QWORD PTR [rsi]
	mov	rsi, QWORD PTR [rbp-80]
	vbroadcastsd	ymm13, xmm6
	vbroadcastsd	ymm15, QWORD PTR [rsi]
	mov	rsi, QWORD PTR [rbp-88]
	vbroadcastsd	ymm12, QWORD PTR [rsi]
	cmp	r14, rdx
	jbe	.L97
	vxorpd	xmm8, xmm8, xmm8
	lea	rcx, [rbx+r12]
	sal	rcx, 3
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L80
	.p2align 4,,10
	.p2align 3
.L121:
	mov	rax, QWORD PTR [r10+16]
	mov	rbx, rdx
.L80:
	mov	rdx, QWORD PTR [r11]
	vmulpd	ymm1, ymm13, YMMWORD PTR [rax+rcx]
	vsubpd	ymm4, ymm14, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [r11+8]
	mov	rax, QWORD PTR [r8+8]
	vsubpd	ymm3, ymm15, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [r11+16]
	vmovapd	ymm11, ymm4
	vmulpd	ymm0, ymm3, ymm3
	vsubpd	ymm2, ymm12, YMMWORD PTR [rdx+rbx*8]
	mov	rdx, QWORD PTR [r8]
	add	rcx, 32
	lea	rdx, [rdx+rbx*8]
	vfmadd231pd	ymm0, ymm4, ymm4
	vfmadd231pd	ymm0, ymm2, ymm2
	vsqrtpd	ymm0, ymm0
	vmulpd	ymm5, ymm0, ymm0
	vmulpd	ymm0, ymm5, ymm0
	vmovapd	ymm5, ymm3
	vdivpd	ymm0, ymm1, ymm0
	vmovapd	ymm1, ymm2
	vfnmadd213pd	ymm11, ymm0, YMMWORD PTR [rdx]
	vfnmadd213pd	ymm5, ymm0, YMMWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [r8+16]
	vfmadd231pd	ymm10, ymm4, ymm0
	vfnmadd213pd	ymm1, ymm0, YMMWORD PTR [rax+rbx*8]
	vmovapd	YMMWORD PTR [rdx], ymm11
	mov	rax, QWORD PTR [r8+8]
	lea	rdx, [rbx+4]
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm5
	mov	rax, QWORD PTR [r8+16]
	vfmadd231pd	ymm9, ymm3, ymm0
	vmovapd	YMMWORD PTR [rax+rbx*8], ymm1
	add	rbx, 7
	vfmadd231pd	ymm8, ymm2, ymm0
	cmp	r14, rbx
	ja	.L121
.L79:
	vmovapd	xmm2, xmm10
	vextractf64x2	xmm10, ymm10, 0x1
	vaddpd	xmm10, xmm2, xmm10
	mov	rax, QWORD PTR [rbp-96]
	vmovapd	xmm1, xmm9
	vunpckhpd	xmm2, xmm10, xmm10
	vextractf64x2	xmm9, ymm9, 0x1
	mov	rsi, QWORD PTR [rax]
	vaddpd	xmm9, xmm1, xmm9
	vaddsd	xmm10, xmm10, xmm2
	add	rsi, r13
	vmovapd	xmm0, xmm8
	vaddsd	xmm10, xmm10, QWORD PTR [rsi]
	vextractf64x2	xmm8, ymm8, 0x1
	vunpckhpd	xmm1, xmm9, xmm9
	mov	rcx, QWORD PTR [rax+8]
	vaddpd	xmm8, xmm0, xmm8
	vaddsd	xmm9, xmm9, xmm1
	vmovsd	QWORD PTR [rsi], xmm10
	add	rcx, r13
	vaddsd	xmm9, xmm9, QWORD PTR [rcx]
	vunpckhpd	xmm0, xmm8, xmm8
	mov	rbx, QWORD PTR [rax+16]
	vaddsd	xmm8, xmm8, xmm0
	add	rbx, r13
	vmovsd	QWORD PTR [rcx], xmm9
	vaddsd	xmm8, xmm8, QWORD PTR [rbx]
	add	r12, rdx
	mov	rax, rbx
	vmovsd	QWORD PTR [rbx], xmm8
	sal	r12, 3
	vxorpd	xmm8, xmm8, xmm8
	cmp	rdx, r14
	jnb	.L84
	.p2align 4,,10
	.p2align 3
.L85:
	mov	r9, QWORD PTR [r10+24]
	mov	rdi, QWORD PTR [r11]
	vmovsd	xmm3, QWORD PTR [r9+r13]
	mov	r9, QWORD PTR [r10+32]
	vsubsd	xmm3, xmm3, QWORD PTR [rdi+rdx*8]
	vmovsd	xmm2, QWORD PTR [r9+r13]
	mov	rdi, QWORD PTR [r11+8]
	mov	r9, QWORD PTR [r10+40]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rdx*8]
	vmovsd	xmm1, QWORD PTR [r9+r13]
	mov	rdi, QWORD PTR [r11+16]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rdx*8]
	lea	rbx, [0+rdx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L122
.L83:
	mov	rdi, QWORD PTR [r10+16]
	vmulsd	xmm0, xmm5, xmm5
	vmulsd	xmm4, xmm6, QWORD PTR [rdi+r12]
	mov	rdi, QWORD PTR [r8]
	inc	rdx
	add	rdi, rbx
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	add	r12, 8
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [r8+8]
	add	rdi, rbx
	vmovsd	xmm0, QWORD PTR [rdi]
	add	rbx, QWORD PTR [r8+16]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	vmovsd	xmm0, QWORD PTR [rbx]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [rbx], xmm1
	cmp	r14, rdx
	jne	.L85
.L84:
	add	r15, QWORD PTR [rbp-112]
	cmp	r14, r15
	jbe	.L115
	mov	rax, QWORD PTR [rbp-104]
	mov	rax, QWORD PTR [rax+40]
	mov	r12, QWORD PTR [rax]
	jmp	.L82
	.p2align 4,,10
	.p2align 3
.L120:
	mov	r9d, 4
	sub	r9, rdi
	mov	QWORD PTR [rbp-144], r9
	cmp	r14, rbx
	jbe	.L86
	mov	r9, QWORD PTR [r11]
	vmovsd	xmm2, QWORD PTR [rsi]
	vmovsd	xmm1, QWORD PTR [rcx]
	vsubsd	xmm2, xmm2, QWORD PTR [r9+rbx*8]
	mov	r9, QWORD PTR [r11+8]
	vmovsd	xmm0, QWORD PTR [rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [r9+rbx*8]
	mov	r9, QWORD PTR [r11+16]
	vxorpd	xmm8, xmm8, xmm8
	vsubsd	xmm4, xmm0, QWORD PTR [r9+rbx*8]
	vmulsd	xmm0, xmm1, xmm1
	lea	rdi, [0+rbx*8]
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm4, xmm4
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L123
.L87:
	lea	r9, [r12+rbx]
	vmulsd	xmm0, xmm6, QWORD PTR [rax+r9*8]
	vmulsd	xmm3, xmm5, xmm5
	mov	r9, QWORD PTR [rbp-96]
	mov	r9, QWORD PTR [r9]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm3, xmm3, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm4
	mov	QWORD PTR [rbp-168], r9
	add	r9, r13
	vdivsd	xmm2, xmm2, xmm3
	vdivsd	xmm1, xmm1, xmm3
	vdivsd	xmm0, xmm0, xmm3
	vaddsd	xmm3, xmm2, QWORD PTR [r9]
	vmovsd	QWORD PTR [r9], xmm3
	mov	r9, QWORD PTR [rbp-96]
	mov	r9, QWORD PTR [r9+8]
	mov	QWORD PTR [rbp-184], r9
	add	r9, r13
	vaddsd	xmm3, xmm1, QWORD PTR [r9]
	vmovsd	QWORD PTR [r9], xmm3
	mov	r9, QWORD PTR [rbp-96]
	mov	r9, QWORD PTR [r9+16]
	mov	QWORD PTR [rbp-152], r9
	add	r9, r13
	vaddsd	xmm3, xmm0, QWORD PTR [r9]
	vmovsd	QWORD PTR [r9], xmm3
	mov	r9, QWORD PTR [r8]
	mov	QWORD PTR [rbp-176], r9
	add	r9, rdi
	vmovsd	xmm3, QWORD PTR [r9]
	vsubsd	xmm2, xmm3, xmm2
	vmovsd	QWORD PTR [r9], xmm2
	mov	r9, QWORD PTR [r8+8]
	mov	QWORD PTR [rbp-192], r9
	add	r9, rdi
	vmovsd	xmm2, QWORD PTR [r9]
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [r9], xmm1
	mov	r9, QWORD PTR [r8+16]
	add	rdi, r9
	vmovsd	xmm1, QWORD PTR [rdi]
	cmp	QWORD PTR [rbp-144], 1
	vsubsd	xmm0, xmm1, xmm0
	mov	QWORD PTR [rbp-160], r9
	vmovsd	QWORD PTR [rdi], xmm0
	lea	rdi, [rbx+1]
	je	.L101
	cmp	r14, rdi
	jbe	.L101
	lea	r9, [0+rdi*8]
	mov	QWORD PTR [rbp-200], r9
	vmovsd	xmm2, QWORD PTR [rsi]
	mov	r9, QWORD PTR [r11]
	vmovsd	xmm1, QWORD PTR [rcx]
	vsubsd	xmm2, xmm2, QWORD PTR [r9+rdi*8]
	mov	r9, QWORD PTR [r11+8]
	vmovsd	xmm0, QWORD PTR [rdx]
	vsubsd	xmm1, xmm1, QWORD PTR [r9+rdi*8]
	mov	r9, QWORD PTR [r11+16]
	mov	QWORD PTR [rbp-72], rsi
	vsubsd	xmm4, xmm0, QWORD PTR [r9+rdi*8]
	vmulsd	xmm0, xmm1, xmm1
	mov	QWORD PTR [rbp-80], rcx
	mov	QWORD PTR [rbp-88], rdx
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm4, xmm4
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L124
.L88:
	add	rdi, r12
	vmulsd	xmm0, xmm6, QWORD PTR [rax+rdi*8]
	vmulsd	xmm3, xmm5, xmm5
	mov	rdi, QWORD PTR [rbp-168]
	mov	r9, QWORD PTR [rbp-200]
	add	rdi, r13
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm3, xmm3, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm4
	vdivsd	xmm2, xmm2, xmm3
	vdivsd	xmm1, xmm1, xmm3
	vdivsd	xmm0, xmm0, xmm3
	vaddsd	xmm3, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-184]
	add	rdi, r13
	vaddsd	xmm3, xmm1, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-152]
	add	rdi, r13
	vaddsd	xmm3, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm3
	mov	rdi, QWORD PTR [rbp-176]
	add	rdi, r9
	vmovsd	xmm3, QWORD PTR [rdi]
	vsubsd	xmm2, xmm3, xmm2
	vmovsd	QWORD PTR [rdi], xmm2
	mov	rdi, QWORD PTR [rbp-192]
	add	rdi, r9
	vmovsd	xmm2, QWORD PTR [rdi]
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rdi], xmm1
	mov	rdi, QWORD PTR [rbp-160]
	add	rdi, r9
	vmovsd	xmm1, QWORD PTR [rdi]
	cmp	QWORD PTR [rbp-144], 2
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rdi], xmm0
	lea	rdi, [rbx+2]
	je	.L101
	cmp	r14, rdi
	jbe	.L101
	vmovsd	xmm3, QWORD PTR [rsi]
	mov	QWORD PTR [rbp-72], rsi
	mov	rsi, rcx
	vmovsd	xmm2, QWORD PTR [rsi]
	mov	QWORD PTR [rbp-80], rcx
	mov	rcx, QWORD PTR [r11+8]
	lea	r9, [0+rdi*8]
	vsubsd	xmm2, xmm2, QWORD PTR [rcx+rdi*8]
	mov	QWORD PTR [rbp-144], r9
	mov	r9, QWORD PTR [r11]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm3, xmm3, QWORD PTR [r9+rdi*8]
	mov	rsi, rdx
	mov	QWORD PTR [rbp-88], rdx
	vmovsd	xmm1, QWORD PTR [rsi]
	mov	rdx, QWORD PTR [r11+16]
	vfmadd231sd	xmm0, xmm3, xmm3
	vsubsd	xmm1, xmm1, QWORD PTR [rdx+rdi*8]
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm8, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L125
.L89:
	add	rdi, r12
	vmulsd	xmm4, xmm6, QWORD PTR [rax+rdi*8]
	vmulsd	xmm0, xmm5, xmm5
	mov	rdx, QWORD PTR [rbp-168]
	mov	r9, QWORD PTR [rbp-144]
	add	rdx, r13
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	add	r9, QWORD PTR [rbp-160]
	add	rbx, 3
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	mov	rdx, QWORD PTR [rbp-184]
	add	rdx, r13
	vaddsd	xmm0, xmm2, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	mov	rdx, QWORD PTR [rbp-152]
	add	rdx, r13
	vaddsd	xmm0, xmm1, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	mov	rdx, QWORD PTR [rbp-176]
	add	rdx, QWORD PTR [rbp-144]
	vmovsd	xmm0, QWORD PTR [rdx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdx], xmm3
	mov	rdx, QWORD PTR [rbp-192]
	add	rdx, QWORD PTR [rbp-144]
	vmovsd	xmm0, QWORD PTR [rdx]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rdx], xmm2
	vmovsd	xmm0, QWORD PTR [r9]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r9], xmm1
	jmp	.L86
	.p2align 4,,10
	.p2align 3
.L115:
	vzeroupper
.L76:
	call	GOMP_barrier
	mov	rax, QWORD PTR [rbp-104]
	mov	rsi, QWORD PTR [rbp-224]
	mov	rax, QWORD PTR [rax+40]
	mov	r12, QWORD PTR [rax]
	cmp	QWORD PTR [rbp-208], rsi
	jb	.L75
.L74:
	test	r12, r12
	je	.L67
	call	omp_get_num_threads
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r12
	div	rcx
	mov	r12, rax
	cmp	QWORD PTR [rbp-216], rdx
	jb	.L66
.L71:
	mov	r11, QWORD PTR [rbp-216]
	imul	r11, r12
	add	r11, rdx
	lea	rax, [r12+r11]
	mov	QWORD PTR [rbp-80], rax
	cmp	r11, rax
	jnb	.L67
	mov	rax, QWORD PTR [rbp-104]
	mov	rsi, QWORD PTR [rbp-264]
	mov	rax, QWORD PTR [rax]
	test	rsi, rsi
	je	.L67
	mov	r13, QWORD PTR [rax+72]
	mov	r14, QWORD PTR [rax+80]
	mov	r15, QWORD PTR [rax+88]
	mov	rax, QWORD PTR [rbp-288]
	mov	QWORD PTR [rbp-104], r14
	mov	rcx, QWORD PTR [rax]
	mov	r12, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-88], rcx
	mov	rcx, QWORD PTR [rax+8]
	mov	QWORD PTR [rbp-112], r15
	mov	QWORD PTR [rbp-96], rcx
	mov	r15, r13
	mov	r14, QWORD PTR [rbp-280]
	mov	r13, QWORD PTR [rbp-272]
	mov	QWORD PTR [rbp-120], r12
	mov	r12, rsi
.L69:
	mov	rsi, QWORD PTR [rbp-104]
	lea	rax, [0+r11*8]
	lea	r10, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-112]
	mov	QWORD PTR [rbp-72], r11
	lea	r9, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-88]
	lea	rbx, [r15+rax]
	lea	r8, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-96]
	xor	edx, edx
	lea	rdi, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-120]
	add	rsi, rax
	.p2align 4,,10
	.p2align 3
.L68:
	mov	rcx, QWORD PTR [r14+rdx*8]
	vmovsd	xmm0, QWORD PTR [rbx]
	mov	r11, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	mov	r11, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r10]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	vmovsd	QWORD PTR [r10], xmm0
	vmovsd	xmm0, QWORD PTR [r9]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	mov	rcx, QWORD PTR [r13+0+rdx*8]
	inc	rdx
	vmovsd	QWORD PTR [r9], xmm0
	mov	r11, QWORD PTR [rcx]
	vmovsd	xmm0, QWORD PTR [r8]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	mov	r11, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	r12, rdx
	jne	.L68
	mov	r11, QWORD PTR [rbp-72]
	inc	r11
	cmp	QWORD PTR [rbp-80], r11
	jne	.L69
.L67:
	call	GOMP_barrier
	add	rsp, 320
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
.L97:
	.cfi_restore_state
	vxorpd	xmm8, xmm8, xmm8
	mov	rdx, rbx
	vmovapd	ymm9, ymm8
	vmovapd	ymm10, ymm8
	jmp	.L79
.L101:
	mov	rbx, rdi
	jmp	.L86
.L118:
	mov	rax, QWORD PTR [rbp-264]
	test	rax, rax
	je	.L91
	mov	rbx, QWORD PTR [rbp-272]
	mov	r12, QWORD PTR [rbp-280]
	mov	r11, rax
.L93:
	lea	rax, [0+rsi*8]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L92:
	mov	rcx, QWORD PTR [r12+rdx*8]
	mov	rdi, QWORD PTR [rcx]
	mov	QWORD PTR [rdi+rax], 0x000000000
	mov	rdi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rdi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	mov	rcx, QWORD PTR [rbx+rdx*8]
	inc	rdx
	mov	rdi, QWORD PTR [rcx]
	mov	QWORD PTR [rdi+rax], 0x000000000
	mov	rdi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rdi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	cmp	r11, rdx
	jne	.L92
	inc	rsi
	cmp	r8, rsi
	jne	.L93
	jmp	.L91
.L119:
	test	rax, rax
	jne	.L64
	jmp	.L74
.L90:
	inc	rax
	xor	edx, edx
	jmp	.L95
.L122:
	mov	QWORD PTR [rbp-184], r8
	mov	QWORD PTR [rbp-176], r11
	mov	QWORD PTR [rbp-168], rdx
	vmovsd	QWORD PTR [rbp-160], xmm8
	vmovsd	QWORD PTR [rbp-152], xmm5
	vmovsd	QWORD PTR [rbp-144], xmm1
	vmovsd	QWORD PTR [rbp-88], xmm2
	vmovsd	QWORD PTR [rbp-80], xmm3
	vmovsd	QWORD PTR [rbp-72], xmm6
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-104]
	mov	r8, QWORD PTR [rbp-184]
	mov	r10, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-96]
	mov	r11, QWORD PTR [rbp-176]
	mov	rdx, QWORD PTR [rax+16]
	mov	rsi, QWORD PTR [rax]
	mov	rcx, QWORD PTR [rax+8]
	add	rdx, r13
	mov	rax, rdx
	add	rsi, r13
	add	rcx, r13
	mov	rdx, QWORD PTR [rbp-168]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	vmovsd	xmm8, QWORD PTR [rbp-160]
	vmovsd	xmm5, QWORD PTR [rbp-152]
	vmovsd	xmm1, QWORD PTR [rbp-144]
	vmovsd	xmm2, QWORD PTR [rbp-88]
	vmovsd	xmm3, QWORD PTR [rbp-80]
	vmovsd	xmm6, QWORD PTR [rbp-72]
	jmp	.L83
.L66:
	inc	r12
	xor	edx, edx
	jmp	.L71
.L125:
	mov	QWORD PTR [rbp-160], r8
	mov	QWORD PTR [rbp-336], r11
	mov	QWORD PTR [rbp-328], rdi
	vmovsd	QWORD PTR [rbp-320], xmm5
	vmovsd	QWORD PTR [rbp-312], xmm1
	vmovsd	QWORD PTR [rbp-304], xmm2
	vmovsd	QWORD PTR [rbp-296], xmm3
	vmovsd	QWORD PTR [rbp-200], xmm6
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-104]
	mov	r8, QWORD PTR [rbp-160]
	mov	r10, QWORD PTR [rax]
	mov	r11, QWORD PTR [rbp-336]
	mov	rsi, QWORD PTR [r10+40]
	mov	rax, QWORD PTR [r10+16]
	add	rsi, r13
	mov	QWORD PTR [rbp-88], rsi
	mov	rsi, QWORD PTR [r10+24]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	add	rsi, r13
	mov	QWORD PTR [rbp-72], rsi
	mov	rsi, QWORD PTR [r10+32]
	mov	rdi, QWORD PTR [rbp-328]
	add	rsi, r13
	mov	QWORD PTR [rbp-80], rsi
	mov	rsi, QWORD PTR [rbp-96]
	vmovsd	xmm5, QWORD PTR [rbp-320]
	mov	rcx, QWORD PTR [rsi]
	vmovsd	xmm1, QWORD PTR [rbp-312]
	mov	QWORD PTR [rbp-168], rcx
	mov	rcx, QWORD PTR [rsi+8]
	mov	rsi, QWORD PTR [rsi+16]
	mov	QWORD PTR [rbp-184], rcx
	mov	QWORD PTR [rbp-152], rsi
	mov	rsi, QWORD PTR [r8]
	vmovsd	xmm2, QWORD PTR [rbp-304]
	mov	QWORD PTR [rbp-176], rsi
	mov	rsi, QWORD PTR [r8+8]
	vmovsd	xmm3, QWORD PTR [rbp-296]
	mov	QWORD PTR [rbp-192], rsi
	mov	rsi, QWORD PTR [r8+16]
	vmovsd	xmm6, QWORD PTR [rbp-200]
	mov	QWORD PTR [rbp-160], rsi
	jmp	.L89
.L124:
	mov	QWORD PTR [rbp-160], r8
	mov	QWORD PTR [rbp-352], r11
	vmovsd	QWORD PTR [rbp-344], xmm8
	mov	QWORD PTR [rbp-336], rdi
	vmovsd	QWORD PTR [rbp-328], xmm2
	vmovsd	QWORD PTR [rbp-320], xmm1
	vmovsd	QWORD PTR [rbp-312], xmm4
	vmovsd	QWORD PTR [rbp-304], xmm5
	vmovsd	QWORD PTR [rbp-296], xmm6
	vzeroupper
	call	sqrt
	mov	rdi, QWORD PTR [rbp-96]
	mov	r8, QWORD PTR [rbp-160]
	mov	r11, QWORD PTR [rdi]
	mov	rax, QWORD PTR [rbp-104]
	mov	QWORD PTR [rbp-168], r11
	mov	r11, QWORD PTR [rdi+8]
	mov	rdi, QWORD PTR [rdi+16]
	mov	r10, QWORD PTR [rax]
	mov	QWORD PTR [rbp-152], rdi
	mov	rdi, QWORD PTR [r8]
	mov	rdx, QWORD PTR [r10+40]
	mov	QWORD PTR [rbp-176], rdi
	mov	rdi, QWORD PTR [r8+8]
	mov	rsi, QWORD PTR [r10+24]
	mov	rcx, QWORD PTR [r10+32]
	mov	QWORD PTR [rbp-192], rdi
	mov	rdi, QWORD PTR [r8+16]
	add	rdx, r13
	add	rsi, r13
	add	rcx, r13
	mov	QWORD PTR [rbp-184], r11
	mov	QWORD PTR [rbp-160], rdi
	mov	rax, QWORD PTR [r10+16]
	mov	QWORD PTR [rbp-88], rdx
	mov	QWORD PTR [rbp-72], rsi
	mov	QWORD PTR [rbp-80], rcx
	mov	r11, QWORD PTR [rbp-352]
	vmovq	xmm7, QWORD PTR .LC0[rip]
	vmovsd	xmm8, QWORD PTR [rbp-344]
	mov	rdi, QWORD PTR [rbp-336]
	vmovsd	xmm2, QWORD PTR [rbp-328]
	vmovsd	xmm1, QWORD PTR [rbp-320]
	vmovsd	xmm4, QWORD PTR [rbp-312]
	vmovsd	xmm5, QWORD PTR [rbp-304]
	vmovsd	xmm6, QWORD PTR [rbp-296]
	jmp	.L88
.L123:
	mov	QWORD PTR [rbp-304], r8
	mov	QWORD PTR [rbp-296], r11
	vmovsd	QWORD PTR [rbp-200], xmm8
	mov	QWORD PTR [rbp-192], rdi
	vmovsd	QWORD PTR [rbp-184], xmm2
	vmovsd	QWORD PTR [rbp-176], xmm1
	vmovsd	QWORD PTR [rbp-168], xmm4
	vmovsd	QWORD PTR [rbp-160], xmm5
	vmovsd	QWORD PTR [rbp-152], xmm6
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-104]
	mov	r8, QWORD PTR [rbp-304]
	mov	r10, QWORD PTR [rax]
	mov	r11, QWORD PTR [rbp-296]
	mov	rdx, QWORD PTR [r10+40]
	mov	rsi, QWORD PTR [r10+24]
	mov	rcx, QWORD PTR [r10+32]
	add	rdx, r13
	add	rsi, r13
	add	rcx, r13
	mov	rax, QWORD PTR [r10+16]
	mov	QWORD PTR [rbp-88], rdx
	mov	QWORD PTR [rbp-72], rsi
	mov	QWORD PTR [rbp-80], rcx
	vmovq	xmm7, QWORD PTR .LC0[rip]
	vmovsd	xmm8, QWORD PTR [rbp-200]
	mov	rdi, QWORD PTR [rbp-192]
	vmovsd	xmm2, QWORD PTR [rbp-184]
	vmovsd	xmm1, QWORD PTR [rbp-176]
	vmovsd	xmm4, QWORD PTR [rbp-168]
	vmovsd	xmm5, QWORD PTR [rbp-160]
	vmovsd	xmm6, QWORD PTR [rbp-152]
	jmp	.L87
	.cfi_endproc
.LFE8444:
	.size	_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1, .-_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1
	.p2align 4,,15
	.type	_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2, @function
_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2:
.LFB8445:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
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
	mov	r14, rdi
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	sub	rsp, 448
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rax, QWORD PTR [rdi+72]
	mov	r13, QWORD PTR [rdi+24]
	mov	QWORD PTR [rbp-328], rax
	mov	rax, QWORD PTR [rdi+64]
	mov	r15, QWORD PTR [rdi+32]
	mov	QWORD PTR [rbp-80], rax
	mov	rax, QWORD PTR [rdi+56]
	mov	r12, QWORD PTR [rdi+8]
	mov	QWORD PTR [rbp-248], rax
	mov	rax, QWORD PTR [rdi+48]
	mov	QWORD PTR [rbp-176], rdi
	mov	QWORD PTR [rbp-216], rax
	mov	rax, QWORD PTR [rdi+16]
	mov	QWORD PTR [rbp-344], r13
	mov	QWORD PTR [rbp-336], r15
	mov	QWORD PTR [rbp-352], rax
	call	omp_get_thread_num
	movsx	rsi, eax
	mov	rax, QWORD PTR [r13+0+rsi*8]
	mov	QWORD PTR [rbp-232], rsi
	mov	rdi, QWORD PTR [rax]
	lea	rbx, [0+rsi*8]
	mov	QWORD PTR [rbp-88], rdi
	mov	rdi, QWORD PTR [rax+8]
	mov	rax, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-96], rdi
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [r15+rsi*8]
	mov	rsi, r14
	mov	r11, QWORD PTR [rax]
	mov	r8, QWORD PTR [rax+8]
	mov	rdi, QWORD PTR [rax+16]
	mov	rax, QWORD PTR [r14]
	mov	r14, QWORD PTR [rax+24]
	mov	r13, QWORD PTR [rax+32]
	mov	rax, QWORD PTR [rax+40]
	mov	QWORD PTR [rbp-144], rax
	mov	rax, QWORD PTR [r12]
	mov	QWORD PTR [rbp-104], rax
	mov	rax, QWORD PTR [r12+8]
	mov	QWORD PTR [rbp-112], rax
	mov	rax, QWORD PTR [r12+16]
	mov	QWORD PTR [rbp-120], rax
	mov	rax, QWORD PTR [rsi+40]
	mov	r12, QWORD PTR [rax]
	test	r12, r12
	je	.L156
	mov	QWORD PTR [rbp-152], rdi
	mov	QWORD PTR [rbp-136], r8
	mov	QWORD PTR [rbp-72], r11
	call	omp_get_num_threads
	movsx	rsi, eax
	xor	edx, edx
	mov	rax, r12
	div	rsi
	mov	r11, QWORD PTR [rbp-72]
	mov	r8, QWORD PTR [rbp-136]
	mov	rdi, QWORD PTR [rbp-152]
	cmp	QWORD PTR [rbp-232], rdx
	mov	r12, rdx
	jb	.L155
.L160:
	mov	rdx, QWORD PTR [rbp-232]
	imul	rdx, rax
	lea	r10, [rdx+r12]
	lea	rsi, [rax+r10]
	cmp	r10, rsi
	jb	.L182
.L156:
	mov	QWORD PTR [rbp-152], rdi
	mov	QWORD PTR [rbp-136], r8
	mov	QWORD PTR [rbp-72], r11
	call	GOMP_barrier
	mov	rax, QWORD PTR [rbp-176]
	mov	r11, QWORD PTR [rbp-72]
	mov	rax, QWORD PTR [rax+40]
	mov	r8, QWORD PTR [rbp-136]
	mov	r15, QWORD PTR [rax]
	mov	rdi, QWORD PTR [rbp-152]
	mov	rax, r15
	shr	rax, 8
	test	r15b, r15b
	mov	QWORD PTR [rbp-240], rax
	je	.L183
	inc	QWORD PTR [rbp-240]
.L129:
	mov	rax, QWORD PTR [rbp-88]
	mov	QWORD PTR [rbp-224], 0
	add	rax, rbx
	mov	QWORD PTR [rbp-288], rax
	mov	rax, QWORD PTR [rbp-96]
	mov	QWORD PTR [rbp-304], r11
	add	rax, rbx
	mov	QWORD PTR [rbp-280], rax
	mov	rax, QWORD PTR [rbp-128]
	mov	QWORD PTR [rbp-312], r8
	add	rax, rbx
	mov	QWORD PTR [rbp-272], rax
	lea	rax, [r14+rbx]
	mov	QWORD PTR [rbp-264], rax
	lea	rax, [r13+0+rbx]
	mov	QWORD PTR [rbp-256], rax
	mov	rax, QWORD PTR [rbp-80]
	mov	QWORD PTR [rbp-320], rdi
	add	rax, QWORD PTR [rbp-216]
	mov	QWORD PTR [rbp-296], rax
	mov	r12, r15
	.p2align 4,,10
	.p2align 3
.L140:
	mov	rsi, QWORD PTR [rbp-224]
	mov	rax, rsi
	sal	rax, 8
	mov	QWORD PTR [rbp-192], rax
	add	rax, 256
	inc	rsi
	cmp	r12, rax
	mov	QWORD PTR [rbp-56], rax
	cmovbe	rax, r12
	mov	QWORD PTR [rbp-224], rsi
	mov	QWORD PTR [rbp-96], rax
	test	rax, rax
	je	.L141
	call	omp_get_num_threads
	movsx	rdi, eax
	mov	rcx, QWORD PTR [rbp-232]
	mov	rax, QWORD PTR [rbp-96]
	mov	QWORD PTR [rbp-184], rdi
	cmp	rcx, rax
	vmovq	xmm8, QWORD PTR .LC0[rip]
	vmovq	xmm7, QWORD PTR .LC2[rip]
	vmovq	xmm6, QWORD PTR .LC3[rip]
	jnb	.L141
	mov	rax, QWORD PTR [rbp-296]
	xor	edx, edx
	div	QWORD PTR [rbp-248]
	mov	rax, QWORD PTR [rbp-176]
	mov	r11, QWORD PTR [rbp-256]
	mov	rsi, QWORD PTR [rax]
	mov	r14, QWORD PTR [rbp-280]
	mov	r13, QWORD PTR [rbp-288]
	mov	r15, QWORD PTR [rbp-272]
	mov	r8, QWORD PTR [rbp-304]
	mov	r9, QWORD PTR [rbp-312]
	lea	rax, [0+rdi*8]
	mov	rdi, QWORD PTR [rbp-264]
	mov	r10, QWORD PTR [rbp-320]
	mov	QWORD PTR [rbp-200], rax
	mov	QWORD PTR [rbp-128], r11
	mov	QWORD PTR [rbp-136], rdi
	mov	rax, rcx
	vxorpd	xmm5, xmm5, xmm5
	mov	rdi, r14
	mov	r11, r13
	mov	QWORD PTR [rbp-208], rdx
	.p2align 4,,10
	.p2align 3
.L147:
	mov	rbx, QWORD PTR [rbp-216]
	mov	rcx, QWORD PTR [rsi+16]
	mov	rdx, rbx
	imul	rdx, r12
	lea	r13, [rax+1]
	add	rdx, rax
	vmovsd	xmm4, QWORD PTR [rcx+rdx*8]
	mov	rdx, QWORD PTR [rbp-208]
	vxorpd	xmm4, xmm4, xmm8
	cmp	rbx, rdx
	cmovb	r13, rax
	mov	rbx, QWORD PTR [rbp-192]
	cmp	r13, rbx
	cmovb	r13, rbx
	imul	r12, rdx
	mov	rdx, r13
	and	edx, 7
	jne	.L143
.L151:
	mov	rdx, QWORD PTR [rbp-136]
	mov	rbx, QWORD PTR [rbp-96]
	vbroadcastsd	zmm16, QWORD PTR [rdx]
	mov	rdx, QWORD PTR [rbp-128]
	vxorpd	xmm13, xmm13, xmm13
	vbroadcastsd	zmm17, QWORD PTR [rdx]
	mov	rdx, QWORD PTR [rbp-144]
	vmovapd	zmm12, zmm13
	vbroadcastsd	zmm18, QWORD PTR [rdx+rax*8]
	lea	rdx, [r13+7]
	vmovapd	zmm11, zmm13
	vbroadcastsd	zmm19, xmm4
	vbroadcastsd	zmm14, xmm7
	vbroadcastsd	zmm15, xmm6
	cmp	rdx, rbx
	jnb	.L162
	lea	rdx, [r13+0+r12]
	mov	QWORD PTR [rbp-72], r12
	mov	QWORD PTR [rbp-80], r15
	mov	QWORD PTR [rbp-88], rax
	sal	rdx, 3
	mov	r14, QWORD PTR [rbp-112]
	mov	r12, QWORD PTR [rbp-104]
	mov	r15, QWORD PTR [rbp-120]
	mov	rax, rbx
	jmp	.L145
	.p2align 4,,10
	.p2align 3
.L184:
	mov	rcx, QWORD PTR [rsi+16]
	mov	r13, rbx
.L145:
	vsubpd	zmm10, zmm17, ZMMWORD PTR [r14+r13*8]
	vsubpd	zmm20, zmm16, ZMMWORD PTR [r12+r13*8]
	vsubpd	zmm9, zmm18, ZMMWORD PTR [r15+r13*8]
	vmulpd	zmm2, zmm10, zmm10
	lea	rbx, [r13+8]
	vfmadd231pd	zmm2, zmm20, zmm20
	vmovapd	zmm3, zmm2
	vfmadd231pd	zmm3, zmm9, zmm9
	vrsqrt14pd	zmm2, zmm3
	vmulpd	zmm1, zmm2, zmm2
	vmulpd	zmm2, zmm15, zmm2
	vfnmadd132pd	zmm1, zmm14, zmm3
	vmulpd	zmm1, zmm1, zmm2
	vmulpd	zmm2, zmm1, zmm1
	vmulpd	zmm1, zmm15, zmm1
	vfnmadd132pd	zmm2, zmm14, zmm3
	vmulpd	zmm2, zmm2, zmm1
	vmulpd	zmm1, zmm19, ZMMWORD PTR [rcx+rdx]
	add	rdx, 64
	vmulpd	zmm0, zmm2, zmm2
	vmulpd	zmm0, zmm0, zmm2
	vmulpd	zmm0, zmm1, zmm0
	vfmadd231pd	zmm12, zmm0, zmm10
	vfmadd231pd	zmm11, zmm0, zmm9
	vfnmadd213pd	zmm10, zmm0, ZMMWORD PTR [r9+r13*8]
	vfnmadd213pd	zmm9, zmm0, ZMMWORD PTR [r10+r13*8]
	vfmadd231pd	zmm13, zmm0, zmm20
	vfnmadd213pd	zmm0, zmm20, ZMMWORD PTR [r8+r13*8]
	vmovapd	ZMMWORD PTR [r8+r13*8], zmm0
	vmovapd	ZMMWORD PTR [r9+r13*8], zmm10
	vmovapd	ZMMWORD PTR [r10+r13*8], zmm9
	add	r13, 15
	cmp	rax, r13
	ja	.L184
	mov	r12, QWORD PTR [rbp-72]
	mov	r15, QWORD PTR [rbp-80]
	mov	rax, QWORD PTR [rbp-88]
.L144:
	vextractf64x4	ymm0, zmm13, 0x1
	vaddpd	ymm13, ymm13, ymm0
	vextractf64x2	xmm0, ymm13, 0x1
	vaddpd	xmm13, xmm0, xmm13
	vextractf64x4	ymm0, zmm12, 0x1
	vaddpd	ymm12, ymm12, ymm0
	vhaddpd	xmm13, xmm13, xmm13
	vextractf64x2	xmm0, ymm12, 0x1
	vaddpd	xmm0, xmm12, xmm0
	vaddsd	xmm13, xmm13, QWORD PTR [r11]
	vhaddpd	xmm0, xmm0, xmm0
	vmovsd	QWORD PTR [r11], xmm13
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vextractf64x4	ymm0, zmm11, 0x1
	vaddpd	ymm11, ymm11, ymm0
	vextractf64x2	xmm0, ymm11, 0x1
	vaddpd	xmm0, xmm11, xmm0
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [r15]
	vmovsd	QWORD PTR [r15], xmm0
	cmp	rbx, QWORD PTR [rbp-96]
	jnb	.L149
	mov	rcx, QWORD PTR [rbp-96]
	add	rbx, r12
	lea	rdx, [r12+rcx]
	lea	rcx, [0+rdx*8]
	mov	QWORD PTR [rbp-80], rcx
	neg	r12
	mov	rcx, QWORD PTR [rbp-104]
	sal	r12, 3
	add	rcx, r12
	mov	QWORD PTR [rbp-72], rcx
	mov	rcx, QWORD PTR [rbp-112]
	lea	r14, [r8+r12]
	lea	rdx, [rcx+r12]
	mov	rcx, QWORD PTR [rbp-120]
	mov	QWORD PTR [rbp-88], rdx
	lea	r13, [r9+r12]
	add	rcx, r12
	mov	QWORD PTR [rbp-152], r8
	add	r12, r10
	mov	QWORD PTR [rbp-160], r9
	mov	QWORD PTR [rbp-168], r10
	mov	r8, QWORD PTR [rbp-144]
	mov	r9, QWORD PTR [rbp-128]
	mov	r10, QWORD PTR [rbp-136]
	sal	rbx, 3
	vxorpd	xmm11, xmm11, xmm11
	.p2align 4,,10
	.p2align 3
.L150:
	mov	rdx, QWORD PTR [rbp-72]
	vmovsd	xmm3, QWORD PTR [r10]
	vmovsd	xmm2, QWORD PTR [r9]
	vsubsd	xmm3, xmm3, QWORD PTR [rdx+rbx]
	mov	rdx, QWORD PTR [rbp-88]
	vmovsd	xmm1, QWORD PTR [r8+rax*8]
	vsubsd	xmm2, xmm2, QWORD PTR [rdx+rbx]
	vsubsd	xmm1, xmm1, QWORD PTR [rcx+rbx]
	vmulsd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm11, xmm0
	vsqrtsd	xmm10, xmm10, xmm0
	ja	.L185
.L148:
	mov	rdx, QWORD PTR [rsi+16]
	vmulsd	xmm0, xmm10, xmm10
	vmulsd	xmm9, xmm4, QWORD PTR [rdx+rbx]
	vmulsd	xmm0, xmm0, xmm10
	vmulsd	xmm3, xmm3, xmm9
	vmulsd	xmm2, xmm2, xmm9
	vmulsd	xmm1, xmm1, xmm9
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [r11]
	vmovsd	QWORD PTR [r11], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [r15]
	vmovsd	QWORD PTR [r15], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rbx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [r14+rbx], xmm3
	vmovsd	xmm0, QWORD PTR [r13+0+rbx]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [r13+0+rbx], xmm2
	vmovsd	xmm0, QWORD PTR [r12+rbx]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12+rbx], xmm1
	add	rbx, 8
	cmp	rbx, QWORD PTR [rbp-80]
	jne	.L150
	mov	r8, QWORD PTR [rbp-152]
	mov	r9, QWORD PTR [rbp-160]
	mov	r10, QWORD PTR [rbp-168]
.L149:
	mov	rcx, QWORD PTR [rbp-200]
	add	rax, QWORD PTR [rbp-184]
	add	r11, rcx
	add	rdi, rcx
	add	r15, rcx
	add	QWORD PTR [rbp-136], rcx
	add	QWORD PTR [rbp-128], rcx
	cmp	QWORD PTR [rbp-96], rax
	jbe	.L179
	mov	rcx, QWORD PTR [rbp-176]
	mov	rdx, QWORD PTR [rcx+40]
	mov	r12, QWORD PTR [rdx]
	jmp	.L147
	.p2align 4,,10
	.p2align 3
.L143:
	lea	r14, [r13+8]
	cmp	r13, QWORD PTR [rbp-96]
	jnb	.L151
	sub	r14, rdx
	mov	rdx, QWORD PTR [rbp-144]
	lea	rbx, [r12+r13]
	mov	QWORD PTR [rbp-72], rdx
	mov	QWORD PTR [rbp-80], rsi
	sal	rbx, 3
	mov	QWORD PTR [rbp-88], r12
	mov	rdx, QWORD PTR [rbp-128]
	mov	rsi, QWORD PTR [rbp-136]
	jmp	.L152
	.p2align 4,,10
	.p2align 3
.L174:
	add	rbx, 8
	cmp	r13, QWORD PTR [rbp-96]
	je	.L176
.L152:
	mov	r12, QWORD PTR [rbp-104]
	vmovsd	xmm3, QWORD PTR [rsi]
	vmovsd	xmm2, QWORD PTR [rdx]
	vsubsd	xmm3, xmm3, QWORD PTR [r12+r13*8]
	mov	r12, QWORD PTR [rbp-112]
	vsubsd	xmm2, xmm2, QWORD PTR [r12+r13*8]
	mov	r12, QWORD PTR [rbp-72]
	vmulsd	xmm0, xmm2, xmm2
	vmovsd	xmm1, QWORD PTR [r12+rax*8]
	mov	r12, QWORD PTR [rbp-120]
	vsubsd	xmm1, xmm1, QWORD PTR [r12+r13*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm5, xmm0
	vsqrtsd	xmm10, xmm10, xmm0
	ja	.L186
.L153:
	vmulsd	xmm9, xmm4, QWORD PTR [rcx+rbx]
	vmulsd	xmm0, xmm10, xmm10
	vmulsd	xmm3, xmm3, xmm9
	vmulsd	xmm0, xmm0, xmm10
	vmulsd	xmm2, xmm2, xmm9
	vmulsd	xmm1, xmm1, xmm9
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [r11]
	vmovsd	QWORD PTR [r11], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [r15]
	vmovsd	QWORD PTR [r15], xmm0
	vmovsd	xmm0, QWORD PTR [r8+r13*8]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [r8+r13*8], xmm3
	vmovsd	xmm0, QWORD PTR [r9+r13*8]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [r9+r13*8], xmm2
	vmovsd	xmm0, QWORD PTR [r10+r13*8]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r10+r13*8], xmm1
	inc	r13
	cmp	r13, r14
	jne	.L174
.L176:
	mov	r12, QWORD PTR [rbp-88]
	mov	rsi, QWORD PTR [rbp-80]
	jmp	.L151
	.p2align 4,,10
	.p2align 3
.L179:
	vzeroupper
.L141:
	call	GOMP_barrier
	mov	rax, QWORD PTR [rbp-176]
	mov	rsi, QWORD PTR [rbp-240]
	mov	rax, QWORD PTR [rax+40]
	cmp	QWORD PTR [rbp-224], rsi
	jnb	.L187
	mov	r12, QWORD PTR [rax]
	jmp	.L140
	.p2align 4,,10
	.p2align 3
.L162:
	mov	rbx, r13
	jmp	.L144
.L187:
	mov	r15, QWORD PTR [rax]
.L139:
	test	r15, r15
	je	.L132
	call	omp_get_num_threads
	movsx	rsi, eax
	xor	edx, edx
	mov	rax, r15
	div	rsi
	mov	r15, rdx
	cmp	QWORD PTR [rbp-232], rdx
	jb	.L131
.L136:
	mov	r11, QWORD PTR [rbp-232]
	imul	r11, rax
	add	r11, r15
	add	rax, r11
	mov	QWORD PTR [rbp-80], rax
	cmp	r11, rax
	jnb	.L132
	mov	rax, QWORD PTR [rbp-176]
	mov	rsi, QWORD PTR [rbp-328]
	mov	rax, QWORD PTR [rax]
	test	rsi, rsi
	je	.L132
	mov	r13, QWORD PTR [rax+72]
	mov	r14, QWORD PTR [rax+80]
	mov	r15, QWORD PTR [rax+88]
	mov	rax, QWORD PTR [rbp-352]
	mov	QWORD PTR [rbp-104], r14
	mov	rdi, QWORD PTR [rax]
	mov	r12, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-88], rdi
	mov	rdi, QWORD PTR [rax+8]
	mov	QWORD PTR [rbp-112], r15
	mov	QWORD PTR [rbp-96], rdi
	mov	r15, r13
	mov	r14, QWORD PTR [rbp-344]
	mov	r13, QWORD PTR [rbp-336]
	mov	QWORD PTR [rbp-120], r12
	mov	r12, rsi
.L134:
	mov	rsi, QWORD PTR [rbp-104]
	lea	rax, [0+r11*8]
	lea	r10, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-112]
	mov	QWORD PTR [rbp-72], r11
	lea	r9, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-88]
	lea	rbx, [r15+rax]
	lea	r8, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-96]
	xor	edx, edx
	lea	rdi, [rsi+rax]
	mov	rsi, QWORD PTR [rbp-120]
	add	rsi, rax
	.p2align 4,,10
	.p2align 3
.L133:
	mov	rcx, QWORD PTR [r14+rdx*8]
	vmovsd	xmm0, QWORD PTR [rbx]
	mov	r11, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	mov	r11, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r10]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	vmovsd	QWORD PTR [r10], xmm0
	vmovsd	xmm0, QWORD PTR [r9]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	mov	rcx, QWORD PTR [r13+0+rdx*8]
	inc	rdx
	vmovsd	QWORD PTR [r9], xmm0
	mov	r11, QWORD PTR [rcx]
	vmovsd	xmm0, QWORD PTR [r8]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	mov	r11, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	r12, rdx
	jne	.L133
	mov	r11, QWORD PTR [rbp-72]
	inc	r11
	cmp	QWORD PTR [rbp-80], r11
	jne	.L134
.L132:
	call	GOMP_barrier
	add	rsp, 448
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
.L182:
	.cfi_restore_state
	mov	rax, QWORD PTR [rbp-328]
	test	rax, rax
	je	.L156
	mov	r15, rbx
	mov	r12, QWORD PTR [rbp-344]
	mov	rbx, QWORD PTR [rbp-336]
	mov	r9, rax
.L158:
	mov	QWORD PTR [rbp-72], rsi
	lea	rax, [0+r10*8]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L157:
	mov	rcx, QWORD PTR [r12+rdx*8]
	mov	rsi, QWORD PTR [rcx]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	rsi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	mov	rcx, QWORD PTR [rbx+rdx*8]
	inc	rdx
	mov	rsi, QWORD PTR [rcx]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	rsi, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [rsi+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	cmp	r9, rdx
	jne	.L157
	mov	rsi, QWORD PTR [rbp-72]
	inc	r10
	cmp	rsi, r10
	jne	.L158
	mov	rbx, r15
	jmp	.L156
.L183:
	test	rax, rax
	jne	.L129
	jmp	.L139
.L155:
	inc	rax
	xor	r12d, r12d
	jmp	.L160
.L185:
	mov	QWORD PTR [rbp-448], rcx
	mov	QWORD PTR [rbp-440], rax
	mov	QWORD PTR [rbp-432], r11
	mov	QWORD PTR [rbp-424], rdi
	mov	QWORD PTR [rbp-416], r10
	mov	QWORD PTR [rbp-408], r9
	mov	QWORD PTR [rbp-400], r8
	vmovsd	QWORD PTR [rbp-392], xmm10
	vmovsd	QWORD PTR [rbp-384], xmm1
	vmovsd	QWORD PTR [rbp-376], xmm2
	vmovsd	QWORD PTR [rbp-368], xmm3
	vmovsd	QWORD PTR [rbp-360], xmm4
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-176]
	vxorpd	xmm5, xmm5, xmm5
	mov	rsi, QWORD PTR [rax]
	mov	rcx, QWORD PTR [rbp-448]
	mov	rax, QWORD PTR [rbp-440]
	mov	r11, QWORD PTR [rbp-432]
	mov	rdi, QWORD PTR [rbp-424]
	mov	r10, QWORD PTR [rbp-416]
	mov	r9, QWORD PTR [rbp-408]
	mov	r8, QWORD PTR [rbp-400]
	vmovq	xmm6, QWORD PTR .LC3[rip]
	vmovq	xmm7, QWORD PTR .LC2[rip]
	vmovq	xmm8, QWORD PTR .LC0[rip]
	vmovapd	xmm11, xmm5
	vmovsd	xmm10, QWORD PTR [rbp-392]
	vmovsd	xmm1, QWORD PTR [rbp-384]
	vmovsd	xmm2, QWORD PTR [rbp-376]
	vmovsd	xmm3, QWORD PTR [rbp-368]
	vmovsd	xmm4, QWORD PTR [rbp-360]
	jmp	.L148
.L131:
	inc	rax
	xor	r15d, r15d
	jmp	.L136
.L186:
	mov	QWORD PTR [rbp-432], rax
	mov	QWORD PTR [rbp-424], r11
	mov	QWORD PTR [rbp-416], rdi
	mov	QWORD PTR [rbp-408], rsi
	mov	QWORD PTR [rbp-400], rdx
	mov	QWORD PTR [rbp-392], r10
	mov	QWORD PTR [rbp-384], r9
	mov	QWORD PTR [rbp-376], r8
	vmovsd	QWORD PTR [rbp-368], xmm10
	vmovsd	QWORD PTR [rbp-360], xmm1
	vmovsd	QWORD PTR [rbp-168], xmm2
	vmovsd	QWORD PTR [rbp-160], xmm3
	vmovsd	QWORD PTR [rbp-152], xmm4
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-176]
	mov	r11, QWORD PTR [rbp-424]
	mov	rax, QWORD PTR [rax]
	mov	rdi, QWORD PTR [rbp-416]
	mov	QWORD PTR [rbp-80], rax
	mov	rcx, QWORD PTR [rax+16]
	mov	rsi, QWORD PTR [rbp-408]
	mov	rax, QWORD PTR [rbp-432]
	mov	rdx, QWORD PTR [rbp-400]
	mov	r10, QWORD PTR [rbp-392]
	mov	r9, QWORD PTR [rbp-384]
	mov	r8, QWORD PTR [rbp-376]
	vmovq	xmm6, QWORD PTR .LC3[rip]
	vmovq	xmm7, QWORD PTR .LC2[rip]
	vmovq	xmm8, QWORD PTR .LC0[rip]
	vxorpd	xmm5, xmm5, xmm5
	vmovsd	xmm10, QWORD PTR [rbp-368]
	vmovsd	xmm1, QWORD PTR [rbp-360]
	vmovsd	xmm2, QWORD PTR [rbp-168]
	vmovsd	xmm3, QWORD PTR [rbp-160]
	vmovsd	xmm4, QWORD PTR [rbp-152]
	jmp	.L153
	.cfi_endproc
.LFE8445:
	.size	_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2, .-_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2
	.p2align 4,,15
	.type	_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3, @function
_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3:
.LFB8446:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
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
	mov	r14, rdi
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	sub	rsp, 448
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rax, QWORD PTR [rdi+72]
	mov	r13, QWORD PTR [rdi+32]
	mov	QWORD PTR [rbp-264], rax
	mov	rax, QWORD PTR [rdi+64]
	mov	r15, QWORD PTR [rdi+24]
	mov	QWORD PTR [rbp-272], rax
	mov	rax, QWORD PTR [rdi+56]
	mov	r12, QWORD PTR [rdi+8]
	mov	QWORD PTR [rbp-280], rax
	mov	rax, QWORD PTR [rdi+48]
	mov	QWORD PTR [rbp-288], r13
	mov	QWORD PTR [rbp-200], rax
	mov	rax, QWORD PTR [rdi+16]
	mov	QWORD PTR [rbp-296], r15
	mov	QWORD PTR [rbp-352], rax
	call	omp_get_thread_num
	movsx	rdx, eax
	mov	rax, QWORD PTR [r15+rdx*8]
	mov	QWORD PTR [rbp-248], rdx
	mov	rsi, QWORD PTR [rax]
	mov	r15, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-72], rsi
	mov	rsi, QWORD PTR [rax+8]
	mov	rax, QWORD PTR [r13+0+rdx*8]
	mov	QWORD PTR [rbp-80], rsi
	mov	r11, QWORD PTR [rax]
	mov	r13, QWORD PTR [rax+8]
	mov	rax, QWORD PTR [rax+16]
	lea	rbx, [0+rdx*8]
	mov	QWORD PTR [rbp-168], rax
	mov	rax, QWORD PTR [r14]
	mov	rdx, QWORD PTR [rax+24]
	mov	rsi, QWORD PTR [rax+32]
	mov	rax, QWORD PTR [rax+40]
	mov	QWORD PTR [rbp-88], rdx
	mov	QWORD PTR [rbp-176], rax
	mov	rax, QWORD PTR [r12]
	mov	QWORD PTR [rbp-96], rsi
	mov	QWORD PTR [rbp-104], rax
	mov	rax, QWORD PTR [r12+8]
	mov	QWORD PTR [rbp-112], rax
	mov	rax, QWORD PTR [r12+16]
	mov	QWORD PTR [rbp-120], rax
	mov	rax, QWORD PTR [r14+40]
	mov	r12, QWORD PTR [rax]
	test	r12, r12
	je	.L221
	mov	QWORD PTR [rbp-128], r11
	call	omp_get_num_threads
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r12
	div	rcx
	mov	r11, QWORD PTR [rbp-128]
	cmp	QWORD PTR [rbp-248], rdx
	mov	r12, rdx
	jb	.L220
.L225:
	mov	rdi, QWORD PTR [rbp-248]
	imul	rdi, rax
	add	rdi, r12
	lea	r8, [rax+rdi]
	cmp	rdi, r8
	jb	.L247
.L221:
	mov	QWORD PTR [rbp-128], r11
	call	GOMP_barrier
	mov	rax, QWORD PTR [r14+40]
	mov	r11, QWORD PTR [rbp-128]
	mov	rcx, QWORD PTR [rax]
	mov	rax, rcx
	shr	rax, 10
	test	ecx, 1023
	mov	QWORD PTR [rbp-256], rax
	je	.L248
	inc	QWORD PTR [rbp-256]
.L191:
	mov	rax, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-240], 0
	add	rax, rbx
	mov	QWORD PTR [rbp-336], rax
	mov	rax, QWORD PTR [rbp-80]
	mov	QWORD PTR [rbp-344], r11
	add	rax, rbx
	mov	QWORD PTR [rbp-328], rax
	lea	rax, [r15+rbx]
	mov	QWORD PTR [rbp-320], rax
	mov	rax, QWORD PTR [rbp-88]
	mov	r12, rcx
	add	rax, rbx
	add	rbx, QWORD PTR [rbp-96]
	mov	QWORD PTR [rbp-312], rax
	mov	QWORD PTR [rbp-304], rbx
.L202:
	mov	rsi, QWORD PTR [rbp-240]
	mov	rax, rsi
	sal	rax, 10
	mov	QWORD PTR [rbp-216], rax
	add	rax, 1024
	inc	rsi
	cmp	r12, rax
	mov	QWORD PTR [rbp-56], rax
	cmovbe	rax, r12
	mov	QWORD PTR [rbp-240], rsi
	mov	QWORD PTR [rbp-96], rax
	test	rax, rax
	je	.L203
	call	omp_get_num_threads
	movsx	rsi, eax
	mov	r15, QWORD PTR [rbp-248]
	mov	rax, QWORD PTR [rbp-96]
	mov	QWORD PTR [rbp-208], rsi
	cmp	r15, rax
	vmovq	xmm30, QWORD PTR .LC0[rip]
	jnb	.L203
	mov	rax, QWORD PTR [rbp-272]
	xor	edx, edx
	add	rax, QWORD PTR [rbp-200]
	div	QWORD PTR [rbp-280]
	mov	r11, QWORD PTR [rbp-344]
	lea	rax, [0+rsi*8]
	mov	QWORD PTR [rbp-224], rax
	mov	rax, QWORD PTR [rbp-304]
	mov	QWORD PTR [rbp-128], rax
	mov	rax, QWORD PTR [rbp-312]
	mov	QWORD PTR [rbp-136], rax
	mov	rax, QWORD PTR [rbp-320]
	mov	QWORD PTR [rbp-144], rax
	mov	rax, QWORD PTR [rbp-328]
	mov	QWORD PTR [rbp-152], rax
	mov	rax, QWORD PTR [rbp-336]
	mov	QWORD PTR [rbp-232], rdx
	mov	QWORD PTR [rbp-160], rax
	.p2align 4,,10
	.p2align 3
.L210:
	mov	rsi, QWORD PTR [rbp-200]
	mov	rcx, QWORD PTR [rbp-232]
	mov	rdx, rsi
	imul	rdx, r12
	lea	rbx, [r15+1]
	mov	rax, QWORD PTR [r14]
	add	rdx, r15
	cmp	rsi, rcx
	cmovb	rbx, r15
	mov	rsi, QWORD PTR [rbp-216]
	mov	rax, QWORD PTR [rax+16]
	cmp	rbx, rsi
	cmovb	rbx, rsi
	imul	r12, rcx
	vmovsd	xmm8, QWORD PTR [rax+rdx*8]
	mov	rcx, rbx
	vxorpd	xmm8, xmm8, xmm30
	mov	QWORD PTR [rbp-72], r12
	and	ecx, 7
	jne	.L205
.L216:
	mov	rax, QWORD PTR [rbp-136]
	mov	r12, QWORD PTR [rbp-96]
	vbroadcastsd	zmm15, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-128]
	vxorpd	xmm31, xmm31, xmm31
	vbroadcastsd	zmm16, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-176]
	vbroadcastsd	zmm18, xmm8
	vbroadcastsd	zmm17, QWORD PTR [rax+r15*8]
	lea	rax, [rbx+31]
	vbroadcastsd	zmm13, QWORD PTR .LC2[rip]
	vbroadcastsd	zmm14, QWORD PTR .LC3[rip]
	vmovapd	zmm27, zmm31
	vmovapd	zmm19, zmm31
	cmp	r12, rax
	jbe	.L227
	mov	rax, QWORD PTR [rbp-104]
	lea	rdx, [0+rbx*8]
	lea	r9, [rax+rdx]
	mov	rax, QWORD PTR [rbp-112]
	lea	rsi, [r11+rdx]
	lea	r8, [rax+rdx]
	mov	rax, QWORD PTR [rbp-120]
	lea	rcx, [r13+0+rdx]
	lea	rdi, [rax+rdx]
	mov	rax, QWORD PTR [rbp-72]
	mov	QWORD PTR [rbp-80], r11
	lea	r10, [rbx+rax]
	sal	r10, 3
	add	rdx, QWORD PTR [rbp-168]
	vmovapd	zmm22, zmm31
	vmovapd	zmm23, zmm31
	vmovapd	zmm24, zmm31
	vmovapd	zmm25, zmm31
	vmovapd	zmm26, zmm31
	vmovapd	zmm20, zmm31
	vmovapd	zmm28, zmm31
	vmovapd	zmm29, zmm31
	vmovapd	zmm21, zmm31
	mov	r11, r12
	.p2align 4,,10
	.p2align 3
.L207:
	vsubpd	zmm9, zmm15, ZMMWORD PTR [r9]
	vsubpd	zmm4, zmm15, ZMMWORD PTR [r9+64]
	vsubpd	zmm10, zmm15, ZMMWORD PTR [r9+128]
	vsubpd	zmm5, zmm15, ZMMWORD PTR [r9+192]
	vsubpd	zmm11, zmm16, ZMMWORD PTR [r8]
	vsubpd	zmm6, zmm16, ZMMWORD PTR [r8+64]
	vsubpd	zmm12, zmm16, ZMMWORD PTR [r8+128]
	vsubpd	zmm7, zmm16, ZMMWORD PTR [r8+192]
	vsubpd	zmm3, zmm17, ZMMWORD PTR [rdi]
	vsubpd	zmm2, zmm17, ZMMWORD PTR [rdi+64]
	vsubpd	zmm1, zmm17, ZMMWORD PTR [rdi+128]
	vsubpd	zmm0, zmm17, ZMMWORD PTR [rdi+192]
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
	vfnmadd132pd	zmm12, zmm13, zmm3
	vfnmadd132pd	zmm10, zmm13, zmm2
	vfnmadd132pd	zmm7, zmm13, zmm1
	vfnmadd132pd	zmm5, zmm13, zmm0
	vmulpd	zmm11, zmm14, zmm11
	vmulpd	zmm9, zmm14, zmm9
	vmulpd	zmm6, zmm14, zmm6
	vmulpd	zmm4, zmm14, zmm4
	vmulpd	zmm12, zmm11, zmm12
	vmulpd	zmm10, zmm9, zmm10
	vmulpd	zmm7, zmm6, zmm7
	vmulpd	zmm5, zmm4, zmm5
	vmulpd	zmm11, zmm12, zmm12
	vmulpd	zmm9, zmm10, zmm10
	vmulpd	zmm6, zmm7, zmm7
	vmulpd	zmm4, zmm5, zmm5
	vfnmadd132pd	zmm3, zmm13, zmm11
	vfnmadd132pd	zmm2, zmm13, zmm9
	vfnmadd132pd	zmm1, zmm13, zmm6
	vfnmadd132pd	zmm0, zmm13, zmm4
	vmulpd	zmm11, zmm14, zmm12
	vmulpd	zmm9, zmm14, zmm10
	vmulpd	zmm6, zmm14, zmm7
	vmulpd	zmm4, zmm14, zmm5
	vmulpd	zmm11, zmm11, zmm3
	vmulpd	zmm9, zmm9, zmm2
	vmulpd	zmm6, zmm6, zmm1
	vmulpd	zmm4, zmm4, zmm0
	mov	rax, QWORD PTR [r14]
	mov	rax, QWORD PTR [rax+16]
	vmulpd	zmm2, zmm18, ZMMWORD PTR [rax+r10]
	vmulpd	zmm1, zmm18, ZMMWORD PTR [rax+64+r10]
	vmulpd	zmm0, zmm18, ZMMWORD PTR [rax+128+r10]
	vmulpd	zmm5, zmm18, ZMMWORD PTR [rax+192+r10]
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
	vsubpd	zmm7, zmm15, ZMMWORD PTR [r9]
	vsubpd	zmm6, zmm15, ZMMWORD PTR [r9+64]
	vsubpd	zmm5, zmm15, ZMMWORD PTR [r9+128]
	vsubpd	zmm4, zmm15, ZMMWORD PTR [r9+192]
	vfmadd231pd	zmm31, zmm7, zmm3
	vfmadd231pd	zmm21, zmm6, zmm2
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
	vsubpd	zmm7, zmm17, ZMMWORD PTR [rdi]
	vsubpd	zmm6, zmm17, ZMMWORD PTR [rdi+64]
	vsubpd	zmm5, zmm17, ZMMWORD PTR [rdi+128]
	vsubpd	zmm4, zmm17, ZMMWORD PTR [rdi+192]
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
	lea	r12, [rbx+63]
	add	r9, 256
	add	r8, 256
	add	rdi, 256
	add	r10, 256
	add	rsi, 256
	add	rcx, 256
	add	rdx, 256
	mov	rbx, rax
	cmp	r11, r12
	ja	.L207
	mov	r11, QWORD PTR [rbp-80]
.L206:
	vaddpd	zmm9, zmm21, zmm31
	vaddpd	zmm6, zmm20, zmm27
	vaddpd	zmm7, zmm19, zmm24
	vaddpd	zmm9, zmm9, zmm29
	vaddpd	zmm6, zmm6, zmm26
	vaddpd	zmm7, zmm7, zmm23
	lea	rdx, [rax+7]
	vaddpd	zmm9, zmm9, zmm28
	vaddpd	zmm6, zmm6, zmm25
	vaddpd	zmm7, zmm7, zmm22
	cmp	QWORD PTR [rbp-96], rdx
	jbe	.L249
	mov	rdx, QWORD PTR [rbp-72]
	mov	rsi, QWORD PTR [r14]
	add	rdx, rax
	mov	rcx, QWORD PTR [rbp-168]
	mov	r8, QWORD PTR [rbp-104]
	mov	r9, QWORD PTR [rbp-112]
	mov	r10, QWORD PTR [rbp-120]
	mov	r12, QWORD PTR [rbp-96]
	sal	rdx, 3
	.p2align 4,,10
	.p2align 3
.L215:
	vsubpd	zmm4, zmm16, ZMMWORD PTR [r9+rax*8]
	vsubpd	zmm5, zmm15, ZMMWORD PTR [r8+rax*8]
	vsubpd	zmm3, zmm17, ZMMWORD PTR [r10+rax*8]
	vmulpd	zmm1, zmm4, zmm4
	mov	rdi, QWORD PTR [rsi+16]
	lea	rbx, [rax+8]
	vfmadd231pd	zmm1, zmm5, zmm5
	vfmadd231pd	zmm1, zmm3, zmm3
	vrsqrt14pd	zmm0, zmm1
	vmulpd	zmm2, zmm0, zmm0
	vmulpd	zmm0, zmm0, zmm14
	vfnmadd132pd	zmm2, zmm13, zmm1
	vmulpd	zmm2, zmm2, zmm0
	vmulpd	zmm0, zmm2, zmm2
	vfnmadd132pd	zmm1, zmm13, zmm0
	vmulpd	zmm0, zmm2, zmm14
	vmulpd	zmm0, zmm1, zmm0
	vmulpd	zmm1, zmm18, ZMMWORD PTR [rdi+rdx]
	lea	rdi, [rax+15]
	add	rdx, 64
	vmulpd	zmm2, zmm0, zmm0
	vmulpd	zmm0, zmm2, zmm0
	vmulpd	zmm0, zmm1, zmm0
	vfmadd231pd	zmm6, zmm4, zmm0
	vfmadd231pd	zmm7, zmm3, zmm0
	vfnmadd213pd	zmm4, zmm0, ZMMWORD PTR [r13+0+rax*8]
	vfnmadd213pd	zmm3, zmm0, ZMMWORD PTR [rcx+rax*8]
	vfmadd231pd	zmm9, zmm5, zmm0
	vfnmadd213pd	zmm0, zmm5, ZMMWORD PTR [r11+rax*8]
	vmovapd	ZMMWORD PTR [r11+rax*8], zmm0
	vmovapd	ZMMWORD PTR [r13+0+rax*8], zmm4
	vmovapd	ZMMWORD PTR [rcx+rax*8], zmm3
	mov	rax, rbx
	cmp	r12, rdi
	ja	.L215
.L214:
	vextractf64x4	ymm0, zmm9, 0x1
	vaddpd	ymm9, ymm9, ymm0
	mov	rax, QWORD PTR [rbp-160]
	vextractf64x2	xmm0, ymm9, 0x1
	vaddpd	xmm0, xmm9, xmm0
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	vextractf64x4	ymm0, zmm6, 0x1
	vaddpd	ymm6, ymm6, ymm0
	mov	rax, QWORD PTR [rbp-152]
	vextractf64x2	xmm0, ymm6, 0x1
	vaddpd	xmm0, xmm6, xmm0
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	vextractf64x4	ymm0, zmm7, 0x1
	vaddpd	ymm7, ymm7, ymm0
	mov	rax, QWORD PTR [rbp-144]
	vextractf64x2	xmm0, ymm7, 0x1
	vaddpd	xmm0, xmm7, xmm0
	vhaddpd	xmm0, xmm0, xmm0
	vaddsd	xmm0, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	cmp	rbx, QWORD PTR [rbp-96]
	jnb	.L212
	mov	rax, QWORD PTR [rbp-72]
	mov	rsi, QWORD PTR [rbp-96]
	add	rbx, rax
	add	rsi, rax
	neg	rax
	mov	r12, rax
	mov	rax, QWORD PTR [rbp-104]
	sal	r12, 3
	lea	r9, [rax+r12]
	mov	rax, QWORD PTR [rbp-112]
	sal	rsi, 3
	lea	r8, [rax+r12]
	mov	rax, QWORD PTR [rbp-120]
	lea	rdx, [r11+r12]
	lea	rdi, [rax+r12]
	mov	QWORD PTR [rbp-80], rdi
	lea	rax, [r13+0+r12]
	mov	QWORD PTR [rbp-72], r8
	mov	QWORD PTR [rbp-184], r11
	mov	QWORD PTR [rbp-192], r13
	mov	QWORD PTR [rbp-88], rsi
	mov	r8, QWORD PTR [rbp-176]
	mov	r10, QWORD PTR [rbp-128]
	mov	r11, QWORD PTR [rbp-136]
	mov	r13, QWORD PTR [rbp-144]
	mov	rcx, QWORD PTR [rbp-152]
	mov	rsi, QWORD PTR [rbp-160]
	sal	rbx, 3
	add	r12, QWORD PTR [rbp-168]
	vxorpd	xmm6, xmm6, xmm6
	.p2align 4,,10
	.p2align 3
.L213:
	mov	rdi, QWORD PTR [rbp-72]
	vmovsd	xmm2, QWORD PTR [r10]
	vmovsd	xmm3, QWORD PTR [r11]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rbx]
	vsubsd	xmm3, xmm3, QWORD PTR [r9+rbx]
	vmovsd	xmm1, QWORD PTR [r8+r15*8]
	vmulsd	xmm0, xmm2, xmm2
	mov	rdi, QWORD PTR [rbp-80]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rbx]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm6, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L250
.L211:
	mov	rdi, QWORD PTR [r14]
	vmulsd	xmm0, xmm5, xmm5
	mov	rdi, QWORD PTR [rdi+16]
	vmulsd	xmm4, xmm8, QWORD PTR [rdi+rbx]
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [r13+0]
	vmovsd	QWORD PTR [r13+0], xmm0
	vmovsd	xmm0, QWORD PTR [rdx+rbx]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [rdx+rbx], xmm3
	vmovsd	xmm0, QWORD PTR [rax+rbx]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [rax+rbx], xmm2
	vmovsd	xmm0, QWORD PTR [r12+rbx]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12+rbx], xmm1
	add	rbx, 8
	cmp	rbx, QWORD PTR [rbp-88]
	jne	.L213
	mov	r11, QWORD PTR [rbp-184]
	mov	r13, QWORD PTR [rbp-192]
.L212:
	mov	rax, QWORD PTR [rbp-224]
	add	r15, QWORD PTR [rbp-208]
	add	QWORD PTR [rbp-160], rax
	add	QWORD PTR [rbp-152], rax
	add	QWORD PTR [rbp-144], rax
	add	QWORD PTR [rbp-136], rax
	add	QWORD PTR [rbp-128], rax
	cmp	QWORD PTR [rbp-96], r15
	jbe	.L244
	mov	rax, QWORD PTR [r14+40]
	mov	r12, QWORD PTR [rax]
	jmp	.L210
.L205:
	lea	rdx, [rbx+8]
	cmp	rbx, QWORD PTR [rbp-96]
	jnb	.L216
	lea	r12, [rbx+r12]
	sub	rdx, rcx
	mov	QWORD PTR [rbp-88], r14
	sal	r12, 3
	vxorpd	xmm6, xmm6, xmm6
	mov	r8, QWORD PTR [rbp-176]
	mov	QWORD PTR [rbp-80], rax
	mov	r9, QWORD PTR [rbp-128]
	mov	r10, QWORD PTR [rbp-136]
	mov	rcx, QWORD PTR [rbp-144]
	mov	rsi, QWORD PTR [rbp-152]
	mov	rdi, QWORD PTR [rbp-160]
	mov	r14, QWORD PTR [rbp-168]
	jmp	.L217
	.p2align 4,,10
	.p2align 3
.L240:
	add	r12, 8
	cmp	rbx, QWORD PTR [rbp-96]
	je	.L242
.L217:
	mov	rax, QWORD PTR [rbp-104]
	vmovsd	xmm3, QWORD PTR [r10]
	vmovsd	xmm2, QWORD PTR [r9]
	vsubsd	xmm3, xmm3, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp-112]
	vmovsd	xmm1, QWORD PTR [r8+r15*8]
	vsubsd	xmm2, xmm2, QWORD PTR [rax+rbx*8]
	mov	rax, QWORD PTR [rbp-120]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [rax+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm6, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L251
.L218:
	mov	rax, QWORD PTR [rbp-80]
	vmulsd	xmm0, xmm5, xmm5
	vmulsd	xmm4, xmm8, QWORD PTR [rax+r12]
	vmulsd	xmm0, xmm0, xmm5
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm2, xmm2, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vdivsd	xmm1, xmm1, xmm0
	vaddsd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vaddsd	xmm0, xmm2, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vaddsd	xmm0, xmm1, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r11+rbx*8]
	vsubsd	xmm3, xmm0, xmm3
	vmovsd	QWORD PTR [r11+rbx*8], xmm3
	vmovsd	xmm0, QWORD PTR [r13+0+rbx*8]
	vsubsd	xmm2, xmm0, xmm2
	vmovsd	QWORD PTR [r13+0+rbx*8], xmm2
	vmovsd	xmm0, QWORD PTR [r14+rbx*8]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r14+rbx*8], xmm1
	inc	rbx
	cmp	rbx, rdx
	jne	.L240
.L242:
	mov	r14, QWORD PTR [rbp-88]
	jmp	.L216
.L244:
	vzeroupper
.L203:
	call	GOMP_barrier
	mov	rdx, QWORD PTR [rbp-256]
	mov	rax, QWORD PTR [r14+40]
	cmp	QWORD PTR [rbp-240], rdx
	jnb	.L252
	mov	r12, QWORD PTR [rax]
	jmp	.L202
.L249:
	mov	rbx, rax
	jmp	.L214
.L227:
	vxorpd	xmm22, xmm22, xmm22
	vmovapd	zmm23, zmm22
	vmovapd	zmm24, zmm22
	vmovapd	zmm25, zmm22
	vmovapd	zmm26, zmm22
	vmovapd	zmm20, zmm22
	vmovapd	zmm28, zmm22
	vmovapd	zmm29, zmm22
	vmovapd	zmm21, zmm22
	mov	rax, rbx
	jmp	.L206
.L252:
	mov	rcx, QWORD PTR [rax]
.L201:
	test	rcx, rcx
	je	.L194
	mov	QWORD PTR [rbp-72], rcx
	call	omp_get_num_threads
	mov	rcx, QWORD PTR [rbp-72]
	movsx	rsi, eax
	xor	edx, edx
	mov	rax, rcx
	div	rsi
	cmp	QWORD PTR [rbp-248], rdx
	jb	.L193
.L198:
	mov	r10, QWORD PTR [rbp-248]
	imul	r10, rax
	add	r10, rdx
	lea	r13, [rax+r10]
	cmp	r10, r13
	jnb	.L194
	mov	rsi, QWORD PTR [rbp-264]
	mov	rax, QWORD PTR [r14]
	test	rsi, rsi
	je	.L194
	mov	r14, QWORD PTR [rax+72]
	mov	r15, QWORD PTR [rax+80]
	mov	rax, QWORD PTR [rax+88]
	mov	QWORD PTR [rbp-96], r13
	mov	QWORD PTR [rbp-72], rax
	mov	rax, QWORD PTR [rbp-352]
	mov	QWORD PTR [rbp-104], r14
	mov	rdx, QWORD PTR [rax]
	mov	r12, QWORD PTR [rax+16]
	mov	QWORD PTR [rbp-80], rdx
	mov	rdx, QWORD PTR [rax+8]
	mov	r13, QWORD PTR [rbp-288]
	mov	QWORD PTR [rbp-88], rdx
	mov	r14, QWORD PTR [rbp-296]
	mov	QWORD PTR [rbp-112], r15
	mov	r15, rsi
.L196:
	mov	rcx, QWORD PTR [rbp-104]
	mov	rsi, QWORD PTR [rbp-112]
	lea	rax, [0+r10*8]
	mov	rdx, QWORD PTR [rbp-72]
	lea	rbx, [rcx+rax]
	lea	r11, [rsi+rax]
	mov	rcx, QWORD PTR [rbp-80]
	mov	rsi, QWORD PTR [rbp-88]
	mov	QWORD PTR [rbp-120], r10
	lea	r9, [rdx+rax]
	lea	rdi, [rsi+rax]
	lea	r8, [rcx+rax]
	lea	rsi, [r12+rax]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L195:
	mov	rcx, QWORD PTR [r14+rdx*8]
	vmovsd	xmm0, QWORD PTR [rbx]
	mov	r10, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [r10+rax]
	mov	r10, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r11]
	vaddsd	xmm0, xmm0, QWORD PTR [r10+rax]
	vmovsd	QWORD PTR [r11], xmm0
	vmovsd	xmm0, QWORD PTR [r9]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	mov	rcx, QWORD PTR [r13+0+rdx*8]
	inc	rdx
	vmovsd	QWORD PTR [r9], xmm0
	mov	r10, QWORD PTR [rcx]
	vmovsd	xmm0, QWORD PTR [r8]
	vaddsd	xmm0, xmm0, QWORD PTR [r10+rax]
	mov	r10, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [r10+rax]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+rax]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	r15, rdx
	jne	.L195
	mov	r10, QWORD PTR [rbp-120]
	inc	r10
	cmp	QWORD PTR [rbp-96], r10
	jne	.L196
.L194:
	call	GOMP_barrier
	add	rsp, 448
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
.L247:
	.cfi_restore_state
	mov	rax, QWORD PTR [rbp-264]
	test	rax, rax
	je	.L221
	mov	r9, QWORD PTR [rbp-288]
	mov	r10, QWORD PTR [rbp-296]
	mov	rsi, rax
.L223:
	lea	rax, [0+rdi*8]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L222:
	mov	rcx, QWORD PTR [r10+rdx*8]
	mov	r12, QWORD PTR [rcx]
	mov	QWORD PTR [r12+rax], 0x000000000
	mov	r12, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [r12+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	mov	rcx, QWORD PTR [r9+rdx*8]
	inc	rdx
	mov	r12, QWORD PTR [rcx]
	mov	QWORD PTR [r12+rax], 0x000000000
	mov	r12, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	mov	QWORD PTR [r12+rax], 0x000000000
	mov	QWORD PTR [rcx+rax], 0x000000000
	cmp	rsi, rdx
	jne	.L222
	inc	rdi
	cmp	r8, rdi
	jne	.L223
	jmp	.L221
.L220:
	inc	rax
	xor	r12d, r12d
	jmp	.L225
.L193:
	inc	rax
	xor	edx, edx
	jmp	.L198
.L250:
	vmovsd	QWORD PTR [rbp-464], xmm6
	mov	QWORD PTR [rbp-456], rdx
	mov	QWORD PTR [rbp-448], rax
	mov	QWORD PTR [rbp-440], rsi
	mov	QWORD PTR [rbp-432], rcx
	mov	QWORD PTR [rbp-424], r11
	mov	QWORD PTR [rbp-416], r10
	mov	QWORD PTR [rbp-408], r9
	vmovsd	QWORD PTR [rbp-400], xmm8
	mov	QWORD PTR [rbp-392], r8
	vmovsd	QWORD PTR [rbp-384], xmm5
	vmovsd	QWORD PTR [rbp-376], xmm1
	vmovsd	QWORD PTR [rbp-368], xmm2
	vmovsd	QWORD PTR [rbp-360], xmm3
	vzeroupper
	call	sqrt
	vmovsd	xmm6, QWORD PTR [rbp-464]
	mov	rdx, QWORD PTR [rbp-456]
	mov	rax, QWORD PTR [rbp-448]
	mov	rsi, QWORD PTR [rbp-440]
	mov	rcx, QWORD PTR [rbp-432]
	mov	r11, QWORD PTR [rbp-424]
	mov	r10, QWORD PTR [rbp-416]
	mov	r9, QWORD PTR [rbp-408]
	vmovsd	xmm8, QWORD PTR [rbp-400]
	mov	r8, QWORD PTR [rbp-392]
	vmovq	xmm30, QWORD PTR .LC0[rip]
	vmovsd	xmm5, QWORD PTR [rbp-384]
	vmovsd	xmm1, QWORD PTR [rbp-376]
	vmovsd	xmm2, QWORD PTR [rbp-368]
	vmovsd	xmm3, QWORD PTR [rbp-360]
	jmp	.L211
.L248:
	test	rax, rax
	jne	.L191
	jmp	.L201
.L251:
	vmovsd	QWORD PTR [rbp-448], xmm6
	mov	QWORD PTR [rbp-440], rdx
	mov	QWORD PTR [rbp-432], rdi
	mov	QWORD PTR [rbp-424], rsi
	mov	QWORD PTR [rbp-416], rcx
	mov	QWORD PTR [rbp-408], r10
	mov	QWORD PTR [rbp-400], r9
	vmovsd	QWORD PTR [rbp-392], xmm8
	mov	QWORD PTR [rbp-384], r8
	mov	QWORD PTR [rbp-376], r11
	vmovsd	QWORD PTR [rbp-368], xmm5
	vmovsd	QWORD PTR [rbp-360], xmm1
	vmovsd	QWORD PTR [rbp-192], xmm2
	vmovsd	QWORD PTR [rbp-184], xmm3
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-88]
	vmovsd	xmm6, QWORD PTR [rbp-448]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-440]
	mov	rax, QWORD PTR [rax+16]
	mov	rdi, QWORD PTR [rbp-432]
	mov	QWORD PTR [rbp-80], rax
	mov	rsi, QWORD PTR [rbp-424]
	mov	rcx, QWORD PTR [rbp-416]
	mov	r10, QWORD PTR [rbp-408]
	mov	r9, QWORD PTR [rbp-400]
	vmovsd	xmm8, QWORD PTR [rbp-392]
	mov	r8, QWORD PTR [rbp-384]
	mov	r11, QWORD PTR [rbp-376]
	vmovq	xmm30, QWORD PTR .LC0[rip]
	vmovsd	xmm5, QWORD PTR [rbp-368]
	vmovsd	xmm1, QWORD PTR [rbp-360]
	vmovsd	xmm2, QWORD PTR [rbp-192]
	vmovsd	xmm3, QWORD PTR [rbp-184]
	jmp	.L218
	.cfi_endproc
.LFE8446:
	.size	_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3, .-_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3
	.p2align 4,,15
	.type	_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4, @function
_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4:
.LFB8447:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	lea	r10, [rsp+8]
	.cfi_def_cfa 10, 0
	and	rsp, -32
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
	sub	rsp, 320
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	mov	rax, QWORD PTR [rdi+56]
	mov	r14, QWORD PTR [rdi+8]
	mov	r11, QWORD PTR [rdi+24]
	mov	QWORD PTR [rbp-256], rax
	mov	rax, QWORD PTR [rdi+48]
	mov	rbx, QWORD PTR [rdi+16]
	mov	QWORD PTR [rbp-192], rdi
	mov	QWORD PTR [rbp-80], r11
	mov	QWORD PTR [rbp-264], r14
	mov	QWORD PTR [rbp-72], rax
	call	omp_get_thread_num
	movsx	rdx, eax
	mov	rax, QWORD PTR [r14+rdx*8]
	mov	rcx, r15
	mov	r9, QWORD PTR [rax]
	mov	r14, QWORD PTR [rax+8]
	mov	r10, QWORD PTR [rax+16]
	mov	rax, QWORD PTR [r15]
	mov	rsi, QWORD PTR [rbx]
	mov	rdi, QWORD PTR [rax+24]
	mov	r8, QWORD PTR [rbx+16]
	mov	QWORD PTR [rbp-96], rdi
	mov	rdi, QWORD PTR [rax+32]
	mov	rax, QWORD PTR [rax+40]
	mov	QWORD PTR [rbp-104], rdi
	mov	QWORD PTR [rbp-112], rax
	mov	rax, QWORD PTR [r15+32]
	mov	rdi, QWORD PTR [rbx+8]
	mov	r15, QWORD PTR [rax+rdx*8]
	mov	rax, QWORD PTR [rcx+40]
	mov	QWORD PTR [rbp-176], rdx
	mov	rbx, QWORD PTR [rax]
	mov	r11, QWORD PTR [rbp-80]
	test	rbx, rbx
	je	.L294
	mov	QWORD PTR [rbp-144], r8
	mov	QWORD PTR [rbp-136], rdi
	mov	QWORD PTR [rbp-128], rsi
	mov	QWORD PTR [rbp-120], r10
	mov	QWORD PTR [rbp-88], r9
	mov	QWORD PTR [rbp-80], r11
	call	omp_get_num_threads
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, rbx
	div	rcx
	mov	r11, QWORD PTR [rbp-80]
	mov	r9, QWORD PTR [rbp-88]
	mov	r10, QWORD PTR [rbp-120]
	mov	rsi, QWORD PTR [rbp-128]
	mov	rdi, QWORD PTR [rbp-136]
	mov	r8, QWORD PTR [rbp-144]
	cmp	QWORD PTR [rbp-176], rdx
	jb	.L293
.L298:
	mov	rcx, QWORD PTR [rbp-176]
	imul	rcx, rax
	lea	r13, [rcx+rdx]
	lea	r12, [rax+r13]
	cmp	r13, r12
	jb	.L321
.L294:
	mov	QWORD PTR [rbp-144], r8
	mov	QWORD PTR [rbp-136], rdi
	mov	QWORD PTR [rbp-128], rsi
	mov	QWORD PTR [rbp-120], r10
	mov	QWORD PTR [rbp-88], r9
	mov	QWORD PTR [rbp-80], r11
	call	GOMP_barrier
	mov	rax, QWORD PTR [rbp-192]
	mov	r11, QWORD PTR [rbp-80]
	mov	rax, QWORD PTR [rax+40]
	mov	r9, QWORD PTR [rbp-88]
	mov	rbx, QWORD PTR [rax]
	mov	r10, QWORD PTR [rbp-120]
	mov	rax, rbx
	shr	rax, 8
	test	bl, bl
	mov	QWORD PTR [rbp-200], rax
	mov	rsi, QWORD PTR [rbp-128]
	mov	rdi, QWORD PTR [rbp-136]
	mov	r8, QWORD PTR [rbp-144]
	je	.L322
	inc	QWORD PTR [rbp-200]
.L256:
	mov	QWORD PTR [rbp-248], r15
	mov	QWORD PTR [rbp-128], 256
	mov	r15, r14
	mov	QWORD PTR [rbp-184], 0
	mov	QWORD PTR [rbp-208], r11
	mov	QWORD PTR [rbp-216], r10
	mov	QWORD PTR [rbp-224], rsi
	mov	QWORD PTR [rbp-232], rdi
	mov	QWORD PTR [rbp-240], r8
	mov	r14, r9
	jmp	.L265
	.p2align 4,,10
	.p2align 3
.L268:
	call	GOMP_barrier
	mov	rdi, QWORD PTR [rbp-184]
	add	QWORD PTR [rbp-128], 256
	cmp	QWORD PTR [rbp-200], rdi
	jbe	.L323
.L265:
	mov	rax, QWORD PTR [rbp-128]
	inc	QWORD PTR [rbp-184]
	mov	QWORD PTR [rbp-56], rax
	mov	rax, QWORD PTR [rbp-192]
	mov	rbx, QWORD PTR [rax]
	mov	r13, QWORD PTR [rbx]
	test	r13, r13
	je	.L268
	call	omp_get_num_threads
	movsx	rsi, eax
	xor	edx, edx
	mov	rax, r13
	div	rsi
	cmp	QWORD PTR [rbp-176], rdx
	jb	.L267
.L292:
	mov	r13, QWORD PTR [rbp-176]
	imul	r13, rax
	add	r13, rdx
	add	rax, r13
	mov	QWORD PTR [rbp-152], rax
	cmp	r13, rax
	jnb	.L268
	mov	rax, QWORD PTR [rbp-128]
	mov	r9, QWORD PTR [rbp-208]
	lea	rdi, [rax-256]
	sub	rax, 253
	mov	QWORD PTR [rbp-168], rax
	mov	rax, QWORD PTR [rbp-248]
	mov	QWORD PTR [rbp-160], rdi
	mov	QWORD PTR [rbp-80], rax
	mov	r10, QWORD PTR [rbp-216]
	mov	r11, QWORD PTR [rbp-224]
	mov	rdi, QWORD PTR [rbp-232]
	mov	r8, QWORD PTR [rbp-240]
	mov	rsi, QWORD PTR [rbp-192]
	.p2align 4,,10
	.p2align 3
.L287:
	mov	rax, QWORD PTR [rsi+40]
	mov	rdx, r13
	mov	r12, QWORD PTR [rax]
	mov	QWORD PTR [rbp-120], rax
	mov	rax, QWORD PTR [rbp-72]
	mov	ecx, 1
	imul	rax, r12
	sub	rdx, rax
	shr	rdx, 2
	mov	QWORD PTR [rbp-136], rdx
	mov	edx, r13d
	sub	edx, eax
	and	edx, 3
	shlx	edx, ecx, edx
	mov	DWORD PTR [rbp-144], edx
	cmp	r13, rax
	jnb	.L269
	mov	BYTE PTR [rbp-88], 0
.L291:
	mov	rax, QWORD PTR [rbx+16]
	mov	rcx, QWORD PTR [rbp-80]
	vmovsd	xmm10, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-128]
	vxorpd	xmm10, xmm10, XMMWORD PTR .LC0[rip]
	cmp	rax, r12
	cmovbe	r12, rax
	mov	rax, QWORD PTR [rbp-96]
	vbroadcastsd	ymm6, xmm10
	vbroadcastsd	ymm9, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-104]
	vbroadcastsd	ymm8, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-112]
	vbroadcastsd	ymm7, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-160]
	cmp	r12, QWORD PTR [rbp-168]
	jbe	.L324
	.p2align 4,,10
	.p2align 3
.L270:
	vsubpd	ymm2, ymm8, YMMWORD PTR [rdi+rax*8]
	vsubpd	ymm3, ymm9, YMMWORD PTR [r11+rax*8]
	vsubpd	ymm1, ymm7, YMMWORD PTR [r8+rax*8]
	vmulpd	ymm0, ymm2, ymm2
	mov	rdx, rax
	shr	rdx, 2
	movzx	ebx, BYTE PTR [rcx+rdx]
	vmulpd	ymm4, ymm6, YMMWORD PTR [r9+rax*8]
	vfmadd231pd	ymm0, ymm3, ymm3
	kmovd	k1, ebx
	lea	rdx, [rax+7]
	lea	rbx, [rax+4]
	vfmadd231pd	ymm0, ymm1, ymm1
	vsqrtpd	ymm0{k1}{z}, ymm0
	vmulpd	ymm5, ymm0, ymm0
	vmulpd	ymm0, ymm5, ymm0
	vdivpd	ymm0{k1}{z}, ymm4, ymm0
	vfnmadd213pd	ymm2, ymm0, YMMWORD PTR [r15+rax*8]
	vfnmadd213pd	ymm1, ymm0, YMMWORD PTR [r10+rax*8]
	vfnmadd213pd	ymm3, ymm0, YMMWORD PTR [r14+rax*8]
	vmovapd	YMMWORD PTR [r14+rax*8], ymm3
	vmovapd	YMMWORD PTR [r15+rax*8], ymm2
	vmovapd	YMMWORD PTR [r10+rax*8], ymm1
	mov	rax, rbx
	cmp	r12, rdx
	ja	.L270
	mov	QWORD PTR [rbp-80], rcx
.L290:
	cmp	r12, rbx
	jbe	.L271
	mov	rcx, QWORD PTR [rbp-120]
	mov	rax, QWORD PTR [rbp-72]
	imul	rax, QWORD PTR [rcx]
	add	rax, rbx
	cmp	r13, rax
	je	.L272
	mov	rcx, QWORD PTR [rbp-96]
	vxorpd	xmm4, xmm4, xmm4
	vmovsd	xmm2, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-104]
	vsubsd	xmm2, xmm2, QWORD PTR [r11+rbx*8]
	vmovsd	xmm1, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-112]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rbx*8]
	vmovsd	xmm0, QWORD PTR [rcx+r13*8]
	lea	rax, [0+rbx*8]
	vsubsd	xmm3, xmm0, QWORD PTR [r8+rbx*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L312
.L275:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rax]
	vmulsd	xmm4, xmm5, xmm5
	lea	rdx, [r14+rax]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm3
	vmovsd	xmm5, QWORD PTR [rdx]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rdx], xmm2
	lea	rdx, [r15+rax]
	vmovsd	xmm2, QWORD PTR [rdx]
	add	rax, r10
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rdx], xmm1
	vmovsd	xmm1, QWORD PTR [rax]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rax], xmm0
.L272:
	lea	rax, [rbx+1]
	cmp	r12, rax
	jbe	.L271
	mov	rdx, QWORD PTR [rsi+40]
	mov	rcx, QWORD PTR [rbp-72]
	imul	rcx, QWORD PTR [rdx]
	mov	rdx, rcx
	add	rdx, rax
	cmp	r13, rdx
	je	.L276
	mov	rcx, QWORD PTR [rbp-96]
	vxorpd	xmm4, xmm4, xmm4
	vmovsd	xmm2, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-104]
	vsubsd	xmm2, xmm2, QWORD PTR [r11+rax*8]
	vmovsd	xmm1, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-112]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rax*8]
	vmovsd	xmm0, QWORD PTR [rcx+r13*8]
	lea	rdx, [0+rax*8]
	vsubsd	xmm3, xmm0, QWORD PTR [r8+rax*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L313
.L279:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rax*8]
	vmulsd	xmm4, xmm5, xmm5
	lea	rax, [r14+rdx]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm3
	vmovsd	xmm5, QWORD PTR [rax]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	lea	rax, [r15+rdx]
	vmovsd	xmm2, QWORD PTR [rax]
	add	rdx, r10
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	vmovsd	xmm1, QWORD PTR [rdx]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rdx], xmm0
.L276:
	lea	rax, [rbx+2]
	cmp	r12, rax
	jbe	.L271
	mov	rdx, QWORD PTR [rsi+40]
	mov	rcx, QWORD PTR [rbp-72]
	imul	rcx, QWORD PTR [rdx]
	mov	rdx, rcx
	add	rdx, rax
	cmp	r13, rdx
	je	.L280
	mov	rcx, QWORD PTR [rbp-96]
	vxorpd	xmm4, xmm4, xmm4
	vmovsd	xmm2, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-104]
	vsubsd	xmm2, xmm2, QWORD PTR [r11+rax*8]
	vmovsd	xmm1, QWORD PTR [rcx+r13*8]
	mov	rcx, QWORD PTR [rbp-112]
	vsubsd	xmm1, xmm1, QWORD PTR [rdi+rax*8]
	vmovsd	xmm0, QWORD PTR [rcx+r13*8]
	lea	rdx, [0+rax*8]
	vsubsd	xmm3, xmm0, QWORD PTR [r8+rax*8]
	vmulsd	xmm0, xmm1, xmm1
	vfmadd231sd	xmm0, xmm2, xmm2
	vfmadd231sd	xmm0, xmm3, xmm3
	vucomisd	xmm4, xmm0
	vsqrtsd	xmm5, xmm5, xmm0
	ja	.L314
.L283:
	vmulsd	xmm0, xmm10, QWORD PTR [r9+rax*8]
	vmulsd	xmm4, xmm5, xmm5
	lea	rax, [r14+rdx]
	vmulsd	xmm2, xmm0, xmm2
	vmulsd	xmm4, xmm4, xmm5
	vmulsd	xmm1, xmm0, xmm1
	vmulsd	xmm0, xmm0, xmm3
	vmovsd	xmm5, QWORD PTR [rax]
	vdivsd	xmm2, xmm2, xmm4
	vdivsd	xmm1, xmm1, xmm4
	vsubsd	xmm2, xmm5, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	lea	rax, [r15+rdx]
	vmovsd	xmm2, QWORD PTR [rax]
	add	rdx, r10
	vdivsd	xmm0, xmm0, xmm4
	vsubsd	xmm1, xmm2, xmm1
	vmovsd	QWORD PTR [rax], xmm1
	vmovsd	xmm1, QWORD PTR [rdx]
	vsubsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [rdx], xmm0
.L280:
	add	rbx, 3
	cmp	r12, rbx
	jbe	.L271
	mov	rax, QWORD PTR [rsi+40]
	mov	rcx, QWORD PTR [rbp-72]
	imul	rcx, QWORD PTR [rax]
	mov	rax, rcx
	add	rax, rbx
	cmp	r13, rax
	je	.L271
	mov	rax, QWORD PTR [rbp-96]
	vxorpd	xmm5, xmm5, xmm5
	vmovsd	xmm3, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-104]
	vsubsd	xmm3, xmm3, QWORD PTR [r11+rbx*8]
	vmovsd	xmm2, QWORD PTR [rax+r13*8]
	mov	rax, QWORD PTR [rbp-112]
	vsubsd	xmm2, xmm2, QWORD PTR [rdi+rbx*8]
	vmovsd	xmm1, QWORD PTR [rax+r13*8]
	lea	r12, [0+rbx*8]
	vmulsd	xmm0, xmm2, xmm2
	vsubsd	xmm1, xmm1, QWORD PTR [r8+rbx*8]
	vfmadd231sd	xmm0, xmm3, xmm3
	vfmadd231sd	xmm0, xmm1, xmm1
	vucomisd	xmm5, xmm0
	vsqrtsd	xmm4, xmm4, xmm0
	ja	.L325
.L289:
	vmulsd	xmm10, xmm10, QWORD PTR [r9+rbx*8]
	vmulsd	xmm0, xmm4, xmm4
	lea	rax, [r14+r12]
	vmulsd	xmm3, xmm3, xmm10
	vmulsd	xmm0, xmm0, xmm4
	vmulsd	xmm2, xmm2, xmm10
	vmulsd	xmm1, xmm1, xmm10
	vmovsd	xmm4, QWORD PTR [rax]
	vdivsd	xmm3, xmm3, xmm0
	vdivsd	xmm2, xmm2, xmm0
	vsubsd	xmm3, xmm4, xmm3
	vmovsd	QWORD PTR [rax], xmm3
	lea	rax, [r15+r12]
	vmovsd	xmm3, QWORD PTR [rax]
	add	r12, r10
	vdivsd	xmm1, xmm1, xmm0
	vsubsd	xmm2, xmm3, xmm2
	vmovsd	QWORD PTR [rax], xmm2
	vmovsd	xmm0, QWORD PTR [r12]
	vsubsd	xmm1, xmm0, xmm1
	vmovsd	QWORD PTR [r12], xmm1
	.p2align 4,,10
	.p2align 3
.L271:
	cmp	BYTE PTR [rbp-88], 0
	je	.L288
	mov	rax, QWORD PTR [rbp-136]
	movzx	ecx, BYTE PTR [rbp-144]
	mov	rbx, QWORD PTR [rbp-80]
	xor	BYTE PTR [rbx+rax], cl
.L288:
	inc	r13
	cmp	QWORD PTR [rbp-152], r13
	je	.L318
	mov	rbx, QWORD PTR [rsi]
	jmp	.L287
	.p2align 4,,10
	.p2align 3
.L269:
	add	rax, r12
	mov	BYTE PTR [rbp-88], 0
	cmp	r13, rax
	jnb	.L291
	mov	rax, QWORD PTR [rbp-136]
	movzx	ecx, BYTE PTR [rbp-144]
	mov	rdx, QWORD PTR [rbp-80]
	mov	BYTE PTR [rbp-88], 1
	xor	BYTE PTR [rdx+rax], cl
	mov	rax, QWORD PTR [rbp-120]
	mov	r12, QWORD PTR [rax]
	jmp	.L291
	.p2align 4,,10
	.p2align 3
.L324:
	mov	rbx, rax
	jmp	.L290
	.p2align 4,,10
	.p2align 3
.L318:
	vzeroupper
	jmp	.L268
	.p2align 4,,10
	.p2align 3
.L267:
	inc	rax
	xor	edx, edx
	jmp	.L292
.L323:
	mov	rax, QWORD PTR [rbp-192]
	mov	rax, QWORD PTR [rax+40]
	mov	rbx, QWORD PTR [rax]
.L266:
	test	rbx, rbx
	je	.L259
	call	omp_get_num_threads
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, rbx
	div	rcx
	cmp	QWORD PTR [rbp-176], rdx
	jb	.L258
.L263:
	mov	r9, QWORD PTR [rbp-176]
	imul	r9, rax
	add	r9, rdx
	lea	r10, [rax+r9]
	cmp	r9, r10
	jnb	.L259
	mov	rax, QWORD PTR [rbp-192]
	mov	rsi, QWORD PTR [rbp-256]
	mov	rax, QWORD PTR [rax]
	test	rsi, rsi
	je	.L259
	mov	r14, QWORD PTR [rbp-264]
	mov	r12, QWORD PTR [rax+72]
	mov	rbx, QWORD PTR [rax+80]
	mov	r11, QWORD PTR [rax+88]
	lea	r13, [r14+rsi*8]
	.p2align 4,,10
	.p2align 3
.L261:
	lea	rcx, [0+r9*8]
	lea	r8, [r12+rcx]
	lea	rdi, [rbx+rcx]
	lea	rsi, [r11+rcx]
	mov	rax, r14
	.p2align 4,,10
	.p2align 3
.L260:
	mov	rdx, QWORD PTR [rax]
	vmovsd	xmm0, QWORD PTR [r8]
	mov	r15, QWORD PTR [rdx]
	add	rax, 8
	vaddsd	xmm0, xmm0, QWORD PTR [r15+rcx]
	mov	r15, QWORD PTR [rdx+8]
	mov	rdx, QWORD PTR [rdx+16]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [r15+rcx]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	vaddsd	xmm0, xmm0, QWORD PTR [rdx+rcx]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	rax, r13
	jne	.L260
	inc	r9
	cmp	r10, r9
	jne	.L261
.L259:
	call	GOMP_barrier
	add	rsp, 320
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
.L321:
	.cfi_restore_state
	mov	rax, QWORD PTR [rbp-256]
	test	rax, rax
	je	.L294
	mov	rcx, QWORD PTR [rbp-264]
	mov	QWORD PTR [rbp-88], rsi
	lea	rbx, [rcx+rax*8]
	mov	rsi, rcx
	.p2align 4,,10
	.p2align 3
.L296:
	mov	QWORD PTR [rbp-80], rsi
	lea	rcx, [0+r13*8]
	mov	rax, rsi
	.p2align 4,,10
	.p2align 3
.L295:
	mov	rdx, QWORD PTR [rax]
	add	rax, 8
	mov	rsi, QWORD PTR [rdx]
	mov	QWORD PTR [rsi+rcx], 0x000000000
	mov	rsi, QWORD PTR [rdx+8]
	mov	rdx, QWORD PTR [rdx+16]
	mov	QWORD PTR [rsi+rcx], 0x000000000
	mov	QWORD PTR [rdx+rcx], 0x000000000
	cmp	rbx, rax
	jne	.L295
	inc	r13
	mov	rsi, QWORD PTR [rbp-80]
	cmp	r12, r13
	jne	.L296
	mov	rsi, QWORD PTR [rbp-88]
	jmp	.L294
.L322:
	test	rax, rax
	jne	.L256
	jmp	.L266
.L293:
	inc	rax
	xor	edx, edx
	jmp	.L298
.L258:
	inc	rax
	xor	edx, edx
	jmp	.L263
.L312:
	mov	QWORD PTR [rbp-352], rsi
	mov	QWORD PTR [rbp-344], r8
	mov	QWORD PTR [rbp-336], rdi
	mov	QWORD PTR [rbp-328], r11
	mov	QWORD PTR [rbp-320], r10
	mov	QWORD PTR [rbp-312], r9
	vmovsd	QWORD PTR [rbp-304], xmm2
	vmovsd	QWORD PTR [rbp-296], xmm1
	vmovsd	QWORD PTR [rbp-288], xmm3
	vmovsd	QWORD PTR [rbp-280], xmm5
	vmovsd	QWORD PTR [rbp-272], xmm10
	mov	QWORD PTR [rbp-120], rax
	vzeroupper
	call	sqrt
	mov	rax, QWORD PTR [rbp-120]
	vmovsd	xmm10, QWORD PTR [rbp-272]
	vmovsd	xmm5, QWORD PTR [rbp-280]
	vmovsd	xmm3, QWORD PTR [rbp-288]
	vmovsd	xmm1, QWORD PTR [rbp-296]
	vmovsd	xmm2, QWORD PTR [rbp-304]
	mov	r9, QWORD PTR [rbp-312]
	mov	r10, QWORD PTR [rbp-320]
	mov	r11, QWORD PTR [rbp-328]
	mov	rdi, QWORD PTR [rbp-336]
	mov	r8, QWORD PTR [rbp-344]
	mov	rsi, QWORD PTR [rbp-352]
	jmp	.L275
.L325:
	mov	QWORD PTR [rbp-344], rsi
	mov	QWORD PTR [rbp-336], r8
	mov	QWORD PTR [rbp-328], rdi
	mov	QWORD PTR [rbp-320], r11
	mov	QWORD PTR [rbp-312], r10
	mov	QWORD PTR [rbp-304], r9
	vmovsd	QWORD PTR [rbp-296], xmm4
	vmovsd	QWORD PTR [rbp-288], xmm1
	vmovsd	QWORD PTR [rbp-280], xmm2
	vmovsd	QWORD PTR [rbp-272], xmm3
	vmovsd	QWORD PTR [rbp-120], xmm10
	vzeroupper
	call	sqrt
	mov	rsi, QWORD PTR [rbp-344]
	mov	r8, QWORD PTR [rbp-336]
	mov	rdi, QWORD PTR [rbp-328]
	mov	r11, QWORD PTR [rbp-320]
	mov	r10, QWORD PTR [rbp-312]
	mov	r9, QWORD PTR [rbp-304]
	vmovsd	xmm4, QWORD PTR [rbp-296]
	vmovsd	xmm1, QWORD PTR [rbp-288]
	vmovsd	xmm2, QWORD PTR [rbp-280]
	vmovsd	xmm3, QWORD PTR [rbp-272]
	vmovsd	xmm10, QWORD PTR [rbp-120]
	jmp	.L289
.L314:
	mov	QWORD PTR [rbp-360], rsi
	mov	QWORD PTR [rbp-352], r8
	mov	QWORD PTR [rbp-344], rdi
	mov	QWORD PTR [rbp-336], r11
	mov	QWORD PTR [rbp-328], r10
	mov	QWORD PTR [rbp-320], r9
	mov	QWORD PTR [rbp-312], rax
	mov	QWORD PTR [rbp-304], rdx
	vmovsd	QWORD PTR [rbp-296], xmm2
	vmovsd	QWORD PTR [rbp-288], xmm1
	vmovsd	QWORD PTR [rbp-280], xmm3
	vmovsd	QWORD PTR [rbp-272], xmm5
	vmovsd	QWORD PTR [rbp-120], xmm10
	vzeroupper
	call	sqrt
	vmovsd	xmm10, QWORD PTR [rbp-120]
	vmovsd	xmm5, QWORD PTR [rbp-272]
	vmovsd	xmm3, QWORD PTR [rbp-280]
	vmovsd	xmm1, QWORD PTR [rbp-288]
	vmovsd	xmm2, QWORD PTR [rbp-296]
	mov	rdx, QWORD PTR [rbp-304]
	mov	rax, QWORD PTR [rbp-312]
	mov	r9, QWORD PTR [rbp-320]
	mov	r10, QWORD PTR [rbp-328]
	mov	r11, QWORD PTR [rbp-336]
	mov	rdi, QWORD PTR [rbp-344]
	mov	r8, QWORD PTR [rbp-352]
	mov	rsi, QWORD PTR [rbp-360]
	jmp	.L283
.L313:
	mov	QWORD PTR [rbp-360], rsi
	mov	QWORD PTR [rbp-352], r8
	mov	QWORD PTR [rbp-344], rdi
	mov	QWORD PTR [rbp-336], r11
	mov	QWORD PTR [rbp-328], r10
	mov	QWORD PTR [rbp-320], r9
	mov	QWORD PTR [rbp-312], rax
	mov	QWORD PTR [rbp-304], rdx
	vmovsd	QWORD PTR [rbp-296], xmm2
	vmovsd	QWORD PTR [rbp-288], xmm1
	vmovsd	QWORD PTR [rbp-280], xmm3
	vmovsd	QWORD PTR [rbp-272], xmm5
	vmovsd	QWORD PTR [rbp-120], xmm10
	vzeroupper
	call	sqrt
	vmovsd	xmm10, QWORD PTR [rbp-120]
	vmovsd	xmm5, QWORD PTR [rbp-272]
	vmovsd	xmm3, QWORD PTR [rbp-280]
	vmovsd	xmm1, QWORD PTR [rbp-288]
	vmovsd	xmm2, QWORD PTR [rbp-296]
	mov	rdx, QWORD PTR [rbp-304]
	mov	rax, QWORD PTR [rbp-312]
	mov	r9, QWORD PTR [rbp-320]
	mov	r10, QWORD PTR [rbp-328]
	mov	r11, QWORD PTR [rbp-336]
	mov	rdi, QWORD PTR [rbp-344]
	mov	r8, QWORD PTR [rbp-352]
	mov	rsi, QWORD PTR [rbp-360]
	jmp	.L279
	.cfi_endproc
.LFE8447:
	.size	_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4, .-_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4
	.p2align 4,,15
	.type	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.5, @function
_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.5:
.LFB8448:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	sub	rsp, 160
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rbx, QWORD PTR [rdi]
	mov	r12, QWORD PTR [rbx]
	test	r12, r12
	je	.L337
	mov	r13, rdi
	call	omp_get_num_threads
	movsx	r14, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r12
	div	r14
	cmp	rcx, rdx
	jb	.L328
.L334:
	imul	rcx, rax
	add	rdx, rcx
	lea	rdi, [rax+rdx]
	mov	QWORD PTR [rsp+152], rdi
	cmp	rdx, rdi
	jnb	.L337
	mov	rcx, QWORD PTR [r13+8]
	mov	rdi, QWORD PTR [rbx+24]
	mov	r8, QWORD PTR [rcx]
	mov	r10, QWORD PTR [rcx+8]
	mov	r12, QWORD PTR [rcx+16]
	mov	rcx, QWORD PTR [r13+16]
	mov	r9, QWORD PTR [rbx+32]
	mov	rsi, QWORD PTR [rcx]
	mov	r11, QWORD PTR [rbx+40]
	mov	r15, QWORD PTR [rcx+8]
	mov	r14, QWORD PTR [rcx+16]
	mov	r13, QWORD PTR [rbx+72]
	mov	QWORD PTR [rsp+144], rsi
	mov	rsi, QWORD PTR [rbx+80]
	mov	rbx, QWORD PTR [rbx+88]
	lea	rcx, [rax-1]
	mov	QWORD PTR [rsp+64], rdi
	mov	QWORD PTR [rsp+56], r8
	mov	QWORD PTR [rsp+48], r9
	mov	QWORD PTR [rsp+40], r10
	mov	QWORD PTR [rsp+32], r11
	mov	QWORD PTR [rsp+24], r12
	mov	QWORD PTR [rsp+136], r15
	mov	QWORD PTR [rsp+128], r14
	mov	QWORD PTR [rsp+120], r13
	mov	QWORD PTR [rsp+112], rsi
	mov	QWORD PTR [rsp+104], rbx
	cmp	rcx, 2
	jbe	.L330
	lea	rsi, [0+rdx*8]
	mov	rcx, r15
	lea	r13, [r11+rsi]
	lea	r11, [rcx+rsi]
	mov	rcx, QWORD PTR [rsp+128]
	lea	r15, [rdi+rsi]
	lea	rdi, [r8+rsi]
	mov	QWORD PTR [rsp+96], rdi
	lea	rdi, [r10+rsi]
	lea	r10, [rcx+rsi]
	mov	rcx, QWORD PTR [rsp+120]
	lea	r14, [r9+rsi]
	lea	r9, [rcx+rsi]
	mov	rcx, QWORD PTR [rsp+112]
	mov	rbx, QWORD PTR [rsp+144]
	lea	r8, [rcx+rsi]
	mov	rcx, rax
	shr	rcx, 2
	sal	rcx, 5
	mov	QWORD PTR [rsp+88], rcx
	mov	QWORD PTR [rsp+80], rax
	mov	QWORD PTR [rsp+72], rdx
	mov	rax, QWORD PTR [rsp+96]
	mov	rdx, QWORD PTR [rsp+88]
	add	r12, rsi
	add	rbx, rsi
	xor	ecx, ecx
	add	rsi, QWORD PTR [rsp+104]
	vxorpd	xmm0, xmm0, xmm0
	.p2align 4,,10
	.p2align 3
.L331:
	vmovupd	ymm1, YMMWORD PTR [r15+rcx]
	vmovupd	YMMWORD PTR [rax+rcx], ymm1
	vmovupd	ymm2, YMMWORD PTR [r14+rcx]
	vmovupd	YMMWORD PTR [rdi+rcx], ymm2
	vmovupd	ymm3, YMMWORD PTR [r13+0+rcx]
	vmovupd	YMMWORD PTR [r12+rcx], ymm3
	vmovupd	YMMWORD PTR [rbx+rcx], ymm0
	vmovupd	YMMWORD PTR [r11+rcx], ymm0
	vmovupd	YMMWORD PTR [r10+rcx], ymm0
	vmovupd	YMMWORD PTR [r9+rcx], ymm0
	vmovupd	YMMWORD PTR [r8+rcx], ymm0
	vmovupd	YMMWORD PTR [rsi+rcx], ymm0
	add	rcx, 32
	cmp	rcx, rdx
	jne	.L331
	mov	rax, QWORD PTR [rsp+80]
	mov	rdx, QWORD PTR [rsp+72]
	mov	rcx, rax
	and	rcx, -4
	add	rdx, rcx
	cmp	rax, rcx
	je	.L336
	vzeroupper
.L330:
	mov	rbx, QWORD PTR [rsp+64]
	mov	rsi, QWORD PTR [rsp+56]
	vmovsd	xmm0, QWORD PTR [rbx+rdx*8]
	mov	rdi, QWORD PTR [rsp+48]
	vmovsd	QWORD PTR [rsi+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi+rdx*8]
	mov	rcx, QWORD PTR [rsp+40]
	mov	r15, QWORD PTR [rsp+32]
	vmovsd	QWORD PTR [rcx+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	mov	r8, QWORD PTR [rsp+24]
	mov	r9, QWORD PTR [rsp+144]
	mov	r10, QWORD PTR [rsp+136]
	mov	r11, QWORD PTR [rsp+128]
	mov	r14, QWORD PTR [rsp+120]
	mov	r13, QWORD PTR [rsp+112]
	mov	r12, QWORD PTR [rsp+104]
	lea	rax, [rdx+1]
	vmovsd	QWORD PTR [r8+rdx*8], xmm0
	mov	QWORD PTR [r9+rdx*8], 0x000000000
	mov	QWORD PTR [r10+rdx*8], 0x000000000
	mov	QWORD PTR [r11+rdx*8], 0x000000000
	mov	QWORD PTR [r14+rdx*8], 0x000000000
	mov	QWORD PTR [r13+0+rdx*8], 0x000000000
	mov	QWORD PTR [r12+rdx*8], 0x000000000
	cmp	QWORD PTR [rsp+152], rax
	jbe	.L337
	vmovsd	xmm0, QWORD PTR [rbx+rax*8]
	add	rdx, 2
	vmovsd	QWORD PTR [rsi+rax*8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi+rax*8]
	vmovsd	QWORD PTR [rcx+rax*8], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rax*8]
	vmovsd	QWORD PTR [r8+rax*8], xmm0
	mov	QWORD PTR [r9+rax*8], 0x000000000
	mov	QWORD PTR [r10+rax*8], 0x000000000
	mov	QWORD PTR [r11+rax*8], 0x000000000
	mov	QWORD PTR [r14+rax*8], 0x000000000
	mov	QWORD PTR [r13+0+rax*8], 0x000000000
	mov	QWORD PTR [r12+rax*8], 0x000000000
	cmp	QWORD PTR [rsp+152], rdx
	jbe	.L337
	vmovsd	xmm0, QWORD PTR [rbx+rdx*8]
	vmovsd	QWORD PTR [rsi+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi+rdx*8]
	vmovsd	QWORD PTR [rcx+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	vmovsd	QWORD PTR [r8+rdx*8], xmm0
	mov	QWORD PTR [r9+rdx*8], 0x000000000
	mov	QWORD PTR [r10+rdx*8], 0x000000000
	mov	QWORD PTR [r11+rdx*8], 0x000000000
	mov	QWORD PTR [r14+rdx*8], 0x000000000
	mov	QWORD PTR [r13+0+rdx*8], 0x000000000
	mov	QWORD PTR [r12+rdx*8], 0x000000000
.L337:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L328:
	.cfi_restore_state
	inc	rax
	xor	edx, edx
	jmp	.L334
	.p2align 4,,10
	.p2align 3
.L336:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8448:
	.size	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.5, .-_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.5
	.p2align 4,,15
	.type	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.6, @function
_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.6:
.LFB8449:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	sub	rsp, 160
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rbx, QWORD PTR [rdi]
	mov	r12, QWORD PTR [rbx]
	test	r12, r12
	je	.L350
	mov	r13, rdi
	call	omp_get_num_threads
	movsx	r14, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r12
	div	r14
	mov	QWORD PTR [rsp+152], rax
	cmp	rcx, rdx
	jb	.L341
.L347:
	mov	rsi, QWORD PTR [rsp+152]
	imul	rcx, rsi
	lea	r15, [rcx+rdx]
	lea	rax, [rsi+r15]
	mov	QWORD PTR [rsp+96], rax
	cmp	r15, rax
	jnb	.L350
	mov	rax, QWORD PTR [rbx+64]
	mov	rdx, QWORD PTR [rbx+72]
	mov	QWORD PTR [rsp+80], rax
	mov	rax, QWORD PTR [r13+16]
	vmovsd	xmm2, QWORD PTR [r13+8]
	mov	r11, QWORD PTR [rax+8]
	mov	r13, QWORD PTR [rax]
	mov	rax, QWORD PTR [rax+16]
	mov	rdi, QWORD PTR [rbx+24]
	mov	rcx, QWORD PTR [rbx+48]
	mov	r9, QWORD PTR [rbx+32]
	mov	r14, QWORD PTR [rbx+56]
	mov	r12, QWORD PTR [rbx+40]
	mov	QWORD PTR [rsp+136], rdx
	mov	r10, QWORD PTR [rbx+16]
	mov	r8, QWORD PTR [rbx+80]
	mov	rdx, QWORD PTR [rbx+88]
	mov	QWORD PTR [rsp+112], rax
	lea	rax, [rsi-1]
	mov	QWORD PTR [rsp+48], rdi
	mov	QWORD PTR [rsp+40], rcx
	mov	QWORD PTR [rsp+32], r9
	mov	QWORD PTR [rsp+24], r14
	mov	QWORD PTR [rsp+16], r12
	mov	QWORD PTR [rsp+88], r13
	mov	QWORD PTR [rsp+72], r10
	mov	QWORD PTR [rsp+128], r11
	mov	QWORD PTR [rsp+120], r8
	mov	QWORD PTR [rsp+104], rdx
	cmp	rax, 2
	jbe	.L343
	mov	rbx, QWORD PTR [rsp+80]
	lea	rdx, [0+r15*8]
	mov	rax, rsi
	lea	rsi, [rbx+rdx]
	mov	rbx, QWORD PTR [rsp+136]
	lea	r11, [rdi+rdx]
	lea	rdi, [r14+rdx]
	lea	r14, [rbx+rdx]
	mov	rbx, QWORD PTR [rsp+72]
	lea	r8, [rcx+rdx]
	lea	rcx, [r13+0+rdx]
	mov	QWORD PTR [rsp+64], rcx
	lea	rcx, [rbx+rdx]
	mov	rbx, QWORD PTR [rsp+128]
	lea	r10, [r9+rdx]
	lea	r13, [rbx+rdx]
	mov	rbx, QWORD PTR [rsp+120]
	lea	r9, [r12+rdx]
	shr	rax, 2
	lea	r12, [rbx+rdx]
	mov	rbx, QWORD PTR [rsp+112]
	sal	rax, 5
	mov	QWORD PTR [rsp+56], r15
	mov	r15, QWORD PTR [rsp+64]
	add	rbx, rdx
	mov	QWORD PTR [rsp+144], rax
	vbroadcastsd	ymm1, xmm2
	add	rdx, QWORD PTR [rsp+104]
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L344:
	vmovupd	ymm0, YMMWORD PTR [r8+rax]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r11+rax]
	vmovupd	YMMWORD PTR [r11+rax], ymm0
	vmovupd	ymm0, YMMWORD PTR [rdi+rax]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r10+rax]
	vmovupd	YMMWORD PTR [r10+rax], ymm0
	vmovupd	ymm0, YMMWORD PTR [rsi+rax]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r9+rax]
	vmovupd	YMMWORD PTR [r9+rax], ymm0
	vmovupd	ymm3, YMMWORD PTR [r15+rax]
	vaddpd	ymm0, ymm3, YMMWORD PTR [r14+rax]
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rcx+rax]
	vaddpd	ymm0, ymm0, YMMWORD PTR [r8+rax]
	vmovupd	YMMWORD PTR [r8+rax], ymm0
	vmovupd	ymm4, YMMWORD PTR [r13+0+rax]
	vaddpd	ymm0, ymm4, YMMWORD PTR [r12+rax]
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rcx+rax]
	vaddpd	ymm0, ymm0, YMMWORD PTR [rdi+rax]
	vmovupd	YMMWORD PTR [rdi+rax], ymm0
	vmovupd	ymm5, YMMWORD PTR [rbx+rax]
	vaddpd	ymm0, ymm5, YMMWORD PTR [rdx+rax]
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rcx+rax]
	vaddpd	ymm0, ymm0, YMMWORD PTR [rsi+rax]
	vmovupd	YMMWORD PTR [rsi+rax], ymm0
	add	rax, 32
	cmp	rax, QWORD PTR [rsp+144]
	jne	.L344
	mov	rbx, QWORD PTR [rsp+152]
	mov	r15, QWORD PTR [rsp+56]
	mov	rax, rbx
	and	rax, -4
	add	r15, rax
	cmp	rbx, rax
	je	.L349
	vzeroupper
.L343:
	mov	r9, QWORD PTR [rsp+40]
	lea	rax, [0+r15*8]
	lea	rsi, [r9+rax]
	mov	rbx, QWORD PTR [rsp+48]
	vmovsd	xmm0, QWORD PTR [rsi]
	lea	rdx, [rbx+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rdx]
	mov	r11, QWORD PTR [rsp+24]
	mov	r10, QWORD PTR [rsp+32]
	lea	rcx, [r11+rax]
	mov	r13, QWORD PTR [rsp+80]
	vmovsd	QWORD PTR [rdx], xmm0
	vmovsd	xmm0, QWORD PTR [rcx]
	lea	rdx, [r10+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rdx]
	mov	r14, QWORD PTR [rsp+16]
	mov	r8, QWORD PTR [rsp+136]
	lea	rdi, [r14+rax]
	mov	r12, QWORD PTR [rsp+72]
	vmovsd	QWORD PTR [rdx], xmm0
	lea	rdx, [r13+0+rax]
	vmovsd	xmm0, QWORD PTR [rdx]
	add	rax, r12
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rsp+88]
	vmovsd	xmm0, QWORD PTR [rdi+r15*8]
	mov	rdi, QWORD PTR [rsp+120]
	vaddsd	xmm0, xmm0, QWORD PTR [r8+r15*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR [rsp+128]
	vmovsd	xmm0, QWORD PTR [rsi+r15*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+r15*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, QWORD PTR [rsp+112]
	vmovsd	xmm0, QWORD PTR [rcx+r15*8]
	mov	rcx, QWORD PTR [rsp+104]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx+r15*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rdx]
	vmovsd	QWORD PTR [rdx], xmm0
	lea	rdx, [r15+1]
	cmp	QWORD PTR [rsp+96], rdx
	jbe	.L350
	lea	rax, [0+rdx*8]
	lea	rdi, [r9+rax]
	vmovsd	xmm0, QWORD PTR [rdi]
	lea	rcx, [rbx+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	lea	rsi, [r11+rax]
	lea	r8, [r14+rax]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	lea	rcx, [r10+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	lea	rcx, [r13+0+rax]
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rax, r12
	vfmadd213sd	xmm0, xmm2, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	mov	r8, QWORD PTR [rsp+88]
	vmovsd	xmm0, QWORD PTR [r8+rdx*8]
	mov	r8, QWORD PTR [rsp+136]
	vaddsd	xmm0, xmm0, QWORD PTR [r8+rdx*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rsp+128]
	vmovsd	xmm0, QWORD PTR [rdi+rdx*8]
	mov	rdi, QWORD PTR [rsp+120]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	mov	rdi, QWORD PTR [rsp+104]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR [rsp+112]
	vmovsd	xmm0, QWORD PTR [rsi+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	lea	rdx, [r15+2]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	cmp	QWORD PTR [rsp+96], rdx
	jbe	.L350
	lea	rax, [0+rdx*8]
	mov	rsi, r9
	add	rsi, rax
	vmovsd	xmm0, QWORD PTR [rsi]
	add	rbx, rax
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rbx]
	mov	rdi, r11
	add	rdi, rax
	mov	rcx, r10
	add	rcx, rax
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	mov	r8, r14
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	add	r8, rax
	mov	rbx, QWORD PTR [rsp+120]
	vmovsd	QWORD PTR [rcx], xmm0
	mov	rcx, r13
	add	rcx, rax
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rax, r12
	vfmadd213sd	xmm0, xmm2, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	mov	r8, QWORD PTR [rsp+88]
	vmovsd	xmm0, QWORD PTR [r8+rdx*8]
	mov	r8, QWORD PTR [rsp+136]
	vaddsd	xmm0, xmm0, QWORD PTR [r8+rdx*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR [rsp+128]
	vmovsd	xmm0, QWORD PTR [rsi+rdx*8]
	mov	rsi, QWORD PTR [rsp+112]
	vaddsd	xmm0, xmm0, QWORD PTR [rbx+rdx*8]
	vmulsd	xmm0, xmm0, xmm2
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [rsi+rdx*8]
	mov	rdi, QWORD PTR [rsp+104]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	vmulsd	xmm2, xmm0, xmm2
	vdivsd	xmm2, xmm2, QWORD PTR [rax]
	vaddsd	xmm2, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm2
.L350:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L341:
	.cfi_restore_state
	inc	QWORD PTR [rsp+152]
	xor	edx, edx
	jmp	.L347
	.p2align 4,,10
	.p2align 3
.L349:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8449:
	.size	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.6, .-_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.6
	.p2align 4,,15
	.type	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7, @function
_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7:
.LFB8450:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r13
	push	r12
	push	rbx
	sub	rsp, 8
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	mov	r13, QWORD PTR [rdi]
	mov	rbx, QWORD PTR [r13+0]
	test	rbx, rbx
	je	.L363
	call	omp_get_num_threads
	mov	r12d, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	movsx	rsi, r12d
	mov	rax, rbx
	xor	edx, edx
	div	rsi
	cmp	rcx, rdx
	jb	.L354
.L360:
	imul	rcx, rax
	add	rdx, rcx
	lea	r10, [rax+rdx]
	cmp	rdx, r10
	jnb	.L363
	lea	rcx, [rax-1]
	mov	rbx, QWORD PTR [r13+72]
	mov	r11, QWORD PTR [r13+80]
	mov	r12, QWORD PTR [r13+88]
	cmp	rcx, 2
	jbe	.L356
	mov	rdi, rax
	lea	rsi, [0+rdx*8]
	shr	rdi, 2
	lea	r9, [rbx+rsi]
	lea	r8, [r11+rsi]
	sal	rdi, 5
	add	rsi, r12
	xor	ecx, ecx
	vxorpd	xmm0, xmm0, xmm0
	.p2align 4,,10
	.p2align 3
.L357:
	vmovupd	YMMWORD PTR [r9+rcx], ymm0
	vmovupd	YMMWORD PTR [r8+rcx], ymm0
	vmovupd	YMMWORD PTR [rsi+rcx], ymm0
	add	rcx, 32
	cmp	rcx, rdi
	jne	.L357
	mov	rcx, rax
	and	rcx, -4
	add	rdx, rcx
	cmp	rax, rcx
	je	.L362
	vzeroupper
.L356:
	lea	rax, [rdx+1]
	mov	QWORD PTR [rbx+rdx*8], 0x000000000
	mov	QWORD PTR [r11+rdx*8], 0x000000000
	mov	QWORD PTR [r12+rdx*8], 0x000000000
	cmp	r10, rax
	jbe	.L363
	add	rdx, 2
	mov	QWORD PTR [rbx+rax*8], 0x000000000
	mov	QWORD PTR [r11+rax*8], 0x000000000
	mov	QWORD PTR [r12+rax*8], 0x000000000
	cmp	r10, rdx
	jbe	.L363
	mov	QWORD PTR [rbx+rdx*8], 0x000000000
	mov	QWORD PTR [r11+rdx*8], 0x000000000
	mov	QWORD PTR [r12+rdx*8], 0x000000000
.L363:
	add	rsp, 8
	pop	rbx
	pop	r12
	pop	r13
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L354:
	.cfi_restore_state
	inc	rax
	xor	edx, edx
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L362:
	vzeroupper
	add	rsp, 8
	pop	rbx
	pop	r12
	pop	r13
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8450:
	.size	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7, .-_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7
	.p2align 4,,15
	.type	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8, @function
_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8:
.LFB8451:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	sub	rsp, 96
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rbx, QWORD PTR [rdi]
	mov	r13, QWORD PTR [rbx]
	test	r13, r13
	je	.L376
	mov	r12, rdi
	call	omp_get_num_threads
	movsx	r14, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r13
	div	r14
	cmp	rcx, rdx
	jb	.L367
.L373:
	imul	rcx, rax
	add	rdx, rcx
	lea	rsi, [rax+rdx]
	mov	QWORD PTR [rsp+72], rsi
	cmp	rdx, rsi
	jnb	.L376
	mov	rcx, QWORD PTR [rbx+72]
	mov	rdi, QWORD PTR [rbx+24]
	mov	rsi, QWORD PTR [rbx+48]
	mov	r15, QWORD PTR [rbx+32]
	mov	r11, QWORD PTR [rbx+56]
	mov	r14, QWORD PTR [rbx+40]
	mov	r13, QWORD PTR [rbx+64]
	mov	r9, QWORD PTR [rbx+16]
	mov	r8, QWORD PTR [rbx+80]
	mov	rbx, QWORD PTR [rbx+88]
	mov	QWORD PTR [rsp+64], rcx
	lea	rcx, [rax-1]
	vmovsd	xmm2, QWORD PTR [r12+8]
	mov	QWORD PTR [rsp+48], rdi
	mov	QWORD PTR [rsp+40], rsi
	mov	QWORD PTR [rsp+32], r15
	mov	QWORD PTR [rsp+24], r11
	mov	QWORD PTR [rsp+16], r14
	mov	QWORD PTR [rsp+8], r13
	mov	QWORD PTR [rsp+56], r9
	mov	QWORD PTR [rsp+88], r8
	mov	QWORD PTR [rsp+80], rbx
	cmp	rcx, 2
	jbe	.L369
	mov	rcx, QWORD PTR [rsp+64]
	lea	r10, [0+rdx*8]
	lea	r12, [rdi+r10]
	lea	r9, [rsi+r10]
	lea	rbx, [r15+r10]
	lea	rdi, [r13+0+r10]
	lea	r15, [rcx+r10]
	mov	rsi, QWORD PTR [rsp+56]
	mov	rcx, QWORD PTR [rsp+88]
	mov	r13, rax
	shr	r13, 2
	lea	r8, [r11+r10]
	add	rsi, r10
	lea	r11, [r14+r10]
	vbroadcastsd	ymm0, xmm2
	lea	r14, [rcx+r10]
	sal	r13, 5
	add	r10, QWORD PTR [rsp+80]
	xor	ecx, ecx
	.p2align 4,,10
	.p2align 3
.L370:
	vmovupd	ymm1, YMMWORD PTR [r9+rcx]
	vfmadd213pd	ymm1, ymm0, YMMWORD PTR [r12+rcx]
	vmovupd	YMMWORD PTR [r12+rcx], ymm1
	vmovupd	ymm1, YMMWORD PTR [r8+rcx]
	vfmadd213pd	ymm1, ymm0, YMMWORD PTR [rbx+rcx]
	vmovupd	YMMWORD PTR [rbx+rcx], ymm1
	vmovupd	ymm1, YMMWORD PTR [rdi+rcx]
	vfmadd213pd	ymm1, ymm0, YMMWORD PTR [r11+rcx]
	vmovupd	YMMWORD PTR [r11+rcx], ymm1
	vmulpd	ymm1, ymm0, YMMWORD PTR [r15+rcx]
	vdivpd	ymm1, ymm1, YMMWORD PTR [rsi+rcx]
	vaddpd	ymm1, ymm1, YMMWORD PTR [r9+rcx]
	vmovupd	YMMWORD PTR [r9+rcx], ymm1
	vmulpd	ymm1, ymm0, YMMWORD PTR [r14+rcx]
	vdivpd	ymm1, ymm1, YMMWORD PTR [rsi+rcx]
	vaddpd	ymm1, ymm1, YMMWORD PTR [r8+rcx]
	vmovupd	YMMWORD PTR [r8+rcx], ymm1
	vmulpd	ymm1, ymm0, YMMWORD PTR [r10+rcx]
	vdivpd	ymm1, ymm1, YMMWORD PTR [rsi+rcx]
	vaddpd	ymm1, ymm1, YMMWORD PTR [rdi+rcx]
	vmovupd	YMMWORD PTR [rdi+rcx], ymm1
	add	rcx, 32
	cmp	rcx, r13
	jne	.L370
	mov	rcx, rax
	and	rcx, -4
	add	rdx, rcx
	cmp	rax, rcx
	je	.L375
	vzeroupper
.L369:
	mov	r15, QWORD PTR [rsp+40]
	lea	rax, [0+rdx*8]
	lea	rdi, [r15+rax]
	mov	rbx, QWORD PTR [rsp+48]
	vmovsd	xmm0, QWORD PTR [rdi]
	lea	rcx, [rbx+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	mov	r14, QWORD PTR [rsp+24]
	mov	r11, QWORD PTR [rsp+32]
	lea	rsi, [r14+rax]
	mov	r13, QWORD PTR [rsp+8]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	lea	rcx, [r11+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	mov	r10, QWORD PTR [rsp+16]
	mov	r9, QWORD PTR [rsp+64]
	lea	r8, [r10+rax]
	mov	r12, QWORD PTR [rsp+56]
	vmovsd	QWORD PTR [rcx], xmm0
	lea	rcx, [r13+0+rax]
	vmovsd	xmm0, QWORD PTR [rcx]
	add	rax, r12
	vfmadd213sd	xmm0, xmm2, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	vmulsd	xmm0, xmm2, QWORD PTR [r9+rdx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rsp+88]
	vmulsd	xmm0, xmm2, QWORD PTR [rdi+rdx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	mov	rsi, QWORD PTR [rsp+80]
	vmulsd	xmm0, xmm2, QWORD PTR [rsi+rdx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	lea	rcx, [rdx+1]
	cmp	QWORD PTR [rsp+72], rcx
	jbe	.L376
	lea	rax, [0+rcx*8]
	lea	r8, [r15+rax]
	vmovsd	xmm0, QWORD PTR [r8]
	lea	rsi, [rbx+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rsi]
	lea	rdi, [r14+rax]
	lea	r9, [r10+rax]
	add	rdx, 2
	vmovsd	QWORD PTR [rsi], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	lea	rsi, [r11+rax]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	lea	rsi, [r13+0+rax]
	vmovsd	xmm0, QWORD PTR [rsi]
	add	rax, r12
	vfmadd213sd	xmm0, xmm2, QWORD PTR [r9]
	vmovsd	QWORD PTR [r9], xmm0
	mov	r9, r12
	mov	r12, QWORD PTR [rsp+64]
	vmulsd	xmm0, xmm2, QWORD PTR [r12+rcx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	mov	r8, QWORD PTR [rsp+88]
	vmulsd	xmm0, xmm2, QWORD PTR [r8+rcx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rsp+80]
	vmulsd	xmm0, xmm2, QWORD PTR [rdi+rcx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rax]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	cmp	QWORD PTR [rsp+72], rdx
	jbe	.L376
	lea	rcx, [0+rdx*8]
	mov	rdi, r15
	add	rdi, rcx
	vmovsd	xmm0, QWORD PTR [rdi]
	mov	rax, rbx
	add	rax, rcx
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rax]
	mov	rsi, r14
	add	rsi, rcx
	add	r10, rcx
	mov	r8, QWORD PTR [rsp+88]
	vmovsd	QWORD PTR [rax], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	mov	rax, r11
	add	rax, rcx
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	mov	rax, r13
	add	rax, rcx
	vmovsd	xmm0, QWORD PTR [rax]
	add	rcx, r9
	vfmadd213sd	xmm0, xmm2, QWORD PTR [r10]
	vmovsd	QWORD PTR [r10], xmm0
	vmulsd	xmm0, xmm2, QWORD PTR [r12+rdx*8]
	vdivsd	xmm0, xmm0, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmulsd	xmm0, xmm2, QWORD PTR [r8+rdx*8]
	mov	rdi, QWORD PTR [rsp+80]
	vdivsd	xmm0, xmm0, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vmulsd	xmm2, xmm2, QWORD PTR [rdi+rdx*8]
	vdivsd	xmm2, xmm2, QWORD PTR [rcx]
	vaddsd	xmm2, xmm2, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm2
.L376:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L367:
	.cfi_restore_state
	inc	rax
	xor	edx, edx
	jmp	.L373
	.p2align 4,,10
	.p2align 3
.L375:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8451:
	.size	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8, .-_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8
	.p2align 4,,15
	.type	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.9, @function
_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.9:
.LFB8452:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	sub	rsp, 192
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rbx, QWORD PTR [rdi]
	mov	r13, QWORD PTR [rbx]
	test	r13, r13
	je	.L389
	mov	r12, rdi
	call	omp_get_num_threads
	movsx	r14, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r13
	div	r14
	mov	r13, rax
	cmp	rcx, rdx
	jb	.L380
.L386:
	imul	rcx, r13
	add	rdx, rcx
	lea	rax, [r13+0+rdx]
	mov	QWORD PTR [rsp+104], rax
	cmp	rdx, rax
	jnb	.L389
	mov	rcx, QWORD PTR [r12+40]
	mov	rax, QWORD PTR [r12+16]
	mov	rsi, QWORD PTR [rbx+64]
	lea	rax, [rax+rcx*8]
	mov	rcx, QWORD PTR [r12+24]
	mov	QWORD PTR [rsp+80], rsi
	mov	r9, QWORD PTR [rcx]
	mov	r8, QWORD PTR [rcx+8]
	mov	rcx, QWORD PTR [rcx+16]
	vmovsd	xmm3, QWORD PTR [r12+8]
	mov	QWORD PTR [rsp+96], rcx
	mov	rcx, QWORD PTR [r12+32]
	mov	rdi, QWORD PTR [rbx+24]
	mov	rsi, QWORD PTR [rcx+8]
	mov	r12, QWORD PTR [rcx]
	mov	r11, QWORD PTR [rbx+48]
	mov	r15, QWORD PTR [rbx+32]
	mov	r10, QWORD PTR [rbx+56]
	mov	r14, QWORD PTR [rbx+40]
	mov	QWORD PTR [rsp+72], r9
	mov	QWORD PTR [rsp+64], r8
	mov	r9, QWORD PTR [rcx+16]
	mov	QWORD PTR [rsp+144], rsi
	mov	r8, QWORD PTR [rbx+72]
	mov	rsi, QWORD PTR [rbx+80]
	mov	QWORD PTR [rsp+136], r9
	mov	QWORD PTR [rsp+32], rdi
	mov	QWORD PTR [rsp+24], r11
	mov	QWORD PTR [rsp+16], r15
	mov	QWORD PTR [rsp+8], r10
	mov	QWORD PTR [rsp], r14
	mov	QWORD PTR [rsp+88], r12
	mov	QWORD PTR [rsp+128], r8
	mov	QWORD PTR [rsp+120], rsi
	mov	r9, QWORD PTR [rbx+88]
	lea	rcx, [r13-1]
	mov	QWORD PTR [rsp+112], r9
	cmp	rcx, 2
	jbe	.L382
	lea	rsi, [0+rdx*8]
	mov	rbx, QWORD PTR [rsp+80]
	lea	r9, [rdi+rsi]
	mov	rcx, QWORD PTR [rsp+96]
	lea	rdi, [r11+rsi]
	mov	QWORD PTR [rsp+184], rdi
	lea	rdi, [r10+rsi]
	lea	r10, [rbx+rsi]
	mov	rbx, QWORD PTR [rsp+72]
	mov	QWORD PTR [rsp+176], rdi
	lea	rdi, [r14+rsi]
	lea	r14, [rcx+rsi]
	mov	rcx, QWORD PTR [rsp+128]
	lea	r11, [rbx+rsi]
	mov	rbx, QWORD PTR [rsp+64]
	mov	QWORD PTR [rsp+168], r10
	mov	QWORD PTR [rsp+160], r11
	lea	r10, [r12+rsi]
	lea	r11, [rcx+rsi]
	mov	rcx, QWORD PTR [rsp+120]
	lea	r8, [r15+rsi]
	mov	QWORD PTR [rsp+56], r10
	lea	r15, [rbx+rsi]
	mov	rbx, QWORD PTR [rsp+144]
	lea	r10, [rcx+rsi]
	mov	rcx, r13
	lea	r12, [rbx+rsi]
	shr	rcx, 2
	mov	rbx, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsp+40], rdx
	sal	rcx, 5
	mov	QWORD PTR [rsp+48], r13
	mov	r13, QWORD PTR [rsp+56]
	add	rbx, rsi
	mov	QWORD PTR [rsp+152], rcx
	vbroadcastsd	ymm2, xmm3
	add	rsi, QWORD PTR [rsp+112]
	xor	ecx, ecx
	vxorpd	xmm0, xmm0, xmm0
	.p2align 4,,10
	.p2align 3
.L383:
	vbroadcastsd	ymm1, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rsp+184]
	vmulpd	ymm1, ymm1, YMMWORD PTR [rdx+rcx]
	mov	rdx, QWORD PTR [rsp+176]
	vfmadd213pd	ymm1, ymm2, YMMWORD PTR [r9+rcx]
	vmovupd	YMMWORD PTR [r9+rcx], ymm1
	vbroadcastsd	ymm1, QWORD PTR [rax]
	vmulpd	ymm1, ymm1, YMMWORD PTR [rdx+rcx]
	mov	rdx, QWORD PTR [rsp+168]
	vfmadd213pd	ymm1, ymm2, YMMWORD PTR [r8+rcx]
	vmovupd	YMMWORD PTR [r8+rcx], ymm1
	vbroadcastsd	ymm1, QWORD PTR [rax]
	vmulpd	ymm1, ymm1, YMMWORD PTR [rdx+rcx]
	mov	rdx, QWORD PTR [rsp+160]
	vfmadd213pd	ymm1, ymm2, YMMWORD PTR [rdi+rcx]
	vmovupd	YMMWORD PTR [rdi+rcx], ymm1
	vmovupd	ymm4, YMMWORD PTR [r9+rcx]
	vmovupd	YMMWORD PTR [rdx+rcx], ymm4
	vmovupd	ymm5, YMMWORD PTR [r8+rcx]
	vmovupd	YMMWORD PTR [r15+rcx], ymm5
	vmovupd	ymm6, YMMWORD PTR [rdi+rcx]
	vmovupd	YMMWORD PTR [r14+rcx], ymm6
	vmovupd	YMMWORD PTR [r13+0+rcx], ymm0
	vmovupd	YMMWORD PTR [r12+rcx], ymm0
	vmovupd	YMMWORD PTR [rbx+rcx], ymm0
	vmovupd	YMMWORD PTR [r11+rcx], ymm0
	vmovupd	YMMWORD PTR [r10+rcx], ymm0
	vmovupd	YMMWORD PTR [rsi+rcx], ymm0
	add	rcx, 32
	cmp	rcx, QWORD PTR [rsp+152]
	jne	.L383
	mov	r13, QWORD PTR [rsp+48]
	mov	rdx, QWORD PTR [rsp+40]
	mov	rcx, r13
	and	rcx, -4
	add	rdx, rcx
	cmp	r13, rcx
	je	.L388
	vzeroupper
.L382:
	mov	r11, QWORD PTR [rsp+24]
	mov	rbx, QWORD PTR [rsp+32]
	vmovsd	xmm0, QWORD PTR [r11+rdx*8]
	lea	rcx, [0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	lea	rdi, [rbx+rcx]
	mov	r15, QWORD PTR [rsp+8]
	mov	r10, QWORD PTR [rsp+16]
	mov	r9, QWORD PTR [rsp+80]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rdi]
	lea	rsi, [r10+rcx]
	mov	r14, QWORD PTR [rsp]
	mov	r12, QWORD PTR [rsp+72]
	add	rcx, r14
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	mov	r13, QWORD PTR [rsp+64]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	mov	r8, QWORD PTR [rsp+136]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vmovsd	xmm0, QWORD PTR [r9+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	mov	rdi, QWORD PTR [rsp+88]
	vmovsd	QWORD PTR [r12+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	mov	rsi, QWORD PTR [rsp+96]
	vmovsd	QWORD PTR [r13+0+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rcx]
	mov	rcx, QWORD PTR [rsp+144]
	vmovsd	QWORD PTR [rsi+rdx*8], xmm0
	mov	QWORD PTR [rdi+rdx*8], 0x000000000
	mov	QWORD PTR [rcx+rdx*8], 0x000000000
	mov	QWORD PTR [r8+rdx*8], 0x000000000
	mov	rcx, QWORD PTR [rsp+128]
	mov	r8, QWORD PTR [rsp+120]
	mov	QWORD PTR [rcx+rdx*8], 0x000000000
	mov	rcx, QWORD PTR [rsp+112]
	mov	QWORD PTR [r8+rdx*8], 0x000000000
	mov	QWORD PTR [rcx+rdx*8], 0x000000000
	lea	rcx, [rdx+1]
	cmp	QWORD PTR [rsp+104], rcx
	jbe	.L389
	vmovsd	xmm0, QWORD PTR [r11+rcx*8]
	lea	rsi, [0+rcx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	lea	r8, [rbx+rsi]
	lea	rdi, [r10+rsi]
	add	rsi, r14
	add	rdx, 2
	vfmadd213sd	xmm0, xmm3, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rcx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r9+rcx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm0
	vmovsd	xmm0, QWORD PTR [r8]
	mov	r8, r12
	vmovsd	QWORD PTR [r12+rcx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	mov	r12, QWORD PTR [rsp+96]
	vmovsd	QWORD PTR [r13+0+rcx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	mov	rdi, QWORD PTR [rsp+88]
	mov	rsi, QWORD PTR [rsp+144]
	vmovsd	QWORD PTR [r12+rcx*8], xmm0
	mov	QWORD PTR [rdi+rcx*8], 0x000000000
	mov	QWORD PTR [rsi+rcx*8], 0x000000000
	mov	rdi, QWORD PTR [rsp+128]
	mov	rsi, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsi+rcx*8], 0x000000000
	mov	QWORD PTR [rdi+rcx*8], 0x000000000
	mov	rsi, QWORD PTR [rsp+120]
	mov	rdi, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsi+rcx*8], 0x000000000
	mov	QWORD PTR [rdi+rcx*8], 0x000000000
	cmp	QWORD PTR [rsp+104], rdx
	jbe	.L389
	vmovsd	xmm0, QWORD PTR [r11+rdx*8]
	lea	rsi, [0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	add	rbx, rsi
	mov	rdi, r10
	add	rdi, rsi
	add	rsi, r14
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rbx]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	vfmadd213sd	xmm0, xmm3, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r9+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rax]
	vfmadd213sd	xmm3, xmm0, QWORD PTR [rsi]
	vmovsd	QWORD PTR [rsi], xmm3
	vmovsd	xmm0, QWORD PTR [rbx]
	vmovsd	QWORD PTR [r8+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rdi]
	mov	rdi, QWORD PTR [rsp+88]
	vmovsd	QWORD PTR [r13+0+rdx*8], xmm0
	vmovsd	xmm0, QWORD PTR [rsi]
	mov	rsi, QWORD PTR [rsp+144]
	vmovsd	QWORD PTR [r12+rdx*8], xmm0
	mov	QWORD PTR [rdi+rdx*8], 0x000000000
	mov	QWORD PTR [rsi+rdx*8], 0x000000000
	mov	rdi, QWORD PTR [rsp+128]
	mov	rsi, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsi+rdx*8], 0x000000000
	mov	QWORD PTR [rdi+rdx*8], 0x000000000
	mov	rsi, QWORD PTR [rsp+120]
	mov	rdi, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsi+rdx*8], 0x000000000
	mov	QWORD PTR [rdi+rdx*8], 0x000000000
.L389:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L380:
	.cfi_restore_state
	inc	r13
	xor	edx, edx
	jmp	.L386
	.p2align 4,,10
	.p2align 3
.L388:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8452:
	.size	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.9, .-_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.9
	.p2align 4,,15
	.type	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.10, @function
_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.10:
.LFB8453:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	add	rsp, -128
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	rbx, QWORD PTR [rdi]
	mov	r12, QWORD PTR [rbx]
	test	r12, r12
	je	.L402
	mov	r13, rdi
	call	omp_get_num_threads
	movsx	r14, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, r12
	div	r14
	cmp	rcx, rdx
	jb	.L393
.L399:
	imul	rcx, rax
	add	rdx, rcx
	lea	rsi, [rax+rdx]
	mov	QWORD PTR [rsp+112], rsi
	cmp	rdx, rsi
	jnb	.L402
	mov	rcx, QWORD PTR [r13+16]
	mov	rsi, QWORD PTR [r13+32]
	mov	rdi, QWORD PTR [rbx+48]
	lea	rsi, [rcx+rsi*8]
	mov	rcx, QWORD PTR [r13+24]
	mov	r10, QWORD PTR [rbx+72]
	mov	r15, QWORD PTR [rcx]
	mov	r14, QWORD PTR [rbx+16]
	mov	r9, QWORD PTR [rbx+56]
	mov	r12, QWORD PTR [rbx+80]
	mov	r11, QWORD PTR [rbx+64]
	mov	r8, QWORD PTR [rcx+16]
	vmovsd	xmm3, QWORD PTR [r13+8]
	mov	rbx, QWORD PTR [rbx+88]
	mov	r13, QWORD PTR [rcx+8]
	lea	rcx, [rax-1]
	mov	QWORD PTR [rsp+72], rdi
	mov	QWORD PTR [rsp+64], r10
	mov	QWORD PTR [rsp+56], r15
	mov	QWORD PTR [rsp+48], r14
	mov	QWORD PTR [rsp+40], r9
	mov	QWORD PTR [rsp+32], r12
	mov	QWORD PTR [rsp+24], r13
	mov	QWORD PTR [rsp+96], r11
	mov	QWORD PTR [rsp+104], rbx
	mov	QWORD PTR [rsp+120], r8
	cmp	rcx, 2
	jbe	.L395
	lea	r8, [0+rdx*8]
	mov	rcx, r11
	lea	rbx, [r10+r8]
	lea	r10, [r9+r8]
	lea	r9, [rcx+r8]
	mov	rcx, QWORD PTR [rsp+104]
	lea	r11, [rdi+r8]
	lea	rdi, [r14+r8]
	lea	r14, [r12+r8]
	lea	r12, [rcx+r8]
	mov	rcx, rax
	shr	rcx, 2
	sal	rcx, 5
	mov	QWORD PTR [rsp+88], rcx
	mov	QWORD PTR [rsp+80], rax
	add	r15, r8
	mov	rax, QWORD PTR [rsp+88]
	add	r13, r8
	vbroadcastsd	ymm1, xmm3
	add	r8, QWORD PTR [rsp+120]
	xor	ecx, ecx
	.p2align 4,,10
	.p2align 3
.L396:
	vmovupd	ymm4, YMMWORD PTR [rbx+rcx]
	vbroadcastsd	ymm2, QWORD PTR [rsi]
	vaddpd	ymm0, ymm4, YMMWORD PTR [r15+rcx]
	vmulpd	ymm0, ymm0, ymm2
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rdi+rcx]
	vaddpd	ymm0, ymm0, YMMWORD PTR [r11+rcx]
	vmovupd	YMMWORD PTR [r11+rcx], ymm0
	vmovupd	ymm5, YMMWORD PTR [r14+rcx]
	vbroadcastsd	ymm2, QWORD PTR [rsi]
	vaddpd	ymm0, ymm5, YMMWORD PTR [r13+0+rcx]
	vmulpd	ymm0, ymm0, ymm2
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rdi+rcx]
	vaddpd	ymm0, ymm0, YMMWORD PTR [r10+rcx]
	vmovupd	YMMWORD PTR [r10+rcx], ymm0
	vmovupd	ymm6, YMMWORD PTR [r12+rcx]
	vbroadcastsd	ymm2, QWORD PTR [rsi]
	vaddpd	ymm0, ymm6, YMMWORD PTR [r8+rcx]
	vmulpd	ymm0, ymm0, ymm2
	vmulpd	ymm0, ymm0, ymm1
	vdivpd	ymm0, ymm0, YMMWORD PTR [rdi+rcx]
	vaddpd	ymm0, ymm0, YMMWORD PTR [r9+rcx]
	vmovupd	YMMWORD PTR [r9+rcx], ymm0
	add	rcx, 32
	cmp	rcx, rax
	jne	.L396
	mov	rax, QWORD PTR [rsp+80]
	mov	rcx, rax
	and	rcx, -4
	add	rdx, rcx
	cmp	rax, rcx
	je	.L401
	vzeroupper
.L395:
	mov	r11, QWORD PTR [rsp+64]
	mov	r10, QWORD PTR [rsp+56]
	vmovsd	xmm0, QWORD PTR [r11+rdx*8]
	mov	rbx, QWORD PTR [rsp+72]
	vaddsd	xmm0, xmm0, QWORD PTR [r10+rdx*8]
	mov	r15, QWORD PTR [rsp+48]
	lea	rax, [0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	lea	rdi, [rbx+rax]
	lea	rcx, [r15+rax]
	mov	r14, QWORD PTR [rsp+32]
	mov	r12, QWORD PTR [rsp+24]
	vmulsd	xmm0, xmm0, xmm3
	mov	r9, QWORD PTR [rsp+40]
	mov	r13, QWORD PTR [rsp+96]
	vdivsd	xmm0, xmm0, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rdx*8]
	lea	rdi, [r9+rax]
	vaddsd	xmm0, xmm0, QWORD PTR [r12+rdx*8]
	add	rax, r13
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	mov	rdi, QWORD PTR [rsp+104]
	vmovsd	xmm0, QWORD PTR [rdi+rdx*8]
	mov	rdi, QWORD PTR [rsp+120]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	lea	rax, [rdx+1]
	cmp	QWORD PTR [rsp+112], rax
	jbe	.L402
	vmovsd	xmm0, QWORD PTR [r10+rax*8]
	lea	rcx, [0+rax*8]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rax*8]
	lea	r8, [rbx+rcx]
	mov	QWORD PTR [rsp+96], rbx
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	lea	rbx, [r15+rcx]
	add	rdx, 2
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rbx]
	vaddsd	xmm0, xmm0, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rax*8]
	lea	r8, [r9+rcx]
	vaddsd	xmm0, xmm0, QWORD PTR [r12+rax*8]
	add	rcx, r13
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rbx]
	vaddsd	xmm0, xmm0, QWORD PTR [r8]
	vmovsd	QWORD PTR [r8], xmm0
	mov	r8, r13
	mov	r13, QWORD PTR [rsp+104]
	vmovsd	xmm0, QWORD PTR [r13+0+rax*8]
	vaddsd	xmm0, xmm0, QWORD PTR [rdi+rax*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rbx]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	cmp	QWORD PTR [rsp+112], rdx
	jbe	.L402
	vmovsd	xmm0, QWORD PTR [r10+rdx*8]
	mov	rbx, QWORD PTR [rsp+96]
	vaddsd	xmm0, xmm0, QWORD PTR [r11+rdx*8]
	lea	rax, [0+rdx*8]
	mov	rdi, r15
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	add	rdi, rax
	add	rbx, rax
	mov	rcx, r9
	add	rcx, rax
	vmulsd	xmm0, xmm0, xmm3
	add	rax, r8
	mov	r8, QWORD PTR [rsp+120]
	vdivsd	xmm0, xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [rbx]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r12+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [r14+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm0, xmm0, xmm3
	vdivsd	xmm0, xmm0, QWORD PTR [rdi]
	vaddsd	xmm0, xmm0, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r8+rdx*8]
	vaddsd	xmm0, xmm0, QWORD PTR [r13+0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vmulsd	xmm3, xmm0, xmm3
	vdivsd	xmm3, xmm3, QWORD PTR [rdi]
	vaddsd	xmm3, xmm3, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm3
.L402:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L393:
	.cfi_restore_state
	inc	rax
	xor	edx, edx
	jmp	.L399
	.p2align 4,,10
	.p2align 3
.L401:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8453:
	.size	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.10, .-_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.10
	.p2align 4,,15
	.type	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.11, @function
_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.11:
.LFB8454:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	push	r14
	push	r13
	push	r12
	push	rbx
	and	rsp, -32
	sub	rsp, 32
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	r12, QWORD PTR [rdi]
	mov	rbx, QWORD PTR [r12]
	test	rbx, rbx
	je	.L415
	mov	r14, rdi
	call	omp_get_num_threads
	movsx	r13, eax
	call	omp_get_thread_num
	movsx	rcx, eax
	xor	edx, edx
	mov	rax, rbx
	div	r13
	cmp	rcx, rdx
	jb	.L406
.L412:
	imul	rcx, rax
	add	rdx, rcx
	lea	rbx, [rax+rdx]
	mov	QWORD PTR [rsp+24], rbx
	cmp	rdx, rbx
	jnb	.L415
	mov	rcx, QWORD PTR [r14+16]
	mov	rsi, QWORD PTR [r14+24]
	mov	rbx, QWORD PTR [r12+24]
	mov	r8, QWORD PTR [r12+32]
	mov	r11, QWORD PTR [r12+40]
	lea	rsi, [rcx-8+rsi*8]
	lea	rcx, [rax-1]
	vmovsd	xmm2, QWORD PTR [r14+8]
	mov	QWORD PTR [rsp+16], rbx
	mov	r15, QWORD PTR [r12+48]
	mov	QWORD PTR [rsp+8], r8
	mov	r14, QWORD PTR [r12+56]
	mov	QWORD PTR [rsp], r11
	mov	r13, QWORD PTR [r12+64]
	cmp	rcx, 2
	jbe	.L408
	lea	rdi, [0+rdx*8]
	lea	r9, [r8+rdi]
	lea	r8, [r11+rdi]
	mov	r11, rax
	shr	r11, 2
	lea	r10, [rbx+rdi]
	lea	r12, [r15+rdi]
	lea	rbx, [r14+rdi]
	vbroadcastsd	ymm1, xmm2
	add	rdi, r13
	sal	r11, 5
	xor	ecx, ecx
	.p2align 4,,10
	.p2align 3
.L409:
	vbroadcastsd	ymm0, QWORD PTR [rsi]
	vmulpd	ymm0, ymm0, YMMWORD PTR [r12+rcx]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r10+rcx]
	vmovupd	YMMWORD PTR [r10+rcx], ymm0
	vbroadcastsd	ymm0, QWORD PTR [rsi]
	vmulpd	ymm0, ymm0, YMMWORD PTR [rbx+rcx]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r9+rcx]
	vmovupd	YMMWORD PTR [r9+rcx], ymm0
	vbroadcastsd	ymm0, QWORD PTR [rsi]
	vmulpd	ymm0, ymm0, YMMWORD PTR [rdi+rcx]
	vfmadd213pd	ymm0, ymm1, YMMWORD PTR [r8+rcx]
	vmovupd	YMMWORD PTR [r8+rcx], ymm0
	add	rcx, 32
	cmp	rcx, r11
	jne	.L409
	mov	rcx, rax
	and	rcx, -4
	add	rdx, rcx
	cmp	rax, rcx
	je	.L414
	vzeroupper
.L408:
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	mov	rbx, QWORD PTR [rsp+16]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	lea	rax, [0+rdx*8]
	lea	rcx, [rbx+rax]
	mov	r11, QWORD PTR [rsp+8]
	mov	r9, QWORD PTR [rsp]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	mov	r10, QWORD PTR [rsp+24]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rdx*8]
	lea	rcx, [r11+rax]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	add	rax, r9
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r13+0+rdx*8]
	lea	rcx, [rdx+1]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	cmp	r10, rcx
	jbe	.L415
	vmovsd	xmm0, QWORD PTR [r15+rcx*8]
	lea	rax, [0+rcx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	lea	rdi, [rbx+rax]
	add	rdx, 2
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rcx*8]
	lea	rdi, [r11+rax]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	add	rax, r9
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rdi]
	vmovsd	QWORD PTR [rdi], xmm0
	vmovsd	xmm0, QWORD PTR [r13+0+rcx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm0
	cmp	r10, rdx
	jbe	.L415
	vmovsd	xmm0, QWORD PTR [r15+rdx*8]
	lea	rax, [0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	add	rbx, rax
	mov	rcx, r11
	add	rcx, rax
	add	rax, r9
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rbx]
	vmovsd	QWORD PTR [rbx], xmm0
	vmovsd	xmm0, QWORD PTR [r14+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vfmadd213sd	xmm0, xmm2, QWORD PTR [rcx]
	vmovsd	QWORD PTR [rcx], xmm0
	vmovsd	xmm0, QWORD PTR [r13+0+rdx*8]
	vmulsd	xmm0, xmm0, QWORD PTR [rsi]
	vfmadd213sd	xmm2, xmm0, QWORD PTR [rax]
	vmovsd	QWORD PTR [rax], xmm2
.L415:
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L406:
	.cfi_restore_state
	inc	rax
	xor	edx, edx
	jmp	.L412
	.p2align 4,,10
	.p2align 3
.L414:
	vzeroupper
	lea	rsp, [rbp-40]
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8454:
	.size	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.11, .-_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.11
	.p2align 4,,15
	.globl	_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm
	.type	_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm, @function
_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm:
.LFB7810:
	.cfi_startproc
	sub	rsp, 88
	.cfi_def_cfa_offset 96
	mov	rax, QWORD PTR [rsp+120]
	mov	QWORD PTR [rsp+24], rcx
	mov	QWORD PTR [rsp+72], rax
	mov	rax, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsp+16], rdx
	mov	QWORD PTR [rsp+64], rax
	mov	rax, QWORD PTR [rsp+104]
	mov	QWORD PTR [rsp+8], rsi
	mov	QWORD PTR [rsp+56], rax
	mov	rax, QWORD PTR [rsp+96]
	mov	QWORD PTR [rsp], rdi
	mov	rsi, rsp
	xor	ecx, ecx
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0
	mov	QWORD PTR [rsp+48], rax
	mov	QWORD PTR [rsp+40], r9
	mov	QWORD PTR [rsp+32], r8
	call	GOMP_parallel
	add	rsp, 88
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7810:
	.size	_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm, .-_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm
	.p2align 4,,15
	.globl	_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.type	_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, @function
_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm:
.LFB7811:
	.cfi_startproc
	sub	rsp, 104
	.cfi_def_cfa_offset 112
	mov	rax, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsp+40], rcx
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+128]
	mov	QWORD PTR [rsp+32], rdx
	mov	QWORD PTR [rsp+80], rax
	mov	rax, QWORD PTR [rsp+120]
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+72], rax
	mov	rax, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsp+16], rdi
	mov	QWORD PTR [rsp+64], rax
	lea	rsi, [rsp+16]
	lea	rax, [rsp+8]
	xor	ecx, ecx
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1
	mov	QWORD PTR [rsp+8], r9
	mov	QWORD PTR [rsp+48], r8
	mov	QWORD PTR [rsp+56], rax
	call	GOMP_parallel
	add	rsp, 104
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7811:
	.size	_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, .-_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.p2align 4,,15
	.globl	_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.type	_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, @function
_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm:
.LFB7814:
	.cfi_startproc
	sub	rsp, 104
	.cfi_def_cfa_offset 112
	mov	rax, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsp+40], rcx
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+128]
	mov	QWORD PTR [rsp+32], rdx
	mov	QWORD PTR [rsp+80], rax
	mov	rax, QWORD PTR [rsp+120]
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+72], rax
	mov	rax, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsp+16], rdi
	mov	QWORD PTR [rsp+64], rax
	lea	rsi, [rsp+16]
	lea	rax, [rsp+8]
	xor	ecx, ecx
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2
	mov	QWORD PTR [rsp+8], r9
	mov	QWORD PTR [rsp+48], r8
	mov	QWORD PTR [rsp+56], rax
	call	GOMP_parallel
	add	rsp, 104
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7814:
	.size	_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, .-_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.p2align 4,,15
	.globl	_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.type	_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, @function
_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm:
.LFB7815:
	.cfi_startproc
	sub	rsp, 104
	.cfi_def_cfa_offset 112
	mov	rax, QWORD PTR [rsp+136]
	mov	QWORD PTR [rsp+40], rcx
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+128]
	mov	QWORD PTR [rsp+32], rdx
	mov	QWORD PTR [rsp+80], rax
	mov	rax, QWORD PTR [rsp+120]
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+72], rax
	mov	rax, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsp+16], rdi
	mov	QWORD PTR [rsp+64], rax
	lea	rsi, [rsp+16]
	lea	rax, [rsp+8]
	xor	ecx, ecx
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3
	mov	QWORD PTR [rsp+8], r9
	mov	QWORD PTR [rsp+48], r8
	mov	QWORD PTR [rsp+56], rax
	call	GOMP_parallel
	add	rsp, 104
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7815:
	.size	_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm, .-_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm
	.p2align 4,,15
	.globl	_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm
	.type	_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm, @function
_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm:
.LFB7816:
	.cfi_startproc
	sub	rsp, 88
	.cfi_def_cfa_offset 96
	mov	rax, QWORD PTR [rsp+112]
	mov	QWORD PTR [rsp+40], rcx
	mov	QWORD PTR [rsp+72], rax
	mov	rax, QWORD PTR [rsp+96]
	mov	QWORD PTR [rsp+32], rdx
	mov	QWORD PTR [rsp+64], rax
	mov	QWORD PTR [rsp+24], rsi
	mov	QWORD PTR [rsp+16], rdi
	lea	rax, [rsp+8]
	lea	rsi, [rsp+16]
	xor	ecx, ecx
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4
	mov	QWORD PTR [rsp+8], r9
	mov	QWORD PTR [rsp+48], r8
	mov	QWORD PTR [rsp+56], rax
	call	GOMP_parallel
	add	rsp, 88
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7816:
	.size	_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm, .-_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC7:
	.string	"Threads available: %zu\n"
	.text
	.p2align 4,,15
	.globl	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
	.type	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type, @function
_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type:
.LFB7817:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rdi
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
	xor	ebp, ebp
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 248
	.cfi_def_cfa_offset 304
	vmovsd	QWORD PTR [rsp+32], xmm0
	mov	DWORD PTR [rsp+76], ecx
	mov	BYTE PTR [rsp+75], dl
	mov	QWORD PTR [rsp+64], rdi
	mov	QWORD PTR [rsp+40], rsi
	call	omp_get_max_threads
	cdqe
	mov	rsi, rax
	mov	rbx, rax
	mov	QWORD PTR [rsp+8], rax
	mov	edi, OFFSET FLAT:.LC7
	xor	eax, eax
	call	printf
	mov	rax, rbx
	sal	rax, 3
	mov	rbx, rax
	mov	rdi, rax
	mov	QWORD PTR [rsp+56], rax
	call	malloc
	mov	rdi, rbx
	mov	QWORD PTR [rsp+16], rax
	call	malloc
	mov	QWORD PTR [rsp+24], rax
	mov	rax, QWORD PTR [r15]
	lea	r15, [rsp+128]
	mov	QWORD PTR [rsp+48], rax
	lea	rbx, [0+rax*8]
.L428:
	mov	rsi, rbx
	mov	edi, 64
	call	aligned_alloc
	mov	rsi, rbx
	mov	edi, 64
	mov	QWORD PTR [rsp+96+rbp*8], rax
	call	aligned_alloc
	mov	QWORD PTR [r15+rbp*8], rax
	inc	rbp
	cmp	rbp, 3
	jne	.L428
	xor	ebp, ebp
	cmp	QWORD PTR [rsp+8], 0
	je	.L458
	.p2align 4,,10
	.p2align 3
.L429:
	mov	edi, 24
	call	malloc
	mov	r13, rax
	mov	rax, QWORD PTR [rsp+16]
	mov	edi, 24
	mov	QWORD PTR [rax+rbp*8], r13
	xor	r14d, r14d
	call	malloc
	mov	r12, rax
	mov	rax, QWORD PTR [rsp+24]
	mov	QWORD PTR [rax+rbp*8], r12
.L432:
	mov	rsi, rbx
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r13+0+r14*8], rax
	mov	rsi, rbx
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r12+r14*8], rax
	inc	r14
	cmp	r14, 3
	jne	.L432
	inc	rbp
	cmp	QWORD PTR [rsp+8], rbp
	jne	.L429
	cmp	QWORD PTR [rsp+40], 0
	je	.L434
.L431:
	xor	ebx, ebx
	lea	rbp, [rsp+88]
	mov	r12, QWORD PTR [rsp+64]
	mov	r14, QWORD PTR [rsp+40]
	mov	r13d, DWORD PTR [rsp+76]
	jmp	.L441
	.p2align 4,,10
	.p2align 3
.L460:
	cmp	BYTE PTR [rsp+75], 0
	mov	rax, QWORD PTR [r12]
	je	.L437
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+8]
	xor	ecx, ecx
	mov	QWORD PTR [rsp+232], rax
	mov	rax, QWORD PTR [rsp+24]
	xor	edx, edx
	mov	QWORD PTR [rsp+192], rax
	mov	rax, QWORD PTR [rsp+16]
	lea	rsi, [rsp+160]
	mov	QWORD PTR [rsp+184], rax
	mov	edi, OFFSET FLAT:_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1
	lea	rax, [rsp+96]
	mov	QWORD PTR [rsp+224], 0
	mov	QWORD PTR [rsp+216], 1
	mov	QWORD PTR [rsp+208], 0
	mov	QWORD PTR [rsp+176], r15
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+160], r12
	mov	QWORD PTR [rsp+200], rbp
	call	GOMP_parallel
.L438:
	vmovsd	xmm1, QWORD PTR [rsp+32]
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+160]
	mov	edi, OFFSET FLAT:_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.6
	inc	rbx
	vmovsd	QWORD PTR [rsp+168], xmm1
	mov	QWORD PTR [rsp+160], r12
	mov	QWORD PTR [rsp+176], r15
	call	GOMP_parallel
	cmp	r14, rbx
	je	.L459
.L441:
	lea	rax, [rsp+96]
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+160]
	mov	edi, OFFSET FLAT:_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type._omp_fn.5
	mov	QWORD PTR [rsp+160], r12
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+176], r15
	call	GOMP_parallel
	test	r13d, r13d
	je	.L460
	cmp	r13d, 3
	je	.L461
	cmp	r13d, 4
	jne	.L438
	mov	rax, QWORD PTR [r12]
	xor	ecx, ecx
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+8]
	xor	edx, edx
	mov	QWORD PTR [rsp+232], rax
	mov	rax, QWORD PTR [rsp+24]
	lea	rsi, [rsp+160]
	mov	QWORD PTR [rsp+192], rax
	mov	rax, QWORD PTR [rsp+16]
	mov	edi, OFFSET FLAT:_Z38compute_forces_avx512_rsqrt_4i_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.3
	mov	QWORD PTR [rsp+184], rax
	lea	rax, [rsp+96]
	mov	QWORD PTR [rsp+224], 0
	mov	QWORD PTR [rsp+216], 1
	mov	QWORD PTR [rsp+208], 0
	mov	QWORD PTR [rsp+176], r15
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+160], r12
	mov	QWORD PTR [rsp+200], rbp
	call	GOMP_parallel
	jmp	.L438
	.p2align 4,,10
	.p2align 3
.L437:
	mov	QWORD PTR [rsp+200], rax
	mov	rax, QWORD PTR [rsp+24]
	mov	rdx, QWORD PTR [rsp+8]
	mov	QWORD PTR [rsp+192], rax
	mov	rax, QWORD PTR [rsp+16]
	mov	QWORD PTR [rsp+232], rdx
	mov	QWORD PTR [rsp+184], rax
	xor	ecx, ecx
	lea	rax, [rsp+96]
	xor	edx, edx
	lea	rsi, [rsp+160]
	mov	edi, OFFSET FLAT:_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0
	mov	QWORD PTR [rsp+224], 0
	mov	QWORD PTR [rsp+216], 1
	mov	QWORD PTR [rsp+208], 0
	mov	QWORD PTR [rsp+176], r15
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+160], r12
	call	GOMP_parallel
	jmp	.L438
	.p2align 4,,10
	.p2align 3
.L459:
	cmp	QWORD PTR [rsp+8], 0
	je	.L430
.L434:
	mov	rax, QWORD PTR [rsp+16]
	mov	rbp, QWORD PTR [rsp+56]
	mov	rbx, QWORD PTR [rsp+24]
	mov	r13, rax
	add	rbp, rax
	.p2align 4,,10
	.p2align 3
.L443:
	xor	r12d, r12d
.L442:
	mov	rax, QWORD PTR [r13+0]
	mov	rdi, QWORD PTR [rax+r12]
	call	free
	mov	rax, QWORD PTR [rbx]
	mov	rdi, QWORD PTR [rax+r12]
	add	r12, 8
	call	free
	cmp	r12, 24
	jne	.L442
	mov	rdi, QWORD PTR [r13+0]
	add	r13, 8
	call	free
	mov	rdi, QWORD PTR [rbx]
	add	rbx, 8
	call	free
	cmp	r13, rbp
	jne	.L443
.L430:
	xor	ebx, ebx
.L435:
	mov	rdi, QWORD PTR [r15+rbx*8]
	call	free
	mov	rdi, QWORD PTR [rsp+96+rbx*8]
	inc	rbx
	call	free
	cmp	rbx, 3
	jne	.L435
	mov	rdi, QWORD PTR [rsp+16]
	call	free
	mov	rdi, QWORD PTR [rsp+24]
	add	rsp, 248
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
	jmp	free
	.p2align 4,,10
	.p2align 3
.L461:
	.cfi_restore_state
	mov	rax, QWORD PTR [r12]
	xor	ecx, ecx
	mov	QWORD PTR [rsp+88], rax
	mov	rax, QWORD PTR [rsp+8]
	xor	edx, edx
	mov	QWORD PTR [rsp+232], rax
	mov	rax, QWORD PTR [rsp+24]
	lea	rsi, [rsp+160]
	mov	QWORD PTR [rsp+192], rax
	mov	rax, QWORD PTR [rsp+16]
	mov	edi, OFFSET FLAT:_Z35compute_forces_avx512_rsqrt_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.2
	mov	QWORD PTR [rsp+184], rax
	lea	rax, [rsp+96]
	mov	QWORD PTR [rsp+224], 0
	mov	QWORD PTR [rsp+216], 1
	mov	QWORD PTR [rsp+208], 0
	mov	QWORD PTR [rsp+176], r15
	mov	QWORD PTR [rsp+168], rax
	mov	QWORD PTR [rsp+160], r12
	mov	QWORD PTR [rsp+200], rbp
	call	GOMP_parallel
	jmp	.L438
.L458:
	cmp	QWORD PTR [rsp+40], 0
	jne	.L431
	jmp	.L430
	.cfi_endproc
.LFE7817:
	.size	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type, .-_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
	.p2align 4,,15
	.globl	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type
	.type	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type, @function
_Z15full_solver_ompR12NBody_systemmd18Vectorization_type:
.LFB7818:
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
	sub	rsp, 168
	.cfi_def_cfa_offset 224
	vmovsd	QWORD PTR [rsp+16], xmm0
	mov	DWORD PTR [rsp+76], edx
	mov	QWORD PTR [rsp+48], rsi
	call	omp_get_max_threads
	movsx	r14, eax
	mov	rsi, r14
	lea	r15, [0+r14*8]
	mov	edi, OFFSET FLAT:.LC7
	xor	eax, eax
	mov	QWORD PTR [rsp+56], r14
	call	printf
	mov	rdi, r15
	mov	QWORD PTR [rsp+64], r15
	call	malloc
	mov	rbp, QWORD PTR [r13+0]
	mov	QWORD PTR [rsp+32], rax
	mov	rbx, rbp
	shr	rbx, 2
	mov	r12, rax
	xor	eax, eax
	test	bpl, 3
	setne	al
	mov	rdi, r15
	add	rbx, rax
	call	malloc
	mov	QWORD PTR [rsp+40], rax
	test	r14, r14
	je	.L464
	add	r15, rax
	mov	QWORD PTR [rsp], r12
	mov	QWORD PTR [rsp+8], r15
	mov	QWORD PTR [rsp+24], r13
	mov	r13, rax
	.p2align 4,,10
	.p2align 3
.L465:
	mov	edi, 24
	call	malloc
	mov	r12, rax
	mov	rax, QWORD PTR [rsp]
	mov	rdi, rbx
	mov	QWORD PTR [rax], r12
	sal	rbp, 3
	xor	r15d, r15d
	call	malloc
	mov	QWORD PTR [r13+0], rax
	mov	r14, rax
.L468:
	mov	rsi, rbp
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r12+r15*8], rax
	inc	r15
	cmp	r15, 3
	jne	.L468
	test	rbx, rbx
	je	.L469
	mov	BYTE PTR [r14], -1
	cmp	rbx, 1
	je	.L469
	mov	eax, 1
	.p2align 4,,10
	.p2align 3
.L470:
	mov	rdx, QWORD PTR [r13+0]
	mov	BYTE PTR [rdx+rax], -1
	inc	rax
	cmp	rbx, rax
	jne	.L470
.L469:
	add	r13, 8
	add	QWORD PTR [rsp], 8
	cmp	r13, QWORD PTR [rsp+8]
	je	.L471
	mov	rax, QWORD PTR [rsp+24]
	mov	rbp, QWORD PTR [rax]
	jmp	.L465
	.p2align 4,,10
	.p2align 3
.L471:
	cmp	QWORD PTR [rsp+48], 0
	mov	r13, QWORD PTR [rsp+24]
	je	.L466
.L467:
	mov	eax, DWORD PTR [rsp+76]
	test	eax, eax
	je	.L477
	mov	r12, QWORD PTR [rsp+48]
	xor	ebp, ebp
	lea	rbx, [rsp+96]
	.p2align 4,,10
	.p2align 3
.L474:
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7
	mov	QWORD PTR [rsp+96], r13
	call	GOMP_parallel
	vmovsd	xmm1, QWORD PTR [rsp+16]
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8
	inc	rbp
	vmovsd	QWORD PTR [rsp+104], xmm1
	mov	QWORD PTR [rsp+96], r13
	call	GOMP_parallel
	cmp	r12, rbp
	ja	.L474
.L473:
	cmp	QWORD PTR [rsp+56], 0
	je	.L475
.L466:
	mov	rax, QWORD PTR [rsp+32]
	mov	r12, QWORD PTR [rsp+64]
	mov	rbp, QWORD PTR [rsp+40]
	mov	rbx, rax
	add	r12, rax
	.p2align 4,,10
	.p2align 3
.L476:
	mov	rax, QWORD PTR [rbx]
	add	rbx, 8
	mov	rdi, QWORD PTR [rax]
	add	rbp, 8
	call	free
	mov	rax, QWORD PTR [rbx-8]
	mov	rdi, QWORD PTR [rax+8]
	call	free
	mov	rax, QWORD PTR [rbx-8]
	mov	rdi, QWORD PTR [rax+16]
	call	free
	mov	rdi, QWORD PTR [rbx-8]
	call	free
	mov	rdi, QWORD PTR [rbp-8]
	call	free
	cmp	r12, rbx
	jne	.L476
.L475:
	mov	rdi, QWORD PTR [rsp+32]
	call	free
	mov	rdi, QWORD PTR [rsp+40]
	add	rsp, 168
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
	jmp	free
.L477:
	.cfi_restore_state
	lea	r12, [r13+24]
	xor	r14d, r14d
	mov	rax, r12
	mov	r15, QWORD PTR [rsp+56]
	mov	r12, r14
	lea	rbx, [rsp+96]
	lea	rbp, [rsp+88]
	mov	r14, rax
	.p2align 4,,10
	.p2align 3
.L472:
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.7
	mov	QWORD PTR [rsp+96], r13
	call	GOMP_parallel
	mov	rax, QWORD PTR [rsp+40]
	mov	rdx, QWORD PTR [r13+16]
	mov	rcx, QWORD PTR [r13+0]
	mov	QWORD PTR [rsp+128], rax
	mov	rax, QWORD PTR [rsp+32]
	mov	QWORD PTR [rsp+88], rcx
	mov	QWORD PTR [rsp+120], rdx
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:_Z24compute_forces_full_avx2R12NBody_systemPPPdS2_S1_PPhmmmm._omp_fn.4
	mov	QWORD PTR [rsp+104], rax
	mov	QWORD PTR [rsp+152], r15
	mov	QWORD PTR [rsp+144], 0
	mov	QWORD PTR [rsp+112], r14
	mov	QWORD PTR [rsp+96], r13
	mov	QWORD PTR [rsp+136], rbp
	call	GOMP_parallel
	vmovsd	xmm2, QWORD PTR [rsp+16]
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:_Z15full_solver_ompR12NBody_systemmd18Vectorization_type._omp_fn.8
	inc	r12
	vmovsd	QWORD PTR [rsp+104], xmm2
	mov	QWORD PTR [rsp+96], r13
	call	GOMP_parallel
	cmp	QWORD PTR [rsp+48], r12
	ja	.L472
	jmp	.L473
.L464:
	cmp	QWORD PTR [rsp+48], 0
	jne	.L467
	jmp	.L475
	.cfi_endproc
.LFE7818:
	.size	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type, .-_Z15full_solver_ompR12NBody_systemmd18Vectorization_type
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC8:
	.string	"force calculation took: %fs\nintegration took : %fs\n"
	.text
	.p2align 4,,15
	.globl	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb
	.type	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb, @function
_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb:
.LFB7819:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14d, r9d
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	xor	r13d, r13d
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
	sub	rsp, 280
	.cfi_def_cfa_offset 336
	vmovsd	QWORD PTR [rsp+8], xmm0
	mov	QWORD PTR [rsp+24], rdx
	mov	QWORD PTR [rsp+72], rcx
	mov	QWORD PTR [rsp+96], r8
	mov	QWORD PTR [rsp+88], rsi
	call	omp_get_max_threads
	cdqe
	mov	rsi, rax
	mov	r15, rax
	mov	QWORD PTR [rsp+40], rax
	mov	edi, OFFSET FLAT:.LC7
	xor	eax, eax
	call	printf
	mov	rax, r15
	sal	rax, 3
	mov	r15, rax
	mov	rdi, rax
	mov	QWORD PTR [rsp+104], rax
	call	malloc
	mov	rdi, r15
	mov	QWORD PTR [rsp+48], rax
	call	malloc
	mov	QWORD PTR [rsp+56], rax
	mov	rax, QWORD PTR [rbx]
	lea	r15, [rsp+128]
	lea	r12, [0+rax*8]
	lea	rbp, [rsp+160]
.L498:
	mov	rsi, r12
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r15+r13*8], rax
	mov	rsi, r12
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [rbp+0+r13*8], rax
	inc	r13
	cmp	r13, 3
	jne	.L498
	cmp	QWORD PTR [rsp+40], 0
	mov	QWORD PTR [rsp], 0
	je	.L529
	mov	QWORD PTR [rsp+16], rbx
	mov	BYTE PTR [rsp+32], r14b
	.p2align 4,,10
	.p2align 3
.L499:
	mov	edi, 24
	call	malloc
	mov	r14, rax
	mov	rbx, QWORD PTR [rsp]
	mov	rax, QWORD PTR [rsp+48]
	mov	edi, 24
	mov	QWORD PTR [rax+rbx*8], r14
	call	malloc
	mov	r13, rax
	mov	rax, QWORD PTR [rsp+56]
	mov	QWORD PTR [rax+rbx*8], r13
	xor	ebx, ebx
.L502:
	mov	rsi, r12
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r14+rbx*8], rax
	mov	rsi, r12
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r13+0+rbx*8], rax
	inc	rbx
	cmp	rbx, 3
	jne	.L502
	inc	QWORD PTR [rsp]
	mov	rax, QWORD PTR [rsp]
	cmp	QWORD PTR [rsp+40], rax
	jne	.L499
	cmp	QWORD PTR [rsp+88], 0
	mov	rbx, QWORD PTR [rsp+16]
	movzx	r14d, BYTE PTR [rsp+32]
	je	.L530
.L501:
	mov	rax, QWORD PTR [rsp+96]
	mov	QWORD PTR [rsp+80], 0
	lea	r13, [rax-1]
	vxorpd	xmm26, xmm26, xmm26
	mov	QWORD PTR [rsp+64], r13
	mov	r13, QWORD PTR [rsp+24]
	vmovsd	QWORD PTR [rsp], xmm26
	vmovsd	QWORD PTR [rsp+16], xmm26
	.p2align 4,,10
	.p2align 3
.L508:
	cmp	QWORD PTR [rsp+64], 0
	je	.L504
	xor	r12d, r12d
	jmp	.L507
	.p2align 4,,10
	.p2align 3
.L531:
	mov	QWORD PTR [rsp+120], rax
	mov	rax, QWORD PTR [rsp+40]
	xor	ecx, ecx
	mov	QWORD PTR [rsp+264], rax
	mov	rax, QWORD PTR [rsp+56]
	xor	edx, edx
	mov	QWORD PTR [rsp+224], rax
	mov	rax, QWORD PTR [rsp+48]
	lea	rsi, [rsp+192]
	mov	QWORD PTR [rsp+216], rax
	mov	edi, OFFSET FLAT:_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1
	lea	rax, [rsp+120]
	mov	QWORD PTR [rsp+256], 0
	mov	QWORD PTR [rsp+248], 1
	mov	QWORD PTR [rsp+240], 0
	mov	QWORD PTR [rsp+208], rbp
	mov	QWORD PTR [rsp+200], r15
	mov	QWORD PTR [rsp+192], rbx
	mov	QWORD PTR [rsp+232], rax
	call	GOMP_parallel
.L506:
	call	omp_get_wtime
	vsubsd	xmm1, xmm0, QWORD PTR [rsp+32]
	mov	rax, QWORD PTR [rsp+72]
	vmovsd	xmm19, QWORD PTR [rsp+8]
	vaddsd	xmm17, xmm1, QWORD PTR [rsp+16]
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+192]
	mov	edi, OFFSET FLAT:_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.10
	vmovsd	QWORD PTR [rsp+24], xmm0
	vmovsd	QWORD PTR [rsp+16], xmm17
	mov	QWORD PTR [rsp+224], r12
	mov	QWORD PTR [rsp+208], rax
	vmovsd	QWORD PTR [rsp+200], xmm19
	mov	QWORD PTR [rsp+192], rbx
	mov	QWORD PTR [rsp+216], rbp
	call	GOMP_parallel
	call	omp_get_wtime
	vmovsd	xmm2, QWORD PTR [rsp+24]
	inc	r12
	vsubsd	xmm0, xmm0, xmm2
	vaddsd	xmm20, xmm0, QWORD PTR [rsp]
	vmovsd	QWORD PTR [rsp], xmm20
	cmp	QWORD PTR [rsp+64], r12
	je	.L504
.L507:
	call	omp_get_wtime
	vmovsd	xmm4, QWORD PTR [rsp+8]
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+192]
	mov	edi, OFFSET FLAT:_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.9
	vmovsd	QWORD PTR [rsp+24], xmm0
	vmovsd	QWORD PTR [rsp+200], xmm4
	mov	QWORD PTR [rsp+232], r12
	mov	QWORD PTR [rsp+208], r13
	mov	QWORD PTR [rsp+192], rbx
	mov	QWORD PTR [rsp+216], r15
	mov	QWORD PTR [rsp+224], rbp
	call	GOMP_parallel
	call	omp_get_wtime
	vmovsd	QWORD PTR [rsp+32], xmm0
	vsubsd	xmm0, xmm0, QWORD PTR [rsp+24]
	mov	rax, QWORD PTR [rbx]
	vaddsd	xmm6, xmm0, QWORD PTR [rsp]
	vmovsd	QWORD PTR [rsp], xmm6
	test	r14b, r14b
	jne	.L531
	mov	QWORD PTR [rsp+232], rax
	mov	rax, QWORD PTR [rsp+56]
	mov	rdx, QWORD PTR [rsp+40]
	mov	QWORD PTR [rsp+224], rax
	mov	rax, QWORD PTR [rsp+48]
	mov	QWORD PTR [rsp+264], rdx
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+192]
	mov	edi, OFFSET FLAT:_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0
	mov	QWORD PTR [rsp+256], 0
	mov	QWORD PTR [rsp+248], 1
	mov	QWORD PTR [rsp+240], 0
	mov	QWORD PTR [rsp+216], rax
	mov	QWORD PTR [rsp+208], rbp
	mov	QWORD PTR [rsp+200], r15
	mov	QWORD PTR [rsp+192], rbx
	call	GOMP_parallel
	jmp	.L506
	.p2align 4,,10
	.p2align 3
.L504:
	call	omp_get_wtime
	mov	rax, QWORD PTR [rsp+96]
	vmovsd	xmm22, QWORD PTR [rsp+8]
	xor	ecx, ecx
	xor	edx, edx
	lea	rsi, [rsp+192]
	mov	edi, OFFSET FLAT:_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb._omp_fn.11
	mov	QWORD PTR [rsp+216], rax
	vmovsd	QWORD PTR [rsp+24], xmm0
	vmovsd	QWORD PTR [rsp+200], xmm22
	mov	QWORD PTR [rsp+208], r13
	mov	QWORD PTR [rsp+192], rbx
	call	GOMP_parallel
	call	omp_get_wtime
	vsubsd	xmm0, xmm0, QWORD PTR [rsp+24]
	inc	QWORD PTR [rsp+80]
	vaddsd	xmm24, xmm0, QWORD PTR [rsp]
	mov	rax, QWORD PTR [rsp+80]
	vmovsd	QWORD PTR [rsp], xmm24
	cmp	QWORD PTR [rsp+88], rax
	jne	.L508
	vmovsd	xmm0, QWORD PTR [rsp+16]
	vmovapd	xmm1, xmm24
	mov	edi, OFFSET FLAT:.LC8
	mov	eax, 2
	call	printf
	cmp	QWORD PTR [rsp+40], 0
	je	.L512
.L509:
	mov	rax, QWORD PTR [rsp+48]
	mov	r12, QWORD PTR [rsp+104]
	mov	rbx, QWORD PTR [rsp+56]
	mov	r14, rax
	add	r12, rax
	.p2align 4,,10
	.p2align 3
.L513:
	xor	r13d, r13d
.L511:
	mov	rax, QWORD PTR [r14]
	mov	rdi, QWORD PTR [rax+r13]
	call	free
	mov	rax, QWORD PTR [rbx]
	mov	rdi, QWORD PTR [rax+r13]
	add	r13, 8
	call	free
	cmp	r13, 24
	jne	.L511
	mov	rdi, QWORD PTR [r14]
	add	r14, 8
	call	free
	mov	rdi, QWORD PTR [rbx]
	add	rbx, 8
	call	free
	cmp	r12, r14
	jne	.L513
.L512:
	xor	ebx, ebx
.L510:
	mov	rdi, QWORD PTR [rbp+0+rbx*8]
	call	free
	mov	rdi, QWORD PTR [r15+rbx*8]
	inc	rbx
	call	free
	cmp	rbx, 3
	jne	.L510
	mov	rdi, QWORD PTR [rsp+48]
	call	free
	mov	rdi, QWORD PTR [rsp+56]
	add	rsp, 280
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
	jmp	free
.L529:
	.cfi_restore_state
	cmp	QWORD PTR [rsp+88], 0
	jne	.L501
	vxorpd	xmm1, xmm1, xmm1
	vxorpd	xmm0, xmm0, xmm0
	mov	edi, OFFSET FLAT:.LC8
	mov	eax, 2
	call	printf
	jmp	.L512
.L530:
	vxorpd	xmm1, xmm1, xmm1
	vxorpd	xmm0, xmm0, xmm0
	mov	edi, OFFSET FLAT:.LC8
	mov	eax, 2
	call	printf
	jmp	.L509
	.cfi_endproc
.LFE7819:
	.size	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb, .-_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb
	.section	.text.unlikely,"ax",@progbits
.LCOLDB9:
	.text
.LHOTB9:
	.p2align 4,,15
	.globl	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb
	.type	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb, @function
_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb:
.LFB7820:
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
	mov	r15, rdi
	mov	edi, 1
	push	r14
	push	r13
	push	r12
	push	r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	push	rbx
	sub	rsp, 480
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	vmovsd	QWORD PTR [rbp-280], xmm0
	mov	QWORD PTR [rbp-504], rdx
	mov	QWORD PTR [rbp-432], rcx
	mov	QWORD PTR [rbp-376], r8
	mov	BYTE PTR [rbp-433], r9b
	mov	QWORD PTR [rbp-480], rsi
	call	omp_set_num_threads
	call	omp_get_max_threads
	cdqe
	mov	rsi, rax
	mov	rbx, rax
	mov	QWORD PTR [rbp-400], rax
	mov	edi, OFFSET FLAT:.LC7
	xor	eax, eax
	call	printf
	mov	rax, rbx
	sal	rax, 3
	mov	rbx, rax
	mov	rdi, rax
	mov	QWORD PTR [rbp-488], rax
	call	malloc
	mov	rdi, rbx
	mov	QWORD PTR [rbp-408], rax
	call	malloc
	mov	QWORD PTR [rbp-416], rax
	mov	rdx, QWORD PTR [r15]
	vmovsd	xmm0, QWORD PTR [rbp-280]
	lea	r13, [0+rdx*8]
	xor	ebx, ebx
	mov	r12, rdx
.L533:
	mov	rsi, r13
	mov	edi, 64
	vmovsd	QWORD PTR [rbp-280], xmm0
	call	aligned_alloc
	mov	rsi, r13
	mov	edi, 64
	mov	QWORD PTR [rbp-256+rbx*8], rax
	call	aligned_alloc
	mov	QWORD PTR [rbp-224+rbx*8], rax
	inc	rbx
	cmp	rbx, 3
	vmovsd	xmm0, QWORD PTR [rbp-280]
	jne	.L533
	xor	edi, edi
	cmp	QWORD PTR [rbp-400], 0
	mov	rdx, r12
	je	.L538
	mov	QWORD PTR [rbp-280], r12
	mov	QWORD PTR [rbp-288], r15
	mov	r14, rdi
	vmovsd	QWORD PTR [rbp-296], xmm0
.L534:
	mov	edi, 24
	call	malloc
	mov	r12, rax
	mov	rax, QWORD PTR [rbp-408]
	mov	edi, 24
	mov	QWORD PTR [rax+r14*8], r12
	xor	r15d, r15d
	call	malloc
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-416]
	mov	QWORD PTR [rax+r14*8], rbx
.L537:
	mov	rsi, r13
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [r12+r15*8], rax
	mov	rsi, r13
	mov	edi, 64
	call	aligned_alloc
	mov	QWORD PTR [rbx+r15*8], rax
	inc	r15
	cmp	r15, 3
	jne	.L537
	inc	r14
	cmp	QWORD PTR [rbp-400], r14
	jne	.L534
	mov	rdx, QWORD PTR [rbp-280]
	mov	r15, QWORD PTR [rbp-288]
	vmovsd	xmm0, QWORD PTR [rbp-296]
.L538:
	mov	rdi, QWORD PTR [rbp-376]
	lea	rax, [rdi+rdi*2]
	lea	rax, [15+rax*8]
	shr	rax, 4
	sal	rax, 4
	sub	rsp, rax
	mov	QWORD PTR [rbp-288], rsp
	sub	rsp, rax
	mov	QWORD PTR [rbp-296], rsp
	test	rdi, rdi
	je	.L535
	mov	QWORD PTR [rbp-280], 0
	mov	r12, QWORD PTR [rbp-288]
	mov	r13, rsp
	movabs	rbx, 1152921504606846975
	vmovsd	QWORD PTR [rbp-304], xmm0
.L543:
	cmp	rdx, rbx
	ja	.L539
	xor	r14d, r14d
.L542:
	lea	rdi, [0+rdx*8]
	call	_Znam
	mov	QWORD PTR [r12+r14*8], rax
	mov	rax, QWORD PTR [r15]
	cmp	rax, rbx
	ja	.L539
	lea	rdi, [0+rax*8]
	call	_Znam
	mov	QWORD PTR [r13+0+r14*8], rax
	inc	r14
	cmp	r14, 3
	je	.L541
	mov	rdx, QWORD PTR [r15]
	cmp	rdx, rbx
	jbe	.L542
	jmp	.L539
	.p2align 4,,10
	.p2align 3
.L541:
	inc	QWORD PTR [rbp-280]
	mov	rdx, QWORD PTR [r15]
	add	r13, 24
	add	r12, 24
	mov	rax, QWORD PTR [rbp-280]
	cmp	QWORD PTR [rbp-376], rax
	jne	.L543
	vmovsd	xmm0, QWORD PTR [rbp-304]
.L535:
	movabs	rbx, 1152921504606846975
	cmp	rdx, rbx
	ja	.L539
	xor	r12d, r12d
	vmovsd	QWORD PTR [rbp-280], xmm0
.L545:
	lea	rdi, [0+rdx*8]
	call	_Znam
	mov	QWORD PTR [rbp-192+r12*8], rax
	mov	rax, QWORD PTR [r15]
	cmp	rax, rbx
	ja	.L539
	lea	rdi, [0+rax*8]
	call	_Znam
	mov	QWORD PTR [rbp-160+r12*8], rax
	inc	r12
	cmp	r12, 3
	je	.L544
	mov	rdx, QWORD PTR [r15]
	cmp	rdx, rbx
	jbe	.L545
	jmp	.L539
	.p2align 4,,10
	.p2align 3
.L544:
	mov	rax, QWORD PTR [rbp-376]
	vmovsd	xmm0, QWORD PTR [rbp-280]
	dec	rax
	mov	QWORD PTR [rbp-424], rax
	mov	rax, QWORD PTR [rbp-192]
	cmp	QWORD PTR [rbp-480], 0
	mov	QWORD PTR [rbp-304], rax
	mov	rax, QWORD PTR [rbp-160]
	mov	QWORD PTR [rbp-312], rax
	je	.L552
	mov	rax, QWORD PTR [r15]
	mov	rbx, QWORD PTR [rbp-376]
	mov	QWORD PTR [rbp-368], rax
	mov	rax, QWORD PTR [rbp-424]
	mov	QWORD PTR [rbp-472], 0
	sal	rax, 3
	mov	QWORD PTR [rbp-456], rax
	add	rax, 8
	mov	QWORD PTR [rbp-464], rax
	mov	rax, QWORD PTR [rbp-432]
	mov	r14, r15
	lea	rax, [rax+rbx*8]
	mov	QWORD PTR [rbp-496], rax
.L553:
	mov	rax, QWORD PTR [rbp-368]
	xor	r12d, r12d
	lea	rbx, [0+rax*8]
	vmovsd	QWORD PTR [rbp-280], xmm0
.L549:
	mov	rdi, QWORD PTR [rbp-192+r12*8]
	mov	rsi, QWORD PTR [r14+24+r12*8]
	mov	rdx, rbx
	call	memcpy
	mov	rdi, QWORD PTR [rbp-160+r12*8]
	mov	rsi, QWORD PTR [r14+48+r12*8]
	mov	rdx, rbx
	inc	r12
	call	memcpy
	cmp	r12, 3
	jne	.L549
	cmp	QWORD PTR [rbp-376], 0
	vmovsd	xmm0, QWORD PTR [rbp-280]
	je	.L564
	mov	rax, QWORD PTR [rbp-504]
	mov	QWORD PTR [rbp-360], 0
	mov	QWORD PTR [rbp-320], rax
	lea	r15, [rax+8]
	mov	rax, QWORD PTR [rbp-296]
	vmovsd	QWORD PTR [rbp-448], xmm0
	mov	QWORD PTR [rbp-384], rax
	mov	rax, QWORD PTR [rbp-288]
	mov	QWORD PTR [rbp-352], rax
	.p2align 4,,10
	.p2align 3
.L566:
	mov	rdx, QWORD PTR [rbp-368]
	xor	ebx, ebx
.L555:
	mov	rdi, QWORD PTR [rbp-256+rbx*8]
	mov	rsi, QWORD PTR [r14+24+rbx*8]
	sal	rdx, 3
	call	memcpy
	mov	rax, QWORD PTR [r14]
	mov	rdi, QWORD PTR [rbp-224+rbx*8]
	lea	rdx, [0+rax*8]
	xor	esi, esi
	call	memset
	mov	rax, QWORD PTR [r14]
	mov	rdi, QWORD PTR [r14+72+rbx*8]
	lea	rdx, [0+rax*8]
	xor	esi, esi
	inc	rbx
	call	memset
	cmp	rbx, 3
	je	.L554
	mov	rdx, QWORD PTR [r14]
	jmp	.L555
	.p2align 4,,10
	.p2align 3
.L554:
	cmp	BYTE PTR [rbp-433], 0
	mov	rax, QWORD PTR [r14]
	je	.L556
	mov	QWORD PTR [rbp-264], rax
	mov	rax, QWORD PTR [rbp-400]
	xor	ecx, ecx
	mov	QWORD PTR [rbp-56], rax
	mov	rax, QWORD PTR [rbp-416]
	xor	edx, edx
	mov	QWORD PTR [rbp-96], rax
	mov	rax, QWORD PTR [rbp-408]
	lea	rsi, [rbp-128]
	mov	QWORD PTR [rbp-104], rax
	lea	rax, [rbp-224]
	mov	QWORD PTR [rbp-112], rax
	lea	rax, [rbp-256]
	mov	QWORD PTR [rbp-120], rax
	mov	edi, OFFSET FLAT:_Z27compute_forces_avx2_blockedR12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.1
	lea	rax, [rbp-264]
	mov	QWORD PTR [rbp-64], 0
	mov	QWORD PTR [rbp-72], 1
	mov	QWORD PTR [rbp-80], 0
	mov	QWORD PTR [rbp-128], r14
	mov	QWORD PTR [rbp-88], rax
	call	GOMP_parallel
.L557:
	xor	r13d, r13d
	mov	QWORD PTR [rbp-280], r15
	mov	r15, r13
	mov	r13, QWORD PTR [rbp-384]
	mov	r12, r14
.L563:
	mov	r14, QWORD PTR [r12]
	mov	rbx, QWORD PTR [r12+72+r15*8]
	test	r14, r14
	je	.L558
	mov	rdx, QWORD PTR [rbp-224+r15*8]
	lea	rax, [rbx+32]
	cmp	rdx, rax
	lea	rax, [rdx+32]
	setnb	sil
	cmp	rbx, rax
	setnb	al
	or	sil, al
	je	.L588
	lea	rax, [r14-1]
	cmp	rax, 2
	jbe	.L588
	mov	rsi, r14
	shr	rsi, 2
	sal	rsi, 5
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L560:
	vmovupd	ymm16, YMMWORD PTR [rdx+rax]
	vaddpd	ymm1, ymm16, YMMWORD PTR [rbx+rax]
	vmovupd	YMMWORD PTR [rbx+rax], ymm1
	add	rax, 32
	cmp	rax, rsi
	jne	.L560
	mov	rax, r14
	and	rax, -4
	cmp	r14, rax
	je	.L638
	lea	rsi, [rbx+rax*8]
	vmovsd	xmm1, QWORD PTR [rsi]
	vaddsd	xmm1, xmm1, QWORD PTR [rdx+rax*8]
	vmovsd	QWORD PTR [rsi], xmm1
	lea	rsi, [rax+1]
	cmp	r14, rsi
	jbe	.L638
	lea	rdi, [rbx+rsi*8]
	vmovsd	xmm1, QWORD PTR [rdi]
	add	rax, 2
	vaddsd	xmm1, xmm1, QWORD PTR [rdx+rsi*8]
	vmovsd	QWORD PTR [rdi], xmm1
	cmp	r14, rax
	jbe	.L638
	lea	rsi, [rbx+rax*8]
	vmovsd	xmm1, QWORD PTR [rsi]
	vaddsd	xmm1, xmm1, QWORD PTR [rdx+rax*8]
	vmovsd	QWORD PTR [rsi], xmm1
	vzeroupper
.L562:
	sal	r14, 3
.L558:
	mov	rax, QWORD PTR [rbp-352]
	mov	rsi, QWORD PTR [r12+48+r15*8]
	mov	rdi, QWORD PTR [rax+r15*8]
	mov	rdx, r14
	call	memcpy
	mov	rdi, QWORD PTR [r13+0+r15*8]
	mov	rdx, r14
	mov	rsi, rbx
	call	memcpy
	mov	rdi, QWORD PTR [r12+24+r15*8]
	mov	rdx, r14
	xor	esi, esi
	call	memset
	mov	rax, QWORD PTR [r12]
	mov	rdi, QWORD PTR [r12+48+r15*8]
	lea	rdx, [0+rax*8]
	xor	esi, esi
	inc	r15
	call	memset
	cmp	r15, 3
	jne	.L563
	mov	rax, QWORD PTR [r12]
	mov	rcx, QWORD PTR [rbp-360]
	mov	r15, QWORD PTR [rbp-280]
	mov	r14, r12
	mov	QWORD PTR [rbp-368], rax
	cmp	QWORD PTR [rbp-424], rcx
	je	.L633
	test	rax, rax
	je	.L568
	mov	rcx, QWORD PTR [rbp-176]
	mov	r10, QWORD PTR [r14+24]
	mov	QWORD PTR [rbp-328], rcx
	mov	rcx, QWORD PTR [rbp-368]
	mov	rbx, QWORD PTR [rbp-152]
	lea	rcx, [r10+rcx*8]
	mov	rax, QWORD PTR [rbp-184]
	mov	QWORD PTR [rbp-344], rcx
	mov	r13, QWORD PTR [r12+16]
	vmovsd	xmm0, QWORD PTR [rbp-448]
	mov	r12, QWORD PTR [rbp-144]
	mov	QWORD PTR [rbp-336], rbx
	mov	r11, QWORD PTR [r14+40]
	mov	rbx, QWORD PTR [r14+32]
	mov	r9, QWORD PTR [r14+48]
	mov	r8, QWORD PTR [r14+56]
	mov	rdi, QWORD PTR [r14+64]
	mov	QWORD PTR [rbp-392], r14
	xor	edx, edx
	mov	r14, rax
	.p2align 4,,10
	.p2align 3
.L569:
	mov	QWORD PTR [rbp-280], r12
	mov	rsi, QWORD PTR [rbp-296]
	mov	rcx, QWORD PTR [rbp-288]
	mov	rax, QWORD PTR [rbp-320]
	.p2align 4,,10
	.p2align 3
.L567:
	vmovsd	xmm1, QWORD PTR [rax]
	vmovsd	xmm2, QWORD PTR [r10]
	mov	r12, QWORD PTR [rcx]
	add	rax, 8
	vfmadd132sd	xmm1, xmm2, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rcx+8]
	add	rsi, 24
	add	rcx, 24
	vmovsd	QWORD PTR [r10], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8]
	vmovsd	xmm3, QWORD PTR [rbx]
	vfmadd132sd	xmm1, xmm3, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rcx-8]
	vmovsd	QWORD PTR [rbx], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8]
	vmovsd	xmm4, QWORD PTR [r11]
	vfmadd132sd	xmm1, xmm4, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rsi-24]
	vmovsd	QWORD PTR [r11], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8]
	vmovsd	xmm5, QWORD PTR [r9]
	vfmadd132sd	xmm1, xmm5, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rsi-16]
	vmovsd	QWORD PTR [r9], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8]
	vmovsd	xmm6, QWORD PTR [r8]
	vfmadd132sd	xmm1, xmm6, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rsi-8]
	vmovsd	QWORD PTR [r8], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8]
	vmovsd	xmm7, QWORD PTR [rdi]
	vfmadd132sd	xmm1, xmm7, QWORD PTR [r12+rdx]
	vmovsd	QWORD PTR [rdi], xmm1
	cmp	rax, r15
	jne	.L567
	vmulsd	xmm1, xmm0, QWORD PTR [r10]
	mov	rax, QWORD PTR [rbp-304]
	mov	r12, QWORD PTR [rbp-280]
	add	r10, 8
	add	rbx, 8
	vmovsd	QWORD PTR [r10-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [rbx-8]
	add	r11, 8
	add	r9, 8
	add	r8, 8
	add	rdi, 8
	vmovsd	QWORD PTR [rbx-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r11-8]
	vmovsd	QWORD PTR [r11-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r9-8]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r8-8]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [rdi-8]
	vmovsd	QWORD PTR [rdi-8], xmm1
	vmovsd	xmm1, QWORD PTR [r9-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmovsd	xmm1, QWORD PTR [r8-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmovsd	xmm1, QWORD PTR [rdi-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [rdi-8], xmm1
	vmovsd	xmm1, QWORD PTR [r10-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	mov	rax, QWORD PTR [rbp-328]
	vmovsd	QWORD PTR [r10-8], xmm1
	vmovsd	xmm1, QWORD PTR [rbx-8]
	vaddsd	xmm1, xmm1, QWORD PTR [r14+rdx]
	vmovsd	QWORD PTR [rbx-8], xmm1
	vmovsd	xmm1, QWORD PTR [r11-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	vmovsd	QWORD PTR [r11-8], xmm1
	vmovsd	xmm1, QWORD PTR [r9-8]
	mov	rax, QWORD PTR [rbp-312]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	mov	rax, QWORD PTR [rbp-336]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmovsd	xmm1, QWORD PTR [r8-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmovsd	xmm1, QWORD PTR [rdi-8]
	vaddsd	xmm1, xmm1, QWORD PTR [r12+rdx]
	add	rdx, 8
	vmovsd	QWORD PTR [rdi-8], xmm1
	cmp	r10, QWORD PTR [rbp-344]
	jne	.L569
	mov	r14, QWORD PTR [rbp-392]
.L568:
	inc	QWORD PTR [rbp-360]
	mov	rbx, QWORD PTR [rbp-456]
	add	r15, QWORD PTR [rbp-464]
	add	QWORD PTR [rbp-320], rbx
	mov	rax, QWORD PTR [rbp-360]
	add	QWORD PTR [rbp-352], 24
	add	QWORD PTR [rbp-384], 24
	cmp	QWORD PTR [rbp-376], rax
	jne	.L566
.L633:
	vmovsd	xmm0, QWORD PTR [rbp-448]
.L564:
	cmp	QWORD PTR [rbp-368], 0
	je	.L571
	mov	rax, QWORD PTR [rbp-152]
	mov	r10, QWORD PTR [r14+24]
	mov	QWORD PTR [rbp-328], rax
	mov	rax, QWORD PTR [rbp-144]
	mov	r13, QWORD PTR [r14+16]
	mov	QWORD PTR [rbp-336], rax
	mov	rax, QWORD PTR [rbp-368]
	mov	rbx, QWORD PTR [r14+32]
	lea	rax, [r10+rax*8]
	mov	QWORD PTR [rbp-320], rax
	mov	r11, QWORD PTR [r14+40]
	mov	r9, QWORD PTR [r14+48]
	mov	r8, QWORD PTR [r14+56]
	mov	rdi, QWORD PTR [r14+64]
	mov	QWORD PTR [rbp-344], r14
	mov	r12, QWORD PTR [rbp-184]
	mov	r15, QWORD PTR [rbp-176]
	mov	r14, QWORD PTR [rbp-496]
	xor	edx, edx
	.p2align 4,,10
	.p2align 3
.L572:
	cmp	QWORD PTR [rbp-376], 0
	mov	rsi, QWORD PTR [rbp-288]
	mov	rcx, QWORD PTR [rbp-296]
	mov	rax, QWORD PTR [rbp-432]
	je	.L573
	mov	QWORD PTR [rbp-280], r12
	.p2align 4,,10
	.p2align 3
.L574:
	mov	r12, QWORD PTR [rsi]
	vmovsd	xmm17, QWORD PTR [r10]
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	mov	r12, QWORD PTR [rsi+8]
	vfmadd132sd	xmm1, xmm17, QWORD PTR [rax]
	add	rax, 8
	add	rsi, 24
	add	rcx, 24
	vmovsd	QWORD PTR [r10], xmm1
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	vmovsd	xmm18, QWORD PTR [rbx]
	mov	r12, QWORD PTR [rsi-8]
	vfmadd132sd	xmm1, xmm18, QWORD PTR [rax-8]
	vmovsd	QWORD PTR [rbx], xmm1
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	vmovsd	xmm19, QWORD PTR [r11]
	mov	r12, QWORD PTR [rcx-24]
	vfmadd132sd	xmm1, xmm19, QWORD PTR [rax-8]
	vmovsd	QWORD PTR [r11], xmm1
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	vmovsd	xmm20, QWORD PTR [r9]
	mov	r12, QWORD PTR [rcx-16]
	vfmadd132sd	xmm1, xmm20, QWORD PTR [rax-8]
	vmovsd	QWORD PTR [r9], xmm1
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	vmovsd	xmm21, QWORD PTR [r8]
	mov	r12, QWORD PTR [rcx-8]
	vfmadd132sd	xmm1, xmm21, QWORD PTR [rax-8]
	vmovsd	QWORD PTR [r8], xmm1
	vmovsd	xmm1, QWORD PTR [r12+rdx]
	vmovsd	xmm22, QWORD PTR [rdi]
	vfmadd132sd	xmm1, xmm22, QWORD PTR [rax-8]
	vmovsd	QWORD PTR [rdi], xmm1
	cmp	rax, r14
	jne	.L574
	mov	r12, QWORD PTR [rbp-280]
.L573:
	vmulsd	xmm1, xmm0, QWORD PTR [r10]
	mov	rax, QWORD PTR [rbp-304]
	add	r10, 8
	add	rbx, 8
	add	r11, 8
	vmovsd	QWORD PTR [r10-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [rbx-8]
	add	r9, 8
	add	r8, 8
	add	rdi, 8
	vmovsd	QWORD PTR [rbx-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r11-8]
	vmovsd	QWORD PTR [r11-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r9-8]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [r8-8]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmulsd	xmm1, xmm0, QWORD PTR [rdi-8]
	vmovsd	QWORD PTR [rdi-8], xmm1
	vmovsd	xmm1, QWORD PTR [r9-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmovsd	xmm1, QWORD PTR [r8-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmovsd	xmm1, QWORD PTR [rdi-8]
	vdivsd	xmm1, xmm1, QWORD PTR [r13+0+rdx]
	vmovsd	QWORD PTR [rdi-8], xmm1
	vmovsd	xmm1, QWORD PTR [r10-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	vmovsd	QWORD PTR [r10-8], xmm1
	vmovsd	xmm1, QWORD PTR [rbx-8]
	vaddsd	xmm1, xmm1, QWORD PTR [r12+rdx]
	vmovsd	QWORD PTR [rbx-8], xmm1
	vmovsd	xmm1, QWORD PTR [r11-8]
	vaddsd	xmm1, xmm1, QWORD PTR [r15+rdx]
	vmovsd	QWORD PTR [r11-8], xmm1
	vmovsd	xmm1, QWORD PTR [r9-8]
	mov	rax, QWORD PTR [rbp-312]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	mov	rax, QWORD PTR [rbp-328]
	vmovsd	QWORD PTR [r9-8], xmm1
	vmovsd	xmm1, QWORD PTR [r8-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	mov	rax, QWORD PTR [rbp-336]
	vmovsd	QWORD PTR [r8-8], xmm1
	vmovsd	xmm1, QWORD PTR [rdi-8]
	vaddsd	xmm1, xmm1, QWORD PTR [rax+rdx]
	add	rdx, 8
	vmovsd	QWORD PTR [rdi-8], xmm1
	cmp	QWORD PTR [rbp-320], r10
	jne	.L572
	mov	r14, QWORD PTR [rbp-344]
.L571:
	inc	QWORD PTR [rbp-472]
	mov	rax, QWORD PTR [rbp-472]
	cmp	QWORD PTR [rbp-480], rax
	jne	.L553
.L552:
	mov	rax, QWORD PTR [rbp-408]
	mov	r12, QWORD PTR [rbp-488]
	mov	r14, rax
	add	r12, rax
	cmp	QWORD PTR [rbp-400], 0
	mov	rbx, QWORD PTR [rbp-416]
	je	.L576
.L577:
	xor	r13d, r13d
.L575:
	mov	rax, QWORD PTR [r14]
	mov	rdi, QWORD PTR [rax+r13]
	call	free
	mov	rax, QWORD PTR [rbx]
	mov	rdi, QWORD PTR [rax+r13]
	add	r13, 8
	call	free
	cmp	r13, 24
	jne	.L575
	mov	rdi, QWORD PTR [r14]
	add	r14, 8
	call	free
	mov	rdi, QWORD PTR [rbx]
	add	rbx, 8
	call	free
	cmp	r12, r14
	jne	.L577
.L576:
	xor	ebx, ebx
.L548:
	mov	rdi, QWORD PTR [rbp-224+rbx*8]
	call	free
	mov	rdi, QWORD PTR [rbp-256+rbx*8]
	inc	rbx
	call	free
	cmp	rbx, 3
	jne	.L548
	mov	rdi, QWORD PTR [rbp-408]
	xor	r14d, r14d
	call	free
	mov	rdi, QWORD PTR [rbp-416]
	call	free
	cmp	QWORD PTR [rbp-376], 0
	mov	r13, QWORD PTR [rbp-296]
	mov	r12, QWORD PTR [rbp-288]
	je	.L583
.L584:
	xor	ebx, ebx
.L582:
	mov	rdi, QWORD PTR [r12+rbx*8]
	test	rdi, rdi
	je	.L580
	call	_ZdaPv
.L580:
	mov	rdi, QWORD PTR [r13+0+rbx*8]
	test	rdi, rdi
	je	.L581
	call	_ZdaPv
.L581:
	inc	rbx
	cmp	rbx, 3
	jne	.L582
	inc	r14
	add	r13, 24
	add	r12, 24
	cmp	QWORD PTR [rbp-376], r14
	jne	.L584
.L583:
	xor	ebx, ebx
.L579:
	mov	rdi, QWORD PTR [rbp-192+rbx*8]
	test	rdi, rdi
	je	.L585
	call	_ZdaPv
.L585:
	mov	rdi, QWORD PTR [rbp-160+rbx*8]
	test	rdi, rdi
	je	.L586
	call	_ZdaPv
.L586:
	inc	rbx
	cmp	rbx, 3
	jne	.L579
	lea	rsp, [rbp-48]
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
.L638:
	.cfi_restore_state
	vzeroupper
	jmp	.L562
.L588:
	xor	eax, eax
	.p2align 4,,10
	.p2align 3
.L559:
	vmovsd	xmm1, QWORD PTR [rbx+rax*8]
	vaddsd	xmm1, xmm1, QWORD PTR [rdx+rax*8]
	vmovsd	QWORD PTR [rbx+rax*8], xmm1
	inc	rax
	cmp	r14, rax
	jne	.L559
	jmp	.L562
.L556:
	mov	QWORD PTR [rbp-88], rax
	mov	rax, QWORD PTR [rbp-416]
	mov	rbx, QWORD PTR [rbp-400]
	mov	QWORD PTR [rbp-96], rax
	mov	rax, QWORD PTR [rbp-408]
	xor	ecx, ecx
	mov	QWORD PTR [rbp-104], rax
	lea	rax, [rbp-224]
	mov	QWORD PTR [rbp-112], rax
	xor	edx, edx
	lea	rax, [rbp-256]
	lea	rsi, [rbp-128]
	mov	edi, OFFSET FLAT:_Z19compute_forces_avx2R12NBody_systemPPdS2_PS2_S3_mmmmm._omp_fn.0
	mov	QWORD PTR [rbp-56], rbx
	mov	QWORD PTR [rbp-64], 0
	mov	QWORD PTR [rbp-72], 1
	mov	QWORD PTR [rbp-80], 0
	mov	QWORD PTR [rbp-120], rax
	mov	QWORD PTR [rbp-128], r14
	call	GOMP_parallel
	jmp	.L557
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.type	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb.cold.13, @function
_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb.cold.13:
.LFSB7820:
.L539:
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	.cfi_escape 0x10,0x6,0x2,0x76,0
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	call	__cxa_throw_bad_array_new_length
	.cfi_endproc
.LFE7820:
	.text
	.size	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb, .-_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb
	.section	.text.unlikely
	.size	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb.cold.13, .-_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb.cold.13
.LCOLDE9:
	.text
.LHOTE9:
	.section	.rodata.str1.1
.LC13:
	.string	"N = %zu, s = %zu\n"
	.section	.rodata.str1.8
	.align 8
.LC14:
	.string	"Reduced Euler blocked solver took %fs\n"
	.section	.rodata.str1.1
.LC15:
	.string	"Performance: %fMPairs/s\n\n"
.LC16:
	.string	"position"
.LC17:
	.string	"velocity"
	.section	.rodata.str1.8
	.align 8
.LC32:
	.string	"Order %zu not supported! Defaulting to 2nd order\n"
	.section	.rodata.str1.1
.LC34:
	.string	"c[%zu] = %f\n"
.LC35:
	.string	"sum(c) = %f\n"
.LC36:
	.string	"d[%zu] = %f\n"
.LC37:
	.string	"sum(d) = %f\n"
	.section	.rodata.str1.8
	.align 8
.LC38:
	.string	"Reduced Symplectic Solver took %fs\n"
	.section	.rodata.str1.1
.LC39:
	.string	"Performance: %fMPairs/s\n"
	.section	.rodata.str1.8
	.align 8
.LC40:
	.string	"Runge Kutta solver is not parallelized!"
	.align 8
.LC43:
	.string	"Order %zu not supported! Defaulting to 4th order\n"
	.align 8
.LC45:
	.string	"Reduced Runge-Kutta Solver took %fs\n"
	.section	.text.unlikely
.LCOLDB46:
	.text
.LHOTB46:
	.p2align 4,,15
	.globl	_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb
	.type	_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb, @function
_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb:
.LFB7821:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7821
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r15
	.cfi_offset 15, -24
	mov	r15d, edx
	push	r14
	.cfi_offset 14, -32
	mov	r14d, r9d
	push	r13
	.cfi_offset 13, -40
	mov	r13, rsi
	push	r12
	.cfi_offset 12, -48
	mov	r12, rdi
	push	rbx
	.cfi_offset 3, -56
	vmovq	rbx, xmm1
	sub	rsp, 1432
	mov	eax, DWORD PTR [rbp+16]
	mov	QWORD PTR [rbp-1416], rcx
	mov	DWORD PTR [rbp-1424], r8d
	mov	DWORD PTR [rbp-1444], eax
	test	rsi, rsi
	js	.L641
	vxorpd	xmm17, xmm17, xmm17
	vcvtsi2sdq	xmm17, xmm17, rsi
	vmovsd	QWORD PTR [rbp-1432], xmm17
.L642:
	lea	rdi, [rbp-1264]
	vdivsd	xmm7, xmm0, QWORD PTR [rbp-1432]
	vmovsd	QWORD PTR [rbp-1456], xmm7
.LEHB0:
	call	_ZN12NBody_systemC1Ev
.LEHE0:
	lea	rdi, [rbp-656]
.LEHB1:
	call	_ZN12NBody_systemC1Ev
.LEHE1:
	mov	rax, QWORD PTR .LC11[rip]
	vmovsd	xmm1, QWORD PTR .LC12[rip]
	vmovq	xmm2, rbx
	vmovq	xmm0, rax
	mov	rsi, r12
	lea	rdi, [rbp-1264]
.LEHB2:
	call	_ZN12NBody_system30init_stable_orbiting_particlesEmddd
	lea	rsi, [rbp-1264]
	lea	rdi, [rbp-656]
	call	_ZN12NBody_systemaSERKS_
	mov	rdx, r13
	mov	rsi, r12
	mov	edi, OFFSET FLAT:.LC13
	xor	eax, eax
	call	printf
	test	r15d, r15d
	jne	.L643
	cmp	r14d, 1
	je	.L706
	mov	rax, QWORD PTR .LC11[rip]
	vmovsd	xmm2, QWORD PTR .LC10[rip]
	vmovq	xmm0, rax
	test	r14d, r14d
	je	.L707
.L645:
	lea	rax, [r12-1]
	imul	rax, r12
	test	rax, rax
	js	.L646
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
.L647:
	vmulsd	xmm1, xmm1, QWORD PTR [rbp-1432]
	mov	edi, OFFSET FLAT:.LC14
	mov	eax, 1
	vdivsd	xmm19, xmm1, xmm2
	vmovsd	QWORD PTR [rbp-1416], xmm19
	call	printf
	vmovsd	xmm0, QWORD PTR [rbp-1416]
	mov	edi, OFFSET FLAT:.LC15
	mov	eax, 1
	call	printf
.L705:
	mov	eax, DWORD PTR [rbp-1444]
	lea	rcx, [rbp-656]
	lea	rsi, [rcx+24]
	lea	rcx, [rbp-1264]
	lea	rdi, [rcx+24]
	movzx	r8d, al
	mov	rcx, r12
	mov	edx, OFFSET FLAT:.LC16
	movzx	ebx, al
	call	_Z15print_deviationPPdS0_PKcmb
	lea	rax, [rbp-656]
	lea	rsi, [rax+48]
	lea	rax, [rbp-1264]
	lea	rdi, [rax+48]
	mov	r8d, ebx
	mov	rcx, r12
	mov	edx, OFFSET FLAT:.LC17
	call	_Z15print_deviationPPdS0_PKcmb
.L648:
	lea	rdi, [rbp-656]
	call	_ZN12NBody_systemD1Ev
	lea	rdi, [rbp-1264]
	call	_ZN12NBody_systemD1Ev
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
.L643:
	.cfi_restore_state
	cmp	r15d, 1
	je	.L708
	cmp	r15d, 2
	jne	.L648
	mov	edi, OFFSET FLAT:.LC40
	call	puts
	vmovsd	xmm0, QWORD PTR .LC33[rip]
	mov	rax, QWORD PTR .LC11[rip]
	vmovsd	xmm1, QWORD PTR .LC42[rip]
	vmovsd	QWORD PTR [rbp-1344], xmm0
	vmovsd	QWORD PTR [rbp-1312], xmm0
	mov	QWORD PTR [rbp-1280], rax
	vmovsd	xmm0, QWORD PTR .LC41[rip]
	mov	rax, QWORD PTR [rbp-1416]
	mov	QWORD PTR [rbp-1336], 0x000000000
	mov	QWORD PTR [rbp-1328], 0x000000000
	mov	QWORD PTR [rbp-1320], 0x000000000
	mov	QWORD PTR [rbp-1304], 0x000000000
	mov	QWORD PTR [rbp-1296], 0x000000000
	mov	QWORD PTR [rbp-1288], 0x000000000
	vmovsd	QWORD PTR [rbp-1376], xmm0
	vmovsd	QWORD PTR [rbp-1368], xmm1
	vmovsd	QWORD PTR [rbp-1360], xmm1
	vmovsd	QWORD PTR [rbp-1352], xmm0
	cmp	rax, 4
	je	.L659
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC43
	xor	eax, eax
	call	printf
.L659:
	call	omp_get_wtime
	vmovsd	QWORD PTR [rbp-1416], xmm0
	vmovsd	xmm0, QWORD PTR [rbp-1456]
	mov	r9d, 1
	mov	r8d, 4
	lea	rcx, [rbp-1376]
	lea	rdx, [rbp-1344]
	mov	rsi, r13
	lea	rdi, [rbp-1264]
	call	_Z21reduced_solver_omp_rkR12NBody_systemmdPdS1_mb
	call	omp_get_wtime
	lea	rax, [r12-1]
	imul	rax, r12
	vsubsd	xmm0, xmm0, QWORD PTR [rbp-1416]
	test	rax, rax
	js	.L660
	vxorpd	xmm2, xmm2, xmm2
	vcvtsi2sdq	xmm2, xmm2, rax
.L661:
	vmovsd	xmm27, QWORD PTR [rbp-1432]
	mov	edi, OFFSET FLAT:.LC45
	vmulsd	xmm1, xmm27, QWORD PTR .LC44[rip]
	mov	eax, 1
	vmulsd	xmm1, xmm2, xmm1
	vmulsd	xmm2, xmm0, QWORD PTR .LC10[rip]
	vdivsd	xmm28, xmm1, xmm2
	vmovsd	QWORD PTR [rbp-1416], xmm28
	call	printf
	vmovsd	xmm0, QWORD PTR [rbp-1416]
	mov	edi, OFFSET FLAT:.LC39
	mov	eax, 1
	call	printf
.LEHE2:
	jmp	.L705
	.p2align 4,,10
	.p2align 3
.L641:
	mov	rax, rsi
	mov	rdx, rsi
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vaddsd	xmm20, xmm1, xmm1
	vmovsd	QWORD PTR [rbp-1432], xmm20
	jmp	.L642
	.p2align 4,,10
	.p2align 3
.L646:
	mov	rdx, rax
	shr	rdx
	and	eax, 1
	or	rdx, rax
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	vaddsd	xmm1, xmm1, xmm1
	jmp	.L647
	.p2align 4,,10
	.p2align 3
.L708:
	mov	rax, QWORD PTR .LC11[rip]
	cmp	QWORD PTR [rbp-1416], 4
	mov	QWORD PTR [rbp-1400], rax
	mov	rax, QWORD PTR .LC18[rip]
	mov	QWORD PTR [rbp-1392], rax
	mov	rax, QWORD PTR .LC19[rip]
	mov	QWORD PTR [rbp-1384], rax
	mov	rax, QWORD PTR .LC20[rip]
	mov	QWORD PTR [rbp-1368], rax
	mov	rax, QWORD PTR .LC21[rip]
	mov	QWORD PTR [rbp-1360], rax
	mov	rax, QWORD PTR .LC22[rip]
	mov	QWORD PTR [rbp-1352], rax
	mov	rax, QWORD PTR .LC23[rip]
	mov	QWORD PTR [rbp-1376], rax
	mov	rax, QWORD PTR .LC24[rip]
	mov	QWORD PTR [rbp-1336], rax
	mov	rax, QWORD PTR .LC25[rip]
	mov	QWORD PTR [rbp-1328], rax
	mov	rax, QWORD PTR .LC26[rip]
	mov	QWORD PTR [rbp-1320], rax
	mov	rax, QWORD PTR .LC27[rip]
	mov	QWORD PTR [rbp-1312], rax
	mov	rax, QWORD PTR .LC28[rip]
	mov	QWORD PTR [rbp-1304], rax
	mov	rax, QWORD PTR .LC29[rip]
	mov	QWORD PTR [rbp-1296], rax
	mov	rax, QWORD PTR .LC30[rip]
	mov	QWORD PTR [rbp-1288], rax
	mov	rax, QWORD PTR .LC31[rip]
	mov	QWORD PTR [rbp-1344], rax
	je	.L666
	jbe	.L709
	mov	rax, QWORD PTR [rbp-1416]
	cmp	rax, 6
	je	.L668
	cmp	rax, 8
	jne	.L652
	mov	QWORD PTR [rbp-1440], 15
	mov	QWORD PTR [rbp-1416], 16
	lea	rax, [rbp-1344]
	mov	edx, 8
	mov	ecx, 14
	mov	esi, 120
	mov	edi, 128
	lea	r8, [rax+56]
.L650:
	vmovsd	xmm0, QWORD PTR .LC33[rip]
	add	rsi, 15
	vmulsd	xmm1, xmm0, QWORD PTR [r8]
	mov	ebx, 3
	and	esi, 240
	mov	QWORD PTR [rbp-1464], rsp
	sub	rsp, rdi
	shrx	rdi, rsp, rbx
	sub	rsp, rsi
	shrx	rsi, rsp, rbx
	mov	rbx, QWORD PTR [rbp-1440]
	lea	r14, [0+rdi*8]
	vmovsd	QWORD PTR [r14+rbx*8], xmm1
	vmovsd	QWORD PTR [0+rdi*8], xmm1
	vmovsd	xmm1, QWORD PTR [rax-8+rdx*8]
	lea	r15, [0+rsi*8]
	vmovsd	QWORD PTR [r15+rcx*8], xmm1
	vmovsd	QWORD PTR [0+rsi*8], xmm1
	cmp	rdx, 1
	je	.L653
	lea	r8, [rdx-1]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-8+rcx*8], xmm2
	vmovsd	QWORD PTR [8+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-8+rbx*8], xmm1
	vmovsd	QWORD PTR [8+rdi*8], xmm1
	cmp	rdx, 2
	je	.L653
	lea	r8, [rdx-2]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-16+rcx*8], xmm2
	vmovsd	QWORD PTR [16+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-16+rbx*8], xmm1
	vmovsd	QWORD PTR [16+rdi*8], xmm1
	cmp	rdx, 3
	je	.L653
	lea	r8, [rdx-3]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-24+rcx*8], xmm2
	vmovsd	QWORD PTR [24+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-24+rbx*8], xmm1
	vmovsd	QWORD PTR [24+rdi*8], xmm1
	cmp	rdx, 4
	je	.L653
	lea	r8, [rdx-4]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-32+rcx*8], xmm2
	vmovsd	QWORD PTR [32+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-32+rbx*8], xmm1
	vmovsd	QWORD PTR [32+rdi*8], xmm1
	cmp	rdx, 5
	je	.L653
	lea	r8, [rdx-5]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-40+rcx*8], xmm2
	vmovsd	QWORD PTR [40+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-40+rbx*8], xmm1
	vmovsd	QWORD PTR [40+rdi*8], xmm1
	cmp	rdx, 6
	je	.L653
	lea	r8, [rdx-6]
	vmovsd	xmm2, QWORD PTR [rax-8+r8*8]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+r8*8]
	vmovsd	QWORD PTR [r15-48+rcx*8], xmm2
	vmovsd	QWORD PTR [48+rsi*8], xmm2
	vmulsd	xmm1, xmm1, xmm0
	vmovsd	QWORD PTR [r14-48+rbx*8], xmm1
	vmovsd	QWORD PTR [48+rdi*8], xmm1
	cmp	rdx, 7
	je	.L653
	vmovsd	xmm2, QWORD PTR [rax]
	vaddsd	xmm1, xmm2, QWORD PTR [rax+8]
	vmovsd	QWORD PTR [r15-56+rcx*8], xmm2
	vmovsd	QWORD PTR [56+rsi*8], xmm2
	vmulsd	xmm0, xmm1, xmm0
	vmovsd	QWORD PTR [r14-56+rbx*8], xmm0
	vmovsd	QWORD PTR [56+rdi*8], xmm0
.L653:
	mov	QWORD PTR [rbp-1424], 0x000000000
	xor	ebx, ebx
	.p2align 4,,10
	.p2align 3
.L654:
	vmovsd	xmm0, QWORD PTR [r14+rbx*8]
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:.LC34
	mov	eax, 1
.LEHB3:
	call	printf
	vmovsd	xmm4, QWORD PTR [rbp-1424]
	vaddsd	xmm3, xmm4, QWORD PTR [r14+rbx*8]
	inc	rbx
	vmovsd	QWORD PTR [rbp-1424], xmm3
	cmp	rbx, QWORD PTR [rbp-1416]
	jne	.L654
	vmovapd	xmm0, xmm3
	mov	edi, OFFSET FLAT:.LC35
	mov	eax, 1
	call	printf
	mov	QWORD PTR [rbp-1424], 0x000000000
	xor	ebx, ebx
	.p2align 4,,10
	.p2align 3
.L655:
	vmovsd	xmm0, QWORD PTR [r15+rbx*8]
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:.LC36
	mov	eax, 1
	call	printf
	vmovsd	xmm6, QWORD PTR [rbp-1424]
	vaddsd	xmm5, xmm6, QWORD PTR [r15+rbx*8]
	inc	rbx
	vmovsd	QWORD PTR [rbp-1424], xmm5
	cmp	rbx, QWORD PTR [rbp-1440]
	jne	.L655
	vmovapd	xmm0, xmm5
	mov	edi, OFFSET FLAT:.LC37
	mov	eax, 1
	call	printf
	call	omp_get_wtime
	vmovsd	QWORD PTR [rbp-1424], xmm0
	mov	r8, QWORD PTR [rbp-1416]
	vmovsd	xmm0, QWORD PTR [rbp-1456]
	mov	r9d, 1
	mov	rcx, r15
	mov	rdx, r14
	mov	rsi, r13
	lea	rdi, [rbp-1264]
	call	_Z21reduced_solver_omp_lfR12NBody_systemmdPdS1_mb
	call	omp_get_wtime
	lea	rax, [r12-1]
	imul	rax, r12
	vsubsd	xmm0, xmm0, QWORD PTR [rbp-1424]
	test	rax, rax
	js	.L656
	vxorpd	xmm2, xmm2, xmm2
	vcvtsi2sdq	xmm2, xmm2, rax
.L657:
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, QWORD PTR [rbp-1440]
	mov	edi, OFFSET FLAT:.LC38
	mov	eax, 1
	vmulsd	xmm1, xmm1, QWORD PTR [rbp-1432]
	vmulsd	xmm1, xmm2, xmm1
	vmulsd	xmm2, xmm0, QWORD PTR .LC10[rip]
	vdivsd	xmm23, xmm1, xmm2
	vmovsd	QWORD PTR [rbp-1416], xmm23
	call	printf
	vmovsd	xmm0, QWORD PTR [rbp-1416]
	mov	edi, OFFSET FLAT:.LC39
	mov	eax, 1
	call	printf
	mov	eax, DWORD PTR [rbp-1444]
	lea	rcx, [rbp-656]
	lea	rsi, [rcx+24]
	lea	rcx, [rbp-1264]
	lea	rdi, [rcx+24]
	movzx	r8d, al
	mov	rcx, r12
	mov	edx, OFFSET FLAT:.LC16
	movzx	ebx, al
	call	_Z15print_deviationPPdS0_PKcmb
	lea	rax, [rbp-656]
	lea	rsi, [rax+48]
	lea	rax, [rbp-1264]
	lea	rdi, [rax+48]
	mov	r8d, ebx
	mov	rcx, r12
	mov	edx, OFFSET FLAT:.LC17
	call	_Z15print_deviationPPdS0_PKcmb
.LEHE3:
	mov	rsp, QWORD PTR [rbp-1464]
	jmp	.L648
	.p2align 4,,10
	.p2align 3
.L706:
	call	omp_get_wtime
	vmovsd	QWORD PTR [rbp-1416], xmm0
	mov	ecx, DWORD PTR [rbp-1424]
	vmovsd	xmm0, QWORD PTR [rbp-1456]
	mov	edx, 1
	mov	rsi, r13
	lea	rdi, [rbp-1264]
.LEHB4:
	call	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
.L701:
	call	omp_get_wtime
	vsubsd	xmm0, xmm0, QWORD PTR [rbp-1416]
	vmulsd	xmm2, xmm0, QWORD PTR .LC10[rip]
	jmp	.L645
	.p2align 4,,10
	.p2align 3
.L709:
	cmp	QWORD PTR [rbp-1416], 2
	jne	.L652
	lea	r8, [rbp-1400]
	xor	ecx, ecx
	mov	esi, 8
	mov	edi, 16
	mov	QWORD PTR [rbp-1440], 1
	mov	edx, 1
	mov	rax, r8
	jmp	.L650
	.p2align 4,,10
	.p2align 3
.L707:
	call	omp_get_wtime
	vmovsd	QWORD PTR [rbp-1416], xmm0
	mov	edx, DWORD PTR [rbp-1424]
	vmovsd	xmm0, QWORD PTR [rbp-1456]
	mov	rsi, r13
	lea	rdi, [rbp-1264]
	call	_Z15full_solver_ompR12NBody_systemmd18Vectorization_type
	jmp	.L701
	.p2align 4,,10
	.p2align 3
.L656:
	mov	rdx, rax
	shr	rdx
	and	eax, 1
	or	rdx, rax
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	vaddsd	xmm2, xmm1, xmm1
	jmp	.L657
	.p2align 4,,10
	.p2align 3
.L668:
	lea	rax, [rbp-1376]
	mov	ecx, 6
	mov	esi, 56
	mov	edi, 64
	lea	r8, [rax+24]
	mov	QWORD PTR [rbp-1440], 7
	mov	QWORD PTR [rbp-1416], 8
	mov	edx, 4
	jmp	.L650
	.p2align 4,,10
	.p2align 3
.L660:
	mov	rdx, rax
	shr	rdx
	and	eax, 1
	or	rdx, rax
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rdx
	vaddsd	xmm2, xmm1, xmm1
	jmp	.L661
	.p2align 4,,10
	.p2align 3
.L666:
	lea	rax, [rbp-1392]
	mov	ecx, 2
	mov	esi, 24
	mov	edi, 32
	lea	r8, [rax+8]
	mov	QWORD PTR [rbp-1440], 3
	mov	edx, 2
	jmp	.L650
	.p2align 4,,10
	.p2align 3
.L652:
	mov	rsi, QWORD PTR [rbp-1416]
	mov	edi, OFFSET FLAT:.LC32
	xor	eax, eax
	call	printf
.LEHE4:
	lea	r8, [rbp-1400]
	xor	ecx, ecx
	mov	esi, 8
	mov	edi, 16
	mov	QWORD PTR [rbp-1440], 1
	mov	QWORD PTR [rbp-1416], 2
	mov	edx, 1
	mov	rax, r8
	jmp	.L650
.L671:
	mov	rbx, rax
	jmp	.L663
.L672:
	jmp	.L662
.L670:
	mov	rbx, rax
	vzeroupper
	jmp	.L664
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA7821:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7821-.LLSDACSB7821
.LLSDACSB7821:
	.uleb128 .LEHB0-.LFB7821
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB7821
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L670-.LFB7821
	.uleb128 0
	.uleb128 .LEHB2-.LFB7821
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L671-.LFB7821
	.uleb128 0
	.uleb128 .LEHB3-.LFB7821
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L672-.LFB7821
	.uleb128 0
	.uleb128 .LEHB4-.LFB7821
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L671-.LFB7821
	.uleb128 0
.LLSDACSE7821:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC7821
	.type	_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb.cold.14, @function
_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb.cold.14:
.LFSB7821:
.L662:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	mov	rsp, QWORD PTR [rbp-1464]
	mov	rbx, rax
.L663:
	lea	rdi, [rbp-656]
	vzeroupper
	call	_ZN12NBody_systemD1Ev
.L664:
	lea	rdi, [rbp-1264]
	call	_ZN12NBody_systemD1Ev
	mov	rdi, rbx
.LEHB5:
	call	_Unwind_Resume
.LEHE5:
	.cfi_endproc
.LFE7821:
	.section	.gcc_except_table
.LLSDAC7821:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC7821-.LLSDACSBC7821
.LLSDACSBC7821:
	.uleb128 .LEHB5-.LCOLDB46
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
.LLSDACSEC7821:
	.section	.text.unlikely
	.text
	.size	_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb, .-_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb
	.section	.text.unlikely
	.size	_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb.cold.14, .-_Z8omp_mainmmdd16Integration_kindm18Vectorization_type11Solver_typeb.cold.14
.LCOLDE46:
	.text
.LHOTE46:
	.section	.rodata.str1.1
.LC47:
	.string	"w"
	.section	.rodata.str1.8
	.align 8
.LC48:
	.string	"N, t_blocked[s], p_blocked[Mpairs/s], t_default[s], p_default[Mpairs/s]\n"
	.section	.rodata.str1.1
.LC49:
	.string	"\nStarting iteration; N: %zu\n"
	.section	.rodata.str1.8
	.align 8
.LC50:
	.string	"Blocked Performance: %fMPairs/s\n\n"
	.align 8
.LC51:
	.string	"Default Performance: %fMPairs/s\n\n"
	.section	.rodata.str1.1
.LC52:
	.string	"%zu,%f,%f,%f,%f\n"
	.section	.text.unlikely
.LCOLDB53:
	.text
.LHOTB53:
	.p2align 4,,15
	.globl	_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb
	.type	_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb, @function
_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb:
.LFB7822:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7822
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	vmovq	r15, xmm1
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
	mov	r12, rcx
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	rbx, rdi
	sub	rsp, 1288
	.cfi_def_cfa_offset 1344
	mov	QWORD PTR [rsp+56], rsi
	test	rcx, rcx
	js	.L711
	vxorpd	xmm25, xmm25, xmm25
	vcvtsi2sdq	xmm25, xmm25, rcx
	vmovsd	QWORD PTR [rsp+48], xmm25
.L712:
	mov	rdi, QWORD PTR [r8]
	mov	esi, OFFSET FLAT:.LC47
	vdivsd	xmm23, xmm0, QWORD PTR [rsp+48]
	vmovsd	QWORD PTR [rsp+16], xmm23
.LEHB6:
	call	fopen
	mov	rcx, rax
	mov	edx, 72
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC48
	mov	r13, rax
	call	fwrite
.LEHE6:
	test	r14, r14
	je	.L713
	xor	ebp, ebp
	jmp	.L716
	.p2align 4,,10
	.p2align 3
.L727:
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
.L715:
	vmovsd	xmm20, QWORD PTR .LC10[rip]
	vmulsd	xmm4, xmm0, QWORD PTR [rsp+48]
	vmulsd	xmm0, xmm20, QWORD PTR [rsp+8]
	mov	edi, OFFSET FLAT:.LC50
	mov	eax, 1
	vmovsd	QWORD PTR [rsp+24], xmm4
	vdivsd	xmm6, xmm4, xmm0
	vmovapd	xmm0, xmm6
	vmovsd	QWORD PTR [rsp+32], xmm6
.LEHB7:
	call	printf
	call	omp_get_wtime
	vmovsd	QWORD PTR [rsp+40], xmm0
	vmovsd	xmm0, QWORD PTR [rsp+16]
	xor	ecx, ecx
	xor	edx, edx
	mov	rsi, r12
	lea	rdi, [rsp+672]
	call	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
	call	omp_get_wtime
	vsubsd	xmm7, xmm0, QWORD PTR [rsp+40]
	vmovsd	xmm22, QWORD PTR .LC10[rip]
	vmovsd	xmm4, QWORD PTR [rsp+24]
	vmulsd	xmm0, xmm22, xmm7
	mov	edi, OFFSET FLAT:.LC51
	mov	eax, 1
	vmovsd	QWORD PTR [rsp+40], xmm7
	vdivsd	xmm16, xmm4, xmm0
	vmovapd	xmm0, xmm16
	vmovsd	QWORD PTR [rsp+24], xmm16
	call	printf
	vmovsd	xmm3, QWORD PTR [rsp+24]
	vmovsd	xmm2, QWORD PTR [rsp+40]
	vmovsd	xmm1, QWORD PTR [rsp+32]
	vmovsd	xmm0, QWORD PTR [rsp+8]
	mov	rdx, rbx
	mov	esi, OFFSET FLAT:.LC52
	mov	rdi, r13
	mov	eax, 4
	call	fprintf
.LEHE7:
	lea	rdi, [rsp+672]
	call	_ZN12NBody_systemD1Ev
	inc	rbp
	lea	rdi, [rsp+64]
	call	_ZN12NBody_systemD1Ev
	add	rbx, QWORD PTR [rsp+56]
	cmp	r14, rbp
	je	.L713
.L716:
	lea	rdi, [rsp+64]
.LEHB8:
	call	_ZN12NBody_systemC1Ev
.LEHE8:
	lea	rdi, [rsp+672]
.LEHB9:
	call	_ZN12NBody_systemC1Ev
.LEHE9:
	mov	rax, QWORD PTR .LC12[rip]
	vmovsd	xmm0, QWORD PTR .LC11[rip]
	vmovq	xmm2, r15
	vmovq	xmm1, rax
	mov	rsi, rbx
	lea	rdi, [rsp+64]
.LEHB10:
	call	_ZN12NBody_system30init_stable_orbiting_particlesEmddd
	lea	rsi, [rsp+64]
	lea	rdi, [rsp+672]
	call	_ZN12NBody_systemaSERKS_
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:.LC49
	xor	eax, eax
	call	printf
	call	omp_get_wtime
	vmovsd	QWORD PTR [rsp+8], xmm0
	vmovsd	xmm0, QWORD PTR [rsp+16]
	xor	ecx, ecx
	mov	edx, 1
	mov	rsi, r12
	lea	rdi, [rsp+64]
	call	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
.LEHE10:
	call	omp_get_wtime
	lea	rax, [rbx-1]
	vsubsd	xmm17, xmm0, QWORD PTR [rsp+8]
	imul	rax, rbx
	vmovsd	QWORD PTR [rsp+8], xmm17
	test	rax, rax
	jns	.L727
	mov	rdx, rax
	shr	rdx
	and	eax, 1
	or	rdx, rax
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L715
	.p2align 4,,10
	.p2align 3
.L713:
	mov	rdi, r13
.LEHB11:
	call	fclose
.LEHE11:
	add	rsp, 1288
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
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L711:
	.cfi_restore_state
	mov	rax, rcx
	mov	rdx, rcx
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vaddsd	xmm26, xmm1, xmm1
	vmovsd	QWORD PTR [rsp+48], xmm26
	jmp	.L712
.L720:
	mov	rbx, rax
	jmp	.L717
.L719:
	mov	rbx, rax
	vzeroupper
	jmp	.L718
	.section	.gcc_except_table
.LLSDA7822:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7822-.LLSDACSB7822
.LLSDACSB7822:
	.uleb128 .LEHB6-.LFB7822
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB7822
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L720-.LFB7822
	.uleb128 0
	.uleb128 .LEHB8-.LFB7822
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB9-.LFB7822
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L719-.LFB7822
	.uleb128 0
	.uleb128 .LEHB10-.LFB7822
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L720-.LFB7822
	.uleb128 0
	.uleb128 .LEHB11-.LFB7822
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE7822:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC7822
	.type	_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb.cold.15, @function
_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb.cold.15:
.LFSB7822:
.L717:
	.cfi_def_cfa_offset 1344
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	lea	rdi, [rsp+672]
	vzeroupper
	call	_ZN12NBody_systemD1Ev
.L718:
	lea	rdi, [rsp+64]
	call	_ZN12NBody_systemD1Ev
	mov	rdi, rbx
.LEHB12:
	call	_Unwind_Resume
.LEHE12:
	.cfi_endproc
.LFE7822:
	.section	.gcc_except_table
.LLSDAC7822:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC7822-.LLSDACSBC7822
.LLSDACSBC7822:
	.uleb128 .LEHB12-.LCOLDB53
	.uleb128 .LEHE12-.LEHB12
	.uleb128 0
	.uleb128 0
.LLSDACSEC7822:
	.section	.text.unlikely
	.text
	.size	_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb, .-_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb
	.section	.text.unlikely
	.size	_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb.cold.15, .-_Z19omp_cache_benchmarkmmmmddNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEb.cold.15
.LCOLDE53:
	.text
.LHOTE53:
	.section	.rodata.str1.8
	.align 8
.LC54:
	.string	"#Cores, N, t_total[s], performance[Mpairs/s], speedup\n"
	.align 8
.LC55:
	.string	"Maximum number of Cores available: %zu\n"
	.align 8
.LC56:
	.string	"%zu core performance for N = %zu: %fMPairs/s\n\n"
	.section	.rodata.str1.1
.LC57:
	.string	"%zu,%zu,%f,%f,%f\n"
	.section	.text.unlikely
.LCOLDB58:
	.text
.LHOTB58:
	.p2align 4,,15
	.globl	_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb
	.type	_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb, @function
_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb:
.LFB7823:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA7823
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	r15, rsi
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	mov	r14, rdi
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	mov	r13d, edx
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 696
	.cfi_def_cfa_offset 752
	vmovsd	QWORD PTR [rsp+64], xmm1
	mov	DWORD PTR [rsp+76], r8d
	test	rsi, rsi
	js	.L729
	vxorpd	xmm28, xmm28, xmm28
	vcvtsi2sdq	xmm28, xmm28, rsi
	vmovsd	QWORD PTR [rsp+40], xmm28
.L730:
	mov	rdi, QWORD PTR [rcx]
	mov	esi, OFFSET FLAT:.LC47
	vdivsd	xmm23, xmm0, QWORD PTR [rsp+40]
	vmovsd	QWORD PTR [rsp+48], xmm23
.LEHB13:
	call	fopen
	mov	rcx, rax
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC54
	mov	edx, 54
	mov	QWORD PTR [rsp+32], rax
	call	fwrite
	call	omp_get_max_threads
	cdqe
	mov	rbx, rax
	mov	QWORD PTR [rsp+56], rax
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC55
	xor	eax, eax
	call	printf
.LEHE13:
	test	rbx, rbx
	je	.L731
	vxorpd	xmm27, xmm27, xmm27
	mov	r12, r14
	mov	ebx, 1
	vmovsd	QWORD PTR [rsp+24], xmm27
	jmp	.L739
	.p2align 4,,10
	.p2align 3
.L754:
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
.L734:
	vmovsd	xmm6, QWORD PTR .LC10[rip]
	vmulsd	xmm0, xmm0, QWORD PTR [rsp+40]
	vmulsd	xmm1, xmm6, QWORD PTR [rsp]
	vdivsd	xmm16, xmm0, xmm1
	vmovsd	QWORD PTR [rsp+8], xmm16
	cmp	rbx, 1
	je	.L753
	vmovapd	xmm18, xmm16
	test	r13b, r13b
	jne	.L736
.L737:
	vmovsd	xmm21, QWORD PTR [rsp+24]
	vdivsd	xmm20, xmm21, QWORD PTR [rsp]
	vmovsd	QWORD PTR [rsp+16], xmm20
.L738:
	vmovsd	xmm0, QWORD PTR [rsp+8]
	mov	rdx, rbp
	mov	rsi, rbx
	mov	edi, OFFSET FLAT:.LC56
	mov	eax, 1
.LEHB14:
	call	printf
	vmovsd	xmm2, QWORD PTR [rsp+16]
	vmovsd	xmm1, QWORD PTR [rsp+8]
	vmovsd	xmm0, QWORD PTR [rsp]
	mov	rdi, QWORD PTR [rsp+32]
	mov	rcx, rbp
	mov	rdx, rbx
	mov	esi, OFFSET FLAT:.LC57
	mov	eax, 3
	call	fprintf
.LEHE14:
	lea	rdi, [rsp+80]
	inc	rbx
	call	_ZN12NBody_systemD1Ev
	add	r12, r14
	cmp	QWORD PTR [rsp+56], rbx
	jb	.L731
.L739:
	mov	edi, ebx
	call	omp_set_num_threads
	lea	rdi, [rsp+80]
.LEHB15:
	call	_ZN12NBody_systemC1Ev
.LEHE15:
	mov	rax, QWORD PTR .LC12[rip]
	test	r13b, r13b
	mov	rbp, r14
	cmovne	rbp, r12
	vmovq	xmm1, rax
	mov	rax, QWORD PTR .LC11[rip]
	vmovsd	xmm2, QWORD PTR [rsp+64]
	vmovq	xmm0, rax
	mov	rsi, rbp
	lea	rdi, [rsp+80]
.LEHB16:
	call	_ZN12NBody_system30init_stable_orbiting_particlesEmddd
	call	omp_get_wtime
	vmovsd	QWORD PTR [rsp], xmm0
	mov	ecx, DWORD PTR [rsp+76]
	vmovsd	xmm0, QWORD PTR [rsp+48]
	mov	edx, 1
	mov	rsi, r15
	lea	rdi, [rsp+80]
	call	_Z18reduced_solver_ompR12NBody_systemmdb18Vectorization_type
.LEHE16:
	call	omp_get_wtime
	lea	rax, [rbp-1]
	vsubsd	xmm3, xmm0, QWORD PTR [rsp]
	imul	rax, rbp
	vmovsd	QWORD PTR [rsp], xmm3
	test	rax, rax
	jns	.L754
	mov	rdx, rax
	shr	rdx
	and	eax, 1
	or	rdx, rax
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rdx
	vaddsd	xmm0, xmm0, xmm0
	jmp	.L734
	.p2align 4,,10
	.p2align 3
.L742:
	vmovsd	QWORD PTR [rsp+24], xmm16
	vmovapd	xmm18, xmm16
.L736:
	vdivsd	xmm17, xmm18, QWORD PTR [rsp+24]
	vmovsd	QWORD PTR [rsp+16], xmm17
	jmp	.L738
	.p2align 4,,10
	.p2align 3
.L753:
	test	r13b, r13b
	jne	.L742
	vmovsd	xmm25, QWORD PTR [rsp]
	vmovsd	QWORD PTR [rsp+24], xmm25
	jmp	.L737
	.p2align 4,,10
	.p2align 3
.L731:
	mov	rdi, QWORD PTR [rsp+32]
.LEHB17:
	call	fclose
.LEHE17:
	add	rsp, 696
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
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L729:
	.cfi_restore_state
	mov	rax, rsi
	mov	rdx, rsi
	shr	rax
	and	edx, 1
	or	rax, rdx
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vaddsd	xmm29, xmm1, xmm1
	vmovsd	QWORD PTR [rsp+40], xmm29
	jmp	.L730
.L743:
	mov	rbx, rax
	jmp	.L740
	.section	.gcc_except_table
.LLSDA7823:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7823-.LLSDACSB7823
.LLSDACSB7823:
	.uleb128 .LEHB13-.LFB7823
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB14-.LFB7823
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L743-.LFB7823
	.uleb128 0
	.uleb128 .LEHB15-.LFB7823
	.uleb128 .LEHE15-.LEHB15
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB16-.LFB7823
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L743-.LFB7823
	.uleb128 0
	.uleb128 .LEHB17-.LFB7823
	.uleb128 .LEHE17-.LEHB17
	.uleb128 0
	.uleb128 0
.LLSDACSE7823:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDAC7823
	.type	_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb.cold.16, @function
_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb.cold.16:
.LFSB7823:
.L740:
	.cfi_def_cfa_offset 752
	.cfi_offset 3, -56
	.cfi_offset 6, -48
	.cfi_offset 12, -40
	.cfi_offset 13, -32
	.cfi_offset 14, -24
	.cfi_offset 15, -16
	lea	rdi, [rsp+80]
	vzeroupper
	call	_ZN12NBody_systemD1Ev
	mov	rdi, rbx
.LEHB18:
	call	_Unwind_Resume
.LEHE18:
	.cfi_endproc
.LFE7823:
	.section	.gcc_except_table
.LLSDAC7823:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC7823-.LLSDACSBC7823
.LLSDACSBC7823:
	.uleb128 .LEHB18-.LCOLDB58
	.uleb128 .LEHE18-.LEHB18
	.uleb128 0
	.uleb128 0
.LLSDACSEC7823:
	.section	.text.unlikely
	.text
	.size	_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb, .-_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb
	.section	.text.unlikely
	.size	_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb.cold.16, .-_Z21omp_scaling_benchmarkmmddbNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE18Vectorization_type11Solver_typeb.cold.16
.LCOLDE58:
	.text
.LHOTE58:
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC0:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 16
.LC2:
	.long	0
	.long	1074266112
	.long	0
	.long	0
	.align 16
.LC3:
	.long	0
	.long	1071644672
	.long	0
	.long	0
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC10:
	.long	0
	.long	1093567616
	.align 8
.LC11:
	.long	0
	.long	1072693248
	.align 8
.LC12:
	.long	1413754136
	.long	1075388923
	.align 8
.LC18:
	.long	3715286641
	.long	-1074053866
	.align 8
.LC19:
	.long	1857643321
	.long	1073061515
	.align 8
.LC20:
	.long	4153621395
	.long	-1074604090
	.align 8
.LC21:
	.long	1469617588
	.long	1070475075
	.align 8
.LC22:
	.long	1233687419
	.long	1072241340
	.align 8
.LC23:
	.long	3484925501
	.long	1073023744
	.align 8
.LC24:
	.long	4275932521
	.long	-1074144663
	.align 8
.LC25:
	.long	1929586097
	.long	-1073507472
	.align 8
.LC26:
	.long	3514422470
	.long	-1082302931
	.align 8
.LC27:
	.long	200925561
	.long	1073972525
	.align 8
.LC28:
	.long	1816673235
	.long	1069822162
	.align 8
.LC29:
	.long	2797773797
	.long	1073553296
	.align 8
.LC30:
	.long	447594506
	.long	1072737735
	.align 8
.LC31:
	.long	678410110
	.long	-1073971642
	.align 8
.LC33:
	.long	0
	.long	1071644672
	.align 8
.LC41:
	.long	1431655765
	.long	1069897045
	.align 8
.LC42:
	.long	1431655765
	.long	1070945621
	.align 8
.LC44:
	.long	0
	.long	1074790400
	.ident	"GCC: (GNU) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
