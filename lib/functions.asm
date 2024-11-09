; function init_game
; initialize the game
init_game:
  ; initialize the program
  call init_vdp_registers
  call init_color

  ; load tiles
  call load_tiles

  ; draw tilemap - background
  call draw_tilemap

  ; save initial position of snake
  call start_snake

  call create_apple

  ret

; function init_vdp_registers
; initialize VDP Registers
init_vdp_registers:
  ld hl, vdp_registers
  ld b, VDP_REGISTERS

  init_vdp_registers_loop:
    ; set VDP Register Address
    ld a, (hl)
    out (CONTROL_PORT), a
    inc hl

    ; set VDP Register Value
    ld a, VDP_REGISTERS
    sub b
    add VDP_REGISTER_BASE
    out (CONTROL_PORT), a

    djnz init_vdp_registers_loop

; function init_color
; initialize CRAM
init_color:
  ld hl, color
  ld b, COLORS

  ; set CRAM Address
  ld a, 0h
  out (CONTROL_PORT), a
  ld a, CRAM_BASE_ADDRESS
  out (CONTROL_PORT), a

  init_color_loop:
    ; set CRAM Data
    ld a, (hl)
    out (DATA_PORT), a

    inc hl

    djnz init_color_loop
  ret

; function load_tiles
; load tiles to VDP Ram
load_tiles:
  ld hl, tiles
  ld b, TILES

  ; set CRAM Address
  ld a, 0h
  out (CONTROL_PORT), a
  ld a, VRAM_BASE_ADDRESS
  out (CONTROL_PORT), a

  load_tiles_loop:
    ; set CRAM Data
    ld a, (hl)
    out (DATA_PORT), a

    inc hl

    djnz load_tiles_loop
  ret

; function draw_tilemap
; draw tilemap (background)
draw_tilemap:
  ; set VRAM Address
  ld a, 0h
  out (CONTROL_PORT), a
  ld a, TILEMAP_BASE_ADDRESS
  out (CONTROL_PORT), a

  ld b, TILEMAPS_Y

  ; start loop y
  draw_tilemap_loop_y:
    exx
    ld b, TILEMAPS_X

    ; start loop x
    draw_tilemap_loop_x:
      ; set VRAM Data
      ld a, 1h
      out (DATA_PORT), a
      ld a, 0b
      out (DATA_PORT), a

      djnz draw_tilemap_loop_x
    exx

    djnz draw_tilemap_loop_y
  ret

; function draw_sprites
; draw the snake on initial position
draw_sprites:
  ; Axis Y
  ld a, 0
  out (CONTROL_PORT), a
  ld a, SPRITE_BASE_Y_ADDRESS
  out (CONTROL_PORT), a

  ; draw apple
  ld a, (APPLE_Y_ADDRESS)
  out (DATA_PORT), a

  ld b, SNAKE_SIZE
  ld hl, SNAKE_POS_Y_ADDRESS

  draw_sprites_y_loop:
    ld a, (hl)
    out (DATA_PORT), a
    inc hl

    djnz draw_sprites_y_loop

  ; Stop draw - 0xD0
  ld a, 0d0h
  out (DATA_PORT), a

  ; Axis X
  ld a, SPRITE_BASE_X_ADDRESS_LO
  out (CONTROL_PORT), a
  ld a, SPRITE_BASE_X_ADDRESS_HI
  out (CONTROL_PORT), a

  ; draw apple
  ld a, (APPLE_X_ADDRESS)
  out (DATA_PORT), a
  ld a, 2
  out (DATA_PORT), a

  ld b, SNAKE_SIZE
  ld hl, SNAKE_POS_X_ADDRESS

  draw_sprites_x_loop:
    ld a, (hl)
    out (DATA_PORT), a
    ld a, 0
    out (DATA_PORT), a
    inc hl

    djnz draw_sprites_x_loop

  ret

; function wait_v_sync
; wait while V != 0
wait_v_sync:
  ld b, 30

  wait_v_sync_loop:
    in a, (V_COUNTER_ADDRESS)
    or a
    jp nz, wait_v_sync_loop

  djnz wait_v_sync_loop

  ret

; function move_sprites
; move the snake
move_sprites:
  call draw_sprites
  call set_last_move
  call move_snake

  ret

