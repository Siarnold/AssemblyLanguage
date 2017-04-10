NAME TEST1_3

DATA SEGMENT
NUMH DB 10H DUP(?) ;为数据开空间
DATA ENDS

STACK SEGMENT PARA STACK
    DB 10H DUP(?)  ;为堆栈开空间
STACK ENDS    

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:  
    
        LEA SI,NUMH ;取得偏移地址
        MOV AX,30H
        MOV CX,10   ;第一次循环:30H到39H共10次
LOOP1:  MOV [SI],AX
        INC SI
        INC AX
        LOOP LOOP1

        MOV AX,41H
        MOV CX,6    ;第二次循环:41H到46H共6次
LOOP2:  MOV [SI],AX
        INC SI
        INC AX
        LOOP LOOP2

        INT 3
        
CODE ENDS

END START