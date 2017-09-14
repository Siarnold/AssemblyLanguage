NAME EX7_3_1
DATA SEGMENT
    ADDRESS EQU 0280H
DATA ENDS
STACK SEGMENT PARA STACK
      DB 100 DUP(?)
STACK ENDS
CODE SEGMENT
  ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK 

; delay
DELAY  PROC    FAR
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

; main
START: MOV AX,DATA
       MOV DS,AX
       MOV ES,AX                 
; initialize 8255
    MOV AL,10000000B; method 0£¬A/C output
    MOV DX,ADDRESS+3    
    OUT DX,AL
LOOPER:   
    MOV AH,1; keyboard read in 
    INT 16H
    JNZ READ
    
    MOV DX,ADDRESS; clear
    MOV AL,00H
    OUT DX,AL 
    MOV DX,ADDRESS+2; select 1
    MOV AL,00000001B
    OUT DX,AL
    MOV DX,ADDRESS
    MOV AL,00111111B; output 0
    OUT DX,AL
    CALL DELAY
    
    MOV DX,ADDRESS; clear 
    MOV AL,00H
    OUT DX,AL
    MOV DX,ADDRESS+2; select 2
    MOV AL,00000010B
    OUT DX,AL
    MOV DX,ADDRESS; output 1
    MOV AL,00000110B
    OUT DX,AL
    CALL DELAY
    
    JMP LOOPER
READ:
    MOV AH,0; keyboard read in
    INT 16H
    CMP AL,0EH
    JNE ENDD
    JMP LOOPER
ENDD:
    MOV AH,4CH
    INT 21H
CODE ENDS
END START


