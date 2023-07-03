bstatusbar macro string
push ax
push dx
mov ah,2
mov dl,226
mov dh,10
int 10h

mov ah,9 
mov dx,offset string
int 21h

pop dx
pop ax
endm

wstatusbar macro string
push ax
push dx
mov ah,2
mov dl,226
mov dh,23
int 10h

mov ah,9 
mov dx,offset string
int 21h

pop dx
pop ax
endm

drawstatline macro x,y,max
local line
push ax
push cx
push dx

    mov ah,0ch 
    mov al,0fh 
    mov cx,x
    mov dx,y
    line:
    int 10h
    inc cx
    cmp cx,max
    jnz line
    pop dx
    pop cx
    pop ax
endm

drawvertline macro x,y,max
local line
push ax
push cx
push dx

    mov ah,0ch 
    mov al,0fh 
    mov cx,x
    mov dx,y
    line:
    int 10h
    inc dx
    cmp dx,max
    jnz line
    pop dx
    pop cx
    pop ax
endm

printwhitestatus macro
    mov ah,2
    mov dl,226
    mov dh,13
    int 10h

    mov ah,9 
    mov dx,offset nowpawnkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,13
    int 10h

    mov ah,9 
    mov dx,offset wpawnid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,15
    int 10h

    mov ah,9 
    mov dx,offset nowknightkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,15
    int 10h

    mov ah,9 
    mov dx,offset wknightid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,17
    int 10h

    mov ah,9 
    mov dx,offset nowbishopkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,17
    int 10h

    mov ah,9 
    mov dx,offset wbishopid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,19
    int 10h

    mov ah,9 
    mov dx,offset nowqueenkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,19
    int 10h

    mov ah,9 
    mov dx,offset wqueenid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,21
    int 10h

    mov ah,9 
    mov dx,offset nowrookkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,21
    int 10h

    mov ah,9 
    mov dx,offset wrookid
    int 21h
    endm

printblackstatus macro
    mov ah,2
    mov dl,226
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset nobpawnkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset bpawnid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,2
    int 10h

    mov ah,9 
    mov dx,offset nobknightkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,2
    int 10h

    mov ah,9 
    mov dx,offset bknightid
    int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,4
    int 10h

    mov ah,9 
    mov dx,offset nobbishopkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,4
    int 10h

    mov ah,9 
    mov dx,offset bbishopid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,6
    int 10h

    mov ah,9 
    mov dx,offset nobqueenkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,6
    int 10h

    mov ah,9 
    mov dx,offset bqueenid
    int 21h
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ah,2
    mov dl,226
    mov dh,8
    int 10h

    mov ah,9 
    mov dx,offset nobrookkill
    int 21h

    mov ah,2
    mov dl,227
    mov dh,8
    int 10h

    mov ah,9 
    mov dx,offset brookid
    int 21h
    endm

stringcolour macro string,place,length,colour ;macro to print string with colour
    local print
    push es ;save segment register
    mov ax,0b800h
    mov es,ax
    lea si,string ;string to be printed
    mov cx,length ;length of string
    mov ah,colour ;white colour
    mov di,place  ;adjusts the place where the string should be printed
    
    print:
    lodsb
    stosw     ;loop to print string
    dec cx
    jne print
    pop es 
    ENDM

drawpicture macro filename,filehandle,width,height,data,x,y
    push ax
    push bx
    push cx
    push dx
    push di 
    push si

    mov  dx ,offset filename
    mov di , offset filehandle
    CALL OpenFile
    mov cx ,width*height
    lea DX,data
    mov bx ,offset filehandle
    CALL ReadData
    
    mov ax,00h
    MOV CX,x
    MOV DX,y
    mov di , cx
    MOV AH,0ch
    mov si,offset data
    ;mov BX , si ; BL contains index at the current drawn pixel
	  mov bx ,00h
    mov bl ,height
    mov bp , bx
    add bp , dx
    add bx,cx
  
    ;mov di,0
    call Drawing

  MOV BX,[filehandle]
    call CloseFile

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    endm
;------------------------------------------convert25toindex---------------------------------------------
  ; function convert (cx,dx) coordinates into arrayboard index without affecting cx or dx 
  ; store the index in di and store the piece code of this index in bl (affects di and bl)

  convert25toindex macro 
  push cx
  push dx
  push ax
  push si
  push bp

  mov di,cx
  mov bx,dx
    mov dx, 0000h
    ; take the index of piece saved in di and bx
     mov ax,di
     mov si,25
     div si
     
     mov di,0000h
     mov di, ax
     
     mov ax,bx
     mov si,25
     div si 
     
     mov bp,8
     mul bp

     add di, ax
     mov bx,0 
     mov bl, arrayboard[di]   ; using bl to check the piece 

pop bp
pop si
pop ax     
pop dx
pop cx
     endm

     ;-------------------------------------------draw piece------------------------------------------------
Drawpiece macro pieceData
    push ax
    push bx
    push si
    push bp
    push di
    push cx
    push dx

    call clearCellWithGreenOrWhite
    ;call DrawFrame

    mov ax, 00h
    mov di, cx
    mov ah, 0ch
    mov si, offset pieceData
    ;mov BX , si ; BL contains index at the current drawn pixel
	  mov bx, 00h
    
    mov bl, pieceHeight
    mov bp, bx
    add bp, dx
    add bx, cx

    call Drawing
   
    pop dx
    pop cx
    pop di
    pop bp
    pop si
    pop bx
    pop ax
endm 
;---------------------------------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of macros  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
include utility.inc
.Model Small
.Stack 64
.Data

hblx dw   0              
hbly dw   0                

 oneThirdtimeWidth EQU 15
 oneThirdtimeHeight EQU 15
 oneThirdtimeFilename DB 'clk1.bin', 0
 oneThirdtimeFilehandle DW ?
 oneThirdtimeData DB oneThirdtimeWidth*oneThirdtimeWidth dup(0)

 TwoThirdtimeWidth EQU 15
 TwoThirdtimeHeight EQU 15
 TwoThirdtimeFilename DB 'clk2.bin', 0
 TwoThirdtimeFilehandle DW ?
 TwoThirdtimeData DB TwoThirdtimeWidth*TwoThirdtimeWidth dup(0)

 FulltimeWidth EQU 15
 FulltimeHeight EQU 15
 FulltimeFilename DB 'clk3.bin', 0
 FulltimeFilehandle DW ?
 FulltimeData DB FulltimeHeight*FulltimeWidth dup(0)



TimerArray db 64 dup(3)
currentTime db 99
previousTime db 99
;board 
arrayboard  db 64 dup (0)
arrvalid  db 64 dup (0)                  ;0 means not valid but 1 means valid
arrvalidwhite  db 64 dup (0)             ;0 means not valid but 1 means valid
xWhite dw 175
yWhite dw 175
xBlack dw 0
yBlack dw 0
xWhiteOld dw 175
yWhiteOld dw 175
xBlackOld dw 0
yBlackOld dw 0
qFlag db 0000h                ;indicate weather player 2 has selected or not
mFlag db 0000h        
whichQ db 0000h               ;first q = 0              second q = 1
whichM db 0000h 
firstToMoveFlag db 0000h      ; if(1)->black is the first  ,but if(2)->white is the first

boardWidth EQU 200
boardHeight EQU 200
boardFilename DB 'new.bin', 0
boardFilehandle DW ?
boardData DB boardWidth*boardHeight dup(0)
;blackrook
pieceWidth EQU 25
pieceHeight EQU 25
blackrookFilename DB 'bbr.bin', 0
blackrookFilehandle DW ?
blackrookData DB pieceWidth*pieceHeight dup(0)
;blackhorse
pieceWidth EQU 25
pieceHeight EQU 25
blackhorseFilename DB 'bbkn.bin', 0
blackhorseFilehandle DW ?
blackhorseData DB pieceWidth*pieceHeight dup(0)
;blackbishop
pieceWidth EQU 25
pieceHeight EQU 25
blackbishopFilename DB 'bii.bin', 0
blackbishopFilehandle DW ?
blackbishopData DB pieceWidth*pieceHeight dup(0)
;blackqueen
pieceWidth EQU 25
pieceHeight EQU 25
blackqueenFilename DB 'bbq.bin', 0
blackqueenFilehandle DW ?
blackqueenData DB pieceWidth*pieceHeight dup(0)
;blackking
pieceWidth EQU 25
pieceHeight EQU 25
blackkingFilename DB 'bbk.bin', 0
blackkingFilehandle DW ?
blackkingData DB pieceWidth*pieceHeight dup(0)
;blackpawn
pieceWidth EQU 25
pieceHeight EQU 25
blackpawnFilename DB 'bbp.bin', 0
blackpawnFilehandle DW ?
blackpawnData DB pieceWidth*pieceHeight dup(0)
;--------------------------------------------------------
;whiterook
pieceWidth EQU 25
pieceHeight EQU 25
whiterookFilename DB 'wbr.bin', 0
whiterookFilehandle DW ?
whiterookData DB pieceWidth*pieceHeight dup(0)
;whiteknight
pieceWidth EQU 25
pieceHeight EQU 25
whiteknightFilename DB 'wbk.bin', 0
whiteknightFilehandle DW ?
whiteknightData DB pieceWidth*pieceHeight dup(0)
;whitebishop
pieceWidth EQU 25
pieceHeight EQU 25
whitebishopFilename DB 'wbi.bin', 0
whitebishopFilehandle DW ?
whitebishopData DB pieceWidth*pieceHeight dup(0)
;whitequeen
pieceWidth EQU 25
pieceHeight EQU 25
whitequeenFilename DB 'wbq.bin', 0
whitequeenFilehandle DW ?
whitequeenData DB pieceWidth*pieceHeight dup(0)
;whiteking
pieceWidth EQU 25
pieceHeight EQU 25
whitekingFilename DB 'wbkin.bin', 0
whitekingFilehandle DW ?
whitekingData DB pieceWidth*pieceHeight dup(0)
;whitepawn
pieceWidth EQU 25
pieceHeight EQU 25
whitepawnFilename DB 'wbp.bin', 0
whitepawnFilehandle DW ?
whitepawnData DB pieceWidth*pieceHeight dup(0)

reachingPieceFlag db 0

;GreenCell
pieceWidth EQU 25
pieceHeight EQU 25
GreenCellFilename DB 'Green.bin', 0
GreenCellFilehandle DW ?
GreenCellData DB pieceWidth*pieceHeight dup(0)

;GreyCell
pieceWidth EQU 25
pieceHeight EQU 25
GreyCellFilename DB 'Grey.bin', 0
GreyCellFilehandle DW ?
GreyCellData DB pieceWidth*pieceHeight dup(0)
;;;;;;;;;;;;;;;;;;;;;main screen;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nam db 'Player 1, Please Enter your Name:','$'  
nam1 db 'Player 2, Please Enter your Name:','$'
vnm db 'Kindly Please Enter a valid Name:','$'
username db 16,?,30 dup('$')
username1 db 16,?,30 dup('$')
cont db 'Press Enter key to continue'
mes  db 'To start chatting press F1','$'
mes1 db 'To start the game press F2','$'
mes2 db 'To end the program press ESC','$'
mes3 db '--------------------------------------------------------------------------------','$'
mes4 db ' Has sent an invitation to start chat with ','$'
mes5 db ' Has sent an invitation to start game with ','$'
mes6 db '- To accept the invitation of chatting, Press F1     ','$'
mes7 db '- To accept the invitation of starting game, Press F2','$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wpawn db ' wpawn->lost ','$'
wknight db 'wknight->lost','$'
wbishop db 'wbishop->lost','$'
wqueen db 'wqueen->lost ','$'
wrook db ' wrook->lost ','$'

bpaw db ' bpawn->lost ','$'
bhorse db 'bknight->lost','$'
bbshop db 'bbishop->lost','$'
Bquen db 'bqueen->lost ','$'
Brok db 'brook->lost','$'

gameover db '  GAME OVER  ','$'
wingame db '   YOU WON   ','$'

nowpawnkill db '0','$'
wpawnid db 'P','$'

nowknightkill db '0','$'
wknightid db 'K','$'

nowbishopkill db '0','$'
wbishopid db 'B','$'

nowqueenkill db '0','$'
wqueenid db 'Q','$'

nowrookkill db '0','$'
wrookid db 'R','$'

nobpawnkill db '0','$'
bpawnid db 'P','$'

nobknightkill db '0','$'
bknightid db 'K','$'

nobbishopkill db '0','$'
bbishopid db 'B','$'

nobqueenkill db '0','$'
bqueenid db 'Q','$'

nobrookkill db '0','$'
brookid db 'R','$'

whiteteam db 'white','$'
blackteam db 'black','$'

wkCheckmate db 'WK checkmate ','$'
bKcheckmate db 'BK checkmate','$'
gameoverFlag db 0            ;To be one if game ended

RESAH DB '$', '$'
SENDAH DB '$', '$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.Code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN PROC FAR
    MOV AX , @DATA
    MOV DS , AX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;To be uncommented;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; push ax
; push bx
; push cx
; push dx
; push si
; push di
; push bp
; ;go to text mode
;     mov ah, 0
;     mov al, 3h
;     int 10h 

; stringcolour nam,0000,33,0fh

; ;set cursor position
; mov ah,2
; mov dx ,0102h
; int 10h

; ; get the username
; mov ah,0Ah
; mov dx,offset username
; int 21h  
; cmp username+2,'A'
; jc nvalid  
; cmp username+2,'z'
; jnc nvalid 
; mov cx,6 
; mov al,'['
; mov dl,username+2
; loop1:     
; mov dl,username+2
;      sub dl,al
;      jz nvalid   
;      inc al 
;      dec cx  
;      jnz loop1
; jmp valid
; nvalid:  
; mov ax,0003h
; int 10h
;      stringcolour vnm,0000,33,0fh
;      ;set cursor position
; mov ah,2
; mov dx ,0102h
; int 10h
; mov ah,0Ah
; mov dx,offset username
; int 21h
; cmp username+2,'A'
; jc nvalid  
; cmp username+2,'z'
; jnc nvalid 
; mov cx,6
; mov al,'['
; loop2:     
; mov dl,username+2
;      sub dl,al
;      jz nvalid   
;      inc al 
;      dec cx  
;      jnz loop2
; ;jmp nvalid
; valid:
; mov dx,0
; mov bx,2
; count:
; lea si,username+[bx]
;     lodsb
;     cmp bx,17
;     jz colour
;     cmp al,32d
;     jb colour
;     cmp al,255d
;     ja colour
;     inc dx
;     inc bx
;     jmp count

; colour:
; stringcolour username+2,0164,dx,0fh
; stringcolour cont,0640,27,0fh

; mov ah,2
; mov dx ,041Bh
; int 10h

; entr:
; mov ah,0
; int 16h
; cmp al,0Dh
; jnz entr


;  mov ah, 0
;     mov al, 3h
;     int 10h 

; stringcolour nam1,0000,33,0fh

; ;set cursor position
; mov ah,2
; mov dx ,0102h
; int 10h

; ; get the username
; mov ah,0Ah
; mov dx,offset username1
; int 21h  
; cmp username1+2,'A'
; jc nvalid1 
; cmp username1+2,'z'
; jnc nvalid1 
; mov cx,6 
; mov al,'['
; mov dl,username1+2
; loop4:     
; mov dl,username1+2
;      sub dl,al
;      jz nvalid1   
;      inc al 
;      dec cx  
;      jnz loop4
; jmp valid1
; nvalid1:  
; mov ax,0003h
; int 10h
;      stringcolour vnm,0000,33,0fh
;      ;set cursor position
; mov ah,2
; mov dx ,0102h
; int 10h
; mov ah,0Ah
; mov dx,offset username1
; int 21h
; cmp username1+2,'A'
; jc nvalid1  
; cmp username1+2,'z'
; jnc nvalid1 
; mov cx,6
; mov al,'['
; loop3:     
; mov dl,username1+2
;      sub dl,al
;      jz nvalid1   
;      inc al 
;      dec cx  
;      jnz loop3
; ;jmp nvalid
; valid1:
; valid2:
; mov dx,0
; mov bx,2
; count2:
; lea si,username1+[bx]
;     lodsb
;     cmp bx,17
;     jz colour2
;     cmp al,32d
;     jb colour2
;     cmp al,255d
;     ja colour2
;     inc dx
;     inc bx
;     jmp count2

; colour2:
; stringcolour username1+2,0164,dx,0fh

; stringcolour cont,0640,27,0fh

; mov ah,2
; mov dx ,041Bh
; int 10h

; entr1:
; mov ah,0
; int 16h
; cmp al,0Dh
; jnz entr1

;    call mainscreen

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; End of (To be uncommented) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    call INITIALIZEUART
    call initializeTheGame
    call move

    ; mov arrayboard[27],6d
    ; mov cx,0
    ; mov dx,0
    ; ; ; call DrawFrame
    ; ; ; ;call HighlightBlack
    ; ;call ValidateBQueen
    ; ; mov cx,75
    ; ; mov dx,100
    ; ; call ValidateBQueen
    ; ;call ValidateBQueen
    ; ; mov bx,0
    ; ; convert25toindex     ;not working
    ; ;call removeAnyHighlights
    ; mov cx,100
    ; mov dx,100
    ; ; ;mov di,50
    ; ;call DrawFrame
    ; call ValidateBBishop
    ; mov cx,0
    ; mov dx,100
    ; ; ;mov di,50
    ; call DrawFrameRed


    
    call beforeEnd
MAIN ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;---------------------------------------initialize the game------------------------------------------
initializeTheGame proc

    ; call Graphics mode
    MOV AH, 0
    MOV AL, 13h
    INT 10h

;;;;;;;;;;;;;;;;;;;;;;;;prints the lines of the status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    drawvertline 200,0,200
    drawvertline 319,0,200

    drawstatline 200,99,320
    drawstatline 200,80,320

    drawstatline 200,199,320
    drawstatline 200,181,320

    drawvertline 227,0,80
    drawvertline 227,99,181

