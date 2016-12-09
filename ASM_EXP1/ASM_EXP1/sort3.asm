.586
.model flat, stdcall

includelib "D:\\PROGRAMING\\msvcrt.lib"
printf proto c : dword, : vararg
scanf proto c : dword, : vararg
getchar proto c
ExitProcess proto : dword

.data
count	dword 0
arr		sdword - 2
msg1	byte		"请输入1-100的数组元素个数：", 0
msg2	byte		"%d", 0
msg3    byte		"%d ", 0
.code
main proc
LIN :
invoke printf, offset msg1
invoke scanf, offset msg2, offset count
invoke getchar
cmp		count, 0
JZ			LIN

mov ecx, count
lea ebx, offset arr
mov edi, 0
LSCANF:
push ecx
invoke scanf, offset msg2, addr[ebx][edi * 4]
invoke getchar
inc edi
pop ecx
loop LSCANF

cmp		count, 1
JZ			PRINT

mov edi, count
dec  edi
mov ecx, edi
L1 :
push ecx
push edi
L2 :
mov eax, [ebx][edi * 4]
cmp eax, [ebx][edi * 4 - 4]
JGE   L3
mov edx, [ebx][edi * 4 - 4]
mov[ebx][edi * 4 - 4], eax
mov[ebx][edi * 4], edx
L3 :
dec edi
loop L2
pop edi
pop ecx
loop L1
PRINT :
mov ecx, count
mov edi, 0
LP :
	push ecx
	invoke printf, offset msg3, dword ptr[ebx][edi * 4]
	inc edi
	pop ecx
	loop LP
	invoke ExitProcess, 0
	main endp
	end main
