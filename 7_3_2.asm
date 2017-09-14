NAME EX7_3_2

DATAS SEGMENT
NUM DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
DATAS ENDS

STACKS SEGMENT
   DB 100 DUP(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV DX,283H         ; set control word
    MOV AL,10000000B
    OUT DX,AL

    MOV BX,0
    MOV CX,0
MAIN:
    MOV AH,0BH        ; check keyboard
    INT 21H
    INC AL
    JNE NEXT
    
    MOV AH,1        ; type the higher digit
    INT 21H
    CMP AL,'0'
    JS EXIT
    CMP AL,'9'+1
    JNS EXIT
    SUB AL,30H
    MOV BL,AL
   
    MOV AH,1        ; type the lower digit
    INT 21H
    CMP AL,'0'
    JS EXIT
    CMP AL,'9'+1
    JNS EXIT 
    SUB AL,30H
    MOV CL,AL

CALL DELAY        ; delay
CALL DELAY        ; delay 
CALL DELAY        ; delay

NEXT:

; output 0
    MOV DX,280H
    PUSH BX
    MOV BX,CX
    MOV AL,[NUM+BX]
    OUT DX,AL        ; port A output 0
    MOV DX,282H
    MOV AL,01H
    OUT DX,AL
    POP BX
    
    CALL DELAY        ; delay

; shut down two digits
    MOV DX,282H
    MOV AL,00H
    OUT DX,AL    
    
; output 1    
    MOV DX,280H
    MOV AL,[NUM+BX]
    OUT DX,AL
    MOV DX,282H
    MOV AL,02H
    OUT DX,AL
    
    CALL DELAY        ; delay 

; shut down two digits 
    MOV DX,282H
    MOV AL,00H
    OUT DX,AL     
    JMP MAIN  
  
EXIT:  
    MOV AH,4CH
    INT 21H


; delay 
DELAY  PROC    ; FAR
       PUSH    CX
       PUSH    AX
       MOV    AX,000FH
X1:    MOV    CX,0FFFH
X2:    DEC    CX
       JNE    X2
       DEC    AX
       JNE    X1
       POP    AX
       POP    CX
       RET
DELAY  ENDP  
    
CODES ENDS
END START
