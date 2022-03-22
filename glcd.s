#include <xc.inc>
global  LcdOpen
global  LcdDisplayOn
global  LcdDisplayOff
global  LcdCtrlAll
global  LcdSendCtrl
global  LcdSendData
global  LcdWait
global  LcdReadBusy
global  LcdReadData
global  LcdSelectLeft
global  LcdSelectRight
global  LcdSetPage
global  LcdSetRow
global  LcdReset
global  LcdClear
global	LcdSetStart
 
LCD_RES_TRIS    equ     TRISB           ; /RES        
 LCD_RES_LAT     equ     LATB
 LCD_RES         equ     5
 
 LCD_CS1_TRIS    equ     TRISB           ; /CS1
 LCD_CS1_LAT     equ     LATB
 LCD_CS1         equ     0
 
 LCD_CS2_TRIS    equ     TRISB           ; /CS2
 LCD_CS2_LAT     equ     LATB
 LCD_CS2         equ     1
 
 LCD_R_W_TRIS    equ     TRISB           ; R/W
 LCD_R_W_LAT     equ     LATB
 LCD_R_W         equ     3
 
 LCD_D_I_TRIS    equ     TRISB           ; D/I
 LCD_D_I_LAT     equ     LATB
 LCD_D_I         equ     2
 
 LCD_EN_TRIS     equ     TRISB           ; EN
 LCD_EN_LAT      equ     LATB
 LCD_EN          equ     4
 
 
 LCD_DATA_TRIS   equ     TRISD           ; D0-D7
 LCD_DATA_PORT   equ     PORTD
 LCD_DATA_LAT    equ     LATD
   
 	
 ;===============================================================================
 ; Data Areas
 ;-------------------------------------------------------------------------------
 
 psect	udata_acs 
 
 PAGE_NO:         ds     1
 ROW_NO:          ds     1
 START_NO:	  ds	 1
 counterpixel:	  ds	 1 
 counterpage:	  ds	 1
 rightleft:	  ds	 1
 
 ;===============================================================================
 ; Graphical LCD Control Routines
 ;-------------------------------------------------------------------------------
 
