; PIC16F18875 Configuration Bit Settings

; Assembly source line config statements

#include "p16f18875.inc"

; CONFIG1
; __config 0xFFEC
 __CONFIG _CONFIG1, _FEXTOSC_OFF & _RSTOSC_HFINT1 & _CLKOUTEN_OFF & _CSWEN_ON & _FCMEN_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _MCLRE_ON & _PWRTE_OFF & _LPBOREN_OFF & _BOREN_ON & _BORV_LO & _ZCD_OFF & _PPS1WAY_ON & _STVREN_ON
; CONFIG3
; __config 0xCFAC
 __CONFIG _CONFIG3, _WDTCPS_WDTCPS_12 & _WDTE_SWDTEN & _WDTCWS_WDTCWS_7 & _WDTCCS_HFINTOSC
; CONFIG4
; __config 0xFFFF
 __CONFIG _CONFIG4, _WRT_OFF & _SCANE_available & _LVP_ON
; CONFIG5
; __config 0xFFFF
 __CONFIG _CONFIG5, _CP_OFF & _CPD_OFF

;user define registers @ bank0   
R0	equ 0x20
R1	equ 0x21
R2	equ 0x22
R3	equ 0x23
R4	equ 0x24
LED	equ 0x26

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program

START
    BANKSEL ANSELB ;Bank select, analog select B. This is the bank we are using.
    CLRF ANSELB ;Clear F register, analog select A. This clears the file register of the bank we are using
    BANKSEL PORTB ; Bank select Port A. Selects Port A.
    ;CLRF PORTA ;Clears Port A register f
    CLRF PORTB ;Clears Port B register f
    CLRF TRISB ;Changes TRIS B to output
    MOVLW B'00010000' ;Move literal Bit to W: this sets the bit to high.
    MOVWF TRISB ; set RB4 as input, which is the switch.

INIT
    MOVLW B'00000000' ; 
    MOVWF PORTB; Moves bit from W to f register.

MAIN
    CALL DELAY   
    INCF LATB
    GOTO MAIN
    
DELAY
    movlw 0xff
    movwf R4
    goto DELAY4
    
DELAY0
    decfsz R0
    goto DELAY0
    goto DELAY4
    
DELAY1
    movlw 0xff
    movwf R0
    decfsz R1
    goto DELAY0
    return
    
DELAY2
    movlw 0xff
    movwf R1
    decfsz R2
    goto DELAY1
    return
    
DELAY3
    movlw 0xff
    movwf R2
    decfsz R3
    goto DELAY2
    return
    
DELAY4
    movlw 0xff
    movwf R3
    decfsz R4
    goto DELAY3
    return


    END
