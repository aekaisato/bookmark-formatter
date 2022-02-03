#lang racket

(require "string-contains.rkt")

(define FMT-START "<bm-fmt>")
(define FMT-END "</bm-fmt>")
(define FO-FMT-START "<fo-fmt>")
(define FO-FMT-END "</fo-fmt>")
(define FI-FMT-START "<fi-fmt>")
(define FI-FMT-END "</fi-fmt>")

(define NAME-TAG "$name")
(define CONTENT-TAG "$content")
(define URL-TAG "$url")

(define (format-text h f)
  (define start-index (string-contains f FMT-START))
  (define end-index (string-contains f FMT-END))
  (define bm-fmt (substring f (+ start-index (string-length FMT-START)) end-index))

  (define fo-start-index (string-contains bm-fmt FO-FMT-START))
  (define fo-end-index (string-contains bm-fmt FO-FMT-END))
  (define fi-start-index (string-contains bm-fmt FI-FMT-START))
  (define fi-end-index (string-contains bm-fmt FI-FMT-END))

  (define fo-fmt (substring bm-fmt (+ fo-start-index (string-length FO-FMT-START)) fo-end-index))
  (define fi-fmt (substring bm-fmt (+ fi-start-index (string-length FI-FMT-START)) fi-end-index))

  (string-replace f (substring f start-index (+ end-index (string-length FMT-END))) (format-bm fo-fmt fi-fmt h)))

(define (format-bm fo-fmt fi-fmt h [s ""])
  (cond
    [(and (hash? h) (hash-has-key? h "url")) (string-append s (format-tags fi-fmt h))] ; file
    [(hash? h) (string-append s (format-fo fo-fmt fi-fmt h (format-bm fo-fmt fi-fmt (hash-ref h "contents") s)))] ; folder
    [(list? h) (foldr (lambda (x y) (string-append (format-bm fo-fmt fi-fmt x s) y)) s h)])) ; list of files / folders

(define (format-tags fmt h)
  (cond
    [(hash-empty? h) fmt]
    [else
      (define k (list-ref (hash-keys h) 0))
      (define hr (hash-copy h))
      (define t (string-append "$" k))
      (define v (hash-ref h k))
      (hash-remove! hr k)
      (format-tags (string-replace fmt t (if (string? v) v t)) hr)]))

(define (format-fo fo-fmt fi-fmt h [content #f])
  (string-replace (format-tags fo-fmt h) "$content" (format-bm fo-fmt fi-fmt (hash-ref h "contents"))))

(define format-fi format-tags)

(provide format-text)
