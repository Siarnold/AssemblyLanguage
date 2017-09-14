NAME EX6_2

DATA SEGMENT
MSG0 DB 0DH, 0AH, '$'
MSG1 DB 'D/A    A/D', 0DH, 0AH, '$'
MSG2 DB  '     ', '$' 
HEX DB '0123456789ABCDEF'
NUM DB 0
DATA ENDS

STACKS SEGMENT PARA STACK   
    DB    1024 DUP(?)
STACKS ENDS

; macro to print messages
PRINTMSG MACRO NUM
    PUSH AX
    PUSH DX
    MOV AH,9
	MOV DX,OFFSET MSG&NUM
	INT 21H
    POP DX
    POP AX
ENDM

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACKS

; delay
DELAY PROC NEAR
    PUSH AX        
    MOV AX,0FFFFH
DELAY_1: DEC AX
    JNZ DELAY_1
    POP AX
    RET
DELAY ENDP 

; DISPLAY SINGLE NUMBER
DISPLAY_NUM16 PROC NEAR
    PUSH SI
    PUSH AX
    PUSH DX
    
    AND AX,00FFH
    LEA SI,HEX
    ADD SI,AX
    
    MOV DL,[SI]
    MOV AH,2
    INT 21H
    
    POP DX
    POP AX
    POP SI
    RET 
DISPLAY_NUM16 ENDP

; DISPLAY NUMBER
DISPLAY PROC NEAR
    PUSH DX
    PUSH CX
    PUSH AX
    
    MOV DL, AL
    
    ;display higher number 
    MOV CL, 4
    SHR AL, CL
    AND AL, 0FH
    CALL DISPLAY_NUM16    
    
    ;display lower number
    MOV AL, DL
    AND AL, 0FH
    CALL DISPLAY_NUM16
    
    POP AX
    POP CX
    POP DX
    
    RET
DISPLAY ENDP

; Main
START:
    MOV AX,DATA
    MOV DS,AX        
    MOV ES,AX 
INPUT:    
    MOV AH,0  ; read keyboard
    INT 16H
    
    CMP AL,'C'
    JZ TRANS
    CMP AL,'c'
    JZ TRANS
    
    CMP AL,'E'
    JZ QUIT
    CMP AL,'e'
    JZ QUIT
    
    JMP INPUT
    
TRANS:
    PRINTMSG 0
    PRINTMSG 1
    
    MOV CX,20
TRANS1:
    ; D/A
    MOV AL,NUM
    ADD AL,11H
    MOV NUM,AL
    CALL DISPLAY  
    PRINTMSG 2 
    MOV DX,280H
    OUT DX,AL 
    CALL DELAY 
    
    ; A/D
    MOV DX,289H        
    OUT DX,AL
    CALL DELAY
    MOV DX,289H
    IN AL,DX  
    CALL DISPLAY
    PRINTMSG 0
    LOOP TRANS1
    
    JMP INPUT

QUIT:    
    MOV AH,4CH
    INT 21H    
    
CODE ENDS
END START