psect	lcd_code, class=CODE
 
 ; Initialises the I/O pins used to communicate with the graphics LCD module and
 ; tells it to reset.
 
 LcdOpen:
		 clrf	 LATB, A
		 movlw	 0b11000000
		 movwf	 TRISB, A
                 bcf     TRISB,LCD_RES, A    ; Set /RES lo and reset display 
                 bcf     LATB,LCD_RES, A   
 
                 bcf     LCD_CS1_TRIS,LCD_CS1, A   ; Set chip selects as outputs
                 bcf     LCD_CS2_TRIS,LCD_CS2, A
 
                 bcf     LCD_EN_TRIS,LCD_EN , A  ; Set control lines as outputs
                 bcf     LCD_R_W_TRIS,LCD_R_W, A
                 bcf     LCD_D_I_TRIS,LCD_D_I, A
                 bcf     LCD_EN_LAT,LCD_EN, A     ; Set EN = LO
 
                 bsf     LCD_RES_LAT,LCD_RES, A     ; Release from reset   
 
                 rcall   LcdSelectLeft
                 bra     LcdWait                 ; and wait until ready
 
 ; Instruct all the controller chips to turn thier displays on.
 
 LcdDisplayOn:
                 movlw   0b00111111
                 bra     LcdCtrlAll
 
 ; Instruct all the controller chips to turn thier displays off.
 
 LcdDisplayOff:
                 movlw   0b00111110
 
 ; Sends a command byte to all the display controllers.
 
 LcdCtrlAll:
                 bcf     LCD_CS1_LAT,LCD_CS1, A
                 bcf     LCD_CS2_LAT,LCD_CS2, A
 
 ; Sends the command byte in WREG to the currently selected controller chip
 
 LcdSendCtrl:
                 bcf     LCD_D_I_LAT,LCD_D_I, A     ; Set D/I = LO for commands
                 bra     DoOutput
 
 ; Sends the data byte in WREG to the currently selected controller chip
 
 LcdSendData:
                 bsf     LCD_D_I_LAT,LCD_D_I, A     ; Set D/I = HI for data
 DoOutput:       bcf     LCD_R_W_LAT,LCD_R_W, A     ; Set R/W = LO for output
                 clrf    TRISD, A           ; Set TRIS for output
                 movwf   LATD, A            ; .. and latch byte
                 nop
                 bsf     LCD_EN_LAT,LCD_EN , A      ; Then strobe EN
                 bra     $+2
                 bra     $+2
		 bra     $+2
                 bcf     LCD_EN_LAT,LCD_EN, A
 
                 btfss   LCD_D_I_LAT,LCD_D_I, A     ; If we were sending data
                 bra     LcdWait
                 incf    ROW_NO,W, A                ; Bump ROW tracker
                 andlw   0b00111111             ; .. and wrap round
                 movwf   ROW_NO, A
 
 ; Reads the status byte from the currently selected controller and waits
 ; for it to become zero.
 
 LcdWait:
                 rcall   LcdReadBusy             ; Read status byte and
                 andlw   0b10010000             ; .. mask irrelevant bits
                 bnz     LcdWait                 ; Until it becomes clear
                 return

 LcdReset:
		bcf     LCD_D_I_LAT,LCD_D_I, A 
		bcf     LCD_R_W_LAT,LCD_R_W, A
		bsf     LCD_EN_LAT,LCD_EN, A       ; Strobe EN
                bra     $+2
                bra     $+2
		bcf     TRISB,LCD_RES, A    ; Set /RES lo and reset display 
                bcf     LATB,LCD_RES, A  
		bcf     LCD_EN_LAT,LCD_EN, A
		return
 
 ; Reads the status byte from the active controller chip.
 
 LcdReadBusy:
                 bcf     LCD_D_I_LAT,LCD_D_I, A     ; Set D/I = LO for command
                 bra     DoInput
 
 ; Reads a data byte from the active controller chip
 
 LcdReadData:
                 bsf     LCD_D_I_LAT,LCD_D_I, A     ; Set D/I = HI for data
 DoInput:         bsf     LCD_R_W_LAT,LCD_R_W, A     ; Set R/W = HI for input
                 setf    LCD_DATA_TRIS, A           ; Set TRIS for input
                 nop
                 bsf     LCD_EN_LAT,LCD_EN, A       ; Strobe EN
                 bra     $+2
                 bra     $+2
		 bra     $+2
                 movf    PORTD,W , A        ; Read byte from display
                 bcf     LCD_EN_LAT,LCD_EN, A
                 return
 
 ; Sets the chip select lines so the left hand side of the screen is enabled
 
 LcdSelectLeft:
                 bcf     LCD_CS1_LAT,LCD_CS1, A
                 bsf     LCD_CS2_LAT,LCD_CS2, A
                 return
 
 ; Sets the chip select lines so the right hand side of the screen is enabled
 
 LcdSelectRight:
                 bsf     LCD_CS1_LAT,LCD_CS1, A
                 bcf     LCD_CS2_LAT,LCD_CS2, A
                 return
		 
LcdClear:
		 movlw	 0x02
		 movwf	 rightleft, A
		 movlw	 0x08
		 movwf	 counterpage, A
		 call    LcdSelectLeft
		 
loop1:		 movf    counterpage, W, A
		 call	 LcdSetPage
		 movlw	 0x40
		 movwf	 counterpixel, A
		 
		 
loop2:		 
		 movlw	 0x00
		 call	 LcdSendData
		 decfsz  counterpixel,F,A
		 bra	 loop2
		 decfsz  counterpage,F,A
		 bra	 loop1
		 bra	 loop3
		 
loop3:		 call    LcdSelectRight
		 movlw	 0x08
		 movwf	 counterpage, A
		 decfsz	 rightleft,F,A
		 bra	 loop1
		 return
		 
		 
		 
 
 ; Generates and sends a command to set the selected page 
 
 LcdSetPage:
                 andlw   0b00000111
                 movwf   PAGE_NO, A
                 iorlw   0b10111000
                 bra     LcdSendCtrl
 
 ; Generates and sends a command to set the selected row
 
 LcdSetRow:
                 andlw   0b00111111
                 movwf   ROW_NO, A
                 iorlw   0b01000000
                 bra     LcdSendCtrl

LcdSetStart:
                 andlw   0b00111111
                 movwf   START_NO, A
                 iorlw   0b11000000
                 bra     LcdSendCtrl
 
                 end


