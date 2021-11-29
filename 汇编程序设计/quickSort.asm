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

partition proc
	push	ebp
	mov	ebp, esp
	sub	esp, 4
	pushad
	
	mov	edx, [ebp+16]
	mov	esi, [ebp+12]
	mov	edi, [ebp+8]
	mov	ebx, [edx+4*esi]
again:
	cmp	esi, edi
	jge	final
	againt:
		cmp	esi, edi
		jge	final
		cmp	[edx+4*edi], ebx
		jl	nextt
		dec	edi
		jmp	againt
	nextt:
		mov	eax, [edx+4*edi]
		xchg	[edx+4*esi] ,eax
		mov	[edx+4*edi], eax
	againh:
		cmp	esi, edi
		jge	final
		cmp	[edx+4*esi], ebx
		jg	nexth
		inc	esi
		jmp	againh
	nexth:
		mov	eax, [edx+4*esi]
		xchg	[edx+4*edi], eax
		mov	[edx+4*esi], eax
	jmp	again
final:
	mov	[ebp-4], esi
	popad
	pop	eax
	pop	ebp
	ret	12
partition endp

quickSort proc
	push	ebp
	mov	ebp, esp
	pushad
	
	mov	eax, [ebp+12]
	cmp	eax, [ebp+8]
	jge	final
again:
	push	[ebp+16]
	push	[ebp+12]
	push	[ebp+8]
	call	partition
	
	push	[ebp+16]
	push	[ebp+12]
	dec	eax
	push	eax
	call	quickSort
	inc	eax
	
	push	[ebp+16]
	inc	eax
	push	eax
	push	[ebp+8]
	call	quickSort
	dec	eax
final:
	popad
	pop	ebp
	ret	12
quickSort endp

main proc
	push	offset n
	push	offset arr
	call	readArray
	
	push	offset arr
	push	0
	dec	n
	push	n
	inc	n
	call	quickSort
	
	push	offset n
	push	offset arr
	call	writeArray
	exit
main endp
end main