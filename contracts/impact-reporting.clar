;; Impact Reporting Contract
;; Quantifies and shares results of charitable work

(define-map impact-reports {id: uint} {
  project-id: uint,
  metric-name: (string-ascii 64),
  metric-value: uint,
  description: (string-ascii 256),
  timestamp: uint
})

(define-data-var report-count uint u0)

;; Function to create a new impact report
(define-public (create-report (project-id uint) (metric-name (string-ascii 64)) (metric-value uint) (description (string-ascii 256)))
  (let
    (
      (new-id (+ (var-get report-count) u1))
      (current-time (get-block-info? time (- block-height u1)))
    )
    (begin
      ;; Create the impact report
      (map-set impact-reports {id: new-id} {
        project-id: project-id,
        metric-name: metric-name,
        metric-value: metric-value,
        description: description,
        timestamp: (default-to u0 current-time)
      })

      ;; Increment report count
      (var-set report-count new-id)

      ;; Return success with the new report ID
      (ok new-id)
    )
  )
)

;; Read-only function to get an impact report
(define-read-only (get-report (report-id uint))
  (ok (map-get? impact-reports {id: report-id}))
)

;; Read-only function to get report count
(define-read-only (get-report-count)
  (ok (var-get report-count))
)

