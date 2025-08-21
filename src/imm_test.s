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

.include "imm_test.inc"
.include "shell.inc"
.include "std.inc"

.segment "ZEROPAGE"

.segment "BSS"

in_a:       .res 1
in_x:       .res 1
in_y:       .res 1
in_p:       .res 1

out_a:      .res 1
out_x:      .res 1
out_y:      .res 1
out_p:      .res 1

tmp:        .res 1

;code:      .res (BASE_CODE_END-BASE_CODE)
code:       .res 256 ; It should be fine for now

num_buffer: .res 3

.segment "TEXT"

; TODO: Maybe also allow choosing the stack pointer

.proc IMM_TEST_INIT

        ; Copy the code
        LDX #$00
    LOOP:
        LDA BASE_CODE, X
        STA code, X
        INX
        CPX #(BASE_CODE_END-BASE_CODE)
        BNE LOOP

        LDA #$00
        STA in_a
        STA in_x
        STA in_y
        STA in_p

        RTS
.endproc

.proc IMM_TEST_SHOW
        LDX #$00
        LDY #$00

    LOOP:
        TXA

        AND #$07
        BNE SKIP_LABEL_PRINT

        ; Display a label
        TXA
        PHA

        LDY #<num_buffer
        LDX #>num_buffer
        JSR HTOA

        LDA #<num_buffer
        LDX #>num_buffer
        JSR PUTS

        LDA #<COLUMN_STR
        LDX #>COLUMN_STR
        JSR PUTS

        PLA
        TAX

    SKIP_LABEL_PRINT:

        STX code+(BASE_CODE_OPERAND-BASE_CODE)
        JSR code

        ; Display the results
        TXA
        PHA

        ; TODO: Also allow showing X, Y, etc.
        LDA out_a
        LDY #<num_buffer
        LDX #>num_buffer
        JSR HTOA

        LDA #<num_buffer
        LDX #>num_buffer
        JSR PUTS

        LDA #' '
        JSR PUTC

        PLA
        TAX

        INX
        BNE LOOP

        RTS
.endproc

BASE_CODE:
    PHA
    TXA
    PHA
    TYA
    PHA

    LDX in_x
    LDY in_y
    LDA in_p
    PHA
    LDA in_a
    PLP
BASE_CODE_OPCODE:
    .byte $09 ; ORA #i
BASE_CODE_OPERAND:
    .byte $00
    PHP
    STA out_a
    PLA
    STA out_p
    STX out_x
    STY out_y

    PLA
    TAY
    PLA
    TAX
    PLA

    RTS
BASE_CODE_END:

COLUMN_STR:
    .asciiz ": "
