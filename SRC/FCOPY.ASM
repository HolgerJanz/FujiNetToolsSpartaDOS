* FujiNet FCOPY copy from host to host

        icl '_SYSEQU.ICL'
        icl '_FNEQU.ICL'

* main
        blk dos $3000
        jsr _chksdos
* clear copy buffer
        ldx #$00
        txa
        sta cpybuf,X
        inx
        bpl *-4
* parse comand line
        jsr _lbinit
        jsr _lbtrim
* parse source slot and file
        cmp #'1'
        bcc badpara
        cmp #'9'
        bcs badpara
        and #$0F
        sta srchst
        jsr _lbtrim
        cmp #'"'
        bne *+8
        sta nxtidc+1
        jsr _lbget
        ldy #$00
nxtidc  cmp #' '
        beq pardst
        cmp #$9b
        beq badpara
        sta cpybuf,Y
        jsr _lbget
        iny
        jmp nxtidc
* parse destination slot and file
pardst  lda #'|'
        sta cpybuf,Y
        iny
        jsr _lbtrim
        cmp #'1'
        bcc badpara
        cmp #'9'
        bcs badpara
        and #$0F
        sta dsthst
        jsr _lbtrim
        cmp #'"'
        bne *+8
        sta nxtpwc+1
        jsr _lbget
nxtpwc  cmp #' '
        bne *+11
        jsr _lbtrim
        cmp #$9b
        beq callsio
        bne badpara
        cmp #$9b
        beq callsio
        cpy #fn_pass_ln-1
        bcs badpara
        sta cpybuf,Y
        jsr _lbget
        iny
        jmp nxtpwc

* error bad parameter
badpara ldy #$9C ; Bad Parameter
        jmp _fail

* call sio
callsio jsr _print
        dta b($9b),c'copy file',b($9b,$00)
        ldx <siocopy
        ldy >siocopy
        jsr _dosio
        rts

* print docu, used by _blinit
prnDocu jsr _print
        dta b($9b)
        dta c'Usage: FCOPY sslot sfile dslot [dfile]',b($9b)
        dta c'Version: 21-03-23',b($9b)
        dta c'Copies one file sfile from host slot',b($9b)
        dta c'sslot to file dfile of host slot dslot.',b($9b)
        dta b($00)
        rts

* DCB data for Fuji COPY FILE
siocopy dta b($70,$01)  ; FujiNet device and unit
        dta b($D8)      ; Command COPY FILE
        dta b($80)      ; status
        dta a(cpybuf)   ; buffer SSID and passwd
        dta b($FE)      ; time out
        dta b($00)      ; unused
        dta a($100)     ; buffer size
srchst  dta b($00)      ; AUX1 source host slot 1-8
dsthst  dta b($00)      ; AUX2 dest host solt 1-8

        icl '_PRINT.ICL'
        icl '_CHKSDOS.ICL'
        icl '_SDLBUF.ICL'
        icl '_SDFAIL.ICL'
        icl '_SDLSIO.ICL'

cpybuf  equ *

        end
