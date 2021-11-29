include irvine32.inc
.data
.code

reverse proc
;input: eax
;output: eax
;usage: reverse digits to built a new number
	push ebx
	push ecx
	push edx

	mov ebx, 10
	mov ecx, 0
again:
	cmp eax, 0
	jle final
	mov edx, 0
	div ebx
	push eax
	push edx
	mov eax, ecx
	mov edx, 0
	mul ebx
	pop edx
	add eax, edx
	mov ecx, eax
	pop eax
	jmp again

final:
	mov eax, ecx
	pop edx
	pop ecx
	pop ebx
	ret
reverse endp

main proc
	call readInt
	call reverse
	call writeInt
	exit
main endp
end main