

CODE SEGMENT
        ASSUME CS:CODE
START:  MOV SI,200      ;确定偏移地址
        MOV CX,10       ;计数器10
        MOV AL,0        ;累加器0
LOOP0:  MOV [SI],AL     ;赋值到内存
        INC SI          ;调整内存地址
        INC AL          ;调整赋值
        DEC CX          ;计数
        JNZ LOOP0       ;若(CX==0)则跳转
        INT 3           ;退出程序
CODE ENDS
END START
