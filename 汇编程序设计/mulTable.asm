include irvine32.inc
.data
.code

writeMultiply proc
	push	ebp
	mov	ebp, esp
	pushad

	mov	eax, [ebp+12]
	call	writeDec
	mov	al, '*'
	call	writeChar
	mov	eax, [ebp+8]
	call	writeDec
	mov	al, '='
	call	writeChar
	mov	eax, [ebp+12]
	mov	edx, 0
	mul	dword ptr [ebp+8]
	call	writeDec
	mov	edx, eax
	mov	al, ' '
	call	writeChar
	cmp	edx, 10
	jge	greaterTen
	call	writeChar
greaterTen:
	popad
	pop	ebp
	ret	8
writeMultiply endp

main proc
	mov	esi, 1
again1:
	cmp	esi, 10
	jge	final
	mov	edi, 1
	again2:
		cmp	edi, esi
		jg	next
		push	esi
		push	edi
		call	writeMultiply
		inc	edi
		jmp	again2
	next:
	inc	esi
	call	crlf
	jmp	again1
final:
	exit
main endp
end main