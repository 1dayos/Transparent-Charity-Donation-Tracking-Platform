;; Expense Tracking Contract
;; Documents how funds are used

(define-map expenses {id: uint} {
  project-id: uint,
  amount: uint,
  description: (string-ascii 128),
  recipient: principal,
  timestamp: uint
})

(define-data-var expense-count uint u0)
(define-data-var total-expenses uint u0)

;; Function to record a new expense
(define-public (record-expense (project-id uint) (amount uint) (description (string-ascii 128)) (recipient principal))
  (let
    (
      (new-id (+ (var-get expense-count) u1))
      (current-time (get-block-info? time (- block-height u1)))
    )
    (begin
      ;; Record the expense
      (map-set expenses {id: new-id} {
        project-id: project-id,
        amount: amount,
        description: description,
        recipient: recipient,
        timestamp: (default-to u0 current-time)
      })

      ;; Increment expense count
      (var-set expense-count new-id)

      ;; Update total expenses
      (var-set total-expenses (+ (var-get total-expenses) amount))

      ;; Return success with the new expense ID
      (ok new-id)
    )
  )
)

;; Read-only function to get an expense
(define-read-only (get-expense (expense-id uint))
  (ok (map-get? expenses {id: expense-id}))
)

;; Read-only function to get total expenses
(define-read-only (get-total-expenses)
  (ok (var-get total-expenses))
)

;; Read-only function to get expense count
(define-read-only (get-expense-count)
  (ok (var-get expense-count))
)

