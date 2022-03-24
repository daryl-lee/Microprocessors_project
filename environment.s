#include <xc.inc>

extrn	set_y, make_sprite_x
extrn	load_block1, load_block2, load_block3, load_block4, load_block5, load_block6, load_block7, load_block8
extrn	load_block9, load_block10, load_block11, load_block12, load_block13, load_block14, load_block15, load_block16   
extrn	load_cloud1, load_cloud2, load_cloud3, load_cloud4, load_cloud5, load_cloud6, load_cloud7, load_cloud8
extrn	load_cloud9, load_cloud10, load_cloud11, load_cloud12, load_cloud13, load_cloud14, load_cloud15, load_cloud16    
 
global	env_init, make_ground, move_ground, make_cloud   


psect	udata_acs
	
b1_x1:		    ds 1
b2_x1:		    ds 1
b3_x1:		    ds 1
b4_x1:		    ds 1
b5_x1:		    ds 1
b6_x1:		    ds 1
b7_x1:		    ds 1
b8_x1:		    ds 1
b9_x1:		    ds 1
b10_x1:		    ds 1
b11_x1:		    ds 1
b12_x1:		    ds 1
b13_x1:		    ds 1
b14_x1:		    ds 1
b15_x1:		    ds 1
b16_x1:		    ds 1

    
psect	env_code, class=CODE 
    
env_init:
    movlw	0x00
    movwf	b1_x1, A
    movlw	0x08
    movwf	b2_x1, A
    movlw	0x10
    movwf	b3_x1, A
    movlw	0x18
    movwf	b4_x1, A
    movlw	0x20
    movwf	b5_x1, A
    movlw	0x28
    movwf	b6_x1, A
    movlw	0x30
    movwf	b7_x1, A
    movlw	0x38
    movwf	b8_x1, A
    movlw	0x40
    movwf	b9_x1, A
    movlw	0x48
    movwf	b10_x1, A
    movlw	0x50
    movwf	b11_x1, A
    movlw	0x58
    movwf	b12_x1, A
    movlw	0x60
    movwf	b13_x1, A
    movlw	0x68
    movwf	b14_x1, A
    movlw	0x70
    movwf	b15_x1, A
    movlw	0x78
    movwf	b16_x1, A

    
    return
    
make_ground:
	movlw   0x07	;
	call	set_y	;
	call	load_block1
	movf	b1_x1, W, A
	call	make_sprite_x
	
	
	movlw   0x07	;
	call	set_y
	call	load_block2
	movf	b2_x1, W, A
	call	make_sprite_x
	
	
	movlw   0x07	;
	call	set_y
	call	load_block3
	movf	b3_x1, W, A
	call	make_sprite_x
	
	call	load_block4
	movf	b4_x1, W, A
	call	make_sprite_x
	
	call	load_block5
	movf	b5_x1, W, A
	call	make_sprite_x
	
	call	load_block6
	movf	b6_x1, W, A
	call	make_sprite_x
	
	call	load_block7
	movf	b7_x1, W, A
	call	make_sprite_x
	
	call	load_block8
	movf	b8_x1, W, A
	call	make_sprite_x
	
	call	load_block9
	movf	b9_x1, W, A
	call	make_sprite_x
	
	call	load_block10
	movf	b10_x1, W, A
	call	make_sprite_x
	
	call	load_block11
	movf	b11_x1, W, A
	call	make_sprite_x
	
	call	load_block12
	movf	b12_x1, W, A
	call	make_sprite_x
	
	call	load_block13
	movf	b13_x1, W, A
	call	make_sprite_x
	
	call	load_block14
	movf	b14_x1, W, A
	call	make_sprite_x
	
	call	load_block15
	movf	b15_x1, W, A
	call	make_sprite_x
	
	call	load_block16
	movf	b16_x1, W, A
	call	make_sprite_x
	
	return
    
