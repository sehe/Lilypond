;;;; output-lib.scm -- implement Scheme output helper functions
;;;;
;;;;  source file of the GNU LilyPond music typesetter
;;;; 
;;;; (c) 1998--2001 Jan Nieuwenhuizen <janneke@gnu.org>
;;;; Han-Wen Nienhuys <hanwen@cs.uu.nl>


(define (arg->string arg)
  (cond ((number? arg) (inexact->string arg 10))
	((string? arg) (string-append "\"" arg "\""))
	((symbol? arg) (string-append "\"" (symbol->string arg) "\""))))

;; ugh: naming.
(define (func name . args)
  (string-append 
   "(" name 
   (if (null? args) 
       ""
       (apply string-append 
	      (map (lambda (x) (string-append " " (arg->string x))) args)))
   ")\n"))


;;(define (mm-to-pt x)
;;  (* (/ 72.27 25.40) x))

;; do nothing in .scm output
(define (comment s) "")

(define (numbers->string l)
  (apply string-append (map ly-number->string l)))

; (define (chop-decimal x) (if (< (abs x) 0.001) 0.0 x))

(define (number->octal-string x)
  (let* ((n (inexact->exact x))
         (n64 (quotient n 64))
         (n8 (quotient (- n (* n64 64)) 8)))
    (string-append
     (number->string n64)
     (number->string n8)
     (number->string (remainder (- n (+ (* n64 64) (* n8 8))) 8)))))

(define (inexact->string x radix)
  (let ((n (inexact->exact x)))
    (number->string n radix)))


(define (control->string c)
  (string-append (number->string (car c)) " "
		 (number->string (cdr c)) " "))

(define (font i)
  (string-append
   "font"
   (make-string 1 (integer->char (+ (char->integer #\A) i)))))

(define (scm-scm action-name)
  1)


;; silly, use alist? 
(define (find-notehead-symbol duration style)
  (case style
   ((xcircle) "2xcircle")
   ((harmonic) "0neo_mensural")
   ((baroque) 
    (string-append (number->string duration)
		   (if (< duration 0) "neo_mensural" "")))
   ((mensural) (string-append (number->string duration) (symbol->string style)))
   ((neo_mensural) (string-append (number->string duration) (symbol->string style)))
   ((default) (number->string duration))
   (else
    (string-append (number->string (max 0 duration)) (symbol->string style)))))


(define (note-head-style->attachment-coordinates style)
  "Return pair (X . Y), containing multipliers for the note head
bounding box, where to attach the stem. e.g.: X==0 means horizontally
centered, X==1 is at the right, X == -1 is at the left."

  (case style
    ((default) '(1.0 . 0.5))
    ((cross) '(1.0 . 0.75))
    ((mensural) '(0.0 . 0.6))
    ((neo_mensural) '(0.0 . 0.6))
    ((diamond) '(1.0 . 0.8))
    ((transparent) '(1.0 . 1.0))
    ((slash) '(1.0 . 1.0))
    ((harmonic) '(1.0 0.0))
    ((triangle) '(0.75 . 0.15))
    (else
     '(1.0 . 0.0)
     )))
		     
(define (string-encode-integer i)
  (cond
   ((= i  0) "o")
   ((< i 0)   (string-append "n" (string-encode-integer (- i))))
   (else (string-append
	  (make-string 1 (integer->char (+ 65 (modulo i 26))))
	  (string-encode-integer (quotient i 26))))))





