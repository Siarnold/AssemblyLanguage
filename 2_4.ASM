NAME EX2_4
;Copyleft(c), Siarnold, 2017

DATA    SEGMENT
        M1 DB '4572'
        M2 DB '3'
        PRD DB 4 DUP(0)
DATA    ENDS
STACK   SEGMENT PARA STACK
        DB 100 DUP(?)
STACK   ENDS
CODE    SEGMENT
        ASSUME DS:DATA, ES:DATA, SS:STACK, CS:CODE
START:  MOV AX, DATA; the old 3 lines
        MOV DS, AX
        MOV ES, AX
        
        MOV BL, [M2];change ASCII to number
        SUB BL, 30H
        
        LEA SI, M1
        LEA DI, PRD
        MOV CX, 4
        
LOOP1:  MOV AL, [SI]
        SUB AL, 30H
        MUL BL
        AAM;ascii adjustment   
        INC SI
     
        ADD AL, [DI]; DI store the carry
        AAA
        MOV [DI], AL
        
        INC DI
        MOV [DI], AH; need not clear AH
        ;'cause MUL gets a 16-bit result
        LOOP LOOP1
        
        LEA DI, PRD
        MOV CX, 4

LOOP2:  ADD BYTE PTR [DI], 30H; DI ascii adjust
        INC DI
        LOOP LOOP2
        
        MOV AH, 4CH;the old 2 lines
        INT 21H
CODE    ENDS
END     START