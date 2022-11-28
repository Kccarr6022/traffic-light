#define __SFR_OFFSET 0
#include <avr/io.h>
	

setup:				; Set PB2 as OUTPUT
	
	
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
          
	; Red light
	sbi	DDRB, 3
	cbi	PORTB, 3
	
	
	
	; Data Direction Register After
	; PB7	PB6	PB5	PB4	PB3	PB2	PB1	PB0
	;x	x	x	x	1	1	1	x
	
	;NORTH/SOUTH
	





loop:
turn_led_on:
          sbi       PORTB,2        ; turn led on
          call      wait_25             
          
turn_led_off:
          cbi       PORTB,2        ; turn led off
          call      wait_25
          
          rjmp loop

	
	
	
	

	
	
	
	
	
	
	
wait_25:
          ldi       r18,16
wait_25_1:
          ldi       r17,200
wait_25_2:
          ldi       r16,250
wait_25_3:
          nop
          nop
          dec       r16
          brne      wait_25_3
          dec       r17
          brne      wait_25_2
          dec       r18
          brne      wait_25_1
          ret                           ; end
