NAME TEST1_2

DATA SEGMENT
BUFFER1     DB  0,1,2,3,4,5,6,7,8,9
            DB  0AH, 0BH, 0CH, 0DH, 0EH, 0FH    ;数据区填入00H~0FH
BUFFER2     DB  10H DUP(0)                      ;填入16个00H
MESS        DB  'HAVE DONE', 13, 10, '$'        ;填入字符串
DATA ENDS

STACK SEGMENT PARA STACK
            DB 100 DUP(?)   ;为堆栈开256个字节的空间
STACK ENDS

CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:  MOV AX,DATA
        MOV DS,AX
        MOV ES,AX           ;设置基本的数据段位置
        
        LEA SI,BUFFER1
        LEA DI,BUFFER2      ;取得BUFFER[1,2]的偏移地址
        MOV CX,10H          ;重复16次
NEXT:   MOV AL,[SI]
        MOV [DI],AL         ;转移数据
        INC SI
        INC DI
        DEC CX              ;更新偏移地址和计数器
        JNZ NEXT            ;循环跳转
        
        LEA DX,MESS
        MOV AH,9            ;系统调用:输出字符串
        INT 21H
        
        MOV AH,4CH          ;系统调用:正常退出
        INT 21H
CODE ENDS

END START