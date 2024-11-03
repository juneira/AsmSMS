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

  ; draw sprites
  call draw_sprites

  ; save x and y of sprite
  ld hl, SNAKE_POS_X_ADDRESS
  ld (hl), SNAKE_POS_X
  ld hl, SNAKE_POS_Y_ADDRESS
  ld (hl), SNAKE_POS_Y

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

  ld a, SNAKE_POS_Y
  out (DATA_PORT), a
  out (DATA_PORT), a
  out (DATA_PORT), a

  ; Stop draw - 0xD0
  ld a, 0d0h
  out (DATA_PORT), a

  ; Axis X - 0x10
  ld a, SPRITE_BASE_X_ADDRESS_LO
  out (CONTROL_PORT), a
  ld a, SPRITE_BASE_X_ADDRESS_HI
  out (CONTROL_PORT), a

  ld a, SNAKE_POS_X
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, SNAKE_POS_X - 8h
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, SNAKE_POS_X - 10h
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ret

; function wait_v_sync
; wait while V != 0
wait_v_sync:
  wait_v_sync_loop:
    in a, (V_COUNTER_ADDRESS)
    ld b, a
    djnz wait_v_sync_loop
  ret

; function move_sprites
; move the snake (ptbr - lah ele 10mil vezes)
move_sprites:
  ; Axis X
  ld a, SPRITE_BASE_X_ADDRESS_LO
  out (CONTROL_PORT), a
  ld a, SPRITE_BASE_X_ADDRESS_HI
  out (CONTROL_PORT), a

  ; update Axis X
  ld hl, SNAKE_POS_X_ADDRESS
  ld a, (hl)
  add 1
  ld (hl), a

  ld b, a

  ld a, b
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, b
  sub 8h
  ld b, a
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, b
  sub 8h
  ld b, a
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ret
