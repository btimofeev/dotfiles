;; -*- mode: elisp -*-

;; System-type definition
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))

(defun system-is-mac()
    (string-equal system-type "darwin"))

(defun system-is-windows()
    (string-equal system-type "windows-nt"))

;; Start Emacs as a server
(unless (system-is-windows)
  (require 'server)
  (unless (server-running-p)
    (server-start)))

;; Repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Directory for additional modules
(add-to-list 'load-path "~/.emacs.d/lisp")

;; My name and e-mail adress
(setq user-full-name   "Boris Timofeev"
      user-mail-adress "btimofeev@emunix.org")

;; GUI components
(tool-bar-mode     -1)
(blink-cursor-mode -1)
(setq use-dialog-box     nil)
(setq redisplay-dont-pause t)
(setq ring-bell-function 'ignore)

;; Short command confirmation
(defalias 'yes-or-no-p 'y-or-n-p)

;; Display the name of the current buffer in the title bar
(setq frame-title-format "GNU Emacs: %b")

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq inhibit-startup-message t)

;; Highlight current line
(global-hl-line-mode 1)

;; Highlight {}, [], ()
(show-paren-mode t)

;; Autoclose {}, [], ()
(electric-pair-mode    1)

;; Delete selection
(delete-selection-mode t)

;; Coding-system settings
(set-language-environment 'utf-8)

;; change coding for current buffer
(setq my-working-codings ["utf-8" "windows-1251" "koi8-r" "cp866"])
(setq my-current-coding-index -1)
(defun pa23-change-coding ()
  "Change coding for current buffer."
  (interactive)
  (let (my-current-eol
        my-next-coding-index
        my-new-coding-system
        my-new-coding)
    (setq my-current-eol
          (coding-system-eol-type buffer-file-coding-system))
    (setq my-next-coding-index (1+ my-current-coding-index))
    (if (equal my-next-coding-index (length my-working-codings))
        (setq my-next-coding-index 0))
    (setq my-new-coding-system
          (elt my-working-codings my-next-coding-index))
    (cond ((equal my-current-eol 0)
           (setq my-new-coding (concat my-new-coding-system "-unix")))
          ((equal my-current-eol 1)
           (setq my-new-coding (concat my-new-coding-system "-dos")))
          ((equal my-current-eol 2)
           (setq my-new-coding (concat my-new-coding-system "-mac"))))
    (setq coding-system-for-read (read my-new-coding))
    (revert-buffer t t)
    (setq my-current-coding-index my-next-coding-index)
    (message "Set coding %s." my-new-coding)
    )
  )
(global-set-key [f11] 'pa23-change-coding)

;; Display line numbers
(require 'linum)
(line-number-mode   t)
(global-linum-mode  0)
(column-number-mode t)
(setq linum-format " %d")
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'text-mode-hook 'linum-mode)

;; Fringe settings
(fringe-mode '(8 . 0)) ;; органичиталь текста только слева

;; Display file size in mode-line
(size-indication-mode          t)

;; Line wrapping
(setq word-wrap          t)
(global-visual-line-mode t)

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2

;; Theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;(load-theme 'monokai t)
;(load-theme 'zenburn t)
;(load-theme 'dracula t)
(load-theme 'sanityinc-tomorrow-eighties t)

;; Scrolling settings
(setq scroll-step               1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq scroll-margin            5)
(setq mouse-wheel-follow-mouse 't)

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; IDO
(require 'ido)
(ido-mode t)
(when (system-is-windows) ;; avoid freezes on windows 7
   (setq ido-enable-last-directory-history nil)
   (setq ido-record-commands nil)
   (setq ido-max-work-directory-list 0)
   (setq ido-max-work-file-list 0))

;; Dired+
(require 'dired+)
(diredp-toggle-find-file-reuse-dir 1)

;; Org-mode settings
(require 'org)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cl" 'org-store-link)
(setq org-startup-indented t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; FB2-mode
(add-to-list 'load-path "~/.emacs.d/lisp/fb2-mode")
(require 'fb2-mode)

;; nov.el epub reader
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; Proxy
;;(setq url-proxy-services
;;   '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;;     ("http" . "192.168.100.1:3128")
;;     ("https" . "192.168.100.1:3128")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "d9129a8d924c4254607b5ded46350d68cc00b6e38c39fc137c3cfb7506702c12" "c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" default)))
 '(org-agenda-files
   (quote
    ("~/documents/org/UniPatcher.org" "~/documents/org/emunix.org.org" "~/documents/org/personal.org" "~/documents/org/work.org")))
 '(package-selected-packages
   (quote
    (magit nov monokai-theme markdown-mode lua-mode go-mode dracula-theme dired+ color-theme-sanityinc-tomorrow auto-complete alert))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit default :foreground "#FD971F" :height 1.0))))
 '(org-level-2 ((t (:inherit default :foreground "#A6E22E" :height 1.0))))
 '(org-level-3 ((t (:inherit default :foreground "#66D9EF" :height 1.0))))
 '(org-level-4 ((t (:inherit default :foreground "#E6DB74" :height 1.0)))))
