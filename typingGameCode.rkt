; Mark Bernstein 5255204

(require 2htdp/image)
(require 2htdp/universe)

;Constants
(define background (scale 1/2 *INSERT IMAGE HERE* ));static background image
(define letter-size 30) ;size of letters used for game
(define long-screen-size (image-width background));width of screen
(define short-screen-size (image-height background));height of screen
(define half-screen (/ long-screen-size 2));midpoint of screen
(define counter-size 25) ;size of the counter numbers
(define start-letter-speed 2) ;velocity of letters falling from top
(define frame-rate 1/60) ;desired frame rate
(define score-background (rectangle 500 240 "solid" (make-color 0 255 255 200))) ;partially transparent background for the score
(define letter-colors (vector "red" "orange" "yellow" "green" "pink" "violet")) ;the colors used for the falling letters

;type definition character number number string
(define-struct letter-position (letter x y color))
; Type definition: ListOfletterposition Number Number Number Number Number
(define-struct World (letters time letters-correct score speed keys-pressed)) ;creates a struct called World with letter, time, and position as parameters
(define start-world  (make-World (list
                                  (make-letter-position #\D half-screen 0 "red")) ;list of letters that are falling
                                 10 ;time in seconds
                                 0  ;letters correct
                                 0  ;score
                                 start-letter-speed  ;speed of falling letters
                                 0) ;total amount of keys pressed
  ) ;world that has a letter D at time 0, at the midpoint of screen


;Purpose: convert number to alphabetic letter
;Signature: Number -> Character
;Examples:
(check-expect (converter 0) #\A)
(check-expect (converter 4) #\E)
;Stub:
;Code:
(define (converter num)
  (integer->char ;case where we change an integer to a character ...
   (+ ;where the integer is the addition of...
    (char->integer #\A) ;the character of A changed to an integer which means that this turns 0 into A                     
    num); and num
   )
  )


(define alphabet ; define alphabet to be a
  (build-vector 26 converter)); vector containing all of the letters of the alphabet

;Purpose: To have 3 letters displayed on the background
;Signature: List Image -> Image
;Examples:
(check-expect (draw-letters (list) background) background)
(check-expect (draw-letters (list (make-letter-position #\D half-screen 0 "red")) background)
              (overlay/xy
               (text (string #\D) letter-size "red")
               (* -1 half-screen)
               0
               background))
; Stub :
;(define (draw-letters lst img) "A")
;Code:
(define (draw-letters lst img)
  (cond
    ((empty? lst) img) ;if the list (lst) is empty, return the image (img)
    (else
     (overlay/xy
      (text (string (letter-position-letter (first lst))) letter-size (letter-position-color (first lst)))
      (* -1 (letter-position-x (first lst))) ;takes first element of the list lst and its x coordinate and multiplies it by -1 to keep it in bounds
      (* -1 (letter-position-y (first lst))) ;takes first element of the list lst and its y coordinate and multiplies it by -1 to keep it in bounds
      (draw-letters (rest lst) img) ;repeats all of the above steps to the rest of the list lst
      )
     )
    )
  )


;Purpose: Show background
;Signature: World -> Image
;Examples:
(check-expect (draw-scene start-world)
              (draw-letters (World-letters start-world)           
                            (overlay/align "left" "top"
                                           (text (number->string (floor (* frame-rate (World-time start-world)))) counter-size "gray")
                                           (overlay/align "right" "top"
                                                          (text (number->string (World-letters-correct start-world))counter-size "gray")
                                                          (overlay/align "center" "top"
                                                                         (text (number->string (World-score start-world)) counter-size "gray")                                                     
                                                                         background) ;overlaying background
                                                          )
                                           )
                            )
              )

;Stub:
;(define (draw-background wrld) -1)
;Code:
(define (draw-scene wrld); define draw-scene to be the
  (cond
    ((and
      (>= (World-letters-correct wrld) 10) ;if current letters correct is equal to or greater than 10...
      (< (World-letters-correct wrld) 20)) ;...and less than 20...
     (draw-letters (World-letters wrld) 
                   (overlay
                    (text "level 2..." 50 (make-color 0 255 255)) ;makes cyan colored text appear saying "level 2..." on the screen
                    (overlay/align "left" "top"; the position of the timer
                                   (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                                   (overlay/align "right" "top"
                                                  (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of letters correct
                                                  (overlay/align "center" "top"
                                                                 (text (number->string (World-score wrld)) counter-size "gray") ;image of score                                                    
                                                                 background) ;overlaying background
                                                  )
                                   )
                    )
                   )
     )
    ((and
      (>= (World-letters-correct wrld) 20) ;if current letters correct is equal to or greater than 20...
      (< (World-letters-correct wrld) 30)) ;...and less than 30...
     (draw-letters (World-letters wrld)
                   (overlay
                    (text "level 3 YEEEEE" 50 (make-color 0 255 255)) ;makes cyan colored text appear saying "level 3 YEEEEE" on the screen
                    (overlay/align "left" "top"; the position of the timer
                                   (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                                   (overlay/align "right" "top"
                                                  (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of letters correct
                                                  (overlay/align "center" "top"
                                                                 (text (number->string (World-score wrld)) counter-size "gray") ;image of score                                                     
                                                                 background) ;overlaying background
                                                  )
                                   )
                    )
                   )
     )
    ((and
      (>= (World-letters-correct wrld) 30) ;if current letters correct is equal to or greater than 30...
      (< (World-letters-correct wrld) 40)) ;...and less than 40...
     (draw-letters (World-letters wrld)
                   (overlay
                    (text "level 4 AWWW YEAHHH" 50 (make-color 0 255 255)) ;makes cyan colored text appear saying "level 4 AWW YEAHHH" on the screen
                    (overlay/align "left" "top"; the position of the timer
                                   (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                                   (overlay/align "right" "top"
                                                  (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of letters correct
                                                  (overlay/align "center" "top"
                                                                 (text (number->string (World-score wrld)) counter-size "gray") ;image of score                                                      
                                                                 background) ;overlaying background
                                                  )
                                   )
                    )
                   )
     )
    ((>= (World-letters-correct wrld) 40) ;if current letters correct is equal to or greater than 40...
     (draw-letters (World-letters wrld)
                   (overlay
                    (text "MAX LEVEL" 50 (make-color 0 255 255)) ;makes cyan colored text appear saying "MAX LEVEL" on the screen
                    (overlay/align "left" "top"; the position of the timer
                                   (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                                   (overlay/align "right" "top"
                                                  (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of letters correct
                                                  (overlay/align "center" "top"
                                                                 (text (number->string (World-score wrld)) counter-size "gray") ;image of score                                                     
                                                                 background) ;overlaying background
                                                  )
                                   )
                    )
                   )
     )
    (else (draw-letters (World-letters wrld)(overlay/align "left" "top"; the position of the timer
                                                           (text (number->string (floor (* frame-rate (World-time wrld)))) counter-size "gray") ;image of timer
                                                           (overlay/align "right" "top"
                                                                          (text (number->string (World-letters-correct wrld))counter-size "gray") ;image of letters correct
                                                                          (overlay/align "center" "top"
                                                                                         (text (number->string (World-score wrld)) counter-size "gray") ;image of score                                                     
                                                                                         background) ;overlaying background
                                                                          )
                                                           )
                        )
          )
    )
  )



;purpose: animating the image of a letter with the changed y coordinate
;signature: letter-position->letter-position
;examples
(check-expect (animate-letter (make-letter-position #\D half-screen 0 "red") 42)
              (make-letter-position #\D half-screen 42 "red")
              )
;stub:
;(define (animate-letter letter-psn) -1)

;code:
;code:
(define (animate-letter letter-psn speed)
  (make-letter-position ;creates a new letter
   (letter-position-letter letter-psn) ;the letter
   (letter-position-x letter-psn) ;the x position
   (+ (letter-position-y letter-psn) speed) ;adds the letter speed to the y position
   (letter-position-color letter-psn) ;the color
   )
  )

;Purpose: create a random letter-position
;Signature: -> letter-position
;Examples:
(check-expect (letter-position-y (make-random-letter-position start-world)) 0)
;Stub:
;Template:
;Code:
(define (make-random-letter-position wrld)
  (make-letter-position
   (random-letter (World-letters wrld)) ;gets a random letter from the alphabet vector
   (new-x (World-letters wrld)) ;gets a random x coordinate
   0 ;the y coordinate (the top)
   (vector-ref letter-colors (random (vector-length letter-colors))) ;gets a random color
   )
  )

;Purpose: Animate image of letter
;Signature: World -> World
;Examples:
(check-expect (tick-handler start-world)
              (make-World
               (list (make-letter-position #\D half-screen start-letter-speed "red")) 11 0 0 start-letter-speed 0))
;Stub
;(define (tick-handler wrld) -1)
;Code:
(define (tick-handler wrld)
  (cond
    ((empty? (World-letters wrld)) ;if there are no letters in the world...
     (make-World ;create a new world...
      (list (make-random-letter-position wrld)) ;creates a list of a random letter (at a random x position, y at 0, and a random color)
      (+ 1 (World-time wrld)) ;adds 1 to the time
      (World-letters-correct wrld) ;uses wrld to make the letters-correct counter
      (World-score wrld) ;current score
      (World-speed wrld) ;current speed
      (World-keys-pressed wrld) ;uses wrld to get the keys pressed
      )
     )
    ((and ;if both are true...
      (integer? ;if wrld is an integer...
       (* frame-rate (World-time wrld))) ;multiply the frame-rate to the time of wrld
      (< (length (World-letters wrld)) 3)) ;if there are less than 3 letters in the world...
     (make-World ;create a new world
      (append
       (World-letters wrld) ;current letter/s in the world
       (list (make-random-letter-position wrld))) ;list of random letters
      (+ 1 (World-time wrld)) ;time advancements
      (World-letters-correct wrld) ;current total correct letters
      (World-score wrld) ;current score
      (World-speed wrld) ;current speed
      (World-keys-pressed wrld) ;uses wrld to get the keys pressed
      )
     )
    (else
     (make-World ;makes a whole new world
      (map
       (λ(letter-posn)(animate-letter letter-posn (World-speed wrld))) ;animates all the letters in game
       (World-letters wrld) ;current letters in the world
       )
      (+ 1 (World-time wrld)) ;time advancements
      (World-letters-correct wrld) ;current total correct letters
      (World-score wrld) ;current score
      (World-speed wrld) ;current speed
      (World-keys-pressed wrld) ;current total amount of keys pressed
      )
     )
    )
  )


;Purpose: Given a x value, return a x value that doesn't overlap eachother.
;Signature: Number Letter-position -> Boolean
;Examples:
(check-expect (overlap? half-screen (make-letter-position #\D (+ 31 half-screen) 0 "red")) false)
(check-expect (overlap? half-screen (make-letter-position #\D half-screen 31 "red")) false)
(check-expect (overlap? half-screen (make-letter-position #\D (+ 30 half-screen) 0 "red")) true)
(check-expect (overlap? half-screen (make-letter-position #\D (- half-screen 31) 0 "red")) false)
;stub
;(define (overlap? x letter-psn) -1)
;code
(define (overlap? x letter-psn)
  (cond
    ((< (letter-position-x letter-psn) (- x letter-size)) false)
    ((> (letter-position-x letter-psn) (+ x letter-size)) false)
    ((> (letter-position-y letter-psn) letter-size) false)
    (else true)
    )
  )


;Purpose: Check if the list of letters overlap
; Signature: number list of letter positions -> Boolean
;Examples:
(check-expect
 (list-overlap? half-screen
                (list
                 (make-letter-position #\D (/ long-screen-size 2) 0 "red")
                 (make-letter-position #\C (/ long-screen-size 3) 0 "green")
                 (make-letter-position #\E (/ long-screen-size 4) 0 "blue")
                 )
                )
 true)
(check-expect
 (list-overlap? half-screen
                (list                 
                 (make-letter-position #\C (/ long-screen-size 3) 0 "green")
                 (make-letter-position #\E (/ long-screen-size 4) 0 "blue")
                 (make-letter-position #\D (/ long-screen-size 2) 0 "red")
                 )
                )
 true)
(check-expect (list-overlap? half-screen '()) false)

;Stub: (define (list-overlap? x lst) -1)
;Template:
;(define (list-overlap? x lst)
;(cond
;((...) ...)
;((...) ...)
;((...) ...)
;((...) ...)
;(else ...)))
;Code:
(define (list-overlap? x lst)
  (cond
    ((empty? lst) false)
    ((overlap? x (first lst)) true)
    (else (list-overlap? x (rest lst)))
    )
  )

;Purpose: Return a random x-coordinate that doesn't overlap
;Signature: ListofLetterPositions -> Number
;Examples:
 
(check-expect
 (or
  (< (new-x
      (list                 
       (make-letter-position #\E (/ long-screen-size 4) 0 "blue")
       )
      )
     (- (/ long-screen-size 4) letter-size)
     )
  (> (new-x
      (list                 
       (make-letter-position #\E (/ long-screen-size 4) 0 "blue")
       )
      )
     (+ (/ long-screen-size 4) letter-size)
     )
  )
 true)
;Stub:
;(define (new-x lst) "Program")
;Code:
(define (new-x lst)
  (let ; equivalent to define inside of a function
      (
       (random-x (random (- long-screen-size letter-size)))
       )
    (if (list-overlap? random-x lst)
        (new-x lst)
        random-x
        )
    )
  )

;Purpose: Return Boolean to indicate game is over
;Signature: World -> Boolean
;Examples:
(check-expect (game-over? (make-World (list
                                       (make-letter-position #\D half-screen (+ short-screen-size letter-size) "red"))
                                      0
                                      0
                                      0
                                      start-letter-speed
                                      0)) #t)
;Stub
;(define (game-over? wrld) -1)
;Code
(define (game-over? wrld)
  (cond
    ((empty? (World-letters wrld)) #false) ;if there are no letters in world, return false
    (else
     (<= short-screen-size ;comparing screen size to bottom of letter
         (+ ;addition of
          (letter-position-y (first (World-letters wrld))) ;y posn of the world     
          letter-size);and letter size
         ) ;and if screen size is less than or equal to the sum, then is is true, otherwise false
     )
    )
  ); when the letter meets the bottom of the screen then its game over


;Purpose: show the ending screen of a finished game
;Signature: world -> image
;Example:
(check-expect (game-over (make-World (list
                                      (make-letter-position #\D half-screen (- short-screen-size letter-size) "red"))
                                     0
                                     0
                                     0
                                     start-letter-speed
                                     0))
              (overlay
               (underlay
                score-background
                (above
                 (text "GAME OVER" 80 "red")
                 (text (string-append "Time played: "(number->string 0)) counter-size "black")
                 (text (string-append "Score: "(number->string 0)) counter-size "black")
                 (text (string-append "Correct letters typed: "(number->string 0))counter-size "black")
                 (text (string-append "Keys pressed: "(number->string 0))counter-size "black")
                 (text (string-append "Success Percentage: "(number->string 0) "%")counter-size "black")))
               (draw-scene
                (make-World (list
                             (make-letter-position #\D half-screen (- short-screen-size letter-size) "red"))
                            0 0 0 start-letter-speed 0))
               )
              )

;Stub:
;(define (game-over wrld) -1)
;Code:
(define (game-over wrld)
  (cond
    ((= (World-keys-pressed wrld) 0) ;if the total keys pressed equals 0, then...
     (overlay
      (underlay
       score-background ;partially transparent background for the score
       (above
        ; this overlaying the text on top the old world   
        (text "GAME OVER" 80 "red");creating the game over text
        (text (string-append "Time played: "(number->string (floor (* frame-rate (World-time wrld))))) counter-size "black") ;creates text for the time played (in seconds)
        (text (string-append "Score: "(number->string (World-score wrld))) counter-size "black") ;creates text for the score
        (text (string-append "Correct letters typed: "(number->string (World-letters-correct wrld))) counter-size "black") ;creates the text for total correctly typed letters
        (text (string-append "Keys pressed: "(number->string (World-keys-pressed wrld))) counter-size "black") ;creates the text for total amount of keys pressed
        (text (string-append "Success Percentage: "(number->string 0) "%") counter-size "black") ;creates the text for the percentage of correct keys pressed when you press no keys
        )
       )
      (draw-scene wrld) ;old world
      )
     )
    (else
     (overlay
      (underlay
       score-background
       (above
        ; this overlaying the text on top the old world   
        (text "GAME OVER" 80 "red");creating the game over text
        (text (string-append "Time played: "(number->string (floor (* frame-rate (World-time wrld)))) " seconds") counter-size "black");creates text for the time played (in seconds)
        (text (string-append "Score: "(number->string (World-score wrld))) counter-size "black");creates text for the score
        (text (string-append "Correct letters typed: "(number->string (World-letters-correct wrld)))counter-size "black");creates the text for total correctly typed letters
        (text (string-append "Keys pressed: "(number->string (World-keys-pressed wrld)))counter-size "black");creates the text for total amount of keys pressed
        (text (string-append "Success Percentage: "(number->string (round (* 100 (* 1 (/ (World-letters-correct wrld) (World-keys-pressed wrld)))))) "%")counter-size "black");creates the text for the percentage of correct keys pressed when you press keys
        )
       )
      (draw-scene wrld) ;old world
      )
     )
    )
  )

; Purpose: to determine if a letter-position contains a certain character
; Signature: letter-position character -> boolean
; Examples:
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "E") #true)
(check-expect (character-in-position? (make-letter-position #\E 0 0 "cyan") "D") #false)

; Stub:
;(define (character-in-position? letter-psn char) -1)
;code
(define (character-in-position? letter-psn str)
  (char=? (letter-position-letter letter-psn) ;if the following is a character...
          (char-upcase (string-ref str 0)) ;then capitalize the character
          )
  )

(define (character-not-in-position? letter-psn str)
  (not ;the opposite of
   (char=? (letter-position-letter letter-psn) ;if the following is a character...
           (char-upcase (string-ref str 0)) ;then capitalize the character
           )
   )
  )


;Purpose: when a letter on screen is typed, a random new letter appears
;Signature: World Key -> World
;Examples:
(check-expect (empty? (World-letters (key-handler start-world "D"))) #true)
(check-expect (key-handler start-world "X") (make-World (list (make-letter-position #\D 480 0 "red")) 10 0 0 1.9 1))

;Stub:
;(define (key-handler wrld key) -1)
;Template:
;(define (key-handler wrld key)
;  (cond
;    ((...) ... ...)
;    (else
;     ...)
;    )
;  )

;Code:
(define (key-handler wrld key)
  (if
   (not
    (empty? ;if returned list is empty... then the typed key is not displaying
     (filter
      ;function that returns boolean depending on letter position
      ;whether the key is equal to the letter of letter position
      (λ(letter-psn)
        (character-in-position? letter-psn key)) ;lambda applies operation to each letter position
      (World-letters wrld))
     )
    )
   (make-World ;if it is true new world
    (filter ;function that returns boolean depending on letter position
     ;whether the key is equal to the letter of letter position
     (λ(letter-psn)
       (character-not-in-position? letter-psn key)) ;lambda applies operation to each letter position 
     (World-letters wrld)) ;list
    (World-time wrld) ;time
    (+ (World-letters-correct wrld) 1) ; adds 1 to total correct
    (+ (letter-score (char-upcase (string-ref key 0))) (World-score wrld)) ; adds score
    (min 5 (* 1.01 (World-speed wrld))) ;makes speed 1% faster (max possible speed is 5)
    (+ 1 (World-keys-pressed wrld)) ;adds 1 to total keys pressed
    )
   (make-World ;if false old-world with slower speed
    (World-letters wrld) ;list
    (World-time wrld) ;time
    (World-letters-correct wrld) ;correct
    (World-score wrld) ;score
    (* .95 (World-speed wrld)) ;makes speed of letters falling 5% slower
    (+ 1 (World-keys-pressed wrld)) ;adds 1 to total keys pressed
    )
   )
  )




;Purpose: create a randomized letter
;signature:listofletter-positions -> character
(check-expect (char>=? (random-letter (list)) #\A) #true)
(check-expect (char<=? (random-letter (list)) #\Z) #true)
;Stub:
;(define (random-letter) 3) 
;Code:
(define (random-letter lst)
  (let ; equivalent to define inside of a function
      (
       (random-char (vector-ref alphabet ;picking an element from alphabet
                                (random (vector-length alphabet)) ;which the reference is a random number between 0 to 25
                                )
                    )
       )
    (cond
      ((empty? lst ) random-char) ;if list lst is empty, get a new random character
      ((char=? ;if the characters match...
        (letter-position-letter (list-ref lst (- (length lst) 1))) ;a character in the game
        random-char ;a new random character
        )
       (random-letter lst) ;then start over and try again (recursion)
       )
      (else random-char) ;get a new random character
      )
    )
  )



;Purpose: create a randomized position of the letter between the width of the frame
;signature:->number
;examples:
(check-expect (> (random-position) 0) #true)
(check-expect (< (random-position) (- short-screen-size letter-size)) #true)
;Stub:
;(define (random-position) "s")
;Code:
(define (random-position)
  (random (- short-screen-size letter-size)) ;creating a random location so that the letter fits within the screen size
  )


;Purpose: For each standard finger letter position, those are worth 1 point; the others are worth 3 points
;Signature: Char -> Number
;Examples:
(check-expect (letter-score #\A) 1)
(check-expect (letter-score #\S) 1)
(check-expect (letter-score #\D) 1)
(check-expect (letter-score #\F) 1)
(check-expect (letter-score #\J) 1)
(check-expect (letter-score #\K) 1)
(check-expect (letter-score #\L) 1)
(check-expect (letter-score #\Q) 3)

;Stub:(define (letter-score char) -1)

;Template:
;(define (letter-score char)
;  (cond
;    ((...)...)
;    (else
;     ...)
;    )
;  )
(define 1-point ;this function makes the following letters worth 1 point 
  (make-hash ;creates a hash table
   (list (list #\A 1)
         (list #\S 1)
         (list #\D 1)
         (list #\F 1)
         (list #\J 1)
         (list #\K 1)
         (list #\L 1)
         )
   )
  )
;Code:
(define (letter-score char)
  (cond
    ((hash-has-key? 1-point char) 1) ;if the character is part of the hash table, it is worth 1 point...
    (else
     3) ;otherwise, the character is worth 3 points
    )
  )


(big-bang (make-World
           (list)
           0
           0
           0
           start-letter-speed 
           0) ;this is a world starting with "D" with position being in the midpoint of the screen and at the top of the screen
  (on-draw draw-scene) ;generates an image
  (on-tick tick-handler frame-rate) ;animates the falling letters and timer
  (stop-when game-over? game-over) ;tells the animation when to stop
  (on-key key-handler) ;allows the user to use the keyboard
  )
