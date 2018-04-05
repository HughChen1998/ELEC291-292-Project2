// -------------------------------------------------------------------------------------------
// EFM8_I2C_Nunchuck.c: Reads the WII nunchuck using the hardware I2C port
// available in the EFM8LB1 and sends them using the serial port.  The best
// information so far about the nunchuck is at:
//
// http://wiibrew.org/wiki/Wiimote/Extension_Controllers
// http://wiibrew.org/wiki/Wiimote/Extension_Controllers/Nunchuck
//
// Some good information was found also here:
//
// http://forum.arduino.cc/index.php/topic,45924.0.html
//
// Base code by:  Jesus Calvino-Fraga (c) 2010-2018
// 
// The next line clears the "C51 command line options:" field when compiling with CrossIDE
//  ~C51~
// --------------------------------------------------------------------------------------------

#include <EFM8LB1.h>
#include <stdlib.h>
#include <stdio.h>
#include "lcd.h"
#include "global.h"
#include <math.h>
#include <stdint.h>

#define  SYSCLK         48000000L // System clock frequency in Hz
#define  BAUDRATE       115200L
#define  SMB_FREQUENCY  100000L   // I2C SCL clock rate (10kHz to 100kHz)
#define  DEFAULT_F 		15500L

// I2C ports at P2_0 and P2_1
#define OUT0 P2_0
#define OUT1 P2_1
#define BUTT1 !P3_3
#define BUTT2 !P3_0
#define BUTT3 !P2_5

#define JOYMARGIN 10
#define ANGLEMARGIN 20

#define DEBUG 0

// Signal delay in ms (for Timer4ms)
#define SIGNALDELAY 10

volatile char c  = 'z';
unsigned char overflow_count;

char _c51_external_startup (void)
{
	// Disable Watchdog with key sequence
	SFRPAGE = 0x00;
	WDTCN = 0xDE; 		//First key
	WDTCN = 0xAD; 		//Second key
  
	VDM0CN=0x80;       	// Enable VDD monitor
	RSTSRC=0x02|0x04;  	// Enable reset on missing clock detector and VDD

	#if (SYSCLK == 48000000L)	
		SFRPAGE = 0x10;
		PFE0CN  = 0x10; 	// SYSCLK < 50 MHz.
		SFRPAGE = 0x00;
	#elif (SYSCLK == 72000000L)
		SFRPAGE = 0x10;
		PFE0CN  = 0x20;		// SYSCLK < 75 MHz.
		SFRPAGE = 0x00;
	#endif
	
	#if (SYSCLK == 12250000L)
		CLKSEL = 0x10;
		CLKSEL = 0x10;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 24500000L)
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 48000000L)	
		// Before setting clock to 48 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x07;
		CLKSEL = 0x07;
		while ((CLKSEL & 0x80) == 0);
	#elif (SYSCLK == 72000000L)
		// Before setting clock to 72 MHz, must transition to 24.5 MHz first
		CLKSEL = 0x00;
		CLKSEL = 0x00;
		while ((CLKSEL & 0x80) == 0);
		CLKSEL = 0x03;
		CLKSEL = 0x03;
		while ((CLKSEL & 0x80) == 0);
	#else
		#error SYSCLK must be either 12250000L, 24500000L, 48000000L, or 72000000L
	#endif

	#if ( ((SYSCLK/BAUDRATE)/(12L*2L)) > 0x100)
		#error Can not configure baudrate using timer 1 
	#endif
	// Configure Uart 0
	SCON0 = 0x10;
	TH1 = 0x100-((SYSCLK/BAUDRATE)/(12L*2L));
	TL1 = TH1;      // Init Timer1
	TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	TMOD |=  0x20;                       
	TR1 = 1; 	// START Timer1
	TI = 1;  	// Indicate TX0 ready

	P2MDOUT|=0b_0000_0011;
	P0MDOUT |= 0x10; 		// Enable UART0 TX as push-pull output
	XBR0 = 0b_0000_0101; 	// Enable SMBus pins and UART pins P0.4(TX) and P0.5(RX)
	XBR1 = 0X00;
	XBR2 = 0x40; // Enable crossbar and weak pull-ups

	// Configure Timer 0 as the I2C clock source
	CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK
	TMOD &= 0xf0;  // Mask out timer 1 bits
	TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	// Timer 0 configured to overflow at 1/3 the rate defined by SMB_FREQUENCY
	TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	TR0 = 1; // Enable timer 0
	
	// Configure and enable SMBus
	SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	SMB0CF |= 0b_1000_0000;  // Enable SMBus
	
	//Configure timer 2 for periodic interupts
	 TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	CKCON0|=0b_0001_0000;
	TMR2RL=(-(SYSCLK/(2*DEFAULT_F))); // Initialize reload value
	TMR2=0xffff;   // Set to reload immediately
	ET2=1;         // Enable Timer2 interrupts
	TR2=1;         // Start Timer2

	return 0;
}

