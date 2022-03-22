#include <xc.inc>

extrn	set_y, make_sprite_x
extrn	load_block1, load_block2, load_block3, load_block4, load_block5, load_block6, load_block7, load_block8
extrn	load_block9, load_block10, load_block11, load_block12, load_block13, load_block14, load_block15, load_block16   
extrn	load_cloud1, load_cloud2, load_cloud3, load_cloud4, load_cloud5, load_cloud6, load_cloud7, load_cloud8
extrn	load_cloud9, load_cloud10, load_cloud11, load_cloud12, load_cloud13, load_cloud14, load_cloud15, load_cloud16    
 
global	env_init, make_ground, move_ground;, make_cloud, move_cloud    


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

psect	udata_bank4, class=BANK4
;psect	data
c1_x1:		    ds 1
c2_x1:		    ds 1
c3_x1:		    ds 1
c4_x1:		    ds 1
c5_x1:		    ds 1
c6_x1:		    ds 1
c7_x1:		    ds 1
c8_x1:		    ds 1
c9_x1:		    ds 1
c10_x1:		    ds 1
c11_x1:		    ds 1
c12_x1:		    ds 1
c13_x1:		    ds 1
c14_x1:		    ds 1
c15_x1:		    ds 1
c16_x1:		    ds 1
    
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
    
;    movlb	0x04
;    movlw	0x00
;    movwf	c1_x1, B
;    movlw	0x08
;    movwf	c2_x1, B
;    movlw	0x10
;    movwf	c3_x1, B
;    movlw	0x18
;    movwf	c4_x1, B
;    movlw	0x20
;    movwf	c5_x1, B
;    movlw	0x28
;    movwf	c6_x1, B
;    movlw	0x30
;    movwf	c7_x1, B
;    movlw	0x38
;    movwf	c8_x1, B
;    movlw	0x40
;    movwf	c9_x1, B
;    movlw	0x48
;    movwf	c10_x1, B
;    movlw	0x50
;    movwf	c11_x1, B
;    movlw	0x58
;    movwf	c12_x1, B
;    movlw	0x60
;    movwf	c13_x1, B
;    movlw	0x68
;    movwf	c14_x1, B
;    movlw	0x70
;    movwf	c15_x1, B
;    movlw	0x78
;    movwf	c16_x1, B
;    
;    movlb   0x00
    
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
	
	
;make_cloud:
;	movlb	1
;    
;	movlw   0x01	;
;	call	set_y	;
;	call	load_cloud1
;	movf	c1_x1, W, B
;	call	make_sprite_x
;	
;	
;	movlw   0x01	;
;	call	set_y
;	call	load_cloud2
;	movf	c2_x1, W, B
;	call	make_sprite_x
;	
;	
;	movlw   0x01	;
;	call	set_y
;	call	load_cloud3
;	movf	c3_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud4
;	movf	c4_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud5
;	movf	c5_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud6
;	movf	c6_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud7
;	movf	c7_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud8
;	movf	c8_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud9
;	movf	c9_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud10
;	movf	c10_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud11
;	movf	c11_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud12
;	movf	c12_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud13
;	movf	c13_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud14
;	movf	c14_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud15
;	movf	c15_x1, W, B
;	call	make_sprite_x
;	
;	call	load_cloud16
;	movf	c16_x1, W, B
;	call	make_sprite_x
;	
;	movlb	0
;	
;	return
;    
;move_cloud:
;	movlb	1
;	decf	c1_x1, F, B
;	decf	c2_x1, F, B
;	decf	c3_x1, F, B
;	decf	c4_x1, F, B
;	decf	c5_x1, F, B
;	decf	c6_x1, F, B
;	decf	c7_x1, F, B
;	decf	c8_x1, F, B
;	decf	c9_x1, F, B
;	decf	c10_x1, F, B
;	decf	c11_x1, F, B
;	decf	c12_x1, F, B
;	decf	c13_x1, F, B
;	decf	c14_x1, F, B
;	decf	c15_x1, F, B
;	decf	c16_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c1_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c1_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c2_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c2_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c3_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c3_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c4_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c4_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c5_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c5_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c6_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c6_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c7_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c7_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c8_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c8_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c9_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c9_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c10_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c10_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c11_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c11_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c12_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c12_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c13_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c13_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c14_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c14_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c15_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c15_x1, F, B
;	
;	movlw	0x7f
;	cpfsgt	c16_x1, B
;	bra	$+6
;	movlw	0x80
;	subwf	c16_x1, F, B
;	
;	movlb	0
;	
;	return


end
