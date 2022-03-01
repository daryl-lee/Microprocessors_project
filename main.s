#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset
	
psect	udata_acs   ; reserve data space in access ram

    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    

    
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
	
reset1:	call    LcdSelectRight
	;movlw	0x01
	;call	LcdSetPage
;	movlw	0x7F
;	call	LcdSendData
;	movlw	0x08
;	call	LcdSendData
;	movlw	0x08
;	call	LcdSendData
;	movlw	0x08
;	call	LcdSendData
;	movlw	0x7F
;	call	LcdSendData
;	movlw	0x00
;	call	LcdSendData
	;call	LcdReset
	;bra	reset1
	goto	$		; goto current line in code

	end	rst