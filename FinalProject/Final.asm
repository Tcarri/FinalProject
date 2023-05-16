TITLE MASM main      (main.asm) 
INCLUDE Irvine32.inc  

.const 
MAX_VAL EQU 5

.data  
decimalArray  word 5 dup (0)
decimalArray2 word 5 dup (0)
decimalArrayResult word ?


stringbuffer BYTE 50 DUP(0)
storedmsg BYTE "Result: ",0
storenegsign BYTE "- ",0
lenghtOfnum  EQU $ - number1    ;to make sure numbers are the same length


Pnumber1 BYTE "Enter Number1 0-9 >",0 
Pnumber2 BYTE "Enter Number2 0-9 >",0 
Pnumber4 BYTE "Invalid entry ",0


 .code
 
MAIN    PROC 

 JUMPTODOAGAIN:
  call crlf

  mov edx, OFFSET  Pnumber1        ;load location of buffer 
  call writestring                 ;send message to monitor

  mov ecx,5
  mov eax,0 
  mov edi, OFFSET decimalArray
  add edi, 10
  
  input:
    xor ax,ax
    call readchar
    call writechar
    sub al,30h
    mov [edi],al
    sub edi,2
    LOOP input    ;inc cx and checks if cx>0
    call crlf

  mov edx, OFFSET  Pnumber2       ;load location of buffer 
  call writestring 
  
  mov ecx,5
  mov eax,0
  mov esi, OFFSET decimalArray2
  add esi,10

  input2:
    xor ax,ax
    call readchar
    call writechar
    sub al,30h
    mov [esi],al
    sub esi,2
    LOOP input2    ;inc cx and checks if cx>0
    call crlf

mov ecx,05
add di,2
add si,2
mov ax,0
mov bx,0
mov edx,0
SumLoop:     ;this loop adds all if there is no carry and sends to display loop
     add dh,01
     mov eax,0 
     mov ebx,0
     mov al,[edi]; gets first number inputed
     mov bl,[esi]; gets second number inputed
     adc ax,bx
     cmp ax,09
     jg IF_CARRY
     add al,30h
     mov [edi],al
     ;call writechar
     add di,2
     add si,2
     cmp dh,05 
     je DISPLAYRESULT
     cmp cx,00
     jle DISPLAYRESULT
     Loop SumLoop
  
     
IF_CARRY:          ; this loop add with a carry and sends to after carry loop if ax result is <9
   mov bl,10
   sub ax,bx
   add al,30h
   ;call writechar
   mov [edi],al
   add di,2
   add si,2
   cmp dh,05 
   je DISPLAYRESULTWITHCARRY
   cmp cx,0
   jle DISPLAYRESULTWITHCARRY
   Loop AddAfterCarry


AddAfterCarry:
     add dh,1
     mov eax,0 
     mov ebx,0
     mov al,[edi]; gets first number inputed
     mov bl,[esi]; gets second number inputed
     mov dl,01
     add al,dl
     adc ax,bx
     cmp ax,09
     jg IF_CARRY
     add al,30h
     mov [edi],al
     ;call writechar
     add di,2
     add si,2
     dec cx
     cmp dh,05 
     je DISPLAYRESULTWITHCARRY
     cmp cx,00
     jle DISPLAYRESULTWITHCARRY
     jmp SumLoop


DISPLAYRESULT:

  mov ecx,05
  mov edx, OFFSET storedmsg
  call writestring
  sub edi,2
  PRINT_NEXT:
  mov al,[edi]
  sub edi,2    
  call writechar
  Loop PRINT_NEXT
  JMP JUMPTODOAGAIN

DISPLAYRESULTWITHCARRY:
  cmp bx,10
  jl DISPLAYRESULT
  mov ecx,05
  mov edx, OFFSET storedmsg
  call writestring
  mov al,01
  add al,30h
  call writechar
  sub edi,2
  PRINT_NEXT2:
  mov al,[edi]
  sub edi,2    ;shr edi,1 nope...
  call writechar
  Loop PRINT_NEXT2

  JMP JUMPTODOAGAIN
  

  main ENDP
  END main