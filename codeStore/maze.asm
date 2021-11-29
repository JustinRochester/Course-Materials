include irvine32.inc
.data
	n	dd	16
	m	dd	16
	map	db	16 dup(1)
		db	1,2,0,0,0,0,1,0,0,0,1,0,0,0,1,1
		db	1,1,1,1,1,0,1,1,1,0,1,0,1,0,1,1
		db	1,0,0,0,1,0,0,0,1,0,0,0,1,0,1,1
		db	1,0,1,1,1,0,1,1,1,1,1,0,1,1,1,1
		db	1,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1
		db	1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,1
		db	1,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1
		db	1,1,1,0,1,1,1,0,1,1,1,0,1,0,1,1
		db	1,0,1,0,0,0,1,0,0,0,0,0,1,0,1,1
		db	1,0,1,0,1,0,1,1,1,1,1,1,1,0,1,1
		db	1,0,0,0,1,0,1,0,1,0,0,0,0,0,1,1
		db	1,0,1,0,1,0,1,0,1,0,1,0,1,1,1,1
		db	1,0,1,0,1,0,0,0,0,0,1,0,0,3,1,1
		db	16 dup(1)
		db	16 dup(1)
	dirx	dd	0, 1, 0, -1
	diry	dd	1, 0, -1, 0
	ansx	dd	256 dup(?)
	ansy	dd	256 dup(?)
	msg	db	'No Solution!', 0
.code

writeAnswer proc
	push	ebp
	mov	ebp, esp
	pushad
	; [ebp+16] :	length of solution
	; [ebp+12] :	address of x-solution
	; [ebp+08] :	address of y-solution
	cmp	dword ptr [ebp+16], 0
	jne	existSolution
	lea	edx, msg
	call	writeString
	jmp	final
existSolution:
	mov	esi, 0
	mov	edx, [ebp+12]
	mov	ebx, [ebp+8]
again:
	cmp	esi, [ebp+16]
	jge	final
	
	mov	al, '('
	call	writeChar
	mov	eax, [edx+4*esi]
	call	writeDec
	mov	al, ','
	call	writeChar
	mov	eax, [ebx+4*esi]
	call	writeDec
	mov	al, ')'
	call	writeChar
	call	crlf
	inc	esi
	jmp	again
final:
	popad
	pop	ebp
	ret	12
writeAnswer endp

findMaze proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	; [ebp+48] :	length of map
	; [ebp+44] :	width of map
	; [ebp+40] :	address of map
	; [ebp+36] :	x-position at present
	; [ebp+32] :	y-position at present
	; [ebp+28] :	the number of directions
	; [ebp+24] :	address of x-directions
	; [ebp+20] :	address of y-directions
	; [ebp+16] :	the number of paces at present
	; [ebp+12] :	the address of x-answer
	; [ebp+08] :	the address of y-answer
	; [ebp-04] :	length of solution
	mov	edx, [ebp+40]
	mov	eax, [ebp+36]
	mov	ebx, [ebp+32]
	mov	ecx, [ebp+16]
	mov	esi, [ebp+12]
	mov	edi, [ebp+8]
	mov	[esi+4*ecx], eax
	mov	[edi+4*ecx], ebx
	inc	ecx
	mov	[ebp+16], ecx
	
	pushad
	add	ebx, [ebp+40]
	mov	edx, 0
	mov	ecx, 16
	mul	ecx
	add	eax, ebx
	mov	[ebp-4], eax
	popad
	mov	edx, [ebp-4]
	mov	dword ptr [ebp-4], 0
	
	push	[edx]
	cmp	byte ptr [edx], 1
	je	final
	cmp	byte ptr [edx], 3
	jne	notFinish
	mov	eax, [ebp+16]
	mov	[ebp-4], eax
	jmp	final
notFinish:
	mov	byte ptr [edx], 1
	mov	ecx, 0
	mov	edx, [ebp+40]
	mov	esi, [ebp+24]
	mov	edi, [ebp+20]
again:
	cmp	ecx, [ebp+28]
	jge	final
	
	add	eax, [esi+4*ecx]
	add	ebx, [edi+4*ecx]
	
	push	eax
	push	[ebp+48]
	push	[ebp+44]
	push	[ebp+40]
	push	eax
	push	ebx
	push	[ebp+28]
	push	[ebp+24]
	push	[ebp+20]
	push	[ebp+16]
	push	[ebp+12]
	push	[ebp+8]
	call	findMaze
	mov	[ebp-4], eax
	pop	eax
	
	sub	eax, [esi+4*ecx]
	sub	ebx, [edi+4*ecx]
	
	cmp	dword ptr [ebp-4], 0
	jne	final
	
	inc	ecx
	jmp	again
final:
	pop	[edx]
	popad
	xchg	ecx, [ebp+16]
	dec	ecx
	xchg	ecx, [ebp+16]
	pop	eax
	pop	ebp
	ret	44
findMaze endp

main proc
	push	n
	push	m
	push	offset map
	push	1
	push	1
	push	4
	push	offset dirx
	push	offset diry
	push	0
	push	offset ansx
	push	offset ansy
	call	findMaze
	
	push	eax
	push	offset ansx
	push	offset ansy
	call	writeAnswer
	exit
main endp
end main