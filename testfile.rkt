#lang racket

(require "parse-dir.rkt")
(require "format-text.rkt")

(define src (get-path (vector-ref (current-command-line-arguments) 0)))
(define fmt (file->string (vector-ref (current-command-line-arguments) 1)))

; (displayln (string-replace fmt "\\n" "\n"))

; (pretty-print (parse-from src))
(displayln (format-text (parse-from src) (string-replace fmt "\\n" "\n")))
