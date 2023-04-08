* FujiNet FMOUNTAL mount all host and device slots

        icl '_SYSEQU.ICL'
        icl '_FNEQU.ICL'

        blk dos $3000
        jsr _chksdos
        jsr _lbinit
* read config via SIO
        ldx <siomnta
        ldy >siomnta
        jsr _dosio
        rts

prnDocu jsr _print
        dta b($9b),c'Usage: FMOUNTAL',b($9b)
        dta c'Version: 08-04-23',b($9b)
        dta c'Mounts all host and device slots.',b($9b,$00)
        rts

* DCB data for Fuji mount all
siomnta dta b($70,$01)  ; FujiNet device and unit
        dta b($D7)      ; Command MOUNT ALL
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
