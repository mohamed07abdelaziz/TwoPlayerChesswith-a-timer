SCROLL MACRO X, Y, EX, EY
	MOV AX, 0601h    ; Scroll up function
	MOV CH, Y     ; Upper left corner CH=row, CL=column
	MOV CL, X
	MOV DH, EY   ; lower right corner DH=row, DL=column
	MOV DL, EX
	MOV BH, 07    
	INT 10H
ENDM SCROLL


SENDING MACRO VALUE
LOCAL AGAINsend
;PUSHA
;Check that Transmitter Holding Register is Empty
	mov dx,3FDH		; Line Status Register
AGAINsend:
	In al,dx 			;Read Line Status
  	AND al,00100000b
  	JZ AGAINsend

;If empty put the VALUE in Transmit data register
  	mov dx,3F8H		; Transmit data register
  	mov al,VALUE
  	out dx,al 
;POPA
ENDM SENDING

RECEIVING MACRO VALUE
	;PUSHA
  ;CHECK THAT DATA READY
  MOV DX,3FDH		; LINE STATUS REGISTER
  IN AL,DX 
  AND AL,1
  JNZ READ 
  JMP FINISHrec

  READ:
  ;IF READY READ THE VALUE IN RECEIVE DATA REGISTER
	MOV DX,03F8H
	IN AL,DX 
	MOV VALUE,AL

  FINISHrec:
	;POPA
ENDM RECEIVING


setCursor MACRO x,y
mov ah,2
mov bh,0
mov dl,x
mov dh,y
int 10h
ENDM setCursor

.MODEL SMALL
.STACK 64
.DATA
 
    LINE  DB 80 DUP('-'),'$'
    value db ?
    ys db 0
    xs db 0
    xr db 0
    yr db 0DH
    SPACE DB ' ', '$'
    CHAR DB '$', '$'
    RECCHAR DB '$', '$'

.CODE

main proc far
mov   ax,@data
mov   ds,ax
     

CALL INITIALIZATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 CALL CLEAR

 setCursor 0,0Ch
            
 mov ah, 9
 mov dx, offset LINE
 int 21h

setCursor   0,0
 ;call detect

detect:
  MOV RECCHAR, '$'
 mov  ah,1                 ;check if a key is pressed
  int   16h
 jz  temp
 jnz   send

 ;;;;;;;;;;;;;;;;;;
 send:       
 mov ah,0                 ;clear the keyboard buffer
int 16h

 mov CHAR,al
 CMP ah,1ch               ; check if the key is enter
jz  newline

CMP AL, 08 ;BACKSPACE
JZ temp2


MOV CHAR, AL
				setCursor xs, ys
				MOV SI, OFFSET CHAR
				CALL DISPLAYMESSAGE
				SENDING CHAR

    inc xs
				CMP xs, 80
				JE akhrsatr
				BACKSEND:
				JMP recieve
                temp:
                jmp recieve
akhrsatr:
        MOV xs, 0
				INC ys
				CMP ys, 12
				JE khlst
				BACKakhrsatr:
				JMP BACKSEND
			khlst:
				SCROLL 0, 0, 79, 11
				MOV ys, 11
				JMP BACKakhrsatr
temp2:
jmp BACKSPACE
 newline:    
 inc  ys
mov xs,0
CMP ys, 12
				JE linegded
				CONTSEN:
				setCursor xs, ys
				SENDING 0CH
				JMP endsend
linegded:
				SCROLL 0, 0, 79, 11
				MOV ys, 11
				JMP CONTSEN
temp3:
jmp detect
BACKSPACE:
setCursor xs, ys
				MOV SI, OFFSET SPACE
				CALL DISPLAYMESSAGE
				DEC xs
				setCursor xs, ys
				SENDING SPACE
				JMP endsend

endsend:

recieve:     
        RECEIVING RECCHAR
				CMP RECCHAR, '$'
				JE temp3
				
				CMP RECCHAR, 0CH
				JE enterr
				
				CMP RECCHAR, 32
				JE BACKSPACERER
				
				setCursor xr, yr
				MOV SI, OFFSET RECCHAR
				CALL DISPLAYMESSAGE
				INC xr
				CMP xr, 80
				JE akhrsatr2
				BACKSENDREC:
				JMP detect
				
			enterr:        
				MOV xr, 0
				inc yr
				CMP yr, 24
				JE linegded2
				CONT_RES:
				setCursor xr, yr
				JMP detect
				
			BACKSPACERER:
				setCursor xr, yr
				MOV SI, OFFSET SPACE
				CALL DISPLAYMESSAGE
				DEC xr
				setCursor xr, yr
				JMP detect
				
			linegded2:
				SCROLL 0, 0DH, 79, 24
				setCursor 0, 12
				;MOV SI, OFFSET SPLIT
				;CALL DISPLAYMESSAGE
				MOV yr, 23
				JMP CONT_RES
				
			akhrsatr2:
				MOV xr, 0
				INC yr
				CMP yr, 24
				JE khlst2
				akhrsatr2back:
				JMP BACKSENDREC
				
			khlst2:
				SCROLL 0, 0DH, 79, 24
				setCursor 0, 12
				;MOV SI, OFFSET SPLIT
				;CALL DISPLAYMESSAGE
				MOV yr, 23
				JMP akhrsatr2back
	
		JMP detect
hlt
main endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


INITIALIZATION PROC 
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
	INITIALIZATION ENDP

   CLEAR PROC 
		MOV AX, 0600h    ; Scroll up function
		MOV CX,0     ; Upper left corner CH=row, CL=column
		MOV DX, 184FH  ; lower right corner DH=row, DL=column
		MOV BH, 07    
		INT 10H
		RET
	CLEAR ENDP
DISPLAYMESSAGE PROC
		MOV AH, 9		;Display string function
		MOV DX, SI		;offset of the string
		INT 21H			;execute
		RET
	DISPLAYMESSAGE ENDP
    end MAIN