include irvine32.inc
.data
	arr	dd	128 dup(?)
	n	dd	?
.code

readArray proc
	push	ebp
	mov	ebp, esp
	pushad
	
	call	readInt
	mov	ecx, [ebp+12]
	mov	[ecx], eax
	mov	esi, 0
	mov	edx, [ebp+8]
again:
	cmp	esi, [ecx]
	jge	final
	call	readInt
	mov	[edx+4*esi], eax
	inc	esi
	jmp	again
final:
	popad
	pop	ebp
	ret	8
readArray endp

writeArray proc
	push	ebp
	mov	ebp, esp
	pushad
	
	mov	esi, 0
	mov	ecx, [ebp+12]
	mov	edx, [ebp+8]
again:
	cmp	esi, [ecx]
	jge	final
	mov	eax, [edx+4*esi]
	call	writeInt
	mov	al, ' '
	call	writeChar
	inc	esi
	jmp	again
final:
	popad
	pop	ebp
	ret	8
writeArray endp

bubleSort proc
	push	ebp
	mov	ebp, esp
	pushad
	
	mov	ecx, [ebp+12]
	mov	ecx, [ecx]
	mov	edx, [ebp+8]
again:
	mov	esi, 0
	again2:
		mov	edi, esi
		inc	edi
		cmp	edi, ecx
		jge	next
		mov	ebx, [edx+4*esi]
		cmp	ebx, [edx+4*edi]
		jl	swaped
		xchg	ebx, [edx+4*edi]
		mov	[edx+4*esi], ebx
	swaped:
		inc	esi
		jmp	again2
next:
	loop	again
final:
	popad
	pop	ebp
	ret	8
bubleSort endp

main proc
	push	offset n
	push	offset arr
	call	readArray
	
	push	offset n
	push	offset arr
	call	bubleSort
	
	push	offset n
	push	offset arr
	call	writeArray
	exit
main endp
end main