;;;;;;;;;;;;;;;;;;;;;;;;;;prints status of pieces in status bar;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov ah,2
    mov dl,230
    mov dh,0
    int 10h

    mov ah,9 
    mov dx,offset blackteam
    int 21h

    mov ah,2
    mov dl,230
    mov dh,12
    int 10h

    mov ah,9 
    mov dx,offset whiteteam
    int 21h

    printblackstatus
    printwhitestatus
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

    mov arrayboard[0],1d              ;bRook(1)
    mov arrayboard[1],2d              ;bKnight(2)
    mov arrayboard[2],3d              ;bBishop(3)
    mov arrayboard[3],4d              ;bQueeen(4)
    mov arrayboard[4],5d              ;bKing(5)
    mov arrayboard[5],3d          
    mov arrayboard[6],2d
    mov arrayboard[7],1d
    mov arrayboard[8],6d              ;bPawn(6)
    mov arrayboard[9],6d
    mov arrayboard[10],6d
    mov arrayboard[11],6d
    mov arrayboard[12],6d
    mov arrayboard[13],6d
    mov arrayboard[14],6d
    mov arrayboard[15],6d

    push di                           ;To put zero in empty cells after return to the game from main screen
    mov di,16
    nextEmptyCell:
    mov arrayboard[di],0
    inc di
    cmp di,48
    jne nextEmptyCell
    pop di

    mov arrayboard[63],7d              ;wRook(7)
    mov arrayboard[62],8d              ;wKnight(8)
    mov arrayboard[61],9d              ;wBishop(9)
    mov arrayboard[60],10d             ;wKing(10)
    mov arrayboard[59],11d             ;wQueen(11)
    mov arrayboard[58],9d
    mov arrayboard[57],8d
    mov arrayboard[56],7d
    mov arrayboard[55],12d             ;wPawn(12)
    mov arrayboard[54],12d
    mov arrayboard[53],12d
    mov arrayboard[52],12d
    mov arrayboard[51],12d
    mov arrayboard[50],12d
    mov arrayboard[49],12d
    mov arrayboard[48],12d

	  ;push all reg to be able to use them
    ;save file name in dx as the interupt need this
    ;save file handle in di to carry then file 
   
  drawpicture boardFilename,boardFilehandle,200,200,boardData,0,0 ;board
  ;-----------------------------------------------Black Pieces----------------------------------------
  drawpicture blackrookFilename,blackrookFilehandle,25,25,blackrookData,0,0 ;left blackrook
  drawpicture blackrookFilename,blackrookFilehandle,25,25,blackrookData,175,0 ;right blackrook

  drawpicture blackhorseFilename,blackhorseFilehandle,25,25,blackhorseData,25,0 ;left blackhorse
  drawpicture blackhorseFilename,blackhorseFilehandle,25,25,blackhorseData,150,0 ;right blackhorse

  drawpicture blackbishopFilename,blackbishopFilehandle,25,25,blackbishopData,50,0 ;left blackbishop
  drawpicture blackbishopFilename,blackbishopFilehandle,25,25,blackbishopData,125,0 ;right blackbishop

  drawpicture blackqueenFilename,blackqueenFilehandle,25,25,blackqueenData,75,0 ;blackqueen

  drawpicture blackkingFilename,blackkingFilehandle,25,25,blackkingData,100,0 ;blackking
  
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,0,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,25,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,50,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,75,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,100,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,125,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,150,25 ;blackpawn
   drawpicture blackpawnFilename,blackpawnFilehandle,25,25,blackpawnData,175,25 ;blackpawn
;-----------------------------------------------------------------------------------------------------
;-----------------------------------------------White Pieces----------------------------------------
drawpicture whiterookFilename,whiterookFilehandle,25,25,whiterookData,175,175 ;left whiterook
drawpicture whiterookFilename,whiterookFilehandle,25,25,whiterookData,0,175 ;right whiterook

drawpicture whiteknightFilename,whiteknightFilehandle,25,25,whiteknightData,150,175 ;left whiteknight
drawpicture whiteknightFilename,whiteknightFilehandle,25,25,whiteknightData,25,175 ;right whiteknight

drawpicture whitebishopFilename,whitebishopFilehandle,25,25,whitebishopData,125,175 ;left whitebishop
drawpicture whitebishopFilename,whitebishopFilehandle,25,25,whitebishopData,50,175 ;right whitebishop

drawpicture whitequeenFilename,whitequeenFilehandle,25,25,whitequeenData,75,175 ;whitequeen

drawpicture whitekingFilename,whitekingFilehandle,25,25,whitekingData,100,175 ;whitequeen

drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,0,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,25,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,50,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,75,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,100,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,125,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,150,150 ;whitepawn
drawpicture whitepawnFilename,whitepawnFilehandle,25,25,whitepawnData,175,150 ;whitepawn


RET                 
initializeTheGame ENDP
;---------------------------------------------------------------------------------------------

;-----------------------------------------befor end-------------------------------------------
beforeEnd PROC 
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; return control to operating system
    MOV AH , 4ch
    INT 21H
RET                 
beforeEnd ENDP
;---------------------------------------------------------------------------------------------

;-------------------------------------------drawing-----------------------------------------
Drawing PROC 
; Drawing loop
increment:
INC CX
INC si
CMP CX,bx
jz cont50
drawLoop:
    MOV AL,[si]
    cmp al,1d
    je increment
    INT 10h 
    INC CX
    INC si
    CMP CX,bx
JNE drawLoop 
	cont50:
    MOV CX , di
    inc dx
    CMP DX , bp
JNE drawLoop

RET                 
Drawing ENDP  
;-----------------------------------------------------------------------------------------------

;------------------------------------open file--------------------------------------------------
OpenFile PROC 
    ; Open file 
    
    MOV AH, 3Dh
    MOV AL, 0 ; read only
    ;mov DX, bx
    INT 21h
    MOV [di], AX
    RET
OpenFile ENDP
;------------------------------------------------------------------------------------------------

;--------------------------------------read data-------------------------------------------------
ReadData PROC
    MOV AH,3Fh
    MOV BX,[di]
    ;MOV CX,boardHeight*boardHeight ; number of bytes to read
    ;lea DX, boardData
    INT 21h
    RET
ReadData ENDP 
;-------------------------------------------------------------------------------------------------

;----------------------------------------close file-----------------------------------------------
CloseFile PROC
	MOV AH, 3Eh
	;MOV BX,[boardFilehandle]
	INT 21h
	RET
CloseFile ENDP
;-------------------------------------------------------------------------------------------------

pushingA proc 
   push ax 
   push bx 
   push CX
   push dx
 ret
pushingA endp

popingA proc 
   pop ax 
   pop bx 
   pop CX
   pop dx
 ret
popingA endp

;--------------------------------------------move------------------------------------------------
move proc 

; Draw The fram at   (0 ,0) location in start of the program
mov cx, xBlack
mov Dx ,yBlack
call DrawFrame

; Draw The fram at   (175 ,175) location in start of the program
mov cx, xWhite
mov Dx ,yWhite
call DrawFrameWhite


looptomoveagin:

      mov RESAH, '$'
			mov AH, 1
			int 16H  
			jnz SendBlack ;Ther is a key pressed = sending ah or closing game
			JMP ResWhite  ;No key pressed then recieving ah

;----------------------------------------- loop to move again ------------------------------------------
SendBlack:
  call checkTimer
  ; Get key pressed
  ; mov ah,1
  ; int 16h 
  mov ah,0
  int 16h 

  cmp ah,48h ;check if w
  jz w

  cmp ah,4Dh ;check if d
  jz d

  cmp ah,4Bh ;check if a
  jz a

  cmp ah,50h ;check if s
  jz s

  cmp ah,2Bh ;check if q (backSlash)
  jz q

  cmp ah,3Dh ;check if f3 (wants to go to mainscreen)
  jz f3cond

  jmp looptomoveagin

f3cond:
  sending 3Dh
  call mainscreen
  jmp looptomoveagin

  w:
    sending 48h
    mov dx,yBlack
    mov cx,xBlack 
    cmp dx,00h
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalidw
    jmp validw
    
    notvalidw:
      pop di 
      call CLEARFRAM
      jmp finishvalidw
    validw:
      pop di
      call DrawFrameRed

    finishvalidw: 
    sub dx,25
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin


  s:  
    sending 50h
    mov dx,yBlack
    mov cx,xBlack 
    cmp dx,175d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalids
    jmp valids
    
    notvalids:
      pop di 
      call CLEARFRAM
      jmp finishvalids
    valids:
      pop di
      call DrawFrameRed

    finishvalids: 
    add dx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin

  a:  
    sending 4Bh
    mov dx,yBlack
    mov cx,xBlack 
    cmp cx,0d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalida
    jmp valida
    
    notvalida:
      pop di 
      call CLEARFRAM
      jmp finishvalida
    valida:
      pop di
      call DrawFrameRed

    finishvalida: 
    sub cx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin


  d: 
    sending 4Dh
    mov dx,yBlack
    mov cx,xBlack 
    cmp cx,175d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalid[di],0
    je notvalidd
    jmp validd
    
    notvalidd:
      pop di 
      call CLEARFRAM
      jmp finishvalidd
    validd:
      pop di
      call DrawFrameRed

    finishvalidd: 
    add cx,25d
    call DrawFrame
    mov yBlack,dx
    mov xBlack,cx
    jmp looptomoveagin

  

    ;============================================ q ==================================================
  q:
  sending 2Bh

  mov dx,yBlack
  mov cx,xBlack
  
  cmp whichQ,0
  je firstq
  jmp secondq


firstq:
    call checkTimer

      push bx 
      push di 
      convert25toindex
      cmp TimerArray[di],2
      pop di
      pop bx
      jbe looptomoveagin

    mov whichQ,1

    mov xBlackOld , cx 
    mov yBlackOld , dx

    call validateBlackPiece

    jmp looptomoveagin

secondq:

    call checkTimer
    mov whichQ,0

      ; check for the valid dest or not
      push di
      push bx
      convert25toindex
      pop bx
      cmp arrvalid[di],0
      je notValidDest
      jmp validDest

      notValidDest:
      pop di
      mov yBlack,dx
      mov xBlack,cx
      call removeAnyHighlights
      jmp looptomoveagin

      validDest:
      pop di
      ;end of check dest without affecting any register
   
    push cx
    push dx

    mov cx, xBlackOld                ;carry location of the old x ax
    mov dx, yBlackOld                ;carry location of the old y ax

    call clearCellWithGreenOrWhite

      push di
      convert25toindex   ;To get piece code in bl
      mov arrayboard[di],0
      pop di

     pop dx
     pop cx
     ;check which to draw -------------------------------------------------------

      cmp bl,0 ;check if empty
        je finishmoving1
      cmp bl,1 ;check if Rook
        je bRook1
      cmp bl,2 ;check if kinght
        je bknight1
      cmp bl,3 ;check if Bishop
        je bBishop1
      cmp bl,4 ;check if Queen
        je bQueen1
      cmp bl,5 ;check if King
        je bKing1
      cmp bl,6 ;check if Pawn
        je bPawn1
        jmp finishmoving1
      
      bRook1:
        push bx                   ;these four lines for getting the index of cell and put the piece code in it
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackrookData
        call DrawFrame
        jmp finishmoving1
      
      bknight1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackhorseData
        call DrawFrame
        jmp finishmoving1
      
      bBishop1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackbishopData
        call DrawFrame
        jmp finishmoving1
      
      bQueen1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackqueenData
        call DrawFrame
        jmp finishmoving1
      
      bKing1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackkingData
        call DrawFrame
        jmp finishmoving1
        
      bPawn1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece blackpawnData
        mov hblx,cx
        mov hbly,dx
        drawpicture  FulltimeFilename,FulltimeFilehandle,FulltimeWidth,FulltimeHeight,FulltimeData,hblx,hbly
        call checkTimer
        call DrawFrame
        jmp finishmoving1

   finishmoving1: 

   call removeAnyHighlights
   call falseAllTheValidArray
   call checkTimer

  jmp looptomoveagin


