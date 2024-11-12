org 0x0000

di

include "lib/constants.asm"

call init_game

start:
  call wait_v_sync
  call move_sprites
  call check_apple
  jp start

include "lib/functions.asm"

include "lib/data.asm"
