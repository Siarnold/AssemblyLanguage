NAME EX3_1 ; 

DATA SEGMENT 
    ; messages
    MSG0 DB ' $'
    MSG1 DB 'PLEASE INPUT 10 DECIMAL NUMBERS(0~99): ','$'
    MSG2 DB 'NEXT: ', '$'
    MSG3 DB 0DH,0AH,'10 NUMBERS: ',0DH,0AH, '$'
    MSG4 DB 0DH,0AH,'MAX NUMBER: ','$'
    MSGERR1 DB 0DH,0AH,'[ERROR] INVALID INPUT: 0~99 REQUIRED! (0~99): ','$'
    ; store 10 numbers from 1000H
    ORG 1000H
    NUMLIST DB 10 DUP(0)
DATA ENDS

STACK SEGMENT PARA STACK
    DB 100 DUP(?)
STACK ENDS

; print out info
PRINTMSG MACRO NUM
    PUSH AX
    PUSH DX
    MOV AH,9
	MOV DX,OFFSET MSG&NUM
	INT 21H
    POP DX
    POP AX
ENDM


CODE SEGMENT 
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK

; main program as a far procedure
MAIN PROC FAR
START:
    ; initialize
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    MOV AX, STACK
    MOV SS, AX
    
    ; get 10 number inputs
    PRINTMSG 1    
    LEA SI, NUMLIST
    MOV CX, 10
    INPUT_LOOP:
    PRINTMSG 2
    CALL INPUTNUM
    INC SI
    LOOP INPUT_LOOP

    ; output the 10 numbers
    PRINTMSG 3
    LEA SI, NUMLIST
    MOV CX, 10
    OUTPUT_LOOP:
    CALL OUTPUTNUM
    PRINTMSG 0
    INC SI
    LOOP OUTPUT_LOOP
    
    ; find the max
    LEA SI, NUMLIST
    MOV CX, 10
    CALL FINDMAX
    MOV SI,DI
    PRINTMSG 4
    CALL OUTPUTNUM
    
    ; sort with selection
    LEA SI, NUMLIST
    MOV CX, 10
    SORT_LOOP:
    CALL FINDMAX
    MOV AL,[SI]
    MOV AH,[DI]
    MOV [SI],AH
    MOV [DI],AL
    INC SI
    LOOP SORT_LOOP
    
    ; output the 10 sorted numbers
    PRINTMSG 3
    LEA SI, NUMLIST
    MOV CX, 10
    OUTPUT_LOOP2:
    CALL OUTPUTNUM
    PRINTMSG 0
    INC SI
    LOOP OUTPUT_LOOP2

    ; end
    MOV AH, 4CH
    INT 21H
MAIN ENDP


; get 0-99 from keyboard and save to [SI] as BCD
INPUTNUM PROC NEAR
    PUSH AX
    PUSH DX
    PUSH CX
    
    ; input the first character
    INPUTNUM_CHAR1:
    MOV DX,0
    CALL GETCHAR
    CALL ISDIGIT
    CMP AH,0FFH
    JNE INPUTNUM_CHAR1
    SUB AL,30H
    MOV DL,AL
    
    ; get the second character
    CALL GETCHAR
    CALL ISDIGIT
    CMP AH,0FH
    JE INPUTNUM_RETURN
    CMP AH,00H
    JE INPUTNUM_CHAR1
    SUB AL,30H
    MOV CL,4
    SHL DL,CL
    ADD DL,AL
    
    ; get the third character
    CALL GETCHAR
    CALL ISDIGIT
    CMP AH,0FH
    JE INPUTNUM_RETURN
    CMP AH,00H
    JE INPUTNUM_CHAR1
    PRINTMSG ERR1
    JMP INPUTNUM_CHAR1
    
    ; store the BCD number
    INPUTNUM_RETURN:
    MOV [SI],DL
    
    POP CX
    POP DX
    POP AX
    RET
INPUTNUM ENDP

; get a character to AL
GETCHAR PROC NEAR
    MOV AH, 01H
    INT 21H
    RET
GETCHAR ENDP

; if AL is '0'-'9', AH=0FFH
; if AL == CR, AH=0FH
; else, AH=00H
ISDIGIT PROC NEAR
    CMP AL,0DH
    JE ISDIGIT_EMPTY
    CMP AL,30H
    JB ISDIGIT_ERR
    CMP AL,39H
    JA ISDIGIT_ERR
    JMP ISDIGIT_DIGIT
    ISDIGIT_DIGIT:
    MOV AH, 0FFH
    RET
    ISDIGIT_EMPTY:
    MOV AH, 0FH
    RET
    ISDIGIT_ERR:
    PRINTMSG ERR1
    MOV AH, 00H
    RET
ISDIGIT ENDP

; find the max of [SI£ºSI+CX) and store the index to [DI]
FINDMAX PROC NEAR
    ; protect the scene
    PUSH CX
    PUSH SI
    PUSH DX
    PUSH AX
    
    MOV AL,[SI]
    MOV DI,SI
    FINDMAX_LOOP:
    CMP AL,[SI]
    JA FINDMAX_NEXT 
    MOV AL,[SI]
    MOV DI,SI
    FINDMAX_NEXT:
    INC SI
    LOOP FINDMAX_LOOP
    
    ; restore the scene
    POP AX
    POP DX
    POP SI
    POP CX
    RET
FINDMAX ENDP

; output the number(0-99) in [SI]
OUTPUTNUM PROC NEAR
    PUSH AX
    PUSH DX
    PUSH CX
    MOV AX,0
    MOV AL,[SI]
    MOV CL,4
    SHL AX,CL
    OR AH,AH
    JZ OUTPUTNUM_2
    ADD AH,30H
    MOV DL,AH
    MOV AH,6
    INT 21H
    OUTPUTNUM_2:
    MOV AL,[SI]
    AND AL,0FH
    ADD AL,30H
    MOV DL,AL
    MOV AH,6
    INT 21H
    POP CX
    POP DX
    POP AX
    RET
OUTPUTNUM ENDP

CODE ENDS

END START
