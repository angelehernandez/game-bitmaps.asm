; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;   Angel Hernandez
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc 

;;IMPORTANT COMMENT:    my visual studio doesn't allow for the "includes" to not have the entire path
;;                      I included the copy+paste versions from the docs on canvas in comments below my paths        

;number string
include D:\EECS_205\masm32\include\user32.inc
includelib D:\EECS_205\masm32\lib\user32.lib
; include \masm32\include\user32.inc
; includelib \masm32\lib\user32.lib

;sounds
include D:\EECS_205\masm32\include\windows.inc
include D:\EECS_205\masm32\include\winmm.inc
includelib D:\EECS_205\masm32\lib\winmm.lib
includelib D:\EECS_205\masm32\lib\masm32.lib
; include \masm32\include\windows.inc
; include \masm32\include\winmm.inc
; includelib \masm32\lib\winmm.lib

;; Has keycodes
include keys.inc

	
.DATA

      ;; If you need to, you can place global variables here
      soundStr    BYTE "D:\EECS_205\eecs205-assign-45\Galaga_Theme.wav", 0
      livesStr    BYTE "Lives: %d", 0
      livesArr    BYTE 256 DUP(0)
      scoreStr    BYTE "Score: %d", 0
      scoreoutStr	BYTE 256 DUP(0)
      shipStr     BYTE "^You^", 0
      enemStr     BYTE "^Enemies^", 0
      lrStr       BYTE "Use Left and Right to strafe", 0
      spaceStr    BYTE "Use Spacebar to shoot", 0
      startStr    BYTE "Click START to begin!", 0
      instStr     BYTE "Shoot the enemies!", 0
      pauseInst   BYTE "Press P to pause", 0
      pauseStr    BYTE "GAME PAUSED. 'O' to unpause", 0
      loseStr     BYTE "Game over!", 0
      state GameState <>

.CODE
	

