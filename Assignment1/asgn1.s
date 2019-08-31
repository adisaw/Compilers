	.file	"asgn1.c"	#source file name
	
	.section	.rodata #section read only data
	.align 8	#align with 8-byte boundary
.LC0:		# Label of f-string-1st print
	.string	"Enter the dimension of a square matrix: " 
.LC1:		# Label of f-string scanf
	.string	"%d"
	.align 8   #align with 8-byte boundary
.LC2:		# Label of f-string -2nd printf
	.string	"Enter the first matix (row-major): "
	.align 8   #align with 8-byte boundary
.LC3:		# Label of f-string -3rd printf
	.string	"Enter the second matix (row-major): "
.LC4:		# Label of f-string -4th printf
	.string	"\nThe result matrix:"
.LC5:		# Label of f-string -5th printf (printf("%d ", C[i][j]);)
	.string	"%d "  
	.text  #code starts
	.globl	main     # main is a global name
	.type	main, @function # main is a function
main:	#main starts
.LFB0:
	.cfi_startproc  #call frame information
	pushq	%rbp     #save old base pointer
	.cfi_def_cfa_offset 16		#CFA(Canonical Frame Address) is now at an offset of 16 bytes from the current stack pointer.
	.cfi_offset 6, -16      #register 6 is saved at offset -16 from CFA.	
	movq	%rsp, %rbp 	#rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6	 #Change rule for CFA to use register 6 Offset remains the same.	
	subq	$4832, %rsp	#Create space for local variables like arrays A,B,C and variables i,j,n
	movq	%fs:40, %rax	#get the canary value
	movq	%rax, -8(%rbp)		#canary value stored rbp-8<-rax
	xorl	%eax, %eax	#clear eax
	leaq	.LC0(%rip), %rdi  #load address of "Enter the dimension of a square matrix: " into rdi		
	movl	$0, %eax #no vector register so eax stores 0	
	call	printf@PLT  #will print "Enter the dimension of a square matrix: "
	leaq	-4828(%rbp), %rax  #load address of rbp-4828 in rax
	movq	%rax, %rsi  #rsi<-rax
	leaq	.LC1(%rip), %rdi  #load address of string "%d"
	movl	$0, %eax #no vector register so eax stores 0	
	call	__isoc99_scanf@PLT	# call scanf, return value is in eax
	leaq	.LC2(%rip), %rdi   #load address of "Enter the dimension of a square matrix: " into rdi	
	movl	$0, %eax	#no vector register so eax stores 0
	call	printf@PLT	#will print "Enter the first matix (row-major): "
	movl	-4828(%rbp), %eax	#eax will have previously entered 'n' value eax<-rbp-4828
	leaq	-4816(%rbp), %rdx	#loading address of array A to rdx
	movq	%rdx, %rsi	#moving address of array A to rsi second argument of function
	movl	%eax, %edi	#edi<--eax edi stores value 'n' first argument of function
	call	ReadMat		#ReadMat function called
	leaq	.LC3(%rip), %rdi  # load address of string "Enter the second matix (row-major): " into rdi	
	movl	$0, %eax 	#no vector register so eax stores 0
	call	printf@PLT	#will print "Enter the second matix (row-major): "
	movl	-4828(%rbp), %eax	#eax will have previously entered 'n' value eax<-rbp-4828
	leaq	-3216(%rbp), %rdx	#loading address of array B to rdx
	movq	%rdx, %rsi	#rsi<- address of B 2nd parameter
	movl	%eax, %edi	#value of n 1st parameter
	call	ReadMat		#calling ReadMat function
	movl	-4828(%rbp), %eax	#value of n stored in eax
	leaq	-1616(%rbp), %rcx	# load address of array C 4th parameter
	leaq	-3216(%rbp), %rdx	#load address of array B  3rd parameter
	leaq	-4816(%rbp), %rsi	#load address of array A  2nd parameter
	movl	%eax, %edi	#edi store n 1st parameter
	call	MatMult		#calls MatMult function
	leaq	.LC4(%rip), %rdi	#load address of string "\nThe result matrix:"
	call	puts@PLT	#will print "\nThe result matrix:"
	movl	$0, -4824(%rbp)  #rbp-4824=0 | i of main function holds 0
	jmp	.L2  #jump to .L2
.L5:
	movl	$0, -4820(%rbp) #rbp-4820 stores 0 | j=0
	jmp	.L3	#jump to .L3
