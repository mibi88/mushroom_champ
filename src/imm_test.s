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

; TODO: Clean all of this code up.

.include "imm_test.inc"
.include "shell.inc"
.include "std.inc"

.segment "TEXT"

DEFAULT_OP = $09 ; ORA #i

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
    .byte DEFAULT_OP
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

TITLE_STR:
    .asciiz "Imm. addr. opcode test"
TITLE_STR_END:

PAGE_STR:
    .asciiz "SELECT to change page"
PAGE_STR_END:

COLUMN_STR:
    .asciiz ": "

.segment "ZEROPAGE"

.segment "BSS"

register:   .res 1

vars:
in_a:       .res 1
in_x:       .res 1
in_y:       .res 1
in_p:       .res 1
opcode:     .res 1

out_vars:
out_a:      .res 1
out_x:      .res 1
out_y:      .res 1
out_p:      .res 1

tmp:        .res 1

tmp_x:      .res 1
tmp_y:      .res 1

start:      .res 1

code:       .res (BASE_CODE_END-BASE_CODE)

num_buffer: .res 3

cur:        .res 1

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

        LDA #DEFAULT_OP
        STA opcode

        RTS
.endproc

VAR_NUM = 5

VAR_LETTERS:
    .byte 'A'
    .byte 'X'
    .byte 'Y'
    .byte 'P'
    .byte 'O'

.macro imm_test_draw_cur top_char, bottom_char
        LDA cur
        ; Leave 1 tile empty between two numbers.
        LSR
        CLC
        ADC cur
        CLC
        ADC #$02
        STA tmp

        TAX
        LDA #$04
        JSR MOVE
        LDA #top_char
        JSR PUTC

        LDX tmp
        LDA #$07
        JSR MOVE
        LDA #bottom_char
        JSR PUTC
.endmacro

.proc IMM_TEST_DRAW
        LDX #(16-(TITLE_STR_END-TITLE_STR)/2)
        LDA #$02
        JSR MOVE

        LDX #>TITLE_STR
        LDA #<TITLE_STR
        JSR PUTS

        LDX #(16-(PAGE_STR_END-PAGE_STR)/2)
        LDA #(30-3)
        JSR MOVE

        LDX #>PAGE_STR
        LDA #<PAGE_STR
        JSR PUTS

        ; Show the variables etc.

        imm_test_draw_cur 'v', '^'

        LDX #$00
        LDA #$02
        STA tmp
    LOOP:
        STX tmp_x

        LDX tmp
        LDA #$05
        JSR MOVE

        LDX tmp_x
        LDA VAR_LETTERS, X
        JSR PUTC

        LDX tmp_x
        LDA vars, X
        LDX #>num_buffer
        LDY #<num_buffer
        JSR HTOA

        LDX tmp
        LDA #$06
        JSR MOVE

        LDX #>num_buffer
        LDA #<num_buffer
        JSR PUTS

        LDA tmp
        CLC
        ADC #$03
        STA tmp

        LDX tmp_x

        INX
        CPX #VAR_NUM
        BNE LOOP

        ; Print the selected register
        LDA tmp
        TAX
        LDA #$06
        JSR MOVE

        LDX register
        LDA VAR_LETTERS, X
        JSR PUTC

        RTS
.endproc

.proc IMM_TEST_INPUT
        LDA ctrl1
        LDX #$10

    LOOP:
        LSR
        BCC CONTINUE

        PHA
        TXA
        PHA

        LDA IMM_TEST_INPUT_LUT-2, X
        STA ptr
        LDA IMM_TEST_INPUT_LUT-1, X
        STA ptr+1
        JSR CALL

        PLA
        TAX
        PLA
    CONTINUE:

        DEX
        DEX
        BNE LOOP

        RTS

    CALL:
        JMP (ptr)
.endproc

.proc IMM_TEST_LEFT
        LDX cur
        BEQ SKIP

        imm_test_draw_cur ' ', ' '

        LDX cur
        DEX
        STX cur

        JSR IMM_TEST_DRAW

    SKIP:
        RTS
.endproc

