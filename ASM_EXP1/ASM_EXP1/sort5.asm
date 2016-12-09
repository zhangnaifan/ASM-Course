.586
.model flat, stdcall

includelib "D:\\PROGRAMING\\msvcrt.lib"
printf proto c : dword, : vararg
scanf proto c : dword, : vararg
getchar proto c
ExitProcess proto : dword

.data
count	dword 0
arr		sdword 100 dup(-2)
msg1	byte		"请输入1-100的数组元素个数：", 0
msg2	byte		"%d", 0
msg3    byte		"%d ", 0
.code
main proc
.REPEAT
invoke printf, offset msg1
invoke scanf, offset msg2, offset count
invoke getchar
.UNTIL		count>0

mov ecx, count
mov edi, 0
.WHILE ecx>0
push ecx
invoke scanf, offset msg2, addr arr[edi * 4]
invoke getchar
inc edi
pop ecx
dec ecx
.ENDW

cmp		count, 1
JZ			PRINT

mov esi, count
dec  esi
mov edi, esi

.WHILE esi>0
xor edi, edi
.WHILE edi<esi
	mov eax, arr[edi * 4]
	.IF eax > arr[edi * 4 + 4]
	mov edx, arr[edi * 4 + 4]
	mov arr[edi * 4 + 4], eax
	mov arr[edi * 4], edx
	nop
	.ENDIF
	inc edi
	.ENDW
	dec esi
	.ENDW

	PRINT :
mov ecx, count
mov edi, 0
LP :
	push ecx
	invoke printf, offset msg3, arr[edi * 4]
	inc edi
	pop ecx
	loop LP
	invoke ExitProcess, 0
	main endp
	end main
