
/*
* ELEC 291/292 - Project 2
* Team: A6
* C code for PIC32 microcontroller system
*/

#include <XC.h>
#include <sys/attribs.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#pragma config FNOSC = FRCPLL       // Internal Fast RC oscillator (8 MHz) w/ PLL
#pragma config FPLLIDIV = DIV_2     // Divide FRC before PLL (now 4 MHz)
#pragma config FPLLMUL = MUL_20     // PLL Multiply (now 80 MHz)
#pragma config FPLLODIV = DIV_2     // Divide After PLL (now 40 MHz) see figure 8.1 in datasheet for more info
#pragma config FWDTEN = OFF         // Watchdog Timer Disabled

#pragma config FPBDIV = DIV_1       // PBCLK = SYCLK

#define SYSCLK 40000000L
#define FREQ 2L // 2Hz or 0.5 seconds interrupt rate
#define Baud2BRG(desired_baud) ( (SYSCLK / (16*desired_baud))-1)

// Function Prototypes
int SerialTransmit(const char *buffer);
unsigned int SerialReceive(char *buffer,unsigned int max_size);
int UART2Configure( int baud);
void waitms(int ms);
unsigned char distanceIR();
void delaysignal();
// Variables
volatile unsigned char pwm_count=0;
volatile unsigned char turn;
volatile unsigned char turningcount=0;

volatile int pwm0 = 0;
volatile int pwm1 = 0;
volatile int pwm2 = 0;
volatile int pwm3 = 0;

void ADCConf(void)
{
	AD1CON1CLR = 0x8000;    // disable ADC before configuration
	AD1CON1 = 0x00E0;       // internal counter ends sampling and starts conversion (auto-convert), manual sample
	AD1CON2 = 0;            // AD1CON2<15:13> set voltage reference to pins AVSS/AVDD
	AD1CON3 = 0x0f01;       // TAD = 4*TPB, acquisition time = 15*TAD
	AD1CON1SET=0x8000;      // Enable ADC
}

int ADCRead(char analogPIN)
{
	AD1CHS = analogPIN << 16;    // AD1CHS<16:19> controls which analog pin goes to the ADC
	
	AD1CON1bits.SAMP = 1;        // Begin sampling	
	while(AD1CON1bits.SAMP);     // wait until acquisition is done
	while(!AD1CON1bits.DONE);    // wait until conversion done
	
	return ADC1BUF0;             // result stored in ADC1BUF0
}

void __ISR(_TIMER_1_VECTOR, IPL5SOFT) Timer1_Handler(void)
{
	IFS0CLR=_IFS0_T1IF_MASK; // Clear timer 1 interrupt flag, bit 4 of IFS0
	pwm_count++;
	if(pwm_count > 100) pwm_count = 0;

	/* ---- Wheel pin assignment ----
	*	Pin A2 - Right, Backward			 +--+	  ^ Forward	
	*	Pin A3 - Right, Forward				 |  |	  |
	*	PIN B2 - Left, Backward				 |  |	  |
	*	PIN B3 - Left, Forward			  L	(|__|) R  V Backward
	*/
	LATAbits.LATA2 = pwm_count>pwm0?0:1;
	LATAbits.LATA3 = pwm_count>pwm1?0:1;
	LATBbits.LATB2 = pwm_count>pwm2?0:1;
	LATBbits.LATB3 = pwm_count>pwm3?0:1;
}

