.386
.model flat, stdcall
INCLUDELIB "D:\\PROGRAMING\\msvcrt.lib"
printf      PROTO C  :ptr byte, : vararg
_getche	PROTO C
ExitProcess	PROTO : DWORD; exit program
exit 		EQU <INVOKE ExitProcess, 0>

chr$ MACRO any_text : VARARG
LOCAL txtname
.data
txtname db any_text, 0
align 4
.code
EXITM <OFFSET txtname>
ENDM

.data
buff byte 16 dup(? )
count dword 0
chr byte ?

.code

iq proc	uses edx	address : dword, x : byte
mov		edx, 16
cmp		count, edx
jz			full

mov		dl, x
mov		ebx, address
mov		[ebx][edi], dl
inc		dword ptr count

inc		edi
cmp		edi, 16
jnz		not_full
xor		edi, edi
mov		eax, 1
jmp		not_full

full :
invoke printf, chr$(0dh,0ah,"队列已满！", 0dh, 0ah)
xor		eax,	eax

not_full :
ret
iq endp


oq	proc		uses	edx	address : dword

xor		edx,	edx
cmp		count,	edx
jz			empty

dec		count
mov		ebx,	address
invoke printf, chr$("队首为：%c",0dh,0ah) , byte ptr [ebx][esi]
inc		esi
cmp		esi,	16
jnz		not_empty
xor		esi,	esi
mov		eax,	1
jmp		not_empty

empty:
invoke printf, chr$("队列为空！",0dh,0ah)
xor		eax,	eax

not_empty:
ret
oq	endp


pq	proc  uses edx 		address : dword

xor		edx,	edx
cmp		count,	edx
jz			not_print

invoke  printf, chr$("队列元素：")
mov		ebx,	address
mov		ecx ,count
push		esi

OUTB:
push		ecx
invoke	printf,	chr$("%c "), byte ptr [ebx][esi]
pop		ecx
inc		esi
cmp		esi,	16
jnz		do_nothing
xor		esi,	esi
do_nothing:
loop		OUTB

pop		esi
invoke	printf, chr$("队首指针：%d,队尾指针：%d",0dh,0ah), esi, edi
jmp		print

not_print:
invoke printf, chr$("当前队列为空！",0dh,0ah)
print:
mov		eax,	count
ret
pq	endp


main proc

invoke printf, chr$("ESC:退出；+显示队列；-取出队首；1-9A-Z入队",0dh,0ah)
xor		edi,	edi
xor		esi,	esi

getchar:
invoke _getche
mov chr, al

cmp al, 1bh; 输入esc则退出程序
jz end_main

cmp al, 43			; 输入 ‘ + ’则打印buff中的元素
jz		printBuff

cmp al, 45			; 输入‘ - ’，若队列非空则取出队首元素，否则输出错误提醒信息
jz		dequeue

.IF		al >= 48 && al <= 57 || al >= 65 && al <= 90			; 若输入0 - 9A - Z且队列不满，则字符入队

movzx	edx,	al
push     edx
push		offset buff
call		iq
add		esp,	8

.ENDIF

jmp		getchar

printBuff:

push		offset	buff
call		pq
add		esp,	4
jmp		getchar

dequeue:

push		offset buff
call		oq
add		esp, 4
jmp		getchar

end_main:
exit
main endp
end main