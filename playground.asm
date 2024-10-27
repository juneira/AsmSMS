org 0x0000

di

; contants

; number of colors
COLORS equ (color_end-color)

; initialize the program
call init_color

start:
  ld a, 50h
  jp start

; function init_color
; initialize CRAM
init_color:
  ld hl, color
  ld b, COLORS

  init_color_loop:
    ld a, COLORS
    sub b

    ; set CRAM Address
    out (0bfh), a
    ld a, 0c0h
    out (0bfh), a

    ; set CRAM Data
    ld a, (hl)
    out (0beh), a

    inc hl

    djnz init_color_loop
  ret

; COLOR CRAM
color:
  db 0b00110000
  db 0b00001100
  db 0b00000011
  db 0b00000111
color_end:
