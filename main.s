#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, make_sprite_x, set_y
extrn	set_x, make_sprite_y, LcdSetStart, key_setup, key_setup_column, key_delay_ms, key_setup_row, decode, collision_t1, collision_t2
extrn	load_data_treetop, load_data_treebottom, load_data_dino
extrn	random_setup, update_seed
extrn	score_init, scoreboard, highscore, display_score, display_hscore,  hscore_low, hscore_high
extrn	buzzer_setup, pulse    
extrn	start_menu, end_menu
extrn	env_init, make_ground, move_ground, make_cloud;, move_cloud 
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
delay_rate:	    ds 1
    


    
psect	code, abs	
rst: 	org 0x0
	movlw	0x00
	movwf	hscore_low, A
	movwf	hscore_high, A
	
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	
	pop
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
	
		
init:	
	call    LcdClear
	movlw	0x18
	movwf	distance, A ;min distance between trees
	movlw	0x7f
	movwf	t1_x1, A    ;starting x1 coordinate of tree 1
	movwf	display_distance, A ;127
	movlw	0x8f
	addwf	distance, W, A
	movwf	t2_x1, A    ;starting x1 coordinate of tree 2
	movlw	0x08
	movwf	start_y, A
	movlw   0x50
	movwf	delay_time, A
	movlw	0x0e
	movwf	delay_rate, A
	
	call	env_init
	
	call	score_init

startup:
	call	start_menu
	
	movlw	0x50
	call	delay_ms
	
	movlw	0x00
	movwf	start_counter, A    ;initialise counter for seed generation

set_seed:
	movff	start_counter, seed
	incf	start_counter, F, A	; increment counter until FFh then goes back to 00h
	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	bra	random_init ;set counter to seed if key is pressed
	bra	set_seed
	
random_init:
	call	update_seed ;generates the next random number in the sequence 
	movlw	0b00111111
	movwf	short_seed, A	;ensure that new tree position does not exceed FFh
	movlw	0x16
	movwf	min_dist, A	;minimum distance between t1_x1 and t2_x1
	movlw	0x7f
	addwf	seed, W, A	
	movwf	t1_x1, A	;starting tree 1 position = 127 + random number (0-127)
	call    update_seed
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	t1_x1, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A	;starting tree 2 position = tree 1 position + minimum distance + short random number(0 - 64)
	call    LcdClear
	
	; ******* Ground State ****************************************	
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
	
	call	make_cloud
;	call	move_cloud
	
	
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
	
	
	goto	loop
	
	
	; ******* Airborne State ****************************************	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	call	make_cloud
;	call	move_cloud
	
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
	
	return
	
	
reset1:
	movff	t2_x1, t1_x1		;swap tree labels
	movf	t1_x1, W, A
	cpfslt	display_distance, A	; dont skip if t1_x1 is less than 127
	bra	random_case1
	call    update_seed		; if there are no trees on screen
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	t1_x1, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A		;tree 2 position = tree 1 position + minimum distance + short random number
	movf	delay_rate, W, A	
	subwf	delay_time, F, A	;decrease delay time by delay rate every time we make a tree

	
	return	
	
random_case1:				;if there is another tree on screen already
	call    update_seed
	movf	seed, W, A
	andwf	short_seed, W, A
	addwf	display_distance, W, A
	addwf	min_dist, W, A
	movwf	t2_x1, A		; tree 2 position = 127 + minimum distance + short random number
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
	movlw	0x06			;page of upper tree 1 sprite
	call	set_y
	call	load_data_treebottom
	movf	t1_x1, W, A
	cpfslt	display_distance, A	; display tree if x is less than 127
	call    make_sprite_x
	movlw	0x05			;page of lower tree 1 sprite
	call	set_y
	call	load_data_treetop
	movf	t1_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	
	movlw	0x06			;page of upper tree 2 sprite
	call	set_y
	call	load_data_treebottom
	movf	t2_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	movlw	0x05			;page of lower tree 2 sprite
	call	set_y
	call	load_data_treetop
	movf	t2_x1, W, A
	cpfslt	display_distance, A
	call    make_sprite_x
	
	return
	
	
move_trees:			;both trees move by 4 pixels per frame
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t1_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	decf	t2_x1, F, A
	
	return

	
collision_check:
	call	collision_t1	   ; check with collision box of tree 1
	
	movwf	collision_bool, A
	movlw   0x01
	cpfslt	collision_bool, A ;skip if no collision (W=0x00)
	bra	game_over
	
	call	collision_t2	    ;check with collision box of tree 2
	
	movwf	collision_bool, A
	movlw   0x01
	cpfslt	collision_bool, A ;skip if no collision (W=0x00)
	bra	game_over
	return
	
game_over:
	
	call    LcdClear
	call	LcdOpen
	call	LcdDisplayOn
	call    LcdClear
	
display_game_over:
	call	end_menu
	
	call	display_score	    ;display current score
	call	highscore	    ;updates highscore if current score > previous high score
	call	display_hscore	    ;display highscore
	
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