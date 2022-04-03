; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
MOV 70H,#12H
MOV 71H,#34H
LJMP START

org 30h
START:
	;initial delay for lcd power up
	ACALL DELAY
	ACALL DELAY
	ACALL lcd_init      ;initialise LCD
	MOV A,#80h		    ;Put cursor on first row,0 column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	
	MOV DPTR,#my_string1  ;Load DPTR with sring1 Addr
	ACALL lcd_sendstring  ;call text strings sending routine
	ACALL delay
	
	MOV A,#0C0h		  ;Put cursor on second row,0 column
	ACALL lcd_command
	ACALL delay
	  
	MOV DPTR,#my_string2
	ACALL lcd_sendstring
	
	MOV A,#8Ah		    ;Put cursor on first row,11th column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY

	MOV A,#31H
	ACALL lcd_senddata
	
	MOV A,70H
	SWAP A
	MOV P1,A
	
	MOV A,#0CAh		  ;Put cursor on second row,11TH column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	ACALL PORT_LCD
	ACALL DELAY_1s
	//--------------------------END-OF-LEVEL-1--------------------------//
	MOV A,#8Ah		    ;Put cursor on first row,11th column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY

	MOV A,#32H
	ACALL lcd_senddata
	
	MOV A,70H
	MOV P1,A
	
	MOV A,#0CAh		  ;Put cursor on second row,11TH column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	ACALL PORT_LCD
	ACALL DELAY_1s
	//--------------------------END-OF-LEVEL-2--------------------------//
	MOV A,#8Ah		    ;Put cursor on first row,11th column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY

	MOV A,#33H
	ACALL lcd_senddata
	
	MOV A,71H
	SWAP A
	MOV P1,A
	
	MOV A,#0CAh		  ;Put cursor on second row,11TH column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	ACALL PORT_LCD
	ACALL DELAY_1s
	//--------------------------END-OF-LEVEL-3--------------------------//
	MOV A,#8Ah		    ;Put cursor on first row,11th column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY

	MOV A,#34H
	ACALL lcd_senddata
	
	MOV A,71H
	MOV P1,A
	
	MOV A,#0CAh		  ;Put cursor on second row,11TH column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	ACALL PORT_LCD
	ACALL DELAY_1s
	//--------------------------END-OF-LEVEL-4--------------------------//
	
	
	AJMP START

PORT_LCD:
	
	MOV A,#30H
	JNB P1.7, SKIP_TO_THE_GOOD_PART_1
	ADD A,#1
	SKIP_TO_THE_GOOD_PART_1:
	ACALL LCD_SENDDATA
	
	MOV A,#30H
	JNB P1.6, SKIP_TO_THE_GOOD_PART_2
	ADD A,#1
	SKIP_TO_THE_GOOD_PART_2:
	ACALL LCD_SENDDATA
	
	MOV A,#30H
	JNB P1.5, SKIP_TO_THE_GOOD_PART_3
	ADD A,#1
	SKIP_TO_THE_GOOD_PART_3:
	ACALL LCD_SENDDATA
	
	MOV A,#30H
	JNB P1.4, SKIP_TO_THE_GOOD_PART_4
	ADD A,#1
	SKIP_TO_THE_GOOD_PART_4:
	ACALL LCD_SENDDATA
	
	RET

org 200h
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------DELAY SUBROUTINES-----------------------------------------------------
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

delay:
	push 0
	push 1
    mov r0,#1
	loop2:mov r1,#255
	loop1:djnz r1,loop1
	djnz r0,loop2
	pop 1
	pop 0 
	ret
;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB "    LEVEL ",00H
my_string2:
		 DB "   VALUE: ",00H
;-------------------------------ASCII-CONVERTER_SUBROUTINE------------------------------------
ASCII_rep:
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

end

