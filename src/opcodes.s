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

.include "opcodes.inc"

.segment "TEXT"

ADDRESSING_MODES:
    ; 0x00 to 0x0F
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ACCUMULATOR
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0x10 to 0x1F
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0x20 to 0x2F
    .byte ABSOLUTE
    .byte INDEXED_INDIRECT
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ACCUMULATOR
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0x30 to 0x3F
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0x40 to 0x4F
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ACCUMULATOR
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0x50 to 0x5F
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0x60 to 0x6F
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte IMPLIED
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ACCUMULATOR
    .byte IMMEDIATE
    .byte ABSOLUTE_INDIRECT
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0x70 to 0x7F
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0x80 to 0x8F
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0x90 to 0x9F
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0xA0 to 0xAF
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0xB0 to 0xBF
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0xC0 to 0xCF
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0xD0 to 0xDF
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    ; 0xE0 to 0xEF
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte IMMEDIATE
    .byte INDEXED_INDIRECT
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte ZERO_PAGE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte IMPLIED
    .byte IMMEDIATE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    .byte ABSOLUTE
    ; 0xF0 to 0xFF
    .byte RELATIVE
    .byte INDIRECT_INDEXED
    .byte IMPLIED
    .byte INDIRECT_INDEXED
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte INDEXED_ZERO_PAGE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte IMPLIED
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
    .byte INDEXED_ABSOLUTE
