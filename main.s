#include <xc.inc>

extrn	LcdOpen, LcdSendData, LcdSelectLeft, LcdSelectRight, LcdSetPage, LcdSetRow, LcdDisplayOn, LcdDisplayOff, LcdReset, LcdClear, make_sprite_x, set_y
extrn	set_x, make_sprite_y, LcdSetStart, key_setup, key_delay_ms, decode, key_press, collision_t1, collision_t2
extrn	load_data_treetop, load_data_treebottom, load_data_dino
extrn	random_setup, update_seed
extrn	score_init, scoreboard, highscore, display_score, display_hscore,  hscore_low, hscore_high
extrn	buzzer_setup, pulse_jump, pulse_death, death_setup  
extrn	start_menu, end_menu, pause_menu
extrn	env_init, make_ground, move_ground, make_cloud
global	t1_x1, t2_x1, d_y1, seed

psect	udata_acs   ; named variables in access ram
start_x: ds 1
start_y: ds 1

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

	; ******* Setup Code ***********************
setup:	
	pop
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	
	call	LcdOpen	; setup glcd
	call	key_setup ;setup keypad
	
	call	random_setup	;setup random number generator
	call	buzzer_setup	; setup buzzer
	clrf    STATUS, A

	goto	start
	
	; ******* Main programme ****************************************
start: 	call	LcdOpen
	call	LcdDisplayOn
	bra	init
	
	; ******* Set game parameters ****************************************	
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
	
	call	env_init	; sets variables in environment
	call	score_init	; digit display initialisation

startup:
	call	start_menu	; display start menu
	
	movlw	0x50
	call	key_delay_ms
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
	movlw	0x18
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
	call	make_trees	; creates trees
	movlw	0x2a
	call	set_x
	
	call	load_data_dino	    ; dino on ground
	movff	start_y, d_y1
	movf	start_y, W, A
	call	make_sprite_y
	
	call	frame_updates	    ; frame checks and updates
	
	call	key_press	    ; looks for key presses
	movwf	key_bool, A
	movlw   0x01
	cpfseq	key_bool, A; skip if key is pressed
	goto	loop
	call	jump
	goto	loop
	

	
	; ******* Airborne State ****************************************	
jump:				    ;jumping animation
				    ;y coordinates : 0x14 -> 0x1b -> 0x22 -> 0x26 -> 0x26 -> 0x22 -> 0x1b -> 0x14
    
	call	pulse_jump	    ;jump sound
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x14		    
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
    
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x1b
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x22
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x26
	movwf	d_y1, A
	call	make_sprite_y

	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x26
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x22
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x1b
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	call    LcdSelectLeft
	call	make_trees
	movlw	0x2a
	call	set_x
	
	call    load_data_dino
	movlw	0x14
	movwf	d_y1, A
	call	make_sprite_y
	
	call	frame_updates
	
	return
	
pause:
	call	pause_menu
	movlw	0x60
	call	key_delay_ms
	call	key_press
	movwf	key_bool, A
	movlw   0x02
	cpfseq	key_bool, A; skip if unpause key is pressed
	bra	pause
	movlw	0x60
	call	key_delay_ms
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
	
frame_updates:
	call	make_ground	   ;display ground
	call	move_ground	    ; shifts ground by 4
	call	move_ground
	call	move_ground
	call	move_ground
	
	call	make_cloud	    ;display static cloud
	
	call	scoreboard	    ;increase score
	call	display_score	    ;display current score
	call	display_hscore	    ;display previous highscore
	
	movf	delay_time, W, A
	call	key_delay_ms	    ; refresh rate set by delay time
	call	collision_check	    ; check for collision
	
	call    LcdClear	    ; clear screen after delay
	call	move_trees	    ; move trees by 4
	
	movlw	0x03
	cpfsgt	t1_x1, A	    ; if tree is 3 pixels away from left edge, remove tree
	call	reset1		    ; create new tree as replacement
	
	call	key_press	    ;checks for pause key
	movwf	key_bool, A
	movlw   0x02
	cpfseq	key_bool, A	    ; skip if pause key is pressed
	bra	$+4
	call	pause
	
	return
	
game_over:
	call	death_setup	;buzzer setup for death sound
	call    LcdClear
	call	LcdOpen
	call	LcdDisplayOn
	call    LcdClear
	call	pulse_death	;death sound
	
display_game_over:
	
	call	end_menu
	call	display_score	    ;display current score
	call	highscore	    ;updates highscore if current score > previous high score
	call	display_hscore	    ;display highscore
	
	movlw	0x90
	call	key_delay_ms

	call	key_press
	movwf	key_bool, A
	movlw   0x01
	cpfslt	key_bool, A; don't skip if key is pressed
	goto	setup
	
	bra	display_game_over

	goto	$

	end	rst