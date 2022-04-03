#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code 

sbit LED=P1^7;
/*
Port P0.7 is used for the audio signal output
*/	
//Main function

void main(void)
{
	P1=0xFF; //Make an input port
	//Call initialization functions
	lcd_init();
	
	// Read input nibble here
	if (P1_0){
		lcd_write_string("       A");
		morse_a();
	}
	else if(P1_1){
		lcd_write_string("       B");
		morse_b();
	}
	else if(P1_2){
		lcd_write_string("       C");
		morse_c();
	}
	else if(P1_3){
		lcd_write_string("       D");
		morse_d();
	}
	else {
		lcd_write_string("       E");
		morse_e();
	}
	
	// Insert Priority Logic
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h
	// Write to LCD using function lcd_write_string() in side the condition as well
	
	
	// 
	while(1){}
	
}
