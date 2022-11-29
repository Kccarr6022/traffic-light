#define __SFR_OFFSET 0
#include <avr/io.h>
	

setup:				; Set PB2 as OUTPUT
	
	;NORTH/SOUTH
	
	; Data Direction Register After
	; PD0	PD1	PD2	PD3	PD4	PD5	PD6	PD7
	;x	x	x	x	x	x	x	x
	
	;Green light
	sbi	DDRD, 4
	cbi	PORTD, 4
	
	;Yellow light
	sbi	DDRD, 5
	cbi	PORTD, 5
	
	;Red light
	sbi	DDRD, 6
	cbi	PORTD, 6
	
	; Data Direction Register After
	; PD0	PD1	PD2	PD3	PD4	PD5	PD6	PD7
	;x	x	x	x	x	x	x	x
	
	
	;EAST/WEST
	
	; Data Direction Register Before
	; PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
	;x	x	x	x	x	x	x	x
	
	;Green light
	sbi	DDRB, 1
	cbi	PORTB, 1
	
	;Yellow light
          sbi       DDRB, 2          ; Command: (sbi = Set bit in I/O register) Destination: (DDRB = A I/O register) Source: (bit_num = a number to make DDRB an output pin)
          cbi       PORTB,2        ; turns LED off (cbi = clear bit in I/O register)
          
	;Red light
	sbi	DDRB, 3
	cbi	PORTB, 3
	
	; Data Direction Register Before
	; PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
	;x	x	x	x	1	1	1	x
	

loop:
	
change_lanes:		; Change color for previous lane to green

DAY_CYCLE:
	sbi       PORTD,6        ; turn RED N/S on
	sbi       PORTB,1        ; turn GREEN E/W on
	call      wait_1500
	cbi       PORTB,1        ; turn GREEN E/W on
	sbi       PORTB,2        ; turn YELLOW E/W on
	call	wait_500
	cbi       PORTB,2        ; turn GREEN E/W off
	cbi       PORTD,6        ; turn RED N/S off
	sbi       PORTB,3        ; turn RED E/W on
	sbi       PORTD,4        ; turn GREEN N/S on
	call      wait_1500
	sbi	PORTD,5
	cbi       PORTD,4        ; turn GREEN N/S off	
	call	wait_500
	cbi	PORTD,5
	cbi	PORTB,3
	
;          
;turn_led_off:
;          cbi       PORTD,6        ; turn led off
;	cbi       PORTB,1       ; turn led off
;	cbi       PORTB,2       ; turn led off
;	cbi       PORTB,3        ; turn RED N/S on
;	cbi       PORTD,4        ; turn GREEN E/W on
;	call      wait_1500
          
          rjmp loop

	

; Add wait_500_ms
wait_500:
	call	wait_250
	call      wait_250
	ret
	

; Add wait_1500_ms
wait_1500:
	call	wait_500
	call	wait_500
	call	wait_500
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