* FujiNet FLS List Slot Path Content

        icl '_SYSEQU.ICL'
        icl '_FNEQU.ICL'

        blk dos $3000
        jsr _chksdos
* clear buffer
        ldx #$00
        txa
clr_buf sta buffer,X
        inx
        bne clr_buf
* parse parameter
        jsr _lbinit
        jsr _lbtrim
        cmp #$9b
        bne *+5
        jmp prnDocu
* check for slot number
        cmp #'1'
        bcc badpara
        cmp #'9'
        bcs badpara
        tay
        jsr _lbget
        cmp #' '
        beq sslt
        cmp #$9b
        bne badpara
        dex
        jmp sslt
* Bad Parameter
badpara jsr prnDocu
        ldy #$9C
        jmp _fail

prnDocu jsr _print
        dta b($9b),c'Usage: FLS slot [path[/pattern]]',b($9b)
        dta c'Version: 08-04-23',b($9b)
        dta b($9b),c'List directory of host slot.',b($9b,$00)
        rts

* set slot
sslt    dey
        tya
        and #$0F
        sta mntslt
        sta openslt
        sta readslt
        sta closslt
* set path in buffer for open directory
        ldy #$00
nxtlbuf jsr _lbget
        cmp #$9b
        beq spatt
        sta buffer,Y
        iny
        jmp nxtlbuf
* set null for pattern
spatt   dey
        bmi noslash
        lda buffer,Y
        cmp #'/'
        bne spatt
setnul  lda #$00
        sta buffer,Y
        beq mount
* if no slash then dec buffer
* to get starting 0
noslash dec opendbu
* mount host slot
mount   ldx <mounts
        ldy >mounts
        jsr _dosio
* open directory
        ldx <opendir
        ldy >opendir
        jsr _dosio
* read directory
        jmp prneol
read    ldx <readdir
        ldy >readdir
        jsr _dosio
* $7F7F = last entry
        lda buffer
        cmp #$7F
        bne print
        lda buffer+1
        cmp #$7F
        beq close
* print entry
print   ldx #$00
        stx iter1
nxtchar lda buffer,X
        beq prneol
        jsr _putc
        inc iter1
        ldx iter1
        cpx #$FF
        bne nxtchar
prneol  lda #$9b
        jsr _putc
* check ESC key
        lda #$1C ; ESC
        cmp CH
        beq close
        jmp read
* close directory
close   ldx <closdir
        ldy >closdir
        jsr _dosio
        rts

* DCB data for Fuji MOUNT HOST SLOT
mounts  dta b($70,$01)  ; FujiNet device and unit
        dta b($F9)      ; Command OPEN DIRECTORY
        dta b($00)      ; status
        dta a($0000)    ; device slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($0000)    ; buffer size
mntslt  dta b($00)      ; AUX1 slot number
        dta b($00)      ; AUX2

* DCB data for Fuji OPEN DIRECTORY
opendir dta b($70,$01)  ; FujiNet device and unit
        dta b($F7)      ; Command OPEN DIRECTORY
        dta b($80)      ; status
opendbu dta a(buffer)   ; device slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($100)     ; buffer size
openslt dta b($00)      ; AUX1 slot number
        dta b($00)      ; AUX2

* DCB data for Fuji READ DIRECTORY
readdir dta b($70,$01)  ; FujiNet device and unit
        dta b($F6)      ; Command READ DIRECTORY
        dta b($40)      ; status
        dta a(buffer)   ; device slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($FF)      ; buffer size
        dta b($FF)      ; AUX1 used buffer size
readslt dta b($00)      ; AUX2 slot number

* DCB data for Fuji CLOSE DIRECTORY
closdir dta b($70,$01)  ; FujiNet device and unit
        dta b($F5)      ; Command CLOSE DIRECTORY
        dta b($00)      ; status
        dta a($0000)    ; device slots buffer
        dta b($10)      ; time out
        dta b($00)      ; unused
        dta a($0000)    ; buffer size
closslt dta b($00)      ; AUX1 slot number
        dta b($00)      ; AUX2

        icl '_PRINT.ICL'
        icl '_CHKSDOS.ICL'
        icl '_SDLBUF.ICL'
        icl '_SDFAIL.ICL'
        icl '_SDLSIO.ICL'

* device slots buffer
        dta b($00)
* buffer is dec by 1 if no slash
* must not start at page begin 
buffer  equ *
* div by 0 if page begin
assert  equ 1/[buffer&$FF]

iter1   equ buffer+$100

        end
