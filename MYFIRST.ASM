NAME    EX1_3   ;Copyleft(c), Siarnold, 2017

DATA    SEGMENT ;define data segment
BUFFER  DB  10H DUP(?)
DATA    ENDS

STACK   SEGMENT     PARA STACK  ;define stack segment
        DB  100 DUP(?)
STACK   ENDS

CODE    SEGMENT ;define code segment
        ASSUME  CS: CODE, DS: DATA, ES: DATA, SS: STACK

START:  LEA DI, BUFFER  ;load EA to DI
        MOV AL, 30H
        MOV CX, 10

LOOP1:  MOV [DI], AL
        INC AL
        INC DI
        DEC CX
        JNZ LOOP1

        MOV AL, 41H
        MOV CX, 6

LOOP2:  MOV [DI], AL
        INC AL
        INC DI
        DEC CX
        JNZ LOOP2        
        
        INT 3
CODE    ENDS
END     START