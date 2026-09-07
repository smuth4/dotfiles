;;; -*- lexical-binding: t; -*-
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
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;; PACKAGES
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

;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(setq org-agenda-files (quote ("~/src/org/")))
(global-set-key "\C-ca" 'org-agenda)
(setq org-archive-location "archive.org::")

;;;;;;;;;;;;;;;;;;;;;;
;; System customizations
;;;;;;;;;;;;;;;;;;;;;;

;; Prevent dynamic changes from polluting in-repo files
(setq custom-file "~/.emacs.d/custom.el")
(load-file "~/.emacs.d/custom.el")

;;;;;;;;;;;;;;;;;;;;;;
;; Start moving stuff to org-babel
;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/lisp/")
;(setq package-enable-at-startup nil)
(unless (version< emacs-version "27.0")
  (org-babel-load-file "~/.emacs.d/emacs.org")
)

(provide '.emacs)
;;; .emacs ends here
(put 'downcase-region 'disabled nil)
