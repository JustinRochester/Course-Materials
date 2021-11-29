include irvine32.inc
.data
	msg db 'Hello World!', 0
.code

hw proc
	push edx
	lea edx, msg
	call writeString
	pop edx
	ret
hw endp

main proc
	call hw
	exit
main endp
end main