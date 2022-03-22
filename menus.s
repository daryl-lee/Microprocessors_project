#include <xc.inc>
extrn		set_y, make_sprite_x
extrn		load_data_A, load_data_E, load_data_G , load_data_M, load_data_O, load_data_R, load_data_V, load_data_P, load_data_S
global		start_menu, end_menu    
    
psect	menu_code, class=CODE    
start_menu:
    movlw	0x03
    call	set_y
    call	load_data_P
    movlw	0x1a
    call	make_sprite_x

    call	load_data_R
    movlw	0x22
    call	make_sprite_x

    call	load_data_E
    movlw	0x2a
    call	make_sprite_x

    call	load_data_S
    movlw	0x32
    call	make_sprite_x

    call	load_data_S
    movlw	0x3a
    call	make_sprite_x

    call	load_data_O
    movlw	0x5a
    call	make_sprite_x
    
    return
    
end_menu:
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

    return


