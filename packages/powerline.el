;;; powerline.el --- Rewrite of Powerline

;; Copyright (C) 2012-2013 Donald Ephraim Curtis
;; Copyright (C) 2013 Jason Milkins
;; Copyright (C) 2013 Dewdrops
;; Copyright (C) 2012 Nicolas Rougier

;; Author: Donald Ephraim Curtis <dcurtis@milkbox.net>
;; URL: http://github.com/Dewdrops/powerline/
;; Version: 2.4
;; Keywords: mode-line
;; Package-Requires: ((cl-lib "0.2"))

;;; Commentary:
;;
;; Powerline is a library for customizing the mode-line that is based on the Vim
;; Powerline. A collection of predefined themes comes with the package.
;;

;;; Code:

(require 'powerline-themes)
(require 'powerline-separators)

(require 'cl-lib)

(defface powerline-active1 '((t (:foreground "#FBF1C7" :background "#282828" :inherit mode-line)))
  "Powerline face 1."
  :group 'powerline)

(defface powerline-active2 '((t (:foreground "#FBF1C7" :background "#1D2021" :inherit mode-line)))
  "Powerline face 2."
  :group 'powerline)

(defface powerline-active3 '((t (:foreground "#FBF1C7" :background "#282828" :inherit mode-line)))
  "Powerline face 3."
  :group 'powerline)

(defface powerline-inactive1
  '((t (:foreground "#FBF1C7" :background "#1D2021" :inherit mode-line-inactive)))
  "Powerline face 1."
  :group 'powerline)

(defface powerline-inactive2
  '((t (:foreground "#FBF1C7" :background "#1D2021" :inherit mode-line-inactive)))
  "Powerline face 2."
  :group 'powerline)

(defcustom powerline-default-separator 'arrow
  "The separator to use for the default theme.

Valid Values: arrow, slant, chamfer, wave, brace, roundstub,
zigzag, butt, rounded, contour, curve"
  :group 'powerline
  :type '(choice (const alternate)
                 (const arrow)
                 (const arrow-fade)
                 (const bar)
                 (const box)
                 (const brace)
                 (const butt)
                 (const chamfer)
                 (const contour)
                 (const curve)
                 (const rounded)
                 (const roundstub)
                 (const slant)
                 (const wave)
                 (const zigzag)
                 (const nil)))

(defcustom powerline-default-separator-dir '(left . right)
  "The separator direction to use for the default theme.

CONS of the form (DIR . DIR) denoting the lean of the
separators for the left and right side of the powerline.

DIR must be one of: left, right"
  :group 'powerline
  :type '(cons (choice :tag "Left Hand Side" (const left) (const right))
               (choice :tag "Right Hand Side" (const left) (const right))))

(defcustom powerline-height nil
  "Override the mode-line height."
  :group 'powerline
  :type '(choice integer (const nil)))

(defcustom powerline-text-scale-factor nil
  "Scale of mode-line font size to default text size.

Smaller mode-line fonts will be a float value less that 1.
Larger mode-line fonts require a float value greater than 1.

This is needed to make sure that text is properly aligned."
  :group 'powerline
  :type '(choice float integer (const nil)))

(defcustom powerline-buffer-size-suffix t
  "Display the buffer size suffix."
  :group 'powerline
  :type 'boolean)

(defcustom powerline-use-hud t
  "Whether to show hud in the rightmost"
  :group 'powerline
  :type 'boolean)

(defun pl/create-or-get-cache ()
  "Return a frame-local hash table that acts as a memoization cache for powerline. Create one if the frame doesn't have one yet."
  (or (frame-parameter nil 'powerline-cache)
      (pl/reset-cache)))

(defun pl/reset-cache ()
  "Reset and return the frame-local hash table used for a memoization cache."
  (let ((table (make-hash-table :test 'equal)))
    ;; Store it as a frame-local variable
    (modify-frame-parameters nil `((powerline-cache . ,table)))
    table))

;; from memoize.el @ http://nullprogram.com/blog/2010/07/26/
(defun pl/memoize (func)
  "Memoize FUNC.
If argument is a symbol then install the memoized function over
the original function.  Use frame-local memoization."
  (cl-typecase func
    (symbol (fset func (pl/memoize-wrap-frame-local (symbol-function func))) func)
    (function (pl/memoize-wrap-frame-local func))))

(defun pl/memoize-wrap-frame-local (func)
  "Return the memoized version of FUNC.
The memoization cache is frame-local."
  (let ((funcid (cl-gensym)))
    `(lambda (&rest args)
       ,(concat (documentation func) (format "\n(memoized function %s)" funcid))
       (let* ((cache (pl/create-or-get-cache))
              (key (cons ',funcid args))
              (val (gethash key cache)))
         (if val
             val
           (puthash key (apply ,func args) cache))))))

(defun pl/separator-height ()
  "Get default height for rendering separators."
  (or powerline-height (frame-char-height)))

(defun powerline-reset ()
  "Reset memoized functions."
  (interactive)
  (pl/memoize (pl/alternate left))
  (pl/memoize (pl/alternate right))
  (pl/memoize (pl/arrow left))
  (pl/memoize (pl/arrow right))
  (pl/memoize (pl/arrow-fade left))
  (pl/memoize (pl/arrow-fade right))
  (pl/memoize (pl/bar left))
  (pl/memoize (pl/bar right))
  (pl/memoize (pl/box left))
  (pl/memoize (pl/box right))
  (pl/memoize (pl/brace left))
  (pl/memoize (pl/brace right))
  (pl/memoize (pl/butt left))
  (pl/memoize (pl/butt right))
  (pl/memoize (pl/chamfer left))
  (pl/memoize (pl/chamfer right))
  (pl/memoize (pl/contour left))
  (pl/memoize (pl/contour right))
  (pl/memoize (pl/curve left))
  (pl/memoize (pl/curve right))
  (pl/memoize (pl/rounded left))
  (pl/memoize (pl/rounded right))
  (pl/memoize (pl/roundstub left))
  (pl/memoize (pl/roundstub right))
  (pl/memoize (pl/slant left))
  (pl/memoize (pl/slant right))
  (pl/memoize (pl/wave left))
  (pl/memoize (pl/wave right))
  (pl/memoize (pl/zigzag left))
  (pl/memoize (pl/zigzag right))
  (pl/memoize (pl/nil left))
  (pl/memoize (pl/nil right))
  (pl/reset-cache))

(powerline-reset)

(defun pl/make-xpm (name color1 color2 data)
  "Return an XPM image with NAME using COLOR1 for enabled and COLOR2 for disabled bits specified in DATA."
  (when window-system
    (create-image
     (concat
      (format "/* XPM */
static char * %s[] = {
\"%i %i 2 1\",
\". c %s\",
\"  c %s\",
"
              (downcase (replace-regexp-in-string " " "_" name))
              (length (car data))
              (length data)
              (or (pl/hex-color color1) "None")
              (or (pl/hex-color color2) "None"))
      (let ((len  (length data))
            (idx  0))
        (apply 'concat
               (mapcar #'(lambda (dl)
                           (setq idx (+ idx 1))
                           (concat
                            "\""
                            (concat
                             (mapcar #'(lambda (d)
                                         (if (eq d 0)
                                             (string-to-char " ")
                                           (string-to-char ".")))
                                     dl))
                            (if (eq idx len)
                                "\"};"
                              "\",\n")))
                       data))))
     'xpm t :ascent 'center)))

(defun pl/percent-xpm
  (height pmax pmin winend winstart width color1 color2)
  "Generate percentage xpm of HEIGHT for PMAX to PMIN given WINEND and WINSTART with WIDTH and COLOR1 and COLOR2."
  (let* ((height- (1- height))
         (fillstart (round (* height- (/ (float winstart) (float pmax)))))
         (fillend (round (* height- (/ (float winend) (float pmax)))))
         (data nil)
         (i 0))
    (while (< i height)
      (setq data (cons
                  (if (and (<= fillstart i)
                           (<= i fillend))
                      (append (make-list width 1))
                    (append (make-list width 0)))
                  data))
      (setq i (+ i 1)))
    (pl/make-xpm "percent" color1 color2 (reverse data))))

(pl/memoize 'pl/percent-xpm)

;;;###autoload
(defun powerline-hud (face1 face2 &optional width)
  "Return an XPM of relative buffer location using FACE1 and FACE2 of optional WIDTH."
  (unless width (setq width 2))
  (let ((color1 (if face1 (face-attribute face1 :background) "None"))
        (color2 (if face2 (face-attribute face2 :background) "None"))
        (height (or powerline-height (frame-char-height)))
        pmax
        pmin
        (ws (window-start))
        (we (window-end)))
    (save-restriction
      (widen)
      (setq pmax (point-max))
      (setq pmin (point-min)))
    (pl/percent-xpm height pmax pmin we ws
                    (* (frame-char-width) width) color1 color2)))

;;;###autoload
(defun powerline-mouse (click-group click-type string)
  "Return mouse handler for CLICK-GROUP given CLICK-TYPE and STRING."
  (cond ((eq click-group 'minor)
         (cond ((eq click-type 'menu)
                `(lambda (event)
                   (interactive "@e")
                   (minor-mode-menu-from-indicator ,string)))
               ((eq click-type 'help)
                `(lambda (event)
                   (interactive "@e")
                   (describe-minor-mode-from-indicator ,string)))
               (t
                `(lambda (event)
                   (interactive "@e")
                   nil))))
        (t
         `(lambda (event)
            (interactive "@e")
            nil))))

;;;###autoload
(defun powerline-concat (&rest strings)
  "Concatonate STRINGS and pad sides by spaces."
  (concat
   " "
   (mapconcat 'identity (delq nil strings) " ")
   " "))

;;;###autoload
(defmacro defpowerline (name body)
  "Create function NAME by wrapping BODY with powerline padding an propetization."
  `(defun ,name
     (&optional face pad)
     (powerline-raw ,body face pad)))

(defun pl/property-substrings (str prop)
  "Return a list of substrings of STR when PROP change."
  (let ((beg 0) (end 0)
        (len (length str))
        (out))
    (while (< end (length str))
      (setq end (or (next-single-property-change beg prop str) len))
      (setq out (append out (list (substring str beg (setq beg end))))))
    out))

(defun pl/assure-list (item)
  "Assure that ITEM is a list."
  (if (listp item)
      item
    (list item)))

(defun pl/add-text-property (str prop val)
  (mapconcat
   (lambda (mm)
     (let ((cur (pl/assure-list (get-text-property 0 'face mm))))
       (propertize mm 'face (append cur (list val)))))
   (pl/property-substrings str prop)
   ""))

;;;###autoload
(defun powerline-raw (str &optional face pad)
  "Render STR as mode-line data using FACE and optionally PAD import on left (l) or right (r)."
  (when str
    (let* ((rendered-str (format-mode-line str))
           (padded-str (concat
                        (when (and (> (length rendered-str) 0) (eq pad 'l)) " ")
                        (if (listp str) rendered-str str)
                        (when (and (> (length rendered-str) 0) (eq pad 'r)) " "))))
      (if face
          (pl/add-text-property padded-str 'face face)
        padded-str))))

;;;###autoload
(defun powerline-fill (face reserve)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when powerline-text-scale-factor
    (setq reserve (* powerline-text-scale-factor reserve)))
  (when (and window-system (eq 'right (get-scroll-bar-mode)))
    (setq reserve (- reserve 3)))
  (propertize " "
              'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))
              'face face))

(defun powerline-fill-center (face reserve)
  "Return empty space using FACE to the center of remaining space leaving RESERVE space on the right."
  (unless reserve
    (setq reserve 20))
  (when powerline-text-scale-factor
    (setq reserve (* powerline-text-scale-factor reserve)))
  (propertize " "
              'display `((space :align-to (- (+ center (.5 . right-margin)) ,reserve
                                             (.5 . left-margin))))
              'face face))

;;;###autoload
(defpowerline powerline-major-mode
  (propertize (format-mode-line mode-name)
              'mouse-face 'mode-line-highlight
              'help-echo "Major mode\n\ mouse-1: Display major mode menu\n\ mouse-2: Show help for major mode\n\ mouse-3: Toggle minor modes"
              'local-map (let ((map (make-sparse-keymap)))
                           (define-key map [mode-line down-mouse-1]
                             `(menu-item ,(purecopy "Menu Bar") ignore
                                         :filter (lambda (_) (mouse-menu-major-mode-map))))
                           (define-key map [mode-line mouse-2] 'describe-mode)
                           (define-key map [mode-line down-mouse-3] mode-line-mode-menu)
                           map)))

;;;###autoload
(defpowerline powerline-minor-modes
  (mapconcat (lambda (mm)
               (propertize mm
                           'mouse-face 'mode-line-highlight
                           'help-echo "Minor mode\n mouse-1: Display minor mode menu\n mouse-2: Show help for minor mode\n mouse-3: Toggle minor modes"
                           'local-map (let ((map (make-sparse-keymap)))
                                        (define-key map
                                          [mode-line down-mouse-1]
                                          (powerline-mouse 'minor 'menu mm))
                                        (define-key map
                                          [mode-line mouse-2]
                                          (powerline-mouse 'minor 'help mm))
                                        (define-key map
                                          [mode-line down-mouse-3]
                                          (powerline-mouse 'minor 'menu mm))
                                        (define-key map
                                          [header-line down-mouse-3]
                                          (powerline-mouse 'minor 'menu mm))
                                        map)))
             (split-string (format-mode-line minor-mode-alist))
             (propertize " " 'face face)))

;;;###autoload
(defpowerline powerline-narrow
  (let (real-point-min real-point-max)
    (save-excursion
      (save-restriction
        (widen)
        (setq real-point-min (point-min) real-point-max (point-max))))
    (when (or (/= real-point-min (point-min))
              (/= real-point-max (point-max)))
      (propertize "Narrow"
                  'mouse-face 'mode-line-highlight
                  'help-echo "mouse-1: Remove narrowing from the current buffer"
                  'local-map (make-mode-line-mouse-map
                              'mouse-1 'mode-line-widen)))))

;;;###autoload
(defpowerline powerline-vc
  (when (and (buffer-file-name (current-buffer))
             vc-mode)
    (format-mode-line '(vc-mode vc-mode))))

;;;###autoload
(defpowerline powerline-buffer-size
  (propertize
   (if powerline-buffer-size-suffix
       "%I"
     "%i")
   'mouse-face 'mode-line-highlight
   'local-map (make-mode-line-mouse-map
               'mouse-1 (lambda () (interactive)
                          (setq powerline-buffer-size-suffix
                                (not powerline-buffer-size-suffix))
                          (force-mode-line-update)))))

;;;###autoload
(defpowerline powerline-buffer-id
  #("%12b" 0 4
    (local-map
     (keymap
      (mode-line keymap
                 (mouse-2 . swbuff-kill-this-buffer)
                 (mouse-3 . swbuff-switch-to-next-buffer)
                 (mouse-1 . swbuff-switch-to-previous-buffer)))
     mouse-face mode-line-highlight
     help-echo "mouse-1: Previous buffer\nmouse-2: Kill buffer\nmouse-3: Next buffer")))

;;;###autoload
(defpowerline powerline-recursive-left
  #("%[" 0 2
    (help-echo "Recursive edit, type C-M-c to get out")))

;;;###autoload
(defpowerline powerline-recursive-right
  #("%]" 0 2
    (help-echo "Recursive edit, type C-M-c to get out")))

;;;###autoload
(defpowerline powerline-process
  (cond
   ((symbolp mode-line-process) (symbol-value mode-line-process))
   ((listp mode-line-process) (format-mode-line mode-line-process))
   (t mode-line-process)))

;;;###autoload
(defpowerline powerline-frame-id
  (if (or (null window-system)
          (eq window-system 'pc))
      "-%F "
    ""))

;;;###autoload
(defpowerline powerline-client
  (if (frame-parameter nil 'client)
      "@"
    ""))

;;;###autoload
(defpowerline powerline-remote
  (propertize
   (if (file-remote-p default-directory)
       "@"
     "")
   'mouse-face 'mode-line-highlight
   'help-echo (purecopy (lambda (window _object _point)
                          (format "%s"
                                  (with-selected-window window
                                    (concat
                                     (if (file-remote-p default-directory)
                                         "Current directory is remote: "
                                       "Current directory is local: ")
                                     default-directory)))))))

;;;###autoload
(defpowerline powerline-which-func
  (propertize
   (replace-regexp-in-string "%" "%%"
                             (or
                              (gethash
                               (selected-window)
                               which-func-table)
                              which-func-unknown))
   'mouse-face 'mode-line-highlight
   'help-echo "mouse-1: go to beginning\n\
mouse-2: toggle rest visibility\nmouse-3: go to end"
   'local-map which-func-keymap
   'face 'which-func))

;;;###autoload
(defpowerline powerline-life
  (propertize
   (concat "Generation " life-generation-string)))

;;;###autoload
(defpowerline powerline-fancy-battery
  (propertize
   (when fancy-battery-last-status
     (let* ((time (cdr (assq ?t fancy-battery-last-status)))
            (percentage (cdr (assq ?p fancy-battery-last-status)))
            (status (if (or fancy-battery-show-percentage
                            (string= time "N/A"))
                        (and percentage (concat (concat percentage "%%")
                                                " (" time ")"))
                      time)))
       (if status (concat " " status)
         ;; Battery status is not available
         "N/A")))
   'mouse-face 'mode-line-highlight
   'face (pcase (cdr (assq ?b fancy-battery-last-status))
           ("!"  'fancy-battery-critical)
           ("+"  ' fancy-battery-charging)
           (_ 'fancy-battery-discharging))))

;;;###autoload
(defpowerline powerline-position
  (if (eq major-mode 'paradox-menu-mode)
      (concat
       " (%l / "
       (int-to-string (line-number-at-pos (point-max)))
       ")")
  (concat
   (if (and column-number-mode line-number-mode)
       (propertize
        " (%l,%2c)"
        'local-map mode-line-column-line-number-mode-map
        'mouse-face 'mode-line-highlight
        'help-echo "Line number and Column number\n\
mouse-1: Display Line and Column Mode Menu")
     (if line-number-mode
         (propertize
          " L%l"
          'local-map mode-line-column-line-number-mode-map
          'mouse-face 'mode-line-highlight
          'help-echo "Line Number\n\
mouse-1: Display Line and Column Mode Menu")
       (if column-number-mode
           (propertize
            " C%c"
            'local-map mode-line-column-line-number-mode-map
            'mouse-face 'mode-line-highlight
            'help-echo "Column number\n\
mouse-1: Display Line and Column Mode Menu")
         "")))
   (propertize
    " %p"
    'local-map mode-line-column-line-number-mode-map
    'mouse-face 'mode-line-highlight
    'help-echo "Size indication mode\n\
mouse-1: Display Line and Column Mode Menu")
   (if size-indication-mode
       (propertize
        " of %I"
        'local-map mode-line-column-line-number-mode-map
        'mouse-face 'mode-line-highlight
        'help-echo "Size indication mode\n\
mouse-1: Display Line and Column Mode Menu")
     ""))))

(eval-after-load 'wc-mode
  '(defpowerline powerline-wc-mode
     (if (use-region-p)
         (format " %d,%d,%d"
                 (abs (- (point) (mark)))
                 (count-words-region (point) (mark))
                 (abs (- (line-number-at-pos (point))
                         (line-number-at-pos (mark)))))
       (format " %d,%d,%d"
               (point-max)
               (count-words-region (point-min) (point-max))
               (line-number-at-pos (point-max))))))

(eval-after-load 'paradox
  '(defpowerline powerline-paradox
     (concat
      (if paradox--current-filter (concat "[" paradox--current-filter "]"))
      (if paradox--upgradeable-packages-any?
          (concat "  Upgrade:" (int-to-string paradox--upgradeable-packages-number)))
      (if package-menu--new-package-list
          (concat "  New:" (int-to-string (paradox--cas "new"))))
      " Installed:" (int-to-string (+ (paradox--cas "installed") (paradox--cas "unsigned")))
      (if paradox--current-filter
          "" (concat "  Total:" (int-to-string (length package-archive-contents)))))))

(eval-after-load 'evil
  '(progn
     (defface powerline-evil-insert-face
       '((((class color))
          :foreground "#FBF1C7" :background "#B8BB26" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil insert state"
       :group 'powerline)

     (defface powerline-evil-normal-face
       '((((class color))
          :foreground "#FBF1C7" :background "#FB4934" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil normal state"
       :group 'powerline)

     (defface powerline-evil-visual-face
       '((((class color))
          :foreground "#FBF1C7" :background "#FABD2F" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil visual state"
       :group 'powerline)

     (defface powerline-evil-motion-face
       '((((class color))
          :foreground "#FBF1C7" :background "#83A598" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil motion state"
       :group 'powerline)

     (defface powerline-evil-emacs-face
       '((((class color))
          :foreground "#FBF1C7" :background "#D3869D" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil emacs state"
       :group 'powerline)

     (defface powerline-evil-replace-face
       '((((class color))
          :foreground "#FBF1C7" :background "#1D2021" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil replace state"
       :group 'powerline)

     (defface powerline-evil-operator-face
       '((((class color))
          :foreground "#FBF1C7" :background "#458588" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil operator state"
       :group 'powerline)

     (defface powerline-evil-iedit-face
       '((((class color))
          :foreground "#FBF1C7" :background "#FB4934" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil iedit state"
       :group 'powerline)

     (defface powerline-evil-iedit-insert-face
       '((((class color))
          :foreground "#FBF1C7" :background "#8EC07C" :weight bold :inherit mode-line)
         (t (:weight bold)))
       "face to fontify evil iedit insert state"
       :group 'powerline)

     (defun powerline-evil-face (active)
       (let ((face (intern (concat "powerline-evil-" (symbol-name evil-state) "-face"))))
         (cond ((and active (facep face))
                face)
               (active 'powerline-active2)
               (t 'powerline-inactive2))))

     (defun powerline-evil-tag ()
       (cond
        ((and (evil-visual-state-p) (eq evil-visual-selection 'block))
         " +V+ ")
        ((and (evil-visual-state-p) (eq evil-visual-selection 'line))
         " -V- ")
        (t
         evil-mode-line-tag)))
     ))

(defvar pl/default-mode-line mode-line-format)

(defvar pl/minibuffer-selected-window-list '())

(defun pl/minibuffer-selected-window ()
  "Return the selected window when entereing the minibuffer."
  (when pl/minibuffer-selected-window-list
    (car pl/minibuffer-selected-window-list)))

(defun pl/minibuffer-setup ()
  "Save the `minibuffer-selected-window' to `pl/minibuffer-selected-window'."
  (push (minibuffer-selected-window) pl/minibuffer-selected-window-list))

(add-hook 'minibuffer-setup-hook 'pl/minibuffer-setup)

(defun pl/minibuffer-exit ()
  "Set `pl/minibuffer-selected-window' to nil."
  (pop pl/minibuffer-selected-window-list))

(add-hook 'minibuffer-exit-hook 'pl/minibuffer-exit)

(defun powerline-selected-window-active ()
  "Return whether the current window is active."
  (or (eq (frame-selected-window)
          (selected-window))
      (and (minibuffer-window-active-p
            (frame-selected-window))
           (eq (pl/minibuffer-selected-window)
               (selected-window)))))

(defun powerline-revert ()
  "Revert to the default Emacs mode-line."
  (interactive)
  (setq-default mode-line-format pl/default-mode-line))

(defun pl/render (item)
  "Render a powerline ITEM."
  (cond
   ((and (listp item) (eq 'image (car item)))
    (propertize " " 'display item
                'face (plist-get (cdr item) :face)))
   (item item)))

(defun powerline-render (values)
  "Render a list of powerline VALUES."
  (mapconcat 'pl/render values ""))

(defun powerline-width (values)
  "Get the length of VALUES."
  (if values
      (let ((val (car values)))
        (+ (cond
            ((stringp val) (length (format-mode-line val)))
            ((and (listp val) (eq 'image (car val)))
             (car (image-size val)))
            (t 0))
           (powerline-width (cdr values))))
    0))

;; Define swbuff-switch-to-next-buffer in case we don't
;; yet have it.
(when (not (fboundp 'swbuff-switch-to-next-buffer))
        (defun swbuff-switch-to-next-buffer ()
               (interactive)
               (next-buffer)))

;; Same for swbuff-switch-to-previous-buffer and swbuff-kill-this-buffer.
(when (not (fboundp 'swbuff-switch-to-previous-buffer))
        (defun swbuff-switch-to-previous-buffer ()
               (interactive)
               (previous-buffer)))


(when (not (fboundp 'swbuff-kill-this-buffer))
        (defun swbuff-kill-this-buffer ()
               (interactive)
               (kill-buffer)))

(provide 'powerline)

;;; powerline.el ends here
