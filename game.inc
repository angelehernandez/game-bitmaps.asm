; #########################################################################
;
;   game.inc - Includes for EECS205 Assignment 4/5
;   Angel Hernandez
;
; #########################################################################

;; Library Definitions
MouseInfo STRUCT
 horiz DWORD ?
 vert  DWORD ?
 buttons DWORD ?
MouseInfo ENDS

SpaceShip STRUCT
    xpos DWORD ?
    ypos DWORD 400
    lives DWORD ?
SpaceShip ENDS

Projectile STRUCT
    xpos DWORD ?
    ypos DWORD 400
Projectile ENDS

Enemy STRUCT
    xpos DWORD ?
    ypos DWORD 50
    velocity DWORD 2
Enemy ENDS

GameState STRUCT
    ;0 = title, 1 = game, 2 = end, 3 = pause
    CurrentState DWORD ?
    score DWORD ?
    ;00(enem4)(enem3)(enem2)(enem1)(enem0)
    living DWORD 00011111b

    ship        SpaceShip <>
    proj       Projectile <>
    enem0       Enemy <>
    enem_proj0  Projectile <>
    enem1       Enemy <>
    enem_proj1  Projectile <>
    enem2       Enemy <>
    enem_proj2  Projectile <>
    enem3       Enemy <>
    enem_proj3  Projectile <>
    enem4       Enemy <>
    enem_proj4  Projectile <>

GameState ENDS

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

; SNF_FILENAME = 20000h
; SND_ASYNC = 1h
; SND_NOSTOP = 10h

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD
EXTERNDEF BITMAP_SPACESHIP:EECS205BITMAP
EXTERNDEF BITMAP_ENEMY:EECS205BITMAP
EXTERNDEF BITMAP_PROJECTILE:EECS205BITMAP
EXTERNDEF BITMAP_ENEMY_PROJECTILE:EECS205BITMAP
EXTERNDEF BITMAP_START:EECS205BITMAP

;; User Defined Functions
GameInit PROTO
GamePlay PROTO
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 