void Timer2_ISR (void) interrupt INTERRUPT_TIMER2
{
	TF2H = 0; // Clear Timer2 interrupt flag
	OUT0=!OUT0;
	OUT1=!OUT0;
}

// Uses Timer4 to delay <ms> milli-seconds. 
void Timer4ms(unsigned char ms)
{
	unsigned char i;// usec counter
	unsigned char k;
	
	k=SFRPAGE;
	SFRPAGE=0x10;
	// The input for Timer 4 is selected as SYSCLK by setting bit 0 of CKCON1:
	CKCON1|=0b_0000_0001;
	
	TMR4RL = 65536-(SYSCLK/1000L); // Set Timer4 to overflow in 1 ms.
	TMR4 = TMR4RL;                 // Initialize Timer4 for first overflow
	
	TF4H=0; 	// Clear overflow flag
	TR4=1;  	// Start Timer4
	for (i = 0; i < ms; i++)       // Count <ms> overflows
	{
		while (!TF4H);  // Wait for overflow
		TF4H=0;         // Clear overflow indicator
	}
	TR4=0; 		// Stop Timer4
	SFRPAGE=k;	
}

void I2C_write (unsigned char output_data)
{
	SMB0DAT = output_data; 	// Put data into buffer
	SI = 0;
	while (!SI); 			// Wait until done with send
}

unsigned char I2C_read (void)
{
	unsigned char input_data;

	SI = 0;
	while (!SI); 			// Wait until we have data to read
	input_data = SMB0DAT; 	// Read the data

	return input_data;
}

void I2C_start (void)
{
	ACK = 1;
	STA = 1;     // Send I2C start
	STO = 0;
	SI = 0;
	while (!SI); // Wait until start sent
	STA = 0;     // Reset I2C start
}

void I2C_stop(void)
{
	STO = 1;  		// Perform I2C stop
	SI = 0;			// Clear SI
	//while (!SI);	// Wait until stop complete (Doesn't work???)
}

void nunchuck_init(bit print_extension_type)
{
	unsigned char i, buf[6];
	
	// Newer initialization format that works for all nunchucks
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0x55);
	I2C_stop();
	Timer4ms(1);
	 
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFB);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	// Read the extension type from the register block.  For the original Nunchuk it should be
	// 00 00 a4 20 00 00.
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xFA); 	// extension type register
	I2C_stop();
	Timer4ms(3); 		// 3 ms required to complete acquisition

	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		buf[i]=I2C_read();
	}
	ACK=0;
	I2C_stop();
	Timer4ms(3);
	
	
	if(print_extension_type)
	{
		//printf("Extension type: %02x  %02x  %02x  %02x  %02x  %02x\n", buf[0],  buf[1], buf[2], buf[3], buf[4], buf[5]);
	}

	// Send the crypto key (zeros), in 3 blocks of 6, 6 & 4.

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0xF0);
	I2C_write(0xAA);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);

	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x40);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(1);
}

