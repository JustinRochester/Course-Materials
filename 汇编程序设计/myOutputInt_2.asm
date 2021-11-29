include irvine32.inc
.data
	arr dd 30 dup(?)
.code

myOutputInt proc
	push eax
	push ebx
	push ecx
	push edx

	mov ecx, 0
	mov ebx, 10
	cmp eax, 0
	je output0

again:
	cmp eax, 0
	je printit
	mov edx, 0
	div ebx
	add edx, '0'
	mov [arr+4*ecx], edx
	add ecx, 1
	jmp again

output0:
	mov [arr], '0'
	add ecx, 1

printit:
	cmp ecx, 0
	je final
	sub ecx, 1
	mov eax, [arr+4*ecx]
	call writeChar
	jmp printit

final:	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
myOutputInt endp

main proc
	call readInt
	call myOutputInt
	exit
main endp
end main