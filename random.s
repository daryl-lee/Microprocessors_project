#include <xc.inc>

extrn	    seed
global	    random_setup, update_seed
    
psect	udata_acs
five:	    ds  1
seventeen:  ds	1
    
    
psect	rand_code, class=CODE

random_setup:
	movlw	0x05
	movwf	five, A
	movlw	0x11
	movwf	seventeen, A
	
	return

update_seed:	
	movf	seed, W, A ;
	mulwf	five, A ; seed * 5
	movff	PRODL, seed
	movf	seventeen, W, A
	addwf	seed, F, A  ; seed + 17
	movlw	0b0111111   ; lower 7 bits of seed
	andwf	seed, F, A
	
	return

end