;=============================================recieve ===================================================
ResWhite:

  receiving RESAH
	CMP RESAH, '$'
	JE looptomoveagin

  cmp RESAH,48h ;check if up
  jz upArrow 

  cmp RESAH,4Dh ;check if right
  jz rightArrow

  cmp RESAH,4Bh ;check if left
  jz leftArrow

  cmp RESAH,50h ;check if down
  jz downArrow

  cmp RESAH,2Bh ;check if m (select for the white player) (backslash)
  jz m

  cmp RESAH,3Dh ;check if f3 (wants to go to mainscreen)
  jz f3condw

  jmp looptomoveagin

f3condw:
  call mainscreen
  jmp looptomoveagin


  upArrow:
    mov cx,xWhite
    mov dx,ywhite
    cmp dx,00h
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidww
    jmp validww
    
    notvalidww:
      pop di 
      call clearFrameWhite
      jmp finishvalidww
    validww:
      pop di
      call DrawFrameBlue

    finishvalidww: 
    sub dx,25
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin


downArrow:
    mov cx,xWhite
    mov dx,ywhite
    cmp dx,175d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidsw
    jmp validsw
    
    notvalidsw:
      pop di 
      call clearFrameWhite
      jmp finishvalidsw
    validsw:
      pop di
      call DrawFrameBlue

    finishvalidsw: 
    add dx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

leftArrow: 
    mov cx,xWhite
    mov dx,ywhite 
    cmp cx,0d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvalidaw
    jmp validaw
    
    notvalidaw:
      pop di 
      call clearFrameWhite
      jmp finishvalidaw
    validaw:
      pop di
      call DrawFrameBlue

    finishvalidaw: 
    sub cx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

rightArrow: 
    mov cx,xWhite
    mov dx,ywhite
    cmp cx,175d
    jz looptomoveagin

    push di
    push bx
    convert25toindex
    pop bx
    cmp arrvalidwhite[di],0
    je notvaliddw
    jmp validdw
    
    notvaliddw:
      pop di 
      call clearFrameWhite
      jmp finishvaliddw
    validdw:
      pop di
      call DrawFrameBlue

    finishvaliddw: 
    add cx,25d
    call DrawFrameWhite
    mov xWhite,cx
    mov ywhite,dx
    jmp looptomoveagin

 ;============================================ m ==================================================
  m:

  mov dx,yWhite
  mov cx,xWhite
  
  cmp whichM,0
  je firstm
  jmp secondm


firstm:
    call checkTimer

      push bx 
      push di 
      convert25toindex
      cmp TimerArray[di],2
      pop di
      pop bx
      jbe looptomoveagin

    mov whichM,1

    mov xWhiteOld , cx 
    mov yWhiteOld , dx

    call validateWhitePiece

    jmp looptomoveagin

secondm:
    call checkTimer
    mov whichM,0

      ; check for the valid dest or nor 
      push di
      push bx 
      convert25toindex
      pop bx
      cmp arrvalidwhite[di],0
      je notValidDestw
      jmp validDestw

      notValidDestw:
      pop di
      mov ywhite,dx
      mov xWhite,cx
      call removeAnyHighlightswhite
      jmp looptomoveagin

      validDestw:
      pop di
      ;end of check dest without affecting any register

    push cx
    push dx

      mov cx, xWhiteOld                ;carry location of the old x ax
      mov dx, yWhiteOld                ;carry location of the old y ax

      call clearCellWithGreenOrWhite

        push di
        convert25toindex   ;To get piece code in bl
        mov arrayboard[di],0
        pop di

    pop dx
    pop cx
    
;check which to draw -------------------------------------------------------

      cmp bl,0 ;check if empty
        je finishmoving1w
      cmp bl,7 ;check if Rook
        je wRook1
      cmp bl,8 ;check if kinght
        je wknight1
      cmp bl,9 ;check if Bishop
        je wBishop1
      cmp bl,11 ;check if Queen
        je wQueen1
      cmp bl,10 ;check if King
        je wKing1
      cmp bl,12 ;check if Pawn
        je wPawn1
      
      wRook1:
        push bx                   ;these four lines for getting the index of cell and put the piece code in it
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whiterookData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wknight1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whiteknightData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wBishop1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitebishopData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wQueen1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitequeenData
        call DrawFrameWhite
        jmp finishmoving1w
      
      wKing1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitekingData
        call DrawFrameWhite
        jmp finishmoving1w
        
      wPawn1:
        push bx
        convert25toindex
        call fillTheStatusBar
        pop bx
        mov arrayboard[di], bl
        mov TimerArray[di],0
        Drawpiece whitepawnData
        call DrawFrameWhite
        jmp finishmoving1w

   finishmoving1w: 
      
   call removeAnyHighlightswhite
   call falseAllTheValidArrayWhite
      
  jmp looptomoveagin

ret
move endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                               vGraphics                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-----------------------------------------------draw frame---------------------------------------------
DrawFrame proc
push ax
push bx 
push si
push di
push bp


mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d

mov al,00h
mov ah,0ch
back1: int 10h
 inc cx
 cmp cx,bp
jnz back1

mov al,00h
mov ah,0ch
back2: int 10h
 inc dx
 cmp dx,bx
jnz back2

mov al,00h
mov ah,0ch
back3: int 10h
 dec cx
 cmp cx,si
jnz back3

mov al,00h
mov ah,0ch
back4: int 10h
 dec dx
 cmp dx,di
jnz back4

pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrame  endp
;---------------------------------------------------------------------------------------------------

;----------------------------------------clear frame------------------------------------------------
CLEARFRAM proc
push ax
push bx 
push si
push di
push bp

; check if red finish
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    je finishClearFrame


;checking the color of drawing (white or black)
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz odd
jmp pass
odd: mov al,07h
pass:
;end checking
mov dx,bp
;clear before drawing
mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d


mov ah,0ch
back11: int 10h
  inc cx
  cmp cx,bp
jnz back11

mov ah,0ch
back22: int 10h
 inc dx
 cmp dx,bx
jnz back22

mov ah,0ch
back33: int 10h
 dec cx
 cmp cx,si
jnz back33

mov ah,0ch
back44: int 10h
 dec dx
 cmp dx,di
jnz back44

finishClearFrame:

pop bp
pop di
pop si
pop bx
pop ax
ret
CLEARFRAM  endp
;-----------------------------------------------------------------------------------------------------------

;-----------------------------------------draw frame for white player --------------------------------------
DrawFrameWhite proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc cx
inc dx

mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22
add bx,22

mov al,02h
mov ah,0ch
back1w: int 10h
 inc cx
 cmp cx,bp
jnz back1w

mov al,02h
mov ah,0ch
back2w: int 10h
 inc dx
 cmp dx,bx
jnz back2w

mov al,02h
mov ah,0ch
back3w: int 10h
 dec cx
 cmp cx,si
jnz back3w

mov al,02h
mov ah,0ch
back4w: int 10h
 dec dx
 cmp dx,di
jnz back4w

pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameWhite  endp
;-----------------------------------------------------------------------------------------------------------

;-------------------------------------clear frame for the white player--------------------------------------
clearFrameWhite proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc cx
inc dx

; check if blue finish
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,01h              ;compare it with the highlighting color(blue)
    je finishClearFramew

;checking the color of drawing (white or black)
push cx
push dx

dec cx
dec dx
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz oddw
jmp passw
oddw: mov al,07h
passw:
;end checking
mov dx,bp
;clear before drawing
pop dx
pop cx

mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22
add bx,22


mov ah,0ch
back11w: int 10h
  inc cx
  cmp cx,bp
jnz back11w

mov ah,0ch
back22w: int 10h
 inc dx
 cmp dx,bx
jnz back22w

mov ah,0ch
back33w: int 10h
 dec cx
 cmp cx,si
jnz back33w

mov ah,0ch
back44w: int 10h
 dec dx
 cmp dx,di
jnz back44w

finishClearFramew:
pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax
ret
clearFrameWhite  endp
;-----------------------------------------------------------------------------------------------------------

;-----------------------------------draw frame for highlighting black pieces--------------------------------
DrawFrameRed proc
push ax
push bx 
push si
push di
push bp

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d

mov al,04h
mov ah,0ch
back1r: int 10h
 inc cx
 cmp cx,bp
jnz back1r

mov al,04h
mov ah,0ch
back2r: int 10h
 inc dx
 cmp dx,bx
jnz back2r

mov al,04h
mov ah,0ch
back3r: int 10h
 dec cx
 cmp cx,si
jnz back3r

mov al,04h
mov ah,0ch
back4r: int 10h
 dec dx
 cmp dx,di
jnz back4r

pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameRed  endp
;---------------------------------------------------------------------------------------------------

;-------------------------------clear highlighted frame for black pieces----------------------------
ClearFrameRed proc
push ax
push bx 
push si
push di
push bp
;checking the color of drawing (white or black)
MOV bp,dx

