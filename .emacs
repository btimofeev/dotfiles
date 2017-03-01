;; System-type definition
(defun system-is-linux()
  (string-equal system-type "gnu/linux"))
(defun system-is-windows()
  (string-equal system-type "windows-nt"))

;; Start Emacs as a server
(when (system-is-linux)
  (require 'server)
  (unless (server-running-p)
    (server-start)))

;; Repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; MS Windows path-variable
(when (system-is-windows)
  (setq win-sbcl-exe          "C:/sbcl/sbcl.exe")
  (setq win-init-slime-path   "C:/slime")
  (setq win-init-path         "C:/.emacs.d/lisp"))

;; Unix path-variable
(when (system-is-linux)
  (setq unix-sbcl-bin          "/usr/bin/sbcl")
  (setq unix-init-slime-path   "/usr/share/common-lisp/source/slime/")
  (setq unix-init-path         "~/.emacs.d/lisp"))

;; Load path for plugins
(if (system-is-windows)
  (add-to-list 'load-path win-init-path)
  (add-to-list 'load-path unix-init-path))

;; My name and e-mail adress
(setq user-full-name   "Boris Timofeev")
(setq user-mail-adress "btimofeev@emunix.org")

;; Dired
(require 'dired)
(setq dired-recursive-deletes 'top) ;; чтобы можно было непустые директории удалять...

;; Display the name of the current buffer in the title bar
(setq frame-title-format "GNU Emacs: %b")

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t) ;; экран приветствия можно вызвать комбинацией C-h C-a

;; Org-mode settings
(require 'org) ;; Вызвать org-mode
(global-set-key "\C-ca" 'org-agenda) ;; определение клавиатурных комбинаций для внутренних
(global-set-key "\C-cb" 'org-iswitchb) ;; подрежимов org-mode
(global-set-key "\C-cl" 'org-store-link)
(add-to-list 'auto-mode-alist '("\\.org$" . Org-mode)) ;; ассоциируем *.org файлы с org-mode

;; Show-paren-mode settings
(show-paren-mode t) ;; включить выделение выражений между {},[],()
(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()

;; Electric-modes settings
(electric-pair-mode    1) ;; автозакрытие {},[],() с переводом курсора внутрь скобок

;; Delete selection
(delete-selection-mode t)

;; GUI components
;;(tooltip-mode      -1)
;;(menu-bar-mode     -1) ;; отключаем графическое меню
(tool-bar-mode     -1) ;; отключаем tool-bar
;;(scroll-bar-mode   -1) ;; отключаем полосу прокрутки
(blink-cursor-mode -1) ;; курсор не мигает
(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq visible-bell t) ;; мигать строкой статуса вместо писка
;;(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал
(defalias 'yes-or-no-p 'y-or-n-p) ;; вопросы

;; Coding-system settings
(set-language-environment 'UTF-8)
(if (system-is-linux) ;; для GNU/Linux кодировка utf-8, для MS Windows - windows-1251
    (progn
        (setq default-buffer-file-coding-system 'utf-8)
        (setq-default coding-system-for-read    'utf-8)
        (setq file-name-coding-system           'utf-8)
        (set-selection-coding-system            'utf-8)
        (set-keyboard-coding-system        'utf-8-unix)
        (set-terminal-coding-system             'utf-8)
        (prefer-coding-system                   'utf-8))
    (progn
        (prefer-coding-system                   'windows-1251)
        (set-terminal-coding-system             'windows-1251)
        (set-keyboard-coding-system        'windows-1251-unix)
        (set-selection-coding-system            'windows-1251)
        (setq file-name-coding-system           'windows-1251)
        (setq-default coding-system-for-read    'windows-1251)
        (setq default-buffer-file-coding-system 'windows-1251)))

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк

;; Fringe settings
(fringe-mode '(8 . 0)) ;; органичиталь текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева

;; Display file size in mode-line
(size-indication-mode          t) ;; показывать размер файла

;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f2>") 'bs-show) ;; запуск buffer selection кнопкой F2
1
;; Theme
;;(load-theme 'monokai t)

;; Scrolling settings
(setq scroll-step               1) ;; вверх-вниз по 1 строке
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; также мышкой
(setq scroll-margin            5) ;; сдвигать буфер верх/вниз когда курсор в n шагах от верхней/нижней границы
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; IDO
(require 'ido)
(ido-mode t)

;; SLIME settings
(defun run-slime()
  (require 'slime)
  (require 'slime-autoloads)
  (setq slime-net-coding-system 'utf-8-unix)
  (slime-setup '(slime-fancy slime-asdf slime-indentation))) ;; загрузить основные дополнения Slime
;;;; for MS Windows
(when (system-is-windows)
  (when (and (file-exists-p win-sbcl-exe) (file-directory-p win-init-slime-path))
    (setq inferior-lisp-program win-sbcl-exe)
    (add-to-list 'load-path win-init-slime-path)
    (run-slime)))
;;;; for GNU/Linux
(when (system-is-linux)
  (when (and (file-exists-p unix-sbcl-bin) (file-directory-p unix-init-slime-path))
    (setq inferior-lisp-program unix-sbcl-bin)
    (add-to-list 'load-path unix-init-slime-path)
    (run-slime)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c7a9a68bd07e38620a5508fef62ec079d274475c8f92d75ed0c33c45fbe306bc" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
