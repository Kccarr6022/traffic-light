#define __SFR_OFFSET 0
#include <avr/io.h>


; vector table for interrupts
;----------------------------------------------------
BEGIN_VECTORS:			; Reset
	jmp	setup
INT0addr:		; External Interrupt Request 0
	call	CYCLE_CHANGE
	reti
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
OC2Aaddr:			; Timer/Counter2 Compare Match A
	nop
	nop
OC2Baddr:				; Timer/Counter2 Compare Match A
	nop
	nop
OVF2addr:				; Timer/Counter2 Overflow
	nop
	nop
ICP1addr:				; Timer/Counter1 Capture Event
	nop
	nop
OC1Aaddr:				; Timer/Counter1 Compare Match A
	nop
	nop
OC1Baddr:				; Timer/Counter1 Compare Match B
	nop
	nop
OVF1addr:				; Timer/Counter1 Overflow
	nop
	nop
OC0Aaddr:				; TimerCounter0 Compare Match A
	nop
	nop
OC0Baddr:				; TimerCounter0 Compare Match B
	nop
	nop
OVF0addr:				; Timer/Counter0 Overflow
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
ADC0addr:				; ADC Conversion Complete
	nop;jmp	NIGHT_CYCLE
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
	
	.set	NORTH_SOUTH_DIR, DDRD
	.set	NORTH_SOUTH_OUT, PORTD
	.set	NORTH_SOUTH_IN, PIND
	.set	GREEN_LIGHT_PIN, 4
	.set	YELLOW_LIGHT_PIN, 5
	.set	RED_LIGHT_PIN, 6
	.set	EAST_WEST_DIR, DDRB
	.set	EAST_WEST_OUT, PORTB
	.set	EAST_WEST_IN, PINB
	.set	EGREEN_LIGHT_PIN, 1
	.set	EYELLOW_LIGHT_PIN, 2
	.set	ERED_LIGHT_PIN, 3
	.set	IS_NIGHT_CYCLE, R16
	.set	CHECK_CYCLE, 1
setup:				; Set PB2 as OUTPUT
	
	ldi	R16, 0 ; Defaults to day cycle
	
	; Configure Timer1
	clr	r20
	sts	TCNT1H, r20
	sts	TCNT1L, r20
	
	ldi	r20, 0b00000010
	sts	TIMSK1, r20
	
	
	;PULL up IN
	cbi	DDRD, 2
	sbi	PORTD, 2
	
	; configure button interrupt
	sbi	EIMSK, INT0	; enable INT0 on D2 for button
	ldi	r20, 0b00000010	;
	sts	EICRA, r20	; set falling edge
	
	sei
	
	;Green light
	sbi	NORTH_SOUTH_DIR, GREEN_LIGHT_PIN
	cbi	NORTH_SOUTH_OUT, GREEN_LIGHT_PIN
	
	;Yellow light
	sbi	NORTH_SOUTH_DIR, YELLOW_LIGHT_PIN
	cbi	NORTH_SOUTH_OUT, YELLOW_LIGHT_PIN
	
	;Red light
	sbi	NORTH_SOUTH_DIR, RED_LIGHT_PIN
	cbi	NORTH_SOUTH_OUT, RED_LIGHT_PIN
	sbi       NORTH_SOUTH_OUT,RED_LIGHT_PIN        ; turn RED N/S on
	
	;Green light
	sbi	EAST_WEST_DIR, EGREEN_LIGHT_PIN
	sbi       EAST_WEST_OUT, EGREEN_LIGHT_PIN       ; turn RED N/S on
	
	;Yellow light
          sbi       EAST_WEST_DIR, EYELLOW_LIGHT_PIN          ; Command: (sbi = Set bit in I/O register) Destination: (DDRB = A I/O register) Source: (bit_num = a number to make DDRB an output pin)
          cbi       EAST_WEST_OUT, EYELLOW_LIGHT_PIN        ; turns LED off (cbi = clear bit in I/O register)
          
	;Red light
	sbi	EAST_WEST_DIR, ERED_LIGHT_PIN
	cbi	EAST_WEST_OUT, ERED_LIGHT_PIN


MAIN:
	rjmp	DAY_CYCLE

;	Changes to night_cycle if in day_cycle or day_cycle if in night_cycle
CHECK_CYCLE:
	cpi	r16, 0
	breq	CYCLE_CHANGE
	ldi	r16, 0
	ret
	
CYCLE_CHANGE:
	ldi	r16, 1
	ret

DAY_CYCLE:
	call      wait_2500
	cbi       EAST_WEST_OUT,EGREEN_LIGHT_PIN        ; turn GREEN E/W on
	sbi       EAST_WEST_OUT,EYELLOW_LIGHT_PIN        ; turn YELLOW E/W on
	call	wait_1500
	cbi       EAST_WEST_OUT,EYELLOW_LIGHT_PIN        ; turn GREEN E/W off
	cbi       NORTH_SOUTH_OUT,RED_LIGHT_PIN        ; turn RED N/S off
	sbi       EAST_WEST_OUT,ERED_LIGHT_PIN        ; turn RED E/W on
	sbi       NORTH_SOUTH_OUT,GREEN_LIGHT_PIN        ; turn GREEN N/S on
	call      wait_2500
	sbi	NORTH_SOUTH_OUT,YELLOW_LIGHT_PIN
	cbi       NORTH_SOUTH_OUT,GREEN_LIGHT_PIN        ; turn GREEN N/S off	
	call	wait_1500
	cbi	NORTH_SOUTH_OUT,YELLOW_LIGHT_PIN
	cbi	EAST_WEST_OUT,ERED_LIGHT_PIN
	sbi       EAST_WEST_OUT,EGREEN_LIGHT_PIN        ; turn GREEN E/W on
	sbi       NORTH_SOUTH_OUT,RED_LIGHT_PIN        ; turn RED N/S on
	cpi	r16, 0
	breq	DAY_CYCLE
	rjmp	NIGHT_CYCLE

NIGHT_CYCLE:
	call      wait_250
	cbi       EAST_WEST_OUT,EGREEN_LIGHT_PIN        ; turn GREEN E/W on
	sbi       EAST_WEST_OUT,EYELLOW_LIGHT_PIN        ; turn YELLOW E/W on
	call	wait_250
	cbi       EAST_WEST_OUT,EYELLOW_LIGHT_PIN        ; turn GREEN E/W off
	cbi       NORTH_SOUTH_OUT,RED_LIGHT_PIN        ; turn RED N/S off
	sbi       EAST_WEST_OUT,ERED_LIGHT_PIN        ; turn RED E/W on
	sbi       NORTH_SOUTH_OUT,GREEN_LIGHT_PIN        ; turn GREEN N/S on
	call      wait_250
	sbi	NORTH_SOUTH_OUT,YELLOW_LIGHT_PIN
	cbi       NORTH_SOUTH_OUT,GREEN_LIGHT_PIN        ; turn GREEN N/S off	
	call	wait_250
	cbi	NORTH_SOUTH_OUT,YELLOW_LIGHT_PIN
	cbi	EAST_WEST_OUT,ERED_LIGHT_PIN
	sbi       EAST_WEST_OUT,EGREEN_LIGHT_PIN        ; turn GREEN E/W on
	sbi       NORTH_SOUTH_OUT,RED_LIGHT_PIN        ; turn RED N/S on
	
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