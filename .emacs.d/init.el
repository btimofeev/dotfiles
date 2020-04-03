;; Определяем операционную систему
(defun system-is-linux()
    (string-equal system-type "gnu/linux"))

(defun system-is-mac()
    (string-equal system-type "darwin"))

(defun system-is-windows()
    (string-equal system-type "windows-nt"))

;; Настраиваем адрес прокси-сервера
(when (system-is-windows)
  (setq url-proxy-services
    '(("no_proxy" . "^\\(localhost\\|10.*\\)")
     ("http" . "192.168.100.1:3128")
     ("https" . "192.168.100.1:3128"))))

;; Добавляем репозирории
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Устанавливаем use-package если не установлен
(unless (package-installed-p 'use-package)
  (message "EMACS install use-package.el")
  (package-refresh-contents)
  (package-install 'use-package))

;; Загружаем use-package
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
;;(setq use-package-always-ensure t) ;; автоматически устанавливаем остальные пакеты, при необходимости

;; Пробуем пакеты без установки
(use-package try
  :ensure t
  :defer t)

;; Директория для дополнительных модулей
(add-to-list 'load-path "~/.emacs.d/lisp")

;; Директория для бэкапов
(setq backup-directory-alist `(("." . "~/.emacs.d/bakups")))

;; Запускаем Emacs как сервер
;; (use-package server
;;   :ensure t
;;   :init (server-mode 1)
;;   :config
;;   (unless (server-running-p)
;;     (server-start)))

;; Заполняем личные данные
(setq user-full-name   "Boris Timofeev"
      user-mail-adress "btimofeev@emunix.org")

;; Настраиваем компоненты GUI
(tool-bar-mode     -1) ;; выключить тулбар
(scroll-bar-mode -1) ;; выключить скроллбар
(blink-cursor-mode -1) ;; не мигать курсором
(setq use-dialog-box     nil) ;; не показывать диалоги
(setq redisplay-dont-pause t) ;; не прерывать перересовку экрана при событиях ввода 
(setq ring-bell-function 'ignore) ;; не мигать экраном
(defalias 'yes-or-no-p 'y-or-n-p) ;; принимать y/n вместо yes/no
(setq frame-title-format "GNU Emacs: %b") ;; отображать имя буфера в строке заголовка
(setq inhibit-startup-screen t) ;; не показывать экран помощи при старте
(fringe-mode '(8 . 0)) ;; органичитель текста только слева
(size-indication-mode t) ;; отображать размер файла в строке статуса
(global-visual-line-mode t) ;; переносить строки во всех буферах

(global-hl-line-mode 1) ;; подсвечивать текущую строку
(show-paren-mode t) ;; подсвечивать скобки {}, [], ()
(electric-pair-mode    1) ;; автоматически закрывать скобки {}, [], ()
(delete-selection-mode t) ;; удалять выделенный текст при вводе текста
(setq-default indent-tabs-mode t) ;; конвертировать табы в пробелы (t - нет, nil - да)

;; определяем вид и количество отступов для c-кода
(setq c-default-style "linux" 
      c-basic-offset 8)

(setq scroll-step 1) ;; при скролле сдвигать экран по 1 строке
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; мышью также

(define-key global-map [(insert)] nil) ;; Ins не включает режим замены

;; Цветовая тема
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'sanityinc-tomorrow-eighties t)

(set-language-environment 'utf-8) ;; кодировка текста

;; Функция меняет кодировку текста для текущего буфера
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

;; Отображать номера строк
(if (version< emacs-version "26.1")
    (use-package linum
      :hook ((prog-mode . linum-mode)  ;; только для кода
             (text-mode . linum-mode)) ;; и обычного текста, ибо просмотр pdf тормозит из-за этого режима
      :config
      (progn
        (line-number-mode   t)
        (global-linum-mode  0)
        (column-number-mode t)
        (setq linum-format " %d")))
  ;; в емаксе 26.1 и выше используем более быструю встроенную нумерацию строк:
  (global-display-line-numbers-mode))

;; Сохранять и восстанавливать позицию курсора в файле
(use-package saveplace
  :init (save-place-mode 1))

(use-package bs
  :bind ("C-x C-b" . bs-show)) ;; диалог выбора буфера

(use-package ibuffer
  :bind ("<f2>" . ibuffer)) ;; отдельный список буферов

;; Перемещаться между окнами через M-стрелки
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; IDO
(use-package ido
  :init (ido-mode t)
  :config
    (when (system-is-windows) ;; отключаем часть, т.к. в Windows 7 подвисает
      (setq ido-enable-last-directory-history nil)
      (setq ido-record-commands nil)
      (setq ido-max-work-directory-list 0)
      (setq ido-max-work-file-list 0)))

;; Dired+
(use-package dired+
  :init
  (progn
    (setq diredp-hide-details-initially-flag nil))
  :config
  (diredp-toggle-find-file-reuse-dir 1))

;; Org-mode
(use-package org
  :mode ("\\.org$" . org-mode)
  :bind (("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture))
  :config
  (progn
    (setq org-startup-indented t)
    (setq org-default-notes-file "~/documents/org/notes.org")))

;; Magit
(use-package magit
  :bind ("C-x g" . magit-status))

;; Отображать скрытые символы
(use-package whitespace
  :bind ("<f9>" . whitespace-mode))

;; Для работы горячих клавиш в русской раскладке
(use-package reverse-im
  :ensure t
  :config
  (reverse-im-activate "russian-computer"))

;; Отображать подсказки по горячим клавишам
(use-package which-key
  :ensure t
  :config
  (which-key-setup-side-window-right)
  (which-key-mode))

;; DocView (pdf reader)
(use-package doc-view
  :commands doc-view-mode
  :config
  (setq doc-view-resolution 300)
  (define-key doc-view-mode-map (kbd "<right>") 'doc-view-next-page)
  (define-key doc-view-mode-map (kbd "<left>") 'doc-view-previous-page))

;; FB2-mode
(use-package fb2-mode
  :load-path "~/.emacs.d/lisp/fb2-mode"
  :mode ("\\.fb2$" . fb2-mode)
  :ensure nil)

;; nov.el epub reader
(use-package nov
  :mode ("\\.epub$" . nov-mode))

;; easy-hugo
(use-package easy-hugo
  :bind ("C-c C-e" . easy-hugo)
  :init (setq easy-hugo-basedir "~/dev/web/emunix-hugo/")
        (setq easy-hugo-url "https://emunix.org")
        (setq easy-hugo-previewtime "300"))

;; emms
(use-package emms-setup
  :config
  (emms-all)
  (emms-default-players))

(use-package emms-volume)

(use-package emms
  :bind ("<f12>" . emms)
  :config
  (progn
    (setq emms-playlist-buffer-name "Music-EMMS")
    (setq emms-source-file-default-directory "~/music/"))
    (define-emms-simple-player xmp '(file)
      (regexp-opt '(".AMF" ".ADSC" ".669" ".DIGI" ".DBM" ".MDL" ".PSM" ".FAR"
         		".FT" ".XM" ".GMC" ".IMF" ".IT" ".LIQ" ".MTM" ".NTP"
	        	".MMD0" ".MMD1" ".MMD2" ".MMD3" ".OKTA"	".PTM" ".MOD"
		        ".PT36" ".EMOD" ".RTM" ".STM" ".S3M" ".SFX" ".ST26" ".ULT"
		        ".amf" ".adsc" ".digi" ".dbm" ".mdl" ".psm" ".far"
		        ".ft" ".xm" ".gmc" ".imf" ".it" ".liq" ".mtm" ".ntp"
		        ".mmd0" ".mmd1" ".mmd2" ".mmd3" ".okta"	".ptm" ".mod"
                        ".pt36" ".emod" ".rtm" ".stm" ".s3m" ".sfx" ".st26" ".ult")) "xmp" "-q")
    (define-emms-simple-player zxtune123 '(file)
      (regexp-opt '(".pt3" ".PT3" ".ay" ".AY" ".stp" ".STP" ".stc" ".STC"
                    ".stp1" ".STP1" ".pt2" ".PT2"
                    ".vgm" ".VGM" ".vgz" ".VGZ" ".nsf" ".NSF" ".spc" ".SPC" ".gbs" ".GBS")) "zxtune123" "--silent")
    (add-to-list 'emms-player-list 'emms-player-xmp)
    (add-to-list 'emms-player-list 'emms-player-zxtune123))

;; elfeed
(use-package elfeed
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-feeds '("http://love2d.org/releases.xml"
			       "https://emunix.org/index.xml"
			       "https://habr.com/ru/rss/hub/android_dev/all/?fl=ru%2Cen"))
  (setq elfeed-sort-order 'ascending))

;; slime
(use-package slime
  :ensure t
  :defer t
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (use-package slime-company
    :ensure t)
  (add-hook 'slime-mode-hook
            (lambda ()
              (load (expand-file-name "~/quicklisp/slime-helper.el"))
              (add-to-list 'slime-contribs 'slime-fancy)
              (add-to-list 'slime-contribs 'inferior-slime))))

;; markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(global-unset-key (kbd "C-x C-j")) ;; чтобы dired не конфликтовал с jabber

;; jabber.el
(use-package jabber
  :defer t
  :config
  (setq jabber-history-enabled t
        jabber-use-global-history nil
        fsm-debug nil)
  :bind
  ("C-x C-j C-c" . jabber-connect-all)
  :custom
  (jabber-auto-reconnect t)
  (jabber-chat-buffer-format "*-jc-%n-*")
  (jabber-groupchat-buffer-format "*-jg-%n-*")
  (jabber-chat-foreign-prompt-format "▼ [%t] %n> ")
  (jabber-chat-local-prompt-format "▲ [%t] %n> ")
  (jabber-muc-colorize-foreign t)
  (jabber-muc-private-buffer-format "*-jmuc-priv-%g-%n-*")
  (jabber-rare-time-format "%e %b %Y %H:00")
  (jabber-resource-line-format "   %r - %s [%p]")
  (jabber-roster-buffer "*-jroster-*")
  (jabber-roster-line-format "%c %-17n")
  (jabber-roster-show-title nil)
  (jabber-roster-sort-functions (quote (jabber-roster-sort-by-status jabber-roster-sort-by-displayname jabber-roster-sort-by-group)))
  (jabber-show-offline-contacts nil)
  (jabber-show-resources nil))

;; Эмоджи
(use-package emojify
  :config (if (display-graphic-p)
               (setq emojify-display-style 'image)
             (setq emojify-display-style 'unicode)
             )
  :init (global-emojify-mode 1))

;; free-keys помогает найти незанятые сочетания клавиш
;; Если запускать как C-u M-x free-keys то можно указать префикс вида C-x
(use-package free-keys
  :ensure t
  :defer t
  :commands free-keys)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(custom-safe-themes
   (quote
    ("d9129a8d924c4254607b5ded46350d68cc00b6e38c39fc137c3cfb7506702c12" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" default)))
 '(org-agenda-files (quote ("~/Documents/org/work.org")))
 '(package-selected-packages
   (quote
    (emojify use-package-secrets quelpa-use-package quelpa free-keys try jabber yasnippet yasnippet-snippets slime-company ac-slime slime elfeed love-minor-mode gnugo emms groovy-mode gradle-mode which-key pkgbuild-mode use-package reverse-im monokai-theme ducpel dracula-theme dired+ diminish color-theme-sanityinc-tomorrow))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "SRC" :slant normal :weight normal :height 98 :width normal))))
 '(org-level-1 ((t (:inherit default :foreground "#FD971F" :height 1.0))))
 '(org-level-2 ((t (:inherit default :foreground "#A6E22E" :height 1.0))))
 '(org-level-3 ((t (:inherit default :foreground "#66D9EF" :height 1.0))))
 '(org-level-4 ((t (:inherit default :foreground "#E6DB74" :height 1.0)))))
