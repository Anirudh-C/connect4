;;; The main connect4 module
(defun connect4()
  "Start playing connect4"
  (interactive)
  (switch-to-buffer "connect4")
  (connect4-mode)
  (connect4-init))

(define-derived-mode connect4-mode special-mode "connect4")

(defvar *connect4-board* nil
  "The connect4 board")

(defconst *connect4-banner* '"Welcome to Connect-4\n"
  "The connect 4 banner")

(defconst *connect4-size* 5
  "The size of the board: width and height")

(defvar *connect4-current-player* nil
  "Character Indicating current player")

(defun connect4-init ()
  "Initiate new game of connect4"
  (setq *connect4-board* (make-vector (* *connect4-size*
                                         *connect4-size*)
                                      ?\.))
  (setq *connect4-current-player* ?\X)
  (connect4-print-board))

(defun connect4-print-board ()
  "Print the board current board"
  (let ((inhibit-read-only t))
    (erase-buffer)
    (dotimes (row *connect4-size*)
      (dotimes (column *connect4-size*)
        (insert "| " (connect4-get-square row column) " "))
      (insert "|\n"))))

(defun connect4-get-square (row column)
  "Get the value at the (row,column) square"
  (elt *connect4-board*
       (+ column
          (* row
             *connect4-size*))))

(defun connect4-set-square (row column value)
  "Set the value in the (row, column) square"
  (aset *connect4-board*
        (+ column
           (* row
              *connect4-size*))
        value))

(defun connect4-mark ()
  "Mark the current square"
  (interactive)
  (let ((row (1- (line-number-at-pos)))
        (column (current-column)))
    (connect4-set-square row column *connect4-current-player*))
  (connect4-print-board)
  (when (connect4-game-has-been-won)
    (message "Congrats! Player %c won!" *connect4-current-player*))
  (connect4-swap-players))

(defun connect4-swap-players ()
  "Swap the current player"
  (setq *connect4-current-player*
        (if (char-equal *connect4-current-player*
                        ?\X)
            ?\O
          ?\X)))

(defun connect4-is-a-player (square)
  "Returns true if the square is a player"
  (or (char-equal square ?\X)
      (char-equal square ?\O)))

(defun connect4-all-same-player (sq1 sq2 sq3 sq4)
  "Check if the 4 squares sq1,sq2,sq3 and sq4 have the same character"
  (and (connect4-is-a-player sq1)
       (char-equal sq1 sq2)
       (char-equal sq2 sq3)
       (char-equal sq3 sq4)))

(defun connect4-game-has-been-won ()
  "Returns true if either player has won"
  (or (connect4-diagonal-win)
      (connect4-column-win)
      (connect4-row-win)))

(defun connect4-row-win ()
  "Returns true if a win is with a row 4"
  (let ((has-won nil))
    (dotimes (current-row *connect4-size*)
      (when (connect4-all-same-player (connect4-get-square current-row 0)
                                       (connect4-get-square current-row 1)
                                       (connect4-get-square current-row 2)
                                       (connect4-get-square current-row 3))
        (setq has-won t)))
    has-won))

(defun connect4-column-win ()
  "Returns true if a win is with a column 4"
  (let ((has-won nil))
    (dotimes (current-column *connect4-size*)
      (when (connect4-all-same-player (connect4-get-square 0 current-column)
                                       (connect4-get-square 1 current-column)
                                       (connect4-get-square 2 current-column)
                                       (connect4-get-square 3 current-column))
        (setq has-won t)))
    has-won))

(defun connect4-diagonal-win-helper(row column)
  "Returns true if the 4x4 matrix's diagonals are the same with the top left location as (row,column)"
  (or (connect4-all-same-player (connect4-get-square row column)
                                (connect4-get-square (+ 1 row) (+ 1 column))
                                (connect4-get-square (+ 2 row) (+ 2 column))
                                (connect4-get-square (+ 3 row) (+ 3 column)))
      (connect4-all-same-player (connect4-get-square row (+ 3 column))
                                (connect4-get-square (+ 1 row) (+ 2 column))
                                (connect4-get-square (+ 2 row) (+ 1 column))
                                (connect4-get-square (+ 3 row) column))))

(defun connect4-diagonal-win ()
  "Returns true if a win is with a diagonal 4"
  (or (connect4-diagonal-win-helper 0 0)
      (connect4-diagonal-win-helper 0 1)
      (connect4-diagonal-win-helper 1 0)
      (connect4-diagonal-win-helper 1 1)))