mov si,cx
add si,dx

mov dx, 0000h
mov ax,si
MOV bx,2d 
DIV bx

mov al,07h
CMP DL,1
jz oddr
jmp passr
oddr: mov al,07h
passr:
;end checking
mov dx,bp
;clear before drawing
mov si,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,24d
add bx,24d


mov ah,0ch
back11r: int 10h
  inc cx
  cmp cx,bp
jnz back11r

mov ah,0ch
back22r: int 10h
 inc dx
 cmp dx,bx
jnz back22r

mov ah,0ch
back33r: int 10h
 dec cx
 cmp cx,si
jnz back33r

mov ah,0ch
back44r: int 10h
 dec dx
 cmp dx,di
jnz back44r

pop bp
pop di
pop si
pop bx
pop ax
ret
ClearFrameRed  endp
;------------------------------------------------------------------------------------------------------


;-----------------------------------draw frame for highlighting white pieces--------------------------------
DrawFrameBlue proc
push ax
push bx 
push si
push di
push bp
push cx
push dx

inc dx
inc cx

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22d
add bx,22d

mov al,01h
mov ah,0ch
back1rb: int 10h
 inc cx
 cmp cx,bp
jnz back1rb

mov al,01h
mov ah,0ch
back2rb: int 10h
 inc dx
 cmp dx,bx
jnz back2rb

mov al,01h
mov ah,0ch
back3rb: int 10h
 dec cx
 cmp cx,si
jnz back3rb

mov al,01h
mov ah,0ch
back4rb: int 10h
 dec dx
 cmp dx,di
jnz back4rb


pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax

ret
DrawFrameBlue  endp
;---------------------------------------------------------------------------------------------------

;-------------------------------clear highlighted frame for white pieces----------------------------
ClearFrameBlue proc

push ax
push bx 
push si
push di
push bp
push cx
push dx


inc dx
inc cx

mov si ,cx
mov di,dx
mov bp,cx
mov bx,dx

add bp,22d
add bx,22d

mov al,07h
mov ah,0ch
back1rbg: int 10h
 inc cx
 cmp cx,bp
jnz back1rbg

mov al,07h
mov ah,0ch
back2rbg: int 10h
 inc dx
 cmp dx,bx
jnz back2rbg

mov al,07h
mov ah,0ch
back3rbg: int 10h
 dec cx
 cmp cx,si
jnz back3rbg

mov al,07h
mov ah,0ch
back4rbg: int 10h
 dec dx
 cmp dx,di
jnz back4rbg


pop dx
pop cx
pop bp
pop di
pop si
pop bx
pop ax
ret

ClearFrameBlue  endp
;------------------------------------------------------------------------------------------------------

;-------------------------------------------fill the status bar----------------------------------------
;function to send lost pieces after moving using bl to check the removed piece id
fillTheStatusBar proc
  push bx
    ;black pieces
    cmp bl,1
    je bRStatus
    cmp bl,2
    je bHStatus
    cmp bl,3
    je bBStatus
    cmp bl,4
    je bQStatus
    cmp bl,5
    je bKStatus
    cmp bl,6
    je bPStatus

    ;white pieces
    cmp bl,7
    je wRStatus
    cmp bl,8
    je wHStatus
    cmp bl,9
    je wBStatus
    cmp bl,10
    je wKStatus
    cmp bl,11
    je wQStatus
    cmp bl,12
    je wPStatus
    jmp finishFillingStatus

    ;black
    bRStatus:
      bstatusbar Brok
      inc nobrookkill
      jmp finishFillingStatus
    bHStatus:
      bstatusbar bhorse
      inc nobknightkill
      jmp finishFillingStatus
    bBStatus:
      bstatusbar bbshop
      inc nobbishopkill
      jmp finishFillingStatus
    bQStatus:
      bstatusbar Bquen
      inc nobqueenkill
      jmp finishFillingStatus
    bKStatus:
      bstatusbar gameover
      wstatusbar wingame
      mov gameoverFlag,1
      jmp finishFillingStatus
    bPStatus:
      bstatusbar bpaw
      inc nobpawnkill
      jmp finishFillingStatus

    ;white
    wRStatus:
      wstatusbar wrook
      inc nowrookkill
      jmp finishFillingStatus
    wHStatus:
      wstatusbar wknight
      inc nowknightkill
      jmp finishFillingStatus
    wBStatus:
      wstatusbar wbishop
      inc nowbishopkill
      jmp finishFillingStatus
    wQStatus:
      wstatusbar wqueen
      inc nowqueenkill
      jmp finishFillingStatus
    wKStatus:
      wstatusbar gameover
      bstatusbar wingame
      mov gameoverFlag,1
      jmp finishFillingStatus
    wPStatus:
      wstatusbar wpawn
      inc nowpawnkill
      jmp finishFillingStatus

    finishFillingStatus:
    push ax
    push dx
    printwhitestatus
    printblackstatus
    pop dx
    pop ax

  pop bx
ret
fillTheStatusBar endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            validation for each piece destination and highlight available destinations               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;balck pieces;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------validate black Pawn ----------------------------------------
ValidateBPawn proc
push cx
push dx

add cx,25                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower right
add dx,25
cmp dx,175
jg notempty2                     ; means reaching the last row of the board, So return fom proc
cmp cx,175
jg notwhitep1
;check if white piece in this position
mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againp1:
    cmp bx,di
    je whitep1                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againp1
  
    jmp notwhitep1
  whitep1:                    
    call DrawFrameRed                ;highlight because it is white (could be attacked)
  notwhitep1:

sub cx,50                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower left
cmp cx,0
jl notwhitep2
;check if white piece in this position
mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againp2:
    cmp bx,di
    je whitep2                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againp2
  
    jmp notwhitep2
  whitep2:                    
    call DrawFrameRed                ;highlight because it is white (could be attacked)
  notwhitep2:

add cx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty                      ;(jump if empty piece)

    jmp notempty
  empty:                    
    call DrawFrameRed              ;highlight because it is empty (could move to it)
    jmp lowerIsEmpty
  notempty:
  add dx,25                        ;To cancel drawing in lower lower


lowerIsEmpty:

add dx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower lower 
cmp dx,75
jne notempty2 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty2                      ;(jump if empty piece)
  
   jmp notempty2
  empty2:                    
    call DrawFrameRed                ;highlight because it is empty (could move to it)
  notempty2:

pop dx
pop cx
ret
ValidateBPawn  endp


;--------------------------------------------validate black Rook ----------------------------------------
ValidateBRook proc
push cx
push dx
push bx

push dx
lower:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR1 

  cmp dx,175                      ;break the loop if dx reaches border
  jl lower
finishR1:
pop dx

push dx
upper:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR2 

  cmp dx,0                        ;break the loop if dx reaches border
  jg upper 
finishR2:
pop dx

push cx
right:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR3 

  cmp cx,175                      ;break the loop if cx reaches border
  jl right 
finishR3:
pop cx

push cx
left:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR4 

  cmp cx,0                      ;break the loop if cx reaches border
  jg left 
finishR4:
pop cx

pop bx
pop dx
pop cx
ret
ValidateBRook  endp

;--------------------------------------------validate black Bishop ----------------------------------------
ValidateBBishop proc
push cx
push dx
push bx

push cx
push dx
lowerright:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25

  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB1 

  cmp cx,175
  jge finishB1
  cmp dx,175
  jnge lowerright                    ;niether cx nor dx reaches border ,so loop again
finishB1:
pop dx
pop cx

push cx
push dx
lowerleft:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB2 

  cmp cx,0
  jle finishB2
  cmp dx,175
  jnge lowerleft                    ;niether cx nor dx reaches border ,so loop again
 finishB2:
pop dx
pop cx

push cx
push dx
upperright:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB3 

  cmp cx,175
  jge finishB3
  cmp dx,0
  jnle upperright                    ;niether cx nor dx reaches border ,so loop again
 finishB3:
pop dx
pop cx

push cx
push dx
upperleft:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                       ;break the loop if reaching a piece
  je finishB4 

  cmp cx,0
  jle finishB4
  cmp dx,0
  jnle upperleft                    ;niether cx nor dx reaches border ,so loop again
 finishB4:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidateBBishop  endp


;--------------------------------------------validate black Queen ----------------------------------------
ValidateBQueen proc
push cx
push dx
push bx

;main directions (like rook)---------------------------------------------------
push dx
lowerQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ1 

  cmp dx,175
  jl lowerQ 
finishQ1:
pop dx

push dx
upperQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ2 

  cmp dx,0
  jg upperQ 
finishQ2:
pop dx

push cx
rightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ3 

  cmp cx,175
  jl rightQ 
finishQ3:
pop cx

push cx
leftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ4 

  cmp cx,0
  jg leftQ 
finishQ4:
pop cx

;sub directions (like bishop)-----------------------------------------------------------
push cx
push dx
lowerrightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ5 

  cmp cx,175
  jge finishQ5
  cmp dx,175
  jnge lowerrightQ                    ;niether cx nor dx reaches border ,so loop again
finishQ5:
pop dx
pop cx

push cx
push dx
lowerleftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ6 

  cmp cx,0
  jle finishQ6
  cmp dx,175
  jnge lowerleftQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ6:
pop dx
pop cx

push cx
push dx
upperrightQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ7 

  cmp cx,175
  jge finishQ7
  cmp dx,0
  jnle upperrightQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ7:
pop dx
pop cx

push cx
push dx
upperleftQ:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightBlack
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ8 

  cmp cx,0
  jle finishQ8
  cmp dx,0
  jnle upperleftQ                    ;niether cx nor dx reaches border ,so loop again
 finishQ8:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidateBQueen  endp

