include irvine32.inc
.data
.code

putQueen proc
	push	ebp
	mov	ebp, esp
	push	1
	pushad
	; [ebp+20] :	which line
	; [ebp+16] :	list State
	; [ebp+12] : 	main diag State
	; [ebp+8]  :	vice diag State
	; [ebp-4]  :	return the number of planning to put q
	mov	ebx, [ebp+20]
	cmp	ebx, 8
	jge	final
	mov	dword ptr [ebp-4], 0
	mov	esi, 0
again:
	cmp	esi, 8
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
	mov	ecx, 7
	add	ecx, ebx
	sub	ecx, esi
	shl	eax, cl
	and	eax, [ebp+8]
	cmp	eax, 0
	jne	next
	;all allow
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
	mov	ecx, 7
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
	popad
	pop	eax
	pop	ebp
	ret	16
putQueen endp

main proc
	push	0
	push	0
	push	0
	push	0
	call	putQueen
	call	writeInt
	exit
main endp
end main