include irvine32.inc
.data
	n dd ?
	arr dd 128 dup(?)
.code

readArray proc
; input: the address of array->edx
; output: length->a; element->edx
	push esi
	mov esi, 0
	call readInt
again:
	push eax
	call readInt
	mov [edx][4*esi], eax
	pop eax
	inc esi
	cmp esi, eax
	jge final
	jmp again

final:
	pop esi
	ret
readArray endp

findMax proc
; input: the address of array->edx, length->eax
; output: the position of the max element->eax
	push esi
	push ecx
	mov ecx, eax
	mov esi, 0
	mov eax, 0
again:
	push ebx
	mov ebx, [edx][4*esi]
	cmp [edx][4*eax], ebx
	jge updated
	mov eax, esi
updated:
	pop ebx
	inc esi
	cmp esi, ecx
	jge final
	jmp again

final:
	pop ecx
	pop esi
	ret
findMax endp

main proc
	lea edx, arr
	call readArray
	mov n, eax
	
	call findMax
	call writeInt
	call crlf
	mov eax, [edx][4*eax]
	call writeInt
	exit
main endp
end main