void SetupTimer1 (void)
{
	// Explanation here:
	// https://www.youtube.com/watch?v=bu6TTZHnMPY
	__builtin_disable_interrupts();
	
	//PR1 =(SYSCLK/(FREQ*256))-1; // since SYSCLK/FREQ = PS*(PR1+1)
	PR1 = 1;		// MAX clock speed (pre-scaler ZERO)
	
	TMR1 = 0;
	T1CONbits.TCKPS = 3; // Pre-scaler: 256
	T1CONbits.TCS = 0; // Clock source
	T1CONbits.ON = 1;
	IPC1bits.T1IP = 5;
	IPC1bits.T1IS = 0;
	IFS0bits.T1IF = 0;
	IEC0bits.T1IE = 1;
	
	INTCONbits.MVEC = 1; //Int multi-vector
	__builtin_enable_interrupts();
}
void SetupTimer3 (void)
{
	__builtin_disable_interrupts();
	T3CONCLR;
	T3CON = 0x0; // Stop the timer and clear the control register,
	// prescaler at 1:1,internal clock source
	TMR3 = 0x0; // Clear the timer register
	PR3 = 65535; // Load the period register

	T3CONbits.TCKPS = 7; // Pre-scaler: 256
	T3CONbits.TCS = 0; // Clock source
	T3CONbits.ON = 1;
	IPC3bits.T3IP = 2;
	IPC3bits.T3IS = 0;
	IFS0bits.T3IF = 0;
	IEC0bits.T3IE = 1;
	__builtin_enable_interrupts();
	
}
void __ISR(_TIMER_3_VECTOR, IPL5SOFT) TIMER3_Hanlder(void)
{
	IFS0CLR=_IFS0_T3IF_MASK; // Clear timer 3 interrupt flag, bit 4 of IFS0
/*	
	if(turn ==0)
	{
	LATAbits.LATA0 = !LATAbits.LATA0;
	LATBbits.LATB5 = !LATBbits.LATB5;
	LATBbits.LATB0 = !LATBbits.LATB0;
	}
	else{
	LATBbits.LATB13 = !LATBbits.LATB13;
	LATBbits.LATB14 = !LATBbits.LATB14;
	LATBbits.LATB15 = !LATBbits.LATB15;
	}
	
*/	
	if(turn == 0)
	{
		if(turningcount < 2)
		{
		LATAbits.LATA0 = 0;	
		LATBbits.LATB0 = 1;
		LATBbits.LATB5 = 0;
		}	
		else if(turningcount < 3)
		{
		LATAbits.LATA0 = 0;
		LATBbits.LATB0 = 1;
		LATBbits.LATB5 = 1;
		}
		else if(turningcount < 4)
		{
		LATBbits.LATB5 = 1;
		LATBbits.LATB0 = 1;
		LATAbits.LATA0 = 1;
		}
	}
	else if(turn == 1)
	{
		if(turningcount < 2)
		{
		LATBbits.LATB15 = 0;
		LATBbits.LATB14 = 0;
		LATBbits.LATB13 = 1;
		}
		else if(turningcount < 3)
		{
		LATBbits.LATB13 = 1;
		LATBbits.LATB14 = 1;
		LATBbits.LATB15 = 0;
		}
		else if(turningcount < 4)
		{
		LATBbits.LATB13 = 1;
		LATBbits.LATB14 = 1;
		LATBbits.LATB15 = 1;
		}
	}
	else
	{
		LATAbits.LATA0 = !LATAbits.LATA0;
		LATBbits.LATB5 = !LATBbits.LATB5;
		LATBbits.LATB0 = !LATBbits.LATB0;
		LATBbits.LATB14 = !LATBbits.LATB14;
		LATBbits.LATB13 = !LATBbits.LATB13;
		LATBbits.LATB15 = !LATBbits.LATB15;
	}
	if(turningcount > 4)
	{
		turningcount = 0;
	}
	turningcount++;
	
}
void SetupTimer4 (void)
{
	__builtin_disable_interrupts();
	T4CONCLR;
	T4CON = 0x0; // Stop the timer and clear the control register,
	// prescaler at 1:1,internal clock source
	TMR4 = 0x0; // Clear the timer register
	PR4 = 624; // Load the period register
	T4CONbits.TCKPS = 6; // Pre-scaler: 256
	T4CONbits.TGATE =0;
	T4CONbits.TCS= 0;
	T4CONbits.TON = 0;
	T4CONbits.T32 = 0;
	IPC4bits.T4IP = 5;
	IPC4bits.T4IS = 0;
	IFS0bits.T4IF = 0;
	IEC0bits.T4IE = 0;
	__builtin_enable_interrupts();
}

void waitms(int ms)
{
	int k = 0;
	T4CONbits.ON = 1;
	TMR4=0;

	for(k =0; k < ms; k++)
	{
		while(IFS0bits.T4IF == 0){};
		IFS0bits.T4IF = 0;
		k++;
	}
//	printf("ms:%d , k:%d",ms,k);

}

