#include <xc.inc>
	
psect	udata_acs
cycles:		    ds      1
    
psect	buzzer_code, class=CODE

 
movlw	    0x20
movwf	    cycles, A
  
pulse:  
    call	period
    decf	cycles
    movlw	0x00   
    cpfseq	cycles	;skip if = 0
    bra		pulse
    goto	$

	
period:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    bsf	LATB, 6, A	    ; Take enable high
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    bcf	LATB, 6, A	    ; Writes data to LCD
    return


