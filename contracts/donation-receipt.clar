;; Donation Receipt Contract
;; Records incoming contributions to the charity

(define-data-var total-donations uint u0)
(define-map donations principal {amount: uint, timestamp: uint})
(define-map donor-totals principal uint)

;; Function to make a donation
(define-public (donate)
  (let
    (
      (sender tx-sender)
      (amount (get-donation-amount))
      (current-time (get-block-info? time (- block-height u1)))
      (current-total (default-to u0 (map-get? donor-totals sender)))
    )
    (begin
      ;; Update total donations
      (var-set total-donations (+ (var-get total-donations) amount))

      ;; Record this specific donation
      (map-set donations sender {
        amount: amount,
        timestamp: (default-to u0 current-time)
      })

      ;; Update donor's total contributions
      (map-set donor-totals sender (+ current-total amount))

      ;; Return success with the amount donated
      (ok amount)
    )
  )
)

;; Helper function to get donation amount from current transaction
(define-private (get-donation-amount)
  (stx-get-balance tx-sender)
)

;; Read-only function to get total donations
(define-read-only (get-total-donations)
  (ok (var-get total-donations))
)

;; Read-only function to get a donor's total contributions
(define-read-only (get-donor-total (donor principal))
  (ok (default-to u0 (map-get? donor-totals donor)))
)

;; Read-only function to get a specific donation
(define-read-only (get-donation (donor principal))
  (ok (map-get? donations donor))
)

