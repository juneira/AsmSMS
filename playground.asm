org 0x0000

di

;;;; CONTANTS ;;;;
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
SNAKE_POS_X equ 10h
; Snake Pos Y axis
SNAKE_POS_Y equ 10h

; Snake Pos X Axis Address
SNAKE_POS_X_ADDRESS equ 0c000h
; Snake Pos Y Axis Address
SNAKE_POS_Y_ADDRESS equ 0c001h

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

  ld a, SNAKE_POS_X + 8h
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, SNAKE_POS_X + 10h
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
  add 8h
  ld b, a
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ld a, b
  add 8h
  ld b, a
  out (DATA_PORT), a
  ld a, 0h
  out (DATA_PORT), a

  ret

;;;; DATA ;;;;

; COLOR CRAM
color:
  db 0b00110000
  db 0b00001100
  db 0b11111111
  db 0b00000111
  db 0b00000100
  db 0b00100100
  db 0b00101100
  db 0b00101101
  db 0b00101111
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00110000
  db 0b00001100
  db 0b11111111
  db 0b00000111
  db 0b00000100
  db 0b00100100
  db 0b00101100
  db 0b00101101
  db 0b00101111
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
  db 0b00000000
color_end:

; VDP Registers
vdp_registers:
  db 0b00000110 ; Mode Control No. 1                          | Enable Mode 4
  db 0b11001000 ; Mode Control No. 2                          | Enable Display * 240-line mode * Small Sprites
  db 0b11111111 ; Name Table Base Address                     | Table Base Address => 0x3700
  db 0b11111111 ; Color Table Base Address                    | Default value to Mode 4
  db 0b11111111 ; Pattern Generator Table Base Address        | Default value to SMS1 VDP
  db 0b11111111 ; Sprite Attribute Table Base Address         | Sprite Attribute Table Base Address => 0x3F00
  db 0b11111011 ; Sprite Pattern Generator Table Base Address | Set Base Address of Tiles to Spits => 0x00
  db 0b00000000 ; Overscan/Backdrop Color                     | Background - Color 0
  db 0b00000000 ; Background X Scroll                         | Without scroll on X axis
  db 0b00000000 ; Background Y Scroll                         | Without scroll on Y axis
  db 0b11111111 ; Line counter                                | ????
vdp_registers_end:

tiles:
  ; snake
  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b00000000
  db 0b11111111
  db 0b00000000
  db 0b00000000

  ; gram
  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b00000000
  db 0b00000000
  db 0b00000000
tiles_end:
