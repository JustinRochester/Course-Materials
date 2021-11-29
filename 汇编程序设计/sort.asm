include irvine32.inc
.data
	arr dd 128 dup(?)
	n dd ?
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

writeArray proc
; input: the address of array->edx, length->eax
; output: /
	push esi
	mov esi, 0
again:
	push eax
	mov eax, [edx][4*esi]
	call writeInt
	mov al, ' '
	call writeChar
	pop eax
	inc esi
	cmp esi, eax
	jge final
	jmp again

final:
	pop esi
	ret
writeArray endp

selectSort proc
; input: the address of array->edx, length->eax
; output: /
	push esi
	mov esi, 0
again:
	push ebx
	push ecx
	mov ebx, esi
	mov ecx, esi
	findMin:
		push eax
		mov eax, [edx][4*ecx]
		cmp eax, [edx][4*ebx]
		jle updated
		mov ecx, ebx
	updated:
		pop eax
		inc ebx
		cmp ebx, eax
		jge swapMin
		jmp findMin
	swapMin:
		mov ebx, [edx][4*ecx]
		xchg ebx, [edx][4*esi]
		mov [edx][4*ecx], ebx
		pop ecx
		pop ebx
		inc esi
		cmp esi, eax
		jge final
		jmp again
final:
	pop esi
	ret
selectSort endp

main proc
	lea edx, arr
	call readArray
	call writeArray
	call crlf
	call selectSort
	call writeArray
	exit
main endp
end main