;--------------------------------------------validate black King ----------------------------------------
ValidateBKing proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,25
  call HighlightBlack

  sub cx,25                             ;the lower position
  call HighlightBlack

  sub cx,25                             ;the lower left position
  call HighlightBlack

  sub dx,25                             ;the left position
  call HighlightBlack

  sub dx,25                             ;the upper left position
  call HighlightBlack

  add cx,25                             ;the upper position
  call HighlightBlack

  add cx,25                             ;the upper right position
  call HighlightBlack

  add dx,25                             ;the right position
  call HighlightBlack

pop dx
pop cx
ret
ValidateBKing  endp

;--------------------------------------------validate black knight ----------------------------------------
ValidateBKnight proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,50
  call HighlightBlack

  sub cx,50                             ;the lower left position
  call HighlightBlack

  sub cx,25                             ;the left lower position
  sub dx,25
  call HighlightBlack

  sub dx,50                             ;the left upper position
  call HighlightBlack

  sub dx,25                             ;the upper left position
  add cx,25
  call HighlightBlack

  add cx,50                             ;the upper right position
  call HighlightBlack

  add cx,25                             ;the right upper position
  add dx,25
  call HighlightBlack

  add dx,50                             ;the right lower position
  call HighlightBlack

pop dx
pop cx
ret
ValidateBKnight  endp

;--------------------------------------------Highlight black pieces----------------------------------------
HighlightBlack proc
push cx
push dx
push bx
push di

mov bx,0000h
mov di,0000h
mov reachingPieceFlag,bl          ;set reachingPieceFlag = 0  (false by default)
  ;check for the borders
  cmp cx,0
  jl finish                       ;do nothing if (cx < 0)
  cmp cx,175
  jg finish                       ;do nothing if (cx > 175)
  cmp dx,0
  jl finish                       ;do nothing if (dx < 0)
  cmp dx,175
  jg finish                       ;do nothing if (dx > 175)

  ;check if white piece in this position
    mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    again:
    cmp bx,di
    je white                      ;(jump if white piece)
    dec di
    cmp di,6
    jne again
  
    jmp notwhite
  white:                    
    call DrawFrameRed             ;highlight because it is white (could be attacked)
      cmp bl,10                   ;check if white king
      jne continuewhite
      wstatusbar wkCheckmate
      continuewhite:
    mov bl,1                      
    mov reachingPieceFlag,bl      ;set reachingPieceFlag = 1  (true)
    jmp finish
  notwhite:
  

  ;check if black piece in this position
    mov di,7
    push di
    convert25toindex
    pop di
    mov bh,0
    againn:
    dec di
    cmp bx,di
    je black                      ;(jump if black piece)
    cmp di,1
    jne againn

    jmp notblack
  black:                          
    mov bl,1
    mov reachingPieceFlag,bl     ;set reachingPieceFlag = 1  (true)
    jmp finish
  notblack:

  call DrawFrameRed                 ;highlight because no white or black
 
  finish:

pop di
pop bx
pop dx
pop cx
ret
HighlightBlack  endp


;--------------------------------Remove any highlights in the board--------------------------------------
removeAnyHighlights proc
push cx
push dx

  ; Function will be called immediately after moving the piece to the new position to remove any highlight
  ; in the board and not to appear in the next piece selection

;black
  mov cx,0000h
  mov dx,0000h

outer:                   ;loop on the y coordinates

  inner:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    jne notHighlghted
    call ClearFrameRed
    notHighlghted:
      cmp cx,175
      je inner_end
      add cx,25
      jmp inner

  inner_end:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outer            

outer_end:
pop dx
pop cx

; push cx
; pop dx
ret
removeAnyHighlights endp
;-------------------------------------------------------------------------------------------------------

removeAnyHighlightswhite proc

push cx
push dx


;white
  mov cx,0
  mov dx,0

outerwk:                   ;loop on the y coordinates

  innerwk:                 ;loop on the x coordinates
    add cx,1
    add dx,1
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    dec cx
    dec dx
    cmp al,01h              ;compare it with the highlighting color(blue)
    jne notHighlghtedwk
    call ClearFrameBlue
    notHighlghtedwk:
      cmp cx,175
      je inner_endwk
      add cx,25
      jmp innerwk

  inner_endwk:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outerwk           

outer_endwk:

pop dx
pop cx
ret
removeAnyHighlightswhite endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------false all The ValidArray-----------------------------------------
falseAllTheValidArray proc
push di

  mov di,64
nextZ:                   ;loop on the index
  dec di
  mov arrvalid[di] , 0
  cmp di,0
  jg nextZ

pop di 

ret
falseAllTheValidArray endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------True The ValidArray---------------------------------------------
TrueTheValidArray proc
push cx
push dx
push di

  mov cx,0000h
  mov dx,0000h

outerT:                   ;loop on the y coordinates

  innerT:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,04h              ;compare it with the highlighting color(red)
    jne notHighlghtedT

    push bx
    convert25toindex
    pop bx
    mov arrvalid[di] , 1

    notHighlghtedT:
      cmp cx,175
      je inner_endT
      add cx,25
      jmp innerT

  inner_endT:
    add dx,25
    mov cx,0 
    cmp dx,175         
    jle outerT            

outer_endT:

pop di
pop dx
pop cx
ret
TrueTheValidArray endp
;-------------------------------------------------------------------------------------------------------

;-------------------------------- Validate the Black piece ---------------------------------------------
validateBlackPiece proc
; To know which white piece to validate and true its validarray
push bx
    push di
    convert25toindex
    pop di
      cmp bl,0 ;check if empty
        je finishHighlighting
      cmp bl,1 ;check if Rook
        je bRook
      cmp bl,2 ;check if kinght
        je bknight
      cmp bl,3 ;check if Bishop
        je bBishop
      cmp bl,4 ;check if Queen
        je bQueen
      cmp bl,5 ;check if King
        je bKing
      cmp bl,6 ;check if Pawn
        je bPawn
        jmp finishHighlighting    ;White piece

      
      bRook:
        call ValidateBRook
        call TrueTheValidArray
        jmp finishHighlighting
      bknight:
        call ValidateBKnight
        call TrueTheValidArray
        jmp finishHighlighting
      bBishop:
        call ValidateBBishop
        call TrueTheValidArray
        jmp finishHighlighting
      bQueen:
        call ValidateBQueen
        call TrueTheValidArray
        jmp finishHighlighting
      bKing:
        call ValidateBKing
        call TrueTheValidArray
        jmp finishHighlighting
      bPawn:
        call ValidateBPawn
        call TrueTheValidArray
        jmp finishHighlighting

   finishHighlighting: 
  pop bx

ret
validateBlackPiece endp
;------------------------------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;white pieces;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;--------------------------------------------validate white Pawn ----------------------------------------
ValidatewPawn proc
push cx
push dx

add cx,25                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper right
sub dx,25
cmp dx,0
jl notempty2                     ; means reaching the last row of the board, So return fom proc
cmp cx,175
jg notblackp1
;check if black piece in this position
mov di,6
    push di
    convert25toindex
    pop di
    mov bh,0
    againp1w:
    cmp bx,di
    je blackp1                      ;(jump if black piece)
    dec di
    cmp di,0
    jne againp1w
  
    jmp notblackp1
  blackp1:                    
    call DrawFrameBlue                ;highlight because it is balck (could be attacked)
  notblackp1:

sub cx,50                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower left
cmp cx,0
jl notblackp2
;check if white piece in this position
mov di,6
    push di
    convert25toindex
    pop di
    mov bh,0
    againp2w:
    cmp bx,di
    je blackp2                      ;(jump if black piece)
    dec di
    cmp di,0
    jne againp2w
  
    jmp notblackp2
  blackp2:                    
    call DrawFrameBlue                ;highlight because it is balck (could be attacked)
  notblackp2:

add cx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je emptyww                      ;(jump if empty piece)

    jmp notemptyww
  emptyww:                    
    call DrawFrameBlue              ;highlight because it is empty (could move to it)
    jmp upperIsEmptyww
  notemptyww:
  sub dx,25                        ;To cancel drawing in upper upper


upperIsEmptyww:

sub dx,25                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper upper 
cmp dx,100
jne notempty2ww 
;check if empty position
    push di
    convert25toindex
    pop di
    mov bh,0
    cmp bx,0
    je empty2ww                      ;(jump if empty piece)
  
   jmp notempty2ww
  empty2ww:                    
    call DrawFrameBlue                ;highlight because it is empty (could move to it)
  notempty2ww:

pop dx
pop cx
ret
ValidatewPawn  endp


;--------------------------------------------validate white Rook ----------------------------------------
ValidatewRook proc
push cx
push dx
push bx

push dx
lowerw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR1w 

  cmp dx,175                      ;break the loop if dx reaches border
  jl lowerw
finishR1w:
pop dx

push dx
upperw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR2w

  cmp dx,0                        ;break the loop if dx reaches border
  jg upperw 
finishR2w:
pop dx

push cx
rightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR3w 

  cmp cx,175                      ;break the loop if cx reaches border
  jl rightw 
finishR3w:
pop cx

push cx
leftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishR4w 

  cmp cx,0                      ;break the loop if cx reaches border
  jg leftw 
finishR4w:
pop cx

pop bx
pop dx
pop cx
ret
ValidatewRook  endp

;--------------------------------------------validate white Bishop ----------------------------------------
ValidatewBishop proc
push cx
push dx
push bx

push cx
push dx
lowerrightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25

  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB1w 

  cmp cx,175
  jge finishB1w
  cmp dx,175
  jnge lowerrightw                    ;niether cx nor dx reaches border ,so loop again
finishB1w:
pop dx
pop cx

push cx
push dx
lowerleftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB2w 

  cmp cx,0
  jle finishB2w
  cmp dx,175
  jnge lowerleftw                    ;niether cx nor dx reaches border ,so loop again
 finishB2w:
