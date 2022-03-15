#include <xc.inc>
    
extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, LcdSetStart
global	make_sprite_x, set_y, set_x, make_sprite_y
    
psect	udata_acs
    factor:		    ds      1
    y_page:		    ds	    1
    screen_length:	    ds	    1
    x_coord2:		    ds	    1
    y_coord2:		    ds	    1
    size_right:		    ds	    1
    size:		    ds	    1
    page_length:	    ds	    1
    x_coord:		    ds	    1
    y_coord:		    ds	    1
    y_coord_temp:	    ds	    1
    sprite_data:	    ds	    1
    upper_sprite_data:	    ds	    1
    
psect	sprite_code, class=CODE

set_y:
    movwf	y_page, A
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
    movlw	0x3f
    cpfsgt	x_coord, A; if x1>64 skip
    bra		inbetween
    movlw	0x7f
    cpfsgt	x_coord2, A
    bra		displayright
    bra		right_edge

right_edge:
    movlw	0x80
    movwf	screen_length, A
    movf	x_coord, W, A
    subwf	screen_length, W, A ;128-x1
    movwf	size, A
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
    movf	y_page, W, A
    call	LcdSetPage
display:
    
    movf	POSTINC2, W, A
    ;movlw	0xff
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
    
divide8:
    movff	y_coord, y_coord_temp
    movlw	0x00
    movwf	factor, A
    movlw	0x08
    cpfslt	y_coord, A; skip if y1<8
    bra		divide
    return
	
divide: 
    subwf	y_coord_temp, F, A
    incf	factor, F, A
    cpfslt	y_coord_temp, A
    bra		divide
    return
    
set_x:
    movwf	x_coord, A
    return
    
    
make_sprite_y:
    movwf	y_coord, A
    call	divide8
    movlw	0x07
    movwf	y_page, A
    movf	factor, W, A
    subwf	y_page, F, A
    movlw	0x40
    movwf	page_length, A
    movf	y_coord_temp, W, A
    movlw	0x08
    movwf	size, A
    addwf	y_coord, W, A
    movwf	y_coord2, A
    call        LcdSelectLeft
    movf	x_coord, W, A
    call        LcdSetRow  
    call	bottom_page
    movlw	0x08
    movwf	size, A
    movf	x_coord, W, A
    call        LcdSetRow
    call	upper_page
    return
    

empty_page:
    movlw	0x00
    movwf	upper_sprite_data, A
    movf	POSTINC2, W, A
    ;movlw	0xff
    movwf	sprite_data, A
    movlw	0x00
    cpfsgt	y_coord_temp, A ;skip if remainder is =0
    return
    
shift:
    
    rrncf	sprite_data, F, A
    movlw	0x80
    andwf	sprite_data, W, A
    rrncf	upper_sprite_data, F, A
    iorwf	upper_sprite_data, F, A
    movlw	0x7f
    andwf	sprite_data, F, A
    decfsz	y_coord_temp, F, A
    bra		shift
    return
    
bottom_page:	
    movf	y_page, W, A
    call	LcdSetPage
    ;call	empty_page
display_bottom:
    call	empty_page
    ;movlw	0x10
    ;call	LcdSetStart
    movf	sprite_data, W, A
    call	LcdSendData
    decfsz      size,F,A
    bra	        display_bottom
    return
    
upper_page:
    decf	y_page, W, A
    call	LcdSetPage
display_upper:
    ;movlw	0x10
    ;call	LcdSetStart
    movf	upper_sprite_data, W, A
    call	LcdSendData
    decfsz      size,F,A
    bra	        display_upper
    return    
    
    
    end
    


