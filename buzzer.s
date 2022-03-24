#include <xc.inc>
	
global	buzzer_setup, pulse_jump, pulse_death, death_setup
psect	udata_acs
cycles:		ds      1
cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:	ds 1
    
psect	buzzer_code, class=CODE


buzzer_setup: 
    movlw	0x10		    ;length of jump sound
    movwf	cycles, A
    return
    
death_setup: 
    movlw	0x20		    ;length of death sound
    movwf	cycles, A
    return
  
  
pulse_jump:  
    bsf		PORTB, 6, A
    movlw	0x01		    ; 4 us delay
    call	delay_sub2
    bcf		PORTB, 6, A
    movlw	0x01		    ; 4 us delay
    call	delay_sub2
    decf	cycles
    movlw	0x00   
    cpfseq	cycles	;skip if = 0
    bra		pulse_jump
    bra		buzzer_setup
    
pulse_death:  
    bsf		PORTB, 6, A	; 3.06 ms delay
    movlw	0xff
    call	delay_sub2
    movlw	0xff
    call	delay_sub2
    movlw	0xff
    call	delay_sub2
    bcf		PORTB, 6, A
    movlw	0xff
    call	delay_sub2
    movlw	0xff
    call	delay_sub2
    movlw	0xff
    call	delay_sub2
    decf	cycles
    movlw	0x00   
    cpfseq	cycles	;skip if = 0
    bra		pulse_death
    bra		death_setup

	

delay_sub2:	
		    ; 4 microsecond delay
	call	delay_x4us	
	decfsz	cnt_ms, A
	bra	delay_sub2
	return

delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	cnt_l, A	; now need to multiply by 16
	swapf   cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	cnt_l, W, A ; move low nibble to W
	movwf	cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	delay
	return

delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
delay_sub1:	
	decf 	cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	delay_sub1		; carry, then loop again
	return	
	
end