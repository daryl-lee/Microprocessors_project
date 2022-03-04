#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, make_sprite_x, set_y
	
psect	udata_acs   ; reserve data space in access ram

    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data


    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	
	call	LcdOpen	; setup glcd
	goto	start
	
	; ******* Main programme ****************************************
start: 	call	LcdOpen
	call	LcdDisplayOn
	
reset1:	
	call    LcdClear
	call    LcdSelectLeft
	movlw	0x02
	call	set_y
	movlw	0x3D
	call    make_sprite_x
;	movlw	0x03
;	call	set_y
;	movlw	0x38
;	call    make_sprite_x
	call    LcdSelectLeft
	movlw	0x03
	call	LcdSetPage
	movlw	0x3f
	call    LcdSetRow
	movlw	0xff
	call	LcdSendData
	
	goto	$		; goto current line in code

	end	rst