; function start_snake
; save positions of snake to RAM and set move to right as default
start_snake:
  ld hl, SNAKE_POS_X_ADDRESS
  ld (hl), SNAKE_POS_X
  ld hl, SNAKE_POS_Y_ADDRESS
  ld (hl), SNAKE_POS_Y

  ld hl, SNAKE_POS_X_ADDRESS + 1
  ld (hl), SNAKE_POS_X - SNAKE_BODY_SIZE_PX
  ld hl, SNAKE_POS_Y_ADDRESS + 1
  ld (hl), SNAKE_POS_Y

  ld hl, SNAKE_POS_X_ADDRESS + 2
  ld (hl), SNAKE_POS_X - (2*SNAKE_BODY_SIZE_PX)
  ld hl, SNAKE_POS_Y_ADDRESS + 2
  ld (hl), SNAKE_POS_Y

  ld hl, LAST_MOVE_ADDRESS
  ld (hl), 0f7h

  ret

; function set_last_move
; saves the last move
set_last_move:
  in a, (CONTROLLER_PORT)
  ld b, a
  xor 0ffh

  jp z, set_last_move_end

  ld hl, LAST_MOVE_ADDRESS
  ld (hl), b

  set_last_move_end:
  ret

; function move_snake
; moves the snake on X and Y Axis
move_snake:
  ld hl, LAST_MOVE_ADDRESS
  ld a, (hl)

  bit 0, a
  jp z, move_snake_ny

  ; in a, (0dch)
  bit 1, a
  jp z, move_snake_y

  ; in a, (0dch)
  bit 2, a
  jp z, move_snake_nx

  ; in a, (0dch)
  bit 3, a
  jp z, move_snake_x

  mov_snake_end:
  ret

; function move_snake_x
; moves snake on X Axis
move_snake_x:
  call move_snake_body

  ld hl, SNAKE_POS_X_ADDRESS
  ld a, (hl)
  add SNAKE_BODY_SIZE_PX
  ld (hl), a

  jp mov_snake_end

; function move_snake_nx
; moves snake on -X Axis
move_snake_nx:
  call move_snake_body

  ld hl, SNAKE_POS_X_ADDRESS
  ld a, (hl)
  sub SNAKE_BODY_SIZE_PX
  ld (hl), a

  jp mov_snake_end

; function move_snake_y
; moves snake on Y Axis
move_snake_y:
  call move_snake_body

  ld hl, SNAKE_POS_Y_ADDRESS
  ld a, (hl)
  add SNAKE_BODY_SIZE_PX
  ld (hl), a

  jp mov_snake_end

; function move_snake_ny
; moves snake on -Y Axis
move_snake_ny:
  call move_snake_body

  ld hl, SNAKE_POS_Y_ADDRESS
  ld a, (hl)
  sub SNAKE_BODY_SIZE_PX
  ld (hl), a

  jp mov_snake_end

; function move_snake_body
; move the body of snake
move_snake_body:
  ; copy X
  ld b, SNAKE_SIZE-1
  ld hl, SNAKE_POS_X_ADDRESS

  ld a, (hl)
  ld c, a

  move_snake_body_x_loop:
    inc hl

    ld a, (hl)
    ld d, a

    ld a, c
    ld (hl), a

    ld c, d

    djnz move_snake_body_x_loop

  ; copy Y
  ld b, SNAKE_SIZE-1
  ld hl, SNAKE_POS_Y_ADDRESS

  ld a, (hl)
  ld c, a

  move_snake_body_y_loop:
    inc hl

    ld a, (hl)
    ld d, a

    ld a, c
    ld (hl), a

    ld c, d

    djnz move_snake_body_y_loop
  ret

; function create_apple
; generates a apple on map
create_apple:
  ld b, 0b0h
  call random
  ld (APPLE_X_ADDRESS), a

  ld b, 098h
  call random
  ld (APPLE_Y_ADDRESS), a

  ret

; function random
; generates a random number to register A
random:
  push hl
  push de
  ld hl, (RAND_ADDRESS)
  ld a, r
  ld d, a
  ld e, (hl)
  add hl, de
  add a, l
  xor h
  ld (RAND_ADDRESS), hl
  pop de
  pop hl

  cp b

  jp c, random_end
  ld a, b
  random_end:
  ret
