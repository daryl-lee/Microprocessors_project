#include <xc.inc>
	
global	buzzer_setup, pulse
psect	udata_acs
cycles:		ds      1
cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:	ds 1
    
psect	buzzer_code, class=CODE

buzzer_setup: 
    movlw	0x20
    movwf	cycles, A
    return
  
pulse:  
    ;call	period
    bsf		LATB, 6, A
    call	delay_sub2
    bcf		LATB, 6, A
    call	delay_sub2
    decf	cycles
    movlw	0x00   
    cpfseq	cycles	;skip if = 0
    bra		pulse
    bra		buzzer_setup

	
period:
    bsf	LATB, 6, A
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop		    ; Take enable high
    nop
    nop
    nop
    nop
    nop
    nop
    bcf	LATB, 6, A
    bcf	LATB, 6, A	    ; Writes data to LCD
    return


delay_sub2:	
	movlw	0x2a	    ; 0.16ms delay
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