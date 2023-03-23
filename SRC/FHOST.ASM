* FujiNet FHOST set host slot

        icl '_SYSEQU.ICL'
        icl '_FNEQU.ICL'

        blk dos $3000
        jsr _chksdos
*  parse parameter
        jsr _lbinit
        jsr _lbtrim
*  check for slot number
        cmp #'1'
        bcc badpara
        cmp #'9'
        bcs badpara
        jsr getnum
        sta hmntslt
        txa
        pha
* read host slots
        jsr _print
        dta b($9b),c'read host slots',b($9b,$00)
        ldx <siorslt
        ldy >siorslt
        jsr _dosio
* get host name
        pla
        tax
        lda hmntslt
        asl @
        asl @
        asl @
        asl @
        asl @
        tay
        sty sltoff+1
        clc
        adc #fn_hslt_ln-1
        sta cmp_y+1
        jsr _lbtrim
nxtchar cmp #$9b
        beq padslt
cmp_y   cpy #00
        bcs truncr
        sta hslts,Y
        iny
        jsr _lbget
        jmp nxtchar

* truncated record, host name too long
truncr  ldy #$89
        jmp _fail

* parameter error
badpara jsr prnDocu
        ldy #$9C ; Bad Parameter
        jmp _fail

prnDocu jsr _print
        dta b($9b),c'Usage: FHOST slot [address]',b($9b)
        dta c'Version: 21-03-23',b($9b)
        dta b($9b),c'Sets host slot to address.',b($9b,$00)
        rts

* get number ATASCII 1..8 => HEX 0..7
getnum  and #$0F
        sec
        sbc #$01
        rts

* write host slots and mount slot
* pad wirh zero
padslt  lda #$00
        sta hslts,Y
        iny
        tya
        and #%00011111
        bne padslt

* check mount or unmount
sltoff  ldy #$00
        lda hslts,Y
        bne mountsl
* unmount
* SIO $E6 does not work
* instead just write empty host
*        jsr _print
*        dta c'un',b($00)
*        lda #$E6
*        sta mntcmd
*        jsr mntslt
        jsr wrthslt
        rts
* mount
mountsl jsr wrthslt
        jsr mntslt
        rts

* write host slots
wrthslt jsr _print
        dta c'write host slots',b($9b,$00)
        ldx <siowslt
        ldy >siowslt
        jsr _dosio
        rts

mntslt  jsr _print
        dta c'mount host slot',b($9b,$00)
        ldx <siohmnt
        ldy >siohmnt
        jsr _dosio
        rts

* DCB data for Fuji READ HOST SLOTS
siorslt dta b($70,$01)  ; FujiNet device and unit
        dta b($F4)      ; Command READ HOST SLOTS
        dta b($40)      ; status
        dta a(hslts)    ; host slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a(fn_hslt_l8) ; buffer size
        dta b($00)      ; AUX1
        dta b($00)      ; AUX2
* DCB data for Fuji WRITE HOST SLOTS
siowslt dta b($70,$01)  ; FujiNet device and unit
        dta b($F3)      ; Command READ HOST SLOTS
        dta b($80)      ; status
        dta a(hslts)    ; host slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a(fn_hslt_l8)  ; buffer size
        dta b($00)      ; AUX1
        dta b($00)      ; AUX2
* DCB data for Fuji (UN)MOUNT HOST SLOT
siohmnt dta b($70,$01)  ; FujiNet device and unit
mntcmd  dta b($F9)      ; Command MOUNT HOST SLOT
        dta b($00)      ; status
        dta a($0000)    ; device slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($0000)    ; 8 device slots
hmntslt dta b($00)      ; AUX1
        dta b($00)      ; AUX2

        icl '_PRINT.ICL'
        icl '_CHKSDOS.ICL'
        icl '_SDLBUF.ICL'
        icl '_SDFAIL.ICL'
        icl '_SDLSIO.ICL'

* buffer for HOST SLOTS ($100 aligned)
hslts   equ *&$FF00+$100

        end
