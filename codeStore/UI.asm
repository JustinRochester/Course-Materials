include irvine32.inc
.data
	bas dd 0
	n dd ?
	Choice dd 0, 2, 8, 10, 16
	msg2b db '1）2进制', 0
	msg8b db '2）8进制', 0
	msg10b db '3）10进制', 0
	msg16b db '4）16进制', 0
	msgInput db '请输入选项：', 0
	msgNumber db '请输入无符号数：', 0
.code

readBase proc
	push eax
	push ebx

	call readInt
	cmp eax, 4
	jg illegal
	mov ebx, [Choice+eax*4]
	mov bas, ebx

illegal:
	
	pop ebx
	pop eax
	ret
readBase endp

UI proc
	push edx
	lea edx, msg2b
	call writeString
	call crlf
	
	lea edx, msg8b
	call writeString
	call crlf
	
	lea edx, msg10b
	call writeString
	call crlf
	
	lea edx, msg16b
	call writeString
	call crlf
	
	lea edx, msgInput
	call writeString
	call crlf

	pop edx
	ret
UI endp

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

.code
main proc
	call UI

	call readBase

	lea edx, msgNumber
	call writeString
	call crlf

	call readInt
	call baseTurning
	exit
main endp
end main