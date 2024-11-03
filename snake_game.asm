org 0x0000

di

include "lib/constants.asm"

; initialize the program
call init_vdp_registers
call init_color

; load tiles
call load_tiles

; draw tilemap - background
call draw_tilemap

; draw sprites
call draw_sprites

; save x and y of sprite
ld hl, SNAKE_POS_X_ADDRESS
ld (hl), SNAKE_POS_X
ld hl, SNAKE_POS_Y_ADDRESS
ld (hl), SNAKE_POS_Y

start:
  call wait_v_sync
  call move_sprites
  jp start

include "lib/functions.asm"

include "lib/data.asm"
