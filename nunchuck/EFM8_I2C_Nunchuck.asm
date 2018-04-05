;--------------------------------------------------------
; File Created by C51
; Version 1.0.0 #1069 (Apr 23 2015) (MSVC)
; This file was generated Tue Apr 03 14:03:59 2018
;--------------------------------------------------------
$name EFM8_I2C_Nunchuck
$optc51 --model-small
	R_DSEG    segment data
	R_CSEG    segment code
	R_BSEG    segment bit
	R_XSEG    segment xdata
	R_PSEG    segment xdata
	R_ISEG    segment idata
	R_OSEG    segment data overlay
	BIT_BANK  segment data overlay
	R_HOME    segment code
	R_GSINIT  segment code
	R_IXSEG   segment xdata
	R_CONST   segment code
	R_XINIT   segment code
	R_DINIT   segment code

;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	public _main
	public _serial
	public _nunchuck_getdata
	public _nunchuck_init
	public _I2C_stop
	public _I2C_start
	public _I2C_read
	public _I2C_write
	public _Timer4ms
	public _Timer2_ISR
	public __c51_external_startup
	public _nunchuck_init_PARM_1
	public _LCDprint_PARM_3
	public _LCDprint_PARM_2
	public _overflow_count
	public _c
	public _Timer3us
	public _waitms
	public _LCD_pulse
	public _LCD_byte
	public _WriteData
	public _WriteCommand
	public _LCD_4BIT
	public _LCDprint
;--------------------------------------------------------
; Special Function Registers
;--------------------------------------------------------
_ACC            DATA 0xe0
_ADC0ASAH       DATA 0xb6
_ADC0ASAL       DATA 0xb5
_ADC0ASCF       DATA 0xa1
_ADC0ASCT       DATA 0xc7
_ADC0CF0        DATA 0xbc
_ADC0CF1        DATA 0xb9
_ADC0CF2        DATA 0xdf
_ADC0CN0        DATA 0xe8
_ADC0CN1        DATA 0xb2
_ADC0CN2        DATA 0xb3
_ADC0GTH        DATA 0xc4
_ADC0GTL        DATA 0xc3
_ADC0H          DATA 0xbe
_ADC0L          DATA 0xbd
_ADC0LTH        DATA 0xc6
_ADC0LTL        DATA 0xc5
_ADC0MX         DATA 0xbb
_B              DATA 0xf0
_CKCON0         DATA 0x8e
_CKCON1         DATA 0xa6
_CLEN0          DATA 0xc6
_CLIE0          DATA 0xc7
_CLIF0          DATA 0xe8
_CLKSEL         DATA 0xa9
_CLOUT0         DATA 0xd1
_CLU0CF         DATA 0xb1
_CLU0FN         DATA 0xaf
_CLU0MX         DATA 0x84
_CLU1CF         DATA 0xb3
_CLU1FN         DATA 0xb2
_CLU1MX         DATA 0x85
_CLU2CF         DATA 0xb6
_CLU2FN         DATA 0xb5
_CLU2MX         DATA 0x91
_CLU3CF         DATA 0xbf
_CLU3FN         DATA 0xbe
_CLU3MX         DATA 0xae
_CMP0CN0        DATA 0x9b
_CMP0CN1        DATA 0x99
_CMP0MD         DATA 0x9d
_CMP0MX         DATA 0x9f
_CMP1CN0        DATA 0xbf
_CMP1CN1        DATA 0xac
_CMP1MD         DATA 0xab
_CMP1MX         DATA 0xaa
_CRC0CN0        DATA 0xce
_CRC0CN1        DATA 0x86
_CRC0CNT        DATA 0xd3
_CRC0DAT        DATA 0xcb
_CRC0FLIP       DATA 0xcf
_CRC0IN         DATA 0xca
_CRC0ST         DATA 0xd2
_DAC0CF0        DATA 0x91
_DAC0CF1        DATA 0x92
_DAC0H          DATA 0x85
_DAC0L          DATA 0x84
_DAC1CF0        DATA 0x93
_DAC1CF1        DATA 0x94
_DAC1H          DATA 0x8a
_DAC1L          DATA 0x89
_DAC2CF0        DATA 0x95
_DAC2CF1        DATA 0x96
_DAC2H          DATA 0x8c
_DAC2L          DATA 0x8b
_DAC3CF0        DATA 0x9a
_DAC3CF1        DATA 0x9c
_DAC3H          DATA 0x8e
_DAC3L          DATA 0x8d
_DACGCF0        DATA 0x88
_DACGCF1        DATA 0x98
_DACGCF2        DATA 0xa2
_DERIVID        DATA 0xad
_DEVICEID       DATA 0xb5
_DPH            DATA 0x83
_DPL            DATA 0x82
_EIE1           DATA 0xe6
_EIE2           DATA 0xf3
_EIP1           DATA 0xbb
_EIP1H          DATA 0xee
_EIP2           DATA 0xed
_EIP2H          DATA 0xf6
_EMI0CN         DATA 0xe7
_FLKEY          DATA 0xb7
_HFO0CAL        DATA 0xc7
_HFO1CAL        DATA 0xd6
_HFOCN          DATA 0xef
_I2C0ADM        DATA 0xff
_I2C0CN0        DATA 0xba
_I2C0DIN        DATA 0xbc
_I2C0DOUT       DATA 0xbb
_I2C0FCN0       DATA 0xad
_I2C0FCN1       DATA 0xab
_I2C0FCT        DATA 0xf5
_I2C0SLAD       DATA 0xbd
_I2C0STAT       DATA 0xb9
_IE             DATA 0xa8
_IP             DATA 0xb8
_IPH            DATA 0xf2
_IT01CF         DATA 0xe4
_LFO0CN         DATA 0xb1
_P0             DATA 0x80
_P0MASK         DATA 0xfe
_P0MAT          DATA 0xfd
_P0MDIN         DATA 0xf1
_P0MDOUT        DATA 0xa4
_P0SKIP         DATA 0xd4
_P1             DATA 0x90
_P1MASK         DATA 0xee
_P1MAT          DATA 0xed
_P1MDIN         DATA 0xf2
_P1MDOUT        DATA 0xa5
_P1SKIP         DATA 0xd5
_P2             DATA 0xa0
_P2MASK         DATA 0xfc
_P2MAT          DATA 0xfb
_P2MDIN         DATA 0xf3
_P2MDOUT        DATA 0xa6
_P2SKIP         DATA 0xcc
_P3             DATA 0xb0
_P3MDIN         DATA 0xf4
_P3MDOUT        DATA 0x9c
_PCA0CENT       DATA 0x9e
_PCA0CLR        DATA 0x9c
_PCA0CN0        DATA 0xd8
_PCA0CPH0       DATA 0xfc
_PCA0CPH1       DATA 0xea
_PCA0CPH2       DATA 0xec
_PCA0CPH3       DATA 0xf5
_PCA0CPH4       DATA 0x85
_PCA0CPH5       DATA 0xde
_PCA0CPL0       DATA 0xfb
_PCA0CPL1       DATA 0xe9
_PCA0CPL2       DATA 0xeb
_PCA0CPL3       DATA 0xf4
_PCA0CPL4       DATA 0x84
_PCA0CPL5       DATA 0xdd
_PCA0CPM0       DATA 0xda
_PCA0CPM1       DATA 0xdb
_PCA0CPM2       DATA 0xdc
_PCA0CPM3       DATA 0xae
_PCA0CPM4       DATA 0xaf
_PCA0CPM5       DATA 0xcc
_PCA0H          DATA 0xfa
_PCA0L          DATA 0xf9
_PCA0MD         DATA 0xd9
_PCA0POL        DATA 0x96
_PCA0PWM        DATA 0xf7
_PCON0          DATA 0x87
_PCON1          DATA 0xcd
_PFE0CN         DATA 0xc1
_PRTDRV         DATA 0xf6
_PSCTL          DATA 0x8f
_PSTAT0         DATA 0xaa
_PSW            DATA 0xd0
_REF0CN         DATA 0xd1
_REG0CN         DATA 0xc9
_REVID          DATA 0xb6
_RSTSRC         DATA 0xef
_SBCON1         DATA 0x94
_SBRLH1         DATA 0x96
_SBRLL1         DATA 0x95
_SBUF           DATA 0x99
_SBUF0          DATA 0x99
_SBUF1          DATA 0x92
_SCON           DATA 0x98
_SCON0          DATA 0x98
_SCON1          DATA 0xc8
_SFRPAGE        DATA 0xa7
_SFRPGCN        DATA 0xbc
_SFRSTACK       DATA 0xd7
_SMB0ADM        DATA 0xd6
_SMB0ADR        DATA 0xd7
_SMB0CF         DATA 0xc1
_SMB0CN0        DATA 0xc0
_SMB0DAT        DATA 0xc2
_SMB0FCN0       DATA 0xc3
_SMB0FCN1       DATA 0xc4
_SMB0FCT        DATA 0xef
_SMB0RXLN       DATA 0xc5
_SMB0TC         DATA 0xac
_SMOD1          DATA 0x93
_SP             DATA 0x81
_SPI0CFG        DATA 0xa1
_SPI0CKR        DATA 0xa2
_SPI0CN0        DATA 0xf8
_SPI0DAT        DATA 0xa3
_SPI0FCN0       DATA 0x9a
_SPI0FCN1       DATA 0x9b
_SPI0FCT        DATA 0xf7
_SPI0PCF        DATA 0xdf
_TCON           DATA 0x88
_TH0            DATA 0x8c
_TH1            DATA 0x8d
_TL0            DATA 0x8a
_TL1            DATA 0x8b
_TMOD           DATA 0x89
_TMR2CN0        DATA 0xc8
_TMR2CN1        DATA 0xfd
_TMR2H          DATA 0xcf
_TMR2L          DATA 0xce
_TMR2RLH        DATA 0xcb
_TMR2RLL        DATA 0xca
_TMR3CN0        DATA 0x91
_TMR3CN1        DATA 0xfe
_TMR3H          DATA 0x95
_TMR3L          DATA 0x94
_TMR3RLH        DATA 0x93
_TMR3RLL        DATA 0x92
_TMR4CN0        DATA 0x98
_TMR4CN1        DATA 0xff
_TMR4H          DATA 0xa5
_TMR4L          DATA 0xa4
_TMR4RLH        DATA 0xa3
_TMR4RLL        DATA 0xa2
_TMR5CN0        DATA 0xc0
_TMR5CN1        DATA 0xf1
_TMR5H          DATA 0xd5
_TMR5L          DATA 0xd4
_TMR5RLH        DATA 0xd3
_TMR5RLL        DATA 0xd2
_UART0PCF       DATA 0xd9
_UART1FCN0      DATA 0x9d
_UART1FCN1      DATA 0xd8
_UART1FCT       DATA 0xfa
_UART1LIN       DATA 0x9e
_UART1PCF       DATA 0xda
_VDM0CN         DATA 0xff
_WDTCN          DATA 0x97
_XBR0           DATA 0xe1
_XBR1           DATA 0xe2
_XBR2           DATA 0xe3
_XOSC0CN        DATA 0x86
_DPTR           DATA 0x8382
_TMR2RL         DATA 0xcbca
_TMR3RL         DATA 0x9392
_TMR4RL         DATA 0xa3a2
_TMR5RL         DATA 0xd3d2
_TMR0           DATA 0x8c8a
_TMR1           DATA 0x8d8b
_TMR2           DATA 0xcfce
_TMR3           DATA 0x9594
_TMR4           DATA 0xa5a4
_TMR5           DATA 0xd5d4
_SBRL1          DATA 0x9695
_PCA0           DATA 0xfaf9
_PCA0CP0        DATA 0xfcfb
_PCA0CP1        DATA 0xeae9
_PCA0CP2        DATA 0xeceb
_PCA0CP3        DATA 0xf5f4
_PCA0CP4        DATA 0x8584
_PCA0CP5        DATA 0xdedd
_ADC0ASA        DATA 0xb6b5
_ADC0GT         DATA 0xc4c3
_ADC0           DATA 0xbebd
_ADC0LT         DATA 0xc6c5
_DAC0           DATA 0x8584
_DAC1           DATA 0x8a89
_DAC2           DATA 0x8c8b
_DAC3           DATA 0x8e8d
;--------------------------------------------------------
; special function bits
;--------------------------------------------------------
_ACC_0          BIT 0xe0
_ACC_1          BIT 0xe1
_ACC_2          BIT 0xe2
_ACC_3          BIT 0xe3
_ACC_4          BIT 0xe4
_ACC_5          BIT 0xe5
_ACC_6          BIT 0xe6
_ACC_7          BIT 0xe7
_TEMPE          BIT 0xe8
_ADGN0          BIT 0xe9
_ADGN1          BIT 0xea
_ADWINT         BIT 0xeb
_ADBUSY         BIT 0xec
_ADINT          BIT 0xed
_IPOEN          BIT 0xee
_ADEN           BIT 0xef
_B_0            BIT 0xf0
_B_1            BIT 0xf1
_B_2            BIT 0xf2
_B_3            BIT 0xf3
_B_4            BIT 0xf4
_B_5            BIT 0xf5
_B_6            BIT 0xf6
_B_7            BIT 0xf7
_C0FIF          BIT 0xe8
_C0RIF          BIT 0xe9
_C1FIF          BIT 0xea
_C1RIF          BIT 0xeb
_C2FIF          BIT 0xec
_C2RIF          BIT 0xed
_C3FIF          BIT 0xee
_C3RIF          BIT 0xef
_D1SRC0         BIT 0x88
_D1SRC1         BIT 0x89
_D1AMEN         BIT 0x8a
_D01REFSL       BIT 0x8b
_D3SRC0         BIT 0x8c
_D3SRC1         BIT 0x8d
_D3AMEN         BIT 0x8e
_D23REFSL       BIT 0x8f
_D0UDIS         BIT 0x98
_D1UDIS         BIT 0x99
_D2UDIS         BIT 0x9a
_D3UDIS         BIT 0x9b
_EX0            BIT 0xa8
_ET0            BIT 0xa9
_EX1            BIT 0xaa
_ET1            BIT 0xab
_ES0            BIT 0xac
_ET2            BIT 0xad
_ESPI0          BIT 0xae
_EA             BIT 0xaf
_PX0            BIT 0xb8
_PT0            BIT 0xb9
_PX1            BIT 0xba
_PT1            BIT 0xbb
_PS0            BIT 0xbc
_PT2            BIT 0xbd
_PSPI0          BIT 0xbe
_P0_0           BIT 0x80
_P0_1           BIT 0x81
_P0_2           BIT 0x82
_P0_3           BIT 0x83
_P0_4           BIT 0x84
_P0_5           BIT 0x85
_P0_6           BIT 0x86
_P0_7           BIT 0x87
_P1_0           BIT 0x90
_P1_1           BIT 0x91
_P1_2           BIT 0x92
_P1_3           BIT 0x93
_P1_4           BIT 0x94
_P1_5           BIT 0x95
_P1_6           BIT 0x96
_P1_7           BIT 0x97
_P2_0           BIT 0xa0
_P2_1           BIT 0xa1
_P2_2           BIT 0xa2
_P2_3           BIT 0xa3
_P2_4           BIT 0xa4
_P2_5           BIT 0xa5
_P2_6           BIT 0xa6
_P3_0           BIT 0xb0
_P3_1           BIT 0xb1
_P3_2           BIT 0xb2
_P3_3           BIT 0xb3
_P3_4           BIT 0xb4
_P3_7           BIT 0xb7
_CCF0           BIT 0xd8
_CCF1           BIT 0xd9
_CCF2           BIT 0xda
_CCF3           BIT 0xdb
_CCF4           BIT 0xdc
_CCF5           BIT 0xdd
_CR             BIT 0xde
_CF             BIT 0xdf
_PARITY         BIT 0xd0
_F1             BIT 0xd1
_OV             BIT 0xd2
_RS0            BIT 0xd3
_RS1            BIT 0xd4
_F0             BIT 0xd5
_AC             BIT 0xd6
_CY             BIT 0xd7
_RI             BIT 0x98
_TI             BIT 0x99
_RB8            BIT 0x9a
_TB8            BIT 0x9b
_REN            BIT 0x9c
_CE             BIT 0x9d
_SMODE          BIT 0x9e
_RI1            BIT 0xc8
_TI1            BIT 0xc9
_RBX1           BIT 0xca
_TBX1           BIT 0xcb
_REN1           BIT 0xcc
_PERR1          BIT 0xcd
_OVR1           BIT 0xce
_SI             BIT 0xc0
_ACK            BIT 0xc1
_ARBLOST        BIT 0xc2
_ACKRQ          BIT 0xc3
_STO            BIT 0xc4
_STA            BIT 0xc5
_TXMODE         BIT 0xc6
_MASTER         BIT 0xc7
_SPIEN          BIT 0xf8
_TXNF           BIT 0xf9
_NSSMD0         BIT 0xfa
_NSSMD1         BIT 0xfb
_RXOVRN         BIT 0xfc
_MODF           BIT 0xfd
_WCOL           BIT 0xfe
_SPIF           BIT 0xff
_IT0            BIT 0x88
_IE0            BIT 0x89
_IT1            BIT 0x8a
_IE1            BIT 0x8b
_TR0            BIT 0x8c
_TF0            BIT 0x8d
_TR1            BIT 0x8e
_TF1            BIT 0x8f
_T2XCLK0        BIT 0xc8
_T2XCLK1        BIT 0xc9
_TR2            BIT 0xca
_T2SPLIT        BIT 0xcb
_TF2CEN         BIT 0xcc
_TF2LEN         BIT 0xcd
_TF2L           BIT 0xce
_TF2H           BIT 0xcf
_T4XCLK0        BIT 0x98
_T4XCLK1        BIT 0x99
_TR4            BIT 0x9a
_T4SPLIT        BIT 0x9b
_TF4CEN         BIT 0x9c
_TF4LEN         BIT 0x9d
_TF4L           BIT 0x9e
_TF4H           BIT 0x9f
_T5XCLK0        BIT 0xc0
_T5XCLK1        BIT 0xc1
_TR5            BIT 0xc2
_T5SPLIT        BIT 0xc3
_TF5CEN         BIT 0xc4
_TF5LEN         BIT 0xc5
_TF5L           BIT 0xc6
_TF5H           BIT 0xc7
_RIE            BIT 0xd8
_RXTO0          BIT 0xd9
_RXTO1          BIT 0xda
_RFRQ           BIT 0xdb
_TIE            BIT 0xdc
_TXHOLD         BIT 0xdd
_TXNF1          BIT 0xde
_TFRQ           BIT 0xdf
;--------------------------------------------------------
; overlayable register banks
;--------------------------------------------------------
	rbank0 segment data overlay
