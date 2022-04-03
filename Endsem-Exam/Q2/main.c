#include <at89c5131.h>
#include "endsem.h"

char S_str[6]= {0,0,0,0,0,0};   //String for Balance Sita
char G_str[6] = {0,0,0,0,0,0};  //String for Balance Gita
char n500_s[3]= {0,0,0};    // STRING FOR 500RS NOTE
char n100_s[3]= {0,0,0};    // STRING FOR 100RS NOTE

char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY

void msdelay(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<382;j++);
	}
}

unsigned int string_to_int_2(unsigned char *temp_str_data)
{	
		unsigned int num=0;
	  temp_str_data[0]-=48;
	  temp_str_data[1]-=48;
		num=(unsigned int)temp_str_data[0]*10+(unsigned int)temp_str_data[1];
		return num;
}

unsigned int string_check(unsigned char *temp_str_data)
{
		if(temp_str_data[0]>=48 && temp_str_data[0]<58 && temp_str_data[1]>=48 && temp_str_data[1]<58 ) return 1;
		return 0;
}
//Main function

//-------------------------------------------------
void main(void)
{
	unsigned char ch1=0;
	unsigned char ch2=0;
	
	unsigned int G_Bal=10000;
	unsigned int S_Bal=10000;
	
	char Amnt[2]= {0,0};   
	unsigned int Amnt_int=0;
	
	unsigned int Num_5=0;
	unsigned int Num_1=0;
	
	char Num_5_str[2]={0,0};
	char Num_1_str[2]={0,0};
	
	uart_init();            // Please finish this function in endsem.h 
  transmit_string("Press A for Account display and W for withdrawing cash\r\n");  
		while (1)
    {
			//Receive a character
			ch1 = receive_char();
		
			//Decide which test function to run based on character sent
      //Displays the string on the terminal software
			switch(ch1)
			{
				case 'A':transmit_string("Hello, Please enter Account Number\r\n");
								 ch2 = receive_char();
								 switch(ch2)
								 {
									 case '1':transmit_string("Account Holder: Sita\r\n");
														transmit_string("Account Balance:");
														int_to_string(S_Bal,S_str);
														transmit_string(S_str);
														transmit_string("\r\n");
														msdelay(50);				
														break;
									 case '2':transmit_string("Account Holder: Gita\r\n");
														transmit_string("Account Balance:");
														int_to_string(G_Bal,G_str);
														transmit_string(G_str);
														transmit_string("\r\n");
														msdelay(50);					
														break;	
										default:transmit_string("No such account, please enter valid details\r\n");
														break;
				
								 }
								 transmit_string("Press A for Account display and W for withdrawing cash\r\n");  
								 break;
				case 'W':transmit_string("Withdraw state, enter account number\r\n");
								 ch2 = receive_char();
								 switch(ch2)
								 {
									 case '1':transmit_string("Account Holder: Sita\r\n");
														transmit_string("Account Balance:");
														int_to_string(S_Bal,S_str);
														transmit_string(S_str);
														transmit_string("\r\n");
														transmit_string("Enter Amount, in hundreds\r\n");  
														Amnt[0]=receive_char();
														Amnt[1]=receive_char();
														if(string_check(Amnt)){
															Amnt_int=string_to_int_2(Amnt);
															if(S_Bal>=Amnt_int){
																S_Bal-=Amnt_int*100;
																Num_5=Amnt_int/5;
																Num_1=Amnt_int%5;
																transmit_string("Remaining Balance:");
																int_to_string(S_Bal,S_str);
																transmit_string(S_str);
																transmit_string("\r\n");
																transmit_string("500 Notes:");
																int_to_string_2(Num_5,Num_5_str);
																transmit_string(Num_5_str);
																transmit_string(",");
																transmit_string("100 Notes:");
																int_to_string_2(Num_1,Num_1_str);
																transmit_string(Num_1_str);
																transmit_string("\r\n");
															}
															else transmit_string("Insufficient Funds\r\n");  
														
														}
														else{
														transmit_string("Invalid Amount\r\n");  
														}
														break;
									 case '2':transmit_string("Account Holder: Gita\r\n");
														transmit_string("Account Balance:");
														int_to_string(G_Bal,G_str);
														transmit_string(G_str);
														transmit_string("\r\n");	
														transmit_string("Enter Amount, in hundreds\r\n");  
														Amnt[0]=receive_char();
														Amnt[1]=receive_char();
														if(string_check(Amnt)){
															Amnt_int=string_to_int_2(Amnt);
															if(G_Bal>=Amnt_int){
																G_Bal-=Amnt_int*100;
																Num_5=Amnt_int/5;
																Num_1=Amnt_int%5;
																transmit_string("Remaining Balance:");
																int_to_string(G_Bal,G_str);
																transmit_string(G_str);
																transmit_string("\r\n");
																transmit_string("500 Notes:");
																int_to_string_2(Num_5,Num_5_str);
																transmit_string(Num_5_str);
																transmit_string(",");
																transmit_string("100 Notes:");
																int_to_string_2(Num_1,Num_1_str);
																transmit_string(Num_1_str);
																transmit_string("\r\n");
															}
															else transmit_string("Insufficient Funds\r\n");  
														
														}
														else{
														transmit_string("Invalid Amount\r\n");  
														}
														break;	
									default:transmit_string("No such account, please enter valid details\r\n");
														break;
				
								 }
								 break;
				case 'a':transmit_string("Hello, Please enter Account Number\r\n");
								 ch2 = receive_char();
								 switch(ch2)
								 {
									 case '1':transmit_string("Account Holder: Sita\r\n");
														transmit_string("Account Balance:");
														int_to_string(S_Bal,S_str);
														transmit_string(S_str);
														transmit_string("\r\n");
														msdelay(50);				
														break;
									 case '2':transmit_string("Account Holder: Gita\r\n");
														transmit_string("Account Balance:");
														int_to_string(G_Bal,G_str);
														transmit_string(G_str);
														transmit_string("\r\n");
														msdelay(50);					
														break;	
										default:transmit_string("No such account, please enter valid details\r\n");
														break;
				
								 }
								 transmit_string("Press A for Account display and W for withdrawing cash\r\n");  
								 break;
				case 'w':transmit_string("Withdraw state, enter account number\r\n");
								 ch2 = receive_char();
								 switch(ch2)
								 {
									 case '1':transmit_string("Account Holder: Sita\r\n");
														transmit_string("Account Balance:");
														int_to_string(S_Bal,S_str);
														transmit_string(S_str);
														transmit_string("\r\n");
														transmit_string("Enter Amount, in hundreds\r\n");  
														Amnt[0]=receive_char();
														Amnt[1]=receive_char();
														if(string_check(Amnt)){
															Amnt_int=string_to_int_2(Amnt);
															if(S_Bal>=Amnt_int){
																S_Bal-=Amnt_int*100;
																Num_5=Amnt_int/5;
																Num_1=Amnt_int%5;
																transmit_string("Remaining Balance:");
																int_to_string(S_Bal,S_str);
																transmit_string(S_str);
																transmit_string("\r\n");
																transmit_string("500 Notes:");
																int_to_string_2(Num_5,Num_5_str);
																transmit_string(Num_5_str);
																transmit_string(",");
																transmit_string("100 Notes:");
																int_to_string_2(Num_1,Num_1_str);
																transmit_string(Num_1_str);
																transmit_string("\r\n");
															}
															else transmit_string("Insufficient Funds\r\n");  
														
														}
														else{
														transmit_string("Invalid Amount\r\n");  
														}
														break;
									 case '2':transmit_string("Account Holder: Gita\r\n");
														transmit_string("Account Balance:");
														int_to_string(G_Bal,G_str);
														transmit_string(G_str);
														transmit_string("\r\n");	
														transmit_string("Enter Amount, in hundreds\r\n");  
														Amnt[0]=receive_char();
														Amnt[1]=receive_char();
														if(string_check(Amnt)){
															Amnt_int=string_to_int_2(Amnt);
															if(G_Bal>=Amnt_int){
																G_Bal-=Amnt_int*100;
																Num_5=Amnt_int/5;
																Num_1=Amnt_int%5;
																transmit_string("Remaining Balance:");
																int_to_string(G_Bal,G_str);
																transmit_string(G_str);
																transmit_string("\r\n");
																transmit_string("500 Notes:");
																int_to_string_2(Num_5,Num_5_str);
																transmit_string(Num_5_str);
																transmit_string(",");
																transmit_string("100 Notes:");
																int_to_string_2(Num_1,Num_1_str);
																transmit_string(Num_1_str);
																transmit_string("\r\n");
															}
															else transmit_string("Insufficient Funds\r\n");  
														
														}
														else{
														transmit_string("Invalid Amount\r\n");  
														}
														break;	
									default:transmit_string("No such account, please enter valid details\r\n");
														break;
				
								 }
								 break;	
				default:transmit_string("No such action possible. Please Enter A or W\r\n");
								 break;
				
			}
			msdelay(100);				
    }
}