.proc IMM_TEST_RIGHT
        LDX cur
        CPX #(VAR_NUM*2)
        BEQ SKIP

        imm_test_draw_cur ' ', ' '

        LDX cur
        INX
        STX cur

        JSR IMM_TEST_DRAW

    SKIP:
        RTS
.endproc

.proc IMM_TEST_UP
        LDA cur
        CMP #(VAR_NUM*2)
        BNE NUM

    REGISTER:
        LDX register
        CPX #(VAR_NUM-2) ; O is not a register
        BEQ REGISTER_LOOP
        INX
        STX register
        JMP DONE

    REGISTER_LOOP:
        LDA #$00
        STA register
        BEQ DONE ; A is 0 so I can use BEQ instead of JMP

    NUM:
        LSR
        TAX

        LDA cur
        AND #$01
        BNE ADD_1

        LDA vars, X
        CLC
        ADC #$10
        STA vars, X

        JMP DONE

    ADD_1:
        LDY vars, X
        INY
        TYA
        STA vars, X

    DONE:
        JSR IMM_TEST_DRAW

        RTS
.endproc

.proc IMM_TEST_DOWN
        LDA cur
        CMP #(VAR_NUM*2)
        BNE NUM

    REGISTER:
        LDX register
        BEQ REGISTER_LOOP
        DEX
        STX register
        JMP DONE

    REGISTER_LOOP:
        LDA #(VAR_NUM-2) ; O is not a register
        STA register
        JMP DONE

    NUM:
        LSR
        TAX

        LDA cur
        AND #$01
        BNE ADD_1

        LDA vars, X
        SEC
        SBC #$10
        STA vars, X

        JMP DONE

    ADD_1:
        LDY vars, X
        DEY
        TYA
        STA vars, X

    DONE:
        JSR IMM_TEST_DRAW

        RTS
.endproc

.proc IMM_TEST_NONE
        ;

        RTS
.endproc

.proc IMM_TEST_SELECT
        LDA start
        EOR #$80
        STA start
        JSR IMM_TEST_RUN

        RTS
.endproc

.proc IMM_TEST_A
        JSR IMM_TEST_RUN

        RTS
.endproc

IMM_TEST_INPUT_LUT:
    .word IMM_TEST_A
    .word IMM_TEST_NONE
    .word IMM_TEST_SELECT
    .word IMM_TEST_NONE
    .word IMM_TEST_UP
    .word IMM_TEST_DOWN
    .word IMM_TEST_LEFT
    .word IMM_TEST_RIGHT

.proc IMM_TEST_MAINLOOP

    LOOP:
        JSR READCTRL1

        JSR IMM_TEST_INPUT

.if 0   ; Do not allow exiting this test for now as it is the only test.
        ; Exit the test when start is pressed
        LDA ctrl1
        AND #(1<<4)
        BNE LOOP
.else
        JMP LOOP
.endif

        RTS
.endproc

.proc IMM_TEST_RUN
        LDA opcode
        STA code+(BASE_CODE_OPCODE-BASE_CODE)

        LDX start
        LDY #$08
        STY tmp_y

    LOOP:
        STX tmp_x
        TXA

        AND #$07
        BNE SKIP_LABEL_PRINT

        ; Display a label

        TXA
        LDY #<num_buffer
        LDX #>num_buffer
        JSR HTOA

        LDA tmp_y
        LDX #$02
        JSR MOVE

        INC tmp_y

        LDA #<num_buffer
        LDX #>num_buffer
        JSR PUTS

        LDA #<COLUMN_STR
        LDX #>COLUMN_STR
        JSR PUTS

        LDX tmp_x

    SKIP_LABEL_PRINT:

        STX code+(BASE_CODE_OPERAND-BASE_CODE)
        JSR code

        ; Display the results

        LDX register
        LDA out_vars, X
        LDY #<num_buffer
        LDX #>num_buffer
        JSR HTOA

        LDA #<num_buffer
        LDX #>num_buffer
        JSR PUTS

        LDA #' '
        JSR PUTC

        LDX tmp_x

        INX
        BEQ DONE
        CPX #$80
        BNE LOOP

    DONE:
        RTS
.endproc
