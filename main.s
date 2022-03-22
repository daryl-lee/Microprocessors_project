#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, make_sprite_x, set_y
extrn	set_x, make_sprite_y, LcdSetStart, key_setup, key_setup_column, key_delay_ms, key_setup_row, decode, collision_t1, collision_t2
extrn	load_data_A, load_data_E, load_data_G , load_data_M, load_data_O, load_data_R, load_data_V, load_data_P, load_data_S
extrn	load_data_treetop, load_data_treebottom, load_data_dino
extrn	random_setup, update_seed
extrn	score_init, scoreboard, highscore, display_score, display_hscore,  hscore_low, hscore_high
extrn	load_block1, load_block2, load_block3, load_block4, load_block5, load_block6, load_block7, load_block8
extrn	load_block9, load_block10, load_block11, load_block12, load_block13, load_block14, load_block15, load_block16
extrn	buzzer_setup, pulse    
extrn	start_menu
global	t1_x1, t2_x1, d_y1, seed

psect	udata_acs   ; named variables in access ram
cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
cnt_ms:	ds 1   ; reserve 1 byte for ms counter
start_x: ds 1
start_y: ds 1
keys1:	ds  1
keys2:	ds  1
key_bool: ds 1
distance:   ds 1
t1_x1: ds 1
t2_x1: ds 1
d_y1:  ds 1
display_distance:   ds 1
collision_bool:     ds 1
seed:		    ds 1
start_counter:	    ds 1
short_seed:	    ds 1
min_dist:	    ds 1
delay_time:	    ds 1
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
delay_rate:	    ds 1
    
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data


    
psect	code, abs	
rst: 	org 0x0
	movlw	0x00
	movwf	hscore_low, A
	movwf	hscore_high, A
	
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	
	
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	
	call	LcdOpen	; setup glcd
	call	key_setup
	
	call	random_setup
	call	buzzer_setup
	clrf    STATUS, A
	
	
	
	goto	start
	
	; ******* Main programme ****************************************
start: 	call	LcdOpen
	call	LcdDisplayOn
	bra	init

	
	goto $
	
	
init:	
	call    LcdClear
	movlw	0x18
	movwf	distance, A ;min distance between trees
	movlw	0x7f
	movwf	t1_x1, A
	movwf	display_distance, A ;127
	movlw	0x8f
	addwf	distance, W, A
	movwf	t2_x1, A
	movlw	0x08
	movwf	start_y, A
	movlw   0x50
	movwf	delay_time, A
	movlw	0x0e
	movwf	delay_rate, A
	
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
	
	call	score_init

startup:
	call	start_menu
	
	movlw	0x00
	movwf	start_counter, A

set_seed:
	movff	start_counter, seed
	incf	start_counter, F, A
	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	bra	random_init
	bra	set_seed
	
random_init:
	call	update_seed
	movlw	0b00111111
	movwf	short_seed, A
	movlw	0x10
	movwf	min_dist, A
	movlw	0x7f
	addwf	seed, W, A
	movwf	t1_x1, A
	call    update_seed
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	t1_x1, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A
	call    LcdClear
loop:	
    
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call	load_data_dino
	movff	start_y, d_y1
	movf	start_y, W, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1
	
	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	call	jump
	
	
	bra	loop
	
jump:
	;call	pulse
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x14
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1	
    
    
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x1b
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1	
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x22
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1
	
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x26
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x26
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x22
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x1b
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1	
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x14
	movwf	d_y1, A
	call	make_sprite_y
	
	call	make_ground
	call	move_ground
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	scoreboard
	call	display_score
	call	display_hscore
	
	movf	delay_time, W, A
	call	delay_ms
	call	collision_check
	
	call    LcdClear
	call	move_trees
	
	movlw	0x03
	cpfsgt	t1_x1, A
	call	reset1	
	
	bra	loop
	
	goto	$
	
reset1:
	movff	t2_x1, t1_x1
	movf	t1_x1, W, A
	cpfslt	display_distance, A	; dont skip if t1_x1 is less than 127
	bra	random_case1
	call    update_seed
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	t1_x1, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A
	movf	delay_rate, W, A
	subwf	delay_time, F, A

	
	return	
	
random_case1:
	call    update_seed
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	display_distance, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A
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
	
make_trees:
	movlw	0x06
	call	set_y
	call	load_data_treebottom
	movf	t1_x1, W, A
	cpfslt	display_distance, A	; display tree if x is less than 127
	call    make_sprite_x
	movlw	0x05
	call	set_y
	call	load_data_treetop
	movf	t1_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	
	movlw	0x06
	call	set_y
	call	load_data_treebottom
	movf	t2_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	movlw	0x05
	call	set_y
	call	load_data_treetop
	movf	t2_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	
	return
	
	
move_trees:
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	
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
	
collision_check:
	call	collision_t1
	
	movwf	collision_bool, A
	movlw   0x01
	cpfslt	collision_bool, A ;skip if no collision (W=0x00)
	call	game_over
	
	call	collision_t2
	
	movwf	collision_bool, A
	movlw   0x01
	cpfslt	collision_bool, A ;skip if no collision (W=0x00)
	call	game_over
	return
	
game_over:
	call    LcdClear
	call	LcdOpen
	call	LcdDisplayOn
	call    LcdClear
	
display_game_over:
	movlw	0x02
	call	set_y
	call	load_data_G
	movlw	0x32
	call	make_sprite_x
	
	
	call	load_data_A
	movlw	0x3a
	call	make_sprite_x
	
	
	call	load_data_M
	movlw	0x42
	call	make_sprite_x
	
	
	call	load_data_E
	movlw	0x4a
	call	make_sprite_x
	
	movlw	0x03
	call	set_y
	call	load_data_O
	movlw	0x32
	call	make_sprite_x
	
	
	call	load_data_V
	movlw	0x3a
	call	make_sprite_x
	
	
	call	load_data_E
	movlw	0x42
	call	make_sprite_x
	
	
	call	load_data_R
	movlw	0x4a
	call	make_sprite_x
	
	call	display_score
	call	highscore
	call	display_hscore
	
	movlw	0x90
	call	delay_ms
	
	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	goto	setup
	
	bra	display_game_over
	
	
	
	goto	$
	
	

	end	rst