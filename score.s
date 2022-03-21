#include <xc.inc>

extrn	load_data_0, load_data_1, load_data_2, load_data_3, load_data_4, load_data_5, load_data_6 , load_data_7, load_data_8, load_data_9
extrn	set_y, make_sprite_x
global	score_init, scoreboard, highscore, display_score, display_hscore, hscore_low, hscore_high
    
psect	udata_acs    
score_low:	ds  1
score_high:	ds  1  
hscore_low:	ds  1
hscore_high:	ds 1
digit0:		ds 1
digit1:		ds 1
digit2:		ds 1
digit3:		ds 1
digit4:		ds 1
digit5:		ds 1
digit6:		ds 1
digit7:		ds 1
digit8:		ds 1
digit9:		ds 1
position_x:	ds 1
k_consth:	ds 1
k_constl:	ds 1 
k_const2:	ds 1
RES0:	    ds 1
RES1:	    ds 1
RES2:	    ds 1
RES3:	    ds 1
RES11:	    ds 1
RES21:	    ds 1
RES31:	    ds 1

	
psect	score_code, class=CODE
score_init:
    movlw   0x00
    movwf   score_low, A
    movwf   score_high, A
    movwf   digit0, A
    movlw   0x01
    movwf   digit1, A
    movlw   0x02
    movwf   digit2, A
    movlw   0x03
    movwf   digit3, A
    movlw   0x04
    movwf   digit4, A
    movlw   0x05
    movwf   digit5, A
    movlw   0x06
    movwf   digit6, A
    movlw   0x07
    movwf   digit7, A
    movlw   0x08
    movwf   digit8, A
    movlw   0x09
    movwf   digit9, A
    movlw   0x5e
    movwf   position_x, A
    movlw   0x41
    movwf   k_consth, A
    movlw   0x8a
    movwf   k_constl, A
    movlw   0x0a
    movwf   k_const2, A

    return
    
scoreboard:
    bra	    scoreboard_low
    
scoreboard_low:
    incfsz  score_low, F, A
    return
    bra	    scoreboard_high
    
scoreboard_high:
    incf    score_high, F, A
    return
    
highscore:
    movf    hscore_high, W, A
    cpfsgt  score_high, A ;skip if score_high>hscore_high 
    bra     hscore_eq
    
highscore_low:  
    movf    hscore_low, W, A
    cpfsgt  score_low, A ;skip if score_high>hscore_high 
    return
    movff   score_low, hscore_low
    movff   score_high, hscore_high
    return
    
hscore_eq:
    cpfseq  score_high, A
    return
    bra	    highscore_low
    
display_score:
    
    call    multiply16x16
    movf    RES3, W, A
    call    display_score0
    call    multiply24x8
    movf    RES31, W, A
    call    display_score0
    
    movff   RES21, RES2	
    movff   RES11, RES1
    
    call    multiply24x8
    movff   RES31, RES3
    movff   RES21, RES2
    movff   RES11, RES1
    
    movf    RES3, W, A
    call    display_score0
    
    call    multiply24x8
    movf    RES31, W, A
    call    display_score0
    movlw   0x5e
    movwf   position_x, A
    return
    
display_hscore:
    movlw   0x00
    movwf   position_x, A
    call    multiply16x16h
    movf    RES3, W, A
    call    display_score0
    call    multiply24x8
    movf    RES31, W, A
    call    display_score0
    
    movff   RES21, RES2	
    movff   RES11, RES1
    
    call    multiply24x8
    movff   RES31, RES3
    movff   RES21, RES2
    movff   RES11, RES1
    
    movf    RES3, W, A
    call    display_score0
    
    call    multiply24x8
    movf    RES31, W, A
    call    display_score0
    movlw   0x5e
    movwf   position_x, A
    return


display_score0:
    cpfseq  digit0, A
    bra     display_score1
    movlw   0x00
    call    set_y
    call    load_data_0
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return
    
display_score1:
    cpfseq  digit1, A
    bra	    display_score2	    
    movlw   0x00
    call    set_y
    call    load_data_1
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return
    