;; Note: You will need to implement CheckIntersect!!!
CheckIntersect PROC USES ebx ecx oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, 
            twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
      LOCAL one_upleftX: DWORD, one_uprightX: DWORD, one_downleftX: DWORD, one_downrightX: DWORD,
            one_upleftY: DWORD, one_uprightY: DWORD, one_downleftY: DWORD, one_downrightY: DWORD,
            two_upleftX: DWORD, two_uprightX: DWORD, two_downleftX: DWORD, two_downrightX: DWORD,
            two_upleftY: DWORD, two_uprightY: DWORD, two_downleftY: DWORD, two_downrightY: DWORD
      
      INITIALIZE_ONE:
            ;;Upper Left: (one.x - bitmap.width / 2, one.y - bitmap.height / 2)
            ;x coord
            mov ebx, oneX
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            sub ebx, ecx
            mov one_upleftX, ebx

            ;y coord
            mov ebx, oneY
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            sub ebx, ecx
            mov one_upleftY, ebx

            ;;Upper Right: (one.x + bitmap.width / 2, one.y - bitmap.height / 2)
            ;x coord
            mov ebx, oneX
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            add ebx, ecx
            mov one_uprightX, ebx

            ;y coord
            mov ebx, oneY
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            sub ebx, ecx
            mov one_uprightY, ebx

            ;;Bottom Left: (one.x - bitmap.width / 2, one.y + bitmap.height / 2)
            ;x coord
            mov ebx, oneX
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            sub ebx, ecx
            mov one_downleftX, ebx

            ;y coord
            mov ebx, oneY
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            add ebx, ecx
            mov one_downleftY, ebx

            ;;Bottom Right: (one.x + bitmap.width / 2, one.y + bitmap.height / 2)
            ;x coord
            mov ebx, oneX
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            add ebx, ecx
            mov one_downrightX, ebx

            ;y coord
            mov ebx, one_upleftY
            mov ecx, oneBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            add ebx, ecx
            mov one_downrightY, ebx

      INITIALIZE_TWO:
            ;;Upper Left: (two.x - bitmap.width / 2, two.y - bitmap.height / 2)
            ;x coord
            mov ebx, twoX
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            sub ebx, ecx
            mov two_upleftX, ebx

            ;y coord
            mov ebx, twoY
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            sub ebx, ecx
            mov two_upleftY, ebx

            ;;Upper Right: (two.x + bitmap.width / 2, two.y - bitmap.height / 2)
            ;x coord
            mov ebx, twoX
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            add ebx, ecx
            mov two_uprightX, ebx

            ;y coord
            mov ebx, twoY
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            sub ebx, ecx
            mov two_uprightY, ebx

            ;;Bottom Left: (two.x - bitmap.width / 2, two.y + bitmap.height / 2)
            ;x coord
            mov ebx, twoX
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            sub ebx, ecx
            mov two_downleftX, ebx

            ;y coord
            mov ebx, twoY
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            add ebx, ecx
            mov two_downleftY, ebx

            ;;Bottom Right: (two.x + bitmap.width / 2, two.y + bitmap.height / 2)
            ;x coord
            mov ebx, twoX
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwWidth
            shr ecx, 1
            add ebx, ecx
            mov two_downrightX, ebx

            ;y coord
            mov ebx, two_upleftY
            mov ecx, twoBitmap
            mov ecx, (EECS205BITMAP PTR [ecx]).dwHeight
            shr ecx, 1
            add ebx, ecx
            mov two_downrightY, ebx

            ;;assume no collision
            mov eax, 0

      CHECK_TOPLEFT:
            ;check x
            mov ebx, two_upleftX
            cmp ebx, one_downrightX ;left of box 1's right x-coord?
            jg PASS_TOPLEFT
            cmp ebx, one_downleftX  ;right of box 1's left x-coord?
            jl PASS_TOPLEFT

            ;check y
            mov ebx, two_upleftY
            cmp ebx, one_uprightY   ;down of box 1's top y-coord?
            jl PASS_TOPLEFT
            cmp ebx, one_downrightY ;up of box 1's bot y-coord
            jg PASS_TOPLEFT
            mov eax, 1
            ret
      PASS_TOPLEFT:

      CHECK_TOPRIGHT:
            ;check x
            mov ebx, two_uprightX
            cmp ebx, one_downrightX 
            jg PASS_TOPRIGHT
            cmp ebx, one_downleftX  
            jl PASS_TOPRIGHT

            ;check y
            mov ebx, two_uprightY   
            cmp ebx, one_uprightY
            jl PASS_TOPRIGHT
            cmp ebx, one_downrightY 
            jg PASS_TOPRIGHT
            mov eax, 1
            ret
      PASS_TOPRIGHT:

      CHECK_BOTRIGHT:
            ;check x
            mov ebx, two_downrightX
            cmp ebx, one_downrightX 
            jg PASS_BOTRIGHT
            cmp ebx, one_downleftX 
            jl PASS_BOTRIGHT

            ;check y
            mov ebx, two_downrightY   
            cmp ebx, one_uprightY
            jl PASS_BOTRIGHT
            cmp ebx, one_downrightY 
            jg PASS_BOTRIGHT
            mov eax, 1
            ret
      PASS_BOTRIGHT:

      CHECK_BOTLEFT:
            ;check x
            mov ebx, two_downleftX
            cmp ebx, one_downrightX 
            jg PASS_BOTLEFT
            cmp ebx, one_downleftX  
            jl PASS_BOTLEFT

            ;check y
            mov ebx, two_downleftY  
            cmp ebx, one_uprightY
            jl PASS_BOTLEFT
            cmp ebx, one_downrightY
            jg PASS_BOTLEFT
            mov eax, 1
            ret
      PASS_BOTLEFT:

      ret         ;; Do not delete this line!!!
CheckIntersect ENDP

ResetGame PROC
      ;update state
      mov state.CurrentState, 0

      ;reset ship
      mov state.ship.xpos, 320
      mov state.ship.lives, 3

      ;set enemies
      mov state.enem0.xpos, 240
      mov state.enem1.xpos, 280
      mov state.enem2.xpos, 320
      mov state.enem3.xpos, 360
      mov state.enem4.xpos, 400

      ;set projectiles
      mov state.proj.xpos, 2000
      mov state.enem_proj0.xpos, 2000

      ;START
      invoke RotateBlit, OFFSET BITMAP_START, 300, 240, 0
      
      ret
ResetGame ENDP

GameInit PROC
	invoke ResetGame
	invoke PlaySound, OFFSET soundStr, 0, SND_FILENAME OR SND_ASYNC
	ret         ;; Do not delete this line!!!
GameInit ENDP

PauseMenu PROC
      PAUSE_TEST:
      cmp KeyPress, VK_P
      jne NO_PAUSE
      mov state.CurrentState, 3
      NO_PAUSE:

      UNPAUSE_TEST:
      cmp KeyPress, VK_O
      jne NO_UNPAUSE
      mov state.CurrentState, 1
      NO_UNPAUSE:
PauseMenu ENDP

UpdateShip PROC 
      ;check if game paused
      cmp state.CurrentState, 3
      je GAME_PAUSED

      ;check if left key being pressed
      LEFT_TEST:
      cmp KeyPress, VK_LEFT
      jne NO_LEFT
      sub state.ship.xpos, 8
      NO_LEFT:

      ;check if right key being pressed
      RIGHT_TEST:
      cmp KeyPress, VK_RIGHT
      jne NO_RIGHT
      add state.ship.xpos, 8
      NO_RIGHT:

      ;paint image
      invoke RotateBlit, OFFSET BITMAP_SPACESHIP, state.ship.xpos, state.ship.ypos, 0

      GAME_PAUSED:
      ret
UpdateShip ENDP

RenderLives PROC 
      rdtsc
      push state.ship.lives
      push OFFSET livesStr
      push OFFSET livesArr
      call wsprintf
      add esp, 12
      invoke DrawStr, OFFSET livesArr, 540, 420, 0ffh
      
      ret
RenderLives ENDP

RenderScore PROC xpos:DWORD, ypos:DWORD
      rdtsc
      push state.score
      push OFFSET scoreStr
      push OFFSET scoreoutStr
      call wsprintf
      add esp, 12
      invoke DrawStr, OFFSET scoreoutStr, xpos, ypos, 0ffh
      
      ret
RenderScore ENDP

UpdateProjectile PROC USES ebx 
      ;check if game paused
      cmp state.CurrentState, 3
      je GAME_PAUSED
      
      ;check if space pressed
      SPACE_TEST:
      cmp KeyPress, VK_SPACE
      jne NO_SPACE
      mov ebx, state.ship.xpos
      mov state.proj.xpos, ebx
      mov ebx, state.ship.ypos
      mov state.proj.ypos, ebx
      NO_SPACE:

      ;move projectile upward
      sub state.proj.ypos, 20
      invoke RotateBlit, OFFSET BITMAP_PROJECTILE, state.proj.xpos, state.proj.ypos, 0

      ;check enem0
      COLLISION_TEST0:
      invoke CheckIntersect, state.enem0.xpos, state.enem0.ypos, OFFSET BITMAP_ENEMY,
      state.proj.xpos, state.proj.ypos, OFFSET BITMAP_PROJECTILE
      cmp eax, 0
      je NO_COLLISION0
      add state.score, 100
      mov state.proj.xpos, 700
      mov state.enem0.xpos, 700
      mov state.enem0.ypos, 700
      and state.living, 00011110b
      NO_COLLISION0:

      ;check enem1
      COLLISION_TEST1:
      invoke CheckIntersect, state.enem1.xpos, state.enem1.ypos, OFFSET BITMAP_ENEMY,
      state.proj.xpos, state.proj.ypos, OFFSET BITMAP_PROJECTILE
      cmp eax, 0
      je NO_COLLISION1
      add state.score, 100
      mov state.proj.xpos, 700
      mov state.enem1.xpos, 700
      mov state.enem1.ypos, 700
      and state.living, 00011101b
      NO_COLLISION1:

      ;check enem2
      COLLISION_TEST2:
      invoke CheckIntersect, state.enem2.xpos, state.enem2.ypos, OFFSET BITMAP_ENEMY,
      state.proj.xpos, state.proj.ypos, OFFSET BITMAP_PROJECTILE
      cmp eax, 0
      je NO_COLLISION2
      add state.score, 100
      mov state.proj.xpos, 700
      mov state.enem2.xpos, 700
      mov state.enem2.ypos, 700
      and state.living, 00011011b
      NO_COLLISION2:

      ;check enem3
      COLLISION_TEST3:
      invoke CheckIntersect, state.enem3.xpos, state.enem3.ypos, OFFSET BITMAP_ENEMY,
      state.proj.xpos, state.proj.ypos, OFFSET BITMAP_PROJECTILE
      cmp eax, 0
      je NO_COLLISION3
      add state.score, 100
      mov state.proj.xpos, 700
      mov state.enem3.xpos, 700
      mov state.enem3.ypos, 700
      and state.living, 00010111b
      NO_COLLISION3:

      ;check enem4
      COLLISION_TEST4:
      invoke CheckIntersect, state.enem4.xpos, state.enem4.ypos, OFFSET BITMAP_ENEMY,
      state.proj.xpos, state.proj.ypos, OFFSET BITMAP_PROJECTILE
      cmp eax, 0
      je NO_COLLISION4
      add state.score, 100
      mov state.proj.xpos, 700
      mov state.enem4.xpos, 700
      mov state.enem4.ypos, 700
      and state.living, 00001111b
      NO_COLLISION4:

      GAME_PAUSED:
      ret
