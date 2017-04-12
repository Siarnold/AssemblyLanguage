NAME EX2_3
;Copyleft(c), Siarnold, 2017

DATA    SEGMENT
        M1 DB 23H ;multiplier one
        M2 DB 75H ;multiplier two
        PRD DB 2 DUP(?) ;product
DATA    ENDS
STACK   SEGMENT PARA STACK
        DB 100 DUP(?)
STACK   ENDS
CODE    SEGMENT
        ASSUME DS:DATA, ES:DATA, SS:STACK, CS:CODE
START:  MOV AX, DATA; the old 3 lines
        MOV DS, AX
        MOV ES, AX
        
        MOV BL, [M1]; the multiplied number
        MOV CL, [M2]; the multiplying number
        XOR DX, DX; clear DX for storing the result
        CLC
        
        AND BL, BL
        JZ MEND;multiplication ends
        AND CL, CL
        JZ MEND
        
CHECK:  MOV AL, DL ;move because DAA only works for AL
        ADD AL, BL
        DAA
        MOV DL, AL
        JNC NEXT ;not carry jump to NEXT
        INC DH
        MOV AL, DH
        CLC; BUG here: must CLC 'cause INC not change CF
        DAA
        MOV DH, AL        
        
NEXT:   DEC CL ;NEXT decrement CL
        MOV AL, CL
        CLC; BUG here: must CLC 'cause DEC not change CF
        DAS
        MOV CL, AL
        JNZ CHECK
        
MEND:   MOV WORD PTR [PRD], DX
        
        MOV AH, 4CH;the old 2 lines-AH!BUG here
        INT 21H
CODE    ENDS
END     START