display_score2:
    cpfseq  digit2, A
    bra     display_score3	    
    movlw   0x00
    call    set_y
    call    load_data_2
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return

display_score3:
    cpfseq  digit3, A
    bra	    display_score4	    
    movlw   0x00
    call    set_y
    call    load_data_3
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return

display_score4:
    cpfseq  digit4, A
    bra     display_score5	    
    movlw   0x00
    call    set_y
    call    load_data_4
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return

display_score5:
    cpfseq  digit5, A
    bra	    display_score6	    
    movlw   0x00
    call    set_y
    call    load_data_5
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return
    
display_score6:
    cpfseq  digit6, A
    bra     display_score7	    
    movlw   0x00
    call    set_y
    call    load_data_6
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return

display_score7:
    cpfseq  digit7, A
    bra	    display_score8	    
    movlw   0x00
    call    set_y
    call    load_data_7
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return
    
display_score8:
    cpfseq  digit8, A
    bra     display_score9	    
    movlw   0x00
    call    set_y
    call    load_data_8
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return

display_score9:
    cpfseq  digit9, A
    nop	    
    movlw   0x00
    call    set_y
    call    load_data_9
    movf    position_x, W, A
    call    make_sprite_x
    movlw   0x08
    addwf   position_x, F, A
    return
    

multiply16x16:	
    MOVF    score_low, W, A
    MULWF   k_constl, A 
    MOVFF   PRODH, RES1 ;
    MOVFF   PRODL, RES0 ;

    MOVF  score_high, W, A
    MULWF k_consth, A 
    MOVFF PRODH, RES3 ;
    MOVFF PRODL, RES2 ;

    MOVF score_low, W, A
    MULWF k_consth, A 
    MOVF PRODL, W, A ;
    ADDWF RES1, F ; Add cross
    MOVF PRODH, W, A ; products
    ADDWFC RES2, F ;
    CLRF WREG ;
    ADDWFC RES3, F ;

    MOVF score_high, W, A ;
    MULWF k_constl, A ;
    MOVF PRODL, W, A ;
    ADDWF RES1, F ; Add cross
    MOVF PRODH, W, A ; products
    ADDWFC RES2, F ;
    CLRF WREG ;
    ADDWFC RES3, F ;
    return   
    
multiply16x16h:	
    MOVF    hscore_low, W, A
    MULWF   k_constl, A 
    MOVFF   PRODH, RES1 ;
    MOVFF   PRODL, RES0 ;

    MOVF  hscore_high, W, A
    MULWF k_consth, A 
    MOVFF PRODH, RES3 ;
    MOVFF PRODL, RES2 ;

    MOVF hscore_low, W, A
    MULWF k_consth, A 
    MOVF PRODL, W, A ;
    ADDWF RES1, F ; Add cross
    MOVF PRODH, W, A ; products
    ADDWFC RES2, F ;
    CLRF WREG ;
    ADDWFC RES3, F ;

    MOVF hscore_high, W, A ;
    MULWF k_constl, A ;
    MOVF PRODL, W, A ;
    ADDWF RES1, F ; Add cross
    MOVF PRODH, W, A ; products
    ADDWFC RES2, F ;
    CLRF WREG ;
    ADDWFC RES3, F ;
    return   
    
multiply24x8:	
    MOVF	RES0, W, A
    MULWF	k_const2, A 
    MOVFF	PRODH, RES11 ;
    MOVFF	PRODL, RES0 ;

    MOVF	RES2, W, A
    MULWF	k_const2, A 
    MOVFF	PRODH, RES31 ;
    MOVFF	PRODL, RES21 ;

    MOVF	RES1, W, A
    MULWF	k_const2, A 
    MOVF	PRODL, W, A ;
    ADDWF	RES11, F ; Add cross
    MOVF	PRODH, W, A ; products
    ADDWFC	RES21, F ;
    CLRF	WREG ;
    ADDWFC	RES31, F ;

    return

    

