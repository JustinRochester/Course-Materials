include irvine32.inc
.data
	factor	dd 10000	dup(?)
	index	dd 10000	dup(?)
	cntfc	dd		0
.code

divided proc
; input: eax
; output: prime factors: factor
;	  prime fc's index: index
;	  numbers: cntfc
	pushad
	mov	esi, 2
	mov	ecx, eax
again:
	mov	eax, esi
	mul	esi
	cmp	eax, ecx
	jg	final
	mov	edx, 0
	mov	eax, ecx
	div	esi
	cmp	edx, 0
	jne	next

	mov	edi, cntfc
	mov	factor[4*edi], esi
resolution:
	mov	eax, ecx
	mov	edx, 0
	div	esi
	cmp	edx, 0
	jne	endres
	inc	index[4*edi]
	mov	ecx, eax
	jmp	resolution
endres:
	inc	cntfc
next:
	inc	esi
	jmp	again
final:
	cmp	ecx, 1
	je	finished
	mov	edi, cntfc
	mov	factor[4*edi], ecx
	mov	index[4*edi], 1
	inc	cntfc
finished:
	popad
	ret
divided endp

printInt proc
	pushad
	mov	ecx, 0
	mov	ebx, 10
again:
	cmp	eax, 0
	jle	final
	mov	edx, 0
	div	ebx
	add	edx, '0'
	push	edx
	inc	ecx
	jmp	again
final:
	cmp	ecx, 0
	jne	next
	push	'0'
	inc	ecx
next:
	cmp	ecx, 0
	jle	endprint
	pop	eax
	call	writeChar
	dec	ecx
endprint:
	popad
	ret
printInt endp

writeFactor proc
	pushad
	mov	esi, 0
	mov	ecx, eax
again:
	cmp	esi, ecx
	jge	final
	mov	eax, factor[4*esi]
	call	printInt
	mov	al, '^'
	call	writeChar
	mov	eax, index[4*esi]
	call	printInt
	inc	esi
	cmp	esi, ecx
	jge	again
	mov	al, '*'
	call	writeChar
	jmp	again
final:
	popad
	ret
writeFactor endp

main proc
	call	readInt
	call	divided
	mov	eax, cntfc
	call	writeFactor
	exit
main endp
end main