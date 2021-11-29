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
	call	writeDec
	mov	al, ' '
	call	writeChar
	inc	esi
	jmp	again
final:
	popad
	pop	ebp
	ret	8
writeArray endp

insertSort proc
	push	ebp
	mov	ebp, esp
	pushad
	
	mov	ecx, [ebp+12]
	mov	ecx, [ecx]
	mov	edx, [ebp+8]
	mov	esi, 1
again:
	cmp	esi, ecx
	jge	final
	mov	edi, 0
	push	esi
	again2:
		cmp	edi, esi
		jge	next
		mov	eax, [edx+4*edi]
		cmp	eax, [edx+4*esi]
		jge	next
		inc	edi
		jmp	again2
	next:
		push	[edx+4*esi]
	backShift:
		dec	esi
		cmp	esi, edi
		jl	insertit
		mov	eax, [edx+4*esi]
		mov	[edx+4*esi+4], eax
		jmp	backShift
insertit:
	pop	[edx+4*edi]
	pop	esi
	inc	esi
	jmp	again
final:
	popad
	pop	ebp
	ret	8
insertSort endp

main proc
	push	offset n
	push	offset arr
	call	readArray
	
	push	offset n
	push	offset arr
	call	insertSort
	
	push	offset n
	push	offset arr
	call	writeArray
	exit
main endp
end main