;--------------------------------------------------------
; internal ram data
;--------------------------------------------------------
	rseg R_DSEG
_c:
	ds 1
_overflow_count:
	ds 1
_LCDprint_PARM_2:
	ds 1
_nunchuck_init_buf_1_106:
	ds 6
_main_x_1_116:
	ds 4
_main_f_1_116:
	ds 4
_main_rbuf_1_116:
	ds 6
_main_joy_x_1_116:
	ds 2
_main_joy_y_1_116:
	ds 2
_main_off_x_1_116:
	ds 2
_main_off_y_1_116:
	ds 2
_main_acc_x_1_116:
	ds 2
_main_acc_y_1_116:
	ds 2
_main_acc_z_1_116:
	ds 2
_main_magnitude_1_116:
	ds 2
_main_konamiProg_1_116:
	ds 2
_main_koldProg_1_116:
	ds 2
_main_accelLoop_1_116:
	ds 2
_main_sloc4_1_0:
	ds 4
;--------------------------------------------------------
; overlayable items in internal ram 
;--------------------------------------------------------
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
	rseg	R_OSEG
;--------------------------------------------------------
; indirectly addressable internal ram data
;--------------------------------------------------------
	rseg R_ISEG
;--------------------------------------------------------
; absolute internal ram data
;--------------------------------------------------------
	DSEG
;--------------------------------------------------------
; bit data
;--------------------------------------------------------
	rseg R_BSEG
_LCDprint_PARM_3:
	DBIT	1
_nunchuck_init_PARM_1:
	DBIT	1
_main_but1_1_116:
	DBIT	1
_main_but2_1_116:
	DBIT	1
_main_signal_stream0_1_116:
	DBIT	1
_main_signal_stream5_1_116:
	DBIT	1
_main_signal_stream6_1_116:
	DBIT	1
_main_signal_stream7_1_116:
	DBIT	1
_main_signal_stream8_1_116:
	DBIT	1
_main_konamiReady_1_116:
	DBIT	1
_main_koldReady_1_116:
	DBIT	1
_main_shakeDir_1_116:
	DBIT	1
_main_sloc0_1_0:
	DBIT	1
_main_sloc1_1_0:
	DBIT	1
_main_sloc2_1_0:
	DBIT	1
_main_sloc3_1_0:
	DBIT	1
;--------------------------------------------------------
; paged external ram data
;--------------------------------------------------------
	rseg R_PSEG
;--------------------------------------------------------
; external ram data
;--------------------------------------------------------
	rseg R_XSEG
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	XSEG
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
	rseg R_IXSEG
	rseg R_HOME
	rseg R_GSINIT
	rseg R_CSEG
;--------------------------------------------------------
; Reset entry point and interrupt vectors
;--------------------------------------------------------
	CSEG at 0x0000
	ljmp	_crt0
	CSEG at 0x0023
	ljmp	_serial
	CSEG at 0x002b
	ljmp	_Timer2_ISR
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	rseg R_HOME
	rseg R_GSINIT
	rseg R_GSINIT
;--------------------------------------------------------
; data variables initialization
;--------------------------------------------------------
	rseg R_DINIT
;	EFM8_I2C_Nunchuck.c:47: volatile char c  = 'z';
	mov	_c,#0x7A
	; The linker places a 'ret' at the end of segment R_DINIT.
;--------------------------------------------------------
; code
;--------------------------------------------------------
	rseg R_CSEG
;------------------------------------------------------------
;Allocation info for local variables in function '_c51_external_startup'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:50: char _c51_external_startup (void)
;	-----------------------------------------
;	 function _c51_external_startup
;	-----------------------------------------
__c51_external_startup:
	using	0
;	EFM8_I2C_Nunchuck.c:53: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	EFM8_I2C_Nunchuck.c:54: WDTCN = 0xDE; 		//First key
	mov	_WDTCN,#0xDE
;	EFM8_I2C_Nunchuck.c:55: WDTCN = 0xAD; 		//Second key
	mov	_WDTCN,#0xAD
;	EFM8_I2C_Nunchuck.c:57: VDM0CN=0x80;       	// Enable VDD monitor
	mov	_VDM0CN,#0x80
;	EFM8_I2C_Nunchuck.c:58: RSTSRC=0x02|0x04;  	// Enable reset on missing clock detector and VDD
	mov	_RSTSRC,#0x06
;	EFM8_I2C_Nunchuck.c:61: SFRPAGE = 0x10;
	mov	_SFRPAGE,#0x10
;	EFM8_I2C_Nunchuck.c:62: PFE0CN  = 0x10; 	// SYSCLK < 50 MHz.
	mov	_PFE0CN,#0x10
;	EFM8_I2C_Nunchuck.c:63: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
;	EFM8_I2C_Nunchuck.c:80: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	EFM8_I2C_Nunchuck.c:81: CLKSEL = 0x00;
	mov	_CLKSEL,#0x00
;	EFM8_I2C_Nunchuck.c:82: while ((CLKSEL & 0x80) == 0);
L002001?:
	mov	a,_CLKSEL
	jnb	acc.7,L002001?
;	EFM8_I2C_Nunchuck.c:83: CLKSEL = 0x07;
	mov	_CLKSEL,#0x07
;	EFM8_I2C_Nunchuck.c:84: CLKSEL = 0x07;
	mov	_CLKSEL,#0x07
;	EFM8_I2C_Nunchuck.c:85: while ((CLKSEL & 0x80) == 0);
L002004?:
	mov	a,_CLKSEL
	jnb	acc.7,L002004?
;	EFM8_I2C_Nunchuck.c:102: SCON0 = 0x10;
	mov	_SCON0,#0x10
;	EFM8_I2C_Nunchuck.c:103: TH1 = 0x100-((SYSCLK/BAUDRATE)/(12L*2L));
	mov	_TH1,#0xEF
;	EFM8_I2C_Nunchuck.c:104: TL1 = TH1;      // Init Timer1
	mov	_TL1,_TH1
;	EFM8_I2C_Nunchuck.c:105: TMOD &= ~0xf0;  // TMOD: timer 1 in 8-bit auto-reload
	anl	_TMOD,#0x0F
;	EFM8_I2C_Nunchuck.c:106: TMOD |=  0x20;                       
	orl	_TMOD,#0x20
;	EFM8_I2C_Nunchuck.c:107: TR1 = 1; 	// START Timer1
	setb	_TR1
;	EFM8_I2C_Nunchuck.c:108: TI = 1;  	// Indicate TX0 ready
	setb	_TI
;	EFM8_I2C_Nunchuck.c:110: P2MDOUT|=0b_0000_0011;
	orl	_P2MDOUT,#0x03
;	EFM8_I2C_Nunchuck.c:111: P0MDOUT |= 0x10; 		// Enable UART0 TX as push-pull output
	orl	_P0MDOUT,#0x10
