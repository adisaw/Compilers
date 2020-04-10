	.file	"output.s"

.STR0:	.string "This Program finds length of Longest Increasing Subsequence\nEnter size of array:\n"
.STR1:	.string "Enter array: (elements on new lines)\n"
.STR2:	.string "Length of LIS is: "
.STR3:	.string "\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$1156, %rsp
# 0:res = t000 
	movl	$100, -408(%rbp)
# 1:res = t001 
	movl	$1, -416(%rbp)
# 2:res = err arg1 = t001 
	movl	-416(%rbp), %eax
	movl	%eax, -412(%rbp)
# 3:
	movq	$.STR0,	%rdi
# 4:res = t002 
	pushq %rbp
	call	printStr
	movl	%eax, -420(%rbp)
	addq $8 , %rsp
# 5:res = t003 arg1 = err 
	leaq	-412(%rbp), %rax
	movq	%rax, -428(%rbp)
# 6:res = t003 
# 7:res = t004 
	pushq %rbp
	movq	-428(%rbp), %rdi
	call	readInt
	movl	%eax, -432(%rbp)
	addq $0 , %rsp
# 8:res = n arg1 = t004 
	movl	-432(%rbp), %eax
	movl	%eax, -4(%rbp)
# 9:res = t005 arg1 = t004 
	movl	-432(%rbp), %eax
	movl	%eax, -436(%rbp)
# 10:
	movq	$.STR1,	%rdi
# 11:res = t006 
	pushq %rbp
	call	printStr
	movl	%eax, -440(%rbp)
	addq $8 , %rsp
# 12:res = t007 
	movl	$0, -452(%rbp)
# 13:res = i arg1 = t007 
	movl	-452(%rbp), %eax
	movl	%eax, -444(%rbp)
# 14:res = t008 arg1 = t007 
	movl	-452(%rbp), %eax
	movl	%eax, -456(%rbp)
