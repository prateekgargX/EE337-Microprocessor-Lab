; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 30h
start:
      mov P2,#00h
      mov P1,#00h
	;initial delay for lcd power up
      acall delay
	  acall delay
	  
	  //START OF STATE 0
	  MOV P1,#255
	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#80h		  ;Put cursor on first row,0 column
	  acall lcd_command	  ;send command to LCD
	  acall delay
	  
	  mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  acall delay
	  
	  mov   dptr,#my_string1
	  acall lcd_sendstring
	  //END OF STATE 0
	  
	  ACALL delay_2s
	  
	  //START OF STATE 1-4
	  mov a,#80h		  ;Put cursor on first row,0 column
	  acall lcd_command	  ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  MOV P1,#128
	  
	  ACALL delay_2s
	  MOV A,#0FFH
	  MOV P1,A //Make P1 an input port
	  acall delay
	  MOV A,P1
	  MOV B,#10H
	  MUL AB
	  MOV B,A
	  //END STATE 1
	  MOV P1,#64
	  
	  ACALL delay_2s
	  MOV A,#0FFH
	  MOV P1,A //Make P1 an input port
	  acall delay
	  MOV A,P1
	  MOV R6,B
	  MOV B,#10H
	  DIV AB
	  MOV A,B
	  ADD A,R6
	  
	  MOV 30H,A
	  //END STATE 2
	  MOV P1,#32
	  
	  ACALL delay_2s
	  MOV A,#0FFH
	  MOV P1,A //Make P1 an input port
	  acall delay
	  MOV A,P1
	  MOV B,#10H
	  MUL AB
	  MOV B,A
	  //END STATE 3
	  MOV P1,#16
	  
	  ACALL delay_2s
	  MOV A,#0FFH
	  MOV P1,A //Make P1 an input port
	  acall delay
	  MOV A,P1
	  
	  MOV R6,B
	  MOV B,#10H
	  DIV AB
	  MOV A,B
	  ADD A,R6
	  
	  MOV 31H,A
	  //END STATE 4
	  
	  //START STATE 5
	  MOV P1,#0
	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#80h		  ;Put cursor on first row,0 column
	  acall lcd_command	  ;send command to LCD
	  acall delay
	  
	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
		
	  MOV A,30H
	  ACALL ASCII_rep

	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  acall delay
	  
	  mov   dptr,#my_string5
	  acall lcd_sendstring
	  acall delay
	  
	  mov   A,60H
	  acall lcd_senddata
	  mov   A,61H
	  acall lcd_senddata
	  acall delay
	  
	  mov   dptr,#my_string7  ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  mov   dptr,#my_string6
	  acall lcd_sendstring
	  acall delay
	  
	  MOV A,31H
	  ACALL ASCII_rep
	  mov   A,60H
	  acall lcd_senddata
	  mov   A,61H
	  acall lcd_senddata
	  acall delay
	  
	  MOV A,30H
	  MOV B,31H
	  MUL AB
	  MOV 50H,B
	  MOV 51H,A
	  ACALL delay_2s
	  //END OF STATE 5
	  
	  mov a,#80h		  ;Put cursor on first row,0 column
	  acall lcd_command	  ;send command to LCD
	  acall delay
	  
	  mov   dptr,#my_string8   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  MOV A,50H
	  ACALL ASCII_rep
	  
	  mov   A,60H
	  acall lcd_senddata
	  mov   A,61H
	  acall lcd_senddata
	  
	  MOV A,51H
	  ACALL ASCII_rep
	  mov   A,60H
	  acall lcd_senddata
	  mov   A,61H
	  acall lcd_senddata
	  acall delay
	  mov   A,#20H
	  acall lcd_senddata
	  acall delay
	  
	  		
here: sjmp here ;Infinite Loop 

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

;----------------------delay routine-----------------------------------------------------
delay_2s:
	acall delay_1s
	acall delay_1s
	ret
	
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
         DB "   EE337-2022",00H
my_string2:
		 DB "  Enter Inputs",00H
my_string3:
         DB " Reading Inputs",00H
my_string4:
		 DB "Computing Result",00H
my_string5:
         DB "Num1:",00H
my_string6:
		 DB "Num2:",00H
my_string7:
		 DB ", ",00H
my_string8:
		 DB "  Result = ",00H
			 
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