;	EFM8_I2C_Nunchuck.c:112: XBR0 = 0b_0000_0101; 	// Enable SMBus pins and UART pins P0.4(TX) and P0.5(RX)
	mov	_XBR0,#0x05
;	EFM8_I2C_Nunchuck.c:113: XBR1 = 0X00;
	mov	_XBR1,#0x00
;	EFM8_I2C_Nunchuck.c:114: XBR2 = 0x40; // Enable crossbar and weak pull-ups
	mov	_XBR2,#0x40
;	EFM8_I2C_Nunchuck.c:117: CKCON0 |= 0b_0000_0100; // Timer0 clock source = SYSCLK
	orl	_CKCON0,#0x04
;	EFM8_I2C_Nunchuck.c:118: TMOD &= 0xf0;  // Mask out timer 1 bits
	anl	_TMOD,#0xF0
;	EFM8_I2C_Nunchuck.c:119: TMOD |= 0x02;  // Timer0 in 8-bit auto-reload mode
	orl	_TMOD,#0x02
;	EFM8_I2C_Nunchuck.c:121: TL0 = TH0 = 256-(SYSCLK/SMB_FREQUENCY/3);
	mov	_TH0,#0x60
	mov	_TL0,#0x60
;	EFM8_I2C_Nunchuck.c:122: TR0 = 1; // Enable timer 0
	setb	_TR0
;	EFM8_I2C_Nunchuck.c:125: SMB0CF = 0b_0101_1100; //INH | EXTHOLD | SMBTOE | SMBFTE ;
	mov	_SMB0CF,#0x5C
;	EFM8_I2C_Nunchuck.c:126: SMB0CF |= 0b_1000_0000;  // Enable SMBus
	orl	_SMB0CF,#0x80
;	EFM8_I2C_Nunchuck.c:129: TMR2CN0=0x00;   // Stop Timer2; Clear TF2;
	mov	_TMR2CN0,#0x00
;	EFM8_I2C_Nunchuck.c:130: CKCON0|=0b_0001_0000;
	orl	_CKCON0,#0x10
;	EFM8_I2C_Nunchuck.c:131: TMR2RL=(-(SYSCLK/(2*DEFAULT_F))); // Initialize reload value
	mov	_TMR2RL,#0xF4
	mov	(_TMR2RL >> 8),#0xF9
;	EFM8_I2C_Nunchuck.c:132: TMR2=0xffff;   // Set to reload immediately
	mov	_TMR2,#0xFF
	mov	(_TMR2 >> 8),#0xFF
;	EFM8_I2C_Nunchuck.c:133: ET2=1;         // Enable Timer2 interrupts
	setb	_ET2
;	EFM8_I2C_Nunchuck.c:134: TR2=1;         // Start Timer2
	setb	_TR2
;	EFM8_I2C_Nunchuck.c:136: return 0;
	mov	dpl,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer2_ISR'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:139: void Timer2_ISR (void) interrupt INTERRUPT_TIMER2
;	-----------------------------------------
;	 function Timer2_ISR
;	-----------------------------------------
_Timer2_ISR:
	push	psw
	mov	psw,#0x00
;	EFM8_I2C_Nunchuck.c:141: TF2H = 0; // Clear Timer2 interrupt flag
	clr	_TF2H
;	EFM8_I2C_Nunchuck.c:142: OUT0=!OUT0;
	cpl	_P2_0
;	EFM8_I2C_Nunchuck.c:143: OUT1=!OUT0;
	mov	c,_P2_0
	cpl	c
	mov	_P2_1,c
	pop	psw
	reti
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer3us'
;------------------------------------------------------------
;us                        Allocated to registers r2 
;i                         Allocated to registers r3 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:148: void Timer3us(unsigned char us)
;	-----------------------------------------
;	 function Timer3us
;	-----------------------------------------
_Timer3us:
	mov	r2,dpl
;	EFM8_I2C_Nunchuck.c:153: CKCON0|=0b_0100_0000;
	orl	_CKCON0,#0x40
;	EFM8_I2C_Nunchuck.c:155: TMR3RL = (-(SYSCLK)/1000000L); 	// Set Timer3 to overflow in 1us.
	mov	_TMR3RL,#0xD0
	mov	(_TMR3RL >> 8),#0xFF
;	EFM8_I2C_Nunchuck.c:156: TMR3 = TMR3RL;                 	// Initialize Timer3 for first overflow
	mov	_TMR3,_TMR3RL
	mov	(_TMR3 >> 8),(_TMR3RL >> 8)
;	EFM8_I2C_Nunchuck.c:158: TMR3CN0 = 0x04;                 // Start Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x04
;	EFM8_I2C_Nunchuck.c:159: for (i = 0; i < us; i++)       	// Count <us> overflows
	mov	r3,#0x00
L004006?:
	clr	c
	mov	a,r3
	subb	a,r2
	jnc	L004009?
;	EFM8_I2C_Nunchuck.c:161: while (!(TMR3CN0 & 0x80));  // Wait for overflow
L004001?:
	mov	a,_TMR3CN0
	jnb	acc.7,L004001?
;	EFM8_I2C_Nunchuck.c:162: TMR3CN0 &= ~(0x80);         // Clear overflow indicator
	anl	_TMR3CN0,#0x7F
;	EFM8_I2C_Nunchuck.c:163: if (TF0)
;	EFM8_I2C_Nunchuck.c:165: TF0=0;
	jbc	_TF0,L004019?
	sjmp	L004008?
L004019?:
;	EFM8_I2C_Nunchuck.c:166: overflow_count++;
	inc	_overflow_count
L004008?:
;	EFM8_I2C_Nunchuck.c:159: for (i = 0; i < us; i++)       	// Count <us> overflows
	inc	r3
	sjmp	L004006?
L004009?:
;	EFM8_I2C_Nunchuck.c:169: TMR3CN0 = 0 ;                   // Stop Timer3 and clear overflow flag
	mov	_TMR3CN0,#0x00
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'waitms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 r3 
;j                         Allocated to registers r4 r5 
;k                         Allocated to registers r6 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:172: void waitms (unsigned int ms)
;	-----------------------------------------
;	 function waitms
;	-----------------------------------------
_waitms:
	mov	r2,dpl
	mov	r3,dph
;	EFM8_I2C_Nunchuck.c:176: for(j=0; j<ms; j++)
	mov	r4,#0x00
	mov	r5,#0x00
L005005?:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	L005009?
;	EFM8_I2C_Nunchuck.c:177: for (k=0; k<4; k++) Timer3us(250);
	mov	r6,#0x00
L005001?:
	cjne	r6,#0x04,L005018?
L005018?:
	jnc	L005007?
	mov	dpl,#0xFA
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_Timer3us
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r6
	sjmp	L005001?
L005007?:
;	EFM8_I2C_Nunchuck.c:176: for(j=0; j<ms; j++)
	inc	r4
	cjne	r4,#0x00,L005005?
	inc	r5
	sjmp	L005005?
L005009?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_pulse'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:180: void LCD_pulse (void)
;	-----------------------------------------
;	 function LCD_pulse
;	-----------------------------------------
_LCD_pulse:
;	EFM8_I2C_Nunchuck.c:182: LCD_E=1;
	setb	_P2_5
;	EFM8_I2C_Nunchuck.c:183: Timer3us(40);
	mov	dpl,#0x28
	lcall	_Timer3us
;	EFM8_I2C_Nunchuck.c:184: LCD_E=0;
	clr	_P2_5
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_byte'
;------------------------------------------------------------
;x                         Allocated to registers r2 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:187: void LCD_byte (unsigned char x)
;	-----------------------------------------
;	 function LCD_byte
;	-----------------------------------------
_LCD_byte:
	mov	r2,dpl
;	EFM8_I2C_Nunchuck.c:190: ACC=x; 			//Send high nible
	mov	_ACC,r2
;	EFM8_I2C_Nunchuck.c:191: LCD_D7=ACC_7;
	mov	c,_ACC_7
	mov	_P2_1,c
;	EFM8_I2C_Nunchuck.c:192: LCD_D6=ACC_6;
	mov	c,_ACC_6
	mov	_P2_2,c
;	EFM8_I2C_Nunchuck.c:193: LCD_D5=ACC_5;
	mov	c,_ACC_5
	mov	_P2_3,c
;	EFM8_I2C_Nunchuck.c:194: LCD_D4=ACC_4;
	mov	c,_ACC_4
	mov	_P2_4,c
;	EFM8_I2C_Nunchuck.c:195: LCD_pulse();
	push	ar2
	lcall	_LCD_pulse
;	EFM8_I2C_Nunchuck.c:196: Timer3us(40);
	mov	dpl,#0x28
	lcall	_Timer3us
	pop	ar2
;	EFM8_I2C_Nunchuck.c:197: ACC=x; 			//Send low nible
	mov	_ACC,r2
;	EFM8_I2C_Nunchuck.c:198: LCD_D7=ACC_3;
	mov	c,_ACC_3
	mov	_P2_1,c
;	EFM8_I2C_Nunchuck.c:199: LCD_D6=ACC_2;
	mov	c,_ACC_2
	mov	_P2_2,c
;	EFM8_I2C_Nunchuck.c:200: LCD_D5=ACC_1;
	mov	c,_ACC_1
	mov	_P2_3,c
;	EFM8_I2C_Nunchuck.c:201: LCD_D4=ACC_0;
	mov	c,_ACC_0
	mov	_P2_4,c
;	EFM8_I2C_Nunchuck.c:202: LCD_pulse();
	ljmp	_LCD_pulse
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteData'
;------------------------------------------------------------
;x                         Allocated to registers 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:205: void WriteData (unsigned char x)
;	-----------------------------------------
;	 function WriteData
;	-----------------------------------------
_WriteData:
;	EFM8_I2C_Nunchuck.c:207: LCD_RS=1;
	setb	_P2_6
;	EFM8_I2C_Nunchuck.c:208: LCD_byte(x);
	lcall	_LCD_byte
;	EFM8_I2C_Nunchuck.c:209: waitms(2);
	mov	dptr,#0x0002
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'WriteCommand'
;------------------------------------------------------------
;x                         Allocated to registers 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:212: void WriteCommand (unsigned char x)
;	-----------------------------------------
;	 function WriteCommand
;	-----------------------------------------
_WriteCommand:
;	EFM8_I2C_Nunchuck.c:214: LCD_RS=0;
	clr	_P2_6
;	EFM8_I2C_Nunchuck.c:215: LCD_byte(x);
	lcall	_LCD_byte
;	EFM8_I2C_Nunchuck.c:216: waitms(5);
	mov	dptr,#0x0005
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCD_4BIT'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:219: void LCD_4BIT (void)
;	-----------------------------------------
;	 function LCD_4BIT
;	-----------------------------------------
_LCD_4BIT:
;	EFM8_I2C_Nunchuck.c:221: LCD_E=0; 		// Resting state of LCD's enable is zero
	clr	_P2_5
;	EFM8_I2C_Nunchuck.c:223: waitms(20);
	mov	dptr,#0x0014
	lcall	_waitms
;	EFM8_I2C_Nunchuck.c:225: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:226: WriteCommand(0x33);
	mov	dpl,#0x33
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:227: WriteCommand(0x32); // Change to 4-bit mode
	mov	dpl,#0x32
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:230: WriteCommand(0x28);
	mov	dpl,#0x28
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:231: WriteCommand(0x0c);
	mov	dpl,#0x0C
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:232: WriteCommand(0x01); // Clear screen command (takes some time)
	mov	dpl,#0x01
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:233: waitms(20); 		// Wait for clear screen command to finsih.
	mov	dptr,#0x0014
	ljmp	_waitms
;------------------------------------------------------------
;Allocation info for local variables in function 'LCDprint'
;------------------------------------------------------------
;line                      Allocated with name '_LCDprint_PARM_2'
;string                    Allocated to registers r2 r3 r4 
;j                         Allocated to registers r5 r6 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:236: void LCDprint(char * string, unsigned char line, bit clear)
;	-----------------------------------------
;	 function LCDprint
;	-----------------------------------------
_LCDprint:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	EFM8_I2C_Nunchuck.c:240: WriteCommand(line==2?0xc0:0x80);
	mov	a,#0x02
	cjne	a,_LCDprint_PARM_2,L011013?
	mov	r5,#0xC0
	sjmp	L011014?
L011013?:
	mov	r5,#0x80
L011014?:
	mov	dpl,r5
	push	ar2
	push	ar3
	push	ar4
	lcall	_WriteCommand
;	EFM8_I2C_Nunchuck.c:241: waitms(5);
	mov	dptr,#0x0005
	lcall	_waitms
	pop	ar4
	pop	ar3
	pop	ar2
