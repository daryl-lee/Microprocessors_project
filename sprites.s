#include <xc.inc>
    
extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear
global	make_sprite_x, set_y
    
psect	udata_acs
    aaa:          ds     1
    bbb:	  ds	 1
    ccc:	  ds	 1
    x_coord2:	  ds	 1
    size_right:	  ds	 1
    size:         ds     1
    page_length:  ds	 1
    x_coord:	  ds	 1
    y_coord:	  ds	 1
    
psect	sprite_code, class=CODE

set_y:
    movwf	y_coord, A
    return
    
make_sprite_x:
    movwf	x_coord, A
    movlw	0x40
    movwf	page_length, A
    movlw	0x08
    movwf	size, A
    addwf	x_coord, W, A; x2 in W
    movwf	x_coord2, A
    decf	x_coord2, F, A
    movf	x_coord2, W, A
    cpfsgt	page_length, A; if 64>x2, skip  (all on left)
    bra		right_size
    bra		displayleft
   
    
right_size:
    subfwb	page_length, W, A; x2-64
    movwf	size_right, A; 
    incf	size_right, F, A
    movf	page_length, W, A
    movlw	0x63
    cpfsgt	x_coord, A; if x1>64 skip
    bra		inbetween
    bra		displayright

inbetween:
    movf	x_coord, W, A
    subwf	page_length, W, A; 64-x1
    movwf	size, A
    call	displayleft
    movff	size_right, size
    call        LcdSelectRight
    movlw	0x00
    call        LcdSetRow
    bra		set_page
    

displayleft:
    call        LcdSelectLeft
    movf	x_coord, W, A
    call        LcdSetRow
 
set_page:	
    movf	y_coord, W, A
    call	LcdSetPage
display:
    movlw	0xff
    call	LcdSendData
    decfsz      size,F,A
    ;movf	size, W, A
    bra	        display
    return
    
displayright:
    call        LcdSelectRight
    movlw	0x40
    subwf	x_coord, W, A
    call        LcdSetRow
    bra		set_page
    
    end
    


