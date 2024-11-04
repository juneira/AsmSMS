; Data Port
DATA_PORT equ 0beh
; Control Port
CONTROL_PORT equ 0bfh
; V Counter Address
V_COUNTER_ADDRESS equ 07eh
; CRAM Base Address
CRAM_BASE_ADDRESS equ 0c0h
; VDP Register Base Address
VDP_REGISTER_BASE equ 080h
; VRAM Base Address
VRAM_BASE_ADDRESS equ 040h
; TileMap Base Address
TILEMAP_BASE_ADDRESS equ 078h
; Sprite Base Y Address
SPRITE_BASE_Y_ADDRESS equ 07fh
; Sprite Base X Address
SPRITE_BASE_X_ADDRESS_HI equ 07fh
SPRITE_BASE_X_ADDRESS_LO equ 080h

; number of colors
COLORS equ (color_end-color)
; number of registers
VDP_REGISTERS equ (vdp_registers_end-vdp_registers)
; number of tiles
TILES equ (tiles_end-tiles)
; number of tilemaps on X axis
TILEMAPS_X equ 32
; number of tilemaps on Y axis
TILEMAPS_Y equ 32

; Snake Pos X axis
SNAKE_POS_X equ 20h
; Snake Pos Y axis
SNAKE_POS_Y equ 10h

; Snake Pos X Axis Address
SNAKE_POS_X_ADDRESS equ 0c000h
; Snake Pos Y Axis Address
SNAKE_POS_Y_ADDRESS equ 0c010h

; Snake Size
SNAKE_SIZE equ 3

; Snake Body Size in PX
SNAKE_BODY_SIZE_PX equ 8h