void main (void)
{
	DDPCON = 0;
	float voltage;
	char buf[1024];       // declare receive buffer with max size 1024
    unsigned int rx_size,printval;
  	int t;
    unsigned char direction, LED1, LED2, LED3, LED4, LED5, LED6 = 0;
    int base, speed, decimal_val, len, pin, i, something, adcval;
	CFGCON = 0;

		
	// Peripheral Pin Select
	U2RXRbits.U2RXR = 4;    //SET RX to RB8
	RPB9Rbits.RPB9R = 2;    //SET RB9 to TX
	UART2Configure(115200);  // Configure UART2 for a baud rate of 115200   
	U2MODESET = 0x8000;     // enable UART2

	// Configure pwm output pins
	TRISAbits.TRISA2 = 0;
	TRISAbits.TRISA3 = 0;
	TRISBbits.TRISB2 = 0;
	TRISBbits.TRISB3 = 0;
	TRISBbits.TRISB6 = 0;
	TRISBbits.TRISB5 = 0;
	ANSELBbits.ANSB1 = 0;
	TRISBbits.TRISB1 = 1; //This is the reciever

	LATBbits.LATB6 = 0;
	LATAbits.LATA2 = 0;
	LATAbits.LATA3 = 0;
	LATBbits.LATB3 = 0;
	LATBbits.LATB2 = 0;
	LATBbits.LATB5 = 0;
	
	//LED pins
	TRISAbits.TRISA0 = 0;
	LATAbits.LATA0 = 0;
	TRISBbits.TRISB0 = 0;
	LATBbits.LATB0 = 0;
	TRISAbits.TRISA1 = 0;
	LATAbits.LATA1 = 0;
	TRISBbits.TRISB14 = 0;
	LATBbits.LATB14 = 0;
	TRISBbits.TRISB13 = 0;
	LATBbits.LATB13 = 0;
	TRISBbits.TRISB15 = 0;
	LATBbits.LATB15 = 0;	
	
	//setting input bits 
	
	INTCONbits.MVEC = 1;
	SetupTimer1();//PWM
	SetupTimer3(); //buzzer
	SetupTimer4();//timer
	pwm0 = pwm1, pwm2, pwm3, LED1, LED2, LED3, LED4, LED5, LED6 = 0;
	
	/* -------------- ADC CONFIGURATION [start] -------------- */
	CFGCON = 0;
	UART2Configure(115200);
	// Configure pins as analog inputs
	ANSELAbits.ANSA1 = 1;
//	ANSELBbits.ANSB1 = 1;	
	// set RB3 (AN5, pin 7 of DIP28) as analog pin
	TRISAbits.TRISA1 = 1;	// set RB3 as an input //port A1 and port B1 //This is IR sensor
//	TRISBbits.TRISB1 = 1; //This is the reciever

	INTCONbits.MVEC = 1;
	ADCConf();				// Configure ADC
	printf("Hello World!");

	while (1){	

	if(PORTBbits.RB1 == 1)
	{
	//	LATBbits.LATB6 = !LATBbits.LATB6; //1
		goto recieving;
	}

	goto outputfordirc;

recieving:
//	printf("\x1b[2J\x1b[1;1H");
//	printf("starting");
	waitms(26);
	i= speed = decimal_val = 0;
	base = 1;
	
	while(i<4) //converting first 3 bits to decimal for speed
	{			
		printval = PORTBbits.RB1;
		printf("%u", printval);
	//	LATBbits.LATB6 = !LATBbits.LATB6; //2,3,4,5
		decimal_val = decimal_val + PORTBbits.RB1 *base;
		base = base*2;	
		waitms(20);			
		i++;
	}
			
		decimal_val = decimal_val * 6.66666666666666; // to scale to 100
		printf("  %i  ", decimal_val);
		if(decimal_val > 100)
		{
			decimal_val = 100;
		}
		
		printval = PORTBbits.RB1;
		printf("5:%u ", printval);
//		LATBbits.LATB6 = !LATBbits.LATB6; //6
		if(PORTBbits.RB1 == 1)
		{
			waitms(20);
			printval = PORTBbits.RB1;
			printf("6:%u ", printval);
//			LATBbits.LATB6 = !LATBbits.LATB6; //7
			
			if(PORTBbits.RB1 == 1)
			{
				waitms(20);	
				printval = PORTBbits.RB1;
				printf("7:%u ", printval);
//				LATBbits.LATB6 = !LATBbits.LATB6; //8
				
				if(PORTBbits.RB1 == 1)
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("8:%u \n", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
				
					if(PORTBbits.RB1 == 1)
					{
						direction = 1;
						printf("forward all 1s");
					}
					else
					{
						printf("dead");
						//direction = 9;
					}
				}
				else
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("8:%u \n", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
				
					if(PORTBbits.RB1 == 1)
					{
						printf("dead");
						//direction = 9;
					}
					else
					{
						printf("dead");
						//direction = 9;
					}
				}
			}
			else
			{
				waitms(20);	
				printval = PORTBbits.RB1;
				printf("7:%u ", printval);
//				LATBbits.LATB6 = !LATBbits.LATB6; //8
				if(PORTBbits.RB1 == 1)
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("8:%u \n", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
				
					if(PORTBbits.RB1 == 1)
					{
						printf("dead");
						//direction = 9;
					}
					else
					{
						printf("dead");
						//direction = 9;
					}
				}
				else
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("8:%u \n", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
				
					if(PORTBbits.RB1 == 1)
					{
						printf("dead");
						//direction = 9;
					}
					else
					{
						direction = 8;
						printf("\n\r backwards right");
					}	
				}
				
			}
		}
		else
		{
			waitms(20);
			printval = PORTBbits.RB1;
			printf("6:%u ", printval);
//			LATBbits.LATB6 = !LATBbits.LATB6; //7
			if(PORTBbits.RB1 == 1)
			{
				waitms(20);
				printval = PORTBbits.RB1;
				printf("6:%u ", printval);
//				LATBbits.LATB6 = !LATBbits.LATB6; //8
				if(PORTBbits.RB1 == 1)
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("6:%u ", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
					if(PORTBbits.RB1 == 1)
					{
						direction = 7;
						printf("\n\r backward left");
					}
					else
					{
						direction = 6;
						printf("\n\r forward RIGHT");
					}
				}
				else
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("6:%u ", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
					if(PORTBbits.RB1 == 1)
					{
						direction = 5;
						printf("\n\r forward left");
					}
					else
					{
						direction = 4;
						printf("\n\r bakcwards");
					}
				}
			}
			else
			{
				waitms(20);
				printval = PORTBbits.RB1;
				printf("6:%u ", printval);
//				LATBbits.LATB6 = !LATBbits.LATB6; //8
		
				if(PORTBbits.RB1 == 1)
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("6:%u ", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
					if(PORTBbits.RB1 == 1)
					{
						direction = 3;
						printf("\n\r right turn");
					}
					else
					{
						direction = 2;
						printf("\n\r left turn");
					}
				}
				else
				{
					waitms(20);
					printval = PORTBbits.RB1;
					printf("6:%u ", printval);
//					LATBbits.LATB6 = !LATBbits.LATB6; //9
					if(PORTBbits.RB1 == 1)
					{
						direction = 1;
						printf("\n\r forward");
					}
					else
					{
						direction = 0;
						printf("\n\r stop");
					}	
				}
			
			}
		}
	waitms(16);
	outputfordirc:	
		if(direction == 0)
		{
			LATBbits.LATB5 = 1;
			LATAbits.LATA0 = 1;
			LATBbits.LATB0 = 1;
			LATBbits.LATB14 = 1;
			LATBbits.LATB13 = 1;
			LATBbits.LATB15 = 1;
		}
		else
		{
			LATBbits.LATB5 = 0;
			LATAbits.LATA0 = 0;
			LATBbits.LATB0 = 0;
			LATBbits.LATB14 = 0;
			LATBbits.LATB13 = 0;
			LATBbits.LATB15 = 0;
		}
		if(direction == 2)
		{
			T3CONbits.ON = 1;
			turn = 0;
		}
		else if(direction ==3)
		{
			T3CONbits.ON = 1;
			turn = 1;
		}
		else if(direction ==4)
		{
			T3CONbits.ON = 1;
			turn = 2;
		}
		else 
		{
			T3CONbits.ON = 0;
		}
		if(direction == 0)
		{
			pwm0 = 0;
			pwm1 = 0;
			pwm2 = 0;
			pwm3 = 0;
		}
		else if(direction == 1) //forward
		{
			pwm0 = 0;
			pwm1 = decimal_val;
			pwm2 = 0;
			pwm3 = decimal_val;
		}
		else if(direction == 2) //left turn
		{
			pwm0 = 0;
			pwm1 = decimal_val;
			pwm2 = decimal_val;
			pwm3 = 0;
		}
		else if(direction == 3) //right turn 	B3/A2 / right turn
		{
			pwm0 = decimal_val;
			pwm1 = 0;
			pwm2 = 0;
			pwm3 = decimal_val;
		}
		else if(direction == 4) //backwards
		{
			pwm0 = decimal_val;
			pwm1 = 0;
			pwm2 = decimal_val;
			pwm3 = 0;
		}
		else if(direction == 5) // forward right
		{
			pwm0 = 0;
			pwm1 = decimal_val;
			pwm2 = 0;
			pwm3 = decimal_val / 3;
		}
		else if(direction == 6) // forward left
		{
			pwm0 = 0;
			pwm1 = decimal_val / 3;
			pwm2 = 0;
			pwm3 = decimal_val;
		}
		else if(direction == 7) //backwards left
		{
			pwm0 = decimal_val / 3;
			pwm1 = 0;
			pwm2 = decimal_val;
			pwm3 = 0;
		}
		else if(direction == 8) //backwards right
		{
			pwm0 = decimal_val;
			pwm1 = 0;
			pwm2 = decimal_val / 3;
			pwm3 = 0;
		}
		else if (direction == 9) //accerlation
		{
			pwm0 = 100;
			pwm1 = 0;
			pwm2 = 100;
			pwm3 = 0;
			waitms(50);
		}
		else
		{
			pwm0 = 0;
			pwm1 = 0;
			pwm2 = 0;
			pwm3 = 0;
		}
	}
}
/* UART2Configure() sets up the UART2 for the most standard and minimal operation
*  Enable TX and RX lines, 8 data bits, no parity, 1 stop bit, idle when HIGH
*
* Input: Desired Baud Rate
* Output: Actual Baud Rate from baud control register U2BRG after assignment*/
int UART2Configure( int desired_baud)
{  
	U2MODE = 0;         // disable autobaud, TX and RX enabled only, 8N1, idle=HIGH  
	U2STA = 0x1400;     // enable TX and RX  
	U2BRG = Baud2BRG(desired_baud); // U2BRG = (FPb / (16*baud)) - 1  
	// Calculate actual baud rate  
	int actual_baud = SYSCLK / (16 * (U2BRG+1));  
	return actual_baud;
}

