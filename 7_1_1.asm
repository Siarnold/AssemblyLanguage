NAME EX7_1_1

DATA SEGMENT
DATA ENDS

STACK SEGMENT PARA STACK
      DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
  ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK

; Main
START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX

    MOV AL,10010000B ; A Method 0; A input; C(7-4) output; B Method 0; B output; C(3-0) output
    MOV DX,283H
    OUT DX,AL

LOOP_1:
    MOV DX,280H
    IN AL,DX
    MOV DX,282H
    OUT DX,AL
    
    MOV AH,1
    INT 16H   ; check keyboard 
    JZ LOOP_1 
    
    MOV AH,0
    INT 16H    
    CMP AL,' ' 
    JZ QUIT
    JMP LOOP_1
    
QUIT:
    MOV AH,4CH
    INT 21H
    
CODE ENDS
END START