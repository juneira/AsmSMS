org 0x0000

di

;;;; CONTANTS ;;;;
; Data Port
DATA_PORT equ 0beh
; Control Port
CONTROL_PORT equ 0bfh
; CRAM Base Address
CRAM_BASE_ADDRESS equ 0c0h
; VDP Register Base Address
VDP_REGISTER_BASE equ 080h

; number of colors
COLORS equ (color_end-color)
; number of registers
VDP_REGISTERS equ (vdp_registers_end-vdp_registers)


; initialize the program
call init_vdp_registers
call init_color

start:
  ld a, 50h
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

  init_color_loop:
    ld a, COLORS
    sub b

    ; set CRAM Address
    out (CONTROL_PORT), a
    ld a, CRAM_BASE_ADDRESS
    out (CONTROL_PORT), a

    ; set CRAM Data
    ld a, (hl)
    out (DATA_PORT), a

    inc hl

    djnz init_color_loop
  ret

;;;; DATA ;;;;

; COLOR CRAM
color:
  db 0b00110000
  db 0b00001100
  db 0b00000011
  db 0b00000111
  db 0b00000100
  db 0b00100100
  db 0b00101100
  db 0b00101101
  db 0b00101111
color_end:

; VDP Registers
vdp_registers:
  db 0b00000110 ; Mode Control No. 1                          | Enable Mode 4
  db 0b11001000 ; Mode Control No. 2                          | Enable Display * 240-line mode * Small Sprites
  db 0b11111111 ; Name Table Base Address                     | Table Base Address => 0x3700
  db 0b11111111 ; Color Table Base Address                    | Default value to Mode 4
  db 0b11111111 ; Pattern Generator Table Base Address        | Default value to SMS1 VDP
  db 0b11111111 ; Sprite Attribute Table Base Address         | Sprite Attribute Table Base Address => 0x3F00
  db 0b11111111 ; Sprite Pattern Generator Table Base Address | ????
  db 0b00000000 ; Overscan/Backdrop Color                     | Background - Color 0
  db 0b00000000 ; Background X Scroll                         | Without scroll on X axis
  db 0b00000000 ; Background Y Scroll                         | Without scroll on Y axis
  db 0b11111111 ; Line counter                                | ????
vdp_registers_end:
