NAME    EX2_2;add and subtract of two 16-bit BCD numbers
;Copyleft(c), Siarnold, 2017

DATA    SEGMENT
        A1 DB 83H, 05H; adder one = 0583D
        A2 DB 74H, 02H; adder two = 0274D
        SUM DB 2 DUP(?)
        DIF DB 2 DUP(?)
DATA    ENDS
STACK   SEGMENT PARA STACK
        DB 100 DUP(?)
STACK   ENDS

CODE    SEGMENT
        ASSUME DS:DATA, ES:DATA, SS:STACK, CS:CODE
START:  MOV AX, DATA; the old 3 lines
        MOV DS, AX
        MOV ES, AX
        
        MOV CX, 2;sum
        MOV SI, 0
        CLC
LOOP1:  MOV AL, A1[SI]
        ADC AL, A2[SI]
        DAA;decimal adjustment for addition
        MOV SUM[SI], AL
        INC SI
        DEC CX
        JNZ LOOP1
        
        MOV CX, 2;substract
        MOV SI, 0
        CLC        
LOOP2:  MOV AL, A1[SI]
        SBB AL, A2[SI]
        DAS;decimal adjustment for substract
        MOV DIF[SI], AL
        INC SI
        DEC CX
        JNZ LOOP2
        
        MOV AH, 4CH
        INT 21H
CODE    ENDS
END     START