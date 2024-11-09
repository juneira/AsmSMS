; Color - CRAM
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

  ; apple
  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000

  db 0b11111111
  db 0b11111111
  db 0b00000000
  db 0b00000000
tiles_end:
