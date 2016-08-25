;; special setings
(put 'eval-expression 'disabled nil)
(set-input-mode nil nil 1)
(setq selection-coding-system 'compound-text-with-extensions)

;; no backup file ~
(setq make-backup-files nil)

;; use 2 spaces as tabs
(setq-default tab-width 2 indent-tabs-mode nil)
(setq perl-indent-level 2)
(setq sh-basic-offset 2)

;; nb column, nb lines
(setq column-number-mode t)
(setq line-number-mode t)

;; colors
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; set frame title with buffer file name
(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b"))

;; prevent cursor-down from adding lines.
(setq next-line-add-newlines nil)

;; Make sure there is no trailing whitespace in files
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Make sure there is a final newline character in files
(setq-default require-final-newline t)

;; scroll 1 line
(setq scroll-step 1)

;; delete selection with backspace
(delete-selection-mode t)

;; key bindings
(global-set-key "\C-cH" 'update-file-header)
(global-set-key "\C-c\C-h" 'std-file-header)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-cg" 'goto-line)
(global-set-key "\C-c\C-a" 'add-change-log-entry)
