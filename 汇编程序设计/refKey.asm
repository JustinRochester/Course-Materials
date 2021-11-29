include irvine32.inc
.data
	n	dd ?
	arr	dd 128	dup(?)
	refKey	dd ?
.code

readArray proc
; input: address: edx
; output: length: eax, elements: edx, border: ebx
	push	esi
	push	ecx
	call	readInt
	mov	ecx, eax
	mov	esi, 0
again:
	cmp	esi, ecx
	jge	final
	call	readInt
	mov	[edx+4*esi], eax
	inc	esi
	jmp	again
final:
	mov	eax, ecx
	pop	ecx
	pop	esi
	ret
readArray endp

writeBorder proc
; input: length: eax, elements: edx
; output: \ 
	pushad
	mov	ecx, eax
	inc	ebx
	push	[edx+4*ecx]
	mov	[edx+4*eax], ebx
	dec	ebx
	cmp	[edx], ebx
	jl	start
	mov	al, '|'
	call	writeChar

start:
	mov	esi, 0
again:
	cmp	esi, ecx
	jge	final
	mov	eax, [edx+4*esi]
	call	writeInt
	mov	al, ' '

	cmp	[edx+4*esi], ebx
	jge	printSpace
	cmp	[edx+4*esi+4], ebx
	jl	printSpace
	mov	al, '|'
printSpace:
	call	writeChar
	inc	esi
	jmp	again
final:
	pop	[edx+4*ecx]
	popad
	ret
writeBorder endp

adjustment proc
	pushad
	mov	esi, 0
	mov	edi, eax
	dec	edi
again:
	cmp	esi, edi
	jge	final
	findGreater:
		cmp	esi, edi
		jge	findLess
		cmp	[edx+4*esi], ebx
		jge	findLess
		inc	esi
		jmp	findGreater
	findLess:
		cmp	edi, esi
		jle	swapElem
		cmp	[edx+4*edi], ebx
		jl	swapElem
		dec	edi
		jmp	findLess
swapElem:
	cmp	esi, edi
	jge	next
	xchg	ecx, [edx+4*esi]
	xchg	ecx, [edx+4*edi]
	xchg	ecx, [edx+4*esi]
next:
	inc	esi
	dec	edi
	jmp	again
final:
	popad
	ret
adjustment endp

main proc
	lea	edx, arr
	call	readArray
	mov	n, eax
	call	readInt
	mov	refKey, eax

	mov	eax, n
	mov	ebx, refKey
	call	adjustment
	call	writeBorder
	exit
main endp
end main