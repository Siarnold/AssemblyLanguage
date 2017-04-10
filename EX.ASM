NAME    EX   ;Copyleft(c), Siarnold, 2017

DATA    SEGMENT ;define data segment
BUFFER  DB  10H DUP(?)
DATA    ENDS

STACK   SEGMENT     PARA STACK  ;define stack segment
        DB  100 DUP(?)
STACK   ENDS

CODE    SEGMENT ;define code segment
        ASSUME  CS: CODE, DS: DATA, ES: DATA, SS: STACK

START:  MOV AH, 0FFFFH LE 0FFFFH + 1

        INT 3
CODE    ENDS
END     START