ORG 0000H
//SET THE TIME PERIOD(T) HERE
MOV 30H,#2
ljmp start
org 000BH
RETI
org 200h
start: 	
	MOV R4,30H
	MOV P1,#0FFH
	H2: ACALL DELAY_1S
	DJNZ R4, H2
	
	MOV R4,30H
	MOV P1,#00H
	H3: ACALL DELAY_1S
	DJNZ R4, H3
	SJMP START

DELAY_1s:
	//SINCE WE ARE USING 24MHz CLOCK SIGNAL ON BOARD, 
	//THE FREQUENCY WITH WHICH THE TIMER INCREMENTS IS 24MHz/12= 2MHz 
	//TIME INC PERIOD=0.5us. TO GENERATE 1 SEC DELAY, TIMER HAS TO RUN 2*E6 TIMES 
	//N IS SET TO 50000D=C350H, SO PROP_DELAY_N CAUSES DELAY OF 25ms
	MOV R6,#3CH
	MOV R7,#0B0H
	MOV R5,#40
	H4: ACALL PROP_DELAY_N
	DJNZ R5, H4
	RET

PROP_DELAY_N:
	//T0 IS USED
	;SETB IE.7 //INTERRUPTS ARE ENABLED
	;SETB IE.1 //INTERRUPTS ARE ENABLED FROM T0
	MOV TMOD,#01 //T0 OPERATED IN MODE 1
	//ASSUMING N IS STORED AT R6 AND R7. R6 IS HIGHER NIBBLE
	MOV TH0,R6
	MOV TL0,R7
	
	SETB TR0 //T0 ENABLED
	LOOP: JNB TF0,LOOP
	CLR TR0
	CLR TF0
	RET

END