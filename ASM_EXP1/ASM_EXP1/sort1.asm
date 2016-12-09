.386
.model flat, stdcall
; 此处为本地库文件所在地址！
includelib "D:\\PROGRAMING\\msvcrt.lib"
printf proto c : dword, : vararg
scanf proto c : dword, : vararg
getchar proto c
ExitProcess proto : dword

.data
msg1 byte "%d", 0
msg2 byte "%d ", 0
msg3 byte "请输入1-100的元素个数:", 0
count dword 0
arr sdword 100 dup(-2)

.code
main proc
LIN :
invoke printf, offset msg3
invoke scanf, offset msg1, offset count
invoke getchar
mov eax, count
cmp eax, 0
JZ LIN

mov ecx, count
lea ebx, offset arr
L0 :
push ecx
invoke scanf, offset msg1, ebx
add ebx, 4
invoke getchar
pop ecx
loop L0

mov ecx, count
dec ecx
cmp ecx, 0
JZ PRINT
sub ebx, 4
L1:
push ebx
push ecx
L2 :
mov eax, [ebx]
cmp eax, [ebx - 4]
jge NEXT
mov edx, [ebx - 4]
mov[ebx - 4], eax
mov[ebx], edx
NEXT :
sub ebx, 4
loop L2
pop ecx
pop ebx
loop L1
PRINT :
mov ecx, count
lea ebx, offset arr
LP :
push ecx
invoke printf, offset msg2, dword ptr[ebx]
add ebx, 4
pop ecx
loop LP

invoke ExitProcess, 0
main endp
end main
