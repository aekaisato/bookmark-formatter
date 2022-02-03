#lang racket

(require yaml)

(define (parse-file p)
  (file->yaml p))

(define (parse-folder p)
  (define m (build-path p "__meta.yaml"))
  (define h (file->yaml (build-path p "__meta.yaml")))
  (hash-set! h "contents" (parse-from p)) h)

(define (parse-meta p)
  (cond
    [(file-starts-with? p ".") #f]
    [(eq? (file-or-directory-type p) 'directory) (parse-folder p)]
    [(and
       (eq? (file-or-directory-type p) 'file)
       (string-suffix? (path->string p) ".yaml")
       (not (file-starts-with? p "__"))) (parse-file p)]
    [else #f]))

(define (parse-from p)
  (filter (lambda (x) (not (eq? x #f))) (map (lambda (x) (parse-meta (build-path p x))) (directory-list p))))

(define (get-path s)
  (build-path (current-directory) s))

(define (file-starts-with? p s)
  (let-values
    ([(path file b) (split-path p)])
     (string-prefix? (path->string file) s)))

(provide get-path parse-from)

; (pretty-print (parse-from (get-path (vector-ref (current-command-line-arguments) 0))))
