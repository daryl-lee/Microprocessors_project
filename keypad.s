#include <xc.inc>

global	    key_setup, key_setup_column, key_delay_ms, key_setup_row, decode, key_press

psect	udata_acs   ; named variables in access ram
key_cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
key_cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
key_cnt_ms:	ds 1   ; reserve 1 byte for ms counter
digit0:		ds 1
digit1:		ds 1
digit2:		ds 1
digit3:		ds 1
digitB:		ds 1
keys1:	ds  1
keys2:	ds  1


    
psect	key_code,class=CODE
    
key_setup:
    BANKSEL PADCFG1
    bsf	    REPU
    BANKSEL 0
    clrf    LATE, A
    movlw   0b10111110
    movwf   digit0, A
    movlw   0b11011110
    movwf   digitB, A
    movlw   0b01110111
    movwf   digit1, A
    movlw   0b10110111
    movwf   digit2, A
    movlw   0b11010111
    movwf   digit3, A
    
   
key_setup_row:
    movlw   0x0f
    movwf   TRISE, A
    movlw   0x00
    movwf   PORTE, A
    return
 
key_setup_column:
    movlw   0xf0
    movwf   TRISE, A
    movlw   0x00
    movwf   PORTE, A
    return
    
key_press:	
	call	key_setup_row
	movlw	0x01
	call	key_delay_ms
	movff	PORTE, keys1	
	call	key_setup_column
	movlw	0x01
	call	key_delay_ms
	movff	PORTE, keys2
	movf	keys2, W, A
	addwf	keys1, F, A
	movf	keys1, W, A
	call	decode	
	return
    
decode:
    cpfseq  digit0, A
    goto    decode1	    
    movlw   0x01
    return
    
decode1:
    cpfseq  digit1, A
    goto    decode2	    
    movlw   0x03
    return
    
decode2:
    cpfseq  digit2, A
    goto    decode3	    
    movlw   0x04
    return
    
decode3:
    cpfseq  digit3, A
    goto    decodeB	    
    movlw   0x05
    return
    

decodeB:
    cpfseq  digitB, A
    goto    decodenull	    
    movlw   0x02
    return
    
decodenull:	    
    movlw   0x00
    return
    

    
key_delay_ms:		    ; delay given in ms in W
	movwf	key_cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	key_delay_x4us	
	decfsz	key_cnt_ms, A
	bra	lcdlp2
	return
    
key_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	key_cnt_l, A	; now need to multiply by 16
	swapf   key_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	key_cnt_l, W, A ; move low nibble to W
	movwf	key_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	key_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	key_delay
	return

key_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	key_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	key_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


end