pop dx
pop cx

push cx
push dx
upperrightw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishB3w 

  cmp cx,175
  jge finishB3w
  cmp dx,0
  jnle upperrightw                    ;niether cx nor dx reaches border ,so loop again
 finishB3w:
pop dx
pop cx

push cx
push dx
upperleftw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                       ;break the loop if reaching a piece
  je finishB4w 

  cmp cx,0
  jle finishB4w
  cmp dx,0
  jnle upperleftw                    ;niether cx nor dx reaches border ,so loop again
 finishB4w:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidatewBishop  endp


;--------------------------------------------validate white Queen ----------------------------------------
ValidatewQueen proc
push cx
push dx
push bx

;main directions (like rook)---------------------------------------------------
push dx
lowerQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lower 
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ1w 

  cmp dx,175
  jl lowerQw 
finishQ1w:
pop dx

push dx
upperQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upper 
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ2w 

  cmp dx,0
  jg upperQw 
finishQ2w:
pop dx

push cx
rightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;right 
  add cx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ3w 

  cmp cx,175
  jl rightQw 
finishQ3w:
pop cx

push cx
leftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;left 
  sub cx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ4w 

  cmp cx,0
  jg leftQw 
finishQ4w:
pop cx

;sub directions (like bishop)-----------------------------------------------------------
push cx
push dx
lowerrightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerright 
  add cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ5w 

  cmp cx,175
  jge finishQ5w
  cmp dx,175
  jnge lowerrightQw                    ;niether cx nor dx reaches border ,so loop again
finishQ5w:
pop dx
pop cx

push cx
push dx
lowerleftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;lowerleft 
  sub cx,25
  add dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ6w 

  cmp cx,0
  jle finishQ6w
  cmp dx,175
  jnge lowerleftQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ6w:
pop dx
pop cx

push cx
push dx
upperrightQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperright 
  add cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ7w 

  cmp cx,175
  jge finishQ7w
  cmp dx,0
  jnle upperrightQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ7w:
pop dx
pop cx

push cx
push dx
upperleftQw:                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;upperleft 
  sub cx,25
  sub dx,25
  
  call HighlightWhite
  mov bl,reachingPieceFlag
  cmp bl , 1                      ;break the loop if reaching a piece
  je finishQ8w 

  cmp cx,0
  jle finishQ8w
  cmp dx,0
  jnle upperleftQw                    ;niether cx nor dx reaches border ,so loop again
 finishQ8w:
pop dx
pop cx

pop bx
pop dx
pop cx
ret
ValidatewQueen  endp

;--------------------------------------------validate white King ----------------------------------------
ValidatewKing proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,25
  call HighlightWhite

  sub cx,25                             ;the lower position
  call HighlightWhite

  sub cx,25                             ;the lower left position
  call HighlightWhite

  sub dx,25                             ;the left position
  call HighlightWhite

  sub dx,25                             ;the upper left position
  call HighlightWhite

  add cx,25                             ;the upper position
  call HighlightWhite

  add cx,25                             ;the upper right position
  call HighlightWhite

  add dx,25                             ;the right position
  call HighlightWhite

pop dx
pop cx
ret
ValidatewKing  endp

;--------------------------------------------validate white knight ----------------------------------------
ValidatewKnight proc
push cx
push dx

  add cx,25                             ;the lower right position
  add dx,50
  call HighlightWhite

  sub cx,50                             ;the lower left position
  call HighlightWhite

  sub cx,25                             ;the left lower position
  sub dx,25
  call HighlightWhite

  sub dx,50                             ;the left upper position
  call HighlightWhite

  sub dx,25                             ;the upper left position
  add cx,25
  call HighlightWhite

  add cx,50                             ;the upper right position
  call HighlightWhite

  add cx,25                             ;the right upper position
  add dx,25
  call HighlightWhite

  add dx,50                             ;the right lower position
  call HighlightWhite

pop dx
pop cx
ret
ValidatewKnight  endp

;--------------------------------------------Highlight white pieces----------------------------------------
HighlightWhite proc
push cx
push dx
push bx
push di

mov bx,0000h
mov di,0000h
mov reachingPieceFlag,bl          ;set reachingPieceFlag = 0  (false by default)
  ;check for the borders
  cmp cx,0
  jl finishww                       ;do nothing if (cx < 0)
  cmp cx,175
  jg finishww                       ;do nothing if (cx > 175)
  cmp dx,0
  jl finishww                       ;do nothing if (dx < 0)
  cmp dx,175
  jg finishww                       ;do nothing if (dx > 175)

  ;check if white piece in this position
    mov di,12
    push di
    convert25toindex
    pop di
    mov bh,0
    againw:
    cmp bx,di
    je whitew                      ;(jump if white piece)
    dec di
    cmp di,6
    jne againw
  
    jmp notwhitew
  whitew:                    
    mov bl,1                      
    mov reachingPieceFlag,bl      ;set reachingPieceFlag = 1  (true)
    jmp finishww
  notwhitew:
  

  ;check if black piece in this position
    mov di,7
    push di
    convert25toindex
    pop di
    mov bh,0
    againnw:
    dec di
    cmp bx,di
    je blackw                      ;(jump if black piece)
    cmp di,1
    jne againnw

    jmp notblackw
  blackw: 
    call DrawFrameBlue             ;highlight because it is black (could be attacked)     
      cmp bl,5                    ;check if black king
      jne continueblack
      bstatusbar bkCheckmate
      continueblack:               
    mov bl,1
    mov reachingPieceFlag,bl     ;set reachingPieceFlag = 1  (true)
    jmp finishww
  notblackw:

  call DrawFrameBlue                 ;highlight because no white or black
 
  finishww:

pop di
pop bx
pop dx
pop cx
ret
HighlightWhite  endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------false all The arrvalidwhite--------------------------------------
falseAllTheValidArrayWhite proc
push di

  mov di,64
nextZw:                   ;loop on the index
  dec di
  mov arrvalidwhite[di] , 0
  cmp di,0
  jg nextZw

pop di 



ret
falseAllTheValidArrayWhite endp
;-------------------------------------------------------------------------------------------------------

;--------------------------------------True The arrvalidwhite-------------------------------------------
TrueTheValidArrayWhite proc
push cx
push dx
push di

  
    
  mov cx,1
  mov dx,1

outerTw:                   ;loop on the y coordinates

  innerTw:                 ;loop on the x coordinates
    
    mov ah,0Dh              ;interrupt to get the pexel color
    int 10H                 ; AL = COLOR
    cmp al,01h              ;compare it with the highlighting color(blue)
    jne notHighlghtedTw
    push bx
    sub cx,1
    sub dx,1
    convert25toindex
    add cx,1
    add dx,1
    pop bx
    
    mov arrvalidwhite[di] , 1

    notHighlghtedTw:
      cmp cx,176
      je inner_endTw
      add cx,25
      jmp innerTw

  inner_endTw:
    add dx,25
    mov cx,1 
    cmp dx,176         
    jle outerTw            

outer_endTw:

pop di
pop dx
pop cx
ret
TrueTheValidArrayWhite endp
;-------------------------------------------------------------------------------------------------------

;-------------------------------- Validate the white piece ---------------------------------------------

validateWhitePiece proc
; To know which white piece to validate and true its validarray
    push bx
    push di
    convert25toindex
    pop di
      cmp bl,0 ;check if empty
        je finishHighlightingw
      cmp bl,7 ;check if Rook
        je wRook50
      cmp bl,8 ;check if kinght
        je wknight50
      cmp bl,9 ;check if Bishop
        je wBishop50
      cmp bl,11 ;check if Queen
        je wQueen50
      cmp bl,10 ;check if King
        je wKing50
      cmp bl,12 ;check if Pawn
        je wPawn50
        jmp finishHighlightingw

      wRook50:
        call ValidatewRook
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wknight50:
        call ValidatewKnight
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wBishop50:
        call ValidatewBishop
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wQueen50:
        call ValidatewQueen
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wKing50:
        call ValidatewKing
        call TrueTheValidArrayWhite
        jmp finishHighlightingw
      wPawn50:
        call ValidatewPawn
        call TrueTheValidArrayWhite
        jmp finishHighlightingw

   finishHighlightingw: 
    pop bx

ret
validateWhitePiece endp
;------------------------------------------------------------------------------------------------------


;-----------------------------------clear Cell With Green Or White--------------------------------------
clearCellWithGreenOrWhite proc
      ; clear the cell in the position (cx,dx) of the piece after move check if even draw Dark green else draw white
push si
push bp
push cx
push dx
push ax
     
     mov si,cx                        ;carry location of x (To know which cell we will clear)
     mov bp,dx                        ;carry location of y
     push bp
     push si                      
      mov dx,0000h
      add si,bp
      mov ax,si
      mov bp,2
      div bp
      
      cmp dl,1
      jz odd1macro
      jmp even1macro
      odd1macro:
     pop si 
     pop bp
    
    drawpicture GreenCellFilename,GreenCellFilehandle,25,25,GreenCellData,si,bp ;Green cell 
      jmp pass1macro
      even1macro:
     mov si,0000h
     mov bp ,0000h
     pop si 
     pop bp
     drawpicture GreyCellFilename,GreyCellFilehandle,25,25,GreyCellData,si,bp ;Grey cell  
      pass1macro:
  
  pop ax
  pop dx
  pop cx
  pop bp
  pop si

  ret
  clearCellWithGreenOrWhite endp
