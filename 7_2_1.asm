NAME 7_2_1

DATA SEGMENT
    KEEP_IP DW 0
    KEEP_CS DW 0
DATA ENDS

STACK SEGMENT PARA STACK
    DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
  ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK 

; interrupt vector
INTR PROC FAR
    STI
    
    MOV DX, 280H   
    IN AL, DX
    
    CMP AL, 0FFH
    JZ EXIT
    
    MOV DL, AL
    MOV AH, 2
    INT 21H
    
    MOV AL, 20H
    OUT 20H, AL
    
    IRET
INTR ENDP

; main
START: 
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX

    ; protect initial interrupt vector
    PUSH DS
    MOV AH, 35H   
    MOV AL, 0BH   
    INT 21H       
    MOV KEEP_IP, BX  
    MOV KEEP_CS, ES
    POP DS                                     

    PUSH DS                    
    MOV DX, OFFSET INTR
    MOV AX, SEG INTR
    MOV DS, AX
    MOV AH, 25H 
    MOV AL, 0BH   ;IRQ3            
    INT 21H
    POP DS  

    MOV AL, 11110111B   ;IRQ3
    OUT 21H, AL   

    MOV AL, 10110000B   ; A Method 1; A input; C(7-4) output; B Method 0; B output; C(3-0) output
    MOV DX, 283H    
    OUT DX, AL

LOOP_0:
    CMP AL, 0FFH
    JNZ LOOP_0

EXIT:        
    ; get interrupt vector back
    PUSH DS    
    MOV DX, KEEP_IP            
    MOV AX, KEEP_CS            
    MOV DS, AX
    MOV AH, 25H
    MOV AL, 0BH  ;IRQ3               
    INT 21H                    
    POP DS  
    MOV AH, 4CH
    INT 21H

CODE ENDS
END START
