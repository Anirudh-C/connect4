;;;; The main connect4 module
(defun connect4()
  "Start playing connect4"
  (interactive)
  (switch-to-buffer "connect4")
  (connect4-mode)
  (connect4-init))

(define-derived-mode connect4-mode special-mode "connect4")

(defvar *connect4-board* nil
  "The connect4 board")