# 15:arg1 = i arg2 = n 
.L3:
	movl	-444(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jl .L1
# 16:
	jmp .L2
# 17:
	jmp .L2
# 18:res = t009 arg1 = i 
.L4:
	movl	-444(%rbp), %eax
	movl	%eax, -460(%rbp)
# 19:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 20:
	jmp .L3
# 21:res = t010 
.L1:
	movl	$0, -464(%rbp)
# 22:res = t012 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -472(%rbp)
# 23:res = t011 arg1 = t010 arg2 = t012 
	movl	-464(%rbp), %eax
	movl	-472(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -468(%rbp)
# 24:res = t013 arg1 = err 
	leaq	-412(%rbp), %rax
	movq	%rax, -480(%rbp)
# 25:res = t013 
# 26:res = t014 
	pushq %rbp
	movq	-480(%rbp), %rdi
	call	readInt
	movl	%eax, -484(%rbp)
	addq $0 , %rsp
# 27:res = a arg1 = t011 arg2 = t014 
	leaq	-404(%rbp), %rdx
	movslq	-468(%rbp), %rax
	addq	%rax, %rdx
	movl	-484(%rbp), %eax
	movl	%eax, (%rdx)
# 28:res = t015 arg1 = t014 
	movl	-484(%rbp), %eax
	movl	%eax, -488(%rbp)
# 29:
	jmp .L4
# 30:res = t016 
.L2:
	movl	$100, -892(%rbp)
# 31:res = t017 
	movl	$0, -896(%rbp)
# 32:res = t018 
	movl	$0, -900(%rbp)
# 33:res = t020 arg1 = t018 
	movl	-900(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -908(%rbp)
# 34:res = t019 arg1 = t017 arg2 = t020 
	movl	-896(%rbp), %eax
	movl	-908(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -904(%rbp)
# 35:res = t021 
	movl	$1, -912(%rbp)
# 36:res = l arg1 = t019 arg2 = t021 
	leaq	-888(%rbp), %rdx
	movslq	-904(%rbp), %rax
	addq	%rax, %rdx
	movl	-912(%rbp), %eax
	movl	%eax, (%rdx)
# 37:res = t022 arg1 = t021 
	movl	-912(%rbp), %eax
	movl	%eax, -916(%rbp)
# 38:res = t023 
	movl	$100000, -924(%rbp)
# 39:res = t024 arg1 = t023 
	movl	-924(%rbp), %eax
	negl	%eax
	movl	%eax, -928(%rbp)
# 40:res = max arg1 = t024 
	movl	-928(%rbp), %eax
	movl	%eax, -920(%rbp)
# 41:res = t025 
	movl	$1, -932(%rbp)
# 42:res = i arg1 = t025 
	movl	-932(%rbp), %eax
	movl	%eax, -444(%rbp)
# 43:res = t026 arg1 = t025 
	movl	-932(%rbp), %eax
	movl	%eax, -936(%rbp)
# 44:arg1 = i arg2 = n 
.L7:
	movl	-444(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jl .L5
# 45:
	jmp .L6
# 46:
	jmp .L6
# 47:res = t027 arg1 = i 
.L9:
	movl	-444(%rbp), %eax
	movl	%eax, -940(%rbp)
# 48:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 49:
	jmp .L7
# 50:res = t028 
.L5:
	movl	$0, -944(%rbp)
# 51:res = t030 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -952(%rbp)
# 52:res = t029 arg1 = t028 arg2 = t030 
	movl	-944(%rbp), %eax
	movl	-952(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -948(%rbp)
# 53:res = t031 
	movl	$1, -956(%rbp)
# 54:res = l arg1 = t029 arg2 = t031 
	leaq	-888(%rbp), %rdx
	movslq	-948(%rbp), %rax
	addq	%rax, %rdx
	movl	-956(%rbp), %eax
	movl	%eax, (%rdx)
# 55:res = t032 arg1 = t031 
	movl	-956(%rbp), %eax
	movl	%eax, -960(%rbp)
# 56:res = t033 
	movl	$0, -964(%rbp)
# 57:res = j arg1 = t033 
	movl	-964(%rbp), %eax
	movl	%eax, -448(%rbp)
# 58:res = t034 arg1 = t033 
	movl	-964(%rbp), %eax
	movl	%eax, -968(%rbp)
# 59:arg1 = j arg2 = i 
.L11:
	movl	-448(%rbp), %eax
	movl	-444(%rbp), %edx
	cmpl	%edx, %eax
	jl .L8
# 60:
	jmp .L9
# 61:
	jmp .L10
# 62:res = t035 arg1 = j 
.L13:
	movl	-448(%rbp), %eax
	movl	%eax, -972(%rbp)
# 63:res = j arg1 = j 
	movl	-448(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -448(%rbp)
# 64:
	jmp .L11
# 65:res = t036 
.L8:
	movl	$0, -976(%rbp)
# 66:res = t038 arg1 = j 
	movl	-448(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -984(%rbp)
# 67:res = t037 arg1 = t036 arg2 = t038 
	movl	-976(%rbp), %eax
	movl	-984(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -980(%rbp)
# 68:res = t039 arg1 = a arg2 = t037 
	leaq	-404(%rbp), %rdx
	movslq	-980(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -988(%rbp)
# 69:res = t040 
	movl	$0, -992(%rbp)
# 70:res = t042 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1000(%rbp)
# 71:res = t041 arg1 = t040 arg2 = t042 
	movl	-992(%rbp), %eax
	movl	-1000(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -996(%rbp)
# 72:res = t043 arg1 = a arg2 = t041 
	leaq	-404(%rbp), %rdx
	movslq	-996(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1004(%rbp)
# 73:arg1 = t039 arg2 = t043 
	movl	-988(%rbp), %eax
	movl	-1004(%rbp), %edx
	cmpl	%edx, %eax
	jl .L12
# 74:
	jmp .L13
# 75:res = t044 
.L12:
	movl	$0, -1008(%rbp)
# 76:res = t046 arg1 = j 
	movl	-448(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1016(%rbp)
# 77:res = t045 arg1 = t044 arg2 = t046 
	movl	-1008(%rbp), %eax
	movl	-1016(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1012(%rbp)
# 78:res = t047 arg1 = l arg2 = t045 
	leaq	-888(%rbp), %rdx
	movslq	-1012(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1020(%rbp)
# 79:res = t048 
	movl	$1, -1024(%rbp)
# 80:res = t049 arg1 = t047 arg2 = t048 
	movl	-1020(%rbp), %eax
	movl	-1024(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1028(%rbp)
# 81:res = t050 
	movl	$0, -1032(%rbp)
# 82:res = t052 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1040(%rbp)
# 83:res = t051 arg1 = t050 arg2 = t052 
	movl	-1032(%rbp), %eax
	movl	-1040(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1036(%rbp)
# 84:res = t053 arg1 = l arg2 = t051 
	leaq	-888(%rbp), %rdx
	movslq	-1036(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1044(%rbp)
# 85:arg1 = t049 arg2 = t053 
	movl	-1028(%rbp), %eax
	movl	-1044(%rbp), %edx
	cmpl	%edx, %eax
	jg .L14
# 86:
	jmp .L13
# 87:
	jmp .L15
# 88:res = t054 
.L14:
	movl	$0, -1048(%rbp)
# 89:res = t056 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1056(%rbp)
# 90:res = t055 arg1 = t054 arg2 = t056 
	movl	-1048(%rbp), %eax
	movl	-1056(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1052(%rbp)
# 91:res = t057 
	movl	$0, -1060(%rbp)
# 92:res = t059 arg1 = j 
	movl	-448(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1068(%rbp)
# 93:res = t058 arg1 = t057 arg2 = t059 
	movl	-1060(%rbp), %eax
	movl	-1068(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1064(%rbp)
# 94:res = t060 arg1 = l arg2 = t058 
	leaq	-888(%rbp), %rdx
	movslq	-1064(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1072(%rbp)
# 95:res = t061 
	movl	$1, -1076(%rbp)
# 96:res = t062 arg1 = t060 arg2 = t061 
	movl	-1072(%rbp), %eax
	movl	-1076(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1080(%rbp)
# 97:res = l arg1 = t055 arg2 = t062 
	leaq	-888(%rbp), %rdx
	movslq	-1052(%rbp), %rax
	addq	%rax, %rdx
	movl	-1080(%rbp), %eax
	movl	%eax, (%rdx)
# 98:res = t063 arg1 = t062 
	movl	-1080(%rbp), %eax
	movl	%eax, -1084(%rbp)
# 99:
	jmp .L13
# 100:
.L15:
	jmp .L13
# 101:
.L10:
	jmp .L9
# 102:res = t064 
.L6:
	movl	$1, -1092(%rbp)
# 103:res = t065 arg1 = t064 
	movl	-1092(%rbp), %eax
	negl	%eax
	movl	%eax, -1096(%rbp)
# 104:res = ans arg1 = t065 
	movl	-1096(%rbp), %eax
	movl	%eax, -1088(%rbp)
# 105:res = t066 
	movl	$0, -1100(%rbp)
# 106:res = i arg1 = t066 
	movl	-1100(%rbp), %eax
	movl	%eax, -444(%rbp)
# 107:res = t067 arg1 = t066 
	movl	-1100(%rbp), %eax
	movl	%eax, -1104(%rbp)
# 108:arg1 = i arg2 = n 
.L18:
	movl	-444(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jl .L16
# 109:
	jmp .L17
# 110:
	jmp .L17
# 111:res = t068 arg1 = i 
.L20:
	movl	-444(%rbp), %eax
	movl	%eax, -1108(%rbp)
# 112:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 113:
	jmp .L18
# 114:res = t069 
.L16:
	movl	$0, -1112(%rbp)
# 115:res = t071 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1120(%rbp)
# 116:res = t070 arg1 = t069 arg2 = t071 
	movl	-1112(%rbp), %eax
	movl	-1120(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1116(%rbp)
# 117:res = t072 arg1 = l arg2 = t070 
	leaq	-888(%rbp), %rdx
	movslq	-1116(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1124(%rbp)
# 118:arg1 = ans arg2 = t072 
	movl	-1088(%rbp), %eax
	movl	-1124(%rbp), %edx
	cmpl	%edx, %eax
	jl .L19
# 119:
	jmp .L20
# 120:
	jmp .L21
# 121:res = t073 
.L19:
	movl	$0, -1128(%rbp)
# 122:res = t075 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -1136(%rbp)
# 123:res = t074 arg1 = t073 arg2 = t075 
	movl	-1128(%rbp), %eax
	movl	-1136(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -1132(%rbp)
# 124:res = t076 arg1 = l arg2 = t074 
	leaq	-888(%rbp), %rdx
	movslq	-1132(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -1140(%rbp)
# 125:res = ans arg1 = t076 
	movl	-1140(%rbp), %eax
	movl	%eax, -1088(%rbp)
# 126:res = t077 arg1 = t076 
	movl	-1140(%rbp), %eax
	movl	%eax, -1144(%rbp)
# 127:
	jmp .L20
# 128:
.L21:
	jmp .L20
# 129:
.L17:
	movq	$.STR2,	%rdi
# 130:res = t078 
	pushq %rbp
	call	printStr
	movl	%eax, -1148(%rbp)
	addq $8 , %rsp
# 131:res = ans 
# 132:res = t079 
	pushq %rbp
	movl	-1088(%rbp) , %edi
	call	printInt
	movl	%eax, -1152(%rbp)
	addq $0 , %rsp
# 133:
	movq	$.STR3,	%rdi
# 134:res = t080 
	pushq %rbp
	call	printStr
	movl	%eax, -1156(%rbp)
	addq $8 , %rsp
.LRT0:
	addq	$-1156, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
