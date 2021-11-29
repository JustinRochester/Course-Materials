include irvine32.inc
.data
	answer	dd	16 dup(?)
	cntprt	dd	3
.code

printInt proc
	pushad
	mov	ecx, 0
	mov	esi, eax
	cmp	esi, 0
	je	isZero
	mov	ebx, 10
again:
	mov	edx, 0
	mov	eax, esi
	div	ebx
	mov	esi, eax
	add	edx, '0'
	push	edx
	inc	ecx
	cmp	esi, 0
	jg	again
	jmp	printit
isZero:
	mov	edx, '0'
	push	edx
	inc	ecx
printit:
	pop	eax
	call	writeChar
	loop	printit
final:
	popad
	ret
printInt endp

writeAnswer proc
	push	ebp
	mov	ebp, esp
	pushad
	
	mov	ecx, [ebp+16]
	mov	edx, [ebp+12]
	cmp	[ebp+8], ecx
	jne	final
	cmp	cntprt, 0
	jle	final
	
	mov	esi, 0
again:
	mov	eax, [edx+4*esi]
	inc	eax
	call	printInt
	mov	al, ' '
	call	writeChar
	inc	esi
	cmp	esi, ecx
	jl	again
	
	call	crlf
	dec	cntprt
final:
	popad
	pop	ebp
	ret	12
writeAnswer endp

putQueen proc
	push	ebp
	mov	ebp, esp
	push	1
	pushad
	; [ebp+28] :	address of answer
	; [ebp+24] :	the number of q
	; [ebp+20] :	which line
	; [ebp+16] :	list State
	; [ebp+12] : 	main diag State
	; [ebp+8]  :	vice diag State
	; [ebp-4]  :	return the number of planning to put q
	mov	edx, [ebp+28]
	mov	ebx, [ebp+20]
	cmp	ebx, [ebp+24]
	jge	final
	mov	dword ptr [ebp-4], 0
	mov	esi, 0
again:
	cmp	esi, [ebp+24]
	jge	final
	;check list
	mov	eax, 1
	mov	ecx, esi
	shl	eax, cl
	and	eax, [ebp+16]
	cmp	eax, 0
	jne	next
	;check main diag
	mov	eax, 1
	mov	ecx, ebx
	add	ecx, esi
	shl	eax, cl
	and	eax, [ebp+12]
	cmp	eax, 0
	jne	next
	;check vice diag
	mov	eax, 1
	mov	ecx, [ebp+24]
	dec	ecx
	add	ecx, ebx
	sub	ecx, esi
	shl	eax, cl
	and	eax, [ebp+8]
	cmp	eax, 0
	jne	next
	;all allow
	mov	[edx+4*ebx], esi
	push	edx
	push	[ebp+24]
	mov	eax, ebx
	inc	eax
	push	eax;new line
	mov	eax, 1
	mov	ecx, esi
	shl	eax, cl
	or	eax, [ebp+16]
	push	eax;new list state
	mov	eax, 1
	mov	ecx, ebx
	add	ecx, esi
	shl	eax, cl
	or	eax, [ebp+12]
	push	eax;new main diag state
	mov	eax, 1
	mov	ecx, [ebp+24]
	dec	ecx
	add	ecx, ebx
	sub	ecx, esi
	shl	eax, cl
	or	eax, [ebp+8]
	push	eax;new vice diag state
	call	putQueen
	add	[ebp-4], eax
next:
	inc	esi
	jmp	again
final:
	push	[ebp+24]
	push	edx
	push	ebx
	call	writeAnswer
	popad
	pop	eax
	pop	ebp
	ret	24
putQueen endp

main proc
	call	readInt
	push	offset answer
	push	eax
	push	0
	push	0
	push	0
	push	0
	call	putQueen
	call	printInt
	exit
main endp
end main