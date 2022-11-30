#define __SFR_OFFSET 0
#include <avr/io.h>
	
; vector table for interrupts
;----------------------------------------------------
BEGIN_VECTORS:			; Reset
	jmp	END_VECTORS
INT0addr:				; External Interrupt Request 0
	RJMP	NIGHT_CYCLE
	nop
INT1addr:				; External Interrupt Request 1
	nop
	nop
PCI0addr:				; Pin Change Interrupt Request 0
	nop
	nop
PCI1addr:				; Pin Change Interrupt Request 0
	nop
	nop
PCI2addr:				; Pin Change Interrupt Request 1
	nop
	nop
WDTaddr:				; Watchdog Time-out Interrupt
	nop
	nop
0C2Aaddr:				; Timer/Counter2 Compare Match A
	nop
	nop
0C2Baddr:				; Timer/Counter2 Compare Match A
	nop
	nop
0VF2addr:				; Timer/Counter2 Overflow
	nop
	nop
ICP1addr:				; Timer/Counter1 Capture Event
	nop
	nop
0C1Aaddr:				; Timer/Counter1 Compare Match A
	nop
	nop
0C1Baddr:				; Timer/Counter1 Compare Match B
	nop
	nop
0VF1addr:				; Timer/Counter1 Overflow
	nop
	nop
0C0Aaddr:				; TimerCounter0 Compare Match A
	nop
	nop
0C0Baddr:				; TimerCounter0 Compare Match B
	nop
	nop
0VF0addr:				; Timer/Counter0 Overflow
	nop
	nop
SPIaddr:				; SPI Serial Transfer Complete
	nop
	nop
URXCaddr:				; USART Rx Complete
	nop
	nop
UDREaddr:				; USART Data Register Empty
	nop
	nop
UTXCaddr:				; USART Tx Complete
	nop
	nop
ADCCaddr:				; ADC Conversion Complete
	nop
	nop
ERDYaddr:				; EEPROM Ready
	nop
	nop
ACIaddr:				; Analog Comparator
	nop
	nop
TWIaddr:				; Two-wire Serial Interface
	nop
	nop
SPMRaddr:				; Store Program Memory Read
	nop
	nop
END_VECTORS:
	
setup:				; Set PB2 as OUTPUT
	
	;NORTH/SOUTH
	
	; Data Direction Register After
	; PD0	PD1	PD2	PD3	PD4	PD5	PD6	PD7
	;x	x	x	x	x	x	x	x
	
	;Green light
	sbi	DDRD, PORTD4
	cbi	PORTD, PORTD4
	
	;Yellow light
	sbi	DDRD, PORTD5
	cbi	PORTD, PORTD5
	
	;Red light
	sbi	DDRD, PORTD6
	cbi	PORTD, PORTD6
	sbi       PORTD,PORTD6        ; turn RED N/S on
	
	; Data Direction Register After
	; PD0	PD1	PD2	PD3	PD4	PD5	PD6	PD7
	;x	x	x	x	x	x	x	x
	
	
	;EAST/WEST
	
	; Data Direction Register Before
	; PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
	;x	x	x	x	x	x	x	x
	
	;Green light
	sbi	DDRB, PORTB1
	cbi	PORTB, PORTB1
	sbi       PORTB, PORTB1       ; turn RED N/S on
	
	;Yellow light
          sbi       DDRB, PORTB2          ; Command: (sbi = Set bit in I/O register) Destination: (DDRB = A I/O register) Source: (bit_num = a number to make DDRB an output pin)
          cbi       PORTB, PORTB2        ; turns LED off (cbi = clear bit in I/O register)
          
	;Red light
	sbi	DDRB, PORTB3
	cbi	PORTB, PORTB3
	
	; Data Direction Register Before
	; PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
	;x	x	x	x	1	1	1	x
	

loop:
	rjmp	DAY_CYCLE

DAY_CYCLE:
	call      wait_10000
	cbi       PORTB,PORTB1        ; turn GREEN E/W on
	sbi       PORTB,PORTB2        ; turn YELLOW E/W on
	call	wait_5000
	cbi       PORTB,PORTB2        ; turn GREEN E/W off
	cbi       PORTD,PORTD6        ; turn RED N/S off
	sbi       PORTB,PORTB3        ; turn RED E/W on
	sbi       PORTD,PORTD4        ; turn GREEN N/S on
	call      wait_10000
	sbi	PORTD,PORTD5
	cbi       PORTD,PORTD4        ; turn GREEN N/S off	
	call	wait_5000
	cbi	PORTD,PORTD5
	cbi	PORTB,PORTB3
	sbi       PORTB,PORTB1        ; turn GREEN E/W on
	sbi       PORTD,PORTD6        ; turn RED N/S on
	
	rjmp	DAY_CYCLE

NIGHT_CYCLE:
	call      wait_5000
	cbi       PORTB,PORTB1        ; turn GREEN E/W on
	sbi       PORTB,PORTB2        ; turn YELLOW E/W on
	call	wait_2500
	cbi       PORTB,PORTB2        ; turn GREEN E/W off
	cbi       PORTD,PORTD6        ; turn RED N/S off
	sbi       PORTB,PORTB3        ; turn RED E/W on
	sbi       PORTD,PORTD4        ; turn GREEN N/S on
	call      wait_5000
	sbi	PORTD,PORTD5
	cbi       PORTD,PORTD4        ; turn GREEN N/S off	
	call	wait_2500
	cbi	PORTD,PORTD5
	cbi	PORTB,PORTB3
	sbi       PORTB,PORTB1        ; turn GREEN E/W on
	sbi       PORTD,PORTD6        ; turn RED N/S on
          
          rjmp	NIGHT_CYCLE

wait_10000:
	call	wait_5000
	call	wait_5000
	ret
		

wait_5000:
	call	wait_2500
	call	wait_2500
	ret

wait_2500:
	call	wait_1500
	call	wait_500
	call	wait_500
	ret

; Add wait_1500_ms
wait_1500:
	call	wait_500
	call	wait_500
	call	wait_500
	ret
	
; Add wait_500_ms
wait_500:
	call	wait_250
	call      wait_250
	ret
	
	
; wait 250 ms code
wait_250:
          ldi       r18,16
wait_250_1:
          ldi       r17,200
wait_250_2:
          ldi       r16,250
wait_250_3:
          nop
          nop
          dec       r16
          brne      wait_250_3
          dec       r17
          brne      wait_250_2
          dec       r18
          brne      wait_250_1
          ret                           ; end