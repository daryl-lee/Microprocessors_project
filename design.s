#include <xc.inc>
    
global	load_data_A, load_data_E, load_data_G , load_data_M, load_data_O, load_data_R, load_data_V, load_data_treetop, load_data_treebottom, load_data_dino
global	load_data_0, load_data_1, load_data_2, load_data_3, load_data_4, load_data_5, load_data_6 , load_data_7, load_data_8, load_data_9
    
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable_A:
	db	0b00000000, 0b01111100, 0b00010010, 0b00010010, 0b00010010, 0b00010010, 0b01111100, 0b00000000

myTable_E:
	db	0b00000000, 0b01111110, 0b01001010, 0b01001010, 0b01001010, 0b01001010, 0b01000010, 0b00000000

myTable_G:
	db	0b00000000, 0b01111110, 0b01000010, 0b01000010, 0b01010010, 0b01010010, 0b01110110, 0b00000000

myTable_M:
	db	0b00000000, 0b01111110, 0b00000100, 0b00001000, 0b00001000, 0b00000100, 0b01111110, 0b00000000

myTable_O:
	db	0b00000000, 0b00111100, 0b01000010, 0b01000010, 0b01000010, 0b01000010, 0b00111100, 0b00000000
	
myTable_R:
	db	0b00000000, 0b01111110, 0b00010010, 0b00010010, 0b00010010, 0b01110010, 0b01001100, 0b00000000
	
myTable_V:
	db	0b00000000, 0b00001110, 0b00110000, 0b01000000, 0b01000000, 0b00110000, 0b00001110, 0b00000000
	
myTable_treetop:
	db	0b00111000, 0b01100000, 0b01100010, 0b11111111, 0b11111111, 0b00001000, 0b10001000, 0b00001100

myTable_treebottom:
	db	0b00000000, 0b00000000, 0b00000100, 0b11111111, 0b11111111, 0b00000010, 0b00000011, 0b00000000
	
myTable_dino:
	db	0b00011000, 0b11110000, 0b01110000, 0b01110000, 0b11110000, 0b00111111, 0b00000101, 0b00000111
	
myTable_0:
	db	0b00000000, 0b01111100, 0b10000010, 0b10000010, 0b10000010, 0b10000010, 0b01111100, 0b00000000	
	
myTable_1:
	db	0b00000000, 0b10000000, 0b10000100, 0b11111110, 0b11111110, 0b10000000, 0b10000000, 0b00000000	
	
myTable_2:
	db	0b00000000, 0b11000100, 0b10100010, 0b10010010, 0b10010010, 0b10010010, 0b10001100, 0b00000000	
	
myTable_3:
	db	0b00000000, 0b01000100, 0b10010010, 0b10010010, 0b10010010, 0b10010010, 0b01101100, 0b00000000
	
myTable_4:
	db	0b00000000, 0b00001110, 0b00010000, 0b00010000, 0b00010000, 0b11111110, 0b00010000, 0b00000000	
	
myTable_5:
	db	0b00000000, 0b01001110, 0b10001010, 0b10001010, 0b10001010, 0b10001010, 0b01110010, 0b00000000	
	
myTable_6:
	db	0b00000000, 0b01111100, 0b10010010, 0b10010010, 0b10010010, 0b10010010, 0b01100100, 0b00000000	
	
myTable_7:
	db	0b00000000, 0b10000010, 0b01000010, 0b00100010, 0b00010010, 0b00001010, 0b00000110, 0b00000000
	
myTable_8:
	db	0b00000000, 0b01101100, 0b10010010, 0b10010010, 0b10010010, 0b10010010, 0b01101100, 0b00000000	
	
myTable_9:
	db	0b00000000, 0b01001100, 0b10010010, 0b10010010, 0b10010010, 0b10010010, 0b01111100, 0b00000000
	
	
			
	myTable_l   EQU	8	; length of data, this is myTable_L not "one"
	align	2
    
psect	design_code, class=CODE
	
	; ******* Main programme ****************************************
load_data_A: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_A)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_A)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_A)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_E: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_E)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_E)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_E)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop

load_data_G: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_G)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_G)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_G)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_M: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_M)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_M)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_M)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_O: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_O)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_O)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_O)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop

load_data_R: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_R)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_R)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_R)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop

load_data_V: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_V)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_V)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_V)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_treetop: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_treetop)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_treetop)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_treetop)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_treebottom: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_treebottom)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_treebottom)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_treebottom)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
		
load_data_dino: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_dino)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_dino)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_dino)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_0: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_0)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_0)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_0)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_1: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_1)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_1)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_1)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_2: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_2)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_2)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_2)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_3: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_3)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_3)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_3)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_4: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_4)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_4)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_4)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_5: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_5)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_5)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_5)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_6: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_6)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_6)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_6)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_7: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_7)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_7)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_7)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_8: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_8)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_8)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_8)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
load_data_9: 	lfsr	0, myArray	; Load FSR0 with address in RAM	
		movlw	low highword(myTable_9)	; address of data in PM
		movwf	TBLPTRU, A		; load upper bits to TBLPTRU
		movlw	high(myTable_9)	; address of data in PM
		movwf	TBLPTRH, A		; load high byte to TBLPTRH
		movlw	low(myTable_9)	; address of data in PM
		movwf	TBLPTRL, A		; load low byte to TBLPTRL
		movlw	myTable_l	; bytes to read
		movwf 	counter, A		; our counter register
		bra	loop
		
loop:		tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
		movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
		decfsz	counter, A		; count down to zero
		bra	loop		; keep going until finished
		
		movlw	myTable_l	; output message to UART
		lfsr	2, myArray
		return

		goto	$		; goto current line in code
		
		


