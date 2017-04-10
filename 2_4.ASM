NAME TEST2_2 ;ASCII乘法

DATA SEGMENT 
    NUM1 DB '9876'
    NUM2 DB '9' , 3 DUP(0)
    NUM3 DB 8 DUP(0)
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA, ES:DATA, CS:CODE
START:
    MOV AX,DATA
    MOV DS,AX
    MOV ES,AX
    
    MOV BL,BYTE PTR NUM2
    SUB BL,30H
    
    LEA SI,NUM1
    LEA DI,NUM3
    MOV CX,4
    
LOOP1:
    MOV AL,[SI]
    SUB AL,30H ;ASCII数字修正
    MUL BL
    AAM        ;乘法调整
    
    ADD AL,[DI]
    AAA
    MOV [DI],AL ;加上上一位的进位
    
    ;ADC AH,0
    INC DI
    MOV [DI],AH ;存储这一位的进位
    
    INC SI
    
    LOOP LOOP1
   
   
    LEA DI,NUM3
    MOV CX,4
LOOP2:
    MOV AL,[DI]
    ADD AL,30H
    MOV [DI],AL
    INC DI
    LOOP LOOP2
    
    MOV AL,[DI]
    OR AL,AL
    JZ FINISH
    ADD AL,30H
    MOV [DI],AL
    
FINISH:    
   
    INT 3
CODE ENDS
END START