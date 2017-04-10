NAME TEST1_2 ;16位BCD加减

DATA SEGMENT
    NUM1 DB 0,0 ;数字1
    NUM2 DB 0,0 ;数字2
    NUM3 DB 0,0 ;和
    NUM4 DB 0,0 ;差
DATA ENDS

STACK SEGMENT PARA STACK
    DB 10H DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME DS:DATA, ES:DATA, SS:STACK, CS:CODE
START:
    
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX
    
    ;ADD:
    LEA BX,NUM1
    LEA DI,NUM2
    LEA SI,NUM3
    CLC
    MOV CX,2
LOOP1:
    MOV AL,[BX]
    MOV DL,[DI]
    ADC AL,DL ;加法
    DAA       ;加法修正
    MOV [SI],AL
    INC BX
    INC DI
    INC SI
    LOOP LOOP1

    ;SUB
    LEA BX,NUM1
    LEA DI,NUM2
    LEA SI,NUM4
    CLC
    MOV CX,2
LOOP2:
    MOV AL,[BX]
    MOV DL,[DI]
    SBB AL,DL ;减法
    DAS       ;减法修正
    MOV [SI],AL
    INC BX
    INC DI
    INC SI
    LOOP LOOP2
    
    INT 3 ;结束
    
CODE ENDS

END START