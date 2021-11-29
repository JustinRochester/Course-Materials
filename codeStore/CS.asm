include irvine32.inc
.data
	Array	dword	1000 dup(?)
.code

isCS proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	mov	esi, 1
	mov	ecx, 1
again:
	cmp	ecx, [ebp+8]
	jge	next
	add	ecx, esi
	add	ecx, esi
	inc	ecx
	inc	esi
	jmp	again
next:
	cmp	ecx, [ebp+8]
	jne	final
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	4
isCS endp

aa proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	mov	eax, [ebp+8]
	mov	edx, 0
	mov	ebx, 10
	div	ebx
	cmp	eax, edx
	jne	final
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	4
aa endp

aabb proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	mov	eax, [ebp+8]
	cmp	eax, 1000
	jl	final
	cmp	eax, 9999
	jg	final
	
	mov	edx, 0
	mov	ebx, 100
	div	ebx
	
	push	eax
	call	aa
	cmp	eax, 1
	jne	final
	
	push	edx
	call	aa
	cmp	eax, 1
	jne	final
	
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	4
aabb endp

aabcc proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	mov	eax, [ebp+8]
	cmp	eax, 10000
	jl	final
	cmp	eax, 99999
	jg	final
	
	mov	edx, 0
	mov	ebx, 1000
	div	ebx
	push	eax
	call	aa
	cmp	eax, 1
	jne	final
	
	mov	eax, edx
	mov	edx, 0
	mov	ebx, 100
	div	ebx
	push	edx
	call	aa
	cmp	eax, 1
	jne	final
	
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	4
aabcc endp

abcabc proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	
	mov	eax, [ebp+8]
	cmp	eax, 100000
	jl	final
	cmp	eax, 999999
	jg	final
	
	mov	edx, 0
	mov	ebx, 1000
	div	ebx
	cmp	edx, eax
	jne	final
	mov	dword ptr [ebp-4], 1
final:
	popad
	pop	eax
	pop	ebp
	ret	4
abcabc endp

searchCSs proc
	push	ebp
	mov	ebp, esp
	push	0
	pushad
	; [ebp+16] : address of array
	; [ebp+12] : low
	; [ebp+08] : high
	; [ebp-04] : the number of request numbers
	mov	edx, [ebp+16]
	mov	esi, [ebp+12]
	mov	ecx, 0
again:
	cmp	esi, [ebp+8]
	jg	final
	
	push	esi
	call	isCS
	cmp	eax, 1
	jne	next
	
	push	esi
	call	aabb
	cmp	eax, 1
	je	recordit
	
	push	esi
	call	aabcc
	cmp	eax, 1
	je	recordit
	
	push	esi
	call	abcabc
	cmp	eax, 1
	je	recordit
	jmp	next
recordit:
	mov	[edx+4*ecx], esi
	inc	ecx
next:
	inc	esi
	jmp	again
final:
	mov	[ebp-4], ecx
	popad
	pop	eax
	pop	ebp
	ret	12
searchCSs endp

outPut proc
	pushad
	mov	ecx, eax
	mov	esi, 0
again:
	cmp	esi, ecx
	jge	final
	mov	eax, [edx]
	call	writeDec
	mov	al, ' '
	call	writeChar
	add	edx, 4
	inc	esi
	jmp	again
final:
	popad
	ret
outPut endp

main proc
	push	offset Array
	push	5001
	push	499999
	call	searchCSs
	
	lea	edx, Array
	call	outPut
	exit
main endp
end main