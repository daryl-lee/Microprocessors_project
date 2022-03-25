#include <xc.inc>
extrn		set_y, make_sprite_x
extrn		load_data_A, load_data_E, load_data_G , load_data_M, load_data_O, load_data_R, load_data_V, load_data_P, load_data_S, load_data_U, load_data_D
extrn		load_data_B, load_data_L, load_data_Y, load_data_I, load_data_H
extrn		load_data_pause, load_data_colon, load_data_dino
extrn		load_data_1, load_data_2, load_data_3
global		start_menu, end_menu, pause_menu, difficulty_menu    
    
psect	menu_code, class=CODE    
start_menu:
    movlw	0x02
    call	set_y
    call	load_data_O
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_colon
    movlw	0x32
    call	make_sprite_x
    

    call	load_data_P
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_L
    movlw	0x4a
    call	make_sprite_x
    
    call	load_data_A
    movlw	0x52
    call	make_sprite_x
    
    call	load_data_Y
    movlw	0x5a
    call	make_sprite_x
    
    movlw	0x04
    call	set_y
    call	load_data_B
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_colon
    movlw	0x32
    call	make_sprite_x
    

    call	load_data_P
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_A
    movlw	0x4a
    call	make_sprite_x
    
    call	load_data_U
    movlw	0x52
    call	make_sprite_x
    
    call	load_data_S
    movlw	0x5a
    call	make_sprite_x
    
    call	load_data_E
    movlw	0x62
    call	make_sprite_x
 
    movlw	0x07
    call	set_y
    call	load_data_dino
    movlw	0x05
    call	make_sprite_x
    
    return
    
difficulty_menu:
    movlw	0x01
    call	set_y
    call	load_data_1
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_colon
    movlw	0x32
    call	make_sprite_x
    

    call	load_data_E
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_A
    movlw	0x4a
    call	make_sprite_x
    
    call	load_data_S
    movlw	0x52
    call	make_sprite_x
    
    call	load_data_Y
    movlw	0x5a
    call	make_sprite_x
    
    
    movlw	0x03
    call	set_y
    call	load_data_2
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_colon
    movlw	0x32
    call	make_sprite_x
    

    call	load_data_M
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_E
    movlw	0x4a
    call	make_sprite_x
    
    call	load_data_D
    movlw	0x52
    call	make_sprite_x
    
    call	load_data_I
    movlw	0x5a
    call	make_sprite_x
    
    call	load_data_U
    movlw	0x62
    call	make_sprite_x
    
    call	load_data_M
    movlw	0x6a
    call	make_sprite_x
    
    
    movlw	0x05
    call	set_y
    call	load_data_3
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_colon
    movlw	0x32
    call	make_sprite_x
    

    call	load_data_H
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_A
    movlw	0x4a
    call	make_sprite_x
    
    call	load_data_R
    movlw	0x52
    call	make_sprite_x
    
    call	load_data_D
    movlw	0x5a
    call	make_sprite_x
    
    return
    
pause_menu:
    movlw	0x03
    call	set_y
    call	load_data_P
    movlw	0x22
    call	make_sprite_x
    
    call	load_data_A
    movlw	0x2a
    call	make_sprite_x
    
    call	load_data_U
    movlw	0x32
    call	make_sprite_x
    
    call	load_data_S
    movlw	0x3a
    call	make_sprite_x
    
    call	load_data_E
    movlw	0x42
    call	make_sprite_x
    
    call	load_data_D
    movlw	0x4a
    call	make_sprite_x
    
    
    call	load_data_pause
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


end