/* SerialTransmit() transmits a string to the UART2 TX pin MSB first
*
* Inputs: *buffer = string to transmit */
int SerialTransmit(const char *buffer)
{ 
	unsigned int size = strlen(buffer); 
	while( size)  
	{    
		while( U2STAbits.UTXBF);    // wait while TX buffer full   
			U2TXREG = *buffer;          // send single character to transmit buffer     
			buffer++;                   // transmit next character on following loop     
			size--;                     // loop until all characters sent (when size = 0)
	}   
	while( !U2STAbits.TRMT);        // wait for last transmission to finish    
	return 0;
}

unsigned char distanceIR (void)
{
	// for distance speed function	
	/* -------------- ADC CONFIGURATION [end] -------------- */
	int adcval;
	float distance=0,dist,distcheck;
	int i=0;
		adcval = ADCRead(1); //3 also works
		dist = adcval * 3.3 / 1023.0;
		dist = 26.905 * pow(dist, -1.272);
		printf("AN5 = 0x%04x, %.3fV\r", adcval, dist);
		fflush(stdout);

		pwm0 = 0;
		pwm1 = 0;
		pwm2 = 0;
		pwm3 = 0;
		
		while(1){
			/* ----- Acceleration/deceleration ----- */
			if(distance <= dist*0.75){
				if(pwm1 < 30){
					pwm1 = 30;
					pwm3 = 30;
				}else if(pwm1 >= 90){
					pwm1 = 99;
					pwm3 = 99;
				}else{
					pwm1 = pwm1 * 1.1;
					pwm3 = pwm3 * 1.1;
				}
			}else{
				if(pwm1 < 41){
					pwm1 = 40;
					pwm3 = 40;
				}else{
					pwm1 = pwm1 * 0.85; //change the values
					pwm3 = pwm3 * 0.85;
				}	
			}
			printf("\n%d,%f,%f", pwm1,distance,dist);
			waitms(25);
			
			
			adcval = ADCRead(1); //3 also works //this will check the updated distance
			distcheck = adcval * 3.3 / 1023.0;
			distcheck = 26.905 * pow(distcheck, -1.272);
			distance = abs(dist - distcheck); //updating distance tracker
			while(distcheck > dist)
			{
				adcval = ADCRead(1); //3 also works //this will check the updated distance
				distcheck = adcval * 3.3 / 1023.0;
				distcheck = 26.905 * pow(distcheck, -1.272);
				distance = abs(dist - distcheck); //updating distance tracker
				i++;
				if(i>100)
				{
				return 0;
				}
			}
			
			if((abs(dist - distance) / dist < 0.1) || distcheck <= 10){ //IR sensor becomes pretty inaccurate if too close so quit break the code
				pwm1 = 0;
				pwm3 = 0; 
				printf("break");
				return 0;
			}
		/*	
			if(PORTBbits.RB1 == 1) //1
			{
				waitms(26);
				if(PORTBbits.RB1 == 1) //2
				{
					waitms(20);
					if(PORTBbits.RB1 == 1) //3
					{
						waitms(20);
						if(PORTBbits.RB1 == 1) //4
						{
							waitms(20);
							if(PORTBbits.RB1 == 1) //5
							{
								waitms(20);
								if(PORTBbits.RB1 == 1) //6
								{
									waitms(20);
									if(PORTBbits.RB1 == 1) //7
									{
										waitms(20);
										if(PORTBbits.RB1 == 1) //8
										{
											waitms(20);
											if(PORTBbits.RB1 == 1) //
											{
												pwm1=0;
												pwm3=0;
												return 0;
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			*/
			
		}
		//distance speed function end	
}


