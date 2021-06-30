#lang racket

(define sum
  (lambda (fn x)
    (foldl + 0 (map fn x))))

(define p1
  (lambda (x)
    (- (floor (/ x 3)) 2)))

(define p2
  (lambda (x)
    (define (loop acc x)
      (if (<= x 0)
          acc
          (loop (+ acc x) (p1 x))))
    (loop 0 (p1 x))))

(define nums (map string->number (file->lines "./input/01.txt")))
(printf "~a~n~a~n" (sum p1 nums) (sum p2 nums))
