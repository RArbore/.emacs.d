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

;; Custom themes
(use-package melancholy-theme
  :ensure t)
(load-theme 'melancholy t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(doom-modeline which-key melancholy-theme use-package evil-collection)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Fonts
(set-face-attribute 'default nil
		    :font "Fira Mono 12"
		    :weight 'medium)
(set-face-attribute 'variable-pitch nil
		    :font "Fira Mono 12"
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :font "Fira Mono 12"
		    :weight 'medium)
(add-to-list 'default-frame-alist '(font . "Fira Mono 12"))

;; Zoom
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-uP>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; GUI settings
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Which key
(use-package which-key
  :ensure t)
(which-key-mode)

;; Mode line configuration
(line-number-mode)
(column-number-mode)
(size-indication-mode)
(use-package doom-modeline
  :ensure t)
(doom-modeline-mode)
(use-package all-the-icons
  :ensure t)
(set-face-background 'mode-line "#222222")
(set-face-foreground 'mode-line "#F92672")