;	EFM8_I2C_Nunchuck.c:242: for(j=0; string[j]!=0; j++)	WriteData(string[j]);		// Write the message
	mov	r5,#0x00
	mov	r6,#0x00
L011003?:
	mov	a,r5
	add	a,r2
	mov	r7,a
	mov	a,r6
	addc	a,r3
	mov	r0,a
	mov	ar1,r4
	mov	dpl,r7
	mov	dph,r0
	mov	b,r1
	lcall	__gptrget
	mov	r7,a
	jz	L011006?
	mov	dpl,r7
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	lcall	_WriteData
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	inc	r5
	cjne	r5,#0x00,L011003?
	inc	r6
	sjmp	L011003?
L011006?:
;	EFM8_I2C_Nunchuck.c:243: if(clear) for(; j<CHARS_PER_LINE; j++) WriteData(' '); 	// Clear the rest of the line
	jnb	_LCDprint_PARM_3,L011011?
	mov	ar2,r5
	mov	ar3,r6
L011007?:
	clr	c
	mov	a,r2
	subb	a,#0x10
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L011011?
	mov	dpl,#0x20
	push	ar2
	push	ar3
	lcall	_WriteData
	pop	ar3
	pop	ar2
	inc	r2
	cjne	r2,#0x00,L011007?
	inc	r3
	sjmp	L011007?
L011011?:
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'Timer4ms'
;------------------------------------------------------------
;ms                        Allocated to registers r2 
;i                         Allocated to registers r4 
;k                         Allocated to registers r3 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:249: void Timer4ms(unsigned char ms)
;	-----------------------------------------
;	 function Timer4ms
;	-----------------------------------------
_Timer4ms:
	mov	r2,dpl
;	EFM8_I2C_Nunchuck.c:254: k=SFRPAGE;
	mov	r3,_SFRPAGE
;	EFM8_I2C_Nunchuck.c:255: SFRPAGE=0x10;
	mov	_SFRPAGE,#0x10
;	EFM8_I2C_Nunchuck.c:257: CKCON1|=0b_0000_0001;
	orl	_CKCON1,#0x01
;	EFM8_I2C_Nunchuck.c:259: TMR4RL = 65536-(SYSCLK/1000L); // Set Timer4 to overflow in 1 ms.
	mov	_TMR4RL,#0x80
	mov	(_TMR4RL >> 8),#0x44
;	EFM8_I2C_Nunchuck.c:260: TMR4 = TMR4RL;                 // Initialize Timer4 for first overflow
	mov	_TMR4,_TMR4RL
	mov	(_TMR4 >> 8),(_TMR4RL >> 8)
;	EFM8_I2C_Nunchuck.c:262: TF4H=0; 	// Clear overflow flag
	clr	_TF4H
;	EFM8_I2C_Nunchuck.c:263: TR4=1;  	// Start Timer4
	setb	_TR4
;	EFM8_I2C_Nunchuck.c:264: for (i = 0; i < ms; i++)       // Count <ms> overflows
	mov	r4,#0x00
L012004?:
	clr	c
	mov	a,r4
	subb	a,r2
	jnc	L012007?
;	EFM8_I2C_Nunchuck.c:266: while (!TF4H);  // Wait for overflow
L012001?:
;	EFM8_I2C_Nunchuck.c:267: TF4H=0;         // Clear overflow indicator
	jbc	_TF4H,L012015?
	sjmp	L012001?
L012015?:
;	EFM8_I2C_Nunchuck.c:264: for (i = 0; i < ms; i++)       // Count <ms> overflows
	inc	r4
	sjmp	L012004?
L012007?:
;	EFM8_I2C_Nunchuck.c:269: TR4=0; 		// Stop Timer4
	clr	_TR4
;	EFM8_I2C_Nunchuck.c:270: SFRPAGE=k;	
	mov	_SFRPAGE,r3
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_write'
;------------------------------------------------------------
;output_data               Allocated to registers 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:273: void I2C_write (unsigned char output_data)
;	-----------------------------------------
;	 function I2C_write
;	-----------------------------------------
_I2C_write:
	mov	_SMB0DAT,dpl
;	EFM8_I2C_Nunchuck.c:276: SI = 0;
	clr	_SI
;	EFM8_I2C_Nunchuck.c:277: while (!SI); 			// Wait until done with send
L013001?:
	jnb	_SI,L013001?
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_read'
;------------------------------------------------------------
;input_data                Allocated to registers 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:280: unsigned char I2C_read (void)
;	-----------------------------------------
;	 function I2C_read
;	-----------------------------------------
_I2C_read:
;	EFM8_I2C_Nunchuck.c:284: SI = 0;
	clr	_SI
;	EFM8_I2C_Nunchuck.c:285: while (!SI); 			// Wait until we have data to read
L014001?:
	jnb	_SI,L014001?
;	EFM8_I2C_Nunchuck.c:286: input_data = SMB0DAT; 	// Read the data
	mov	dpl,_SMB0DAT
;	EFM8_I2C_Nunchuck.c:288: return input_data;
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_start'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:291: void I2C_start (void)
;	-----------------------------------------
;	 function I2C_start
;	-----------------------------------------
_I2C_start:
;	EFM8_I2C_Nunchuck.c:293: ACK = 1;
	setb	_ACK
;	EFM8_I2C_Nunchuck.c:294: STA = 1;     // Send I2C start
	setb	_STA
;	EFM8_I2C_Nunchuck.c:295: STO = 0;
	clr	_STO
;	EFM8_I2C_Nunchuck.c:296: SI = 0;
	clr	_SI
;	EFM8_I2C_Nunchuck.c:297: while (!SI); // Wait until start sent
L015001?:
	jnb	_SI,L015001?
;	EFM8_I2C_Nunchuck.c:298: STA = 0;     // Reset I2C start
	clr	_STA
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'I2C_stop'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:301: void I2C_stop(void)
;	-----------------------------------------
;	 function I2C_stop
;	-----------------------------------------
_I2C_stop:
;	EFM8_I2C_Nunchuck.c:303: STO = 1;  		// Perform I2C stop
	setb	_STO
;	EFM8_I2C_Nunchuck.c:304: SI = 0;			// Clear SI
	clr	_SI
	ret
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_init'
;------------------------------------------------------------
;i                         Allocated to registers r2 
;buf                       Allocated with name '_nunchuck_init_buf_1_106'
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:308: void nunchuck_init(bit print_extension_type)
;	-----------------------------------------
;	 function nunchuck_init
;	-----------------------------------------
_nunchuck_init:
;	EFM8_I2C_Nunchuck.c:313: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:314: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:315: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:316: I2C_write(0x55);
	mov	dpl,#0x55
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:317: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:318: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:320: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:321: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:322: I2C_write(0xFB);
	mov	dpl,#0xFB
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:323: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:324: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:325: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:329: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:330: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:331: I2C_write(0xFA); 	// extension type register
	mov	dpl,#0xFA
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:332: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:333: Timer4ms(3); 		// 3 ms required to complete acquisition
	mov	dpl,#0x03
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:335: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:336: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:339: for(i=0; i<6; i++)
	mov	r2,#0x00
L017001?:
	cjne	r2,#0x06,L017010?
L017010?:
	jnc	L017004?
;	EFM8_I2C_Nunchuck.c:341: buf[i]=I2C_read();
	mov	a,r2
	add	a,#_nunchuck_init_buf_1_106
	mov	r0,a
	push	ar2
	push	ar0
	lcall	_I2C_read
	mov	a,dpl
	pop	ar0
	pop	ar2
	mov	@r0,a
;	EFM8_I2C_Nunchuck.c:339: for(i=0; i<6; i++)
	inc	r2
	sjmp	L017001?
L017004?:
;	EFM8_I2C_Nunchuck.c:343: ACK=0;
	clr	_ACK
;	EFM8_I2C_Nunchuck.c:344: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:345: Timer4ms(3);
	mov	dpl,#0x03
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:355: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:356: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:357: I2C_write(0xF0);
	mov	dpl,#0xF0
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:358: I2C_write(0xAA);
	mov	dpl,#0xAA
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:359: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:360: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:362: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:363: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:364: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:365: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:366: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:367: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:368: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:369: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:370: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:371: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:372: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:374: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:375: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:376: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:377: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:378: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:379: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:380: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:381: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:382: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:383: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:384: Timer4ms(1);
	mov	dpl,#0x01
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:386: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:387: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:388: I2C_write(0x40);
	mov	dpl,#0x40
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:389: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:390: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:391: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:392: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:393: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:394: Timer4ms(1);
	mov	dpl,#0x01
	ljmp	_Timer4ms
;------------------------------------------------------------
;Allocation info for local variables in function 'nunchuck_getdata'
;------------------------------------------------------------
;s                         Allocated to registers r2 r3 r4 
;i                         Allocated to registers r5 
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:397: void nunchuck_getdata(unsigned char * s)
;	-----------------------------------------
;	 function nunchuck_getdata
;	-----------------------------------------
_nunchuck_getdata:
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
;	EFM8_I2C_Nunchuck.c:402: I2C_start();
	push	ar2
	push	ar3
	push	ar4
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:403: I2C_write(0xA4);
	mov	dpl,#0xA4
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:404: I2C_write(0x00);
	mov	dpl,#0x00
	lcall	_I2C_write
;	EFM8_I2C_Nunchuck.c:405: I2C_stop();
	lcall	_I2C_stop
;	EFM8_I2C_Nunchuck.c:406: Timer4ms(3); 	// 3 ms required to complete acquisition
	mov	dpl,#0x03
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:409: I2C_start();
	lcall	_I2C_start
;	EFM8_I2C_Nunchuck.c:410: I2C_write(0xA5);
	mov	dpl,#0xA5
	lcall	_I2C_write
	pop	ar4
	pop	ar3
	pop	ar2
;	EFM8_I2C_Nunchuck.c:413: for(i=0; i<6; i++)
	mov	r5,#0x00
L018001?:
	cjne	r5,#0x06,L018010?
L018010?:
	jnc	L018004?
;	EFM8_I2C_Nunchuck.c:415: s[i]=(I2C_read()^0x17)+0x17; // Read and decrypt
	mov	a,r5
	add	a,r2
	mov	r6,a
	clr	a
	addc	a,r3
	mov	r7,a
	mov	ar0,r4
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	push	ar0
	lcall	_I2C_read
	mov	a,dpl
	pop	ar0
	pop	ar7
	pop	ar6
	pop	ar5
	pop	ar4
	pop	ar3
	pop	ar2
	xrl	a,#0x17
	add	a,#0x17
	mov	r1,a
	mov	dpl,r6
	mov	dph,r7
	mov	b,r0
	lcall	__gptrput
;	EFM8_I2C_Nunchuck.c:413: for(i=0; i<6; i++)
	inc	r5
	sjmp	L018001?
L018004?:
;	EFM8_I2C_Nunchuck.c:417: ACK=0;
	clr	_ACK
;	EFM8_I2C_Nunchuck.c:418: I2C_stop();
	ljmp	_I2C_stop
