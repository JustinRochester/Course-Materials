include irvine32.inc
.data
.code

myOutputInt proc
	push eax
	push ebx
	push ecx
	push edx

	cmp eax, 0
	je output0
	
	mov ecx, 0
	mov ebx, 10
again:
	mov edx, 0
	div ebx
	add edx, '0'
	push edx
	add ecx, 1
	cmp eax, 0
	je output
	jmp again

output:
	cmp ecx, 0
	je final
	pop eax
	call writeChar
	sub ecx, 1
	jmp output

output0:
	mov al, '0'
	call writeChar

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