	.file	"output.s"

.STR0:	.string "This Program implements bubble sort\n"
.STR1:	.string "Enter the size of the array: \n"
.STR2:	.string "Enter the elements of the array to be sorted: \n"
.STR3:	.string "The sorted array is: \n"
.STR4:	.string ", "
.STR5:	.string "\n"
	.text
	.globl	bubblesort
	.type	bubblesort, @function
bubblesort:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$184, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -12(%rbp)
# 0:res = t000 
	movl	$0, -28(%rbp)
# 1:res = i arg1 = t000 
	movl	-28(%rbp), %eax
	movl	%eax, -16(%rbp)
# 2:res = t001 arg1 = t000 
	movl	-28(%rbp), %eax
	movl	%eax, -32(%rbp)
# 3:arg1 = i arg2 = n 
.L3:
	movl	-16(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jl .L1
# 4:
	jmp .L2
# 5:
	jmp .L2
# 6:res = t002 arg1 = i 
.L5:
	movl	-16(%rbp), %eax
	movl	%eax, -36(%rbp)
# 7:res = i arg1 = i 
	movl	-16(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -16(%rbp)
# 8:
	jmp .L3
# 9:res = t003 
.L1:
	movl	$0, -40(%rbp)
# 10:res = j arg1 = t003 
	movl	-40(%rbp), %eax
	movl	%eax, -24(%rbp)
# 11:res = t004 arg1 = t003 
	movl	-40(%rbp), %eax
	movl	%eax, -44(%rbp)
# 12:res = t005 
.L7:
	movl	$1, -48(%rbp)
# 13:res = t006 arg1 = n arg2 = t005 
	movl	-4(%rbp), %eax
	movl	-48(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -52(%rbp)
# 14:arg1 = j arg2 = t006 
	movl	-24(%rbp), %eax
	movl	-52(%rbp), %edx
	cmpl	%edx, %eax
	jl .L4
# 15:
	jmp .L5
# 16:
	jmp .L6
# 17:res = t007 arg1 = j 
.L9:
	movl	-24(%rbp), %eax
	movl	%eax, -56(%rbp)
# 18:res = j arg1 = j 
	movl	-24(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -24(%rbp)
# 19:
	jmp .L7
# 20:res = t008 
.L4:
	movl	$0, -60(%rbp)
# 21:res = t009 
	movl	$1, -64(%rbp)
# 22:res = t010 arg1 = j arg2 = t009 
	movl	-24(%rbp), %eax
	movl	-64(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -68(%rbp)
# 23:res = t012 arg1 = t010 
	movl	-68(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -76(%rbp)
# 24:res = t011 arg1 = t008 arg2 = t012 
	movl	-60(%rbp), %eax
	movl	-76(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -72(%rbp)
# 25:res = t013 arg1 = arr arg2 = t011 
	movq	-12(%rbp), %rdx
	movslq	-72(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -80(%rbp)
# 26:res = t014 
	movl	$0, -84(%rbp)
# 27:res = t016 arg1 = j 
	movl	-24(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -92(%rbp)
# 28:res = t015 arg1 = t014 arg2 = t016 
	movl	-84(%rbp), %eax
	movl	-92(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -88(%rbp)
# 29:res = t017 arg1 = arr arg2 = t015 
	movq	-12(%rbp), %rdx
	movslq	-88(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -96(%rbp)
# 30:arg1 = t013 arg2 = t017 
	movl	-80(%rbp), %eax
	movl	-96(%rbp), %edx
	cmpl	%edx, %eax
	jl .L8
# 31:
	jmp .L9
# 32:
	jmp .L10
# 33:res = t018 
.L8:
	movl	$0, -100(%rbp)
# 34:res = t019 
	movl	$1, -104(%rbp)
# 35:res = t020 arg1 = j arg2 = t019 
	movl	-24(%rbp), %eax
	movl	-104(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -108(%rbp)
# 36:res = t022 arg1 = t020 
	movl	-108(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -116(%rbp)
# 37:res = t021 arg1 = t018 arg2 = t022 
	movl	-100(%rbp), %eax
	movl	-116(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -112(%rbp)
# 38:res = t023 arg1 = arr arg2 = t021 
	movq	-12(%rbp), %rdx
	movslq	-112(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -120(%rbp)
# 39:res = key arg1 = t023 
	movl	-120(%rbp), %eax
	movl	%eax, -20(%rbp)
# 40:res = t024 arg1 = t023 
	movl	-120(%rbp), %eax
	movl	%eax, -124(%rbp)
# 41:res = t025 
	movl	$0, -128(%rbp)
# 42:res = t026 
	movl	$1, -132(%rbp)
# 43:res = t027 arg1 = j arg2 = t026 
	movl	-24(%rbp), %eax
	movl	-132(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -136(%rbp)
# 44:res = t029 arg1 = t027 
	movl	-136(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -144(%rbp)
# 45:res = t028 arg1 = t025 arg2 = t029 
	movl	-128(%rbp), %eax
	movl	-144(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -140(%rbp)
# 46:res = t030 
	movl	$0, -148(%rbp)
# 47:res = t032 arg1 = j 
	movl	-24(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -156(%rbp)
# 48:res = t031 arg1 = t030 arg2 = t032 
	movl	-148(%rbp), %eax
	movl	-156(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -152(%rbp)
# 49:res = t033 arg1 = arr arg2 = t031 
	movq	-12(%rbp), %rdx
	movslq	-152(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -160(%rbp)
# 50:res = arr arg1 = t028 arg2 = t033 
	movq	-12(%rbp), %rdx
	movslq	-140(%rbp), %rax
	addq	%rax, %rdx
	movl	-160(%rbp), %eax
	movl	%eax, (%rdx)
# 51:res = t034 arg1 = t033 
	movl	-160(%rbp), %eax
	movl	%eax, -164(%rbp)
# 52:res = t035 
	movl	$0, -168(%rbp)
# 53:res = t037 arg1 = j 
	movl	-24(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -176(%rbp)
# 54:res = t036 arg1 = t035 arg2 = t037 
	movl	-168(%rbp), %eax
	movl	-176(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -172(%rbp)
# 55:res = arr arg1 = t036 arg2 = key 
	movq	-12(%rbp), %rdx
	movslq	-172(%rbp), %rax
	addq	%rax, %rdx
	movl	-20(%rbp), %eax
	movl	%eax, (%rdx)
# 56:res = t038 arg1 = key 
	movl	-20(%rbp), %eax
	movl	%eax, -180(%rbp)
# 57:
	jmp .L9
# 58:
.L10:
	jmp .L9
# 59:
.L6:
	jmp .L5
# 60:res = t039 
.L2:
	movl	$0, -184(%rbp)
# 61:res = t039 
	movl	-184(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-184, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	bubblesort, .-bubblesort
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$568, %rsp
# 62:
	movq	$.STR0,	%rdi
# 63:res = t040 
	pushq %rbp
	call	printStr
	movl	%eax, -4(%rbp)
	addq $8 , %rsp
# 64:res = t041 
	movl	$100, -408(%rbp)
# 65:res = t042 
	movl	$1, -420(%rbp)
# 66:res = err arg1 = t042 
	movl	-420(%rbp), %eax
	movl	%eax, -416(%rbp)
# 67:
	movq	$.STR1,	%rdi
# 68:res = t043 
	pushq %rbp
	call	printStr
	movl	%eax, -424(%rbp)
	addq $8 , %rsp
# 69:res = t044 arg1 = err 
	leaq	-416(%rbp), %rax
	movq	%rax, -432(%rbp)
# 70:res = t044 
# 71:res = t045 
	pushq %rbp
	movq	-432(%rbp), %rdi
	call	readInt
	movl	%eax, -436(%rbp)
	addq $0 , %rsp
# 72:res = n arg1 = t045 
	movl	-436(%rbp), %eax
	movl	%eax, -412(%rbp)
# 73:res = t046 arg1 = t045 
	movl	-436(%rbp), %eax
	movl	%eax, -440(%rbp)
# 74:
	movq	$.STR2,	%rdi
# 75:res = t047 
	pushq %rbp
	call	printStr
	movl	%eax, -444(%rbp)
	addq $8 , %rsp
# 76:res = t048 
	movl	$0, -448(%rbp)
# 77:res = i arg1 = t048 
	movl	-448(%rbp), %eax
	movl	%eax, -444(%rbp)
# 78:res = t049 arg1 = t048 
	movl	-448(%rbp), %eax
	movl	%eax, -452(%rbp)
# 79:arg1 = i arg2 = n 
.L13:
	movl	-444(%rbp), %eax
	movl	-412(%rbp), %edx
	cmpl	%edx, %eax
	jl .L11
# 80:
	jmp .L12
# 81:
	jmp .L12
# 82:res = t050 arg1 = i 
.L14:
	movl	-444(%rbp), %eax
	movl	%eax, -452(%rbp)
# 83:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 84:
	jmp .L13
# 85:res = t051 
.L11:
	movl	$0, -456(%rbp)
# 86:res = t053 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -464(%rbp)
# 87:res = t052 arg1 = t051 arg2 = t053 
	movl	-456(%rbp), %eax
	movl	-464(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -460(%rbp)
# 88:res = t054 arg1 = err 
	leaq	-416(%rbp), %rax
	movq	%rax, -472(%rbp)
# 89:res = t054 
# 90:res = t055 
	pushq %rbp
	movq	-472(%rbp), %rdi
	call	readInt
	movl	%eax, -476(%rbp)
	addq $0 , %rsp
# 91:res = arr arg1 = t052 arg2 = t055 
	leaq	-404(%rbp), %rdx
	movslq	-460(%rbp), %rax
	addq	%rax, %rdx
	movl	-476(%rbp), %eax
	movl	%eax, (%rdx)
# 92:res = t056 arg1 = t055 
	movl	-476(%rbp), %eax
	movl	%eax, -480(%rbp)
# 93:
	jmp .L14
# 94:res = t057 
.L12:
	movl	$0, -484(%rbp)
# 95:res = arr 
# 96:res = n 
# 97:res = t058 
	pushq %rbp
	movl	-412(%rbp) , %edi
	leaq	-404(%rbp), %rsi
	call	bubblesort
	movl	%eax, -488(%rbp)
	addq $0 , %rsp
# 98:
	movq	$.STR3,	%rdi
# 99:res = t059 
	pushq %rbp
	call	printStr
	movl	%eax, -492(%rbp)
	addq $8 , %rsp
# 100:res = t060 
	movl	$0, -496(%rbp)
# 101:res = i arg1 = t060 
	movl	-496(%rbp), %eax
	movl	%eax, -444(%rbp)
# 102:res = t061 arg1 = t060 
	movl	-496(%rbp), %eax
	movl	%eax, -500(%rbp)
# 103:res = t062 
.L17:
	movl	$1, -504(%rbp)
# 104:res = t063 arg1 = n arg2 = t062 
	movl	-412(%rbp), %eax
	movl	-504(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -508(%rbp)
# 105:arg1 = i arg2 = t063 
	movl	-444(%rbp), %eax
	movl	-508(%rbp), %edx
	cmpl	%edx, %eax
	jl .L15
# 106:
	jmp .L16
# 107:
	jmp .L16
# 108:res = t064 arg1 = i 
.L18:
	movl	-444(%rbp), %eax
	movl	%eax, -508(%rbp)
# 109:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 110:
	jmp .L17
# 111:res = t065 
.L15:
	movl	$0, -512(%rbp)
# 112:res = t067 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -520(%rbp)
# 113:res = t066 arg1 = t065 arg2 = t067 
	movl	-512(%rbp), %eax
	movl	-520(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -516(%rbp)
# 114:res = t068 arg1 = arr arg2 = t066 
	leaq	-404(%rbp), %rdx
	movslq	-516(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -524(%rbp)
# 115:res = t068 
# 116:res = t069 
	pushq %rbp
	movl	-524(%rbp) , %edi
	call	printInt
	movl	%eax, -528(%rbp)
	addq $0 , %rsp
# 117:
	movq	$.STR4,	%rdi
# 118:res = t070 
	pushq %rbp
	call	printStr
	movl	%eax, -532(%rbp)
	addq $8 , %rsp
# 119:
	jmp .L18
# 120:res = t071 
.L16:
	movl	$0, -536(%rbp)
# 121:res = t072 
	movl	$1, -540(%rbp)
# 122:res = t073 arg1 = n arg2 = t072 
	movl	-412(%rbp), %eax
	movl	-540(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -544(%rbp)
# 123:res = t075 arg1 = t073 
	movl	-544(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -552(%rbp)
# 124:res = t074 arg1 = t071 arg2 = t075 
	movl	-536(%rbp), %eax
	movl	-552(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -548(%rbp)
# 125:res = t076 arg1 = arr arg2 = t074 
	leaq	-404(%rbp), %rdx
	movslq	-548(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -556(%rbp)
# 126:res = t076 
# 127:res = t077 
	pushq %rbp
	movl	-556(%rbp) , %edi
	call	printInt
	movl	%eax, -560(%rbp)
	addq $0 , %rsp
# 128:
	movq	$.STR5,	%rdi
# 129:res = t078 
	pushq %rbp
	call	printStr
	movl	%eax, -564(%rbp)
	addq $8 , %rsp
# 130:res = t079 
	movl	$0, -568(%rbp)
# 131:res = t079 
	movl	-568(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-568, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
