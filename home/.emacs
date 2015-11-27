;;; .emacs --- My emacs config file
;;; Commentary:

;; Not much special goes on here

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;
;; Misc
;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<f7>") 'compile)
(setq vc-follow-symlinks t)
(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs.d/backups"))
)

;;;;;;;;;;;;;;;;;;;;;;
;; Package
;;;;;;;;;;;;;;;;;;;;;;

;; Set up package.el with MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (version< emacs-version "24.3")
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; PACKAGES
(defun ensure-package-installed (&rest packages)
    "Assure PACKAGES are installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
    (mapcar
     (lambda (package)
       ;; (package-installed-p 'evil)
       (if (package-installed-p package)
           nil
         (if (y-or-n-p (format "Package %s is missing.  Install it? " package))
             (package-install package)
           package)))
     packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Auto-install packages
(ensure-package-installed
 'lua-mode
 'dockerfile-mode
 'zenburn-theme
 'yaml-mode
 'markdown-mode
 'flycheck
 )

;; Version checks
(when (not (version< emacs-version "24.4"))
  (ensure-package-installed
   'systemd
   'magit
   ))

;; Re-initialize
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;
;; Version Control
;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x g") 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-log-done t)
(setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!)" )
                               (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "TESTING(T)" "|" "CANCELLED(c@/!)" ))))
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-agenda-files (quote ("~/org")))
(global-set-key "\C-ca" 'org-agenda)

;;;;;;;;;;;;;;;;;;;;;;
;; File formatting
;;;;;;;;;;;;;;;;;;;;;;

;; NO TABS
(setq-default indent-tabs-mode nil)
;; Change shell indentation to personal preference
(add-hook 'sh-mode-hook (lambda () (setq sh-basic-offset 2 sh-indentation 2)))

;;;;;;;;;;;;;;;;;;;;;;
;; Display
;;;;;;;;;;;;;;;;;;;;;;

;; NO BLINKING
;;; It's still posssible for the terminal to make it blink
(blink-cursor-mode (- (*) (*) (*)))
(setq visible-cursor nil)

;; Transform literal tabs into a right-pointing triangle
(setq
 whitespace-display-mappings ;http://ergoemacs.org/emacs/whitespace-mode.html
 '(
   (tab-mark 9 [9654 9] [92 9])
   ;others substitutions...
   ))
(setq require-final-newline t)

;; Zenburn theme by default
(load-theme 'zenburn t)

;; File mode magic
(add-to-list 'auto-mode-alist '("\\.service\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.mount\\'" . systemd-mode))
(add-to-list 'auto-mode-alist '("\\.socket\\'" . systemd-mode))

(add-hook 'after-init-hook #'global-flycheck-mode)

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

;;;;;;;;;;;;;;;;;;;;;;
;; System customizations
;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 ;;'(org-agenda-files (quote ("~/org/projects.org" "~/org/todo.org" "~/org/dates.org")))
 ;;'(org-archive-location ".%s_archive::"))
)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(provide '.emacs)

;;; .emacs ends here
