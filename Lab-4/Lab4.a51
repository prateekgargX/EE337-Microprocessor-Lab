org 0h
MOV R1,#50H
//Setting up the date
MOV 50H,#2
MOV 51H,#5
MOV 52H,#15
MOV 53H,#0
MOV 54H,#6
MOV 55H,#15
MOV 56H,#1
MOV 57H,#9
MOV 58H,#8
MOV 59H,#3
MOV 5AH,#15

ljmp main
org 100h
		
main : 
MOV B,#16 //To shift by 4 bits upon multiplication
MOV A,@R1
MUL AB
MOV P1,A
ACALL delay_1s
INC R1
CJNE R1,#5BH,main
MOV R1,#50H
sjmp main
			
delay_1s:
push 00h
mov r4, #5
h4: acall delay_200ms
djnz r4, h4
pop 00h
ret

delay_200ms:
push 00h
mov r3, #200
h3: acall delay_1ms
djnz r3, h3
pop 00h
ret

delay_1ms:
push 00h
mov r2, #4
h2: acall delay_250us
djnz r2, h2
pop 00h
ret

delay_250us:
push 00h
mov r0, #244
h1: djnz r0, h1
pop 00h
ret

end
				
