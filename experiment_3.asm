DATA SEGMENT
    LIST1 DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH;无小数点数字
    LIST2 DB 0BFH,86H,0DBH,0CFH,0E6H,0EDH,0FDH,87H,0FFH;带小数点的数字
I0 EQU 298H
I1 EQU 299H
I2 EQU 29AH
PORTA EQU 288H        ;并口
PORTB EQU 289H
PORTC EQU 28AH
DATA ENDS
STACK1 SEGMENT  STACK       
    DW 100 DUP(0)  
STACK1 ENDS 
CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK1
START: MOV AX,DATA
       MOV DS,AX
       MOV DX,028BH
       MOV AL,10000000B
       OUT DX,AL
;------------------------------I0部分------------------------------
L1:   MOV AL,00
      MOV DX,I0
      OUT DX,AL
      MOV CX,0FFH           
DELAY:LOOP DELAY
      MOV DX,I0
      IN AL,DX         ;读入0口数据
      MOV DX,PORTC
      OUT DX,AL
      MOV BX,2        ;100*5/256约等于2,5/256约等于0.0195，取整最少要乘100，约等于2
      MUL BL
      MOV BL,100
      DIV BL           ;得到余数存入AH，十位（个位）存入AL
      
      MOV CH,AL       ;十位（个位）在CH
      MOV CL,AH
;------------------------------I0个位LED显示部分------------------------------
    MOV DX,PORTB        ;B口位选,
    MOV AL,10000000B           
    OUT DX,AL
    MOV DX,PORTA            ;A口段选
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]              ;输出带小数点的数字，led显示
    OUT DX,AL  
    CALL DELAY1
    MOV DX,288H  
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;------------------------------I0个位屏幕显示部分------------------------------
    MOV AL,CH
    ADD AL,30H                
    MOV DL,AL
    MOV AH,02H                   ;输出数字十位显示在屏幕上
    INT 21H
    MOV DL,46             ;输出小数点，显示在屏幕上
    MOV AH,02H
    INT 21H
;------------------------------    
    MOV AL,CL
    MOV BX,10
    MUL BL
    MOV BX,100
    DIV BL
    MOV CL,AL                     ;得到个位（小数部分）数据
    MOV CH,AH
;------------------------------I0小数（十分位）LED显示部分------------------------------
    MOV DX,PORTB        ;B口位选,
    MOV AL,01000000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]              ;输出无小数点的数字，led显示
    OUT DX,AL
    CALL DELAY1                    ;延时显示
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;------------------------------I0小数（十分位）屏幕显示部分------------------------------
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
        
    MOV BX,10
    MOV AH,0             ;将AH清零
    MOV AL,CH
    DIV BL
    MOV CL,AL            ;取百分位
        
    MOV DL,32                      ;输出空格
    MOV AH,02H
    INT 21H

      
      
;------------------------------I1部分------------------------------
L2: MOV AL,00
    MOV DX,I1
    OUT DX,AL
    MOV CX,0FFH           
DELAY2:
	LOOP DELAY2
    MOV DX,I0
    IN AL,DX
    MOV BX,2
    MUL BL
    MOV BL,100
    DIV BL
    MOV CH,AL
    MOV CL,AH                     ;数据暂存于cx   
;------------------------------
    MOV DX,PORTB
    MOV AL,00010000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;--------------------------------  
    MOV AL,CH
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
    MOV DL,46
    MOV AH,02H
    INT 21H      
    MOV AL,CL    
    MOV BX,10
    MUL BL
    MOV BX,100 
    DIV BL
    MOV CL,AL
;---------------------- 
    MOV DX,PORTB
    MOV AL,00001000B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;-------------------------  
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H

    MOV DL,32
    MOV AH,02H
    INT 21H
;------------------------------I2部分------------------------------
  L3: 
  	MOV AL,00
    MOV DX,I2
    OUT DX,AL
    MOV CX,0FFH           
DELAY3:
	LOOP DELAY3
    MOV DX,I0
    IN AL,DX
    MOV BX,2
    MUL BL  
    MOV BL,100
    DIV BL  
    MOV CH,AL
    MOV CL,AH   
;------------------------------
    MOV DX,PORTB
    MOV AL,00000010B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CH
    MOV BH,0
    MOV AL,LIST2[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H    
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;--------------------------------  
    MOV AL,CH
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H  
    MOV DL,46
    MOV AH,02H
    INT 21H  
    MOV AL,CL
    MOV BX,10
    MUL BL
    MOV BX,100
    DIV BL
    MOV CL,AL
;---------------------- 
    MOV DX,PORTB
    MOV AL,00000001B
    OUT DX,AL
    MOV DX,PORTA
    MOV BX,0000H
    MOV BL,CL
    MOV BH,0
    MOV AL,LIST1[BX]
    OUT DX,AL
    CALL DELAY1
    MOV DX,288H   
    MOV AL,00000000B
    OUT DX,AL
    CALL DELAY1
;-------------------------  
    MOV AL,CL
    ADD AL,30H
    MOV DL,AL
    MOV AH,02H
    INT 21H
    MOV DL,32
    MOV AH,02H
    INT 21H       
    MOV DL,0DH             ;显示回车，进行实时显示
    MOV AH,2
    INT 21H
	JMP L1              ;循环

DELAY1 PROC ;延时程序，延时10s
        PUSH BX
        PUSH CX
        
        MOV BX,15    
BAGAIN: MOV CX,3000  
 BWAIT: LOOP BWAIT
        DEC BX
        JNZ BAGAIN
        POP CX
        POP BX
        RET
DELAY1 ENDP

CODE ENDS
  END START

