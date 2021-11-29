include irvine32.inc
.data
.code

gcd	proc
	push	ebp
	mov	ebp, esp
	sub	esp, 4
	pushad
	
	mov	esi, [ebp+8]
	mov	edi, [ebp+12]
again:
	cmp	edi, 0
	je	final
	mov	eax, esi
	mov	edx, 0
	div	edi
	mov	esi, edi
	mov	edi, edx
	jmp	again

final:
	mov	[ebp-4], esi
	popad
	pop	eax
	pop	ebp
	ret	12
gcd	endp

main	proc
	mov	esi, 0
again:
	cmp	esi, 5
	jge	final
	call	readint
	push	eax
	call	readint
	push	eax
	call	gcd
	call	writeint
	call	crlf
	inc	esi
	jmp	again
final:
	exit
main	endp
end	main