UpdateProjectile ENDP

UPDATE_ENEMIES_PROJECTILES:
      UpdateEnemyProjectile0 PROC USES ebx ecx
            cmp state.CurrentState, 3
            je STOP_GAME
            ;if enem0 is living, it shoots
            test state.living, 00000001b
            jz STOP_GAME
            
            cmp state.enem_proj0.ypos, 400
            jle GOOD
            mov state.enem_proj0.ypos, 700
            GOOD:

            ;check is space is pressed
            SPACE_TEST:
            cmp KeyPress, VK_SPACE
            jne NO_SPACE
            mov ebx, state.enem0.xpos
            mov state.enem_proj0.xpos, ebx
            mov ebx, state.enem0.ypos
            mov state.enem_proj0.ypos, ebx
            NO_SPACE:

            ;check if projectile is close enough on x-wise
            POSITION_TESTS:
            mov ebx, state.ship.xpos
            sub ebx, 10
            mov ecx, state.ship.xpos
            add ecx, 10
            cmp state.enem_proj0.xpos, ebx
            jge CENTER_RIGHT
            add state.enem_proj0.xpos, 5
            CENTER_RIGHT:
            cmp state.enem_proj0.xpos, ecx
            jle CENTER_LEFT
            sub state.enem_proj0.xpos, 5
            CENTER_LEFT:

            ;move projectile downward
            add state.enem_proj0.ypos, 20
            invoke RotateBlit, OFFSET BITMAP_ENEMY_PROJECTILE, state.enem_proj0.xpos, state.enem_proj0.ypos, 0

            COLLISION_TEST:
            invoke CheckIntersect, state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP,
            state.enem_proj0.xpos, state.enem_proj0.ypos, OFFSET BITMAP_ENEMY_PROJECTILE
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem_proj0.xpos, 700
            mov state.enem_proj0.ypos, 700
            NO_COLLISION:

            STOP_GAME:
            ret
      UpdateEnemyProjectile0 ENDP

      UpdateEnemyProjectile1 PROC USES ebx ecx
            cmp state.CurrentState, 3
            je STOP_GAME
            ;if enem1 is living
            test state.living, 00000010b
            jz STOP_GAME
            ;if enem0 is dead
            test state.living, 00000001b
            jnz DONT_SHOOT
            
            cmp state.enem_proj0.ypos, 400
            jle GOOD
            mov state.enem_proj0.ypos, 700
            GOOD:

            SPACE_TEST:
            cmp KeyPress, VK_SPACE
            jne NO_SPACE
            mov ebx, state.enem1.xpos
            mov state.enem_proj0.xpos, ebx
            mov ebx, state.enem1.ypos
            mov state.enem_proj0.ypos, ebx
            NO_SPACE:

            
            POSITION_TESTS:
            mov ebx, state.ship.xpos
            sub ebx, 10
            mov ecx, state.ship.xpos
            add ecx, 10
            cmp state.enem_proj0.xpos, ebx
            jge CENTER_RIGHT
            add state.enem_proj0.xpos, 5
            CENTER_RIGHT:
            cmp state.enem_proj0.xpos, ecx
            jle CENTER_LEFT
            sub state.enem_proj0.xpos, 5
            CENTER_LEFT:

            add state.enem_proj0.ypos, 20
            invoke RotateBlit, OFFSET BITMAP_ENEMY_PROJECTILE, state.enem_proj0.xpos, state.enem_proj0.ypos, 0
            
            DONT_SHOOT:
            COLLISION_TEST:
            invoke CheckIntersect, state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP,
            state.enem_proj0.xpos, state.enem_proj0.ypos, OFFSET BITMAP_ENEMY_PROJECTILE
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem_proj0.xpos, 700
            mov state.enem_proj0.ypos, 700
            NO_COLLISION:

            STOP_GAME:
            ret
      UpdateEnemyProjectile1 ENDP

      UpdateEnemyProjectile2 PROC USES ebx ecx
            cmp state.CurrentState, 3
            je STOP_GAME
            ;if enems 0 and 1 are dead, and enem 2 is living, enem2 shoots
            test state.living, 00000100b
            jz STOP_GAME
            test state.living, 00000011b
            jnz DONT_SHOOT
            
            cmp state.enem_proj0.ypos, 400
            jle GOOD
            mov state.enem_proj0.ypos, 700
            GOOD:

            SPACE_TEST:
            cmp KeyPress, VK_SPACE
            jne NO_SPACE
            mov ebx, state.enem2.xpos
            mov state.enem_proj0.xpos, ebx
            mov ebx, state.enem2.ypos
            mov state.enem_proj0.ypos, ebx
            NO_SPACE:

            
            POSITION_TESTS:
            mov ebx, state.ship.xpos
            sub ebx, 10
            mov ecx, state.ship.xpos
            add ecx, 10
            cmp state.enem_proj0.xpos, ebx
            jge CENTER_RIGHT
            add state.enem_proj0.xpos, 5
            CENTER_RIGHT:
            cmp state.enem_proj0.xpos, ecx
            jle CENTER_LEFT
            sub state.enem_proj0.xpos, 5
            CENTER_LEFT:

            add state.enem_proj0.ypos, 20
            invoke RotateBlit, OFFSET BITMAP_ENEMY_PROJECTILE, state.enem_proj0.xpos, state.enem_proj0.ypos, 0
            
            DONT_SHOOT:
            COLLISION_TEST:
            invoke CheckIntersect, state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP,
            state.enem_proj0.xpos, state.enem_proj0.ypos, OFFSET BITMAP_ENEMY_PROJECTILE
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem_proj0.xpos, 700
            mov state.enem_proj0.ypos, 700
            NO_COLLISION:

            STOP_GAME:
            ret
      UpdateEnemyProjectile2 ENDP

      UpdateEnemyProjectile3 PROC USES ebx ecx
            cmp state.CurrentState, 3
            je STOP_GAME
            ;if enems 0,1, and 2 are dead, and enem3 is living, enem3 shoots
            test state.living, 00001000b
            jz STOP_GAME
            test state.living, 00000111b
            jnz DONT_SHOOT
            
            cmp state.enem_proj0.ypos, 400
            jle GOOD
            mov state.enem_proj0.ypos, 700
            GOOD:

            SPACE_TEST:
            cmp KeyPress, VK_SPACE
            jne NO_SPACE
            mov ebx, state.enem3.xpos
            mov state.enem_proj0.xpos, ebx
            mov ebx, state.enem3.ypos
            mov state.enem_proj0.ypos, ebx
            NO_SPACE:

			
            POSITION_TESTS:
            mov ebx, state.ship.xpos
            sub ebx, 10
            mov ecx, state.ship.xpos
            add ecx, 10
            cmp state.enem_proj0.xpos, ebx
            jge CENTER_RIGHT
            add state.enem_proj0.xpos, 5
            CENTER_RIGHT:
            cmp state.enem_proj0.xpos, ecx
            jle CENTER_LEFT
            sub state.enem_proj0.xpos, 5
            CENTER_LEFT:

            add state.enem_proj0.ypos, 20
            invoke RotateBlit, OFFSET BITMAP_ENEMY_PROJECTILE, state.enem_proj0.xpos, state.enem_proj0.ypos, 0

            DONT_SHOOT:
            COLLISION_TEST:
            invoke CheckIntersect, state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP,
            state.enem_proj0.xpos, state.enem_proj0.ypos, OFFSET BITMAP_ENEMY_PROJECTILE
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem_proj0.xpos, 700
            mov state.enem_proj0.ypos, 700
            NO_COLLISION:

            STOP_GAME:
            ret
      UpdateEnemyProjectile3 ENDP

      UpdateEnemyProjectile4 PROC USES ebx ecx
            cmp state.CurrentState, 3
            je STOP_GAME
            ;if enems 0,1,2, and 3 are dead, and enem4 is living, enem4 shoots
            test state.living, 00010000b
            jz STOP_GAME
            test state.living, 00001111b
            jnz DONT_SHOOT
            
            cmp state.enem_proj0.ypos, 400
            jle GOOD
            mov state.enem_proj0.ypos, 700
            GOOD:

            SPACE_TEST:
            cmp KeyPress, VK_SPACE
            jne NO_SPACE
            mov ebx, state.enem4.xpos
            mov state.enem_proj0.xpos, ebx
            mov ebx, state.enem4.ypos
            mov state.enem_proj0.ypos, ebx
            NO_SPACE:

		
            POSITION_TESTS:
            mov ebx, state.ship.xpos
            sub ebx, 10
            mov ecx, state.ship.xpos
            add ecx, 10
            cmp state.enem_proj0.xpos, ebx
            jge CENTER_RIGHT
            add state.enem_proj0.xpos, 5
            CENTER_RIGHT:
            cmp state.enem_proj0.xpos, ecx
            jle CENTER_LEFT
            sub state.enem_proj0.xpos, 5
            CENTER_LEFT:

            add state.enem_proj0.ypos, 20
            invoke RotateBlit, OFFSET BITMAP_ENEMY_PROJECTILE, state.enem_proj0.xpos, state.enem_proj0.ypos, 0
            
            DONT_SHOOT:
            COLLISION_TEST:
            invoke CheckIntersect, state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP,
            state.enem_proj0.xpos, state.enem_proj0.ypos, OFFSET BITMAP_ENEMY_PROJECTILE
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem_proj0.xpos, 700
            mov state.enem_proj0.ypos, 700
            NO_COLLISION:

            STOP_GAME:
            ret
      UpdateEnemyProjectile4 ENDP
