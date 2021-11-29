include irvine32.inc
.data
	bas dd ?
	n dd ?
.code

toChar proc
	cmp edx, 10
	jl lesten
	sub edx, 10
	add edx, 'A'
	ret
lesten:
	add edx, '0'
	ret
toChar endp

baseTurning proc
	push eax
	push ebx
	push ecx
	push edx

	cmp eax, 0
	je output0
	
	mov ecx, 0
	mov ebx, bas
again:
	mov edx, 0
	div ebx
	call toChar
	push edx
	add ecx, 1
	cmp eax, 0
	je output
	jmp again

output:
	cmp ecx, 0
	je final
	pop eax
	call writeChar
	sub ecx, 1
	jmp output

output0:
	mov al, '0'
	call writeChar

final:
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
baseTurning endp

main proc
	call readInt
	mov n, eax
	call readInt
	mov bas, eax
	mov eax, n
	call baseTurning
	exit
main endp
end main