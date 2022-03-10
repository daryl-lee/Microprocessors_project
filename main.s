#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, make_sprite_x, set_y
extrn	set_x, make_sprite_y, LcdSetStart, key_setup, key_setup_column, key_delay_ms, key_setup_row, decode


psect	udata_acs   ; named variables in access ram
cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:	ds 1   ; reserve 1 byte for ms counter
start_x: ds 1
start_y: ds 1
keys1:	ds  1
keys2:	ds  1
key_bool: ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data


    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	
	call	LcdOpen	; setup glcd
	call	key_setup
	
	goto	start
	
	; ******* Main programme ****************************************
start: 	call	LcdOpen
	call	LcdDisplayOn
	bra	reset1

	
	goto $
	
	
reset1:	
	call    LcdClear
	movlw	0x7f
	movwf	start_x, A
	movlw	0x08
	movwf	start_y, A
	
loop:	
    
	call    LcdSelectLeft
	movlw	0x06
	call	set_y
	movf	start_x, W, A
	call    make_sprite_x
	movlw	0x2a
	call	set_x
	movf	start_y, W, A
	call	make_sprite_y
	movlw	0x05
	call	set_y
	movf	start_x, W, A
	call    make_sprite_x
	movlw   0x70
	call	delay_ms
	call    LcdClear
	decf	start_x, F, A
	decf	start_x, F, A
	decf	start_x, F, A
	decf	start_x, F, A
	
	movlw	0x03
	cpfsgt	start_x, A
	goto	reset1
	
	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	call	loop2
	
	
	bra	loop
	
loop2:
	
	call    LcdSelectLeft
	movlw	0x06
	call	set_y
	movf	start_x, W, A
	call    make_sprite_x
	movlw	0x2a
	call	set_x
	movlw	0x26
	call	make_sprite_y
	movlw	0x05
	call	set_y
	movf	start_x, W, A
	call    make_sprite_x
	movlw   0x70
	call	delay_ms
	call    LcdClear
	decf	start_x, F, A
	decf	start_x, F, A
	decf	start_x, F, A
	decf	start_x, F, A
	
	movlw	0x03
	cpfsgt	start_x, A
	goto	reset1	
	
	call	key_press
	movwf	key_bool, A
	movlw   0x00
	cpfsgt	key_bool, A; skip if key is pressed
	bra	loop
	
	bra	loop2
	
	goto	$
	
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
	
delay_ms:		    ; delay given in ms in W
	movwf	cnt_ms, A
delay_sub2:	movlw	250	    ; 1 ms delay
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

	end	rst