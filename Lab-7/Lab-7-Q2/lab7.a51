; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
SOUND 	 equ P0.7  ;SOUND OUTPUT

ORG 0000H
LJMP START
ORG 000BH
LJMP T0ISR
org 30h
T0ISR:
	CPL SOUND
	CLR TR0
	MOV A,@R0
	CPL A
	INC A
	MOV TL0,A
	INC R0
	MOV A,@R0
	CPL A
	MOV TH0,A
	DEC R0
	SETB TR0
	RETI

START:
	//STORING UP THE NOTES
	MOV 50H,#0C1H
	MOV 51H,#11H
	MOV 52H,#0D0H
	MOV 53H,#0FH
	MOV 54H,#49H
	MOV 55H,#0DH
	MOV 56H,#8EH
	MOV 57H,#0AH
	MOV 58H,#0D6H
	MOV 59H,#0BH
	
	MOV TMOD,#00010001B //T1,T0 OPERATED IN MODE 1
	SETB EA //GLOBAL ENABLE INTERRUPTS
	SETB ET0 //T0 ENABLE INTERRUPTS
	ACALL LCD_SETUP
	
	MOV R0,#50H
	ACALL START_PLAYING
	SING_SONG:
	MOV R0,#50H
	MOV R6,#03H
	ACALL DELAY_R6x250ms
	
	MOV R0,#52H
	MOV R6,#03H
	ACALL DELAY_R6x250ms
	
	MOV R0,#54H
	MOV R6,#03H
	ACALL DELAY_R6x250ms
	
	MOV R0,#52H
	MOV R6,#03H
	ACALL DELAY_R6x250ms
	
	MOV R0,#56H
	MOV R6,#04H
	ACALL DELAY_R6x250ms
	
	SILENCE: CLR TR0
	MOV R6,#02H
	ACALL DELAY_R6x250ms

	MOV R0,#56H
	ACALL START_PLAYING
	MOV R6,#04H
	ACALL DELAY_R6x250ms
	
	MOV R0,#58H
	MOV R6,#04H
	ACALL DELAY_R6x250ms
	
	JMP SING_SONG

org 200h
DELAY_R6x250ms:
	H3: ACALL DELAY_250ms
	DJNZ R6, H3
	RET
DELAY_250ms:
	//SINCE WE ARE USING 24MHz CLOCK SIGNAL ON BOARD, 
	//THE FREQUENCY WITH WHICH THE TIMER INCREMENTS IS 24MHz/12= 2MHz 
	//TIME INC PERIOD=0.5us. TO GENERATE 1 SEC DELAY, TIMER HAS TO RUN 2*E6 TIMES 
	//N IS SET TO 50000D=C350H, SO PROP_DELAY_N CAUSES DELAY OF 25ms
	PUSH 7
	MOV R7,#10
	H4: ACALL PROP_DELAY_N_T1
	DJNZ R7, H4
	POP 7
	RET

PROP_DELAY_N_T1:
	//ASSUMING N IS STORED AT R6 AND R7. R6 IS HIGHER NIBBLE
	MOV TH1,#3CH
	MOV TL1,#0B0H
	SETB TR1 //T0 ENABLED
	LOOP: JNB TF1,LOOP
	CLR TR1
	CLR TF1
	RET

;------------------------Notes----------------------------------------------------
START_PLAYING:
	MOV TL0,#0FFH
	MOV TH0,#0FFH
	SETB TR0 //T0 ENABLED
	RET
;------------------------LCD Initialisation routine----------------------------------------------------
LCD_SETUP:

	;initial delay for lcd power up
	ACALL DELAY
	ACALL DELAY
	ACALL lcd_init      ;initialise LCD
	MOV A,#80h		    ;Put cursor on first row,0 column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	
	MOV DPTR,#my_string1  ;Load DPTR with sring1 Addr
	ACALL lcd_sendstring  ;call text strings sending routine
	ACALL DELAY
	
	RET

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
         DB " ROLLING TIME",00H
END
