;; Amendment Tracking System
;; Tracks all contract amendments and modifications

;; Constants
(define-constant ERR-NOT-AUTHORIZED (err u300))
(define-constant ERR-INVALID-INPUT (err u301))
(define-constant ERR-CONTRACT-NOT-FOUND (err u302))
(define-constant ERR-AMENDMENT-NOT-FOUND (err u303))
(define-constant ERR-ALREADY-APPROVED (err u304))
(define-constant ERR-ALREADY-REJECTED (err u305))

;; Data Variables
(define-data-var amendment-counter uint u0)

;; Data Maps
(define-map amendments
  { amendment-id: uint }
  {
    contract-id: uint,
    title: (string-ascii 100),
    description: (string-ascii 500),
    proposer: principal,
    proposal-block: uint,
    status: (string-ascii 20),
    approval-block: (optional uint),
    approver: (optional principal)
  }
)

(define-map amendment-details
  { amendment-id: uint }
  {
    old-value: (string-ascii 300),
    new-value: (string-ascii 300),
    field-changed: (string-ascii 50),
    impact-assessment: (string-ascii 400)
  }
)

(define-map contract-amendments
  { contract-id: uint }
  { amendment-ids: (list 50 uint) }
)

;; Private Functions
(define-private (is-valid-string (input (string-ascii 500)))
  (> (len input) u0)
)

(define-private (add-amendment-to-contract (contract-id uint) (amendment-id uint))
  (let
    (
      (current-amendments (default-to (list) (get amendment-ids (map-get? contract-amendments { contract-id: contract-id }))))
      (updated-amendments (unwrap! (as-max-len? (append current-amendments amendment-id) u50) ERR-INVALID-INPUT))
    )
    (map-set contract-amendments
      { contract-id: contract-id }
      { amendment-ids: updated-amendments }
    )
    (ok true)
  )
)

;; Public Functions

;; Add a new amendment
(define-public (add-amendment
  (contract-id uint)
  (title (string-ascii 100))
  (description (string-ascii 500)))
  (let
    (
      (caller tx-sender)
      (current-counter (var-get amendment-counter))
      (new-amendment-id (+ current-counter u1))
    )
    (asserts! (is-valid-string title) ERR-INVALID-INPUT)
    (asserts! (is-valid-string description) ERR-INVALID-INPUT)

    (map-set amendments
      { amendment-id: new-amendment-id }
      {
        contract-id: contract-id,
        title: title,
        description: description,
        proposer: caller,
        proposal-block: block-height,
        status: "pending",
        approval-block: none,
        approver: none
      }
    )

    (try! (add-amendment-to-contract contract-id new-amendment-id))
    (var-set amendment-counter new-amendment-id)
    (ok new-amendment-id)
  )
)

;; Set amendment details
(define-public (set-amendment-details
  (amendment-id uint)
  (old-value (string-ascii 300))
  (new-value (string-ascii 300))
  (field-changed (string-ascii 50))
  (impact-assessment (string-ascii 400)))
  (let
    (
      (caller tx-sender)
      (amendment-data (unwrap! (map-get? amendments { amendment-id: amendment-id }) ERR-AMENDMENT-NOT-FOUND))
    )
    (asserts! (is-eq caller (get proposer amendment-data)) ERR-NOT-AUTHORIZED)
    (asserts! (is-eq (get status amendment-data) "pending") ERR-NOT-AUTHORIZED)

    (map-set amendment-details
      { amendment-id: amendment-id }
      {
        old-value: old-value,
        new-value: new-value,
        field-changed: field-changed,
        impact-assessment: impact-assessment
      }
    )

    (ok true)
  )
)

;; Approve amendment
(define-public (approve-amendment (amendment-id uint))
  (let
    (
      (caller tx-sender)
      (amendment-data (unwrap! (map-get? amendments { amendment-id: amendment-id }) ERR-AMENDMENT-NOT-FOUND))
    )
    (asserts! (is-eq (get status amendment-data) "pending") ERR-ALREADY-APPROVED)

    (map-set amendments
      { amendment-id: amendment-id }
      (merge amendment-data {
        status: "approved",
        approval-block: (some block-height),
        approver: (some caller)
      })
    )

    (ok true)
  )
)

;; Reject amendment
(define-public (reject-amendment (amendment-id uint) (reason (string-ascii 200)))
  (let
    (
      (caller tx-sender)
      (amendment-data (unwrap! (map-get? amendments { amendment-id: amendment-id }) ERR-AMENDMENT-NOT-FOUND))
    )
    (asserts! (is-eq (get status amendment-data) "pending") ERR-ALREADY-REJECTED)
    (asserts! (is-valid-string reason) ERR-INVALID-INPUT)

    (map-set amendments
      { amendment-id: amendment-id }
      (merge amendment-data {
        status: "rejected",
        approval-block: (some block-height),
        approver: (some caller)
      })
    )

    (ok true)
  )
)

;; Read-only Functions

;; Get amendment details
(define-read-only (get-amendment (amendment-id uint))
  (map-get? amendments { amendment-id: amendment-id })
)

;; Get amendment details
(define-read-only (get-amendment-details (amendment-id uint))
  (map-get? amendment-details { amendment-id: amendment-id })
)

;; Get contract amendments
(define-read-only (get-contract-amendments (contract-id uint))
  (map-get? contract-amendments { contract-id: contract-id })
)

;; Get total number of amendments
(define-read-only (get-amendment-count)
  (var-get amendment-counter)
)

;; Check amendment status
(define-read-only (is-amendment-approved (amendment-id uint))
  (match (map-get? amendments { amendment-id: amendment-id })
    amendment-data (is-eq (get status amendment-data) "approved")
    false
  )
)
