include irvine32.inc
.data
.code

gcd proc
;input: eax, edx
;output: eax
;uses: calculate the greatest comman divisor
	cmp eax, 0
	jne next
	mov eax, edx
	ret
	
next:
	push ebx
	push edx

again:
	cmp edx, 0
	je final
	mov ebx, edx
	mov edx, 0
	div ebx
	mov eax, ebx
	jmp again

final:
	pop edx
	pop ebx
	ret
gcd endp

main proc
	call readInt
	mov edx, eax
	call readInt
	call gcd
	call writeInt
	exit
main endp
end main