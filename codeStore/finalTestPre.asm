include irvine32.inc
.data
	mArray	dword	10 dup(?)
.code

isMR proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	; [ebp+16] : n
	; [ebp+12] : p
	; [ebp+08] : r
	; [ebp-04] : return is MR or not
	
	mov	ecx, 0
	mov	eax, [ebp+16]
	mov	ebx, 10
again:
	cmp	eax, 0
	je	next
	mov	edx, 0
	div	ebx
	push	eax
	mov	eax, edx
	mov	edx, 0
	mul	eax
	add	ecx, eax
	pop	eax
	jmp	again
next:
	mov	eax, ecx
	mov	edx, 0
	mov	ebx, [ebp+12]
	div	ebx
	cmp	edx, [ebp+8]
	jne	final
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	12
isMR endp

searchMR proc
	push	ebp
	mov	ebp, esp
	pushad
	; [ebp+20] : adrress of array
	; [ebp+16] : m
	; [ebp+12] : p
	; [ebp+08] : r
	
	mov	esi, 0
	mov	ecx, [ebp+16]
	mov	edx, [ebp+20]
again:
	cmp	esi, 10
	jge	final
	inc	ecx
	push	ecx
	push	[ebp+12]
	push	[ebp+8]
	call	isMR
	cmp	eax, 1
	jne	next
	mov	[edx+4*esi], ecx
	inc	esi
next:
	jmp	again
final:
	popad
	pop	ebp
	ret	16
searchMR endp

outPut proc
	push	ebp
	mov	ebp, esp
	pushad
	mov	esi, 0
	mov	edx, [ebp+8]
again:
	cmp	esi, 10
	jge	final
	mov	eax, [edx]
	call	writeDec
	mov	al, ' '
	call	writeChar
	inc	esi
	add	edx, 4
	jmp	again
final:
	popad
	pop	ebp
	ret	4
outPut endp

main proc
	push	offset mArray
	call	readInt
	push	eax
	call	readInt
	push	eax
	call	readInt
	push	eax
	call	searchMR
	
	push	offset mArray
	call	outPut
	exit
main endp
end main