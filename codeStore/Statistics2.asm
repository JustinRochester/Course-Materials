include irvine32.inc
.data
	cnt	dd 3	dup(?)
	n1	dd ?
	arr1	dd 128	dup(?)
	n2	dd ?
	arr2	dd 128	dup(?)
	n3	dd ?
	arr3	dd 128	dup(?)
	n	dd	offset n1
		dd	offset n2
		dd	offset n3
	arr	dd	offset arr1
		dd	offset arr2
		dd	offset arr3
.code

readArray proc
; input: address: edx
; output: length: eax, elements: edx
	push	esi
	push	ebx
	call	readInt
	mov	ebx, eax
	mov	esi, 0
again:
	cmp	esi, ebx
	jge	final
	call	readInt
	mov	[edx+4*esi], eax
	inc	esi
	jmp	again
final:
	mov	eax, ebx
	pop	ebx
	pop	esi
	ret
readArray endp

writeArray proc
; input: length: eax, elements: edx
; output: \
	pushad
	mov	ebx, eax
	mov	esi, 0
again:
	cmp	esi, ebx
	jge	final
	mov	eax, [edx+4*esi]
	call	writeInt
	mov	al, ' '
	call	writeChar
	inc	esi
	jmp	again
final:
	popad
	ret
writeArray endp

statistics proc
; input: length: eax, elements: edx
; output: cnt[i]: the number of elements whose remainder is i
	mov	cnt[0], 0
	mov	cnt[4], 0
	mov	cnt[8], 0
	pushad
	mov	esi, 0
	mov	ebx, eax
	mov	ecx, 3
again:
	cmp	esi, ebx
	jge	final
	push	edx
	mov	eax, [edx+4*esi]
	mov	edx, 0
	div	ecx
	inc	cnt[4*edx]
	pop	edx
	inc	esi
	jmp	again
final:
	popad
	ret
statistics endp

main proc
	mov	esi, 0
again:
	cmp	esi, 3
	jge	final
	lea	edx, arr[esi*4]
	call	readArray
	mov	n[esi*4], eax
	call	statistics
	lea	edx, cnt
	mov	eax, 3
	call	writeArray
	call	crlf
	inc	esi
	jmp	again
final:
	exit
main endp
end main