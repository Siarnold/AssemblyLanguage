NAME    EX2_1;add and subtract of two 16-bit binary numbers
;Copyleft(c), Siarnold, 2017

DATA    SEGMENT
        A1 DB 3H, 5H; adder one = 0503H
        A2 DB 4H, 2H; adder two = 0204H
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
        MOV SUM[SI], AL
        MOV AL, A2[SI]
        ADC SUM[SI], AL
        INC SI
        DEC CX
        JNZ LOOP1
        
        MOV CX, 2;substract
        MOV SI, 0
        CLC        
LOOP2:  MOV AL, A1[SI]
        MOV DIF[SI], AL
        MOV AL, A2[SI]
        SBB dif[SI], AL
        INC SI
        DEC CX
        JNZ LOOP2
        
        MOV AH, 4CH
        INT 21H
CODE    ENDS
END     START