void nunchuck_getdata(unsigned char * s)
{
	unsigned char i;

	// Start measurement
	I2C_start();
	I2C_write(0xA4);
	I2C_write(0x00);
	I2C_stop();
	Timer4ms(3); 	// 3 ms required to complete acquisition

	// Request values
	I2C_start();
	I2C_write(0xA5);
	
	// Receive values
	for(i=0; i<6; i++)
	{
		s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	}
	ACK=0;
	I2C_stop();
}

/* ---------------------------------------- Serial ---------------------------------------- */
void serial (void) interrupt 4{
	if(RI == 1){
		RI = 0;
		SFRPAGE = 0x20;
		c = SBUF0;
		SFRPAGE = 0x00;
	}
}
/* ---------------------------------------- Serial END ---------------------------------------- */

void main (void)
{
	unsigned long int x, f;
	int i=0;
	unsigned char rbuf[6];
	int joy_x, joy_y, off_x, off_y, acc_x, acc_y, acc_z;
	bit but1, but2;
	
	// joystick angle + magnitude
	int angle, magnitude;
	
	// signal bitstream
	bit signal_stream0 = 0;	// Start bit
	
	bit signal_stream1 = 0;	// speed[0]
	bit signal_stream2 = 0;	// speed[1]
	bit signal_stream3 = 0;	// speed[2]
	bit signal_stream4 = 0;	// speed[3]
 	
	bit signal_stream5 = 0;	// opcode[0]
	bit signal_stream6 = 0;	// opcode[1]
	bit signal_stream7 = 0; // opcode[2]
	bit signal_stream8 = 0;	// opcode[3]
	
	bit temp1;
	bit temp2;
	bit temp3;
	bit temp4;
	
	// ----------- Nunchuck sequence ------------
	// Konami: U-U-D-D-L-R-L-R-B(Z)-A(C)
	int konamiProg = 0;
	bit konamiReady = 0;
	
	// Mortal Kombat, Sub-Zero "Chest Kold": L-R-D-L-Circle(C)
	int koldProg = 0;
	bit koldReady = 0;
	
	bit shakeDir = 0;
	// ------------------------------------------
	
	// ----------- Accelerometer -------------
	int accelLoop = -1;
	// ---------------------------------------
	EA = 1;
	ES0 = 1;
	ET2=1;
	f = 15614;
	x=(SYSCLK/(2L*f));
	TR2=0; 					// Stop timer 2
	TMR2RL=0x10000L-x; 		// Change reload value for new frequency
	TR2=1; 					// Start timer 2
	f=SYSCLK/(2L*(0x10000L-TMR2RL));

	Timer4ms(200);
	nunchuck_init(1);
	Timer4ms(100);

	nunchuck_getdata(rbuf);

	off_x=(int)rbuf[0]-128;
	off_y=(int)rbuf[1]-128;

	while(1){
		nunchuck_getdata(rbuf);
		
		joy_x=(int)rbuf[0]-128-off_x;
		joy_y=(int)rbuf[1]-128-off_y;
		acc_x=rbuf[2]*4; 
		acc_y=rbuf[3]*4;
		acc_z=rbuf[4]*4;

		but1=(rbuf[5] & 0x01)?1:0;
		but2=(rbuf[5] & 0x02)?1:0;
		if (rbuf[5] & 0x04) acc_x+=2;
		if (rbuf[5] & 0x08) acc_x+=1;
		if (rbuf[5] & 0x10) acc_y+=2;
		if (rbuf[5] & 0x20) acc_y+=1;
		if (rbuf[5] & 0x40) acc_z+=2;
		if (rbuf[5] & 0x80) acc_z+=1;
			   
		// Use joy_x, joy_y to make turns
		// First set all signal bits (except for start bit) to zero by default (IDLE by default)
		signal_stream0 = 1;
		signal_stream1 = 0;
		signal_stream2 = 0;
		signal_stream3 = 0;
		signal_stream4 = 0;
		signal_stream5 = 0;
		signal_stream6 = 0;
		signal_stream7 = 0;
		signal_stream8 = 0;
		
		magnitude = sqrtf(joy_x*joy_x + joy_y*joy_y) * (15.0/100);
		angle = 0;
		
		// --------------------- Python serial control ---------------------
		if(c == 'U'){
			signal_stream1 = 0;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			signal_stream8 = 1;
			c = 'Z';
			goto send;
		}
		else if(c == 'L'){
			signal_stream1 = 1;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			signal_stream7 = 1;
			signal_stream8 = 1;
			c = 'Z';
			goto send;
		}else if(c == 'D'){
			signal_stream1 = 0;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			signal_stream6 = 1;
			c = 'Z';
			goto send;
		}
		else if(c == 'R'){
			signal_stream1 = 0;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			signal_stream7 = 1;
			signal_stream8 = 1;
			c = 'Z';
			goto send;
		}
		// --------------------- Python serial control END ---------------------
		
		// --------------------- Nunchuck joystick control ---------------------
		if(magnitude <= 0){
			if(!but1){
				// ACCEL (1111)
				signal_stream1 = 1;
				signal_stream2 = 1;
				signal_stream3 = 1;
				signal_stream4 = 1;
				
				signal_stream5 = 1;
				signal_stream6 = 1;
				signal_stream7 = 1;
				signal_stream8 = 1;
				
				printf("ACCEL ");
				
				if(konamiReady){
					if(konamiProg == 8){
	 					konamiProg++;
	 				}else{
	 					konamiProg = 0;
	 				}
 				}
				konamiReady = 0;
			}else if(!but2 || c == 'S'){
				// STOP (same as IDLE)
				printf("STOP ");
				
				if(konamiReady){
					if(konamiProg == 9){
	 					konamiProg++;
	 				}else{
	 					konamiProg = 0;
	 				}
				}
				konamiReady = 0;
				
				if(koldReady){
					if(koldProg == 4){
						koldProg++;
					}else{
						koldProg = 0;
					}
				}
				koldReady = 0;
				accelLoop = -1;
			}else{
				// IDLE
				printf("IDLE ");
				konamiReady = 1;
				koldReady = 1;
			}
		}else{
			signal_stream0 = 1;
			angle = abs(atanf((float) joy_y / (float) joy_x) * 180/PI);	// Range: 0 to pi/2 -> 0 to 90
			
			// Convert magnitude to binary
			signal_stream1 = magnitude % 2;						// speed[0]
			signal_stream2 = (magnitude / 2) % 2;				// speed[1]
			signal_stream3 = ((magnitude / 2) / 2) % 2;			// speed[2]
			signal_stream4 = (((magnitude / 2) / 2) / 2) % 2;	// speed[3]
			
			if(joy_y > JOYMARGIN){				// Forward
				if(joy_x < -JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
					// LTURN (0101)
					signal_stream6 = 1;
					signal_stream8 = 1;
					printf("LTURN ");
				}else if(joy_x > JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
					// RTURN (0110)
					signal_stream6 = 1;
					signal_stream7 = 1;
					printf("RTURN ");
				}else if(angle >= (90 - ANGLEMARGIN)){
					// GO (0001)
					
					signal_stream5 = 1;
					signal_stream6 = 1;
					signal_stream7 = 1;
					signal_stream8 = 1;
					
					printf("GO ");
					
					if(konamiReady){
	 					if(konamiProg == 0 || konamiProg == 1){
	 						konamiProg++;
	 					}else{
	 						konamiProg = 0;
	 					}
					}
					konamiReady = 0;
					koldProg = 0;
				}else{
					printf("*N/A* ");
				}
			}else if(joy_y < -JOYMARGIN){		// Backward
				if(joy_x < -JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
					// BLTURN (0111)
 					signal_stream6 = 1;
					signal_stream7 = 1;
					signal_stream8 = 1;
					printf("BLTURN ");
				}else if(joy_x > JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
					// BRTURN (1000)
					signal_stream5 = 1;
					printf("BRTURN ");
				}else if( angle > 90 - ANGLEMARGIN){
					// BACK (0100)
					signal_stream6 = 1;
					printf("BACK ");
					
					if(konamiReady){
	 					if(konamiProg == 2 || konamiProg == 3){
	 						konamiProg++;
	 					}else{
	 						konamiProg = 0;
	 					}
					}
					konamiReady = 0;
					
					if(koldReady){
						if(koldProg == 2){
							koldProg++;
						}else{
							koldProg = 0;
						}
					}
					koldReady = 0;
				}else{
					printf("*N/A* ");
				}
			}else{						// y=0, rotate
				if(joy_x > JOYMARGIN && (angle < ANGLEMARGIN)){
					// RIGHT (0011)
					signal_stream7 = 1;
					signal_stream8 = 1;
					
					printf("RIGHT ");
					
					if(konamiReady){
	 					if(konamiProg == 5 || konamiProg == 7){
	 						konamiProg++;
	 					}else{
	 						konamiProg = 0;
	 					}
					}
					konamiReady = 0;
					
					if(koldReady){
						if(koldProg == 1){
							koldProg++;
						}else{
							koldProg = 0;
						}
					}
					koldReady = 0;
				}else if(joy_x < -JOYMARGIN && (angle < ANGLEMARGIN)){
					// LEFT (0010)
					signal_stream7 = 1;
					printf("LEFT ");
					
					if(konamiReady){
	 					if(konamiProg == 4 || konamiProg == 6){
	 						konamiProg++;
	 					}else{
	 						konamiProg = 0;
	 					}
					}
					konamiReady = 0;
					
					if(koldReady){
						if(koldProg == 0 || koldProg == 3){
							koldProg++;
						}else{
							koldProg = 0;
						}
					}
					koldReady = 0;
				}else{
					printf("*N/A* ");
				}
			}
		}
		// --------------------- Nunchuck joystick control END ---------------------
		
		// ---------- Nunchuck gesture control ----------
		if(accelLoop > 0){
			signal_stream1 = 1;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
		}else{
			if(acc_z <= 150){
				accelLoop = -1;
			}else if(acc_x >= 800){
				accelLoop = 4;
			}else if(acc_x <= 200){
				accelLoop = 3;
			}else if(acc_y >= 800){
				accelLoop = 2;
			}else if(acc_y <= 200){
				accelLoop = 1;
			}
		}
				
		if(accelLoop == 4 || c == 'P'){
			// Loop left (LEFT)
			signal_stream5 = 0;
			signal_stream6 = 0;
			signal_stream7 = 1;
			signal_stream8 = 0;
			accelLoop = 4;
			if(DEBUG) printf(" Shake left ");
		}else if(accelLoop == 3 || c == 'X'){			
			// Loop right (RIGHT)
			signal_stream5 = 0;
			signal_stream6 = 0;
			signal_stream7 = 1;
			signal_stream8 = 1;
			accelLoop = 3;
			if(DEBUG) printf(" Shake right ");
		}else if(accelLoop == 2 || c == 'N'){
			// Loop backward (BACK)
			signal_stream5 = 0;
			signal_stream6 = 1;
			signal_stream7 = 0;
			signal_stream8 = 0;
			accelLoop = 2;
			if(DEBUG) printf(" Shake back ");
		}else if(accelLoop == 1 || c == 'O'){
			// Loop forward (GO)
			signal_stream5 = 0;
			signal_stream6 = 0;
			signal_stream7 = 0;			
			signal_stream8 = 1;
			accelLoop = 1;
			if(DEBUG) printf(" Shake GO ");
		}
		// -------- Nunchuck gesture control END ---------
		
		// [DEBUG] Print nunchuck values
		if(DEBUG){	
			printf("Bitstream: %d%d%d%d",signal_stream0,signal_stream1,signal_stream2,signal_stream3);
			printf("%d%d%d%d%d | ",signal_stream4,signal_stream5,signal_stream6,signal_stream7,signal_stream8);
			//printf("C is %c | ", c);
			//printf("Buttons(Z:%c, C:%c) Joystick(%4d, %4d) Accelerometer(%3d, %3d, %3d), Speed (%2d/15), Angle (%2d degrees)", but1?'1':'0', but2?'1':'0', joy_x, joy_y, acc_x, acc_y, acc_z, magnitude, angle);
			//printf(" | accelLoop = %d | ", accelLoop);
			//printf(" | konamiProg = %d ", konamiProg);
			//printf(" | koldProg = %d ", koldProg);
		}
		
		// ------------- Combo response ---------------
		if(koldProg == 5){
			signal_stream1 = 1;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			printf("[FATALITY]\n10\n");
			
			// Shake the robot using GO/BACK
			if(shakeDir){
				// GO
				signal_stream5 = 0;
				signal_stream6 = 0;
				signal_stream7 = 0;
				signal_stream8 = 1;
				Timer4ms(SIGNALDELAY/2);
			}else{
				// BACK
				signal_stream5 = 0;
				signal_stream6 = 1;
				signal_stream7 = 0;
				signal_stream8 = 0;
				Timer4ms(SIGNALDELAY/2);
			}
			shakeDir = !shakeDir;
		}else if(konamiProg == 10){
			signal_stream1 = 1;
			signal_stream2 = 1;
			signal_stream3 = 1;
			signal_stream4 = 1;
			
			// Spin LEFT
			signal_stream5 = 0;
			signal_stream6 = 0;
			signal_stream7 = 1;
			signal_stream8 = 0;
		}else{
			printf("\n1\n");
		}
		// ------------ Combo response END ----------------
		
		// -------------- Swap buses -------------------
		/*temp1 = signal_stream1;
		temp2 = signal_stream2;
		temp3 = signal_stream3;
		temp4 = signal_stream4;
		
		signal_stream1 = signal_stream5;
		signal_stream2 = signal_stream6;
		signal_stream3 = signal_stream7;
		signal_stream4 = signal_stream8;
		
		signal_stream5 = temp1;
		signal_stream6 = temp2;
		signal_stream7 = temp3;
		signal_stream8 = temp4;*/
		// -------------- Swap buses END-----------------
		
		ET2=1;
 		send:		
		// Start (1)
		ES0 = 0;
		ET2 = signal_stream0;
		Timer4ms(SIGNALDELAY);
		// Binary speed (4)
		ET2 = signal_stream1;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream2;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream3;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream4;
		Timer4ms(SIGNALDELAY);
		// Opcode(4)
		ET2 = signal_stream5;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream6;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream7;
		Timer4ms(SIGNALDELAY);
		ET2 = signal_stream8;
		Timer4ms(SIGNALDELAY);
		// End (1)
		ET2=0;
		Timer4ms(8);
		
		ES0 = 1;
		
  		if(BUTT3)
		{	
			f+= 50;
			x=(SYSCLK/(2L*f));
			TR2=0; 				// Stop timer 2
			TMR2RL=0x10000L-x; 	// Change reload value for new frequency
			TR2=1; 				// Start timer 2
			f=SYSCLK/(2L*(0x10000L-TMR2RL));		
		}
		if(BUTT2)
  		{
  			f-=50;
  			x=(SYSCLK/(2L*f));
			TR2=0; 				// Stop timer 2
			TMR2RL=0x10000L-x; 	// Change reload value for new frequency
			TR2=1; 				// Start timer 2
			f=SYSCLK/(2L*(0x10000L-TMR2RL));
 		}
  		if(DEBUG) printf("    freq now: %lu",f);
	}
}