.L4:
	movl	-4820(%rbp), %eax
	movslq	%eax, %rcx
	movl	-4824(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movl	-1616(%rbp,%rax,4), %eax
	movl	%eax, %esi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -4820(%rbp) 
.L3:
	movl	-4828(%rbp), %eax #eax stores n
	cmpl	%eax, -4820(%rbp)  #j-n ((rbp-4820)-eax)
	jl	.L4  #if (j<n) jump to .L4
	movl	$10, %edi #edi<-10
	call	putchar@PLT
	addl	$1, -4824(%rbp) # increment j by one
.L2:
	movl	-4828(%rbp), %eax #eax stores n  
	cmpl	%eax, -4824(%rbp)  #(rbp-4824) - eax (i-n)
	jl	.L5 #Jump to .L5 (i<n)
	movl	$0, %eax 
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	ReadMat
	.type	ReadMat, @function
ReadMat:
.LFB1:
	.cfi_startproc	#call frame information
	pushq	%rbp	# Save old base pointer
	.cfi_def_cfa_offset 16   #CFA(Canonical Frame Address) is now at an offset of 16 bytes from the current stack
	.cfi_offset 6, -16	 #register 6 is saved at offset -16 from CFA.
	movq	%rsp, %rbp		#rbp <-- rsp set new stack base pointer
	.cfi_def_cfa_register 6		#Change rule for CFA to use register 6 Offset remains the same.
	subq	$32, %rsp		#Create space for local variables like i and j 
	movl	%edi, -20(%rbp)		#rbp-20<--edi value of 'n'
	movq	%rsi, -32(%rbp)		#rbp-32 <-- rsi array A
	movl	$0, -8(%rbp)		#rbp-8<--0 i initialized
	jmp	.L9		#jump to .L9
.L12:
	movl	$0, -4(%rbp) #initializing j
	jmp	.L10 #jump to .L10
.L11:
	movl	-8(%rbp), %eax #eax has value of rbp-8 which is i
	movslq	%eax, %rdx #sign extend %rdx<--%eax holds i
	movq	%rdx, %rax #rax<--rdx stores i
	salq	$2, %rax 	#rax<--4*rax (4*i)	 
	addq	%rdx, %rax	#rax<--rax+rdx (now rax is 5i)
	salq	$4, %rax	#rax=rax*16 left shift rax by 4 places (rax =80i)
	movq	%rax, %rdx	#rdx<--rax(=80i)
	movq	-32(%rbp), %rax   #put data matrix address in rax
	addq	%rax, %rdx	#rdx<--data+ 80*i (data[i])
	movl	-4(%rbp), %eax #%eax has j value
	cltq		#rax<-eax and sign extend to 64 bit ie rax=j
	salq	$2, %rax  #rax*=4  (4j)
	addq	%rdx, %rax	#rax->rax+rdx | rax= data+ 80*i+ 4*j (&data[i][j])
	movq	%rax, %rsi	#rsi=&data[i][j]
	leaq	.LC1(%rip), %rdi #load data address of "%d"
	movl	$0, %eax  #no vector register so eax stores 0
	call	__isoc99_scanf@PLT	#scanf called 
	addl	$1, -4(%rbp)	#Add 1 to j
.L10:
	movl	-4(%rbp), %eax #eax stores j
	cmpl	-20(%rbp), %eax	#%eax -%rbp-20 
	jl	.L11       # jump to.L11 if j<n
	addl	$1, -8(%rbp) #increment i by 1;  (rbp-8)<--(rbp-8) +1 
.L9:
	movl	-8(%rbp), %eax #eax<--rbp-8 value of i
	cmpl	-20(%rbp), %eax # %eax - %rbp-20
	jl	.L12 # jump if i<n
	nop	#no operation
	leave	#leave copies the frame pointer to the stack point and releases the stack space formerly used by a procedure for its local variables. 
	.cfi_def_cfa 7, 8	# defines a rule for computing CFA as: take address from reg 7 and add offset 8 to it. 
	ret	#return
	.cfi_endproc #ends method ReadMat
.LFE1:
	.size	ReadMat, .-ReadMat
	.section	.rodata
	.align 8
.LC6:
	.string	"\nThe transpose of the second matrix:"
	.text
	.globl	TransMat
	.type	TransMat, @function
TransMat:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L14
.L17:
	movl	$0, -8(%rbp)
	jmp	.L15
.L16:
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	movl	%eax, -4(%rbp)
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-12(%rbp), %eax
	cltq
	movl	(%rsi,%rax,4), %edx
	movl	-8(%rbp), %eax
	cltq
	movl	%edx, (%rcx,%rax,4)
	movl	-8(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-12(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movl	%edx, (%rcx,%rax,4)
	addl	$1, -8(%rbp)
.L15:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L16
	addl	$1, -12(%rbp)
.L14:
	movl	-12(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L17
	leaq	.LC6(%rip), %rdi
	call	puts@PLT
	movl	$0, -12(%rbp)
	jmp	.L18
.L21:
	movl	$0, -8(%rbp)
	jmp	.L19
.L20:
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	movl	%eax, %esi
	leaq	.LC5(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -8(%rbp)
.L19:
	movl	-8(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L20
	movl	$10, %edi
	call	putchar@PLT
	addl	$1, -12(%rbp)
.L18:
	movl	-12(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L21
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	TransMat, .-TransMat
	.globl	VectMult
	.type	VectMult, @function
VectMult:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L23
.L24:
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-8(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rcx
	movq	-40(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	imull	%edx, %eax
	addl	%eax, -4(%rbp)
	addl	$1, -8(%rbp)
.L23:
	movl	-8(%rbp), %eax
	cmpl	-20(%rbp), %eax
	jl	.L24
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	VectMult, .-VectMult
	.globl	MatMult
	.type	MatMult, @function
MatMult:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movl	%edi, -36(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	%rcx, -64(%rbp)
	movq	-56(%rbp), %rdx
	movl	-36(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	TransMat
	movl	$0, -24(%rbp)
	jmp	.L27
.L30:
	movl	$0, -20(%rbp)
	jmp	.L28
.L29:
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rsi
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, %rcx
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$4, %rax
	movq	%rax, %rdx
	movq	-64(%rbp), %rax
	leaq	(%rdx,%rax), %rbx
	movl	-36(%rbp), %eax
	movq	%rsi, %rdx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	VectMult
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	cltq
	movl	%edx, (%rbx,%rax,4)
	addl	$1, -20(%rbp)
.L28:
	movl	-20(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L29
	addl	$1, -24(%rbp)
.L27:
	movl	-24(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jl	.L30
	nop
	addq	$56, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	MatMult, .-MatMult
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits
