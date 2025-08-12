;; Student Certificate Issuer Contract
;; Stores and verifies student certificates on the blockchain

;; Storage: mapping from student principal to certificate details
(define-map certificates principal (string-ascii 128))

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-issued (err u101))
(define-constant err-not-found (err u102))

;; Function 1: Issue a certificate (Only Owner)
(define-public (issue-certificate (student principal) (certificate_details (string-ascii 128)))
(begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (map-get? certificates student)) err-already-issued)
    (map-set certificates student certificate_details)
    (ok true)
))

;; Function 2: Verify a certificate (Anyone)
(define-public (verify-certificate (student principal))
(let ((cert (map-get? certificates student)))
    (if (is-some cert)
        (ok cert)
        err-not-found
    )
))

