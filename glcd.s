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
 
LCD_RES_TRIS    equ     TRISB           ; /RES        
 LCD_RES_LAT     equ     LATB
 LCD_RES         equ     .0
 
 LCD_CS1_TRIS    equ     TRISB           ; /CS1
 LCD_CS1_LAT     equ     LATB
 LCD_CS1         equ     .1
 
 LCD_CS2_TRIS    equ     TRISB           ; /CS2
 LCD_CS2_LAT     equ     LATB
 LCD_CS2         equ     .6
 
 LCD_R_W_TRIS    equ     TRISB           ; R/W
 LCD_R_W_LAT     equ     LATB
 LCD_R_W         equ     .3
 
 LCD_D_I_TRIS    equ     TRISB           ; D/I
 LCD_D_I_LAT     equ     LATB
 LCD_D_I         equ     .4
 
 LCD_EN_TRIS     equ     TRISB           ; EN
 LCD_EN_LAT      equ     LATB
 LCD_EN          equ     .5
 
 LCD_LED_TRIS    equ     TRISB           ; LED+
 LCD_LED_LAT     equ     LATB
 LCD_LED         equ     .7
 
 LCD_DATA_TRIS   equ     TRISD           ; D0-D7
 LCD_DATA_PORT   equ     PORTD
 LCD_DATA_LAT    equ     LATD		 
 ;===============================================================================
 ; Data Areas
 ;-------------------------------------------------------------------------------
 
 psect	udata_acs 
 
 PAGE_NO         res     .1
 ROW_NO          res     .1
 
 ;===============================================================================
 ; Graphical LCD Control Routines
 ;-------------------------------------------------------------------------------
 
 .LcdDriver      code
 
 ; Initialises the I/O pins used to communicate with the graphics LCD module and
 ; tells it to reset.
 
 LcdOpen:
                 bcf     LCD_RES_TRIS,LCD_RES    ; Set /RES lo and reset display 
                 bcf     LCD_RES_LAT,LCD_RES     
 
                 bcf     LCD_CS1_TRIS,LCD_CS1    ; Set chip selects as outputs
                 bcf     LCD_CS2_TRIS,LCD_CS2
 
                 bcf     LCD_EN_TRIS,LCD_EN      ; Set control lines as outputs
                 bcf     LCD_R_W_TRIS,LCD_R_W 
                 bcf     LCD_D_I_TRIS,LCD_D_I
                 bcf     LCD_EN_LAT,LCD_EN       ; Set EN = LO
 
                 bsf     LCD_RES_LAT,LCD_RES     ; Release from reset   
 
                 rcall   LcdSelectLeft
                 bra     LcdWait                 ; and wait until ready
 
 ; Instruct all the controller chips to turn thier displays on.
 
 LcdDisplayOn:
                 movlw   b'00111111'
                 bra     LcdCtrlAll
 
 ; Instruct all the controller chips to turn thier displays off.
 
 LcdDisplayOff:
                 movlw   b'00111110'
 
 ; Sends a command byte to all the display controllers.
 
 LcdCtrlAll:
                 bcf     LCD_CS1_LAT,LCD_CS1
                 bcf     LCD_CS2_LAT,LCD_CS2
 
 ; Sends the command byte in WREG to the currently selected controller chip
 
 LcdSendCtrl:
                 bcf     LCD_D_I_LAT,LCD_D_I     ; Set D/I = LO for commands
                 bra     DoOutput
 
 ; Sends the data byte in WREG to the currently selected controller chip
 
 LcdSendData:
                 bsf     LCD_D_I_LAT,LCD_D_I     ; Set D/I = HI for data
 DoOutput        bcf     LCD_R_W_LAT,LCD_R_W     ; Set R/W = LO for output
                 clrf    LCD_DATA_TRIS           ; Set TRIS for output
                 movwf   LCD_DATA_LAT            ; .. and latch byte
                 nop
                 bsf     LCD_EN_LAT,LCD_EN       ; Then strobe EN
                 bra     $+.2
                 bra     $+.2
                 bcf     LCD_EN_LAT,LCD_EN
 
                 btfss   LCD_D_I_LAT,LCD_D_I     ; If we were sending data
                 bra     LcdWait
                 incf    ROW_NO,W                ; Bump ROW tracker
                 andlw   b'00111111'             ; .. and wrap round
                 movwf   ROW_NO
 
 ; Reads the status byte from the currently selected controller and waits
 ; for it to become zero.
 
 LcdWait:
                 rcall   LcdReadBusy             ; Read status byte and
                 andlw   b'10010000'             ; .. mask irrelevant bits
                 bnz     LcdWait                 ; Until it becomes clear
                 return
 
 ; Reads the status byte from the active controller chip.
 
 LcdReadBusy:
                 bcf     LCD_D_I_LAT,LCD_D_I     ; Set D/I = LO for command
                 bra     DoInput
 
 ; Reads a data byte from the active controller chip
 
 LcdReadData:
                 bsf     LCD_D_I_LAT,LCD_D_I     ; Set D/I = HI for data
 DoInput         bsf     LCD_R_W_LAT,LCD_R_W     ; Set R/W = HI for input
                 setf    LCD_DATA_TRIS           ; Set TRIS for input
                 nop
                 bsf     LCD_EN_LAT,LCD_EN       ; Strobe EN
                 bra     $+.2
                 bra     $+.2
                 movf    LCD_DATA_PORT,W         ; Read byte from display
                 bcf     LCD_EN_LAT,LCD_EN
                 return
 
 ; Sets the chip select lines so the left hand side of the screen is enabled
 
 LcdSelectLeft:
                 bcf     LCD_CS1_LAT,LCD_CS1
                 bsf     LCD_CS2_LAT,LCD_CS2
                 return
 
 ; Sets the chip select lines so the right hand side of the screen is enabled
 
 LcdSelectRight:
                 bsf     LCD_CS1_LAT,LCD_CS1
                 bcf     LCD_CS2_LAT,LCD_CS2
                 return
 
 ; Generates and sends a command to set the selected page 
 
 LcdSetPage:
                 andlw   b'00000111'
                 movwf   PAGE_NO
                 iorlw   b'10111000'
                 bra     LcdSendCtrl
 
 ; Generates and sends a command to set the selected row
 
 LcdSetRow:
                 andlw   b'00111111'
                 movwf   ROW_NO
                 iorlw   b'01000000'
                 bra     LcdSendCtrl
 
                 end


