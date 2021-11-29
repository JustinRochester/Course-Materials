include irvine32.inc
.data
	s	db	128 dup(?)
	len	dd	?
	op	db	'+-*/', 0
	msg	db	'Unaccept!', 0
.code

explainNum proc
	push	ebp
	mov	ebp, esp
;	[ebp+16]: address
;	[ebp+12]: head
;	[ebp+8] : tail
;	ret eax : value
;	ret edx : errorType
	push	0
	push	1
	pushad
	
	mov	edx, [ebp+16]
	mov	esi, [ebp+12]
	dec	esi
notNum:
	inc	esi
	cmp	esi, [ebp+8]
	jge	final
	cmp	byte ptr [edx+esi], '0'
	jl	notNum
	cmp	byte ptr [edx+esi], '9'
	jg	notNum

readAbs:
	cmp	esi, [ebp+8]
	jge	final
	mov	dword ptr [ebp-8], 0
	cmp	byte ptr [edx+esi], '0'
	jl	checkSpace
	cmp	byte ptr [edx+esi], '9'
	jg	checkSpace
	pushad
	mov	ebx, 10
	mov	eax, [ebp-4]
	mov	edx, 0
	mul	ebx
	mov	[ebp-4], eax
	popad
	mov	eax, 0
	mov	al, [edx+esi]
	sub	al, '0'
	add	eax, [ebp-4]
	mov	[ebp-4], eax
	inc	esi
	jmp	readAbs
checkSpace:
	cmp	esi, [ebp+8]
	jge	final
	cmp	byte ptr [edx+esi], ' '
	je	checked
	mov	dword ptr [ebp-8], 1
checked:
	inc	esi
	jmp	checkSpace
final:
	popad
	pop	edx
	pop	eax
	pop	ebp
	ret	12
explainNum endp

main proc
	mov	ecx, 128
	lea	edx, s
	call	readString
	mov	len, eax
	
	mov	ebp, 0
	mov	esi, 0
again:
	cmp	esi, 4
	jge	final
	mov	al, op[esi]
	mov	ecx, len
	lea	edi, s
	cld
	repne	scasb
	je	next
	inc	esi
	jmp	again
next:
	mov	ebp, 1
	sub	edi, offset s
	push	offset s
	push	0
	dec	edi
	push	edi
	inc	edi
	call	explainNum
	cmp	edx, 0
	je	accept1
	mov	ebp, 0
accept1:
	push	eax
	
	push	offset s
	push	edi
	push	len
	call	explainNum
	cmp	edx, 0
	je	accept2
	mov	ebp, 0
accept2:
	mov	edx, eax
	pop	eax
	
	jmp	calc[4*esi]
final:
	cmp	ebp, 1
	jne	unaccept
	call	writeInt
	exit
unaccept:
	lea	edx, msg
	call	writeString
	exit
	
	
	
	calc	dd	addit, subit, mulit, divit
addit:
	add	eax, edx
	jmp	final
subit:
	sub	eax, edx
	jmp	final
mulit:
	push	ebx
	mov	ebx, edx
	mov	edx, 0
	mul	ebx
	pop	ebx
	jmp	final
divit:
	push	ebx
	mov	ebx, edx
	mov	edx, 0
	div	ebx
	pop	ebx
	jmp	final
main endp
end main