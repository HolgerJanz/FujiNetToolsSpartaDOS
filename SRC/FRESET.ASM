* FujiNet FRESET reset FujiNet

        icl '_SYSEQU.ICL'
        icl '_FNEQU.ICL'

        blk dos $3000
        jsr _chksdos
        jsr _lbinit
* read config via SIO
        ldx <siorst
        ldy >siorst
        jsr _dosio
* wait 4-5 sec
        ldx RTCLOK+2
        dex
        cpx RTCLOK+2
        bne *-2
        rts

prnDocu jsr _print
        dta b($9b),c'Usage: RESET',b($9b)
        dta c'Version: 21-03-23',b($9b)
        dta c'Resets FujiNet and waits ca. 3s.',b($9b,$00)
        rts

* DCB data for Fuji reset
siorst  dta b($70,$01)  ; FujiNet device and unit
        dta b($FF)      ; Command RESET
        dta b($00)      ; status
        dta a($0000)    ; address unused
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($0000)    ; size unused
        dta b($00)      ; AUX1
        dta b($00)      ; AUX2

        icl '_PRINT.ICL'
        icl '_CHKSDOS.ICL'
        icl '_SDLBUF.ICL'
        icl '_SDFAIL.ICL'
        icl '_SDLSIO.ICL'

        end