/* SerialReceive() is a blocking function that waits for data on
 
*  the UART2 RX buffer and then stores all incoming data into *buffer
*
* Note that when a carriage return '\r' is received, a nul character
*  is appended signifying the strings end
*
* Inputs:  *buffer = Character array/pointer to store received data into
*          max_size = number of bytes allocated to this pointer
* Outputs: Number of characters received */
unsigned int SerialReceive(char *buffer, unsigned int max_size)
{
	unsigned int num_char = 0;
	/* Wait for and store incoming data until either a carriage ret
	urn is received
	*   or the number of received characters (num_chars) exceeds max_size */
    
	while(num_char < max_size)
	{
		while( !U2STAbits.URXDA);   // wait until data available in RX buffer   
		*buffer = U2RXREG;          // empty contents of RX buffer into *buffer pointer
 		// insert null character to indicate end of string
        
		if( *buffer == '\r')       
		{
			*buffer = '\0';                 
			break;       
		}       
		buffer++;      
		num_char++;  
	}  
	return num_char;
}

	/*		
		//too recieve and write an int not a function atm 
		printf("PWM0: %d\tPWM1: %d\tPWM2: %d\tPWM3: %d\n", pwm0, pwm1, pwm2, pwm3);
		SerialTransmit("Type something: ");
    	
		rx_size = SerialReceive(buf, 1024);  // wait here until data is received
		
		if( rx_size > 0){
			SerialTransmit("\r\nYou typed: ");
	    	
			SerialTransmit(buf);
			len = strlen(buf);
			something = atoi(buf);
			
			printf("\n\n%d\n\n",something);  
		}  
		SerialTransmit("\r\n");
	*/
	
