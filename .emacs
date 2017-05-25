;;--------------基础配置--------------------------------
;;(setq default-directory "/home/zosy/Documents/") ;默认目录
;;(setq split-height-threshold nil)
;;(setq split-width-threshold 0);;分为左右两个窗口

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq tool-bar-style 'image) ;;去掉tool-bar上的文字
(show-paren-mode 1) ;;高亮成对的括号
(setq show-paren-style 'parentheses)

(global-linum-mode t) ;;显示行号
(electric-pair-mode t) ;; brackets auto pair
(electric-indent-mode t) ;; 缩进
(setq default-tab-width 4)  ;;tab4字符宽
;;(setq-default indent-tabs-mode nil)
(setq c-default-style "linux")
(setq c-basic-offset 4)
(setq inhibit-startup-message t) ;;关闭启动页
(global-set-key (kbd "RET") 'newline-and-indent) ;;回车缩进

;;设置M-SPC作为标志位，默认C-@来setmark,C-@不太好用
(global-set-key (kbd "M-SPC") 'set-mark-command)
;;禁用工具条
;;(tool-bar-mode 0)
;;禁用滚动条
(scroll-bar-mode 0)
;; 在标题栏提示你目前在什么位置  
(setq frame-title-format
      '("%S" (buffer-file-name "%f"
							   (dired-directory  dired-directory "%b"))))
;;光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。  
(setq mouse-avoidance-mode 'animate)

;; backup goto ~/.emacs.d/backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;;backup type copy
(setq backup-by-copying t)

;; F10:注释/取消注释
(global-set-key [f10] 'comment-or-uncomment-region)

;;----------- highlight selected text color----------------
(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")
;;(global-hl-line-mode 1) ;; turn on highlighting current line
;;(set-face-background 'highlight "#BCDAB8")
;;----------- highlight selected text color end------------

;;;;------------set company candidate color-----------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal))))
 '(company-preview ((t (:foreground "lightgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-annotation ((t (:foreground "#AA0000"))))
 '(company-tooltip-common ((t (:background "lightgray" :foreground "#000000" :weight bold))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white")))))
;;;;------------set company candidate color end ------------

;;--------------------------一键快速编译-------------------
(defun quick-compile()
  (interactive)
  ;;(compile (concat "gcc -g -Wall -I/usr/include/mariadb/ -L/usr/lib/x86_64-linux-gnu/ -lmysqlclient `pkg-config --cflags --libs gtk+-3.0` " (file-name-nondirectory buffer-file-name)))
  (save-some-buffers t)
  (compile (concat "gcc  -Wall -g -ansi -pedantic -DDEBUG=9 "  (file-name-nondirectory buffer-file-name)   " -o "  (file-name-sans-extension  (file-name-nondirectory buffer-file-name)))))

(global-set-key[f5] 'quick-compile) ;;设置编译快捷键
;;--------------------------end-------------------------

;;--------------------------debug-----------------------
(defun quick-gdb()
  "A quick debug funciton for C++"
  (interactive)
  (gdb (concat "gdb --annotate=3 -i=mi " (file-name-sans-extension (file-name-nondirectory buffer-file-name) ))))

(global-set-key[f6] 'quick-gdb) ;;设置编调试捷键F6
(add-hook 'gdb-mode-hook '(lambda ()
                            (define-key c-mode-base-map [(f5)] 'gud-go)
							(define-key c-mode-base-map [(f7)] 'gud-next)
                            (define-key c-mode-base-map [(f8)] 'gud-step)
							(define-key c-mode-base-map [(f9)] 'gud-finish)
  							(define-key c-mode-base-map [(f10)] 'gud-until)
                            (define-key c-mode-base-map [(f11)] 'gud-cont)))

;;--------------------------end--------------------------

;;------------显示时间设置开始------------------------------
(setq display-time-format "%H:%M %A")   ;;设定时间显示格式
;;(setq display-time-day-and-date t)    ;;打开日期显示
(setq display-time-interval 1)          ;;刷新时间
(display-time-mode t)				    ;;显示时间
(setq display-time-24hr-format t)       ;;打开24小时显示模式  
;;(setq time-stamp-format "%3a %3b %2d %02H:%02M:%02S %:y (%z)") ;;设置时间戳的显示格式
;;------------显示时间设置结束------------------------------

;;------------auto-complete------------------------------
;; 选择菜单项的快捷键 
;;(setq ac-use-menu-map t)
;;(define-key ac-menu-map "\C-n" 'ac-next)
;;(define-key ac-menu-map "\C-p" 'ac-previous)
;;------------auto-complete end-------------------------

;;------------company-----------------------------------
(add-to-list 'load-path "~/.emacs.d/elpa/company-mode")
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(autoload 'company-mode "company" nil t)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-clang-arguments '("-I/usr/include/gtk-3.0" 
                                "-I/usr/include/glib-2.0"
                                "-I/usr/include/mysql"
								"-I/usr/include"
								))
;;------------company end--------------------------------


;;set shift+tab switch to last buffer
(global-set-key (kbd "<backtab>")
				#'(lambda ()
					(interactive)
					(switch-to-buffer (other-buffer (current-buffer) 1))))

;;逗号后自动加空格
;; (global-set-key (kbd ",")
;;                 #'(lambda ()
;;                     (interactive)
;;                     (insert ", ")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(show-paren-mode t)
 '(tool-bar-position (quote left)))

(put 'upcase-region 'disabled nil)
