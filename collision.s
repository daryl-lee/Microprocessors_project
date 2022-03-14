#include <xc.inc>

extrn	t1_x1, t2_x1, d_y1
global	collision
    
psect	udata_acs
d_x1: ds 1
delta_x: ds 1
delta_y: ds 1
	
psect	collision_code, class=CODE
	
collision:
    movlw   0x2a
    movwf   d_x1, A
    cpfsgt  t1_x1, A ;skip if t1_x1>d_x1
    nop			;find d_x1-t1_x1
    subwf   t1_x1, W, A	;t1_x1-d_x1
    movwf   delta_x, A
    movlw   0x07
    cpfsgt  delta_x, A ;skip if delta_x>7 (>=8)
    bra	    collision_y
    return
    
collision_y:
    movlw   0x08
    subwf   d_y1, W, A
    movwf   delta_y, A
    movlw   0x0f
    cpfsgt  delta_y, A ;skip if delta_y>15 (>=16)
    nop	    ;collision occurs
    return


