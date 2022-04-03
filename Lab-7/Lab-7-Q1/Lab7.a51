; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
SW1 	 equ P1.0  ;SWITCH INPUT
LED 	 equ P1.4  ;LED OUTPUT
ORG 0000H
LJMP START
//INTERRUPT SERVICE ROUTINE FOR T0
ORG 000BH
INC R0 
RETI

org 30h
START:
	MOV P1,#00H
	SETB EA //GLOBAL ENABLE INTERRUPTS
	SETB ET0 //T1 ENABLE INTERRUPTS
	MOV TMOD,#01H //T0 OPERATED IN MODE 1
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
	
	MOV A,#0C0h		  ;Put cursor on second row,0 column
	ACALL lcd_command
	ACALL DELAY
	  
	MOV DPTR,#my_string2
	ACALL lcd_sendstring
	ACALL DELAY
	//2-SEC DELAY HERE
	ACALL DELAY_1s
	ACALL DELAY_1s
	
	MOV R0,#00H
	SETB TR0 //T0 ENABLED
	MOV P1,#00010001B
	LOOP_SW1:JNB SW1,LOOP_SW1
	//ACALL DELAY_200MS //EXPERIMENTAL SETUP
	CLR TR0
	//CLR LED
	MOV P1,#00H
	MOV R1,TH0
	MOV R2,TL0
	
	MOV A,#80h		    ;Put cursor on first row,0 column
	ACALL lcd_command	;send command to LCD
	ACALL DELAY
	
	MOV DPTR,#my_string3  ;Load DPTR with sring1 Addr
	ACALL lcd_sendstring  ;call text strings sending routine
	ACALL DELAY
	
	MOV A,#0C0h		  ;Put cursor on second row,0 column
	ACALL lcd_command
	ACALL DELAY
	  
	MOV DPTR,#my_string4
	ACALL lcd_sendstring
	ACALL DELAY
	
	MOV A,R0
	ACALL LCD_SEND_NUM_A
	MOV A,R1
	ACALL LCD_SEND_NUM_A
	MOV A,R2
	ACALL LCD_SEND_NUM_A
	ACALL DELAY_5S
	MOV TH0,#00H
	MOV TL0,#00H
	AJMP START

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

;-----------------------Number sending routine-------------------------------------
LCD_SEND_NUM_A:
	  ACALL ASCII_rep
	  mov   A,60H
	  acall lcd_senddata
	  mov   A,61H
	  acall lcd_senddata
	  acall delay
RET
;----------------------DELAY SUBROUTINES-----------------------------------------------------
delay_5s:
	acall delay_2s
	acall delay_2s
	acall delay_1s
	ret

delay_2s:
	acall delay_1s
	acall delay_1s
	ret
	
delay_1s:
	push 4
	mov r4, #5
	h4: acall delay_200ms
	djnz r4, h4
	pop 4
	ret

delay_200ms:
	push 3
	mov r3, #200
	h3: acall delay_1ms
	djnz r3, h3
	pop 3
	ret

delay_1ms:
	push 2
	mov r2, #4
	h2: acall delay_250us
	djnz r2, h2
	pop 2
	ret

delay_250us:
	push 0
	mov r0, #244
	h1: djnz r0, h1
	pop 0
	ret

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
         DB "   Toggle SW1",00H
my_string2:
		 DB "  If LED glows",00H
my_string3:
		 DB " Reaction Time",00H
my_string4:
		 DB " Count is ",00H
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

