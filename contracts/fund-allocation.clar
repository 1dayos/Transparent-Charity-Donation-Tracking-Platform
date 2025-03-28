;; Fund Allocation Contract
;; Manages distribution to specific projects

(define-map projects {id: uint} {name: (string-ascii 64), allocation: uint, active: bool})
(define-data-var project-count uint u0)
(define-data-var total-allocated uint u0)

;; Function to create a new project
(define-public (create-project (name (string-ascii 64)) (allocation uint))
  (let
    (
      (new-id (+ (var-get project-count) u1))
    )
    (begin
      ;; Create the new project
      (map-set projects {id: new-id} {name: name, allocation: allocation, active: true})

      ;; Increment project count
      (var-set project-count new-id)

      ;; Update total allocated
      (var-set total-allocated (+ (var-get total-allocated) allocation))

      ;; Return success with the new project ID
      (ok new-id)
    )
  )
)

;; Function to update a project's allocation
(define-public (update-allocation (project-id uint) (new-allocation uint))
  (let
    (
      (project (unwrap! (map-get? projects {id: project-id}) (err u1)))
      (old-allocation (get allocation project))
    )
    (begin
      ;; Update the project
      (map-set projects {id: project-id}
        (merge project {allocation: new-allocation}))

      ;; Update total allocated
      (var-set total-allocated (+ (- (var-get total-allocated) old-allocation) new-allocation))

      ;; Return success
      (ok true)
    )
  )
)

;; Function to deactivate a project
(define-public (deactivate-project (project-id uint))
  (let
    (
      (project (unwrap! (map-get? projects {id: project-id}) (err u1)))
    )
    (begin
      ;; Update the project to inactive
      (map-set projects {id: project-id}
        (merge project {active: false}))

      ;; Return success
      (ok true)
    )
  )
)

;; Read-only function to get a project
(define-read-only (get-project (project-id uint))
  (ok (map-get? projects {id: project-id}))
)

;; Read-only function to get total allocated funds
(define-read-only (get-total-allocated)
  (ok (var-get total-allocated))
)

;; Read-only function to get project count
(define-read-only (get-project-count)
  (ok (var-get project-count))
)

