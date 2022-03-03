#include <xc.inc>
    
extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear
global	make_sprite_x
    
psect	sprite_data
    size:         ds     1
    page_length:  ds	 1
    x_coord:	  ds	 1
    y_coord:	  ds	 1
    
psect	sprite_code, class=CODE

make_sprite_x:
    movwf	x_coord, A
    movlw	0x08
    movwf	size, A
    movlw	0x40
    movwf	page_length, A
    subfwb	size, W, A
    cpfsgt	x_coord, A
    bra		displayleft
    bra	        displayright
    
displayleft:
    call        LcdSelectLeft
    movf	x_coord, W, A
    call        LcdSetRow
 
display:
    movlw	0xff
    call	LcdSendData
    decfsz      size,F,A
    bra	        display
    return
    
displayright:
    call        LcdSelectRight
    movlw	0x40
    subwf	x_coord, W, A
    call        LcdSetRow
    bra		display
    
    end
    


