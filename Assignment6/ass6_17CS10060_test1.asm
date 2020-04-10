	.file	"output.s"

.STR0:	.string "Program to handles global variables\n"
.STR1:	.string "value = "
.STR2:	.string "\n"
.STR3:	.string "value = "
.STR4:	.string "\n"
	.globl	cat
	.data
	.align 4
	.type	cat, @object
	.size	cat ,4
cat:
	.long 6
	.globl	man
	.data
	.align 4
	.type	man, @object
	.size	man ,4
man:
	.long 3
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$60, %rsp
# 4:
	movq	$.STR0,	%rdi
# 5:res = t002 
	pushq %rbp
	call	printStr
	movl	%eax, -4(%rbp)
	addq $8 , %rsp
# 6:res = t003 
	movl	$2, -12(%rbp)
# 7:res = t004 arg2 = t003 
	movl	man(%rip), %eax
	movl	-12(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -16(%rbp)
# 8:res = value arg1 = t004 
	movl	-16(%rbp), %eax
	movl	%eax, -8(%rbp)
# 9:res = t005 arg1 = t004 
	movl	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
# 10:
	movq	$.STR1,	%rdi
# 11:res = t006 
	pushq %rbp
	call	printStr
	movl	%eax, -24(%rbp)
	addq $8 , %rsp
# 12:res = value 
# 13:res = t007 
	pushq %rbp
	movl	-8(%rbp) , %edi
	call	printInt
	movl	%eax, -28(%rbp)
	addq $0 , %rsp
# 14:
	movq	$.STR2,	%rdi
# 15:res = t008 
	pushq %rbp
	call	printStr
	movl	%eax, -32(%rbp)
	addq $8 , %rsp
# 16:res = t009 
	movl	$11, -36(%rbp)
# 17:arg1 = t009 
	movl	%eax, cat(%rip)
# 18:res = t010 arg1 = t009 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 19:res = value 
	movl	cat(%rip), %eax
	movq	-36(%rbp), %rax
	movq	%rax, -8(%rbp)
# 20:res = t011 
	movl	cat(%rip), %eax
	movq	-36(%rbp), %rax
	movq	%rax, -44(%rbp)
# 21:
	movq	$.STR3,	%rdi
# 22:res = t012 
	pushq %rbp
	call	printStr
	movl	%eax, -48(%rbp)
	addq $8 , %rsp
# 23:res = value 
# 24:res = t013 
	pushq %rbp
	movl	-8(%rbp) , %edi
	call	printInt
	movl	%eax, -52(%rbp)
	addq $0 , %rsp
# 25:
	movq	$.STR4,	%rdi
# 26:res = t014 
	pushq %rbp
	call	printStr
	movl	%eax, -56(%rbp)
	addq $8 , %rsp
# 27:res = t015 
	movl	$0, -60(%rbp)
# 28:res = t015 
	movl	-60(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-60, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
