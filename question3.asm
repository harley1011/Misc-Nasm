section .data
msg db 'The value of variable A is '
a db '3'
  db ' and B is '
b db '7'
  db 0xa
len equ $-msg

section .text
	global _start
_start:
	call output
	
	push dword[a]		;Push values onto stack
	push dword[b]
	call swapPassByValue
	call output

	mov byte [a],'3'		;Reset Values to default so we can do
	mov byte [b],'7'		;pass by reference now
	push a			;Push address of a and b onto stack
	push b
	call swapPassByReference
	call output
	
	mov eax,1
	int 0x80

output:	
	mov eax,4		;outputs a and b value
	mov ebx,1
	mov ecx,msg
	mov edx,len
	int 0x80
	ret

swapPassByValue:
	push ebp		;Save registers 
	push eax
	mov ebp,esp
	mov eax,[ebp+12]	;Place data in stack in eax
	mov ebx,[ebp+16]	;Place data in stack in ebx
	mov [a],al		;Use direct addressing to place al into a
	mov [b],bl		; place value in bl into b
	pop eax
	pop ebp
	ret			;return back to main

swapPassByReference:
	push ebp		;Save registers
	push eax
	push ebx
	mov ebp,esp
	mov eax,[ebp+16]	;Place data in stack on register
	mov ebx,[ebp+20]
	mov edx,[eax]
	mov ecx,[ebx]
	mov [ebx],dl		; use indirect register to acess a and b
	mov [eax],cl		; store value in dl, and cl
	pop ebx
	pop eax
	pop ebp			;return back to main
	ret