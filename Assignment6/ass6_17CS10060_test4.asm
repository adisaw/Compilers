	.file	"output.s"

.STR0:	.string "This Program handles pointers\n"
.STR1:	.string "\n"
.STR2:	.string "\n"
.STR3:	.string "YES\n"
.STR4:	.string "NO\n"
.STR5:	.string "\n"
	.text
	.globl	gen
	.type	gen, @function
gen:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$20, %rsp
	movq	%rdi, -8(%rbp)
# 0:res = t000 
	movl	$78, -12(%rbp)
# 1:res = a arg1 = t000 
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movl	%edx, (%rax)
# 2:res = t001 arg1 = t000 
	movl	-12(%rbp), %eax
	movl	%eax, -16(%rbp)
# 3:res = t002 
	movl	$0, -20(%rbp)
# 4:res = t002 
	movl	-20(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-20, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	gen, .-gen
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$129, %rsp
# 5:
	movq	$.STR0,	%rdi
# 6:res = t003 
	pushq %rbp
	call	printStr
	movl	%eax, -4(%rbp)
	addq $8 , %rsp
# 7:res = t004 
	movl	$5, -20(%rbp)
# 8:res = i arg1 = t004 
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
# 9:res = t005 arg1 = i 
	leaq	-16(%rbp), %rax
	movq	%rax, -28(%rbp)
# 10:res = p arg1 = t005 
	movq	-28(%rbp), %rax
	movq	%rax, -12(%rbp)
# 11:res = t006 arg1 = t005 
	movq	-28(%rbp), %rax
	movq	%rax, -36(%rbp)
# 12:res = t007 
	movl	$6, -40(%rbp)
# 13:res = p arg1 = t007 
	movq	-12(%rbp), %rax
	movl	-40(%rbp), %edx
	movl	%edx, (%rax)
# 14:res = t008 arg1 = t007 
	movl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
# 15:res = i 
# 16:res = t009 
	pushq %rbp
	movl	-16(%rbp) , %edi
	call	printInt
	movl	%eax, -48(%rbp)
	addq $0 , %rsp
# 17:
	movq	$.STR1,	%rdi
# 18:res = t010 
	pushq %rbp
	call	printStr
	movl	%eax, -52(%rbp)
	addq $8 , %rsp
# 19:res = q arg1 = p 
	movq	-12(%rbp), %rax
	movq	%rax, -60(%rbp)
# 20:res = t011 
	movl	$9, -64(%rbp)
# 21:res = q arg1 = t011 
	movq	-60(%rbp), %rax
	movl	-64(%rbp), %edx
	movl	%edx, (%rax)
# 22:res = t012 arg1 = t011 
	movl	-64(%rbp), %eax
	movl	%eax, -68(%rbp)
# 23:res = i 
# 24:res = t013 
	pushq %rbp
	movl	-16(%rbp) , %edi
	call	printInt
	movl	%eax, -72(%rbp)
	addq $0 , %rsp
# 25:
	movq	$.STR2,	%rdi
# 26:res = t014 
	pushq %rbp
	call	printStr
	movl	%eax, -76(%rbp)
	addq $8 , %rsp
# 27:res = t015 
	movb	$65, -78(%rbp)
# 28:res = c arg1 = t015 
	movzbl	-78(%rbp), %eax
	movb	%al, -77(%rbp)
# 29:res = t016 arg1 = c 
	leaq	-77(%rbp), %rax
	movq	%rax, -94(%rbp)
# 30:res = d arg1 = t016 
	movq	-94(%rbp), %rax
	movq	%rax, -86(%rbp)
# 31:res = t017 arg1 = t016 
	movq	-94(%rbp), %rax
	movq	%rax, -102(%rbp)
# 32:res = t018 
	movb	$107, -103(%rbp)
# 33:res = d arg1 = t018 
	movq	-86(%rbp), %rax
	movl	-103(%rbp), %edx
	movl	%edx, (%rax)
# 34:res = t019 arg1 = t018 
	movzbl	-103(%rbp), %eax
	movb	%al, -104(%rbp)
# 35:res = t020 
	movb	$107, -105(%rbp)
# 36:arg1 = c arg2 = t020 
	movzbl	-77(%rbp), %eax
	cmpb	-105(%rbp), %al
	je .L1
# 37:
	jmp .L2
# 38:
	jmp .L3
# 39:
.L1:
	movq	$.STR3,	%rdi
# 40:res = t021 
	pushq %rbp
	call	printStr
	movl	%eax, -109(%rbp)
	addq $8 , %rsp
# 41:
	jmp .L3
# 42:
.L2:
	movq	$.STR4,	%rdi
# 43:res = t022 
	pushq %rbp
	call	printStr
	movl	%eax, -113(%rbp)
	addq $8 , %rsp
# 44:
	jmp .L3
# 45:res = p 
.L3:
# 46:res = t023 
	pushq %rbp
	movq	-12(%rbp), %rdi
	call	gen
	movl	%eax, -117(%rbp)
	addq $0 , %rsp
# 47:res = i 
# 48:res = t024 
	pushq %rbp
	movl	-16(%rbp) , %edi
	call	printInt
	movl	%eax, -121(%rbp)
	addq $0 , %rsp
# 49:
	movq	$.STR5,	%rdi
# 50:res = t025 
	pushq %rbp
	call	printStr
	movl	%eax, -125(%rbp)
	addq $8 , %rsp
# 51:res = t026 
	movl	$0, -129(%rbp)
# 52:res = t026 
	movl	-129(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-129, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
