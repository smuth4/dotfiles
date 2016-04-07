;;; .emacs --- My emacs config file
;;; Commentary:

;; Not much special goes on here

(setq vc-follow-symlinks t)

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;
;; Misc
;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "<f7>") 'compile)

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
    "Assure PACKAGES are installed, ask for installation if it's not.
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

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)
    (package-initialize)))

(eval-and-compile
  (defvar use-package-verbose t)
  (require 'use-package))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Auto-install packages
(ensure-package-installed
 'zenburn-theme
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

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-agenda-files (quote ("~/org/")))
(global-set-key "\C-ca" 'org-agenda)
(setq org-archive-location "archive.org::")

;;;;;;;;;;;;;;;;;;;;;;
;; File formatting
;;;;;;;;;;;;;;;;;;;;;;

;; Change shell indentation to personal preference
(add-hook 'sh-mode-hook (lambda () (setq sh-basic-offset 2 sh-indentation 2)))

;;;;;;;;;;;;;;;;;;;;;;
;; Display
;;;;;;;;;;;;;;;;;;;;;;

;; Transform literal tabs into a right-pointing triangle
(setq
 whitespace-display-mappings ;http://ergoemacs.org/emacs/whitespace-mode.html
 '(
   (tab-mark 9 [9654 9] [92 9])
   ;others substitutions...
   ))

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

;;;;;;;;;;;;;;;;;;;;;;
;; Start moving stuff to org-babel
;;;;;;;;;;;;;;;;;;;;;;

;(setq package-enable-at-startup nil)
(org-babel-load-file "~/.emacs.d/emacs.org")

(provide '.emacs)
;;; .emacs ends here
