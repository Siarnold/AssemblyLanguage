NAME EX_7_3_2

DATA SEGMENT
KEEPIP DW 0
KEEPCS DW 0
DATA ENDS

STACK SEGMENT
    DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START: 

    MOV AX,DATA    
    MOV DS,AX
    MOV ES,AX
; set 8253
    MOV DX,293H
    MOV AL,00110111B
    OUT DX,AL
    
    MOV DX,290H
    MOV AL,90
    OUT DX,AL
    OUT DX,AL

; set 8255
    MOV DX,283H         ; set control word 
    MOV AL,10000000B
    OUT DX,AL       

; change interrupt vector 
    MOV AH,35H                ; get the add of interrupt vector 
    MOV AL,0BH
    INT 21H
    MOV KEEPIP,BX            ; protect the interrupt vector 
    MOV KEEPCS,ES
        
    PUSH DS                    ; change the interrupt vector 
    MOV DX,OFFSET INTR
    MOV AX,SEG INTR
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
        
; cancel the mask of IRQ3
    IN AL,21H
    AND AL,011110111B
    OUT 21H,AL           
    
    MOV BL,0
MAIN:                                   ; iterate
    HLT
    MOV AH,1
    INT 16H            ; if keyboard inputs, exit
    JNE EXIT
    JMP MAIN

EXIT:
; restore the mask of IRQ3
    IN  AL,21H
    OR  AL,00001000B
    OUT 21H,AL
        
; restore interrupt vector 
    PUSH DS
    MOV DX,KEEPIP
    MOV AX,KEEPCS
    MOV DS,AX
    MOV AH,25H
    MOV AL,0BH
    INT 21H
    POP DS
    
    MOV AH,4CH                ; return to DOS
    INT 21H


INTR PROC ; interrupt vector
; shutdown two digits

    MOV DX,282H
    MOV AL,00H
    OUT DX,AL

    CMP BL,0
    JNZ OUT1
OUT0:
    MOV DX,280H
    MOV AL,3FH
    OUT DX,AL        ; port A output 
    MOV DX,282H
    MOV AL,01H
    OUT DX,AL
    MOV BL,1
    JMP END_INTR
OUT1:
; output 1  
    MOV DX,280H
    MOV AL,06H
    OUT DX,AL
    MOV DX,282H
    MOV AL,02H
    OUT DX,AL
    MOV BL,0
    JMP END_INTR
 
END_INTR:
    MOV AL,20H                    ; send out EOI 
    OUT 0A0H,AL
    OUT 20H,AL
IRET
INTR ENDP


CODE ENDS
END START    
