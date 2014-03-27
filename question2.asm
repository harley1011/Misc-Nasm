section .text--
	global _start
_start:	
	mov edx,msgLen
	mov ecx,msg
	mov ebx,1
	mov eax,4
	int 0x80
next: 
	mov ax,[count]
	add ax,'0'
    		                ;Place counter hex value into register
	mov [prompt+13],ax	;Position number counter in output
	sub ax,'0'
	inc ax
	mov [count],ax
	
	mov edx,promptLen	;Output message to enter number
	mov ecx,prompt
	mov ebx,1
	mov eax,4
	int 0x80

	mov ecx,number
	mov eax,3		;Read in two digit number
	mov ebx,2
	mov edx,3
	int 0x80

	xor eax,eax		;Store the number into our array
	mov ax,[count]
	dec eax
	mov ecx,[number]	
	mov [numberArray + eax * 3],ecx

	mov bl,[numberArray + eax * 3]
	
	xor eax,eax		;Convert second digit ascii value to BCD
	mov al,bl
	sub al,'0'
	mov ah,10
	mul ah

	add [total],ax
	
	xor eax,eax		;Convert first digit ascii value to BCD
	mov al,[number+1]
	sub al,'0'
	add [total],al

	mov ax,[count]
	cmp ax,10		;Check if ax is 10 if not loop again
	jnz next

	mov eax,4		;Print out all the numbers entered
	mov ebx,1
	mov ecx,numberArray
	mov edx,30
	int 0x80

	xor ebx,ebx		
	xor eax,eax
	mov ax,[total]		;calculate the average
	mov bl,10
	div bl
	mov [averageValue],al	;Store the quoitent
	add ah,'0'
	mov [averageValueDecimal],ah ;Store the remainder
	
	xor eax,eax
	mov edi,2
	mov ax,[total]

convert:
	mov bx,10		;Convert the integer value total to ascii
	xor dx,dx
	div bx
	add dl,'0'
	mov [totalString+edi],dl
	dec edi
	cmp ax,0
	jne convert

	xor eax,eax		;Convert the integer value avervalue to ascii
	mov al,[averageValue]
	mov bl,10
	div bl
	add ah,'0'
	mov [averageValue+1],ah
	add al,'0'
	mov [averageValue],al
	mov byte [averageValue+2],'.'


	
print:
	mov eax,4		;Here we print out the sum and average value
	mov ebx,1
	mov ecx,totalString
	mov edx,3
	int 0x80

	mov eax,4
	mov ebx,1
	mov ecx,sumString
	mov edx,12
	int 0x80


	mov ecx,averageValue
	mov edx,3 
	mov eax,4
	mov ebx,1
	int 0x80

	mov ecx,averageValueDecimal
	mov edx,2
	mov eax,4
	mov ebx,1
	int 0x80
	
	mov ecx,averageValueString
	mov edx,22
	mov eax,4
	mov ebx,1
	int 0x80
	
	mov eax,1
	int 0x80

section .data
count dw 0
msg db 'Enter ten two digit numbers',0xa
msgLen equ $ - msg
prompt db 'Enter number   :'
promptLen equ $ - prompt
total dw 0
      db ' ',0xa
sumString db ' is the sum',0xa
averageValueString db ' is the average value',0xa
	
section .bss
numberArray resb 30
number resb 3
totalString resb 4
averageValue resb 3
averageValueDecimal resb 1