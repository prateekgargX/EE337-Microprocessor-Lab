ORG 0000H
//LOAD THE NUMBER TO BE CONVERTED

ljmp start

org 200h
start:
	  acall ASCII_rep
here: sjmp here ;Infinite Loop 

ASCII_rep:
	MOV A,30H
	MOV B,#10H
	DIV AB
	ACALL CONV_ASCII
	MOV 60H,A
	MOV A,B
	ACALL CONV_ASCII
	MOV 61H,A
	RET
	
CONV_ASCII:
	CJNE A,#0AH,CONV
	CONV:
	JC CONV_NUM
	ADD A,#55 
	RET
	CONV_NUM:
	ADD A,#48
	RET
	
END