;--------------------------------------------Timer -------------------------------------------

   ; Timer
  checkTimer proc
   
 push bx 
 push cx 
 push dx
   
 mov AH,2Ch
     int 21h
     mov currentTime,dh
     mov bl,currentTime     ;To compere with the previous second
     cmp bl ,previousTime
     pop dx
     pop cx
     jz exitcheckTimer
    

    cmp TimerArray[0],3
    jae inc0
     inc TimerArray[0]       ;can be done through loop 
    inc0: 

     cmp TimerArray[1],3
    jae inc1
     cmp TimerArray[1],0       ;complete clock     

     inc TimerArray[1]       
    inc1: 

    cmp TimerArray[2],3
    jae inc2
     inc TimerArray[2]       
    inc2:  

    cmp TimerArray[3],3
    jae inc3
     inc TimerArray[3]       
    inc3:  

    cmp TimerArray[4],3
    jae inc4
     inc TimerArray[4]       
    inc4:  

    cmp TimerArray[5],3
    jae inc5
     inc TimerArray[5]       
    inc5:  

     cmp TimerArray[6],3
    jae inc6
     inc TimerArray[6]       
    inc6:  
    
    cmp TimerArray[7],3
    

    jz inc7
               ;come snow
     inc TimerArray[7]       
    inc7:  
    

    cmp TimerArray[8],3
    jae inc8
     inc TimerArray[8]       
    inc8:  

     cmp TimerArray[9],3
    jae inc9
     inc TimerArray[9]       
    inc9:  

     cmp TimerArray[10],3
    jae inc10
     inc TimerArray[10]       
    inc10:  

     cmp TimerArray[11],3
    jae inc11
     inc TimerArray[11]       
    inc11:  

    cmp TimerArray[12],3
    jae inc12
     inc TimerArray[12]       
    inc12:  

    cmp TimerArray[13],3
    jae inc13
     inc TimerArray[13]       
    inc13:  

     cmp TimerArray[14],3
    jae inc14
     inc TimerArray[14]       
    inc14:  

     cmp TimerArray[15],3
    jae inc15
     inc TimerArray[15]       
    inc15:  

 



     cmp TimerArray[16],3
      
      

    jae inc16
   
      push cx 
      push dx
      mov cx ,0000
      mov dx ,50
      push bx 
      push di
      convert25toindex
      call CheckWhichToDrawForTimer
      ;FullTime
      ; cmp TimerArray[16],0
      ; jz notFullTime      
      
      ;  notFullTime:

      ; ;TWo Third
       cmp TimerArray[16],1
       jz notTWoThird      
       drawpicture  TwoThirdtimeFilename,TwoThirdtimeFilehandle,TwoThirdtimeWidth,TwoThirdtimeHeight,TwoThirdtimeData,0000,50
       notTWoThird:
      ;One Third
       cmp TimerArray[16],2
       jz notoneThird      
       drawpicture  oneThirdtimeFilename,oneThirdtimeFilehandle,oneThirdtimeWidth,oneThirdtimeHeight,oneThirdtimeData,0000,50
       notoneThird:
       ;Zero waitTime
      
      pop di
      pop bx
    pop dx 
    pop cx
     inc TimerArray[16]       
    inc16:      
    cmp TimerArray[17],3
    jae inc17
     inc TimerArray[17]       
    inc17:  
    cmp TimerArray[18],3
    jae inc18
     inc TimerArray[18]       
    inc18:  
     cmp TimerArray[19],3
    jae inc19
     inc TimerArray[19]       
    inc19:  
     cmp TimerArray[20],3
    jae inc20
     inc TimerArray[20]       
    inc20:  
     inc TimerArray[21]
     inc TimerArray[22]    
     inc TimerArray[23]
     inc TimerArray[24]
     inc TimerArray[25]
     inc TimerArray[26]
     inc TimerArray[27]
     inc TimerArray[28]
     inc TimerArray[29]
     inc TimerArray[30]
     inc TimerArray[31]


     inc TimerArray[32]    ;can be done through loop 
     inc TimerArray[33]
     inc TimerArray[34]
     inc TimerArray[35]
     inc TimerArray[36]
     inc TimerArray[37]
     inc TimerArray[38]    
     inc TimerArray[39]
     inc TimerArray[40]
     inc TimerArray[41]
     inc TimerArray[42]
     inc TimerArray[43]
     inc TimerArray[44]
     inc TimerArray[45]
     inc TimerArray[46]
     inc TimerArray[47]

     inc TimerArray[48]    ;can be done through loop 
     inc TimerArray[49]
     inc TimerArray[50]
     inc TimerArray[51]
     inc TimerArray[52]
     inc TimerArray[53]
     inc TimerArray[54]    
     inc TimerArray[55]
     inc TimerArray[56]
     inc TimerArray[57]
     inc TimerArray[58]
     inc TimerArray[59]
     inc TimerArray[60]
     inc TimerArray[61]
     inc TimerArray[62]
     inc TimerArray[63]

exitcheckTimer:
mov previousTime,bl
pop bx

ret
checkTimer   endp
;-------------------------------------------------------------------------------------------

;----------------------------------- CheckWhichToDrawForTimer -----------------------------
CheckWhichToDrawForTimer proc 

mov bl ,arrayboard[di]
 cmp bl,6
 jnz DontDrwpawn
 call clearCellWithGreenOrWhite
 Drawpiece blackpawnData
 DontDrwpawn:

ret 
 CheckWhichToDrawForTimer endp
 ;-------------------------------------------------------------------------------------------

;--------------------------------------drawFullTimer-----------------------------------------
 drawFullTimer proc
  mov cx,0000h
  mov dx,0050h
  ret
drawFullTimer  endp
  ;----------------------------------------------------------------------------------------------------------
  
  ;--------------------------------------------Clear the buffer ---------------------------------------------
  clearkeyboardbuffer		proc	

	mov ax,0C00h ;equivalent of "mov ah,0Ch mov al,0"
  int 21h

	ret
  clearkeyboardbuffer		endp
  ;----------------------------------------------------------------------------------------------------------

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;                                             MAIN SCREEN                                                 ;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mainscreen proc

push ax
push bx
push cx
push dx
push si
push di
push bp

    mov ah, 0
    mov al, 3h
    int 10h 

stringcolour mes,1330,26,0fh ;prints 1st message
stringcolour mes1,1650,26,0fh ;prints 2nd message
stringcolour mes2,1970,28,0fh ;prints 3rd message
    
mov ah,2  ;moves the cursor for the notification bar
mov dl,0  ;x coordinate   
mov dh,20 ;y coordinate
int 10h ;executes the interrupt
    
mov ah, 9h ;display --- of the notification bar  
mov dx, offset mes3 ;message to be displayed
int 21h ;executes the interrupt



select: ;label to check for selected key
mov ah,0 ;waits for user click (F1,F2,ESC)
int 16h ;executes the interrupt
cmp al,27d ;ascii of esc  
jz terminate ;esc function
cmp ah,3Bh
jz chat
cmp ah,3Ch
jz game
jmp select
;;;;;;;;;;;;;;;;;;;;;;;for chat mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chat:
mov ah,2  
mov dl,1
mov dh,21
int 10h 

mov ah, 9h  
lea dx, username+2
int 21h 

mov ah,2  
mov dl,0
mov dh,22
int 10h 

mov ah, 9h  
mov dx, offset mes4
int 21h 

mov ah, 9h  
lea dx, username1+2
int 21h 

mov ah,2  
mov dl,0 
mov dh,24 
int 10h 
    
mov ah, 9h
mov dx, offset mes6
int 21h 

mov ah,2  
mov dl,48
mov dh,24 
int 10h 

select1:
mov ah,0
int 16h 
cmp al,27d 
jz terminate 
cmp ah,3Bh
jz chat
cmp ah,3Ch
jz game
jmp select1
;;;;;;;;;;;;;;;;;;;;;;for game mode;;;;;;;;;;;;;;;;;;;;;;;;;;
game:
mov ah,2  
mov dl,1
mov dh,21
int 10h 

mov ah, 9h  
lea dx, username+2
int 21h 

mov ah,2  
mov dl,0
mov dh,22
int 10h 

mov ah, 9h  
mov dx, offset mes5
int 21h 

mov ah, 9h  
lea dx, username1+2
int 21h 

mov ah,2  
mov dl,0 
mov dh,24 
int 10h 
    
mov ah, 9h
mov dx, offset mes7
int 21h 
;;;;;;;;;;;;;;;;;;waits for user click;;;;;;;;;;;;;;;;;;;
select2: 
mov ah,0
int 16h 
cmp al,27d 
jz terminate 
cmp ah,3Bh
jz chat
cmp ah,3Ch
jz game1
cmp ah,3Dh              ;f3
jz continuegame
jmp select2

terminate: ;label for termination
mov ah,4Ch ;terminates the program
int 21h  ;executes the interrupt

game1:

pop bp
pop di
pop si
pop dx
pop cx
pop bx
pop ax

continuegame:

call initializeTheGame
call move
ret
mainscreen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                             SERIAL                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INITIALIZEUART PROC NEAR
		;SET DIVISOR LATCH ACCESS BIT
		MOV DX,3FBH 			; LINE CONTROL REGISTER
		MOV AL,10000000B		;SET DIVISOR LATCH ACCESS BIT
		OUT DX,AL				;OUT IT

		;SET LSB BYTE OF THE BAUD RATE DIVISOR LATCH REGISTER.
		MOV DX,3F8H			
		MOV AL,0CH			
		OUT DX,AL

		;SET MSB BYTE OF THE BAUD RATE DIVISOR LATCH REGISTER.
		MOV DX,3F9H
		MOV AL,00H
		OUT DX,AL

		;SET PORT CONFIGURATION
		MOV DX,3FBH
		MOV AL,00011011B
			;0:ACCESS TO RECEIVER BUFFER, TRANSMITTER BUFFER
			;0:SET BREAK DISABLED
			;011:EVEN PARITY
			;0:ONE STOP BIT
			;11:8BITS
		OUT DX,AL
		RET
	INITIALIZEUART ENDP

END MAIN