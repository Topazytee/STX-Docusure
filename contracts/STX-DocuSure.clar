;; Document Verification Smart Contract
;; Enhanced version with improved security and validation

;; Error codes
(define-constant ERR-UNAUTHORIZED-ACCESS (err u100))
(define-constant ERR-DUPLICATE-DOCUMENT (err u101))
(define-constant ERR-DOCUMENT-MISSING (err u102))
(define-constant ERR-DOCUMENT-ALREADY-VERIFIED (err u103))
(define-constant ERR-INVALID-DOCUMENT-HASH-ID (err u104))
(define-constant ERR-INVALID-CONTENT-HASH (err u105))
(define-constant ERR-INVALID-METADATA (err u106))
(define-constant ERR-INVALID-AUTHORIZED-USER (err u107))
(define-constant ERR-INVALID-INPUT (err u108))
(define-constant ERR-PERMISSION-DENIED (err u109))

;; Constants for verification status
(define-constant STATUS-PENDING "PENDING")
(define-constant STATUS-VERIFIED "VERIFIED")

;; Define document record type
(define-data-var document-record-type 
    {
        document-owner: principal,
        document-content-hash: (buff 32),
        submission-timestamp: uint,
        verification-status: (string-ascii 20),
        verification-authority: (optional principal),
        document-metadata: (string-utf8 256),
        document-version: uint,
        verification-complete: bool
    }
    {
        document-owner: tx-sender,
        document-content-hash: 0x0000000000000000000000000000000000000000000000000000000000000000,
        submission-timestamp: u0,
        verification-status: STATUS-PENDING,
        verification-authority: none,
        document-metadata: u"",
        document-version: u0,
        verification-complete: false
    }
)

;; Data maps
(define-map document-records
    { document-hash-id: (buff 32) }
    {
        document-owner: principal,
        document-content-hash: (buff 32),
        submission-timestamp: uint,
        verification-status: (string-ascii 20),
        verification-authority: (optional principal),
        document-metadata: (string-utf8 256),
        document-version: uint,
        verification-complete: bool
    }
)

(define-map document-permissions
    { document-hash-id: (buff 32), authorized-user: principal }
    { document-viewing-permission: bool, document-verification-permission: bool }
)

;; Input validation functions
(define-private (check-buff-32 (input (buff 32)))
    (if (is-eq (len input) u32)
        (ok input)
        ERR-INVALID-INPUT)
)

(define-private (check-string-utf8 (input (string-utf8 256)))
    (if (and 
            (<= (len input) u256)
            (> (len input) u0))
        (ok input)
        ERR-INVALID-INPUT)
)

(define-private (check-principal (input principal))
    (if (and 
            (not (is-eq input tx-sender))
            (not (is-eq input (as-contract tx-sender))))
        (ok input)
        ERR-INVALID-INPUT)
)

;; Enhanced validation functions with consistent response types
(define-private (validate-and-sanitize-hash (hash (buff 32)))
    (check-buff-32 hash)
)

(define-private (validate-and-sanitize-metadata (metadata (string-utf8 256)))
    (check-string-utf8 metadata)
)

(define-private (validate-and-sanitize-user (document-owner principal) (authorized-user principal))
    (if (not (is-eq document-owner authorized-user))
        (ok authorized-user)
        ERR-INVALID-AUTHORIZED-USER)
)

;; Safe getter functions
(define-private (safe-get-document (document-hash-id (buff 32)))
    (ok (unwrap! (map-get? document-records { document-hash-id: document-hash-id })
        ERR-DOCUMENT-MISSING))
)
