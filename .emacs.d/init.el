;; Настраиваем адрес прокси-сервера
;; (setq url-proxy-services
;;       '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;; 	("http" . "192.168.100.1:3128")
;; 	("https" . "192.168.100.1:3128")))

;; Добавляем репозитории
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

;; Устанавливаем отдельный файл для custom настроек
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Заполняем личные данные
(setq user-full-name   "Boris Timofeev"
      user-mail-adress "btimofeev@emunix.org")

;; Настраиваем компоненты GUI
(tool-bar-mode -1) ;; выключить тулбар
(menu-bar-mode -1) ;; выключить меню
(scroll-bar-mode -1) ;; выключить скроллбар
(blink-cursor-mode -1) ;; не мигать курсором
(setq use-dialog-box     nil) ;; не показывать диалоги
(setq redisplay-dont-pause t) ;; не прерывать перересовку экрана при событиях ввода 
(setq ring-bell-function 'ignore) ;; не мигать экраном
(defalias 'yes-or-no-p 'y-or-n-p) ;; принимать y/n вместо yes/no
(setq frame-title-format "GNU Emacs: %b") ;; отображать имя буфера в строке заголовка
(setq inhibit-startup-screen t) ;; не показывать экран помощи при старте
(fringe-mode 0) ;; отключить полосы справа и слева отображающие перенос строки
(size-indication-mode t) ;; отображать размер файла в строке статуса
(global-visual-line-mode t) ;; переносить строки во всех буферах

(global-hl-line-mode -1) ;; не подсвечивать текущую строку
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
;;(load-theme 'sanityinc-tomorrow-eighties t)
(load-theme 'sanityinc-tomorrow-day t)

(set-language-environment 'utf-8) ;; кодировка текста

;; Сохранять и восстанавливать позицию курсора в файле
(use-package saveplace
  :init (save-place-mode 1))

;; Диалог выбора буффера
(use-package bs
  :bind ("C-x C-b" . bs-show))

;; Перемещаться между окнами через M-стрелки
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; Ace-jump - быстрое перемещение к любому символу на экране
(use-package ace-jump-mode
  :ensure    t
  :bind      (("C-." . #'ace-jump-mode)
	      ("C-c SPC" . #'ace-jump-line-mode)))

;; Автодополнение 
(use-package company
  :ensure t
  :init (global-company-mode 1)
  :config
  (setq company-idle-delay 0.3)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer))

;; Helm
(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
	 ("C-x r b" . helm-filtered-bookmarks)
         ("C-x b" . helm-mini))
  :config (progn
	    (setq helm-buffers-fuzzy-matching t)
	    (setq helm-recentf-fuzzy-match t)
	    (setq helm-M-x-fuzzy-match t)
            (helm-mode 1)))

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
  :ensure nil
  :config
  (setq fb2-replace-hard-space t))

;; nov.el epub reader
(use-package nov
  :mode ("\\.epub$" . nov-mode))

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

;; Раскрашиваем вывод комманды M-x man
(use-package man
  :defer t
  :custom-face
  (Man-overstrike ((t (:inherit font-lock-type-face :bold t))))
  (Man-underline ((t (:inherit font-lock-keyword-face :underline t)))))

;; Olivetti выравнивает текст по центру экрана
(use-package olivetty
  :bind ("C-c o" . olivetti-mode))

;; Функция меняет кодировку текста для текущего буфера
(use-package pa23-change-coding
  :ensure nil
  :load-path "~/.emacs.d/lisp/pa23-change-coding"
  :bind ("<f11>" . pa23-change-coding))

