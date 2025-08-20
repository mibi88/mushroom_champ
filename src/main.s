; NES accuracy tests.
;
; Copyright (c) 2025 Mibi88.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
; this list of conditions and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright notice,
; this list of conditions and the following disclaimer in the documentation
; and/or other materials provided with the distribution.
;
; 3. Neither the name of the copyright holder nor the names of its
; contributors may be used to endorse or promote products derived from this
; software without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.

.export MAIN

.segment "ZEROPAGE"

.segment "BSS"

.segment "TEXT"

.include "nmi.inc"
.include "shell.inc"

.proc MAIN
        LDA #$80
        STA $2000

        JSR PPU_INIT
        JSR LOAD_PALETTE

        LDA #%10000000
        STA ppu_ctrl
        LDA #%00011000
        STA ppu_mask

        JSR CLEAR

        LDA #<STR
        LDX #>STR

        JSR PUTS

    LOOP:
        ;
        JMP LOOP
.endproc

.proc LOAD_PALETTE
        LDX #$00
    LOOP:
        LDA PALETTE, X
        STA pal_buffer, X
        INX
        CPX #$20
        BNE LOOP

        LDA #01
        STA pal_update

        RTS
.endproc

PALETTE:
    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30

    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30
    .byte $1D, $00, $10, $30

STR:
    .asciiz "Hello, World!"