;------------------------------------------------------------
;Allocation info for local variables in function 'serial'
;------------------------------------------------------------
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:422: void serial (void) interrupt 4{
;	-----------------------------------------
;	 function serial
;	-----------------------------------------
_serial:
;	EFM8_I2C_Nunchuck.c:423: if(RI == 1){
;	EFM8_I2C_Nunchuck.c:424: RI = 0;
	jbc	_RI,L019006?
	sjmp	L019003?
L019006?:
;	EFM8_I2C_Nunchuck.c:425: SFRPAGE = 0x20;
	mov	_SFRPAGE,#0x20
;	EFM8_I2C_Nunchuck.c:426: c = SBUF0;
	mov	_c,_SBUF0
;	EFM8_I2C_Nunchuck.c:427: SFRPAGE = 0x00;
	mov	_SFRPAGE,#0x00
L019003?:
	reti
;	eliminated unneeded push/pop psw
;	eliminated unneeded push/pop dpl
;	eliminated unneeded push/pop dph
;	eliminated unneeded push/pop b
;	eliminated unneeded push/pop acc
;------------------------------------------------------------
;Allocation info for local variables in function 'main'
;------------------------------------------------------------
;x                         Allocated with name '_main_x_1_116'
;f                         Allocated with name '_main_f_1_116'
;i                         Allocated to registers 
;rbuf                      Allocated with name '_main_rbuf_1_116'
;joy_x                     Allocated with name '_main_joy_x_1_116'
;joy_y                     Allocated with name '_main_joy_y_1_116'
;off_x                     Allocated with name '_main_off_x_1_116'
;off_y                     Allocated with name '_main_off_y_1_116'
;acc_x                     Allocated with name '_main_acc_x_1_116'
;acc_y                     Allocated with name '_main_acc_y_1_116'
;acc_z                     Allocated with name '_main_acc_z_1_116'
;angle                     Allocated to registers r2 r3 
;magnitude                 Allocated with name '_main_magnitude_1_116'
;konamiProg                Allocated with name '_main_konamiProg_1_116'
;koldProg                  Allocated with name '_main_koldProg_1_116'
;accelLoop                 Allocated with name '_main_accelLoop_1_116'
;sloc4                     Allocated with name '_main_sloc4_1_0'
;------------------------------------------------------------
;	EFM8_I2C_Nunchuck.c:432: void main (void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	EFM8_I2C_Nunchuck.c:463: int konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:464: bit konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:467: int koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:468: bit koldReady = 0;
	clr	_main_koldReady_1_116
;	EFM8_I2C_Nunchuck.c:470: bit shakeDir = 0;
	clr	_main_shakeDir_1_116
;	EFM8_I2C_Nunchuck.c:474: int accelLoop = -1;
	mov	_main_accelLoop_1_116,#0xFF
	mov	(_main_accelLoop_1_116 + 1),#0xFF
;	EFM8_I2C_Nunchuck.c:476: EA = 1;
	setb	_EA
;	EFM8_I2C_Nunchuck.c:477: ES0 = 1;
	setb	_ES0
;	EFM8_I2C_Nunchuck.c:478: ET2=1;
	setb	_ET2
;	EFM8_I2C_Nunchuck.c:481: TR2=0; 					// Stop timer 2
	clr	_TR2
;	EFM8_I2C_Nunchuck.c:482: TMR2RL=0x10000L-x; 		// Change reload value for new frequency
	mov	_TMR2RL,#0xFF
	mov	(_TMR2RL >> 8),#0xF9
;	EFM8_I2C_Nunchuck.c:483: TR2=1; 					// Start timer 2
	setb	_TR2
;	EFM8_I2C_Nunchuck.c:484: f=SYSCLK/(2L*(0x10000L-TMR2RL));
	mov	r6,_TMR2RL
	mov	r7,(_TMR2RL >> 8)
	clr	a
	mov	r4,a
	mov	r5,a
	clr	c
	subb	a,r6
	mov	r6,a
	clr	a
	subb	a,r7
	mov	r7,a
	mov	a,#0x01
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r5
	mov	r5,a
	mov	a,r6
	add	a,r6
	mov	__divslong_PARM_2,a
	mov	a,r7
	rlc	a
	mov	(__divslong_PARM_2 + 1),a
	mov	a,r4
	rlc	a
	mov	(__divslong_PARM_2 + 2),a
	mov	a,r5
	rlc	a
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0x6C00
	mov	b,#0xDC
	mov	a,#0x02
	lcall	__divslong
	mov	_main_f_1_116,dpl
	mov	(_main_f_1_116 + 1),dph
	mov	(_main_f_1_116 + 2),b
	mov	(_main_f_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:486: Timer4ms(200);
	mov	dpl,#0xC8
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:487: nunchuck_init(1);
	setb	_nunchuck_init_PARM_1
	lcall	_nunchuck_init
;	EFM8_I2C_Nunchuck.c:488: Timer4ms(100);
	mov	dpl,#0x64
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:490: nunchuck_getdata(rbuf);
	mov	dptr,#_main_rbuf_1_116
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	EFM8_I2C_Nunchuck.c:492: off_x=(int)rbuf[0]-128;
	mov	r4,_main_rbuf_1_116
	mov	r5,#0x00
	mov	a,r4
	add	a,#0x80
	mov	_main_off_x_1_116,a
	mov	a,r5
	addc	a,#0xff
	mov	(_main_off_x_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:493: off_y=(int)rbuf[1]-128;
	mov	r6,(_main_rbuf_1_116 + 0x0001)
	mov	r7,#0x00
	mov	a,r6
	add	a,#0x80
	mov	_main_off_y_1_116,a
	mov	a,r7
	addc	a,#0xff
	mov	(_main_off_y_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:495: while(1){
L020188?:
;	EFM8_I2C_Nunchuck.c:496: nunchuck_getdata(rbuf);
	mov	dptr,#_main_rbuf_1_116
	mov	b,#0x40
	lcall	_nunchuck_getdata
;	EFM8_I2C_Nunchuck.c:498: joy_x=(int)rbuf[0]-128-off_x;
	mov	r6,_main_rbuf_1_116
	mov	r7,#0x00
	mov	a,r6
	add	a,#0x80
	mov	r6,a
	mov	a,r7
	addc	a,#0xff
	mov	r7,a
	mov	a,r6
	clr	c
	subb	a,_main_off_x_1_116
	mov	_main_joy_x_1_116,a
	mov	a,r7
	subb	a,(_main_off_x_1_116 + 1)
	mov	(_main_joy_x_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:499: joy_y=(int)rbuf[1]-128-off_y;
	mov	r4,(_main_rbuf_1_116 + 0x0001)
	mov	r5,#0x00
	mov	a,r4
	add	a,#0x80
	mov	r4,a
	mov	a,r5
	addc	a,#0xff
	mov	r5,a
	mov	a,r4
	clr	c
	subb	a,_main_off_y_1_116
	mov	_main_joy_y_1_116,a
	mov	a,r5
	subb	a,(_main_off_y_1_116 + 1)
	mov	(_main_joy_y_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:500: acc_x=rbuf[2]*4; 
	mov	a,(_main_rbuf_1_116 + 0x0002)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_x_1_116,a
	mov	(_main_acc_x_1_116 + 1),b
;	EFM8_I2C_Nunchuck.c:501: acc_y=rbuf[3]*4;
	mov	a,(_main_rbuf_1_116 + 0x0003)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_y_1_116,a
	mov	(_main_acc_y_1_116 + 1),b
;	EFM8_I2C_Nunchuck.c:502: acc_z=rbuf[4]*4;
	mov	a,(_main_rbuf_1_116 + 0x0004)
	mov	b,#0x04
	mul	ab
	mov	_main_acc_z_1_116,a
	mov	(_main_acc_z_1_116 + 1),b
;	EFM8_I2C_Nunchuck.c:504: but1=(rbuf[5] & 0x01)?1:0;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	rrc	a
	mov	_main_but1_1_116,c
;	EFM8_I2C_Nunchuck.c:505: but2=(rbuf[5] & 0x02)?1:0;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	mov	c,acc.1
	mov	_main_but2_1_116,c
;	EFM8_I2C_Nunchuck.c:506: if (rbuf[5] & 0x04) acc_x+=2;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.2,L020002?
	mov	a,#0x02
	add	a,_main_acc_x_1_116
	mov	_main_acc_x_1_116,a
	clr	a
	addc	a,(_main_acc_x_1_116 + 1)
	mov	(_main_acc_x_1_116 + 1),a
L020002?:
;	EFM8_I2C_Nunchuck.c:507: if (rbuf[5] & 0x08) acc_x+=1;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.3,L020004?
	inc	_main_acc_x_1_116
	clr	a
	cjne	a,_main_acc_x_1_116,L020263?
	inc	(_main_acc_x_1_116 + 1)
L020263?:
L020004?:
;	EFM8_I2C_Nunchuck.c:508: if (rbuf[5] & 0x10) acc_y+=2;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.4,L020006?
	mov	a,#0x02
	add	a,_main_acc_y_1_116
	mov	_main_acc_y_1_116,a
	clr	a
	addc	a,(_main_acc_y_1_116 + 1)
	mov	(_main_acc_y_1_116 + 1),a
L020006?:
;	EFM8_I2C_Nunchuck.c:509: if (rbuf[5] & 0x20) acc_y+=1;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.5,L020008?
	inc	_main_acc_y_1_116
	clr	a
	cjne	a,_main_acc_y_1_116,L020266?
	inc	(_main_acc_y_1_116 + 1)
L020266?:
L020008?:
;	EFM8_I2C_Nunchuck.c:510: if (rbuf[5] & 0x40) acc_z+=2;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.6,L020010?
	mov	a,#0x02
	add	a,_main_acc_z_1_116
	mov	_main_acc_z_1_116,a
	clr	a
	addc	a,(_main_acc_z_1_116 + 1)
	mov	(_main_acc_z_1_116 + 1),a
L020010?:
;	EFM8_I2C_Nunchuck.c:511: if (rbuf[5] & 0x80) acc_z+=1;
	mov	a,(_main_rbuf_1_116 + 0x0005)
	jnb	acc.7,L020012?
	inc	_main_acc_z_1_116
	clr	a
	cjne	a,_main_acc_z_1_116,L020269?
	inc	(_main_acc_z_1_116 + 1)
L020269?:
L020012?:
;	EFM8_I2C_Nunchuck.c:515: signal_stream0 = 1;
	setb	_main_signal_stream0_1_116
;	EFM8_I2C_Nunchuck.c:516: signal_stream1 = 0;
	clr	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:517: signal_stream2 = 0;
	clr	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:518: signal_stream3 = 0;
	clr	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:519: signal_stream4 = 0;
	clr	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:520: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:521: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:522: signal_stream7 = 0;
	clr	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:523: signal_stream8 = 0;
	clr	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:525: magnitude = sqrtf(joy_x*joy_x + joy_y*joy_y) * (15.0/100);
	mov	__mulint_PARM_2,_main_joy_x_1_116
	mov	(__mulint_PARM_2 + 1),(_main_joy_x_1_116 + 1)
	mov	dpl,_main_joy_x_1_116
	mov	dph,(_main_joy_x_1_116 + 1)
	lcall	__mulint
	mov	r4,dpl
	mov	r5,dph
	mov	__mulint_PARM_2,_main_joy_y_1_116
	mov	(__mulint_PARM_2 + 1),(_main_joy_y_1_116 + 1)
	mov	dpl,_main_joy_y_1_116
	mov	dph,(_main_joy_y_1_116 + 1)
	push	ar4
	push	ar5
	lcall	__mulint
	mov	r6,dpl
	mov	r7,dph
	pop	ar5
	pop	ar4
	mov	a,r6
	add	a,r4
	mov	dpl,a
	mov	a,r7
	addc	a,r5
	mov	dph,a
	lcall	___sint2fs
	lcall	_sqrtf
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	push	ar4
	push	ar5
	push	ar6
	push	ar7
	mov	dptr,#0x999A
	mov	b,#0x19
	mov	a,#0x3E
	lcall	___fsmul
	mov	r4,dpl
	mov	r5,dph
	mov	r6,b
	mov	r7,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,r4
	mov	dph,r5
	mov	b,r6
	mov	a,r7
	lcall	___fs2sint
	mov	_main_magnitude_1_116,dpl
	mov	(_main_magnitude_1_116 + 1),dph
;	EFM8_I2C_Nunchuck.c:529: if(c == 'U'){
	mov	a,#0x55
	cjne	a,_c,L020022?
;	EFM8_I2C_Nunchuck.c:530: signal_stream1 = 0;
	clr	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:531: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:532: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:533: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:534: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:535: c = 'Z';
	mov	_c,#0x5A
;	EFM8_I2C_Nunchuck.c:536: goto send;
	ljmp	L020180?
L020022?:
;	EFM8_I2C_Nunchuck.c:538: else if(c == 'L'){
	mov	a,#0x4C
	cjne	a,_c,L020019?
;	EFM8_I2C_Nunchuck.c:539: signal_stream1 = 1;
	setb	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:540: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:541: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:542: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:543: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:544: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:545: c = 'Z';
	mov	_c,#0x5A
;	EFM8_I2C_Nunchuck.c:546: goto send;
	ljmp	L020180?
L020019?:
;	EFM8_I2C_Nunchuck.c:547: }else if(c == 'D'){
	mov	a,#0x44
	cjne	a,_c,L020016?
;	EFM8_I2C_Nunchuck.c:548: signal_stream1 = 0;
	clr	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:549: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:550: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:551: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:552: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:553: c = 'Z';
	mov	_c,#0x5A
;	EFM8_I2C_Nunchuck.c:554: goto send;
	ljmp	L020180?
L020016?:
;	EFM8_I2C_Nunchuck.c:556: else if(c == 'R'){
	mov	a,#0x52
	cjne	a,_c,L020020?
;	EFM8_I2C_Nunchuck.c:557: signal_stream1 = 0;
	clr	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:558: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:559: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:560: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:561: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:562: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:563: c = 'Z';
	mov	_c,#0x5A
;	EFM8_I2C_Nunchuck.c:564: goto send;
	ljmp	L020180?
L020020?:
;	EFM8_I2C_Nunchuck.c:569: if(magnitude <= 0){
	clr	c
	clr	a
	subb	a,_main_magnitude_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_magnitude_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L020278?
	ljmp	L020127?
L020278?:
;	EFM8_I2C_Nunchuck.c:570: if(!but1){
	jb	_main_but1_1_116,L020044?
;	EFM8_I2C_Nunchuck.c:572: signal_stream1 = 1;
	setb	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:573: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:574: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:575: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:577: signal_stream5 = 1;
	setb	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:578: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:579: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:580: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:582: printf("ACCEL ");
	mov	a,#__str_0
	push	acc
	mov	a,#(__str_0 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:584: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020028?
;	EFM8_I2C_Nunchuck.c:585: if(konamiProg == 8){
	mov	a,#0x08
	cjne	a,_main_konamiProg_1_116,L020281?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020281?
	sjmp	L020282?
L020281?:
	sjmp	L020025?
L020282?:
;	EFM8_I2C_Nunchuck.c:586: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020028?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020028?
L020025?:
;	EFM8_I2C_Nunchuck.c:588: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020028?:
;	EFM8_I2C_Nunchuck.c:591: konamiReady = 0;
	clr	_main_konamiReady_1_116
	ljmp	L020128?
L020044?:
;	EFM8_I2C_Nunchuck.c:592: }else if(!but2 || c == 'S'){
	jnb	_main_but2_1_116,L020039?
	mov	a,#0x53
	cjne	a,_c,L020040?
L020039?:
;	EFM8_I2C_Nunchuck.c:594: printf("STOP ");
	mov	a,#__str_1
	push	acc
	mov	a,#(__str_1 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:596: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020033?
;	EFM8_I2C_Nunchuck.c:597: if(konamiProg == 9){
	mov	a,#0x09
	cjne	a,_main_konamiProg_1_116,L020288?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020288?
	sjmp	L020289?
L020288?:
	sjmp	L020030?
L020289?:
;	EFM8_I2C_Nunchuck.c:598: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020033?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020033?
L020030?:
;	EFM8_I2C_Nunchuck.c:600: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020033?:
;	EFM8_I2C_Nunchuck.c:603: konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:605: if(koldReady){
	jnb	_main_koldReady_1_116,L020038?
;	EFM8_I2C_Nunchuck.c:606: if(koldProg == 4){
	mov	a,#0x04
	cjne	a,_main_koldProg_1_116,L020292?
	clr	a
	cjne	a,(_main_koldProg_1_116 + 1),L020292?
	sjmp	L020293?
L020292?:
	sjmp	L020035?
L020293?:
;	EFM8_I2C_Nunchuck.c:607: koldProg++;
	inc	_main_koldProg_1_116
	clr	a
	cjne	a,_main_koldProg_1_116,L020038?
	inc	(_main_koldProg_1_116 + 1)
	sjmp	L020038?
L020035?:
;	EFM8_I2C_Nunchuck.c:609: koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
L020038?:
;	EFM8_I2C_Nunchuck.c:612: koldReady = 0;
	clr	_main_koldReady_1_116
;	EFM8_I2C_Nunchuck.c:613: accelLoop = -1;
	mov	_main_accelLoop_1_116,#0xFF
	mov	(_main_accelLoop_1_116 + 1),#0xFF
	ljmp	L020128?
L020040?:
;	EFM8_I2C_Nunchuck.c:616: printf("IDLE ");
	mov	a,#__str_2
	push	acc
	mov	a,#(__str_2 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:617: konamiReady = 1;
	setb	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:618: koldReady = 1;
	setb	_main_koldReady_1_116
	ljmp	L020128?
L020127?:
;	EFM8_I2C_Nunchuck.c:621: signal_stream0 = 1;
	setb	_main_signal_stream0_1_116
;	EFM8_I2C_Nunchuck.c:622: angle = abs(atanf((float) joy_y / (float) joy_x) * 180/PI);	// Range: 0 to pi/2 -> 0 to 90
	mov	dpl,_main_joy_y_1_116
	mov	dph,(_main_joy_y_1_116 + 1)
	lcall	___sint2fs
	mov	_main_sloc4_1_0,dpl
	mov	(_main_sloc4_1_0 + 1),dph
	mov	(_main_sloc4_1_0 + 2),b
	mov	(_main_sloc4_1_0 + 3),a
	mov	dpl,_main_joy_x_1_116
	mov	dph,(_main_joy_x_1_116 + 1)
	lcall	___sint2fs
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dpl,_main_sloc4_1_0
	mov	dph,(_main_sloc4_1_0 + 1)
	mov	b,(_main_sloc4_1_0 + 2)
	mov	a,(_main_sloc4_1_0 + 3)
	lcall	___fsdiv
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	_atanf
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	push	ar2
	push	ar3
	push	ar4
	push	ar5
	mov	dptr,#0x0000
	mov	b,#0x34
	mov	a,#0x43
	lcall	___fsmul
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	a,#0xDB
	push	acc
	mov	a,#0x0F
	push	acc
	mov	a,#0x49
	push	acc
	mov	a,#0x40
	push	acc
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fsdiv
	mov	r2,dpl
	mov	r3,dph
	mov	r4,b
	mov	r5,a
	mov	a,sp
	add	a,#0xfc
	mov	sp,a
	mov	dpl,r2
	mov	dph,r3
	mov	b,r4
	mov	a,r5
	lcall	___fs2sint
	lcall	_abs
	mov	r2,dpl
	mov	r3,dph
;	EFM8_I2C_Nunchuck.c:625: signal_stream1 = magnitude % 2;						// speed[0]
	mov	__modsint_PARM_2,#0x02
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,_main_magnitude_1_116
	mov	dph,(_main_magnitude_1_116 + 1)
	push	ar2
	push	ar3
	lcall	__modsint
	mov	r4,dpl
	mov	r5,dph
	mov	a,r4
	orl	a,r5
	add	a,#0xff
	mov	_main_sloc0_1_0,c
;	EFM8_I2C_Nunchuck.c:626: signal_stream2 = (magnitude / 2) % 2;				// speed[1]
	mov	__divsint_PARM_2,#0x02
	clr	a
	mov	(__divsint_PARM_2 + 1),a
	mov	dpl,_main_magnitude_1_116
	mov	dph,(_main_magnitude_1_116 + 1)
	lcall	__divsint
	mov	r4,dpl
	mov	r5,dph
	mov	__modsint_PARM_2,#0x02
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r4
	mov	dph,r5
	push	ar4
	push	ar5
	lcall	__modsint
	mov	r6,dpl
	mov	r7,dph
	pop	ar5
	pop	ar4
	mov	a,r6
	orl	a,r7
	add	a,#0xff
	mov	_main_sloc1_1_0,c
;	EFM8_I2C_Nunchuck.c:627: signal_stream3 = ((magnitude / 2) / 2) % 2;			// speed[2]
	mov	__divsint_PARM_2,#0x02
	clr	a
	mov	(__divsint_PARM_2 + 1),a
	mov	dpl,r4
	mov	dph,r5
	lcall	__divsint
	mov	r4,dpl
	mov	r5,dph
	mov	__modsint_PARM_2,#0x02
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r4
	mov	dph,r5
	push	ar4
	push	ar5
	lcall	__modsint
	mov	r6,dpl
	mov	r7,dph
	pop	ar5
	pop	ar4
	mov	a,r6
	orl	a,r7
	add	a,#0xff
	mov	_main_sloc2_1_0,c
;	EFM8_I2C_Nunchuck.c:628: signal_stream4 = (((magnitude / 2) / 2) / 2) % 2;	// speed[3]
	mov	__divsint_PARM_2,#0x02
	clr	a
	mov	(__divsint_PARM_2 + 1),a
	mov	dpl,r4
	mov	dph,r5
	lcall	__divsint
	mov	r4,dpl
	mov	r5,dph
	mov	__modsint_PARM_2,#0x02
	clr	a
	mov	(__modsint_PARM_2 + 1),a
	mov	dpl,r4
	mov	dph,r5
	lcall	__modsint
	mov	r4,dpl
	mov	r5,dph
	pop	ar3
	pop	ar2
	mov	a,r4
	orl	a,r5
	add	a,#0xff
	mov	_main_sloc3_1_0,c
;	EFM8_I2C_Nunchuck.c:630: if(joy_y > JOYMARGIN){				// Forward
	clr	c
	mov	a,#0x0A
	subb	a,_main_joy_y_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_joy_y_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jc	L020295?
	ljmp	L020124?
L020295?:
;	EFM8_I2C_Nunchuck.c:631: if(joy_x < -JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
	clr	c
	mov	a,_main_joy_x_1_116
	subb	a,#0xF6
	mov	a,(_main_joy_x_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L020061?
	clr	c
	mov	a,#0x14
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L020061?
	clr	c
	mov	a,r2
	subb	a,#0x46
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020061?
;	EFM8_I2C_Nunchuck.c:633: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:634: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:635: printf("LTURN ");
	mov	a,#__str_3
	push	acc
	mov	a,#(__str_3 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020061?:
;	EFM8_I2C_Nunchuck.c:636: }else if(joy_x > JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
	clr	c
	mov	a,#0x0A
	subb	a,_main_joy_x_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_joy_x_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L020056?
	clr	c
	mov	a,#0x14
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L020056?
	clr	c
	mov	a,r2
	subb	a,#0x46
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020056?
;	EFM8_I2C_Nunchuck.c:638: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:639: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:640: printf("RTURN ");
	mov	a,#__str_4
	push	acc
	mov	a,#(__str_4 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020056?:
;	EFM8_I2C_Nunchuck.c:641: }else if(angle >= (90 - ANGLEMARGIN)){
	clr	c
	mov	a,r2
	subb	a,#0x46
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jc	L020053?
;	EFM8_I2C_Nunchuck.c:644: signal_stream5 = 1;
	setb	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:645: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:646: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:647: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:649: printf("GO ");
	mov	a,#__str_5
	push	acc
	mov	a,#(__str_5 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:651: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020051?
;	EFM8_I2C_Nunchuck.c:652: if(konamiProg == 0 || konamiProg == 1){
	mov	a,_main_konamiProg_1_116
	orl	a,(_main_konamiProg_1_116 + 1)
	jz	L020046?
	mov	a,#0x01
	cjne	a,_main_konamiProg_1_116,L020305?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020305?
	sjmp	L020306?
L020305?:
	sjmp	L020047?
L020306?:
L020046?:
;	EFM8_I2C_Nunchuck.c:653: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020051?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020051?
L020047?:
;	EFM8_I2C_Nunchuck.c:655: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020051?:
;	EFM8_I2C_Nunchuck.c:658: konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:659: koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
	ljmp	L020128?
L020053?:
;	EFM8_I2C_Nunchuck.c:661: printf("*N/A* ");
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020124?:
;	EFM8_I2C_Nunchuck.c:663: }else if(joy_y < -JOYMARGIN){		// Backward
	clr	c
	mov	a,_main_joy_y_1_116
	subb	a,#0xF6
	mov	a,(_main_joy_y_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x7f
	jc	L020308?
	ljmp	L020121?
L020308?:
;	EFM8_I2C_Nunchuck.c:664: if(joy_x < -JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
	clr	c
	mov	a,_main_joy_x_1_116
	subb	a,#0xF6
	mov	a,(_main_joy_x_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L020085?
	clr	c
	mov	a,#0x14
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L020085?
	clr	c
	mov	a,r2
	subb	a,#0x46
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020085?
;	EFM8_I2C_Nunchuck.c:666: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:667: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:668: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:669: printf("BLTURN ");
	mov	a,#__str_7
	push	acc
	mov	a,#(__str_7 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020085?:
;	EFM8_I2C_Nunchuck.c:670: }else if(joy_x > JOYMARGIN && (angle > ANGLEMARGIN && angle < (90 - ANGLEMARGIN))){
	clr	c
	mov	a,#0x0A
	subb	a,_main_joy_x_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_joy_x_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L020080?
	clr	c
	mov	a,#0x14
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L020080?
	clr	c
	mov	a,r2
	subb	a,#0x46
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020080?
;	EFM8_I2C_Nunchuck.c:672: signal_stream5 = 1;
	setb	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:673: printf("BRTURN ");
	mov	a,#__str_8
	push	acc
	mov	a,#(__str_8 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020080?:
;	EFM8_I2C_Nunchuck.c:674: }else if( angle > 90 - ANGLEMARGIN){
	clr	c
	mov	a,#0x46
	subb	a,r2
	clr	a
	xrl	a,#0x80
	mov	b,r3
	xrl	b,#0x80
	subb	a,b
	jnc	L020077?
;	EFM8_I2C_Nunchuck.c:676: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:677: printf("BACK ");
	mov	a,#__str_9
	push	acc
	mov	a,#(__str_9 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:679: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020070?
;	EFM8_I2C_Nunchuck.c:680: if(konamiProg == 2 || konamiProg == 3){
	mov	a,#0x02
	cjne	a,_main_konamiProg_1_116,L020317?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020317?
	sjmp	L020065?
L020317?:
	mov	a,#0x03
	cjne	a,_main_konamiProg_1_116,L020318?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020318?
	sjmp	L020319?
L020318?:
	sjmp	L020066?
L020319?:
L020065?:
;	EFM8_I2C_Nunchuck.c:681: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020070?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020070?
L020066?:
;	EFM8_I2C_Nunchuck.c:683: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020070?:
;	EFM8_I2C_Nunchuck.c:686: konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:688: if(koldReady){
	jnb	_main_koldReady_1_116,L020075?
;	EFM8_I2C_Nunchuck.c:689: if(koldProg == 2){
	mov	a,#0x02
	cjne	a,_main_koldProg_1_116,L020322?
	clr	a
	cjne	a,(_main_koldProg_1_116 + 1),L020322?
	sjmp	L020323?
L020322?:
	sjmp	L020072?
L020323?:
;	EFM8_I2C_Nunchuck.c:690: koldProg++;
	inc	_main_koldProg_1_116
	clr	a
	cjne	a,_main_koldProg_1_116,L020075?
	inc	(_main_koldProg_1_116 + 1)
	sjmp	L020075?
L020072?:
;	EFM8_I2C_Nunchuck.c:692: koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
L020075?:
;	EFM8_I2C_Nunchuck.c:695: koldReady = 0;
	clr	_main_koldReady_1_116
	ljmp	L020128?
L020077?:
;	EFM8_I2C_Nunchuck.c:697: printf("*N/A* ");
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
	ljmp	L020128?
L020121?:
;	EFM8_I2C_Nunchuck.c:700: if(joy_x > JOYMARGIN && (angle < ANGLEMARGIN)){
	clr	c
	mov	a,#0x0A
	subb	a,_main_joy_x_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_joy_x_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L020117?
	clr	c
	mov	a,r2
	subb	a,#0x14
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020117?
;	EFM8_I2C_Nunchuck.c:702: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:703: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:705: printf("RIGHT ");
	mov	a,#__str_10
	push	acc
	mov	a,#(__str_10 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:707: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020094?
;	EFM8_I2C_Nunchuck.c:708: if(konamiProg == 5 || konamiProg == 7){
	mov	a,#0x05
	cjne	a,_main_konamiProg_1_116,L020328?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020328?
	sjmp	L020089?
L020328?:
	mov	a,#0x07
	cjne	a,_main_konamiProg_1_116,L020329?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020329?
	sjmp	L020330?
L020329?:
	sjmp	L020090?
L020330?:
L020089?:
;	EFM8_I2C_Nunchuck.c:709: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020094?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020094?
L020090?:
;	EFM8_I2C_Nunchuck.c:711: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020094?:
;	EFM8_I2C_Nunchuck.c:714: konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:716: if(koldReady){
	jnb	_main_koldReady_1_116,L020099?
;	EFM8_I2C_Nunchuck.c:717: if(koldProg == 1){
	mov	a,#0x01
	cjne	a,_main_koldProg_1_116,L020333?
	clr	a
	cjne	a,(_main_koldProg_1_116 + 1),L020333?
	sjmp	L020334?
L020333?:
	sjmp	L020096?
L020334?:
;	EFM8_I2C_Nunchuck.c:718: koldProg++;
	inc	_main_koldProg_1_116
	clr	a
	cjne	a,_main_koldProg_1_116,L020099?
	inc	(_main_koldProg_1_116 + 1)
	sjmp	L020099?
L020096?:
;	EFM8_I2C_Nunchuck.c:720: koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
L020099?:
;	EFM8_I2C_Nunchuck.c:723: koldReady = 0;
	clr	_main_koldReady_1_116
	ljmp	L020128?
L020117?:
;	EFM8_I2C_Nunchuck.c:724: }else if(joy_x < -JOYMARGIN && (angle < ANGLEMARGIN)){
	clr	c
	mov	a,_main_joy_x_1_116
	subb	a,#0xF6
	mov	a,(_main_joy_x_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x7f
	jnc	L020113?
	clr	c
	mov	a,r2
	subb	a,#0x14
	mov	a,r3
	xrl	a,#0x80
	subb	a,#0x80
	jnc	L020113?
;	EFM8_I2C_Nunchuck.c:726: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:727: printf("LEFT ");
	mov	a,#__str_11
	push	acc
	mov	a,#(__str_11 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:729: if(konamiReady){
	jnb	_main_konamiReady_1_116,L020105?
;	EFM8_I2C_Nunchuck.c:730: if(konamiProg == 4 || konamiProg == 6){
	mov	a,#0x04
	cjne	a,_main_konamiProg_1_116,L020339?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020339?
	sjmp	L020100?
L020339?:
	mov	a,#0x06
	cjne	a,_main_konamiProg_1_116,L020340?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020340?
	sjmp	L020341?
L020340?:
	sjmp	L020101?
L020341?:
L020100?:
;	EFM8_I2C_Nunchuck.c:731: konamiProg++;
	inc	_main_konamiProg_1_116
	clr	a
	cjne	a,_main_konamiProg_1_116,L020105?
	inc	(_main_konamiProg_1_116 + 1)
	sjmp	L020105?
L020101?:
;	EFM8_I2C_Nunchuck.c:733: konamiProg = 0;
	clr	a
	mov	_main_konamiProg_1_116,a
	mov	(_main_konamiProg_1_116 + 1),a
L020105?:
;	EFM8_I2C_Nunchuck.c:736: konamiReady = 0;
	clr	_main_konamiReady_1_116
;	EFM8_I2C_Nunchuck.c:738: if(koldReady){
	jnb	_main_koldReady_1_116,L020111?
;	EFM8_I2C_Nunchuck.c:739: if(koldProg == 0 || koldProg == 3){
	mov	a,_main_koldProg_1_116
	orl	a,(_main_koldProg_1_116 + 1)
	jz	L020106?
	mov	a,#0x03
	cjne	a,_main_koldProg_1_116,L020345?
	clr	a
	cjne	a,(_main_koldProg_1_116 + 1),L020345?
	sjmp	L020346?
L020345?:
	sjmp	L020107?
L020346?:
L020106?:
;	EFM8_I2C_Nunchuck.c:740: koldProg++;
	inc	_main_koldProg_1_116
	clr	a
	cjne	a,_main_koldProg_1_116,L020111?
	inc	(_main_koldProg_1_116 + 1)
	sjmp	L020111?
L020107?:
;	EFM8_I2C_Nunchuck.c:742: koldProg = 0;
	clr	a
	mov	_main_koldProg_1_116,a
	mov	(_main_koldProg_1_116 + 1),a
L020111?:
;	EFM8_I2C_Nunchuck.c:745: koldReady = 0;
	clr	_main_koldReady_1_116
	sjmp	L020128?
L020113?:
;	EFM8_I2C_Nunchuck.c:747: printf("*N/A* ");
	mov	a,#__str_6
	push	acc
	mov	a,#(__str_6 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
L020128?:
;	EFM8_I2C_Nunchuck.c:754: if(accelLoop > 0){
	clr	c
	clr	a
	subb	a,_main_accelLoop_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_accelLoop_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jnc	L020144?
;	EFM8_I2C_Nunchuck.c:755: signal_stream1 = 1;
	setb	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:756: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:757: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:758: signal_stream4 = 1;
	setb	_main_sloc3_1_0
	sjmp	L020145?
L020144?:
;	EFM8_I2C_Nunchuck.c:760: if(acc_z <= 150){
	clr	c
	mov	a,#0x96
	subb	a,_main_acc_z_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_acc_z_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jc	L020141?
;	EFM8_I2C_Nunchuck.c:761: accelLoop = -1;
	mov	_main_accelLoop_1_116,#0xFF
	mov	(_main_accelLoop_1_116 + 1),#0xFF
	sjmp	L020145?
L020141?:
;	EFM8_I2C_Nunchuck.c:762: }else if(acc_x >= 800){
	clr	c
	mov	a,_main_acc_x_1_116
	subb	a,#0x20
	mov	a,(_main_acc_x_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x83
	jc	L020138?
;	EFM8_I2C_Nunchuck.c:763: accelLoop = 4;
	mov	_main_accelLoop_1_116,#0x04
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
	sjmp	L020145?
L020138?:
;	EFM8_I2C_Nunchuck.c:764: }else if(acc_x <= 200){
	clr	c
	mov	a,#0xC8
	subb	a,_main_acc_x_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_acc_x_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jc	L020135?
;	EFM8_I2C_Nunchuck.c:765: accelLoop = 3;
	mov	_main_accelLoop_1_116,#0x03
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
	sjmp	L020145?
L020135?:
;	EFM8_I2C_Nunchuck.c:766: }else if(acc_y >= 800){
	clr	c
	mov	a,_main_acc_y_1_116
	subb	a,#0x20
	mov	a,(_main_acc_y_1_116 + 1)
	xrl	a,#0x80
	subb	a,#0x83
	jc	L020132?
;	EFM8_I2C_Nunchuck.c:767: accelLoop = 2;
	mov	_main_accelLoop_1_116,#0x02
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
	sjmp	L020145?
L020132?:
;	EFM8_I2C_Nunchuck.c:768: }else if(acc_y <= 200){
	clr	c
	mov	a,#0xC8
	subb	a,_main_acc_y_1_116
	clr	a
	xrl	a,#0x80
	mov	b,(_main_acc_y_1_116 + 1)
	xrl	b,#0x80
	subb	a,b
	jc	L020145?
;	EFM8_I2C_Nunchuck.c:769: accelLoop = 1;
	mov	_main_accelLoop_1_116,#0x01
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
L020145?:
;	EFM8_I2C_Nunchuck.c:773: if(accelLoop == 4 || c == 'P'){
	mov	a,#0x04
	cjne	a,_main_accelLoop_1_116,L020354?
	clr	a
	cjne	a,(_main_accelLoop_1_116 + 1),L020354?
	sjmp	L020165?
L020354?:
	mov	a,#0x50
	cjne	a,_c,L020166?
L020165?:
;	EFM8_I2C_Nunchuck.c:775: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:776: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:777: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:778: signal_stream8 = 0;
	clr	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:779: accelLoop = 4;
	mov	_main_accelLoop_1_116,#0x04
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:780: if(DEBUG) printf(" Shake left ");
	sjmp	L020170?
L020166?:
;	EFM8_I2C_Nunchuck.c:781: }else if(accelLoop == 3 || c == 'X'){			
	mov	a,#0x03
	cjne	a,_main_accelLoop_1_116,L020357?
	clr	a
	cjne	a,(_main_accelLoop_1_116 + 1),L020357?
	sjmp	L020161?
L020357?:
	mov	a,#0x58
	cjne	a,_c,L020162?
L020161?:
;	EFM8_I2C_Nunchuck.c:783: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:784: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:785: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:786: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:787: accelLoop = 3;
	mov	_main_accelLoop_1_116,#0x03
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:788: if(DEBUG) printf(" Shake right ");
	sjmp	L020170?
L020162?:
;	EFM8_I2C_Nunchuck.c:789: }else if(accelLoop == 2 || c == 'N'){
	mov	a,#0x02
	cjne	a,_main_accelLoop_1_116,L020360?
	clr	a
	cjne	a,(_main_accelLoop_1_116 + 1),L020360?
	sjmp	L020157?
L020360?:
	mov	a,#0x4E
	cjne	a,_c,L020158?
L020157?:
;	EFM8_I2C_Nunchuck.c:791: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:792: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:793: signal_stream7 = 0;
	clr	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:794: signal_stream8 = 0;
	clr	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:795: accelLoop = 2;
	mov	_main_accelLoop_1_116,#0x02
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:796: if(DEBUG) printf(" Shake back ");
	sjmp	L020170?
L020158?:
;	EFM8_I2C_Nunchuck.c:797: }else if(accelLoop == 1 || c == 'O'){
	mov	a,#0x01
	cjne	a,_main_accelLoop_1_116,L020363?
	clr	a
	cjne	a,(_main_accelLoop_1_116 + 1),L020363?
	sjmp	L020154?
L020363?:
	mov	a,#0x4F
	cjne	a,_c,L020170?
L020154?:
;	EFM8_I2C_Nunchuck.c:799: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:800: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:801: signal_stream7 = 0;			
	clr	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:802: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:803: accelLoop = 1;
	mov	_main_accelLoop_1_116,#0x01
	clr	a
	mov	(_main_accelLoop_1_116 + 1),a
;	EFM8_I2C_Nunchuck.c:811: printf("%d%d%d%d%d | ",signal_stream4,signal_stream5,signal_stream6,signal_stream7,signal_stream8);
L020170?:
;	EFM8_I2C_Nunchuck.c:820: if(koldProg == 5){
	mov	a,#0x05
	cjne	a,_main_koldProg_1_116,L020366?
	clr	a
	cjne	a,(_main_koldProg_1_116 + 1),L020366?
	sjmp	L020367?
L020366?:
	sjmp	L020178?
L020367?:
;	EFM8_I2C_Nunchuck.c:821: signal_stream1 = 1;
	setb	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:822: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:823: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:824: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:825: printf("[FATALITY]\n10\n");
	mov	a,#__str_18
	push	acc
	mov	a,#(__str_18 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
;	EFM8_I2C_Nunchuck.c:828: if(shakeDir){
	jnb	_main_shakeDir_1_116,L020172?
;	EFM8_I2C_Nunchuck.c:830: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:831: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:832: signal_stream7 = 0;
	clr	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:833: signal_stream8 = 1;
	setb	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:834: Timer4ms(SIGNALDELAY/2);
	mov	dpl,#0x05
	lcall	_Timer4ms
	sjmp	L020173?
L020172?:
;	EFM8_I2C_Nunchuck.c:837: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:838: signal_stream6 = 1;
	setb	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:839: signal_stream7 = 0;
	clr	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:840: signal_stream8 = 0;
	clr	_main_signal_stream8_1_116
;	EFM8_I2C_Nunchuck.c:841: Timer4ms(SIGNALDELAY/2);
	mov	dpl,#0x05
	lcall	_Timer4ms
L020173?:
;	EFM8_I2C_Nunchuck.c:843: shakeDir = !shakeDir;
	cpl	_main_shakeDir_1_116
	sjmp	L020179?
L020178?:
;	EFM8_I2C_Nunchuck.c:844: }else if(konamiProg == 10){
	mov	a,#0x0A
	cjne	a,_main_konamiProg_1_116,L020369?
	clr	a
	cjne	a,(_main_konamiProg_1_116 + 1),L020369?
	sjmp	L020370?
L020369?:
	sjmp	L020175?
L020370?:
;	EFM8_I2C_Nunchuck.c:845: signal_stream1 = 1;
	setb	_main_sloc0_1_0
;	EFM8_I2C_Nunchuck.c:846: signal_stream2 = 1;
	setb	_main_sloc1_1_0
;	EFM8_I2C_Nunchuck.c:847: signal_stream3 = 1;
	setb	_main_sloc2_1_0
;	EFM8_I2C_Nunchuck.c:848: signal_stream4 = 1;
	setb	_main_sloc3_1_0
;	EFM8_I2C_Nunchuck.c:851: signal_stream5 = 0;
	clr	_main_signal_stream5_1_116
;	EFM8_I2C_Nunchuck.c:852: signal_stream6 = 0;
	clr	_main_signal_stream6_1_116
;	EFM8_I2C_Nunchuck.c:853: signal_stream7 = 1;
	setb	_main_signal_stream7_1_116
;	EFM8_I2C_Nunchuck.c:854: signal_stream8 = 0;
	clr	_main_signal_stream8_1_116
	sjmp	L020179?
L020175?:
;	EFM8_I2C_Nunchuck.c:856: printf("\n1\n");
	mov	a,#__str_19
	push	acc
	mov	a,#(__str_19 >> 8)
	push	acc
	mov	a,#0x80
	push	acc
	lcall	_printf
	dec	sp
	dec	sp
	dec	sp
L020179?:
;	EFM8_I2C_Nunchuck.c:877: ET2=1;
	setb	_ET2
;	EFM8_I2C_Nunchuck.c:878: send:		
L020180?:
;	EFM8_I2C_Nunchuck.c:880: ES0 = 0;
	clr	_ES0
;	EFM8_I2C_Nunchuck.c:881: ET2 = signal_stream0;
	mov	c,_main_signal_stream0_1_116
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:882: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:884: ET2 = signal_stream1;
	mov	c,_main_sloc0_1_0
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:885: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:886: ET2 = signal_stream2;
	mov	c,_main_sloc1_1_0
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:887: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:888: ET2 = signal_stream3;
	mov	c,_main_sloc2_1_0
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:889: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:890: ET2 = signal_stream4;
	mov	c,_main_sloc3_1_0
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:891: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:893: ET2 = signal_stream5;
	mov	c,_main_signal_stream5_1_116
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:894: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:895: ET2 = signal_stream6;
	mov	c,_main_signal_stream6_1_116
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:896: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:897: ET2 = signal_stream7;
	mov	c,_main_signal_stream7_1_116
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:898: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:899: ET2 = signal_stream8;
	mov	c,_main_signal_stream8_1_116
	mov	_ET2,c
;	EFM8_I2C_Nunchuck.c:900: Timer4ms(SIGNALDELAY);
	mov	dpl,#0x0A
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:902: ET2=0;
	clr	_ET2
;	EFM8_I2C_Nunchuck.c:903: Timer4ms(8);
	mov	dpl,#0x08
	lcall	_Timer4ms
;	EFM8_I2C_Nunchuck.c:905: ES0 = 1;
	setb	_ES0
;	EFM8_I2C_Nunchuck.c:907: if(BUTT3)
	jnb	_P2_5,L020371?
	ljmp	L020182?
L020371?:
;	EFM8_I2C_Nunchuck.c:909: f+= 50;
	mov	a,#0x32
	add	a,_main_f_1_116
	mov	_main_f_1_116,a
	clr	a
	addc	a,(_main_f_1_116 + 1)
	mov	(_main_f_1_116 + 1),a
	clr	a
	addc	a,(_main_f_1_116 + 2)
	mov	(_main_f_1_116 + 2),a
	clr	a
	addc	a,(_main_f_1_116 + 3)
	mov	(_main_f_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:910: x=(SYSCLK/(2L*f));
	mov	a,_main_f_1_116
	add	a,_main_f_1_116
	mov	__divulong_PARM_2,a
	mov	a,(_main_f_1_116 + 1)
	rlc	a
	mov	(__divulong_PARM_2 + 1),a
	mov	a,(_main_f_1_116 + 2)
	rlc	a
	mov	(__divulong_PARM_2 + 2),a
	mov	a,(_main_f_1_116 + 3)
	rlc	a
	mov	(__divulong_PARM_2 + 3),a
	mov	dptr,#0x6C00
	mov	b,#0xDC
	mov	a,#0x02
	lcall	__divulong
	mov	_main_x_1_116,dpl
	mov	(_main_x_1_116 + 1),dph
	mov	(_main_x_1_116 + 2),b
	mov	(_main_x_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:911: TR2=0; 				// Stop timer 2
	clr	_TR2
;	EFM8_I2C_Nunchuck.c:912: TMR2RL=0x10000L-x; 	// Change reload value for new frequency
	clr	a
	clr	c
	subb	a,_main_x_1_116
	mov	r6,a
	clr	a
	subb	a,(_main_x_1_116 + 1)
	mov	r7,a
	mov	a,#0x01
	subb	a,(_main_x_1_116 + 2)
	clr	a
	subb	a,(_main_x_1_116 + 3)
	mov	_TMR2RL,r6
	mov	(_TMR2RL >> 8),r7
;	EFM8_I2C_Nunchuck.c:913: TR2=1; 				// Start timer 2
	setb	_TR2
;	EFM8_I2C_Nunchuck.c:914: f=SYSCLK/(2L*(0x10000L-TMR2RL));		
	mov	r2,_TMR2RL
	mov	r3,(_TMR2RL >> 8)
	clr	a
	mov	r4,a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r5
	mov	r5,a
	mov	a,r2
	add	a,r2
	mov	__divslong_PARM_2,a
	mov	a,r3
	rlc	a
	mov	(__divslong_PARM_2 + 1),a
	mov	a,r4
	rlc	a
	mov	(__divslong_PARM_2 + 2),a
	mov	a,r5
	rlc	a
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0x6C00
	mov	b,#0xDC
	mov	a,#0x02
	lcall	__divslong
	mov	_main_f_1_116,dpl
	mov	(_main_f_1_116 + 1),dph
	mov	(_main_f_1_116 + 2),b
	mov	(_main_f_1_116 + 3),a
L020182?:
;	EFM8_I2C_Nunchuck.c:916: if(BUTT2)
	jnb	_P3_0,L020372?
	ljmp	L020188?
L020372?:
;	EFM8_I2C_Nunchuck.c:918: f-=50;
	mov	a,_main_f_1_116
	add	a,#0xce
	mov	_main_f_1_116,a
	mov	a,(_main_f_1_116 + 1)
	addc	a,#0xff
	mov	(_main_f_1_116 + 1),a
	mov	a,(_main_f_1_116 + 2)
	addc	a,#0xff
	mov	(_main_f_1_116 + 2),a
	mov	a,(_main_f_1_116 + 3)
	addc	a,#0xff
	mov	(_main_f_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:919: x=(SYSCLK/(2L*f));
	mov	a,_main_f_1_116
	add	a,_main_f_1_116
	mov	__divulong_PARM_2,a
	mov	a,(_main_f_1_116 + 1)
	rlc	a
	mov	(__divulong_PARM_2 + 1),a
	mov	a,(_main_f_1_116 + 2)
	rlc	a
	mov	(__divulong_PARM_2 + 2),a
	mov	a,(_main_f_1_116 + 3)
	rlc	a
	mov	(__divulong_PARM_2 + 3),a
	mov	dptr,#0x6C00
	mov	b,#0xDC
	mov	a,#0x02
	lcall	__divulong
	mov	_main_x_1_116,dpl
	mov	(_main_x_1_116 + 1),dph
	mov	(_main_x_1_116 + 2),b
	mov	(_main_x_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:920: TR2=0; 				// Stop timer 2
	clr	_TR2
;	EFM8_I2C_Nunchuck.c:921: TMR2RL=0x10000L-x; 	// Change reload value for new frequency
	clr	a
	clr	c
	subb	a,_main_x_1_116
	mov	r2,a
	clr	a
	subb	a,(_main_x_1_116 + 1)
	mov	r3,a
	mov	a,#0x01
	subb	a,(_main_x_1_116 + 2)
	clr	a
	subb	a,(_main_x_1_116 + 3)
	mov	_TMR2RL,r2
	mov	(_TMR2RL >> 8),r3
;	EFM8_I2C_Nunchuck.c:922: TR2=1; 				// Start timer 2
	setb	_TR2
;	EFM8_I2C_Nunchuck.c:923: f=SYSCLK/(2L*(0x10000L-TMR2RL));
	mov	r2,_TMR2RL
	mov	r3,(_TMR2RL >> 8)
	clr	a
	mov	r4,a
	mov	r5,a
	clr	c
	subb	a,r2
	mov	r2,a
	clr	a
	subb	a,r3
	mov	r3,a
	mov	a,#0x01
	subb	a,r4
	mov	r4,a
	clr	a
	subb	a,r5
	mov	r5,a
	mov	a,r2
	add	a,r2
	mov	__divslong_PARM_2,a
	mov	a,r3
	rlc	a
	mov	(__divslong_PARM_2 + 1),a
	mov	a,r4
	rlc	a
	mov	(__divslong_PARM_2 + 2),a
	mov	a,r5
	rlc	a
	mov	(__divslong_PARM_2 + 3),a
	mov	dptr,#0x6C00
	mov	b,#0xDC
	mov	a,#0x02
	lcall	__divslong
	mov	_main_f_1_116,dpl
	mov	(_main_f_1_116 + 1),dph
	mov	(_main_f_1_116 + 2),b
	mov	(_main_f_1_116 + 3),a
;	EFM8_I2C_Nunchuck.c:925: if(DEBUG) printf("    freq now: %lu",f);
	ljmp	L020188?
	rseg R_CSEG

	rseg R_XINIT

	rseg R_CONST
__str_0:
	db 'ACCEL '
	db 0x00
__str_1:
	db 'STOP '
	db 0x00
__str_2:
	db 'IDLE '
	db 0x00
__str_3:
	db 'LTURN '
	db 0x00
__str_4:
	db 'RTURN '
	db 0x00
__str_5:
	db 'GO '
	db 0x00
__str_6:
	db '*N/A* '
	db 0x00
__str_7:
	db 'BLTURN '
	db 0x00
__str_8:
	db 'BRTURN '
	db 0x00
__str_9:
	db 'BACK '
	db 0x00
__str_10:
	db 'RIGHT '
	db 0x00
__str_11:
	db 'LEFT '
	db 0x00
__str_12:
	db ' Shake left '
	db 0x00
__str_13:
	db ' Shake right '
	db 0x00
__str_14:
	db ' Shake back '
	db 0x00
__str_15:
	db ' Shake GO '
	db 0x00
__str_16:
	db 'Bitstream: %d%d%d%d'
	db 0x00
__str_17:
	db '%d%d%d%d%d | '
	db 0x00
__str_18:
	db '[FATALITY]'
	db 0x0A
	db '10'
	db 0x0A
	db 0x00
__str_19:
	db 0x0A
	db '1'
	db 0x0A
	db 0x00
__str_20:
	db '    freq now: %lu'
	db 0x00

	CSEG

end
