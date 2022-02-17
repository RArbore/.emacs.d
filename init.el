(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
(setq debug-on-error t)

;; MELPA packages
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
;; (package-refresh-contents)
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Evil mode
(use-package evil
	     :ensure t
	     :init
	     (setq evil-want-integration t)
	     (setq evil-want-keybinding nil)
	     (setq evil-vsplit-window-right t)
	     (setq evil-split-window-below t)
	     (evil-mode))

;; Evil in buffers that aren't strictly text
(use-package evil-collection
	     :after evil
	     :ensure t
	     :config
	     (evil-collection-init))

;; Theme
(add-to-list 'custom-theme-load-path "/home/russel/.emacs.d/packages")
(load-theme 'russel t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files nil)
 '(package-selected-packages
   '(flycheck peep-dired dired-open all-the-icons-dired vterm all-the-icons flycheck-haskell rainbow-mode powerline-evil haskell-mode projectile toc-org org-bullets dashboard magit markdown-mode general gcmh which-key melancholy-theme use-package evil-collection))
 '(safe-local-variable-values '((c-basic-offset 2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Fonts
(set-face-attribute 'default nil
		    :height 120
		    :weight 'medium)
(set-face-attribute 'variable-pitch nil
		    :height 120
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :height 120
		    :weight 'medium)

;; Zoom
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-uP>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; GUI settings
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

;; Which key
(use-package which-key
  :ensure t
  :init
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → " ))
(which-key-mode)

;; Mode line configuration
(line-number-mode)
(column-number-mode)
(size-indication-mode)
(use-package all-the-icons
  :ensure t)

;; VTerm
(use-package vterm
  :ensure t)
(set-face-foreground 'vterm-color-black "#1c1f24")
(set-face-background 'vterm-color-black "#54595e")
(set-face-foreground 'vterm-color-red "#f74c66")
(set-face-background 'vterm-color-red "#f9788c")
(set-face-foreground 'vterm-color-green "#98be65")
(set-face-background 'vterm-color-green "#b1ce8b")
(set-face-foreground 'vterm-color-yellow "#ecbe7b")
(set-face-background 'vterm-color-yellow "#efcb95")
(set-face-foreground 'vterm-color-blue "#2c97f4")
(set-face-background 'vterm-color-blue "#60b1f6")
(set-face-foreground 'vterm-color-magenta "#c678dd")
(set-face-background 'vterm-color-magenta "#d499e5")
(set-face-foreground 'vterm-color-cyan "#46d9ff")
(set-face-background 'vterm-color-cyan "#74e2ff")
(set-face-foreground 'vterm-color-white "#dfdfdf")
(set-face-background 'vterm-color-white "#e7e7e7")

;; Performance
;; Using garbage magic hack.
(use-package gcmh
  :ensure t
  :config
  (gcmh-mode 1))
;; Setting garbage collection threshold
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; General keybinding
(use-package general
  :ensure t
  :config
  (general-evil-setup t))

;; Buffer keybindings
(nvmap :prefix "SPC"
       "b b"   '(ibuffer :which-key "Ibuffer")
       "b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
       "b k"   '(kill-current-buffer :which-key "Kill current buffer")
       "b n"   '(next-buffer :which-key "Next buffer")
       "b p"   '(previous-buffer :which-key "Previous buffer")
       "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
       "b K"   '(kill-buffer :which-key "Kill buffer"))

;; Dired keybindings
(use-package all-the-icons-dired
  :ensure t)
(use-package dired-open
  :ensure t)
(use-package peep-dired
  :ensure t)
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
               "d d" '(dired :which-key "Open dired")
               "d j" '(dired-jump :which-key "Dired jump to current")
               "d p" '(peep-dired :which-key "Peep-dired"))
(with-eval-after-load 'dired
  ;;(define-key dired-mode-map (kbd "M-p") 'peep-dired)
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

;; File keybindings
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
       "."     '(find-file :which-key "Find file")
       "f f"   '(find-file :which-key "Find file")
       "f r"   '(counsel-recentf :which-key "Recent files")
       "f s"   '(save-buffer :which-key "Save file")
       "f u"   '(sudo-edit-find-file :which-key "Sudo find file")
       "f y"   '(dt/show-and-copy-buffer-path :which-key "Yank file path")
       "f C"   '(copy-file :which-key "Copy file")
       "f D"   '(delete-file :which-key "Delete file")
       "f R"   '(rename-file :which-key "Rename file")
       "f S"   '(write-file :which-key "Save file as...")
       "f U"   '(sudo-edit :which-key "Sudo edit file"))

;; M-x stuff
(nvmap :keymaps 'override :prefix "SPC"
       "SPC"   '(execute-extended-command :which-key "M-x"))

;; Language packages
(use-package markdown-mode :ensure t)

;; Magit
(setq bare-git-dir (concat "--git-dir=" (expand-file-name "~/.dotfiles")))
(setq bare-work-tree (concat "--work-tree=" (expand-file-name "~")))
(defun me/magit-status-bare ()
  "set --git-dir and --work-tree in `magit-git-global-arguments' to `bare-git-dir' and `bare-work-tree' and calls `magit-status'"
  (interactive)
  (require 'magit-git)
  (add-to-list 'magit-git-global-arguments bare-git-dir)
  (add-to-list 'magit-git-global-arguments bare-work-tree)
  (call-interactively 'magit-status))
(defun me/magit-status ()
  "removes --git-dir and --work-tree in `magit-git-global-arguments' and calls `magit-status'"
  (interactive)
  (require 'magit-git)
  (setq magit-git-global-arguments (remove bare-git-dir magit-git-global-arguments))
  (setq magit-git-global-arguments (remove bare-work-tree magit-git-global-arguments))
  (call-interactively 'magit-status))
(use-package magit
  :ensure t)
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
       "g g"   '(magit :which-key "Magit status")
       "g b"   '(magit-branch :which-key "Magit switch branch")
       "g C"   '(magit-clone :which-key "Magit clone")
       "g F"   '(magit-fetch :which-key "Magit fetch"))
(setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer
         (cond ((and (derived-mode-p 'magit-mode)
                     (eq (with-current-buffer buffer major-mode)
                         'magit-status-mode))
                nil)
               ((memq (with-current-buffer buffer major-mode)
                      '(magit-process-mode
                        magit-revision-mode
                        magit-diff-mode
                        magit-stash-mode))
                nil)
               (t
                '(display-buffer-same-window))))))

;; Scrolling
(setq scroll-conservatively 101) 
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) 
(setq mouse-wheel-progressive-speed t) 
(setq mouse-wheel-follow-mouse 't) 

;; Window keybindings
(winner-mode 1)
(define-key evil-motion-state-map " " nil)
(define-key evil-motion-state-map (kbd "SPC w c") 'evil-window-delete)
(define-key evil-motion-state-map (kbd "SPC w n") 'evil-window-new)
(define-key evil-motion-state-map (kbd "SPC w s") 'evil-window-split)
(define-key evil-motion-state-map (kbd "SPC w v") 'evil-window-vsplit)
(define-key evil-motion-state-map (kbd "SPC w h") 'evil-window-left)
(define-key evil-motion-state-map (kbd "SPC w j") 'evil-window-down)
(define-key evil-motion-state-map (kbd "SPC w k") 'evil-window-up)
(define-key evil-motion-state-map (kbd "SPC w l") 'evil-window-right)
(define-key evil-motion-state-map (kbd "SPC w H") 'evil-window-move-far-left)
(define-key evil-motion-state-map (kbd "SPC w J") 'evil-window-move-very-bottom)
(define-key evil-motion-state-map (kbd "SPC w K") 'evil-window-move-very-top)
(define-key evil-motion-state-map (kbd "SPC w L") 'evil-window-move-far-right)
(define-key evil-motion-state-map (kbd "SPC w w") 'evil-window-next)
(define-key evil-motion-state-map (kbd "SPC w <left>") 'winner-undo)
(define-key evil-motion-state-map (kbd "SPC w <right>") 'winner-redo)

;; Dashboard
(use-package dashboard
  :ensure t
  :init
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-startup-banner "~/.emacs.d/emacs-dash.png")
  (setq dashboard-center-content t)
  (setq dashboard-set-navigator t)
  (setq dashboard-items '((recents . 10)
                          (agenda . 5 )
                          (bookmarks . 3))))

;; Load newer files
(setq load-prefer-newer t)

;; Org mode
(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-directory "~/Documents/Org/"
      org-agenda-files '("~/Documents/Org/Agenda.org")
      org-default-notes-file (expand-file-name "Notes.org" org-directory)
      org-ellipsis " ▼ "
      org-log-done 'time
      org-journal-dir "~/Documents/Org/Journal/"
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org"
      org-hide-emphasis-markers t)
(setq org-src-preserve-indentation nil
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)
(use-package org-bullets
  :ensure t)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "BLOG(b)"
           "GYM(g)"
           "PROJ(p)"
           "VIDEO(v)"
           "WAIT(w)"
           "|"
           "DONE(d)"
           "CANCELLED(c)")))
(setq org-src-fontify-natively t
    org-src-tab-acts-natively t
    org-confirm-babel-evaluate nil
    org-edit-src-content-indentation 0)
(use-package toc-org
  :ensure t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))
(setq org-blank-before-new-entry (quote ((heading . nil)
                                         (plain-list-item . nil))))

;; Projectile
(use-package projectile
  :ensure t
  :config
  (projectile-global-mode))

;; Backup files
(setq backup-directory-alist `(("." . "~/.local/saves")))

;; C tabbing
(setq-default c-basic-offset 4)

;; Flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Powerline / modeline
(setq load-path
	(append (list
       		"/home/russel/.emacs.d/packages"
		)
		load-path))
(load "powerline")
(powerline-russel-evil-theme)

;; C++
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++20")))

;; Zig
(autoload 'zig-mode "zig-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))

;; Haskell
(use-package haskell-mode
  :ensure t)
;;(add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(setq haskell-process-type 'cabal-repl)
(setq-default toggle-truncate-lines t)

;; Rainbow mode
(use-package rainbow-mode
  :ensure t
  :config
  (rainbow-mode))

;; Scratch
(defun scratch ()
  "create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
        bufname)
    (while (progn
             (setq bufname (concat "*scratch"
                                   (if (= n 0) "" (int-to-string n))
                                   "*"))
             (setq n (1+ n))
             (get-buffer bufname)))
  (switch-to-buffer (get-buffer-create bufname))
  (if (= n 1) initial-major-mode))) ; 1, because n was incremented
(global-set-key (kbd "C-c s") 'scratch)

;; Bluespec
;; (setq load-path
;; 	(append (list
;; 		"/home/russel/Applications/clones/bsc-emacs/bsv-mode"
;; 		)
;; 		load-path))
;; (load "bsv-mode")