UPDATE_ENEMIES_PROJECTILES_END:

UPDATE_ENEMIES:
      UpdateEnemy0 PROC USES eax ebx ecx 
            ;check if game paused
            cmp state.CurrentState, 3
            je GAME_PAUSED

            ;set bounds: eax left, ebx right
            mov eax, 120
            mov ebx, 520
            
            mov ecx, state.enem0.velocity 
            add state.enem0.xpos, ecx

            ;check if too far right
            RIGHT_TEST:
            cmp state.enem0.xpos, ebx
            jne MOVING_RIGHT
            mov state.enem0.velocity, -2
            add state.enem0.ypos, 40
            MOVING_RIGHT:

            ;check if too far left
            LEFT_TEST:
            cmp state.enem0.xpos, eax
            jne MOVING_LEFT
            mov state.enem0.velocity, 2
            add state.enem0.ypos, 40
            MOVING_LEFT:

            ;check if collision
            COLLISION_TEST: 
            invoke CheckIntersect, state.enem0.xpos, state.enem0.ypos, OFFSET BITMAP_ENEMY,
            state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem0.xpos, 700
            mov state.enem0.ypos, 700
            NO_COLLISION:

            invoke RotateBlit, OFFSET BITMAP_ENEMY, state.enem0.xpos, state.enem0.ypos, 0
            GAME_PAUSED:
            ret
      UpdateEnemy0 ENDP

      UpdateEnemy1 PROC USES eax ebx ecx 
            cmp state.CurrentState, 3
            je GAME_PAUSED

            ;set bounds: eax left, ebx right
            mov eax, 120
            mov ebx, 520
            
            mov ecx, state.enem1.velocity 
            add state.enem1.xpos, ecx

            RIGHT_TEST:
            cmp state.enem1.xpos, ebx
            jne MOVING_RIGHT
            mov state.enem1.velocity, -2
            add state.enem1.ypos, 40
            MOVING_RIGHT:

            LEFT_TEST:
            cmp state.enem1.xpos, eax
            jne MOVING_LEFT
            mov state.enem1.velocity, 2
            add state.enem1.ypos, 40
            MOVING_LEFT:

            COLLISION_TEST: 
            invoke CheckIntersect, state.enem1.xpos, state.enem1.ypos, OFFSET BITMAP_ENEMY,
            state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem1.xpos, 700
            mov state.enem1.ypos, 700
            NO_COLLISION:

            invoke RotateBlit, OFFSET BITMAP_ENEMY, state.enem1.xpos, state.enem1.ypos, 0
            GAME_PAUSED:
            ret
      UpdateEnemy1 ENDP

      UpdateEnemy2 PROC USES eax ebx ecx 
            cmp state.CurrentState, 3
            je GAME_PAUSED

            ;set bounds: eax left, ebx right
            mov eax, 120
            mov ebx, 520
            
            mov ecx, state.enem2.velocity 
            add state.enem2.xpos, ecx

            RIGHT_TEST:
            cmp state.enem2.xpos, ebx
            jne MOVING_RIGHT
            mov state.enem2.velocity, -2
            add state.enem2.ypos, 40
            MOVING_RIGHT:

            LEFT_TEST:
            cmp state.enem2.xpos, eax
            jne MOVING_LEFT
            mov state.enem2.velocity, 2
            add state.enem2.ypos, 40
            MOVING_LEFT:

            COLLISION_TEST: 
            invoke CheckIntersect, state.enem2.xpos, state.enem2.ypos, OFFSET BITMAP_ENEMY,
            state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem2.xpos, 700
            mov state.enem2.ypos, 700
            NO_COLLISION:

            invoke RotateBlit, OFFSET BITMAP_ENEMY, state.enem2.xpos, state.enem2.ypos, 0
            GAME_PAUSED:
            ret
      UpdateEnemy2 ENDP

      UpdateEnemy3 PROC USES eax ebx ecx 
            cmp state.CurrentState, 3
            je GAME_PAUSED

            ;set bounds: eax left, ebx right
            mov eax, 120
            mov ebx, 520
            
            mov ecx, state.enem3.velocity 
            add state.enem3.xpos, ecx

            RIGHT_TEST:
            cmp state.enem3.xpos, ebx
            jne MOVING_RIGHT
            mov state.enem3.velocity, -2
            add state.enem3.ypos, 40
            MOVING_RIGHT:

            LEFT_TEST:
            cmp state.enem3.xpos, eax
            jne MOVING_LEFT
            mov state.enem3.velocity, 2
            add state.enem3.ypos, 40
            MOVING_LEFT:

            COLLISION_TEST: 
            invoke CheckIntersect, state.enem3.xpos, state.enem3.ypos, OFFSET BITMAP_ENEMY,
            state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem3.xpos, 700
            mov state.enem3.ypos, 700
            NO_COLLISION:

            invoke RotateBlit, OFFSET BITMAP_ENEMY, state.enem3.xpos, state.enem3.ypos, 0
            GAME_PAUSED:
            ret
      UpdateEnemy3 ENDP

      UpdateEnemy4 PROC USES eax ebx ecx 
            cmp state.CurrentState, 3
            je GAME_PAUSED

            ;set bounds: eax left, ebx right
            mov eax, 120
            mov ebx, 520
            
            mov ecx, state.enem4.velocity 
            add state.enem4.xpos, ecx

            RIGHT_TEST:
            cmp state.enem4.xpos, ebx
            jne MOVING_RIGHT
            mov state.enem4.velocity, -2
            add state.enem4.ypos, 40
            MOVING_RIGHT:

            LEFT_TEST:
            cmp state.enem4.xpos, eax
            jne MOVING_LEFT
            mov state.enem4.velocity, 2
            add state.enem4.ypos, 40
            MOVING_LEFT:

            COLLISION_TEST: 
            invoke CheckIntersect, state.enem4.xpos, state.enem4.ypos, OFFSET BITMAP_ENEMY,
            state.ship.xpos, state.ship.ypos, OFFSET BITMAP_SPACESHIP
            cmp eax, 0
            je NO_COLLISION
            sub state.score, 100
            sub state.ship.lives, 1
            mov state.enem4.xpos, 700
            mov state.enem4.ypos, 700
            NO_COLLISION:

            invoke RotateBlit, OFFSET BITMAP_ENEMY, state.enem4.xpos, state.enem4.ypos, 0
            GAME_PAUSED:
            ret
      UpdateEnemy4 ENDP