move_ground:
	decf	b1_x1, F, A
	decf	b2_x1, F, A
	decf	b3_x1, F, A
	decf	b4_x1, F, A
	decf	b5_x1, F, A
	decf	b6_x1, F, A
	decf	b7_x1, F, A
	decf	b8_x1, F, A
	decf	b9_x1, F, A
	decf	b10_x1, F, A
	decf	b11_x1, F, A
	decf	b12_x1, F, A
	decf	b13_x1, F, A
	decf	b14_x1, F, A
	decf	b15_x1, F, A
	decf	b16_x1, F, A
	
	movlw	0x7f
	cpfsgt	b1_x1, A
	bra	$+6
	movlw	0x80
	subwf	b1_x1, F, A
	
	movlw	0x7f
	cpfsgt	b2_x1, A
	bra	$+6
	movlw	0x80
	subwf	b2_x1, F, A
	
	movlw	0x7f
	cpfsgt	b3_x1, A
	bra	$+6
	movlw	0x80
	subwf	b3_x1, F, A
	
	movlw	0x7f
	cpfsgt	b4_x1, A
	bra	$+6
	movlw	0x80
	subwf	b4_x1, F, A
	
	movlw	0x7f
	cpfsgt	b5_x1, A
	bra	$+6
	movlw	0x80
	subwf	b5_x1, F, A
	
	movlw	0x7f
	cpfsgt	b6_x1, A
	bra	$+6
	movlw	0x80
	subwf	b6_x1, F, A
	
	movlw	0x7f
	cpfsgt	b7_x1, A
	bra	$+6
	movlw	0x80
	subwf	b7_x1, F, A
	
	movlw	0x7f
	cpfsgt	b8_x1, A
	bra	$+6
	movlw	0x80
	subwf	b8_x1, F, A
	
	movlw	0x7f
	cpfsgt	b9_x1, A
	bra	$+6
	movlw	0x80
	subwf	b9_x1, F, A
	
	movlw	0x7f
	cpfsgt	b10_x1, A
	bra	$+6
	movlw	0x80
	subwf	b10_x1, F, A
	
	movlw	0x7f
	cpfsgt	b11_x1, A
	bra	$+6
	movlw	0x80
	subwf	b11_x1, F, A
	
	movlw	0x7f
	cpfsgt	b12_x1, A
	bra	$+6
	movlw	0x80
	subwf	b12_x1, F, A
	
	movlw	0x7f
	cpfsgt	b13_x1, A
	bra	$+6
	movlw	0x80
	subwf	b13_x1, F, A
	
	movlw	0x7f
	cpfsgt	b14_x1, A
	bra	$+6
	movlw	0x80
	subwf	b14_x1, F, A
	
	movlw	0x7f
	cpfsgt	b15_x1, A
	bra	$+6
	movlw	0x80
	subwf	b15_x1, F, A
	
	movlw	0x7f
	cpfsgt	b16_x1, A
	bra	$+6
	movlw	0x80
	subwf	b16_x1, F, A
	
	return
	
	
	
make_cloud:
    
	movlw   0x02	;
	call	set_y	;
	call	load_cloud1
	movlw	0x00
	call	make_sprite_x
	
	
	call	load_cloud2
	movlw	0x08
	call	make_sprite_x
	
	
	call	load_cloud3
	movlw	0x10
	call	make_sprite_x
	
	call	load_cloud4
	movlw	0x18
	call	make_sprite_x
	
	call	load_cloud5
	movlw	0x20
	call	make_sprite_x
	
	call	load_cloud6
	movlw	0x28
	call	make_sprite_x
	
	call	load_cloud7
	movlw	0x30
	call	make_sprite_x
	
	call	load_cloud8
	movlw	0x38
	call	make_sprite_x
	
	call	load_cloud9
	movlw	0x40
	call	make_sprite_x
	
	call	load_cloud10
	movlw	0x48
	call	make_sprite_x
	
	call	load_cloud11
	movlw	0x50
	call	make_sprite_x
	
	call	load_cloud12
	movlw	0x58
	call	make_sprite_x
	
	call	load_cloud13
	movlw	0x60
	call	make_sprite_x
	
	call	load_cloud14
	movlw	0x68
	call	make_sprite_x
	
	call	load_cloud15
	movlw	0x70
	call	make_sprite_x
	
	call	load_cloud16
	movlw	0x78
	call	make_sprite_x
	
	
	return


end