UPDATE_ENEMIES_END:

CheckLives PROC
      cmp state.ship.lives, 0
      jne LIVING
      mov state.CurrentState, 2
      LIVING:
      ret
CheckLives ENDP

CheckEnemies PROC
      cmp state.living, 0
      jne LIVING_ENEMIES
      mov state.CurrentState, 2
      LIVING_ENEMIES:
      ret
CheckEnemies ENDP

TitleScreen PROC
      ;images and captions
      invoke RotateBlit, OFFSET BITMAP_ENEMY, 200, 50, 0
      invoke DrawStr, OFFSET enemStr, 165, 75, 0ffh
      invoke RotateBlit, OFFSET BITMAP_SPACESHIP, 400, 50, 0
      invoke DrawStr, OFFSET shipStr, 381, 75, 0ffh

      ;above strings
      invoke DrawStr, OFFSET lrStr, 200, 140, 0ffh
      invoke DrawStr, OFFSET spaceStr, 220, 160, 0ffh
      invoke DrawStr, OFFSET startStr, 220, 180, 0ffh
      invoke DrawStr, OFFSET pauseInst, 235, 200, 0ffh

      ;below strings

      invoke DrawStr, OFFSET instStr, 230, 280, 0ffh
      ret
TitleScreen ENDP

RenderGame PROC 
      CHECK_STATE:
      ;0 = beginning menu
      cmp state.CurrentState, 0
      je RENDER_0
      ;1 = game
      cmp state.CurrentState, 1
      je RENDER_1
      ;2 = loss screen
      cmp state.CurrentState, 2
      je RENDER_2
      ;3 = pause menu
      cmp state.CurrentState, 3
      je RENDER_3

      RENDER_0:
      invoke TitleScreen
      ret

      RENDER_1:
      ;background
      invoke BlackStarField
      invoke DrawStarField

      ;ship
      invoke UpdateShip
      invoke UpdateProjectile

      ;enemies
      invoke UpdateEnemy0
      invoke UpdateEnemy1
      invoke UpdateEnemy2
      invoke UpdateEnemy3
      invoke UpdateEnemy4
      
      ;enemy projectiles
      invoke UpdateEnemyProjectile0
      invoke UpdateEnemyProjectile1
      invoke UpdateEnemyProjectile2
      invoke UpdateEnemyProjectile3
      invoke UpdateEnemyProjectile4

      ;number strings
      invoke RenderLives
      invoke RenderScore, 10, 420

      ;end conditions
      invoke CheckLives
      invoke CheckEnemies

      ;pause
      invoke PauseMenu
      ret

      RENDER_2:
      invoke BlackStarField
      invoke DrawStr, OFFSET loseStr, 275, 170, 0ffh
      invoke RenderScore, 270, 185
      ret

      RENDER_3:
      invoke PauseMenu
      invoke DrawStr, OFFSET pauseStr, 200, 170, 0ffh
      ret
RenderGame ENDP

GamePlay PROC 

      invoke RenderGame

      cmp state.CurrentState, 0
      jne IN_GAME

      START:
      ;click?
      cmp MouseStatus.buttons, MK_LBUTTON
      jne PASS
      ;left?
      cmp MouseStatus.horiz, 244
      jl PASS
      ;right?
      cmp MouseStatus.horiz, 356
      jg PASS
      ;above?
      cmp MouseStatus.vert, 260
      jg PASS
      ;below
      cmp MouseStatus.vert, 220
      jl PASS
      mov state.CurrentState, 1

      IN_GAME:

      invoke RenderGame

      PASS:
	ret         ;; Do not delete this line!!!
GamePlay ENDP

END